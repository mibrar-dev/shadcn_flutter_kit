// The `calendar` component: [Calendar], a date, month or year grid. Value types
// live in `primitives/date_math.dart`, the selection, keyboard and paint rules
// in `calendar_style.dart`. Ported from `components/display/calendar/**`; the
// `DatePickerDialog` of that tree is not migrated — it needs batch B13's overlay.

import 'package:flutter/rendering.dart' show RenderProxyBox;
import 'package:flutter/widgets.dart';

import '../../primitives/date_math.dart';
import '../../primitives/focus_outline.dart';
import '../../primitives/localizations/localizations.dart';
import '../../primitives/menu_nav.dart';
import '../../theme/density.dart';
import '../../theme/theme.dart';
import 'calendar_style.dart';

export 'calendar_style.dart';

typedef DateStateBuilder = DateState Function(DateTime date);

/// A date, month or year grid. Controlled: it paints [value] and reports every
/// change through [onChanged], like shadcn/ui's `React.Calendar`.
///
/// Keyboard: one tab stop, not 42 — the roving-tabindex model. Arrows move a day
/// (wrapping at the row edge) or a week, `Home`/`End` the ends of the week,
/// `PageUp`/`PageDown` a month, `Shift` plus those a year, `Enter`/`Space`
/// select; a disabled cell is skipped.
class Calendar extends StatefulWidget {
  const Calendar({
    super.key,
    required this.view,
    this.viewType = CalendarViewType.date,
    this.selectionMode = CalendarSelectionMode.none,
    this.value,
    this.now,
    this.onChanged,
    this.onViewChanged,
    this.stateBuilder,
    this.firstDayOfWeek = DateTime.monday,
    this.autofocus = false,
    this.theme,
  }) : assert(
         firstDayOfWeek >= DateTime.monday && firstDayOfWeek <= DateTime.sunday,
         'firstDayOfWeek must be a DateTime weekday',
       );

  /// The month shown by [CalendarViewType.date], the year by the other two, and
  /// how a tap changes the selection.
  final CalendarView view;
  final CalendarViewType viewType;
  final CalendarSelectionMode selectionMode;

  /// The current selection; null when nothing is selected.
  final CalendarValue? value;

  /// The date highlighted as "today"; null draws none.
  final DateTime? now;

  /// The next selection (null when a tap cleared it), and the new month when a
  /// keyboard move takes the focus past the shown one.
  final ValueChanged<CalendarValue?>? onChanged;
  final ValueChanged<CalendarView>? onViewChanged;

  /// Decides whether a cell is interactive; null enables everything.
  final DateStateBuilder? stateBuilder;
  final int firstDayOfWeek;
  final bool autofocus;

  /// Widget-leg theme override; the value a tap or an `Enter` on [date] produces
  /// comes from [calendarSelect] (see [select]).
  final CalendarTheme? theme;

  CalendarValue? select(DateTime date) =>
      calendarSelect(mode: selectionMode, value: value, date: date);

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  late final FocusNode _focusNode = FocusNode(debugLabel: 'Calendar');
  DateTime? _focused;
  DateTime? _pending;
  List<_Slot> _slots = const <_Slot>[];

  @override
  void didUpdateWidget(covariant Calendar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.view != oldWidget.view && !_shown(_focused)) {
      _focused = _pending ?? _initialFocus;
      _pending = null;
    }
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  bool _enabled(DateTime date) =>
      (widget.stateBuilder?.call(date) ?? DateState.enabled) ==
      DateState.enabled;

  /// Whether [date] is drawn as it stands: the month for a date grid, the year for
  /// the other two.
  bool _shown(DateTime? date) =>
      date != null &&
      date.year == widget.view.year &&
      (widget.viewType != CalendarViewType.date ||
          date.month == widget.view.month);

  /// Whether [a] and [b] are the same cell at this grid's granularity: a day, a
  /// month or a year. A month cell holds the first of the month, so a plain day
  /// comparison would match neither it nor a year.
  bool _same(DateTime a, DateTime? b) {
    if (b == null || a.year != b.year) return false;
    return switch (widget.viewType) {
      CalendarViewType.date => a.month == b.month && a.day == b.day,
      CalendarViewType.month => a.month == b.month,
      CalendarViewType.year => true,
    };
  }

