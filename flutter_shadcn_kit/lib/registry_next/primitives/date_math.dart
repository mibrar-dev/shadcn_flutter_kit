// Calendar math shared by calendar, date_picker, time_picker and
// object_input.
//
// P2-E2 removed the `getter` / `computeValueRange` fields from
// `primitives/localizations/locale_parts.dart` because nothing read them; the
// Phase 4 batches need that logic again, so it lives here, scoped to the
// callers, while the enums themselves stay in localizations.

import 'dart:math' as math;

import '../foundation/time_of_day.dart';
import 'localizations/locale_parts.dart';

/// Whether [year] has 366 days (Gregorian calendar rule).
bool isLeapYear(int year) {
  return (year % 4 == 0 && year % 100 != 0) || year % 400 == 0;
}

/// Number of days in [month] (1-12) of [year].
int daysInMonth(int year, int month) {
  assert(month >= 1 && month <= 12, 'month must be between 1 and 12');
  return DateTime(year, month + 1, 0).day;
}

/// Midnight on the first day of [month] (1-12) of [year].
DateTime startOfMonth(int year, int month) => DateTime(year, month);

/// A single cell of a [monthGrid]: a date plus its position in the grid.
class DateGridCell {
  /// Creates a grid cell.
  const DateGridCell({
    required this.date,
    required this.indexInRow,
    required this.rowIndex,
    required this.fromAnotherMonth,
  });

  /// The date this cell shows.
  final DateTime date;

  /// Column of this cell, 0-6, counting from the first day of the week.
  final int indexInRow;

  /// Row of this cell, 0-based.
  final int rowIndex;

  /// Whether the date falls outside the grid's primary month.
  final bool fromAnotherMonth;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DateGridCell &&
        other.date == date &&
        other.indexInRow == indexInRow &&
        other.rowIndex == rowIndex &&
        other.fromAnotherMonth == fromAnotherMonth;
  }

  @override
  int get hashCode => Object.hash(date, indexInRow, rowIndex, fromAnotherMonth);

  @override
  String toString() =>
      'DateGridCell($date, row: $rowIndex, column: $indexInRow, '
      'outside: $fromAnotherMonth)';
}

/// Complete weeks covering [month] (1-12) of [year].
///
/// Weeks start on [firstDayOfWeek] using the `DateTime.weekday` convention
/// (1 = Monday … 7 = Sunday). The grid starts on the nearest such weekday at
/// or before the first of the month and always contains whole weeks; cells
/// outside the primary month carry `fromAnotherMonth: true`.
List<DateGridCell> monthGrid(
  int year,
  int month, {
  int firstDayOfWeek = DateTime.monday,
}) {
  assert(month >= 1 && month <= 12, 'month must be between 1 and 12');
  assert(firstDayOfWeek >= 1 && firstDayOfWeek <= 7, 'weekday out of range');
  final leading = (DateTime(year, month, 1).weekday - firstDayOfWeek + 7) % 7;
  final cellCount = ((leading + daysInMonth(year, month) + 6) ~/ 7) * 7;
  final first = DateTime(year, month, 1 - leading);
  final cells = <DateGridCell>[];
  for (var i = 0; i < cellCount; i++) {
    final date = DateTime(first.year, first.month, first.day + i);
    cells.add(
      DateGridCell(
        date: date,
        indexInRow: i % 7,
        rowIndex: i ~/ 7,
        fromAnotherMonth: date.year != year || date.month != month,
      ),
    );
  }
  return cells;
}

/// The [firstDayOfWeek] on or before [date], at midnight.
DateTime startOfWeek(DateTime date, {int firstDayOfWeek = DateTime.monday}) {
  assert(firstDayOfWeek >= 1 && firstDayOfWeek <= 7, 'weekday out of range');
  final delta = (date.weekday - firstDayOfWeek + 7) % 7;
  return DateTime(date.year, date.month, date.day - delta);
}

/// [date] shifted by [months], keeping the time of day and clamping the day
/// to the length of the target month (Jan 31 + 1 month = Feb 28/29).
DateTime addMonths(DateTime date, int months) {
  final target = DateTime(date.year, date.month + months);
  final day = math.min(date.day, daysInMonth(target.year, target.month));
  return DateTime(
    target.year,
    target.month,
    day,
    date.hour,
    date.minute,
    date.second,
    date.millisecond,
    date.microsecond,
  );
}

/// Clamps [date] into the inclusive range `[min, max]`.
DateTime clampDate(
  DateTime date, {
  required DateTime min,
  required DateTime max,
}) {
  if (date.isBefore(min)) return min;
  if (date.isAfter(max)) return max;
  return date;
}

/// Inclusive range of days for a date whose [year] and [month] may still be
/// unset: 1-31 while either is unknown, otherwise 1-`daysInMonth`.
(int, int) dayValueRange({int? year, int? month}) {
  if (year == null || month == null) return (1, 31);
  return (1, daysInMonth(year, month));
}

/// Inclusive range each date part may take, given the parts already entered.
///
/// `year` is unbounded, hence the nullable bounds.
(int? min, int? max) datePartValueRange(
  DatePart part, {
  int? year,
  int? month,
}) {
  return switch (part) {
    DatePart.year => (null, null),
    DatePart.month => (1, 12),
    DatePart.day => dayValueRange(year: year, month: month),
  };
}

/// Inclusive range each clock-time part may take.
(int, int) timePartValueRange(TimePart part) {
  return switch (part) {
    TimePart.hour => (0, 23),
    TimePart.minute => (0, 59),
    TimePart.second => (0, 59),
  };
}

/// Inclusive range each duration part may take; whole days are unbounded.
(int, int?) durationPartValueRange(DurationPart part) {
  return switch (part) {
    DurationPart.day => (0, null),
    DurationPart.hour => (0, 23),
    DurationPart.minute => (0, 59),
    DurationPart.second => (0, 59),
  };
}

/// Reads one component of [date] (the old `DatePart.getter`).
int datePartValue(DateTime date, DatePart part) {
  return switch (part) {
    DatePart.year => date.year,
    DatePart.month => date.month,
    DatePart.day => date.day,
  };
}

/// Reads one component of [time] (the old `TimePart.getter`).
int timePartValue(TimeOfDay time, TimePart part) {
  return switch (part) {
    TimePart.hour => time.hour,
    TimePart.minute => time.minute,
    TimePart.second => time.second,
  };
}

/// Reads one component of [duration] (the old `DurationPart.getter`).
int durationPartValue(Duration duration, DurationPart part) {
  return switch (part) {
    DurationPart.day => duration.inDays,
    DurationPart.hour => duration.inHours % 24,
    DurationPart.minute => duration.inMinutes % 60,
    DurationPart.second => duration.inSeconds % 60,
  };
}
