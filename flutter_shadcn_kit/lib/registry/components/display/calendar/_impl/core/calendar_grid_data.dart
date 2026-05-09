// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../calendar.dart';

/// Core class used by the calendar component.
class CalendarGridData {
  /// The month number (1-12) this grid represents.
  final int month;

  /// The year this grid represents.
  final int year;

  /// The list of calendar grid items including current and adjacent month dates.
  final List<CalendarGridItem> items;

  /// Creates calendar grid data for the specified month and year.
  ///
  /// Automatically calculates and includes dates from previous and next months
  /// to fill complete weeks in the grid.
  factory CalendarGridData({required int month, required int year}) {
    DateTime firstDayOfMonth = DateTime(year, month, 1);
    int daysInMonth = DateTime(year, month == 12 ? 1 : month + 1, 0).day;

    int prevMonthDays = firstDayOfMonth.weekday;
    DateTime prevMonthLastDay = firstDayOfMonth.subtract(
      Duration(days: prevMonthDays),
    );

    List<CalendarGridItem> items = [];

    int itemCount = 0;

    if (prevMonthDays < 7) {
      for (int i = 0; i < prevMonthDays; i++) {
        int currentItemIndex = itemCount++;

        items.add(
          CalendarGridItem(
            prevMonthLastDay.add(Duration(days: i)),
            currentItemIndex % 7,
            true,
            currentItemIndex ~/ 7,
          ),
        );
      }
    }

    for (int i = 0; i < daysInMonth; i++) {
      int currentItemIndex = itemCount++;
      DateTime currentDay = DateTime(year, month, i + 1);

      items.add(
        CalendarGridItem(
          currentDay,
          currentItemIndex % 7,
          false,
          currentItemIndex ~/ 7,
        ),
      );
    }

    int remainingDays = (7 - (items.length % 7)) % 7;
    DateTime nextMonthFirstDay = DateTime(year, month + 1, 1);

    if (remainingDays < 7) {
      for (int i = 0; i < remainingDays; i++) {
        int currentItemIndex = itemCount++;

        items.add(
          CalendarGridItem(
            nextMonthFirstDay.add(Duration(days: i)),
            currentItemIndex % 7,
            true,
            currentItemIndex ~/ 7,
          ),
        );
      }
    }

    return CalendarGridData._(month, year, items);
  }

  CalendarGridData._(this.month, this.year, this.items);

  /// Compares two calendar values for structural equality.
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CalendarGridData &&
        other.month == month &&
        other.year == year &&
        listEquals(other.items, items);
  }

  /// State flag that toggles specific calendar behavior.
  @override
  int get hashCode => Object.hash(month, year, items);
}