  DateTime get _initialFocus {
    final DateTime now = widget.now ?? DateTime.now();
    if (_shown(now) && _enabled(now)) return now;
    final int first =
        firstEnabledIndex(
          _slots.length,
          isEnabled: (int i) => _slots[i].enabled,
        ) ??
        0;
    return _slots.isEmpty
        ? DateTime(widget.view.year, widget.view.month)
        : _slots[first].date;
  }

  /// Read-only without [Calendar.onChanged] *and* under [none].
  bool get _interactive =>
      widget.onChanged != null &&
      widget.selectionMode != CalendarSelectionMode.none;

  void _select(DateTime date) {
    setState(() => _focused = date);
    widget.onChanged?.call(widget.select(date));
  }

  int get _columns => widget.viewType == CalendarViewType.date ? 7 : 4;
  int _current() => _slots.indexWhere((_Slot s) => _same(s.date, _focused));

  void _move(CalendarGridMove move) {
    final int current = _current();
    if (current < 0) return;
    final int? index = calendarGridMoveIndex(
      move: move,
      count: _slots.length,
      columns: _columns,
      current: current,
      isEnabled: (int i) =>
          i >= 0 && i < _slots.length && _enabled(_slots[i].date),
    );
    if (index != null) {
      setState(() => _focused = _slots[index].date);
      return;
    }

    // Only a month or year move may leave the grid; an arrow off the edge stays.
    if (move != CalendarGridMove.previousMonth &&
        move != CalendarGridMove.nextMonth &&
        move != CalendarGridMove.previousYear &&
        move != CalendarGridMove.nextYear) {
      return;
    }

    final DateTime? next = _focused == null
        ? null
        : calendarGridMove(
            _focused!,
            move,
            firstDayOfWeek: widget.firstDayOfWeek,
          );
    if (next == null || !_enabled(next)) return;
    setState(() => _focused = _pending = next);
    if (!_shown(next)) {
      widget.onViewChanged?.call(CalendarView.fromDateTime(next));
    }
  }

  Widget _keys(Widget child) => FocusableActionDetector(
    focusNode: _focusNode,
    autofocus: widget.autofocus,
    shortcuts: calendarGridShortcuts(),
    actions: calendarGridActions(onMove: _move, onActivate: _activate),
    child: child,
  );

  /// `Enter` and `Space`: select the focused day, if there is one to select.
  void _activate() {
    final DateTime? date = _focused;
    if (date != null && _interactive && _enabled(date)) _select(date);
  }

