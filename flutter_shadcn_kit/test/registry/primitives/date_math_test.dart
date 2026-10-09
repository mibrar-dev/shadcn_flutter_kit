import 'package:flutter_shadcn_kit/registry/foundation/time_of_day.dart';
import 'package:flutter_shadcn_kit/registry/primitives/date_math.dart';
import 'package:flutter_shadcn_kit/registry/primitives/localizations/locale_parts.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('calendar primitives', () {
    test('isLeapYear follows the Gregorian rule', () {
      expect(isLeapYear(2024), isTrue);
      expect(isLeapYear(2000), isTrue);
      expect(isLeapYear(1900), isFalse);
      expect(isLeapYear(2023), isFalse);
    });

    test('daysInMonth knows month lengths and leap years', () {
      expect(daysInMonth(2024, 1), 31);
      expect(daysInMonth(2024, 2), 29);
      expect(daysInMonth(2023, 2), 28);
      expect(daysInMonth(2024, 4), 30);
      expect(daysInMonth(2024, 12), 31);
    });

    test('startOfMonth returns midnight on the first', () {
      expect(startOfMonth(2024, 3), DateTime(2024, 3));
    });

    test('monthGrid fills whole weeks and flags outside dates', () {
      // February 2024 starts on a Thursday: 3 leading January days, 29
      // February days, 3 trailing March days, five rows in total.
      final grid = monthGrid(2024, 2);
      expect(grid, hasLength(35));
      expect(grid.first.date, DateTime(2024, 1, 29));
      expect(grid.first.indexInRow, 0);
      expect(grid.first.rowIndex, 0);
      expect(grid.first.fromAnotherMonth, isTrue);
      expect(grid[3].date, DateTime(2024, 2, 1));
      expect(grid[3].indexInRow, 3);
      expect(grid[3].fromAnotherMonth, isFalse);
      expect(grid.last.date, DateTime(2024, 3, 3));
      expect(grid.last.indexInRow, 6);
      expect(grid.last.rowIndex, 4);
      expect(grid.last.fromAnotherMonth, isTrue);
    });

    test('monthGrid honours a custom first day of the week', () {
      final grid = monthGrid(2024, 2, firstDayOfWeek: DateTime.sunday);
      expect(grid, hasLength(35));
      expect(grid.first.date, DateTime(2024, 1, 28));
      expect(grid[4].date, DateTime(2024, 2, 1));
      expect(grid[4].indexInRow, 4);
    });

    test('monthGrid can be an exact four-week month', () {
      // February 2021 started on a Monday and had 28 days.
      final grid = monthGrid(2021, 2);
      expect(grid, hasLength(28));
      expect(grid.every((cell) => !cell.fromAnotherMonth), isTrue);
      expect(grid.last.date, DateTime(2021, 2, 28));
      expect(grid.last.rowIndex, 3);
    });

    test('startOfWeek walks back to the configured weekday', () {
      final wednesday = DateTime(2024, 2, 7, 15, 30);
      expect(startOfWeek(wednesday), DateTime(2024, 2, 5));
      expect(
        startOfWeek(wednesday, firstDayOfWeek: DateTime.sunday),
        DateTime(2024, 2, 4),
      );
    });

    test('addMonths clamps the day to the target month', () {
      expect(addMonths(DateTime(2024, 1, 31), 1), DateTime(2024, 2, 29));
      expect(addMonths(DateTime(2023, 1, 31), 1), DateTime(2023, 2, 28));
      expect(addMonths(DateTime(2024, 5, 31), 1), DateTime(2024, 6, 30));
      expect(addMonths(DateTime(2024, 12, 15), 1), DateTime(2025, 1, 15));
      expect(addMonths(DateTime(2024, 1, 15), -1), DateTime(2023, 12, 15));
    });

    test('addMonths keeps the time of day', () {
      expect(
        addMonths(DateTime(2024, 1, 31, 10, 30, 15), 1),
        DateTime(2024, 2, 29, 10, 30, 15),
      );
    });

    test('clampDate bounds both sides inclusively', () {
      final min = DateTime(2024, 1, 1);
      final max = DateTime(2024, 12, 31);
      expect(clampDate(DateTime(2023, 6, 1), min: min, max: max), min);
      expect(clampDate(DateTime(2025, 6, 1), min: min, max: max), max);
      expect(
        clampDate(DateTime(2024, 6, 1), min: min, max: max),
        DateTime(2024, 6, 1),
      );
    });

    test('DateGridCell compares by value', () {
      final a = DateGridCell(
        date: _fixedDate,
        indexInRow: 1,
        rowIndex: 2,
        fromAnotherMonth: false,
      );
      final b = DateGridCell(
        date: _fixedDate,
        indexInRow: 1,
        rowIndex: 2,
        fromAnotherMonth: false,
      );
      expect(a, b);
      expect(a.hashCode, b.hashCode);
      expect(
        a,
        isNot(
          DateGridCell(
            date: _fixedDate,
            indexInRow: 1,
            rowIndex: 3,
            fromAnotherMonth: false,
          ),
        ),
      );
    });
  });

  group('value ranges', () {
    test('dayValueRange needs both year and month for a real range', () {
      expect(dayValueRange(), (1, 31));
      expect(dayValueRange(year: 2024), (1, 31));
      expect(dayValueRange(month: 2), (1, 31));
      expect(dayValueRange(year: 2024, month: 2), (1, 29));
      expect(dayValueRange(year: 2023, month: 2), (1, 28));
    });

    test('datePartValueRange dispatches per part', () {
      expect(datePartValueRange(DatePart.year), (null, null));
      expect(datePartValueRange(DatePart.month), (1, 12));
      expect(datePartValueRange(DatePart.day, year: 2024, month: 2), (1, 29));
      expect(datePartValueRange(DatePart.day), (1, 31));
    });

    test('timePartValueRange covers clock parts', () {
      expect(timePartValueRange(TimePart.hour), (0, 23));
      expect(timePartValueRange(TimePart.minute), (0, 59));
      expect(timePartValueRange(TimePart.second), (0, 59));
    });

    test('durationPartValueRange leaves whole days unbounded', () {
      expect(durationPartValueRange(DurationPart.day), (0, null));
      expect(durationPartValueRange(DurationPart.hour), (0, 23));
      expect(durationPartValueRange(DurationPart.minute), (0, 59));
      expect(durationPartValueRange(DurationPart.second), (0, 59));
    });
  });

  group('part readers', () {
    test('datePartValue reads year, month and day', () {
      final date = DateTime(2024, 2, 29);
      expect(datePartValue(date, DatePart.year), 2024);
      expect(datePartValue(date, DatePart.month), 2);
      expect(datePartValue(date, DatePart.day), 29);
    });

    test('timePartValue reads hour, minute and second', () {
      const time = TimeOfDay(hour: 23, minute: 59, second: 58);
      expect(timePartValue(time, TimePart.hour), 23);
      expect(timePartValue(time, TimePart.minute), 59);
      expect(timePartValue(time, TimePart.second), 58);
    });

    test('durationPartValue splits a duration into its parts', () {
      final duration = Duration(days: 2, hours: 1, minutes: 2, seconds: 3);
      expect(durationPartValue(duration, DurationPart.day), 2);
      expect(durationPartValue(duration, DurationPart.hour), 1);
      expect(durationPartValue(duration, DurationPart.minute), 2);
      expect(durationPartValue(duration, DurationPart.second), 3);
    });

    test('durationPartValue rolls overflowing units up like Duration does', () {
      // 2 days + 25 hours normalises to 3 days + 1 hour inside Duration.
      final duration = Duration(days: 2, hours: 25, minutes: 61, seconds: 61);
      expect(durationPartValue(duration, DurationPart.day), 3);
      expect(durationPartValue(duration, DurationPart.hour), 2);
      expect(durationPartValue(duration, DurationPart.minute), 2);
      expect(durationPartValue(duration, DurationPart.second), 1);
    });
  });
}

final DateTime _fixedDate = DateTime(2024, 2, 29);
