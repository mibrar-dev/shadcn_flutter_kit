// Calendar math shared by calendar, date_picker, time_picker and
// object_input: month grids, leap years, value ranges, the navigation view and
// the selection value types.
//
// P2-E2 removed the `getter` / `computeValueRange` fields from
// `primitives/localizations/locale_parts.dart` because nothing read them; the
// Phase 4 batches need that logic again, so it lives here, scoped to the
// callers, while the enums themselves stay in localizations.

import 'dart:math' as math;

import 'package:flutter/foundation.dart' show immutable, listEquals;

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

/// Where a queried date, month or year sits relative to a [CalendarValue].
enum CalendarValueLookup {
  /// Not part of the value.
  none,

  /// Directly selected.
  selected,

  /// First day of a range.
  start,

  /// Last day of a range.
  end,

  /// Inside a range, but not an endpoint.
  inRange,
}

/// The month a calendar is showing: only *where the grid looks*. Which dates
/// are selected is a separate [CalendarValue]. Midnight-anchored throughout, so
/// a DST transition cannot shift a cell.
class CalendarView {
  const CalendarView(this.year, this.month)
    : assert(month >= 1 && month <= 12, 'month must be between 1 and 12');
  factory CalendarView.fromDateTime(DateTime date) =>
      CalendarView(date.year, date.month);

  final int year;
  final int month;

  /// The next month, rolling into January.
  CalendarView get next =>
      month == 12 ? CalendarView(year + 1, 1) : CalendarView(year, month + 1);

  /// The previous month, rolling into December.
  CalendarView get previous =>
      month == 1 ? CalendarView(year - 1, 12) : CalendarView(year, month - 1);

  static DateTime monthStart(DateTime date) => DateTime(date.year, date.month);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CalendarView && other.year == year && other.month == month;

  @override
  int get hashCode => Object.hash(year, month);
}

/// A selection in a calendar: one date, a start/end pair, or a list. The three
/// `lookup` methods answer the same question at three granularities, so all
/// three grids share one paint path. Sealed, so nobody invents a fourth shape.
@immutable
sealed class CalendarValue {
  const CalendarValue();

  /// One selected date.
  const factory CalendarValue.single(DateTime date) = SingleCalendarValue;

  /// A range; [end] is normalised to be on or after [start].
  factory CalendarValue.range(DateTime start, DateTime end) =
      RangeCalendarValue;

  /// Any number of selected dates.
  const factory CalendarValue.multi(List<DateTime> dates) = MultiCalendarValue;

  /// How [date], the month ([year], [month]) or [year] relates to this value.
  CalendarValueLookup lookupDate(DateTime date);
  CalendarValueLookup lookupMonth(int year, int month);
  CalendarValueLookup lookupYear(int year);
}

/// One selected date; the time of day is ignored.
final class SingleCalendarValue extends CalendarValue {
  /// Selects [date].
  const SingleCalendarValue(this.date);
  final DateTime date;

  @override
  CalendarValueLookup lookupDate(DateTime other) =>
      other == date ? CalendarValueLookup.selected : CalendarValueLookup.none;

  @override
  CalendarValueLookup lookupMonth(int year, int month) =>
      _selected(year == date.year && month == date.month);

  @override
  CalendarValueLookup lookupYear(int year) => _selected(year == date.year);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SingleCalendarValue && other.date == date;

  @override
  int get hashCode => date.hashCode;
}

/// A start/end pair; the constructor orders the two dates.
final class RangeCalendarValue extends CalendarValue {
  /// Selects the span between [start] and [end], in either order.
  RangeCalendarValue(DateTime start, DateTime end)
    : start = start.isBefore(end) ? start : end,
      end = start.isBefore(end) ? end : start;

  /// First day of the span; never after [end].
  final DateTime start;

  /// Last day of the span; never before [start].
  final DateTime end;

