// The `calendar-02` block: a scheduling panel.
//
// A block is layer 4 of the registry: it may import foundation, theme,
// primitives and components, never another block. Its public widget is the
// preview - the docs page renders it exactly as an app would.
//
// A month calendar with the selected day's agenda beside it (below 960px the
// agenda moves under the calendar). Time slots are selectable buttons; the
// Book action enables once a slot is picked. The content shrink-wraps so the
// docs frame sizes to its intrinsic height, and scrolls internally when the
// host is bounded.

import 'package:flutter/widgets.dart';

import '../../components/button/button.dart';
import '../../components/calendar/calendar.dart';
import '../../components/card/card.dart';
import '../../components/divider/divider.dart';
import '../../foundation/gap.dart';
import '../../foundation/icons/lucide_icons.dart';
import '../../primitives/date_math.dart';
import '../../theme/theme.dart';

/// A scheduling panel: a month calendar and the selected day's agenda.
class Calendar02 extends StatefulWidget {
  /// Creates the block.
  const Calendar02({super.key, this.onBook});

  /// Called with the picked slot label when "Book a meeting" is tapped.
  final ValueChanged<String>? onBook;

  @override
  State<Calendar02> createState() => _Calendar02State();
}

class _Calendar02State extends State<Calendar02> {
  final DateTime _today = DateTime(2026, 10, 10);
  CalendarView _view = const CalendarView(2026, 10);
  CalendarValue? _value;
  String? _slot;

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    return ColoredBox(
      color: theme.colors.background,
      child: SafeArea(
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final bool aside = constraints.maxWidth >= 960;
            final Widget calendar = Card(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  _Calendar02Header(
                    view: _view,
                    onPrevious: () => setState(() => _view = _view.previous),
                    onNext: () => setState(() => _view = _view.next),
                  ),
                  Gap(theme.spacing.lg),
                  Calendar(
                    view: _view,
                    now: _today,
                    selectionMode: CalendarSelectionMode.single,
                    value: _value,
                    onChanged: (CalendarValue? value) =>
                        setState(() => _value = value),
                  ),
                ],
              ),
            );
            final Widget agenda = _Calendar02Agenda(
              slot: _slot,
              onSlot: (String slot) => setState(() => _slot = slot),
              onBook: () {
                final String? picked = _slot;
                if (picked != null) {
                  widget.onBook?.call(picked);
                }
              },
            );
            final Widget body;
            if (!aside) {
              body = Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[calendar, Gap(theme.spacing.lg), agenda],
              );
            } else {
              body = Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1080),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(flex: 3, child: calendar),
                      Gap(theme.spacing.xl),
                      Expanded(flex: 2, child: agenda),
                    ],
                  ),
                ),
              );
            }
            if (!constraints.maxHeight.isFinite) {
              return Padding(
                padding: EdgeInsets.all(theme.spacing.lg),
                child: body,
              );
            }
            return SingleChildScrollView(
              padding: EdgeInsets.all(theme.spacing.lg),
              child: body,
            );
          },
        ),
      ),
    );
  }
}

class _Calendar02Header extends StatelessWidget {
  const _Calendar02Header({
    required this.view,
    required this.onPrevious,
    required this.onNext,
  });

  final CalendarView view;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    return Row(
      children: <Widget>[
        Expanded(
          child: Text(
            '${_monthName(view.month)} ${view.year}',
            style: theme.typography.textLarge,
          ),
        ),
        Gap(theme.spacing.md),
        _Calendar02Step(icon: LucideIcons.chevronLeft, onPressed: onPrevious),
        Gap(theme.spacing.sm),
        _Calendar02Step(icon: LucideIcons.chevronRight, onPressed: onNext),
      ],
    );
  }
}

class _Calendar02Step extends StatelessWidget {
  const _Calendar02Step({required this.icon, required this.onPressed});

  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Button(
      variant: ButtonVariant.ghost,
      size: ButtonSize.icon,
      onPressed: onPressed,
      child: Icon(icon, size: 16),
    );
  }
}

class _Calendar02Agenda extends StatelessWidget {
  const _Calendar02Agenda({
    required this.slot,
    required this.onSlot,
    required this.onBook,
  });

  /// The picked slot label, or null when nothing is picked yet.
  final String? slot;
  final ValueChanged<String> onSlot;
  final VoidCallback onBook;

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text('Saturday, 10 October', style: theme.typography.h3),
          Gap(theme.spacing.sm),
          Text(
            slot == null
                ? 'Four slots left, 30 minutes each. Pick one.'
                : 'Picked $slot, 30 minutes.',
            style: theme.typography.textSmall.copyWith(
              color: theme.colors.mutedForeground,
            ),
          ),
          Gap(theme.spacing.lg),
          _Calendar02Slots(slot: slot, onSlot: onSlot),
          Gap(theme.spacing.lg),
          const Divider(),
          Gap(theme.spacing.lg),
          Text('Calendar link', style: theme.typography.textSmall),
          Gap(theme.spacing.sm),
          Text(
            'cal.acme.com/ada-lovelace/30min',
            style: theme.typography.inlineCode.copyWith(
              color: theme.colors.mutedForeground,
            ),
          ),
          Gap(theme.spacing.lg),
          // Explicit `enabled: false` while nothing is picked: the block
          // interactivity test whitelists explicit opt-outs on this block.
          Button(
            enabled: slot != null,
            onPressed: onBook,
            child: const Text('Book a meeting'),
          ),
        ],
      ),
    );
  }
}

class _Calendar02Slots extends StatelessWidget {
  const _Calendar02Slots({required this.slot, required this.onSlot});

  final String? slot;
  final ValueChanged<String> onSlot;

  @override
  Widget build(BuildContext context) {
    final double spacing = ShadcnTheme.of(context).spacing.sm;
    return Wrap(
      spacing: spacing,
      runSpacing: spacing,
      children: <Widget>[
        for (final _Calendar02SlotData data in const <_Calendar02SlotData>[
          _Calendar02SlotData('09:00', taken: true),
          _Calendar02SlotData('09:30'),
          _Calendar02SlotData('10:00', taken: true),
          _Calendar02SlotData('10:30'),
          _Calendar02SlotData('11:00'),
          _Calendar02SlotData('11:30', taken: true),
        ])
          _Calendar02Slot(
            time: data.time,
            taken: data.taken,
            selected: slot == data.time,
            onPressed: () => onSlot(data.time),
          ),
      ],
    );
  }
}

class _Calendar02SlotData {
  const _Calendar02SlotData(this.time, {this.taken = false});

  final String time;
  final bool taken;
}

class _Calendar02Slot extends StatelessWidget {
  const _Calendar02Slot({
    required this.time,
    required this.taken,
    required this.selected,
    required this.onPressed,
  });

  final String time;
  final bool taken;
  final bool selected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    return Button(
      variant: taken
          ? ButtonVariant.outline
          : selected
          ? ButtonVariant.primary
          : ButtonVariant.secondary,
      enabled: !taken,
      onPressed: onPressed,
      child: Text(time, style: theme.typography.textSmall),
    );
  }
}

String _monthName(int month) => switch (month) {
  1 => 'January',
  2 => 'February',
  3 => 'March',
  4 => 'April',
  5 => 'May',
  6 => 'June',
  7 => 'July',
  8 => 'August',
  9 => 'September',
  10 => 'October',
  11 => 'November',
  12 => 'December',
  _ => 'Month $month',
};
