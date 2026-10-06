import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_shadcn_kit/registry_next/primitives/file_value/file_value.dart';

/// Behavioural notes for the fixed model types:
/// * [FileValue.resolvedExtension] no longer treats a leading dot (`.gitignore`)
///   as an extension, where the old `FileLike.resolvedExtension` returned
///   `gitignore` through `name.split('.')`;
/// * [FileItem.copyWith] keeps progress on a status-only change; the old
///   `FileUploadItem.copyWith` passed `progress: progress` unconditionally and
///   dropped it on every call, so a progress tick followed by a status change
///   silently reset the bar.
///
/// The checks live in `file_validation_test.dart`, the presentation data and the
/// byte-size formatter in `file_format_test.dart`.
const FileValue png = FileValue(
  id: 'a',
  name: 'photo.png',
  size: 2048,
  mimeType: 'image/png',
);
const FileValue jpeg = FileValue(id: 'b', name: 'photo.jpg', size: 10);
const FileValue pdf = FileValue(id: 'c', name: 'report.pdf', size: 10);

void main() {
  group('FileValue', () {
    test('derives the extension from the name', () {
      expect(png.resolvedExtension, 'png');
      expect(pdf.resolvedExtension, 'pdf');
      expect(png.toString(), 'FileValue(photo.png, 2048 bytes)');
    });

    test('a leading dot is not an extension', () {
      // Old behaviour: `'.gitignore'.split('.')` gave `['gitignore']`, so the
      // resolved extension was `gitignore`.
      const dotfile = FileValue(id: 'e', name: '.gitignore', size: 1);
      expect(dotfile.resolvedExtension, '');
      const trailing = FileValue(id: 'f', name: 'name.', size: 1);
      expect(trailing.resolvedExtension, '');
      const bare = FileValue(id: 'g', name: 'README', size: 1);
      expect(bare.resolvedExtension, '');
    });

    test('an explicit extension wins and is lower-cased', () {
      const file = FileValue(
        id: 'h',
        name: 'weird',
        size: 1,
        extension: '.JPEG',
      );
      expect(file.resolvedExtension, 'jpeg');
    });

    test('isImage reads the mime type or the extension', () {
      expect(png.isImage, isTrue);
      expect(jpeg.isImage, isTrue);
      expect(pdf.isImage, isFalse);
      const webp = FileValue(id: 'i', name: 'x.webp', size: 1);
      expect(webp.isImage, isTrue);
      const dotfileImage = FileValue(id: 'j', name: '.png', size: 1);
      expect(dotfileImage.isImage, isFalse);
    });

    test('carries the bytes, path and platform source through', () {
      final bytes = Uint8List.fromList(<int>[1, 2, 3]);
      final file = FileValue(
        id: 'k',
        name: 'x.bin',
        size: 3,
        bytes: bytes,
        path: '/tmp/x.bin',
        source: Object(),
      );
      expect(file.bytes, same(bytes));
      expect(file.path, '/tmp/x.bin');
      expect(file.source, isNotNull);
    });
  });

  group('FileStatus', () {
    test('busy and settled are exhaustive', () {
      expect(FileStatus.uploading.isBusy, isTrue);
      expect(FileStatus.queued.isBusy, isFalse);
      expect(FileStatus.success.isSettled, isTrue);
      expect(FileStatus.error.isSettled, isTrue);
      expect(FileStatus.uploading.isSettled, isFalse);
      expect(FileStatus.queued.isSettled, isFalse);
    });
  });

  group('FileItem', () {
    test('copyWith keeps progress when only the status changes', () {
      // Old `FileUploadItem.copyWith` dropped progress on every call.
      const item = FileItem(
        file: png,
        status: FileStatus.uploading,
        progress: 0.5,
      );
      final done = item.copyWith(status: FileStatus.success);
      expect(done.progress, 0.5);
      expect(done.status, FileStatus.success);
      expect(item.progress, 0.5);
    });

    test('copyWith replaces progress when one is given', () {
      const item = FileItem(
        file: png,
        status: FileStatus.uploading,
        progress: 0.5,
      );
      expect(item.copyWith(progress: 0.75).progress, 0.75);
    });

    test('copyWith clears progress only when asked', () {
      const item = FileItem(file: png, status: FileStatus.error, progress: 0.2);
      expect(item.copyWith(resetProgress: true).progress, isNull);
      expect(item.copyWith(status: FileStatus.queued).progress, 0.2);
    });

    test('a default item is queued with no progress', () {
      const item = FileItem(file: png);
      expect(item.status, FileStatus.queued);
      expect(item.progress, isNull);
      expect(item.toString(), 'FileItem(photo.png, FileStatus.queued)');
    });
  });

  group('FileConstraints', () {
    test('normalises extensions and mime types', () {
      const rules = FileConstraints(
        allowedExtensions: <String>['.PNG', 'jpg', ''],
        allowedMimeTypes: <String>['IMAGE/PNG', 'image/*', 'application/pdf'],
      );
      expect(rules.normalizedExtensions, <String>{'png', 'jpg'});
      expect(rules.normalizedMimeTypes, <String>[
        'image/png',
        'application/pdf',
      ]);
      expect(rules.mimeTypePrefixes, <String>['image/']);
    });

    test('null lists normalise to empty', () {
      const rules = FileConstraints();
      expect(rules.normalizedExtensions, isEmpty);
      expect(rules.normalizedMimeTypes, isEmpty);
      expect(rules.mimeTypePrefixes, isEmpty);
    });

    test('isUnbounded reflects the configured limits', () {
      // No limits and multiple selection allowed: nothing is restricted.
      expect(const FileConstraints().isUnbounded, isTrue);
      expect(const FileConstraints(allowMultiple: false).isUnbounded, isTrue);
      expect(const FileConstraints(maxFiles: 3).isUnbounded, isFalse);
      expect(const FileConstraints(maxFileSizeBytes: 10).isUnbounded, isFalse);
      expect(
        const FileConstraints(allowedExtensions: <String>['png']).isUnbounded,
        isFalse,
      );
      expect(
        const FileConstraints(
          allowedMimeTypes: <String>['image/*'],
        ).isUnbounded,
        isFalse,
      );
    });
  });

  group('FileError', () {
    test('describes the rejection', () {
      const error = FileError(
        code: FileErrorCode.uploadFailed,
        message: 'boom',
      );
      expect(error.toString(), 'FileError(uploadFailed, boom)');
      const withFile = FileError(
        code: FileErrorCode.tooLarge,
        message: 'too big',
        file: png,
      );
      expect(withFile.toString(), 'FileError(tooLarge, too big, photo.png)');
    });
  });
}
