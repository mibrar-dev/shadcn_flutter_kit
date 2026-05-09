// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../calendar.dart';

/// Core class used by the calendar component.
class Calendar extends StatefulWidget {
  /// The current date for highlighting purposes (defaults to DateTime.now()).
  final DateTime? now;

  /// The currently selected date value(s).
  final CalendarValue? value;

  /// The month and year view to display in the calendar.
  final CalendarView view;

  /// The selection mode determining how dates can be selected.
  final CalendarSelectionMode selectionMode;

  /// Callback invoked when the selected date(s) change.
  final ValueChanged<CalendarValue?>? onChanged;

  /// Legacy function to determine if a date should be enabled.
  final bool Function(DateTime date)? isDateEnabled;

  /// Builder function to determine the state of each date.
  final DateStateBuilder? stateBuilder;

  /// Creates a [Calendar] widget with flexible date selection capabilities.
  ///
  /// Configures the calendar's view, selection behavior, and interaction handling
  /// with comprehensive options for customization and validation.
  ///
  /// Parameters:
  /// - [view] (CalendarView, required): Month/year to display in calendar grid
  /// - [selectionMode] (CalendarSelectionMode, required): How dates can be selected
  /// - [now] (DateTime?, optional): Current date for highlighting, defaults to DateTime.now()
  /// - [value] (CalendarValue?, optional): Currently selected date(s)
  /// - [onChanged] (`ValueChanged<CalendarValue>?`, optional): Called when selection changes
  /// - [isDateEnabled] (bool Function(DateTime)?, optional): Legacy date validation function
  /// - [stateBuilder] (DateStateBuilder?, optional): Custom date state validation
  ///
  /// The [view] parameter determines which month and year are shown in the calendar grid.
  /// Use [CalendarView.now()] for current month or [CalendarView(year, month)] for specific dates.
  ///
  /// The [stateBuilder] takes precedence over [isDateEnabled] when both are provided.
  ///
  /// Example:
  /// ```dart
  /// Calendar(
  ///   view: CalendarView(2024, 3), // March 2024
  ///   selectionMode: CalendarSelectionMode.single,
  ///   onChanged: (value) => print('Selected: ${value?.toString()}'),
  ///   stateBuilder: (date) => date.weekday == DateTime.sunday
  ///     ? DateState.disabled
  ///     : DateState.enabled,
  /// )
  /// ```
  const Calendar({
    super.key,
    this.now,
    this.value,
    required this.view,
    required this.selectionMode,
    this.onChanged,
    this.isDateEnabled,
    this.stateBuilder,
  });

  /// Creates the State object used by this calendar widget.
  @override
  State<Calendar> createState() => _CalendarState();
}

/// A calendar widget that displays months in a year grid.
///
/// Shows a 4x3 grid of months for year selection. Used as part of the calendar
/// navigation when users want to select a different month.
