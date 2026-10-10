// Home showcase: date and time cards (P6-H1).
//
// `Release date` and `Reporting Period` extend the Theme Studio picker
// blocks (`studio_blocks/studio_tabs.dart`); `Standup time` composes the
// registry `TimePicker` the same way.

import 'package:flutter/widgets.dart';

import '../ui/shadcn/components/button/button.dart';
import '../ui/shadcn/components/calendar/calendar.dart';
import '../ui/shadcn/components/date_picker/date_picker.dart';
import '../ui/shadcn/components/time_picker/time_picker.dart';
import '../ui/shadcn/foundation/gap.dart';
import '../ui/shadcn/foundation/icons/lucide_icons.dart';
import '../ui/shadcn/foundation/time_of_day.dart';
import '../ui/shadcn/primitives/date_math.dart';
import '../ui/shadcn/theme/theme.dart';
import 'collage_cards.dart';
import 'studio_blocks/studio_card.dart';

/// A calendar block (the reference's release-date picker).
class HomeCalendarCard extends StatefulWidget {
  /// Creates the card.
  const HomeCalendarCard({super.key});

  @override
  State<HomeCalendarCard> createState() => _HomeCalendarCardState();
}

class _HomeCalendarCardState extends State<HomeCalendarCard> {
  CalendarValue? _selected = CalendarValue.single(DateTime(2026, 5, 25));
  CalendarView _view = const CalendarView(2026, 5);

  @override
  Widget build(BuildContext context) {
    return CollageCard(
      title: 'Release date',
      subtitle: _subtitle(_selected),
      trailing: const Icon(LucideIcons.calendarDays, size: 16),
      children: <Widget>[
        // `Calendar` pitches its 7 columns off a fixed cell height, so its
        // minimum width is ~280 px. Narrow columns scroll horizontally
        // rather than overflowing.
        ScrollConfiguration(
          behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Calendar(
              view: _view,
              value: _selected,
              selectionMode: CalendarSelectionMode.single,
              onViewChanged: (CalendarView view) =>
                  setState(() => _view = view),
              onChanged: (CalendarValue? value) =>
                  setState(() => _selected = value),
            ),
          ),
        ),
      ],
    );
  }
}

/// A date-range block, the reference's reporting-period picker.
class HomeDateRangeCard extends StatefulWidget {
  /// Creates the card.
  const HomeDateRangeCard({super.key});

  @override
  State<HomeDateRangeCard> createState() => _HomeDateRangeCardState();
}

class _HomeDateRangeCardState extends State<HomeDateRangeCard> {
  DateTimeRange? _range = DateTimeRange(
    DateTime(2026, 1, 1),
    DateTime(2026, 3, 31),
  );

  @override
  Widget build(BuildContext context) {
    return CollageCard(
      title: 'Reporting Period',
      subtitle: _periodSubtitle(_range),
      children: <Widget>[
        DateRangePicker(
          value: _range,
          onChanged: (DateTimeRange? next) => setState(() => _range = next),
        ),
        const Gap(16),
        Button(
          variant: ButtonVariant.primary,
          onPressed: () {},
          child: const SizedBox(
            width: double.infinity,
            child: Text('Generate Report', textAlign: TextAlign.center),
          ),
        ),
      ],
    );
  }
}

/// `Standup time`: the registry time picker with its live value.
class HomeTimeCard extends StatefulWidget {
  /// Creates the card.
  const HomeTimeCard({super.key});

  @override
  State<HomeTimeCard> createState() => _HomeTimeCardState();
}

class _HomeTimeCardState extends State<HomeTimeCard> {
  TimeOfDay? _time = const TimeOfDay(hour: 9, minute: 30);

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    return CollageCard(
      title: 'Standup time',
      subtitle: 'Daily at ${_format(_time)}',
      trailing: Icon(
        LucideIcons.clock,
        size: 16,
        color: theme.colors.mutedForeground,
      ),
      children: <Widget>[
        const StudioFieldLabel('Time'),
        const Gap(6),
        TimePicker(
          value: _time,
          use24HourFormat: true,
          onChanged: (TimeOfDay? next) => setState(() => _time = next),
        ),
        const Gap(12),
        const StudioHelper('The team meets every weekday morning.'),
      ],
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
  return date == null ? 'No date picked' : _formatDate(date);
}

String _periodSubtitle(DateTimeRange? range) {
  if (range == null) {
    return 'No period selected';
  }
  return '${_formatDate(range.start)} – ${_formatDate(range.end)}';
}

String _formatDate(DateTime date) => '${date.day}/${date.month}/${date.year}';

String _format(TimeOfDay? time) {
  if (time == null) {
    return '—';
  }
  final String hour = time.hour.toString().padLeft(2, '0');
  final String minute = time.minute.toString().padLeft(2, '0');
  return '$hour:$minute';
}
