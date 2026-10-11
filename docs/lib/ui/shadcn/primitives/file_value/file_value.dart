// File upload value types shared by the file components.
//
// Ported from the old `form/file_picker` tree: `_impl/utils/file_like.dart`
// (`FileLike`), `_impl/utils/file_upload_models.dart` (status/item/error
// enums) and `_impl/core/file_upload_options.dart` (the constraint snapshot).
// The checks live in `file_validation.dart`, the presentation data and the
// byte-size formatter in `file_format.dart`.
//
// Platform file *picking* is not here: the `file_picker` component owns that
// and abstracts it behind `foundation/platform.dart`; no third-party file or
// web package may reach layer 2 (P4-PRIM-6).

import 'dart:typed_data';

/// One selected file, as the registry models it.
///
/// A platform-neutral value type: the picker component converts whatever the
/// platform hands it into this, and every downstream widget reads only this
/// shape.
class FileValue {
  /// Creates a file value.
  const FileValue({
    required this.id,
    required this.name,
    required this.size,
    this.bytes,
    this.path,
    this.mimeType,
    this.extension,
    this.source,
  });

  /// Stable identity of this file inside a selection (upload state, form value).
  final String id;

  /// File name including the extension, as shown to the user.
  final String name;

  /// Size in bytes.
  final int size;

  /// File contents, when the picker was asked to read them.
  final Uint8List? bytes;

  /// Platform path, where one exists (null on the web).
  final String? path;

  /// MIME type, when known.
  final String? mimeType;

  /// Extension without the dot; derived from [name] when null.
  final String? extension;

  /// The platform object this came from, for callers that need it.
  ///
  /// Deliberately `Object?` so layer 2 never names a platform type.
  final Object? source;

  /// Lower-cased extension without the dot; empty when there is none.
  ///
  /// The old `resolvedExtension` used `name.split('.')`, so a name of
  /// `.gitignore` reported `gitignore` as its extension. A leading dot now
  /// yields empty, as does a trailing one.
  String get resolvedExtension {
    final explicit = extension;
    if (explicit != null && explicit.isNotEmpty) {
      final normalized = explicit.toLowerCase();
      return normalized.startsWith('.') ? normalized.substring(1) : normalized;
    }
    final dot = name.lastIndexOf('.');
    if (dot <= 0 || dot == name.length - 1) {
      return '';
    }
    return name.substring(dot + 1).toLowerCase();
  }

  /// Whether the file looks like an image: its MIME type says so, or its
  /// extension is one the platforms decode natively.
  bool get isImage {
    final type = mimeType?.toLowerCase();
    if (type != null && type.startsWith('image/')) {
      return true;
    }
    return imageFileExtensions.contains(resolvedExtension);
  }

  /// Extensions treated as images when no MIME type is available.
  static const Set<String> imageFileExtensions = <String>{
    'png',
    'jpg',
    'jpeg',
    'gif',
    'webp',
    'bmp',
    'svg',
    'heic',
  };

  @override
  String toString() => 'FileValue($name, $size bytes)';
}

/// What a picked file is doing right now.
enum FileStatus {
  /// Picked, not uploaded yet.
  queued,

  /// Being uploaded; [FileItem.progress] is between 0 and 1.
  uploading,

  /// Upload finished.
  success,

  /// Upload failed and may be retried.
  error;

  /// Whether the file is mid-transfer.
  bool get isBusy => this == FileStatus.uploading;

  /// Whether the file reached a final state.
  bool get isSettled => this == FileStatus.success || this == FileStatus.error;
}

/// One row of an upload list: a file plus its transfer state.
class FileItem {
  /// Creates an upload item.
  const FileItem({
    required this.file,
    this.status = FileStatus.queued,
    this.progress,
  });

  /// The file this row tracks.
  final FileValue file;

  /// Transfer state.
  final FileStatus status;

  /// Upload progress in `[0, 1]`; null when unknown or not uploading.
  final double? progress;