  @override
  CalendarValueLookup lookupDate(DateTime date) {
    if (date.isBefore(start) || date.isAfter(end)) {
      return CalendarValueLookup.none;
    }

    if (start == end || date == start) return CalendarValueLookup.start;
    return date == end ? CalendarValueLookup.end : CalendarValueLookup.inRange;
  }

  @override
  CalendarValueLookup lookupMonth(int year, int month) => _span(
    first: DateTime(year, month),
    last: DateTime(year, month + 1, 0),
    startBlock: CalendarView.monthStart(start),
    endBlock: CalendarView.monthStart(end),
  );

  @override
  CalendarValueLookup lookupYear(int year) => _span(
    first: DateTime(year),
    last: DateTime(year, 12, 31),
    startBlock: DateTime(start.year),
    endBlock: DateTime(end.year),
  );

  /// The lookup of block [first]..[last] of a range whose endpoints fall in
  /// blocks [startBlock] and [endBlock].
  CalendarValueLookup _span({
    required DateTime first,
    required DateTime last,
    required DateTime startBlock,
    required DateTime endBlock,
  }) {
    if (last.isBefore(start) || first.isAfter(end)) {
      return CalendarValueLookup.none;
    }

    if (first == startBlock) return CalendarValueLookup.start;
    return first == endBlock
        ? CalendarValueLookup.end
        : CalendarValueLookup.inRange;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RangeCalendarValue && other.start == start && other.end == end;

  @override
  int get hashCode => Object.hash(start, end);
}

/// Any number of selected dates.
final class MultiCalendarValue extends CalendarValue {
  /// Selects [dates].
  const MultiCalendarValue(this.dates);
  final List<DateTime> dates;

  @override
  CalendarValueLookup lookupDate(DateTime date) =>
      _selected(dates.contains(date));

  @override
  CalendarValueLookup lookupMonth(int year, int month) =>
      _selected(dates.any((DateTime d) => d.year == year && d.month == month));

  @override
  CalendarValueLookup lookupYear(int year) =>
      _selected(dates.any((DateTime d) => d.year == year));

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MultiCalendarValue && listEquals(other.dates, dates);

  @override
  int get hashCode => Object.hashAll(dates);
}

/// `selected` when [hit], `none` otherwise.
CalendarValueLookup _selected(bool hit) =>
    hit ? CalendarValueLookup.selected : CalendarValueLookup.none;

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

/// Inclusive day range for a date whose [year] and [month] may be unset.
(int, int) dayValueRange({int? year, int? month}) {
  if (year == null || month == null) return (1, 31);
  return (1, daysInMonth(year, month));
}

/// Inclusive range of each date part; `year` is unbounded, hence nullable.
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

/// Inclusive range of each clock-time part.
(int, int) timePartValueRange(TimePart part) {
  return switch (part) {
    TimePart.hour => (0, 23),
    TimePart.minute => (0, 59),
    TimePart.second => (0, 59),
  };
}

/// Inclusive range of each duration part; whole days are unbounded.
(int, int?) durationPartValueRange(DurationPart part) {
  return switch (part) {
    DurationPart.day => (0, null),
    DurationPart.hour => (0, 23),
    DurationPart.minute => (0, 59),
    DurationPart.second => (0, 59),
  };
}

/// One component of [date] (the old `DatePart.getter`).
int datePartValue(DateTime date, DatePart part) {
  return switch (part) {
    DatePart.year => date.year,
    DatePart.month => date.month,
    DatePart.day => date.day,
  };
}

/// One component of [time] (the old `TimePart.getter`).
int timePartValue(TimeOfDay time, TimePart part) {
  return switch (part) {
    TimePart.hour => time.hour,
    TimePart.minute => time.minute,
    TimePart.second => time.second,
  };
}

/// One component of [duration] (the old `DurationPart.getter`).
int durationPartValue(Duration duration, DurationPart part) {
  return switch (part) {
    DurationPart.day => duration.inDays,
    DurationPart.hour => duration.inHours % 24,
    DurationPart.minute => duration.inMinutes % 60,
    DurationPart.second => duration.inSeconds % 60,
  };
}
