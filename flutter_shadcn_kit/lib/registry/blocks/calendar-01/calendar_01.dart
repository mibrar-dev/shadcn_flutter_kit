// The `calendar-01` block: a date-range picker card.
//
// A two-month range calendar (one month on a phone), a visible range summary
// and the shadcn date-range card footer. `Calendar` owns no navigation, so
// the block drives the `CalendarView` itself.

import 'package:flutter/widgets.dart';

import '../../components/button/button.dart';
import '../../components/calendar/calendar.dart';
import '../../components/card/card.dart';
import '../../components/divider/divider.dart';
import '../../foundation/gap.dart';
import '../../primitives/date_math.dart';
import '../../theme/theme.dart';

/// A date-range card: the calendar, a range summary and footer actions.
class Calendar01 extends StatefulWidget {
  /// Creates the block.
  const Calendar01({super.key});

  @override
  State<Calendar01> createState() => _Calendar01State();
}

class _Calendar01State extends State<Calendar01> {
  CalendarView _view = const CalendarView(2026, 10);
  CalendarValue? _value;

  void _shift(int months) {
    setState(() => _view = months < 0 ? _view.previous : _view.next);
  }

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    final spacing = theme.spacing;
    return ColoredBox(
      color: theme.colors.background,
      child: SafeArea(
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final bool twoMonths = constraints.maxWidth >= 720;
            return Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(spacing.lg),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 720),
                  child: Card(
                    padding: EdgeInsets.all(spacing.lg),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        _Calendar01Header(
                          view: _view,
                          twoMonths: twoMonths,
                          onShift: _shift,
                        ),
                        Gap(spacing.lg),
                        if (twoMonths)
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                child: _Calendar01Month(
                                  view: _view,
                                  value: _value,
                                  onChanged: (CalendarValue? value) =>
                                      setState(() => _value = value),
                                ),
                              ),
                              Gap(spacing.xl),
                              Expanded(
                                child: _Calendar01Month(
                                  view: _view.next,
                                  value: _value,
                                  onChanged: (CalendarValue? value) =>
                                      setState(() => _value = value),
                                ),
                              ),
                            ],
                          )
                        else
                          _Calendar01Month(
                            view: _view,
                            value: _value,
                            onChanged: (CalendarValue? value) =>
                                setState(() => _value = value),
                          ),
                        Gap(spacing.lg),
                        const Divider(),
                        Gap(spacing.lg),
                        const _Calendar01Footer(),
                      ],
                    ),
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

class _Calendar01Header extends StatelessWidget {
  const _Calendar01Header({
    required this.view,
    required this.twoMonths,
    required this.onShift,
  });

  final CalendarView view;
  final bool twoMonths;
  final ValueChanged<int> onShift;

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    final spacing = theme.spacing;
    final months = twoMonths
        ? '${_monthName(view.month)} - ${_monthName(view.next.month)} ${view.next.year}'
        : '${_monthName(view.month)} ${view.year}';
    return Row(
      children: <Widget>[
        Expanded(child: Text(months, style: theme.typography.textLarge)),
        Gap(spacing.md),
        _Calendar01Step(
          label: '<',
          tooltip: 'Previous month',
          onPressed: () => onShift(-1),
        ),
        Gap(spacing.sm),
        _Calendar01Step(
          label: '>',
          tooltip: 'Next month',
          onPressed: () => onShift(1),
        ),
      ],
    );
  }
}

class _Calendar01Step extends StatelessWidget {
  const _Calendar01Step({
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

class _Calendar01Month extends StatelessWidget {
  const _Calendar01Month({
    required this.view,
    required this.value,
    required this.onChanged,
  });

  final CalendarView view;
  final CalendarValue? value;
  final ValueChanged<CalendarValue?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Calendar(
      view: view,
      now: DateTime(2026, 10, 10),
      selectionMode: CalendarSelectionMode.range,
      value: value,
      onChanged: onChanged,
    );
  }
}

class _Calendar01Footer extends StatelessWidget {
  const _Calendar01Footer();

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    final spacing = theme.spacing;
    return Row(
      children: <Widget>[
        Expanded(
          child: Text(
            'Your stay: 7 nights',
            style: theme.typography.textSmall.copyWith(
              color: theme.colors.mutedForeground,
            ),
          ),
        ),
        Gap(spacing.md),
        Button(
          variant: ButtonVariant.outline,
          onPressed: () {},
          child: const Text('Clear'),
        ),
        Gap(spacing.sm),
        Button(onPressed: () {}, child: const Text('Apply')),
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
