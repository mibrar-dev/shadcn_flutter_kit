import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_shadcn_kit/registry_next/primitives/file_value/file_validation.dart';
import 'package:flutter_shadcn_kit/registry_next/primitives/file_value/file_value.dart';

/// Behavioural notes for the fixed validation:
/// * [validateFiles] takes its wording from the caller's `onError` callback, so
///   the English messages the old `validateFiles` built inline are gone;
/// * an over-limit batch reports the overflow once and keeps checking the rest
///   of the files; the old code `break`ed on the first over-limit file, so the
///   remainder of a drop vanished without a word.
const FileValue png = FileValue(
  id: 'a',
  name: 'photo.png',
  size: 2048,
  mimeType: 'image/png',
);
const FileValue jpeg = FileValue(id: 'b', name: 'photo.jpg', size: 10);
const FileValue pdf = FileValue(id: 'c', name: 'report.pdf', size: 10);
const FileValue bigPng = FileValue(id: 'd', name: 'huge.png', size: 5000);

String message(FileErrorCode code, FileValue? file) =>
    '${code.name}${file == null ? '' : ':${file.name}'}';

void main() {
  group('validateFiles', () {
    test('accepts everything when no constraint is set', () {
      final result = validateFiles(
        incoming: const <FileValue>[png, pdf],
        existing: const <FileValue>[],
        onError: message,
      );
      expect(result.accepted, const <FileValue>[png, pdf]);
      expect(result.hasErrors, isFalse);
    });

    test('rejects files over the size limit and keeps the rest', () {
      final result = validateFiles(
        incoming: const <FileValue>[png, bigPng],
        existing: const <FileValue>[],
        constraints: const FileConstraints(maxFileSizeBytes: 4096),
        onError: message,
      );
      expect(result.accepted, const <FileValue>[png]);
      expect(result.errors, hasLength(1));
      expect(result.errors.single.code, FileErrorCode.tooLarge);
      expect(result.errors.single.file, bigPng);
      expect(result.errors.single.message, 'tooLarge:huge.png');
    });

    test('rejects a disallowed extension', () {
      final result = validateFiles(
        incoming: const <FileValue>[png, pdf],
        existing: const <FileValue>[],
        constraints: const FileConstraints(allowedExtensions: <String>['.png']),
        onError: message,
      );
      expect(result.accepted, const <FileValue>[png]);
      expect(result.errors.single.code, FileErrorCode.invalidType);
      expect(result.errors.single.message, 'invalidType:report.pdf');
    });

    test('a file with no extension fails an extension allow-list', () {
      const bare = FileValue(id: 'l', name: 'README', size: 1);
      final result = validateFiles(
        incoming: const <FileValue>[bare],
        existing: const <FileValue>[],
        constraints: const FileConstraints(allowedExtensions: <String>['png']),
        onError: message,
      );
      expect(result.accepted, isEmpty);
      expect(result.errors.single.code, FileErrorCode.invalidType);
    });

    test('honours exact mime types and wildcards', () {
      const wildcard = FileConstraints(allowedMimeTypes: <String>['image/*']);
      expect(
        validateFiles(
          incoming: const <FileValue>[png],
          existing: const <FileValue>[],
          constraints: wildcard,
          onError: message,
        ).accepted,
        const <FileValue>[png],
      );

      const exact = FileConstraints(allowedMimeTypes: <String>['image/png']);
      expect(
        validateFiles(
          incoming: const <FileValue>[jpeg],
          existing: const <FileValue>[],
          constraints: exact,
          onError: message,
        ).errors.single.code,
        FileErrorCode.invalidType,
      );

      expect(
        validateFiles(
          incoming: const <FileValue>[jpeg],
          existing: const <FileValue>[],
          constraints: exact,
          onError: message,
        ).errors.single.file,
        jpeg,
      );
    });

    test('a missing mime type fails a mime allow-list', () {
      final result = validateFiles(
        incoming: const <FileValue>[pdf],
        existing: const <FileValue>[],
        constraints: const FileConstraints(
          allowedMimeTypes: <String>['image/*'],
        ),
        onError: message,
      );
      expect(result.accepted, isEmpty);
      expect(result.errors.single.code, FileErrorCode.invalidType);
    });

    test('allowMultiple false caps the selection at one', () {
      final result = validateFiles(
        incoming: const <FileValue>[png, pdf],
        existing: const <FileValue>[],
        constraints: const FileConstraints(allowMultiple: false),
        onError: message,
      );
      expect(result.accepted, const <FileValue>[png]);
      expect(result.errors.single.code, FileErrorCode.tooMany);
      // The overflow error is not attached to a file.
      expect(result.errors.single.file, isNull);
    });

    test('maxFiles counts the existing selection', () {
      final result = validateFiles(
        incoming: const <FileValue>[png, pdf],
        existing: const <FileValue>[jpeg],
        constraints: const FileConstraints(maxFiles: 2),
        onError: message,
      );
      expect(result.accepted, const <FileValue>[png]);
      expect(result.errors.single.code, FileErrorCode.tooMany);
    });

    test('the overflow is reported once and the rest is still checked', () {
      // Old code broke out of the loop on the first over-limit file, so the
      // remaining files disappeared without a word. Here `pdf` only trips the
      // count limit while `bigPng` still reports its size.
      final result = validateFiles(
        incoming: const <FileValue>[png, pdf, bigPng],
        existing: const <FileValue>[],
        constraints: const FileConstraints(maxFiles: 1, maxFileSizeBytes: 4096),
        onError: message,
      );
      expect(result.accepted, const <FileValue>[png]);
      expect(result.errors.map((error) => error.code), <FileErrorCode>[
        FileErrorCode.tooMany,
        FileErrorCode.tooLarge,
      ]);
      expect(result.errors.last.file, bigPng);
    });

    test('a file can trip several checks at once', () {
      const hugeBadType = FileValue(id: 'm', name: 'huge.txt', size: 9000);
      final result = validateFiles(
        incoming: const <FileValue>[hugeBadType],
        existing: const <FileValue>[],
        constraints: const FileConstraints(
          maxFileSizeBytes: 4096,
          allowedExtensions: <String>['png'],
        ),
        onError: message,
      );
      expect(result.accepted, isEmpty);
      expect(result.errors.map((error) => error.code), <FileErrorCode>[
        FileErrorCode.tooLarge,
        FileErrorCode.invalidType,
      ]);
    });

    test('toString names the counts', () {
      final result = validateFiles(
        incoming: const <FileValue>[png],
        existing: const <FileValue>[],
        onError: message,
      );
      expect(result.toString(), contains('accepted: 1'));
    });
  });
}
