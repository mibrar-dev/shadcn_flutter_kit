// File acceptance checks for the file components.
//
// Ported from the old `form/file_picker/_impl/utils/file_validation.dart`
// (`validateFiles`). Every rejection is reported through the caller's
// `onError` callback, so the wording stays localizable.

import 'file_value.dart';

/// Checks [incoming] against [constraints], counting [existing] towards the file
/// limit.
///
/// Every rejection goes through [onError], so the caller owns the wording and
/// the localization. The old `validateFiles` built its English messages inline,
/// which shipped the same English to every locale.
FileValidationResult validateFiles({
  required List<FileValue> incoming,
  required List<FileValue> existing,
  FileConstraints? constraints,
  required String Function(FileErrorCode code, FileValue? file) onError,
}) {
  final rules = constraints ?? const FileConstraints();
  final errors = <FileError>[];
  final accepted = <FileValue>[];
  final extensions = rules.normalizedExtensions;
  final mimeTypes = rules.normalizedMimeTypes;
  final prefixes = rules.mimeTypePrefixes;

  final limit = rules.allowMultiple ? rules.maxFiles : 1;
  var used = existing.length;
  var overflowReported = false;

  for (final file in incoming) {
    final overLimit = limit != null && used >= limit;
    if (overLimit) {
      // Report the overflow once per batch, then keep checking the remaining
      // files so one that is also too large or of the wrong type still says so.
      // The old code `break`ed on the first over-limit file, so the rest of the
      // drop vanished without a word.
      if (!overflowReported) {
        errors.add(
          FileError(
            code: FileErrorCode.tooMany,
            message: onError(FileErrorCode.tooMany, null),
          ),
        );
        overflowReported = true;
      }
    }
    if (_isRejected(
      file: file,
      rules: rules,
      extensions: extensions,
      mimeTypes: mimeTypes,
      prefixes: prefixes,
      errors: errors,
      onError: onError,
    )) {
      continue;
    }
    if (overLimit) {
      continue;
    }
    used += 1;
    accepted.add(file);
  }

  return FileValidationResult(accepted: accepted, errors: errors);
}

/// Runs the size, extension and MIME checks for one file, appending one error
/// per failed check; returns whether the file was rejected.
bool _isRejected({
  required FileValue file,
  required FileConstraints rules,
  required Set<String> extensions,
  required List<String> mimeTypes,
  required List<String> prefixes,
  required List<FileError> errors,
  required String Function(FileErrorCode code, FileValue? file) onError,
}) {
  var rejected = false;
  void reject(FileErrorCode code) {
    rejected = true;
    errors.add(FileError(code: code, message: onError(code, file), file: file));
  }

  final maxSize = rules.maxFileSizeBytes;
  if (maxSize != null && file.size > maxSize) {
    reject(FileErrorCode.tooLarge);
  }
  if (extensions.isNotEmpty && !extensions.contains(file.resolvedExtension)) {
    reject(FileErrorCode.invalidType);
  }
  if (mimeTypes.isNotEmpty || prefixes.isNotEmpty) {
    final mime = file.mimeType?.toLowerCase();
    final matches =
        mime != null &&
        (mimeTypes.contains(mime) || prefixes.any(mime.startsWith));
    if (!matches) {
      reject(FileErrorCode.invalidType);
    }
  }
  return rejected;
}