  @override
  Widget build(BuildContext context) {
    final CalendarTheme style =
        resolveComponentStyle<CalendarTheme, CalendarTheme>(
          context,
          widget: widget.theme,
          select: (CalendarTheme t) => t,
          defaults: calendarDefaults,
        );
    final bool days = widget.viewType == CalendarViewType.date;
    final ShadcnThemeData ambient = ShadcnTheme.of(context);
    final EdgeInsets padding = resolveEdgeInsets(
      calendarPadding,
      ambient.density.baseContentPadding * ambient.scaling,
    ).resolve(Directionality.of(context));
    // The slots do not depend on the constraints, so they are resolved once
    // here and reused for the hug metrics and the grid.
    final List<_Slot> slots = _slotsFor(context);
    return _keys(
      // A masonry column (~300 px) or a phone (375 px minus padding) is
      // narrower than seven 32 px cells plus gaps, so the cells shrink to the
      // available width (down to a ~7x32 px minimum footprint). Unbounded
      // widths keep the nominal cell sizes.
      //
      // The `p-3` shell (shadcn puts it on the `DayPicker` root) is inside the
      // `LayoutBuilder`, so the grid is fitted against the width it really
      // has; the hug proxy outside reports the natural size to a
      // shrink-wrapping parent — the picker dialogs size themselves to it.
      _CalendarHugWidth(
        nominal: calendarGridWidth(style, ambient, padding),
        nominalHeight: calendarGridHeight(
          style,
          ambient,
          padding,
          slots.length,
          weekdays: days
              ? calendarWeekdayLabels(context, widget.firstDayOfWeek)
              : null,
        ),
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return Padding(
              padding: padding,
              child: _grid(
                context: context,
                slots: slots,
                weekdays: days
                    ? calendarWeekdayLabels(context, widget.firstDayOfWeek)
                    : null,
                style: style,
                maxWidth: constraints.maxWidth - padding.left - padding.right,
              ),
            );
          },
        ),
      ),
    );
  }

  /// The cells of the current grid, with the focus resolved onto one of them.
  ///
  /// The focus cannot be resolved in `initState`: its fallback needs the slots,
  /// and the slots need the focus to paint their ring. So the first pass runs
  /// twice, cheaper than guessing the first selectable day up front.
  List<_Slot> _slotsFor(BuildContext context) {
    final List<DateTime> dates = _dates();
    _slots = _paint(context, dates);
    _focused ??= _initialFocus;
    // The ring comes from `_focused`, so the first pass has to be redone.
    return _slots = _paint(context, dates);
  }

  List<_Slot> _paint(BuildContext context, List<DateTime> dates) => <_Slot>[
    for (final DateTime date in dates) _slotOf(context, date),
  ];

  /// The dates the current grid draws: a month of days with the leading and
  /// trailing ones included, the twelve months of the year, or sixteen years
  /// around the view year snapped to a decade.
  List<DateTime> _dates() => switch (widget.viewType) {
    CalendarViewType.date => <DateTime>[
      for (final DateGridCell cell in monthGrid(
        widget.view.year,
        widget.view.month,
        firstDayOfWeek: widget.firstDayOfWeek,
      ))
        cell.date,
    ],
    CalendarViewType.month => <DateTime>[
      for (int m = 1; m <= 12; m++) DateTime(widget.view.year, m),
    ],
    CalendarViewType.year => <DateTime>[
      for (int i = 0; i < 16; i++)
        DateTime((widget.view.year - 5) ~/ 10 * 10 + i),
    ],
  };

  /// One cell of [date], at this grid's granularity.
  _Slot _slotOf(BuildContext context, DateTime date) {
    return (
      date: date,
      label: calendarCellLabel(context, date, widget.viewType),
      lookup: calendarCellLookup(widget.value, date, widget.viewType),
      today: _same(date, widget.now),
      enabled: _enabled(date),
      focused: _same(date, _focused),
      // Outside the shown month, shadcn draws the day at half strength.
      dimmed: widget.viewType == CalendarViewType.date && !_shown(date),
      wide: widget.viewType != CalendarViewType.date,
      onTap: _interactive ? () => _select(date) : null,
    );
  }
}

/// One cell, before painting: a record, built once and read once.
typedef _Slot = ({
  DateTime date,
  String label,
  CalendarValueLookup lookup,
  bool today,
  bool enabled,
  bool focused,
  bool dimmed,
  bool wide,
  VoidCallback? onTap,
});

/// Narrowest a shrunken cell gets: 7 x 20 + 6 x 4 = 164 px.
///
/// P6-F5 set 28 (220 px min), which fits its 240/300/375 px column tests but
/// overflows the Theme Studio canvas at 768 px (two columns leave ~196 px
/// for the card body; P6-P1 measured RenderFlex overflow 24 px). 20 px still
/// shows two-digit days at the 14 px day size, so the grid fits every tested
/// viewport (home, studio and component pages at 375/768/1440) with no
/// horizontal scroll.
const double _kMinCalendarCell = 20;

/// Density scale of the ambient theme: 1 at the default density, 0.5 at
/// compact, 1.25 at comfortable (the kit's documented scaling rule).
double _densityScale(ShadcnThemeData theme) =>
    theme.density.scale * theme.scaling;

/// Nominal cell side of the day grid, density-scaled.
double calendarDayCellWidthOf(CalendarTheme style, ShadcnThemeData theme) =>
    (style.cellWidth ?? style.cellHeight ?? calendarDayCellSize) *
    _densityScale(theme);

/// Density-scaled grid gap: `CalendarTheme.gap` (4, the shadcn cell pitch) or
/// `density.baseGap` when the theme leaves it unset.
double calendarGapOf(CalendarTheme style, ShadcnThemeData theme) =>
    (style.gap ?? 4) * _densityScale(theme);