  /// A copy with the given fields replaced.
  ///
  /// Pass `resetProgress: true` to clear [progress]. The old
  /// `FileUploadItem.copyWith` dropped progress on *every* call, so a progress
  /// tick followed by a status change silently reset the bar.
  FileItem copyWith({
    FileStatus? status,
    double? progress,
    bool resetProgress = false,
  }) {
    return FileItem(
      file: file,
      status: status ?? this.status,
      progress: resetProgress ? null : (progress ?? this.progress),
    );
  }

  @override
  String toString() => 'FileItem(${file.name}, $status)';
}

/// Why a file was rejected.
enum FileErrorCode {
  /// The extension or MIME type is not allowed.
  invalidType,

  /// The file is bigger than the configured limit.
  tooLarge,

  /// Adding it would exceed the configured file count.
  tooMany,

  /// The upload itself failed.
  uploadFailed,
}

/// One rejection produced by [validateFiles] or by the upload controller.
class FileError {
  /// Creates an error.
  const FileError({required this.code, required this.message, this.file});

  /// Why the file was rejected.
  final FileErrorCode code;

  /// User-facing message. Components build this from `ShadcnLocalizations`; the
  /// validation helper takes it as a parameter so it never hard-codes English.
  final String message;

  /// The rejected file, when the error is about a single file.
  final FileValue? file;

  @override
  String toString() =>
      'FileError(${code.name}, $message${file == null ? '' : ', ${file!.name}'})';
}

/// Outcome of [validateFiles].
class FileValidationResult {
  /// Creates a result.
  const FileValidationResult({required this.accepted, required this.errors});

  /// Files that passed every check, in input order.
  final List<FileValue> accepted;

  /// One error per rejection.
  final List<FileError> errors;

  /// Whether anything was rejected.
  bool get hasErrors => errors.isNotEmpty;

  @override
  String toString() =>
      'FileValidationResult(accepted: ${accepted.length}, errors: $errors)';
}

/// The acceptance constraints a file component enforces.
///
/// The old `FileUploadHelpfulInfoData` duplicated exactly these five fields so
/// the help text and the validation could not drift; one type serves both.
class FileConstraints {
  /// Creates a constraint set. Every field is optional; null means "no limit".
  const FileConstraints({
    this.allowMultiple = true,
    this.maxFiles,
    this.maxFileSizeBytes,
    this.allowedExtensions,
    this.allowedMimeTypes,
  });

  /// Whether more than one file may be selected.
  final bool allowMultiple;

  /// Maximum number of files in the whole selection.
  final int? maxFiles;

  /// Maximum size of a single file, in bytes.
  final int? maxFileSizeBytes;

  /// Allowed extensions, with or without a leading dot; case-insensitive.
  final List<String>? allowedExtensions;

  /// Allowed MIME types; `image/*`-style wildcards are honoured.
  final List<String>? allowedMimeTypes;

  /// Extensions normalised to lower case without the dot.
  Set<String> get normalizedExtensions =>
      (allowedExtensions ?? const <String>[])
          .map((extension) => extension.toLowerCase().replaceFirst('.', ''))
          .where((extension) => extension.isNotEmpty)
          .toSet();

  /// MIME types normalised to lower case, wildcards excluded.
  List<String> get normalizedMimeTypes => (allowedMimeTypes ?? const <String>[])
      .map((type) => type.toLowerCase())
      .where((type) => type.isNotEmpty && !type.endsWith('/*'))
      .toList();

  /// MIME type prefixes such as `image/`, lower case.
  List<String> get mimeTypePrefixes => (allowedMimeTypes ?? const <String>[])
      .map((type) => type.toLowerCase())
      .where((type) => type.endsWith('/*'))
      .map((type) => type.substring(0, type.length - 1))
      .toList();

  /// Whether no limit and no type filter is configured, so a component can skip
  /// rendering the constraints help line.
  bool get isUnbounded =>
      !allowMultiple ||
      (maxFiles == null &&
          maxFileSizeBytes == null &&
          (allowedExtensions?.isEmpty ?? true) &&
          (allowedMimeTypes?.isEmpty ?? true));
}
