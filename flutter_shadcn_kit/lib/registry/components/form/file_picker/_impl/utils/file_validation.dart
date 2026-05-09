// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'file_like.dart';
import 'file_upload_models.dart';

FileValidationResult validateFiles({
  required List<FileLike> incoming,
  required List<FileLike> existing,
  int? maxFiles,
  int? maxFileSizeBytes,
  List<String>? allowedExtensions,
  List<String>? allowedMimeTypes,
}) {
  final errors = <FileUploadError>[];
  final validFiles = <FileLike>[];
  final normalizedExtensions = allowedExtensions
      ?.map((ext) => ext.toLowerCase().replaceFirst('.', ''))
      .where((ext) => ext.isNotEmpty)
      .toSet();
  final normalizedMimeTypes = allowedMimeTypes
      ?.map((type) => type.toLowerCase())
      .where((type) => type.isNotEmpty)
      .toList();

  final remainingSlots = maxFiles == null
      ? null
      : (maxFiles - existing.length).clamp(0, maxFiles);

  for (final file in incoming) {
    if (remainingSlots != null && validFiles.length >= remainingSlots) {
      errors.add(
        const FileUploadError(
          code: FileUploadErrorCode.tooMany,
          message: 'Too many files selected.',
        ),
      );
      break;
    }

    if (maxFileSizeBytes != null && file.size > maxFileSizeBytes) {
      errors.add(
        FileUploadError(
          code: FileUploadErrorCode.tooLarge,
          message: '${file.name} exceeds the maximum file size.',
        ),
      );
      continue;
    }

    if (normalizedExtensions != null && normalizedExtensions.isNotEmpty) {
      final ext = file.resolvedExtension;
      if (ext.isEmpty || !normalizedExtensions.contains(ext)) {
        errors.add(
          FileUploadError(
            code: FileUploadErrorCode.invalidType,
            message: '${file.name} has an unsupported file type.',
          ),
        );
        continue;
      }
    }

    if (normalizedMimeTypes != null && normalizedMimeTypes.isNotEmpty) {
      final mime = file.mimeType?.toLowerCase();
      if (mime == null || mime.isEmpty) {
        errors.add(
          FileUploadError(
            code: FileUploadErrorCode.invalidType,
            message: '${file.name} has an unsupported file type.',
          ),
        );
        continue;
      }
      final matches = normalizedMimeTypes.any((allowed) {
        if (allowed.endsWith('/*')) {
          final prefix = allowed.substring(0, allowed.length - 1);
          return mime.startsWith(prefix);
        }
        return mime == allowed;
      });
      if (!matches) {
        errors.add(
          FileUploadError(
            code: FileUploadErrorCode.invalidType,
            message: '${file.name} has an unsupported file type.',
          ),
        );
        continue;
      }
    }

    validFiles.add(file);
  }

  return FileValidationResult(validFiles: validFiles, errors: errors);
}
