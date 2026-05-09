// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../calendar.dart';

/// Core class used by the calendar component.
class CalendarView {
  /// The year component of this view.
  final int year;

  /// The month component of this view (1-12).
  final int month;

  /// Creates a [CalendarView] for the specified year and month.
  ///
  /// Parameters:
  /// - [year] (int): Four-digit year value
  /// - [month] (int): Month number (1-12, where 1 = January)
  ///
  /// Throws [AssertionError] if month is not between 1 and 12.
  ///
  /// Example:
  /// ```dart
  /// final view = CalendarView(2024, 3); // March 2024
  /// ```
  CalendarView(this.year, this.month) {
    assert(month >= 1 && month <= 12, 'Month must be between 1 and 12');
  }

  /// Creates a [CalendarView] for the current month and year.
  ///
  /// Uses [DateTime.now()] to determine the current date and extracts
  /// the year and month components.
  ///
  /// Example:
  /// ```dart
  /// final currentView = CalendarView.now();
  /// ```
  factory CalendarView.now() {
    DateTime now = DateTime.now();
    return CalendarView(now.year, now.month);
  }

  /// Creates a [CalendarView] from an existing [DateTime].
  ///
  /// Extracts the year and month components from the provided [DateTime]
  /// and creates a corresponding calendar view.
  ///
  /// Parameters:
  /// - [dateTime] (DateTime): Date to extract year and month from
  ///
  /// Example:
  /// ```dart
  /// final birthday = DateTime(1995, 7, 15);
  /// final view = CalendarView.fromDateTime(birthday); // July 1995
  /// ```
  factory CalendarView.fromDateTime(DateTime dateTime) {
    return CalendarView(dateTime.year, dateTime.month);
  }

  /// Returns a view for the next month.
  ///
  /// Advances to the next month, rolling over to January of the next year
  /// if the current month is December.
  CalendarView get next {
    if (month == 12) {
      return CalendarView(year + 1, 1);
    }
    return CalendarView(year, month + 1);
  }

  /// Returns a view for the previous month.
  ///
  /// Moves back to the previous month, rolling back to December of the previous
  /// year if the current month is January.
  CalendarView get previous {
    if (month == 1) {
      return CalendarView(year - 1, 12);
    }
    return CalendarView(year, month - 1);
  }

  /// Returns a view for the next year with the same month.
  CalendarView get nextYear {
    return CalendarView(year + 1, month);
  }

  /// Returns a view for the previous year with the same month.
  CalendarView get previousYear {
    return CalendarView(year - 1, month);
  }

  /// Returns a debug string for this calendar value.
  @override
  String toString() {
    return 'CalendarView($year, $month)';
  }

  /// Compares two calendar values for structural equality.
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CalendarView && other.year == year && other.month == month;
  }

  @override
  int get hashCode => year.hashCode ^ month.hashCode;

  /// Creates a copy of this view with the given fields replaced.
  CalendarView copyWith({ValueGetter<int>? year, ValueGetter<int>? month}) {
    return CalendarView(
      year == null ? this.year : year(),
      month == null ? this.month : month(),
    );
  }
}

/// Extension methods on [DateTime] for calendar operations.
extension CalendarDateTime on DateTime {
  /// Converts this DateTime to a CalendarView.
  CalendarView toCalendarView() {
    return CalendarView.fromDateTime(this);
  }

  /// Converts this DateTime to a single CalendarValue.
  CalendarValue toCalendarValue() {
    return CalendarValue.single(this);
  }
}

/// A highly customizable calendar widget supporting multiple selection modes.
///
/// Displays a grid-based calendar interface allowing users to view and select dates
/// with comprehensive support for single selection, range selection, and multiple
/// date selection. Includes built-in date validation, state management, and theme integration.
///
/// Key Features:
/// - **Selection Modes**: Single date, date range, multiple dates, or display-only
/// - **Date Validation**: Custom date state builder for enabling/disabling dates
/// - **Interactive Grid**: Touch/click support with visual feedback
/// - **Theme Integration**: Follows shadcn_flutter design system
/// - **Accessibility**: Screen reader and keyboard navigation support
/// - **Customizable Appearance**: Themed colors, spacing, and visual states
///
/// The calendar automatically handles date logic, leap years, month boundaries,
/// and provides consistent visual feedback for different selection states.
///
/// Selection Behavior:
/// - **Single**: Click to select one date, click again to deselect
/// - **Range**: Click start date, then end date to form range
/// - **Multi**: Click multiple dates to build selection set
/// - **None**: Display-only mode with no interaction
///
/// Example:
/// ```dart
/// Calendar(
///   view: CalendarView.now(),
///   selectionMode: CalendarSelectionMode.range,
///   value: CalendarValue.range(startDate, endDate),
///   onChanged: (value) => setState(() => selectedDates = value),
///   stateBuilder: (date) => date.isBefore(DateTime.now())
///     ? DateState.disabled
///     : DateState.enabled,
/// )
/// ```