/// Natural (unshrunk) width of a day grid plus its `p-3` shell.
///
/// The day grid is the widest of the three grids, so it decides the width of
/// a shrink-wrapping parent — the picker dialogs. Month and year grids are
/// narrower and still fit.
double calendarGridWidth(
  CalendarTheme style,
  ShadcnThemeData theme,
  EdgeInsets padding,
) {
  final double cell = calendarDayCellWidthOf(style, theme);
  final double gap = calendarGapOf(style, theme);
  return cell * 7 + gap * 6 + padding.left + padding.right;
}

/// Natural (unshrunk) height of a grid: the cell rows, the gaps between them,
/// the weekday header of a day grid, and the `p-3` shell.
///
/// Heights never shrink — only the width adapts — so this is also the height
/// a shrink-wrapping parent measures.
double calendarGridHeight(
  CalendarTheme style,
  ShadcnThemeData theme,
  EdgeInsets padding,
  int slotCount, {
  List<String>? weekdays,
}) {
  final int columns = weekdays == null ? 4 : 7;
  final int rows = (slotCount + columns - 1) ~/ columns;
  final double scale = _densityScale(theme);
  final double cell =
      (style.cellHeight ??
          (columns < 7 ? calendarMonthCellHeight : calendarDayCellSize)) *
      scale;
  final double gap = calendarGapOf(style, theme);
  // A day grid carries a weekday header in its own cell-sized box.
  final int boxes = rows + (weekdays == null ? 0 : 1);
  return cell * boxes +
      gap * (rows > 0 ? rows - 1 : 0) +
      padding.top +
      padding.bottom;
}

/// A nominal cell width fitted into [maxWidth]: the nominal size when it fits,
/// otherwise an even share of the row, floored at [_kMinCalendarCell].
/// Heights never shrink — only the width adapts, so rows keep their pitch.
double _fitCalendarCell({
  required double nominal,
  required int columns,
  required double gap,
  required double maxWidth,
}) {
  if (!maxWidth.isFinite) {
    return nominal;
  }
  final double fit = (maxWidth - (columns - 1) * gap) / columns;
  return fit >= nominal ? nominal : fit.clamp(_kMinCalendarCell, nominal);
}

/// Reports the calendar's nominal width during an intrinsic pass.
///
/// `LayoutBuilder` answers "not implemented" for intrinsic sizes (its builder
/// needs real constraints), so a shrink-wrapping parent would measure the
/// calendar as zero wide. The picker dialogs wrap their content in
/// `IntrinsicWidth`, and this proxy gives it the honest answer: the grid's
/// natural width. Layout is untouched — the child still sees the real
/// constraints and shrinks its cells when the parent is narrow.
class _CalendarHugWidth extends SingleChildRenderObjectWidget {
  const _CalendarHugWidth({
    required this.nominal,
    required this.nominalHeight,
    required super.child,
  });

  /// The grid's natural width, shell padding included.
  final double nominal;

  /// The grid's natural height, shell padding included.
  final double nominalHeight;

  @override
  _RenderCalendarHugWidth createRenderObject(BuildContext context) =>
      _RenderCalendarHugWidth(nominal, nominalHeight);

  @override
  void updateRenderObject(
    BuildContext context,
    covariant _RenderCalendarHugWidth renderObject,
  ) {
    renderObject
      ..nominal = nominal
      ..nominalHeight = nominalHeight;
  }
}

/// Passes the nominal width through an intrinsic pass and the real constraints
/// through layout, so a shrink-wrapping parent measures the grid honestly
/// while the cells still shrink to fit a narrow parent.
class _RenderCalendarHugWidth extends RenderProxyBox {
  _RenderCalendarHugWidth(this._nominal, this._nominalHeight);

  double _nominal;

  double _nominalHeight;

  set nominal(double value) => _nominal = value;

  set nominalHeight(double value) => _nominalHeight = value;

  @override
  double computeMaxIntrinsicWidth(double height) => _nominal;

  @override
  double computeMinIntrinsicWidth(double height) => _nominal;

  @override
  double computeMaxIntrinsicHeight(double width) => _nominalHeight;

  @override
  double computeMinIntrinsicHeight(double width) => _nominalHeight;
}

