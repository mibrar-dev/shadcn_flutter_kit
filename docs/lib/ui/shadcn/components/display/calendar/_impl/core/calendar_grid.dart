// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../calendar.dart';

/// Widget that renders a calendar grid using provided data.
///
/// Takes calendar grid data and an item builder to render the visual grid
/// of calendar dates. Handles layout and arrangement of dates in a weekly grid.
class CalendarGrid extends StatelessWidget {
  /// The grid data containing all calendar items to display.
  final CalendarGridData data;

  /// Builder function to create widgets for each grid item.
  final Widget Function(CalendarGridItem item) itemBuilder;

  /// Creates a calendar grid widget.
  const CalendarGrid({
    super.key,
    required this.data,
    required this.itemBuilder,
  });

  /// Builds the widget tree for calendar.
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localizations = ShadcnLocalizations.of(context);
    // return GridView.builder(
    //   shrinkWrap: true,
    //   itemCount: data.items.length,
    //   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    //     crossAxisCount: 7,
    //     mainAxisSpacing: 0,
    //     crossAxisSpacing: 8 * theme.scaling,
    //   ),
    //   itemBuilder: (context, index) {
    //     return SizedBox(
    //       width: theme.scaling * 32,
    //       height: theme.scaling * 32,
    //       child: itemBuilder(data.items[index]),
    //     );
    //   },
    // );
    // do not use GridView because it doesn't support IntrinsicWidth
    List<Widget> rows = [];

    List<Widget> weekDays = [];
    for (int i = 0; i < 7; i++) {
      int weekday = ((i - 1) % 7) + 1;

      weekDays.add(
        Container(
          width: theme.scaling * 32,
          height: theme.scaling * 32,
          alignment: Alignment.center,
          child: Text(
            localizations.getAbbreviatedWeekday(weekday),
          ).muted().xSmall(),
        ),
      );
    }
    rows.add(Row(mainAxisSize: MainAxisSize.min, children: weekDays));
    for (int i = 0; i < data.items.length; i += 7) {
      rows.add(
        Row(
          mainAxisSize: MainAxisSize.min,
          children: data.items.sublist(i, i + 7).map((e) {
            return SizedBox(
              width: theme.scaling * 32,
              height: theme.scaling * 32,
              child: itemBuilder(e),
            );
          }).toList(),
        ),
      );
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      spacing: theme.density.baseGap * theme.scaling * gapSm,
      children: rows,
    );
  }
}
