// Widgets-only preview gallery for the `calendar` component.
//
// Shows the three view types, the four selection modes, a range, a disabled
// date and dark tokens.

import 'package:flutter/widgets.dart';

import '../../primitives/date_math.dart';
import '../../theme/color_tokens.dart';
import '../../theme/theme.dart';
import 'calendar.dart';

/// Preview entry point used by the docs gallery.
class CalendarPreview extends StatefulWidget {
  /// Creates the preview.
  const CalendarPreview({super.key});

  @override
  State<CalendarPreview> createState() => _CalendarPreviewState();
}

class _CalendarPreviewState extends State<CalendarPreview> {
  static final DateTime _today = DateTime(2024, 3, 14);

  CalendarView _view = const CalendarView(2024, 3);
  CalendarValue? _single;
  CalendarValue? _range;
  final CalendarValue _multi = CalendarValue.multi(<DateTime>[
    DateTime(2024, 3, 4),
    DateTime(2024, 3, 8),
    DateTime(2024, 3, 15),
  ]);

  @override
  Widget build(BuildContext context) {
    return ShadcnTheme(
      data: const ShadcnThemeData(),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: _body(context),
      ),
    );
  }

  Widget _body(BuildContext context) {
    final ShadcnColors colors = ShadcnTheme.of(context).colors;
    return ColoredBox(
      color: colors.background,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Wrap(
          spacing: 32,
          runSpacing: 32,
          crossAxisAlignment: WrapCrossAlignment.start,
          children: <Widget>[
            _panel(context, colors, 'single selection', _singlePicker(context)),
            _panel(context, colors, 'range selection', _rangePicker(context)),
            _panel(context, colors, 'multi selection', _multiPicker(context)),
            _panel(context, colors, 'read-only', _readOnly(context)),
            _panel(context, colors, 'month grid', _monthGrid()),
            _panel(context, colors, 'year grid', _yearGrid()),
            _panel(context, colors, 'dark tokens', _dark()),
          ],
        ),
      ),
    );
  }

  Widget _panel(
    BuildContext context,
    ShadcnColors colors,
    String title,
    Widget child,
  ) => SizedBox(
    width: 280,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(title, style: TextStyle(color: colors.mutedForeground)),
        SizedBox(height: ShadcnTheme.of(context).spacing.sm),
        child,
      ],
    ),
  );

  Widget _header(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
      _Step('‹', () => setState(() => _view = _view.previous)),
      SizedBox(width: ShadcnTheme.of(context).spacing.sm),
      _Caption('${_view.year}'),
      SizedBox(width: ShadcnTheme.of(context).spacing.sm),
      _Step('›', () => setState(() => _view = _view.next)),
    ],
  );

  Widget _singlePicker(BuildContext context) => Column(
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
      _header(context),
      SizedBox(height: ShadcnTheme.of(context).spacing.sm),
      Calendar(
        view: _view,
        now: _today,
        value: _single,
        selectionMode: CalendarSelectionMode.single,
        onChanged: (CalendarValue? value) => setState(() => _single = value),
      ),
    ],
  );

  Widget _rangePicker(BuildContext context) => Column(
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
      _header(context),
      SizedBox(height: ShadcnTheme.of(context).spacing.sm),
      Calendar(
        view: _view,
        now: _today,
        value: _range,
        selectionMode: CalendarSelectionMode.range,
        onChanged: (CalendarValue? value) => setState(() => _range = value),
      ),
    ],
  );

  Widget _multiPicker(BuildContext context) => Column(
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
      _header(context),
      SizedBox(height: ShadcnTheme.of(context).spacing.sm),
      Calendar(
        view: _view,
        now: _today,
        value: _multi,
        selectionMode: CalendarSelectionMode.multi,
        onChanged: (CalendarValue? value) => setState(() {}),
      ),
    ],
  );

  Widget _readOnly(BuildContext context) => Column(
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
      _header(context),
      SizedBox(height: ShadcnTheme.of(context).spacing.sm),
      Calendar(
        view: _view,
        now: _today,
        value: CalendarValue.single(_today),
        stateBuilder: (DateTime date) => date.weekday == DateTime.sunday
            ? DateState.disabled
            : DateState.enabled,
      ),
    ],
  );

  Widget _monthGrid() => Calendar(
    view: _view,
    viewType: CalendarViewType.month,
    now: _today,
    selectionMode: CalendarSelectionMode.single,
    onChanged: (CalendarValue? value) => setState(
      () => _view = CalendarView.fromDateTime(
        DateTime(
          _view.year,
          value is SingleCalendarValue ? value.date.month : 1,
        ),
      ),
    ),
  );

  Widget _yearGrid() => Calendar(
    view: _view,
    viewType: CalendarViewType.year,
    now: _today,
    selectionMode: CalendarSelectionMode.single,
    onChanged: (CalendarValue? value) => setState(
      () => _view = CalendarView(
        value is SingleCalendarValue ? value.date.year : _view.year,
        _view.month,
      ),
    ),
  );

  Widget _dark() => ShadcnTheme(
    data: const ShadcnThemeData(colors: ShadcnColors.darkFallback),
    child: Calendar(
      view: _view,
      now: _today,
      value:
          _range ??
          CalendarValue.range(DateTime(2024, 3, 6), DateTime(2024, 3, 12)),
    ),
  );
}

class _Caption extends StatelessWidget {
  const _Caption(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    final ShadcnColors colors = ShadcnTheme.of(context).colors;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Text(text, style: TextStyle(color: colors.foreground)),
    );
  }
}

class _Step extends StatelessWidget {
  const _Step(this.label, this.onTap);

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ShadcnColors colors = ShadcnTheme.of(context).colors;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 24,
        height: 24,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border.all(color: colors.border),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(label, style: TextStyle(color: colors.foreground)),
      ),
    );
  }
}
