// The `locale_utils` component: byte-size formatting against a unit table.
//
// Ported from `components/utility/locale_utils` minus everything that moved to
// `primitives/localizations/locale_parts.dart` (DatePart / TimePart /
// DurationPart and their helpers). What remains is [SizeUnitLocale] and its
// `format`, the locale-configurable counterpart of the file components'
// `primitives/file_value` formatter.
//
// The old module exposed a top-level `formatFileSize(int, SizeUnitLocale)`;
// that name is owned by `primitives/file_value/file_format.dart` (single
// owner), so the formatter is a method here.

/// Unit table and digit-grouping rules for byte-size formatting.
///
/// ```dart
/// SizeUnitLocale.fileBytes.format(1536); // '1.5 KB'
/// const SizeUnitLocale(1000, ['B', 'kB'], separator: ' ').format(1234567);
/// // '1 234.6 kB'
/// ```
class SizeUnitLocale {
  /// Creates a unit table.
  ///
  /// [base] is the conversion factor between units (1024 for binary,
  /// 1000 for decimal), [units] are the labels from smallest to largest and
  /// [separator] groups the digits of the integer part (empty disables
  /// grouping).
  const SizeUnitLocale(this.base, this.units, {this.separator = ','});

  /// Conversion factor between two neighbouring units.
  final int base;

  /// Unit labels from smallest ([units] first) to largest.
  final List<String> units;

  /// Separator inserted between digit groups of the integer part.
  final String separator;

  /// Byte units with the conventional short labels (`B`, `KB`, `MB`, …).
  static const SizeUnitLocale fileBytes = SizeUnitLocale(1024, <String>[
    'B',
    'KB',
    'MB',
    'GB',
    'TB',
    'PB',
    'EB',
    'ZB',
    'YB',
  ]);

  /// Binary byte units with IEC labels (`B`, `KiB`, `MiB`, …).
  ///
  /// Replaces the old `fileBits`, whose labels started at `Bi` and described
  /// binary *bytes*; the renamed table keeps a single `B` for whole bytes.
  static const SizeUnitLocale binaryBytes = SizeUnitLocale(1024, <String>[
    'B',
    'KiB',
    'MiB',
    'GiB',
    'TiB',
    'PiB',
    'EiB',
    'ZiB',
    'YiB',
  ]);

  /// Formats [bytes] using this table.
  ///
  /// Zero and negative counts read `0 <unit>`. Values past the largest unit
  /// stay in that unit instead of overflowing the table (the old top-level
  /// formatter indexed past the end and threw a `RangeError`).
  String format(int bytes) {
    if (bytes <= 0) {
      return '0 ${units.first}';
    }
    var value = bytes.toDouble();
    var index = 0;
    while (value >= base && index < units.length - 1) {
      value /= base;
      index += 1;
    }
    final String number = value == value.truncateToDouble()
        ? value.truncate().toString()
        : value.toStringAsFixed(1);
    return '${_groupDigits(number)} ${units[index]}';
  }

  /// Inserts [separator] between groups of three integer digits.
  String _groupDigits(String number) {
    if (separator.isEmpty) {
      return number;
    }
    final int dot = number.indexOf('.');
    final String intPart = dot == -1 ? number : number.substring(0, dot);
    final String rest = dot == -1 ? '' : number.substring(dot);
    final StringBuffer grouped = StringBuffer();
    for (int i = 0; i < intPart.length; i += 1) {
      if (i > 0 && (intPart.length - i) % 3 == 0) {
        grouped.write(separator);
      }
      grouped.write(intPart[i]);
    }
    return '$grouped$rest';
  }
}
