// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'dart:async';
import 'dart:collection';

import 'package:flutter/foundation.dart';

import 'file_like.dart';
import 'file_upload_models.dart';
import 'file_validation.dart';

/// FileUploadController coordinates state and interactions for this form component.
class FileUploadController extends ChangeNotifier
    implements FileUploadControllerBase {
  FileUploadController({
    List<FileUploadItem>? initialItems,
    this.allowMultiple = true,
    this.maxFiles,
    this.maxFileSizeBytes,
    this.allowedExtensions,
    this.allowedMimeTypes,
  }) : _items = List<FileUploadItem>.from(initialItems ?? const []);

  final bool allowMultiple;
  final int? maxFiles;
  final int? maxFileSizeBytes;
  final List<String>? allowedExtensions;
  final List<String>? allowedMimeTypes;

  final List<FileUploadError> _errors = [];
  final Map<String, StreamSubscription<double>> _uploads = {};
  final ListQueue<FileLike> _uploadQueue = ListQueue<FileLike>();
  List<FileUploadItem> _items;
  int _activeUploads = 0;
  UploadFn? _uploadFn;
  int _maxConcurrentUploads = 1;

  @override
  List<FileUploadItem> get items => List.unmodifiable(_items);

  @override
  List<FileUploadError> get errors => List.unmodifiable(_errors);

  @override
  bool get isUploading =>
      _items.any((item) => item.status == FileUploadItemStatus.uploading);

  @override
  bool get hasItems => _items.isNotEmpty;

  /// Performs `setItems` logic for this form component.
  @override
  void setItems(List<FileUploadItem> items) {
    _items = List<FileUploadItem>.from(items);
    notifyListeners();
  }

  /// Performs `clear` logic for this form component.
  @override
  void clear() {
    _clearUploads();
    _items = [];
    _errors.clear();
    notifyListeners();
  }

  /// Performs `addFiles` logic for this form component.
  @override
  void addFiles(List<FileLike> files) {
    final effectiveMaxFiles = allowMultiple ? maxFiles : (maxFiles ?? 1);
    final validation = validateFiles(
      incoming: files,
      existing: _items.map((item) => item.file).toList(),
      maxFiles: effectiveMaxFiles,
      maxFileSizeBytes: maxFileSizeBytes,
      allowedExtensions: allowedExtensions,
      allowedMimeTypes: allowedMimeTypes,
    );

    _errors
      ..clear()
      ..addAll(validation.errors);

    if (validation.validFiles.isEmpty) {
      notifyListeners();
      return;
    }

    _items.addAll(validation.validFiles.map(FileUploadItem.fromFile));
    notifyListeners();
  }

  /// Performs `removeFile` logic for this form component.
  @override
  void removeFile(FileLike file) {
    _cancelUploadFor(file.id);
    _items.removeWhere((item) => item.file.id == file.id);
    notifyListeners();
  }

  @override
  void updateItem(
    FileLike file,
    FileUploadItemStatus status,
    double? progress,
  ) {
    final index = _items.indexWhere((item) => item.file.id == file.id);
    if (index == -1) return;
    _items[index] = _items[index].copyWith(status: status, progress: progress);
    notifyListeners();
  }

  /// Performs `startUploads` logic for this form component.
  @override
  void startUploads(UploadFn uploadFn, {int maxConcurrent = 1}) {
    _uploadFn = uploadFn;
    _maxConcurrentUploads = maxConcurrent < 1 ? 1 : maxConcurrent;
    for (final item in _items) {
      if (item.status == FileUploadItemStatus.success) continue;
      final alreadyQueued = _uploadQueue.any(
        (entry) => entry.id == item.file.id,
      );
      final alreadyUploading = _uploads.containsKey(item.file.id);
      if (alreadyQueued || alreadyUploading) continue;
      updateItem(item.file, FileUploadItemStatus.idle, null);
      _uploadQueue.addLast(item.file);
    }
    _pumpUploadQueue();
  }

  /// Performs `_pumpUploadQueue` logic for this form component.
  void _pumpUploadQueue() {
    final uploadFn = _uploadFn;
    if (uploadFn == null) return;
    while (_activeUploads < _maxConcurrentUploads && _uploadQueue.isNotEmpty) {
      final file = _uploadQueue.removeFirst();
      _startUpload(file, uploadFn);
    }
  }

  /// Performs `_startUpload` logic for this form component.
  void _startUpload(FileLike file, UploadFn uploadFn) {
    _activeUploads += 1;
    _uploads[file.id]?.cancel();
    updateItem(file, FileUploadItemStatus.uploading, 0);
    _uploads[file.id] = uploadFn(file).listen(
      (progress) {
        final clamped = progress.clamp(0, 1).toDouble();
        updateItem(file, FileUploadItemStatus.uploading, clamped);
      },
      onError: (_) {
        updateItem(file, FileUploadItemStatus.error, null);
        _completeUpload(file.id);
      },
      onDone: () {
        updateItem(file, FileUploadItemStatus.success, 1);
        _completeUpload(file.id);
      },
    );
  }

  /// Performs `_completeUpload` logic for this form component.
  void _completeUpload(String fileId) {
    final sub = _uploads.remove(fileId);
    sub?.cancel();
    if (_activeUploads > 0) {
      _activeUploads -= 1;
    }
    _pumpUploadQueue();
  }

  /// Performs `_cancelUploadFor` logic for this form component.
  void _cancelUploadFor(String fileId) {
    _uploadQueue.removeWhere((entry) => entry.id == fileId);
    final sub = _uploads.remove(fileId);
    if (sub != null) {
      sub.cancel();
      if (_activeUploads > 0) {
        _activeUploads -= 1;
      }
    }
  }

  /// Performs `_clearUploads` logic for this form component.
  void _clearUploads() {
    _uploadQueue.clear();
    _activeUploads = 0;
    for (final sub in _uploads.values) {
      sub.cancel();
    }
    _uploads.clear();
  }

  /// Releases resources owned by this state object.
  @override
  void dispose() {
    _clearUploads();
    super.dispose();
  }
}

/// FileUploadControllerBase coordinates state and interactions for this form component.
abstract class FileUploadControllerBase {
  /// Field storing `items` for this form implementation.
  List<FileUploadItem> get items;

  /// Field storing `errors` for this form implementation.
  List<FileUploadError> get errors;

  /// Flag indicating whether `isUploading` is enabled/active.
  bool get isUploading;

  /// Flag indicating whether `hasItems` is enabled/active.
  bool get hasItems;
  void setItems(List<FileUploadItem> items);
  void clear();
  void addFiles(List<FileLike> files);
  void removeFile(FileLike file);
  void updateItem(FileLike file, FileUploadItemStatus status, double? progress);
  void startUploads(UploadFn uploadFn, {int maxConcurrent = 1});
}
