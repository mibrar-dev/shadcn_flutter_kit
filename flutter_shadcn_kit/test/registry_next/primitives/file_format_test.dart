import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_shadcn_kit/registry_next/primitives/file_value/file_format.dart';
import 'package:flutter_shadcn_kit/registry_next/primitives/file_value/file_value.dart';

/// Behavioural note for the fixed formatter: [formatFileSize] never rounds up
/// into the next unit. The old `_formatFileSize` used one significant digit
/// below ten units and none above, so 9.99 MB printed as `10.0 MB` and
/// 1023.99 KB could print as `1024.0 KB` — a number larger than the input.
void main() {
  group('loading modes', () {
    test('the surface modes are replace, hide and wrap', () {
      expect(FileSurfaceLoadingMode.values, <FileSurfaceLoadingMode>[
        FileSurfaceLoadingMode.replace,
        FileSurfaceLoadingMode.hide,
        FileSurfaceLoadingMode.wrap,
      ]);
    });

    test('the item modes are linear, none and custom', () {
      expect(FileItemLoadingMode.values, <FileItemLoadingMode>[
        FileItemLoadingMode.linear,
        FileItemLoadingMode.none,
        FileItemLoadingMode.custom,
      ]);
    });

    test('the default indicator applies while uploading only', () {
      expect(defaultFileItemLoadingStatuses, <FileStatus>{
        FileStatus.uploading,
      });
    });
  });

  group('FileStatusLabels', () {
    test('resolves every status', () {
      const labels = FileStatusLabels();
      expect(labels.resolve(FileStatus.queued), 'Queued');
      expect(labels.resolve(FileStatus.uploading), 'Uploading');
      expect(labels.resolve(FileStatus.success), 'Completed');
      expect(labels.resolve(FileStatus.error), 'Failed');
    });

    test('accepts translated overrides', () {
      const labels = FileStatusLabels(
        queued: 'En attente',
        uploading: 'En cours',
        completed: 'Terminé',
        failed: 'Échec',
      );
      expect(labels.resolve(FileStatus.uploading), 'En cours');
      expect(labels.resolve(FileStatus.error), 'Échec');
    });
  });

  group('formatFileSize', () {
    test('formats zero and negative sizes', () {
      expect(formatFileSize(0), '0 B');
      expect(formatFileSize(-5), '0 B');
    });

    test('walks the unit ladder', () {
      expect(formatFileSize(1), '1 B');
      expect(formatFileSize(1023), '1023 B');
      expect(formatFileSize(1024), '1.0 KB');
      expect(formatFileSize(1024 * 1024), '1.0 MB');
      expect(formatFileSize(1024 * 1024 * 1024), '1.0 GB');
      expect(formatFileSize(1024 * 1024 * 1024 * 1024), '1.0 TB');
      // Beyond the ladder the largest unit is kept.
      expect(formatFileSize(1024 * 1024 * 1024 * 1024 * 1024), '1024.0 TB');
    });

    test('never rounds up into the next unit', () {
      // Old `_formatFileSize` produced `1024 B` here and `10.0 MB` for 9.99 MB.
      expect(formatFileSize(1023), '1023 B');
      expect(formatFileSize(1024 * 1024 - 1), '1023.9 KB');
    });

    test('honours the decimals argument', () {
      expect(formatFileSize(1536, decimals: 0), '1 KB');
      expect(formatFileSize(1536, decimals: 2), '1.50 KB');
    });
  });
}
