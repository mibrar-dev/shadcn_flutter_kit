// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../calendar.dart';

/// A calendar widget that displays years in a grid.
///
/// Shows a 4x4 grid of years for year selection. Used as part of the calendar
/// navigation when users want to select a different year.
class YearCalendar extends StatelessWidget {
  /// The starting year for the grid display.
  final int yearSelectStart;

  /// The currently selected year value.
  final int value;

  /// Callback invoked when a year is selected.
  final ValueChanged<int> onChanged;

  /// The current date for highlighting purposes.
  final DateTime? now;

  /// The currently selected calendar value.
  final CalendarValue? calendarValue;

  /// Builder function to determine the state of each year.
  final DateStateBuilder? stateBuilder;

  /// Creates a year selection calendar.
  const YearCalendar({
    super.key,
    required this.yearSelectStart,
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
    // it shows year in a 4x4 grid
    List<Widget> rows = [];

    List<Widget> years = [];
    for (int i = yearSelectStart; i < yearSelectStart + 16; i++) {
      DateTime date = DateTime(i);

      CalendarItemType type = CalendarItemType.none;
      if (calendarValue != null) {
        final lookup = calendarValue!.lookup(date.year);
        switch (lookup) {
          case CalendarValueLookup.none:
            if (now != null && now!.year == date.year) {
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
        if (now != null && now!.year == date.year) {
          type = CalendarItemType.today;
        }
      }

      years.add(
        CalendarItem(
          key: ValueKey(date),
          type: type,
          indexAtRow: (i - yearSelectStart) % 4,
          rowCount: 4,
          onTap: () {
            onChanged(i);
          },
          width: theme.scaling * 56,
          state: stateBuilder?.call(date) ?? DateState.enabled,
          child: Text('$i'),
        ),
      );
    }
    for (int i = 0; i < years.length; i += 4) {
      rows.add(SizedBox(height: theme.density.baseGap * theme.scaling * gapSm));
      rows.add(Row(children: years.sublist(i, i + 4)));
    }
    return Column(mainAxisSize: MainAxisSize.min, children: rows);
  }
}
