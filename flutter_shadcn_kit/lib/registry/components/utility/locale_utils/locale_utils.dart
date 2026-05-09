// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'dart:math';

import '../../../shared/utils/util.dart';

part '_impl/core/date_part.dart';
part '_impl/core/duration_part.dart';
part '_impl/core/time_part.dart';

/// Configuration for file size unit formatting.
///
/// Defines the base (1024 for binary) and unit labels for formatting
/// file sizes and data volumes.
class SizeUnitLocale {
  /// Base for unit conversion (typically 1024 for binary units).
  final int base;

  /// List of unit labels (e.g., ['B', 'KB', 'MB', 'GB']).
  final List<String> units;

  /// Separator for digit grouping (e.g., ',' for 1,000,000).
  final String separator;

  /// Creates a [SizeUnitLocale].
  ///
  /// Parameters:
  /// - [base] (`int`, required): Base for unit conversion.
  /// - [units] (`List<String>`, required): Unit labels.
  /// - [separator] (`String`, default: ','): Digit separator.
  const SizeUnitLocale(this.base, this.units, {this.separator = ','});

  /// Standard file size units in bytes (B, KB, MB, GB, etc.).
  static const SizeUnitLocale fileBytes = _fileByteUnits;

  /// Binary file size units (Bi, KiB, MiB, GiB, etc.).
  static const SizeUnitLocale fileBits = _fileBitUnits;

  /// Gets the appropriate unit label for a value.
  ///
  /// Parameters:
  /// - [value] (`int`, required): The value to get unit for.
  ///
  /// Returns: `String` — the unit label.
  String getUnit(int value) {
    if (value <= 0) return '0 ${units[0]}';
    var log10 = _log10(value);
    final digitGroups = (log10 / _log10(base)).floor();
    final unitIndex = min(digitGroups, units.length - 1);
    return units[unitIndex];
  }
}

const _fileByteUnits = SizeUnitLocale(1024, [
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
const _fileBitUnits = SizeUnitLocale(1024, [
  'Bi',
  'KiB',
  'MiB',
  'GiB',
  'TiB',
  'PiB',
  'EiB',
  'ZiB',
  'YiB',
]);

/// Executes `_log10` behavior for this component/composite.
double _log10(num x) {
  return log(x) / ln10;
}

/// Formats a file size in bytes to a human-readable string.
///
/// Converts byte values to appropriate units (B, KB, MB, GB, etc.) based
/// on the provided locale unit configuration.
///
/// Parameters:
/// - [bytes] (`int`, required): File size in bytes.
/// - [unit] (`SizeUnitLocale`, required): Unit locale configuration.
///
/// Returns: `String` — formatted file size with unit.
///
/// Example:
/// ```dart
/// formatFileSize(1024, SizeUnitLocale.fileBytes) // "1 KB"
/// formatFileSize(1536, SizeUnitLocale.fileBytes) // "1.5 KB"
/// ```
String formatFileSize(int bytes, SizeUnitLocale unit) {
  if (bytes <= 0) return '0 ${unit.units[0]}';

  /// Stores `base` state/configuration for this implementation.
  final base = unit.base;

  /// Stores `units` state/configuration for this implementation.
  final units = unit.units;
  int digitGroups = (_log10(bytes) / _log10(base)).floor();
  // return '${NumberFormat('#,##0.#').format(bytes / pow(base, digitGroups))} ${units[digitGroups]}';
  // do it without NumberFormat, but format to #,##0.# format
  final value = bytes / pow(base, digitGroups);
  final formattedValue = value.toStringAsFixed(
    /// Creates a `value.truncateToDouble` instance.
    value.truncateToDouble() == value ? 0 : 1,
  );
  return '$formattedValue ${units[digitGroups]}';
}

/// Executes `_getYear` behavior for this component/composite.
int _getYear(DateTime dateTime) => dateTime.year;

/// Executes `_getMonth` behavior for this component/composite.
int _getMonth(DateTime dateTime) => dateTime.month;

/// Executes `_getDay` behavior for this component/composite.
int _getDay(DateTime dateTime) => dateTime.day;

(int? min, int? max) _computeYearValueRange(Map<DatePart, int> values) {
  return (null, null);
}

(int? min, int? max) _computeMonthValueRange(Map<DatePart, int> values) {
  return (1, 12);
}

(int? min, int? max) _computeDayValueRange(Map<DatePart, int> values) {
  /// Stores `year` state/configuration for this implementation.
  final year = values[DatePart.year];

  /// Stores `month` state/configuration for this implementation.
  final month = values[DatePart.month];
  if (year == null || month == null) return (1, 31);
  final daysInMonth = DateTime(year, month + 1, 0).day;
  return (1, daysInMonth);
}

/// Executes `_getDurationDay` behavior for this component/composite.
int _getDurationDay(Duration duration) => duration.inDays;

/// Executes `_getDurationHour` behavior for this component/composite.
int _getDurationHour(Duration duration) => duration.inHours % 24;

/// Executes `_getDurationMinute` behavior for this component/composite.
int _getDurationMinute(Duration duration) => duration.inMinutes % 60;

/// Executes `_getDurationSecond` behavior for this component/composite.
int _getDurationSecond(Duration duration) => duration.inSeconds % 60;

(int? min, int? max) _computeDurationDayValueRange(
  Map<DurationPart, int> values,
) => (0, null);
(int? min, int? max) _computeDurationHourValueRange(
  Map<DurationPart, int> values,
) => (0, 23);
(int? min, int? max) _computeDurationMinuteValueRange(
  Map<DurationPart, int> values,
) => (0, 59);
(int? min, int? max) _computeDurationSecondValueRange(
  Map<DurationPart, int> values,
) => (0, 59);

/// Executes `_getTimeHour` behavior for this component/composite.
int _getTimeHour(TimeOfDay time) => time.hour;

/// Executes `_getTimeMinute` behavior for this component/composite.
int _getTimeMinute(TimeOfDay time) => time.minute;

/// Executes `_getTimeSecond` behavior for this component/composite.
int _getTimeSecond(TimeOfDay time) => time.second;

(int? min, int? max) _computeTimeHourValueRange(Map<TimePart, int> values) =>
    (0, 23);
(int? min, int? max) _computeTimeMinuteValueRange(Map<TimePart, int> values) =>
    (0, 59);
(int? min, int? max) _computeTimeSecondValueRange(Map<TimePart, int> values) =>
    (0, 59);
