// The `calendar-02` block: a scheduling panel.
//
// A month calendar with the selected day's agenda beside it (below 960px the
// agenda moves under the calendar). Time slots are plain buttons so the block
// needs no extra component beyond `calendar`, `card` and `button`.

import 'package:flutter/widgets.dart';

import '../../components/button/button.dart';
import '../../components/calendar/calendar.dart';
import '../../components/card/card.dart';
import '../../components/divider/divider.dart';
import '../../foundation/gap.dart';
import '../../primitives/date_math.dart';
import '../../theme/theme.dart';

/// A scheduling panel: a month calendar and the selected day's agenda.
class Calendar02 extends StatefulWidget {
  /// Creates the block.
  const Calendar02({super.key});

  @override
  State<Calendar02> createState() => _Calendar02State();
}

class _Calendar02State extends State<Calendar02> {
  final DateTime _today = DateTime(2026, 10, 10);
  CalendarView _view = const CalendarView(2026, 10);
  CalendarValue? _value;

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    final spacing = theme.spacing;
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
                  Gap(spacing.lg),
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
            final Widget agenda = const _Calendar02Agenda();
            if (!aside) {
              return SingleChildScrollView(
                padding: EdgeInsets.all(spacing.lg),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[calendar, Gap(spacing.lg), agenda],
                ),
              );
            }
            return Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(spacing.xl),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1080),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(flex: 3, child: calendar),
                      Gap(spacing.xl),
                      Expanded(flex: 2, child: agenda),
                    ],
                  ),
                ),
              ),
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
    final theme = ShadcnTheme.of(context);
    final spacing = theme.spacing;
    return Row(
      children: <Widget>[
        Expanded(
          child: Text(
            '${_monthName(view.month)} ${view.year}',
            style: theme.typography.textLarge,
          ),
        ),
        Gap(spacing.md),
        _Calendar02Step(label: '<', tooltip: 'Previous', onPressed: onPrevious),
        Gap(spacing.sm),
        _Calendar02Step(label: '>', tooltip: 'Next', onPressed: onNext),
      ],
    );
  }
}

class _Calendar02Step extends StatelessWidget {
  const _Calendar02Step({
    required this.label,
    required this.tooltip,
    required this.onPressed,
  });

  final String label;
  final String tooltip;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 28,
        height: 28,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border.all(color: theme.colors.border),
          borderRadius: theme.borderRadiusSm,
        ),
        child: Text(
          label,
          style: theme.typography.textSmall,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class _Calendar02Agenda extends StatelessWidget {
  const _Calendar02Agenda();

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    final spacing = theme.spacing;
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text('Saturday, 10 October', style: theme.typography.h3),
          Gap(spacing.sm),
          Text(
            'Four slots left, 30 minutes each.',
            style: theme.typography.textSmall.copyWith(
              color: theme.colors.mutedForeground,
            ),
          ),
          Gap(spacing.lg),
          const _Calendar02Slots(),
          Gap(spacing.lg),
          const Divider(),
          Gap(spacing.lg),
          const _Calendar02Booking(),
        ],
      ),
    );
  }
}

class _Calendar02Slots extends StatelessWidget {
  const _Calendar02Slots();

  @override
  Widget build(BuildContext context) {
    final spacing = ShadcnTheme.of(context).spacing;
    return Wrap(
      spacing: spacing.sm,
      runSpacing: spacing.sm,
      children: const <Widget>[
        _Calendar02Slot('09:00', taken: true),
        _Calendar02Slot('09:30'),
        _Calendar02Slot('10:00', taken: true),
        _Calendar02Slot('10:30'),
        _Calendar02Slot('11:00'),
        _Calendar02Slot('11:30', taken: true),
      ],
    );
  }
}

class _Calendar02Slot extends StatelessWidget {
  const _Calendar02Slot(this.time, {this.taken = false});

  final String time;
  final bool taken;

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    return Button(
      variant: taken ? ButtonVariant.outline : ButtonVariant.secondary,
      enabled: !taken,
      onPressed: () {},
      child: Text(time, style: theme.typography.textSmall),
    );
  }
}

class _Calendar02Booking extends StatelessWidget {
  const _Calendar02Booking();

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Text('Calendar link', style: theme.typography.textSmall),
        Gap(theme.spacing.sm),
        Text(
          'cal.acme.com/ada-lovelace/30min',
          style: theme.typography.inlineCode.copyWith(
            color: theme.colors.mutedForeground,
          ),
        ),
        Gap(theme.spacing.lg),
        const Button(child: Text('Book a meeting')),
      ],
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
