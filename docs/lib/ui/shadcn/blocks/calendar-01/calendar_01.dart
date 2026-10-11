// The `calendar-01` block: a date-range picker card.
//
// A block is layer 4 of the registry: it may import foundation, theme,
// primitives and components, never another block. Its public widget is the
// preview - the docs page renders it exactly as an app would.
//
// A two-month range calendar (one month on a phone), a live range summary
// and footer actions. `Calendar` owns no navigation, so the block drives the
// `CalendarView` itself. The card is capped at 720px and centres itself; the
// content shrink-wraps so the docs frame sizes to its intrinsic height, and
// scrolls internally when the host is bounded.

import 'package:flutter/widgets.dart';

import '../../components/button/button.dart';
import '../../components/calendar/calendar.dart';
import '../../components/card/card.dart';
import '../../components/divider/divider.dart';
import '../../foundation/gap.dart';
import '../../foundation/icons/lucide_icons.dart';
import '../../primitives/date_math.dart';
import '../../theme/theme.dart';

/// A date-range card: the calendar, a range summary and footer actions.
class Calendar01 extends StatefulWidget {
  /// Creates the block.
  const Calendar01({super.key, this.onApply, this.onClear});

  /// Called with the current range when Apply is tapped.
  final ValueChanged<CalendarValue?>? onApply;

  /// Called when Clear resets the selection.
  final VoidCallback? onClear;

  @override
  State<Calendar01> createState() => _Calendar01State();
}

class _Calendar01State extends State<Calendar01> {
  CalendarView _view = const CalendarView(2026, 10);
  CalendarValue? _value;

  void _shift(int months) {
    setState(() => _view = months < 0 ? _view.previous : _view.next);
  }

  void _clear() {
    setState(() => _value = null);
    widget.onClear?.call();
  }

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    final Widget body = Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 720),
        child: Card(
          padding: EdgeInsets.all(theme.spacing.lg),
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              final bool twoMonths = constraints.maxWidth >= 720;
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  _Calendar01Header(
                    view: _view,
                    twoMonths: twoMonths,
                    onShift: _shift,
                  ),
                  Gap(theme.spacing.lg),
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
                        Gap(theme.spacing.xl),
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
                  Gap(theme.spacing.lg),
                  const Divider(),
                  Gap(theme.spacing.lg),
                  _Calendar01Footer(
                    value: _value,
                    onClear: _clear,
                    onApply: () => widget.onApply?.call(_value),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
    return ColoredBox(
      color: theme.colors.background,
      child: SafeArea(
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
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
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    final String months = twoMonths
        ? '${_monthName(view.month)} - ${_monthName(view.next.month)} '
              '${view.next.year}'
        : '${_monthName(view.month)} ${view.year}';
    return Row(
      children: <Widget>[
        Expanded(child: Text(months, style: theme.typography.textLarge)),
        Gap(theme.spacing.md),
        _Calendar01Step(
          icon: LucideIcons.chevronLeft,
          onPressed: () => onShift(-1),
        ),
        Gap(theme.spacing.sm),
        _Calendar01Step(
          icon: LucideIcons.chevronRight,
          onPressed: () => onShift(1),
        ),
      ],
    );
  }
}

class _Calendar01Step extends StatelessWidget {
  const _Calendar01Step({required this.icon, required this.onPressed});

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
  const _Calendar01Footer({
    required this.value,
    required this.onClear,
    required this.onApply,
  });

  final CalendarValue? value;
  final VoidCallback onClear;
  final VoidCallback onApply;

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    return Row(
      children: <Widget>[
        Expanded(
          child: Text(
            _summary(value),
            style: theme.typography.textSmall.copyWith(
              color: theme.colors.mutedForeground,
            ),
          ),
        ),
        Gap(theme.spacing.md),
        Button(
          variant: ButtonVariant.outline,
          onPressed: onClear,
          child: const Text('Clear'),
        ),
        Gap(theme.spacing.sm),
        Button(onPressed: onApply, child: const Text('Apply')),
      ],
    );
  }
}

/// The live range summary for the footer.
String _summary(CalendarValue? value) {
  final CalendarValue? current = value;
  if (current is RangeCalendarValue) {
    final int nights = current.end.difference(current.start).inDays;
    if (nights <= 0) {
      return 'Same-day stay';
    }
    return 'Your stay: $nights night${nights == 1 ? '' : 's'}';
  }
  if (current is SingleCalendarValue) {
    return 'Picked ${_monthName(current.date.month)} ${current.date.day} — '
        'extend it into a range';
  }
  return 'Pick a date range';
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
