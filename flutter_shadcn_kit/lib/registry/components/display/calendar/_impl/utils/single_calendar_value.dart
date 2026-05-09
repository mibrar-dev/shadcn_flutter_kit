// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../calendar.dart';

/// Calendar value representing a single selected date.
///
/// Encapsulates a single [DateTime] selection and provides lookup functionality
/// to determine if a given date matches the selected date. Used primarily
/// with [CalendarSelectionMode.single].
///
/// Example:
/// ```dart
/// final singleValue = SingleCalendarValue(DateTime(2024, 3, 15));
/// final lookup = singleValue.lookup(2024, 3, 15);
/// print(lookup == CalendarValueLookup.selected); // true
/// ```
class SingleCalendarValue extends CalendarValue {
  /// The selected date.
  final DateTime date;

  /// Creates a single calendar value with the specified date.
  SingleCalendarValue(this.date);

  /// Implements `lookup` behavior for calendar.
  @override
  CalendarValueLookup lookup(int year, [int? month, int? day]) {
    DateTime current = _convertNecessarry(date, year, month, day);
    if (current.isAtSameMomentAs(DateTime(year, month ?? 1, day ?? 1))) {
      return CalendarValueLookup.selected;
    }
    return CalendarValueLookup.none;
  }

  @override
  CalendarView get view => date.toCalendarView();

  /// Returns a debug string for this calendar value.
  @override
  String toString() {
    return 'SingleCalendarValue($date)';
  }

  /// Compares two calendar values for structural equality.
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SingleCalendarValue && other.date == date;
  }

  @override
  int get hashCode => date.hashCode;

  /// Implements `toSingle` behavior for calendar.
  @override
  SingleCalendarValue toSingle() {
    return this;
  }

  /// Implements `toRange` behavior for calendar.
  @override
  RangeCalendarValue toRange() {
    return CalendarValue.range(date, date);
  }

  /// Implements `toMulti` behavior for calendar.
  @override
  MultiCalendarValue toMulti() {
    return CalendarValue.multi([date]);
  }
}