/// An optional weekday header, then rows of cells.
Widget _grid({
  required BuildContext context,
  required List<_Slot> slots,
  required CalendarTheme style,
  List<String>? weekdays,
  double maxWidth = double.infinity,
}) {
  final ShadcnThemeData theme = ShadcnTheme.of(context);
  final double scale = _densityScale(theme);
  final double size = (style.cellHeight ?? calendarDayCellSize) * scale;
  final double gap = calendarGapOf(style, theme);
  final int columns = weekdays == null ? 4 : 7;
  double fit(double nominal) => _fitCalendarCell(
    nominal: nominal,
    columns: columns,
    gap: gap,
    maxWidth: maxWidth,
  );
  final double dayWidth = fit(
    style.cellWidth == null ? size : style.cellWidth! * scale,
  );
  final double wideWidth = fit(
    style.cellWidth == null
        ? calendarMonthCellWidth * scale
        : style.cellWidth! * scale,
  );
  final TextStyle header = theme.typography.xSmall.copyWith(
    color: theme.colors.mutedForeground,
    fontSize: style.weekdayTextStyle?.fontSize,
  );
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
      // The header is the same box as a day cell, so both grids keep one pitch.
      if (weekdays != null)
        Row(
          children: <Widget>[
            for (final String day in weekdays)
              SizedBox(
                width: dayWidth,
                height: size,
                child: Center(child: Text(day, style: header)),
              ),
          ],
        ),
      for (int row = 0; row * columns < slots.length; row++)
        Padding(
          padding: EdgeInsets.only(
            bottom: (row + 1) * columns >= slots.length ? 0 : gap,
          ),
          child: Row(
            children: <Widget>[
              for (int column = 0; column < columns; column++)
                if (row * columns + column < slots.length)
                  Padding(
                    padding: EdgeInsets.only(
                      right: column == columns - 1 ? 0 : gap,
                    ),
                    child: _calendarCell(
                      context,
                      slots[row * columns + column],
                      style,
                      cellWidth: slots[row * columns + column].wide
                          ? wideWidth
                          : dayWidth,
                    ),
                  ),
            ],
          ),
        ),
    ],
  );
}

/// One painted cell, wrapped in the focus ring of the focused day. A
/// `Clickable` owns a traversable focus node per cell, so the focus lives on
/// the grid and the ring is drawn here.
Widget _calendarCell(
  BuildContext context,
  _Slot slot,
  CalendarTheme style, {
  double? cellWidth,
}) {
  final ShadcnThemeData theme = ShadcnTheme.of(context);
  final ({Color fill, Color foreground}) colors = calendarCellColors(
    lookup: slot.lookup,
    today: slot.today,
    style: style,
    colors: theme.colors,
  );
  final double scale = _densityScale(theme);
  final double size =
      (style.cellHeight ??
          (slot.wide ? calendarMonthCellHeight : calendarDayCellSize)) *
      scale;
  // [cellWidth] is the row's fitted share; without it the cell keeps the
  // nominal theme size (cellWidth, or the cell height for date cells).
  final double width =
      cellWidth ??
      (style.cellWidth == null
          ? (slot.wide ? calendarMonthCellWidth * scale : size)
          : style.cellWidth! * scale);
  final BorderRadius radius = (style.cellBorderRadius ?? theme.borderRadiusMd)
      .resolve(Directionality.of(context));
  return Semantics(
    container: true,
    label:
        '${ShadcnLocalizations.of(context).getAbbreviatedMonth(slot.date.month)} '
        '${slot.date.day}, ${slot.date.year}',
    button: true,
    enabled: slot.enabled,
    selected: slot.lookup == CalendarValueLookup.selected,
    child: FocusOutline(
      focused: slot.focused,
      borderRadius: radius,
      child: GestureDetector(
        onTap: slot.enabled ? slot.onTap : null,
        child: Opacity(
          opacity: slot.dimmed || !slot.enabled ? 0.5 : 1,
          child: Container(
            width: width == 0 ? size : width,
            height: size,
            alignment: Alignment.center,
            decoration: BoxDecoration(color: colors.fill, borderRadius: radius),
            // The box shows the day number, but the node announces the full
            // date, or a reader says "Mar 14, 2024" then "14".
            child: ExcludeSemantics(
              child: Text(
                slot.label,
                style: (style.cellTextStyle ?? const TextStyle()).copyWith(
                  color: colors.foreground,
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
