// The tabs and calendar blocks of the Theme Studio canvas (spec §2.7).
//
// `Tabs` and `Calendar` are registry components; the calendar block is what
// makes the `accent`, `ring`, `border` and radius edits visible on a dense
// interactive surface the way the reference's date picker is.

import 'package:flutter/widgets.dart';

import '../../ui/shadcn/components/calendar/calendar.dart';
import '../../ui/shadcn/primitives/date_math.dart';
import '../../ui/shadcn/components/tabs/tabs.dart';
import '../../ui/shadcn/foundation/gap.dart';
import '../../ui/shadcn/theme/theme.dart';
import 'studio_card.dart';

/// A three-tab block with a live body, so radius/spacing edits show up in the
/// tab strip as well as the body.
class StudioTabsCard extends StatefulWidget {
  /// Creates the card.
  const StudioTabsCard({super.key});

  @override
  State<StudioTabsCard> createState() => _StudioTabsCardState();
}

class _StudioTabsCardState extends State<StudioTabsCard> {
  static const List<String> labels = <String>[
    'Overview',
    'Activity',
    'Settings',
  ];
  static const List<String> bodies = <String>[
    'Net revenue for the selected period, after fees.',
    'Twelve payouts settled in the last 30 days.',
    'Where the balance is routed once it clears.',
  ];

  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    return StudioCard(
      title: 'Payouts',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Tabs(
            index: _index,
            expand: true,
            onChanged: (int index) => setState(() => _index = index),
            children: <TabItem>[
              for (final String label in labels) TabItem(child: Text(label)),
            ],
          ),
          const Gap(12),
          Text(
            bodies[_index],
            style: theme.typography.small.copyWith(
              color: theme.colors.mutedForeground,
            ),
          ),
        ],
      ),
    );
  }
}

/// A calendar block (the reference's release-date picker).
class StudioCalendarCard extends StatefulWidget {
  /// Creates the card.
  const StudioCalendarCard({super.key});

  @override
  State<StudioCalendarCard> createState() => _StudioCalendarCardState();
}

class _StudioCalendarCardState extends State<StudioCalendarCard> {
  CalendarValue? _selected = CalendarValue.single(DateTime(2026, 5, 25));
  CalendarView _view = const CalendarView(2026, 5);

  @override
  Widget build(BuildContext context) {
    return StudioCard(
      title: 'Release date',
      subtitle: _subtitle(_selected),
      child: Calendar(
        view: _view,
        value: _selected,
        selectionMode: CalendarSelectionMode.single,
        onViewChanged: (CalendarView view) => setState(() => _view = view),
        onChanged: (CalendarValue? value) => setState(() => _selected = value),
      ),
    );
  }
}

String _subtitle(CalendarValue? value) {
  final DateTime? date = switch (value) {
    SingleCalendarValue(date: final DateTime picked) => picked,
    MultiCalendarValue(dates: final List<DateTime> picked) =>
      picked.isEmpty ? null : picked.first,
    _ => null,
  };
  if (date == null) {
    return 'No date picked';
  }
  return '${date.day}/${date.month}/${date.year}';
}
