// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../calendar.dart';

/// Core class used by the calendar component.
class MonthCalendar extends StatelessWidget {
  /// The current calendar view (year to display).
  final CalendarView value;

  /// Callback invoked when a month is selected.
  final ValueChanged<CalendarView> onChanged;

  /// The current date for highlighting purposes.
  final DateTime? now;

  /// The currently selected calendar value.
  final CalendarValue? calendarValue;

  /// Builder function to determine the state of each month.
  final DateStateBuilder? stateBuilder;

  /// Creates a month selection calendar.
  const MonthCalendar({
    super.key,
    required this.value,
    required this.onChanged,
    this.now,
    this.calendarValue,
    this.stateBuilder,
  });

  /// Builds the widget tree for calendar.
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // same as Calendar, but instead of showing date
    // it shows month in a 4x3 grid
    ShadcnLocalizations localizations = ShadcnLocalizations.of(context);

    List<Widget> rows = [];

    List<Widget> months = [];
    for (int i = 1; i <= 12; i++) {
      DateTime date = DateTime(value.year, i);

      CalendarItemType type = CalendarItemType.none;
      if (calendarValue != null) {
        final lookup = calendarValue!.lookup(date.year, date.month);
        switch (lookup) {
          case CalendarValueLookup.none:
            if (now != null &&
                /// Implements `DateTime` behavior for calendar.
                DateTime(now!.year, now!.month).isAtSameMomentAs(date)) {
              type = CalendarItemType.today;
            }
            break;
          case CalendarValueLookup.selected:
            type = CalendarItemType.selected;
            break;
          case CalendarValueLookup.start:
            type = CalendarItemType.startRangeSelected;
            break;
          case CalendarValueLookup.end:
            type = CalendarItemType.endRangeSelected;
            break;
          case CalendarValueLookup.inRange:
            type = CalendarItemType.inRange;
            break;
        }
      } else {
        if (now != null &&
            /// Implements `DateTime` behavior for calendar.
            DateTime(now!.year, now!.month).isAtSameMomentAs(date)) {
          type = CalendarItemType.today;
        }
      }

      months.add(
        CalendarItem(
          key: ValueKey(date),
          type: type,
          indexAtRow: (i - 1) % 4,
          rowCount: 4,
          onTap: () {
            /// Implements `onChanged` behavior for calendar.
            onChanged(value.copyWith(month: () => i));
          },
          width: theme.scaling * 56,
          state: stateBuilder?.call(date) ?? DateState.enabled,
          child: Text(localizations.getAbbreviatedMonth(i)),
        ),
      );
    }
    for (int i = 0; i < months.length; i += 4) {
      rows.add(SizedBox(height: theme.density.baseGap * theme.scaling * gapSm));
      rows.add(Row(children: months.sublist(i, i + 4)));
    }
    return Column(mainAxisSize: MainAxisSize.min, children: rows);
  }
}

/// Visual states for individual calendar date items.
///
/// Defines the different visual appearances and behaviors that calendar date cells
/// can have based on their selection state and position within ranges.
