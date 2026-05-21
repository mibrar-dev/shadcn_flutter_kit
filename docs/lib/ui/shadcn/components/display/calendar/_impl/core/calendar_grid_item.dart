// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../calendar.dart';

/// Individual item within a calendar grid representing a single date cell.
///
/// Contains metadata about a date's position and state within the calendar grid.
class CalendarGridItem {
  /// The date this grid item represents.
  final DateTime date;

  /// The index of this item within its row (0-6 for day of week).
  final int indexInRow;

  /// The row index in the calendar grid.
  final int rowIndex;

  /// Whether this date belongs to a different month than the grid's primary month.
  final bool fromAnotherMonth;

  /// Creates a calendar grid item.
  CalendarGridItem(
    this.date,
    this.indexInRow,
    this.fromAnotherMonth,
    this.rowIndex,
  );

  /// Returns true if this item represents today's date.
  bool get isToday {
    DateTime now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  /// Compares two calendar values for structural equality.
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CalendarGridItem &&
        other.date.isAtSameMomentAs(date) &&
        other.indexInRow == indexInRow &&
        other.fromAnotherMonth == fromAnotherMonth &&
        other.rowIndex == rowIndex;
  }

  /// State flag that toggles specific calendar behavior.
  @override
  int get hashCode => Object.hash(date, indexInRow, fromAnotherMonth, rowIndex);
}
