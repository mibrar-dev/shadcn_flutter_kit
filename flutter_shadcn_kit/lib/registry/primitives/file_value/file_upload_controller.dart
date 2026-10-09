// Upload queue machinery for the file components.
//
// Ported from `form/file_picker/_impl/utils/file_upload_controller.dart` and
// the queue/concurrency half of `_impl/state/file_upload_state_uploads.dart`.
// UI-free on purpose: the `file_picker` component drives it and renders its
// items. It lives in the `file_value` primitive (P4-B22, Q7) because the
// component folder may hold only three Dart files and the engine does not fit.

import 'dart:async';
import 'dart:collection';

import 'package:flutter/foundation.dart';

import 'file_validation.dart';
import 'file_value.dart';

/// Starts one upload; the stream reports progress in `[0, 1]`, completing the
/// stream means success and an error event means failure.
typedef FileUploadFn = Stream<double> Function(FileValue file);

/// Builds the user-facing message for a rejection.
///
/// The component passes `ShadcnLocalizations` wording; the default is the
/// English fallback (no translated ARB equivalent exists for these strings).
typedef FileUploadMessage =
    String Function(FileErrorCode code, FileValue? file);

/// Coordinates the file list, validation, the upload queue and concurrency.
///
/// One queue drives every file: [addFiles] validates, [startUploads] queues
/// the non-success items up to `maxConcurrent`, and [retry] puts one failed
/// file back in line. [removeFile] cancels a queued or active upload.
class FileUploadController extends ChangeNotifier {
  /// Creates a controller, optionally with [initialItems] already listed.
  FileUploadController({
    List<FileItem>? initialItems,
    this.constraints = const FileConstraints(),
    FileUploadMessage? message,
  }) : _items = List<FileItem>.from(initialItems ?? const <FileItem>[]),
       _message = message ?? _englishMessage;

  /// Acceptance constraints; [addFiles] enforces them unless the caller passes
  /// a one-off override.
  final FileConstraints constraints;

  final FileUploadMessage _message;
  final List<FileError> _errors = <FileError>[];
  final Map<String, StreamSubscription<double>> _uploads =
      <String, StreamSubscription<double>>{};
  final ListQueue<FileValue> _queue = ListQueue<FileValue>();
  List<FileItem> _items;
  FileUploadFn? _upload;
  int _maxConcurrent = 1;
  int _active = 0;
  bool _completionReported = false;
  ValueChanged<FileError>? _onError;
  void Function(FileValue file, double progress)? _onProgress;
  VoidCallback? _onUploadStart;
  ValueChanged<List<FileValue>>? _onComplete;

  /// The current rows, in insertion order.
  List<FileItem> get items => List<FileItem>.unmodifiable(_items);

  /// Rejections from the last [addFiles] call plus upload failures.
  List<FileError> get errors => List<FileError>.unmodifiable(_errors);

  /// Whether any row is mid-transfer.
  bool get isUploading =>
      _items.any((FileItem item) => item.status == FileStatus.uploading);

  /// Whether the list has any rows.
  bool get hasItems => _items.isNotEmpty;

  /// Replaces every row; ongoing uploads are cancelled.
  void setItems(List<FileItem> items) {
    _clearUploads();
    _items = List<FileItem>.from(items);
    _completionReported = false;
    notifyListeners();
  }

  /// Empties the list, the errors and every upload.
  void clear() {
    _clearUploads();
    _items = <FileItem>[];
    _errors.clear();
    _completionReported = false;
    notifyListeners();
  }

  /// Validates [files] against [constraints] (or [overrideConstraints]),
  /// appends the accepted rows, replaces the validation errors and returns the
  /// added files.
  ///
  /// The old widget validated *and* the controller validated, so two different
  /// constraint sets could disagree; this is the only validation site now.
  List<FileValue> addFiles(
    List<FileValue> files, {
    FileConstraints? overrideConstraints,
  }) {
    final Set<String> before = _items
        .map((FileItem item) => item.file.id)
        .toSet();
    final FileValidationResult result = validateFiles(
      incoming: files,
      existing: _items.map((FileItem item) => item.file).toList(),
      constraints: overrideConstraints ?? constraints,
      onError: _message,
    );
    _errors
      ..clear()
      ..addAll(result.errors);
    if (result.accepted.isNotEmpty) {
      _items.addAll(
        result.accepted.map((FileValue file) => FileItem(file: file)),
      );
      _completionReported = false;
    }
    notifyListeners();
    return _items
        .where((FileItem item) => !before.contains(item.file.id))
        .map((FileItem item) => item.file)
        .toList(growable: false);
  }

  /// Removes [file], cancelling a queued or active upload.
  void removeFile(FileValue file) {
    _cancel(file.id);
    _items.removeWhere((FileItem item) => item.file.id == file.id);
    _completionReported = false;
    notifyListeners();
  }

  /// Appends [error] to [errors] and notifies (used for picker failures that
  /// produce no file row).
  void reportError(FileError error) {
    _errors.add(error);
    notifyListeners();
  }

  /// Replaces the row for [file] with a new status/progress.
  ///
  /// A null [progress] clears the bar; a non-null one keeps it. The old
  /// `FileUploadItem.copyWith` cleared progress on *every* call, so a status
  /// change silently reset a running bar.
  void updateItem(FileValue file, FileStatus status, double? progress) {
    final int index = _items.indexWhere(
      (FileItem item) => item.file.id == file.id,
    );
    if (index == -1) {
      return;
    }
    _items[index] = _items[index].copyWith(
      status: status,
      progress: progress,
      resetProgress: progress == null,
    );
    notifyListeners();
  }

