// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../calendar.dart';

/// Calendar value representing multiple selected dates.
///
/// Encapsulates a list of individually selected dates. Provides lookup
/// functionality to determine if a date is among the selected dates.
/// Used with [CalendarSelectionMode.multi].
class MultiCalendarValue extends CalendarValue {
  /// The list of selected dates.
  final List<DateTime> dates;

  /// Creates a multi calendar value with the specified list of dates.
  MultiCalendarValue(this.dates);

  /// Implements `lookup` behavior for calendar.
  @override
  CalendarValueLookup lookup(int year, [int? month, int? day]) {
    DateTime current = DateTime(year, month ?? 1, day ?? 1);
    if (dates.any(
      (element) => _convertNecessarry(
        element,
        year,
        month,
        day,
      ).isAtSameMomentAs(current),
    )) {
      return CalendarValueLookup.selected;
    }
    return CalendarValueLookup.none;
  }

  @override
  CalendarView get view =>
      dates.firstOrNull?.toCalendarView() ?? CalendarView.now();

  /// Returns a debug string for this calendar value.
  @override
  String toString() {
    return 'MultiCalendarValue($dates)';
  }

  /// Compares two calendar values for structural equality.
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MultiCalendarValue && listEquals(other.dates, dates);
  }

  @override
  int get hashCode => dates.hashCode;

  /// Implements `toSingle` behavior for calendar.
  @override
  SingleCalendarValue toSingle() {
    return CalendarValue.single(dates.first);
  }

  /// Implements `toRange` behavior for calendar.
  @override
  RangeCalendarValue toRange() {
    assert(dates.isNotEmpty, 'Cannot convert empty list to range');
    DateTime min = dates.reduce(
      (value, element) => value.isBefore(element) ? value : element,
    );
    DateTime max = dates.reduce(
      (value, element) => value.isAfter(element) ? value : element,
    );
    return CalendarValue.range(min, max);
  }

  /// Implements `toMulti` behavior for calendar.
  @override
  MultiCalendarValue toMulti() {
    return this;
  }
}
