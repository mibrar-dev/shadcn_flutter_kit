// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'file_like.dart';

/// Type alias used for `UploadFn` callbacks or API signatures.
typedef UploadFn = Stream<double> Function(FileLike file);

/// Type alias used for `FileUploadPickFiles` callbacks or API signatures.
typedef FileUploadPickFiles =
    Future<List<FileLike>> Function(FileUploadPickRequest request);

/// FileUploadPickRequest represents a form-related type in the registry.
class FileUploadPickRequest {
  /// Constructs `FileUploadPickRequest` with the provided parameters.
  const FileUploadPickRequest({
    required this.allowMultiple,
    required this.withData,
    this.allowedExtensions,
    this.allowedMimeTypes,
  });

  /// Field storing `allowMultiple` for this form implementation.
  final bool allowMultiple;

  /// Field storing `withData` for this form implementation.
  final bool withData;

  /// Field storing `allowedExtensions` for this form implementation.
  final List<String>? allowedExtensions;

  /// Field storing `allowedMimeTypes` for this form implementation.
  final List<String>? allowedMimeTypes;
}

/// FileUploadState enumerates fixed values used by this implementation.
enum FileUploadState { idle, dragging, uploading, success, error, disabled }

/// FileUploadItemStatus enumerates fixed values used by this implementation.
enum FileUploadItemStatus { idle, uploading, success, error }

/// FileUploadItem represents a form-related type in the registry.
class FileUploadItem {
  /// Constructs `FileUploadItem` with the provided parameters.
  const FileUploadItem({
    required this.file,
    this.status = FileUploadItemStatus.idle,
    this.progress,
  });

  /// Field storing `file` for this form implementation.
  final FileLike file;

  /// Field storing `status` for this form implementation.
  final FileUploadItemStatus status;

  /// Field storing `progress` for this form implementation.
  final double? progress;

  /// Factory constructor for creating `FileUploadItem.fromFile` with derived values.
  factory FileUploadItem.fromFile(FileLike file) {
    return FileUploadItem(file: file);
  }

  /// Returns a copy with selected values overridden.
  FileUploadItem copyWith({FileUploadItemStatus? status, double? progress}) {
    return FileUploadItem(
      file: file,
      status: status ?? this.status,
      progress: progress,
    );
  }
}

/// FileUploadErrorCode enumerates fixed values used by this implementation.
enum FileUploadErrorCode { invalidType, tooLarge, tooMany, uploadFailed }

/// FileUploadError represents a form-related type in the registry.
class FileUploadError {
  const FileUploadError({required this.code, required this.message});

  /// Field storing `code` for this form implementation.
  final FileUploadErrorCode code;

  /// Field storing `message` for this form implementation.
  final String message;
}

/// FileValidationResult represents a form-related type in the registry.
class FileValidationResult {
  const FileValidationResult({required this.validFiles, required this.errors});

  /// Field storing `validFiles` for this form implementation.
  final List<FileLike> validFiles;

  /// Field storing `errors` for this form implementation.
  final List<FileUploadError> errors;
}
