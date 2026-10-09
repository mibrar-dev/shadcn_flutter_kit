// Unit tests for the `locale_utils` component.

import 'package:flutter_shadcn_kit/registry/components/locale_utils/locale_utils.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SizeUnitLocale.format', () {
    test('zero and negative counts read 0 in the smallest unit', () {
      expect(SizeUnitLocale.fileBytes.format(0), '0 B');
      expect(SizeUnitLocale.fileBytes.format(-5), '0 B');
    });

    test('whole and fractional values use the conventional ladder', () {
      expect(SizeUnitLocale.fileBytes.format(512), '512 B');
      // The formatter groups digits (the old commented-out NumberFormat
      // intended '#,##0.#'), so four-digit byte counts gain a separator.
      expect(SizeUnitLocale.fileBytes.format(1023), '1,023 B');
      expect(SizeUnitLocale.fileBytes.format(1024), '1 KB');
      expect(SizeUnitLocale.fileBytes.format(1536), '1.5 KB');
      expect(SizeUnitLocale.fileBytes.format(1024 * 1024), '1 MB');
      expect(SizeUnitLocale.fileBytes.format(1024 * 1024 * 1024), '1 GB');
    });

    test('binaryBytes uses IEC labels and starts at B', () {
      expect(SizeUnitLocale.binaryBytes.format(1024), '1 KiB');
      expect(SizeUnitLocale.binaryBytes.format(1536), '1.5 KiB');
      expect(SizeUnitLocale.binaryBytes.format(0), '0 B');
    });

    test('regression: a value past the last unit is clamped, not a crash', () {
      // The old formatter indexed units[digitGroups] without a bound and threw
      // a RangeError once bytes reached base^units.length.
      final SizeUnitLocale small = SizeUnitLocale(1024, const <String>['B']);
      expect(small.format(1024 * 1024), '1,048,576 B');

      final int huge = 1 << 40; // 1 TiB, far past the 2-unit table's top
      final SizeUnitLocale twoUnits = SizeUnitLocale(1024, const <String>[
        'B',
        'KB',
      ]);
      expect(twoUnits.format(huge), '1,073,741,824 KB');
    });

    test('the separator groups the integer part of large values', () {
      final SizeUnitLocale grouped = SizeUnitLocale(1024, const <String>[
        'B',
        'KB',
      ]);
      expect(grouped.format(1234 * 1024), '1,234 KB');
      expect(grouped.format(1234 * 1024 + 512), '1,234.5 KB');
    });

    test('an empty separator disables grouping', () {
      final SizeUnitLocale plain = SizeUnitLocale(1024, const <String>[
        'B',
        'KB',
      ], separator: '');
      expect(plain.format(1234 * 1024), '1234 KB');
    });

    test('a custom base and unit list are honoured', () {
      const SizeUnitLocale decimal = SizeUnitLocale(1000, <String>[
        'B',
        'kB',
        'MB',
        'GB',
      ]);
      expect(decimal.format(1500), '1.5 kB');
      expect(decimal.format(2 * 1000 * 1000), '2 MB');
    });
  });
}
