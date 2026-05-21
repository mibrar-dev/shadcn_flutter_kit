// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../locale_utils.dart';

/// Represents a part of a date (year, month, or day).
///
/// Provides metadata and operations for individual date components.
enum DatePart {
  /// Year component (4 digits).
  year(_getYear, _computeYearValueRange, length: 4),

  /// Month component.
  month(_getMonth, _computeMonthValueRange),

  /// Day component.
  day(_getDay, _computeDayValueRange);

  /// Function that extracts the date/time component value from a DateTime.
  final int Function(DateTime dateTime) getter;

  /// Maximum number of digits for this date component.
  final int length;

  /// Function that computes the valid value range for this component.
  ///
  /// Takes a map of already-set date component values and returns the
  /// minimum and maximum valid values for this component, considering
  /// constraints like month lengths or leap years.
  final (int? min, int? max) Function(Map<DatePart, int> values)
  computeValueRange;

  const DatePart(this.getter, this.computeValueRange, {this.length = 2});
}
