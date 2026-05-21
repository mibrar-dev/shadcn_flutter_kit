// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../calendar.dart';

/// Core class used by the calendar component.
abstract class CalendarValue {
  /// Looks up whether the specified date is part of this calendar value.
  ///
  /// Returns a [CalendarValueLookup] indicating the relationship of the
  /// queried date to this value (none, selected, start, end, or inRange).
  CalendarValueLookup lookup(int year, [int? month = 1, int? day = 1]);

  /// Creates a base calendar value.
  const CalendarValue();

  /// Factory constructor to create a single date value.
  static SingleCalendarValue single(DateTime date) {
    return SingleCalendarValue(date);
  }

  /// Factory constructor to create a date range value.
  static RangeCalendarValue range(DateTime start, DateTime end) {
    return RangeCalendarValue(start, end);
  }

  /// Factory constructor to create a multi-date value.
  static MultiCalendarValue multi(List<DateTime> dates) {
    return MultiCalendarValue(dates);
  }

  /// Converts this value to a single calendar value.
  SingleCalendarValue toSingle();

  /// Converts this value to a range calendar value.
  RangeCalendarValue toRange();

  /// Converts this value to a multi calendar value.
  MultiCalendarValue toMulti();

  /// Returns the calendar view associated with this value.
  CalendarView get view;
}

/// Implements `_convertNecessarry` behavior for calendar.
DateTime _convertNecessarry(DateTime from, int year, [int? month, int? date]) {
  if (month == null) {
    return DateTime(from.year);
  }
  if (date == null) {
    return DateTime(from.year, from.month);
  }
  return DateTime(from.year, from.month, from.day);
}

/// Represents a specific month and year view in calendar navigation.
///
/// Provides immutable representation of a calendar's current viewing position
/// with navigation methods to move between months and years. Used to control
/// which month/year combination is displayed in calendar grids.
///
/// Key Features:
/// - **Navigation Methods**: [next], [previous], [nextYear], [previousYear]
/// - **Factory Constructors**: [now()], [fromDateTime()]
/// - **Validation**: Ensures month values stay within 1-12 range
/// - **Immutable**: All navigation returns new CalendarView instances
///
/// Example:
/// ```dart
/// // Create views for different dates
/// final current = CalendarView.now();
/// final specific = CalendarView(2024, 3); // March 2024
/// final fromDate = CalendarView.fromDateTime(someDateTime);
///
/// // Navigate between months
/// final nextMonth = current.next;
/// final prevMonth = current.previous;
/// final nextYear = current.nextYear;
/// ```