  /// Starts (or restarts) uploads with [upload].
  ///
  /// [files] limits the batch; null queues every non-success row. Rows already
  /// queued or uploading are skipped, so calling this twice never double-starts
  /// an upload. The callbacks are stored for [retry].
  void startUploads(
    FileUploadFn upload, {
    List<FileValue>? files,
    int maxConcurrent = 1,
    void Function(FileValue file, double progress)? onProgress,
    VoidCallback? onUploadStart,
    ValueChanged<List<FileValue>>? onComplete,
    ValueChanged<FileError>? onError,
  }) {
    _upload = upload;
    _maxConcurrent = maxConcurrent < 1 ? 1 : maxConcurrent;
    _onProgress = onProgress;
    _onUploadStart = onUploadStart;
    _onComplete = onComplete;
    _onError = onError;
    final List<FileValue> candidates =
        files ?? _items.map((FileItem item) => item.file).toList();
    var enqueued = 0;
    for (final FileValue file in candidates) {
      final int index = _items.indexWhere(
        (FileItem item) => item.file.id == file.id,
      );
      if (index == -1 || _items[index].status == FileStatus.success) {
        continue;
      }
      if (_queue.any((FileValue entry) => entry.id == file.id) ||
          _uploads.containsKey(file.id)) {
        continue;
      }
      _items[index] = _items[index].copyWith(
        status: FileStatus.queued,
        resetProgress: true,
      );
      _queue.addLast(file);
      enqueued += 1;
    }
    if (enqueued > 0) {
      _onUploadStart?.call();
    }
    _pump();
    notifyListeners();
  }

  /// Re-queues one failed [file] with the function and callbacks of the last
  /// [startUploads] call; does nothing before one.
  void retry(FileValue file) {
    if (_upload == null) {
      return;
    }
    final int index = _items.indexWhere(
      (FileItem item) => item.file.id == file.id,
    );
    if (index == -1) {
      return;
    }
    _errors.removeWhere(
      (FileError error) =>
          error.file?.id == file.id && error.code == FileErrorCode.uploadFailed,
    );
    _items[index] = _items[index].copyWith(
      status: FileStatus.queued,
      resetProgress: true,
    );
    if (!_queue.any((FileValue entry) => entry.id == file.id) &&
        !_uploads.containsKey(file.id)) {
      _queue.addLast(file);
    }
    _completionReported = false;
    _pump();
    notifyListeners();
  }

  void _pump() {
    final FileUploadFn? upload = _upload;
    if (upload == null) {
      return;
    }
    while (_active < _maxConcurrent && _queue.isNotEmpty) {
      _start(_queue.removeFirst(), upload);
    }
  }

  void _start(FileValue file, FileUploadFn upload) {
    _active += 1;
    _uploads[file.id]?.cancel();
    updateItem(file, FileStatus.uploading, 0);
    _uploads[file.id] = upload(file).listen(
      (double progress) {
        final double clamped = progress.clamp(0.0, 1.0);
        updateItem(file, FileStatus.uploading, clamped);
        _onProgress?.call(file, clamped);
      },
      onError: (Object error) {
        _uploads.remove(file.id)?.cancel();
        if (_active > 0) {
          _active -= 1;
        }
        final FileError failure = FileError(
          code: FileErrorCode.uploadFailed,
          message: _message(FileErrorCode.uploadFailed, file),
          file: file,
        );
        _errors.add(failure);
        updateItem(file, FileStatus.error, null);
        _onError?.call(failure);
        _pump();
        _checkCompletion();
      },
      onDone: () {
        _uploads.remove(file.id)?.cancel();
        if (_active > 0) {
          _active -= 1;
        }
        _errors.removeWhere(
          (FileError error) =>
              error.file?.id == file.id &&
              error.code == FileErrorCode.uploadFailed,
        );
        updateItem(file, FileStatus.success, 1);
        _pump();
        _checkCompletion();
      },
    );
  }

  void _cancel(String fileId) {
    _queue.removeWhere((FileValue file) => file.id == fileId);
    final StreamSubscription<double>? subscription = _uploads.remove(fileId);
    if (subscription != null) {
      subscription.cancel();
      if (_active > 0) {
        _active -= 1;
      }
      _pump();
    }
  }

  void _clearUploads() {
    _queue.clear();
    _active = 0;
    for (final StreamSubscription<double> subscription in _uploads.values) {
      subscription.cancel();
    }
    _uploads.clear();
  }

  /// Reports completion once per settled batch: every row succeeded and no
  /// rejection is left. A validation rejection keeps the batch incomplete, as
  /// in the old component.
  void _checkCompletion() {
    if (_queue.isNotEmpty || _active > 0 || _completionReported) {
      return;
    }
    if (_items.isEmpty || _errors.isNotEmpty) {
      return;
    }
    if (_items.any((FileItem item) => item.status != FileStatus.success)) {
      return;
    }
    _completionReported = true;
    _onComplete?.call(
      _items.map((FileItem item) => item.file).toList(growable: false),
    );
  }

  @override
  void dispose() {
    _clearUploads();
    super.dispose();
  }

  /// English fallback used when the caller passes no [FileUploadMessage].
  static String _englishMessage(FileErrorCode code, FileValue? file) {
    switch (code) {
      case FileErrorCode.tooMany:
        return 'Too many files selected.';
      case FileErrorCode.tooLarge:
        return 'File is too large.';
      case FileErrorCode.invalidType:
        return 'File type is not allowed.';
      case FileErrorCode.uploadFailed:
        return file == null
            ? 'Upload failed.'
            : 'Upload failed for ${file.name}.';
    }
  }
}
