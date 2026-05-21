// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../calendar.dart';

/// Calendar value representing a date range selection.
///
/// Encapsulates a date range with start and end dates. Provides lookup
/// functionality to determine if a date is the start, end, within the range,
/// or outside. Used with [CalendarSelectionMode.range].
///
/// The range is automatically normalized so start is always before or equal to end.
class RangeCalendarValue extends CalendarValue {
  /// The start date of the range (always <= end).
  final DateTime start;

  /// The end date of the range (always >= start).
  final DateTime end;

  /// Creates a range calendar value with the specified start and end dates.
  ///
  /// Automatically normalizes the range so [start] is before [end].
  RangeCalendarValue(DateTime start, DateTime end)
    : start = start.isBefore(end) ? start : end,
      end = start.isBefore(end) ? end : start;

  /// Implements `lookup` behavior for calendar.
  @override
  CalendarValueLookup lookup(int year, [int? month, int? day]) {
    DateTime start = _convertNecessarry(this.start, year, month, day);
    DateTime end = _convertNecessarry(this.end, year, month, day);
    DateTime current = DateTime(year, month ?? 1, day ?? 1);
    if (current.isAtSameMomentAs(start) && current.isAtSameMomentAs(end)) {
      return CalendarValueLookup.selected;
    }
    if (current.isAtSameMomentAs(start)) {
      return CalendarValueLookup.start;
    }
    if (current.isAtSameMomentAs(end)) {
      return CalendarValueLookup.end;
    }
    if (current.isAfter(start) && current.isBefore(end)) {
      return CalendarValueLookup.inRange;
    }
    return CalendarValueLookup.none;
  }

  @override
  CalendarView get view => start.toCalendarView();

  /// Returns a debug string for this calendar value.
  @override
  String toString() {
    return 'RangedCalendarValue($start, $end)';
  }

  /// Compares two calendar values for structural equality.
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is RangeCalendarValue &&
        other.start == start &&
        other.end == end;
  }

  @override
  int get hashCode => start.hashCode ^ end.hashCode;

  /// Implements `toSingle` behavior for calendar.
  @override
  SingleCalendarValue toSingle() {
    return CalendarValue.single(start);
  }

  /// Implements `toRange` behavior for calendar.
  @override
  RangeCalendarValue toRange() {
    return this;
  }

  /// Implements `toMulti` behavior for calendar.
  @override
  MultiCalendarValue toMulti() {
    List<DateTime> dates = [];
    for (
      DateTime date = start;
      date.isBefore(end);
      date = date.add(const Duration(days: 1))
    ) {
      dates.add(date);
    }
    dates.add(end);
    return CalendarValue.multi(dates);
  }
}
