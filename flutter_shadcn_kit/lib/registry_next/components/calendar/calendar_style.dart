// Registry-owned theme data for the `calendar` component: the enums the widget
// switches on, `CalendarTheme` with its token-derived `calendarDefaults`, and
// the pure selection / keyboard / paint rules. Value types: `date_math.dart`.

import 'package:flutter/foundation.dart' show listEquals;
import 'package:flutter/services.dart' show LogicalKeyboardKey;
import 'package:flutter/widgets.dart';

import '../../primitives/date_math.dart';
import '../../primitives/localizations/localizations.dart';
import '../../primitives/menu_nav.dart';
import '../../theme/color_tokens.dart';
import '../../theme/theme.dart';

/// How a date cell reacts to a tap. [none] is a read-only display; tapping
/// the selection in [single] clears it; [range] moves or clears an endpoint;
/// [multi] toggles one date of a list.
enum CalendarSelectionMode { none, single, range, multi }

/// Granularity of the grid: the days of one month, the twelve months of one
/// year, or sixteen years four to a row.
enum CalendarViewType { date, month, year }

/// Whether one date cell can be picked. A [disabled] cell is dimmed, ignores
/// taps and is skipped by keyboard navigation.
enum DateState { disabled, enabled }

/// Visual contract of the calendar grid. One flat set of rows: the three grids
/// differ only in cell size, and a disabled cell is the grid dimmed to 50%,
/// not a fourth colour.
///
/// Colour rows, falling back to the token in brackets: `cellBackground`
/// (transparent) and `cellForeground` (`foreground`) per state,
/// `todayBackground` (`secondary`), `selectedBackground` (`primary`),
/// `selectedForeground` (`primaryForeground`), `rangeBackground` (`secondary`).
///
/// Dimension and text rows, falling back when null: `cellBorderRadius`
/// (`borderRadiusMd`), `cellWidth` (32, or 56 for the month and year grids),
/// `cellHeight` (32, or 40 for those), `gap` (the density base gap),
/// `weekdayTextStyle` (xSmall) and `cellTextStyle` (14). Both text rows ignore
/// the colour, because the colour rows own that.
class CalendarTheme extends ComponentThemeData
    implements Mergeable<CalendarTheme> {
  /// Creates a calendar theme.
  const CalendarTheme({
    super.themeDensity,
    super.themeSpacing,
    super.themeShadows,
    this.cellBackground,
    this.cellForeground,
    this.todayBackground,
    this.selectedBackground,
    this.selectedForeground,
    this.rangeBackground,
    this.cellBorderRadius,
    this.cellWidth,
    this.cellHeight,
    this.gap,
    this.weekdayTextStyle,
    this.cellTextStyle,
  });

  final StateValue<ThemedColor>? cellBackground;
  final StateValue<ThemedColor>? cellForeground;
  final ThemedColor? todayBackground;
  final ThemedColor? selectedBackground;
  final ThemedColor? selectedForeground;
  final ThemedColor? rangeBackground;
  final BorderRadiusGeometry? cellBorderRadius;
  final double? cellWidth;
  final double? cellHeight;
  final double? gap;
  final TextStyle? weekdayTextStyle;
  final TextStyle? cellTextStyle;

  /// First-non-null-wins merge; the receiver (higher-priority leg) wins.
  @override
  CalendarTheme merge(CalendarTheme? fallback) {
    if (fallback == null) return this;
    return CalendarTheme(
      themeDensity: themeDensity ?? fallback.themeDensity,
      themeSpacing: themeSpacing ?? fallback.themeSpacing,
      themeShadows: themeShadows ?? fallback.themeShadows,
      cellBackground:
          cellBackground?.merge(fallback.cellBackground) ??
          fallback.cellBackground,
      cellForeground:
          cellForeground?.merge(fallback.cellForeground) ??
          fallback.cellForeground,
      todayBackground: todayBackground ?? fallback.todayBackground,
      selectedBackground: selectedBackground ?? fallback.selectedBackground,
      selectedForeground: selectedForeground ?? fallback.selectedForeground,
      rangeBackground: rangeBackground ?? fallback.rangeBackground,
      cellBorderRadius: cellBorderRadius ?? fallback.cellBorderRadius,
      cellWidth: cellWidth ?? fallback.cellWidth,
      cellHeight: cellHeight ?? fallback.cellHeight,
      gap: gap ?? fallback.gap,
      weekdayTextStyle: weekdayTextStyle ?? fallback.weekdayTextStyle,
      cellTextStyle: cellTextStyle ?? fallback.cellTextStyle,
    );
  }

  /// Every row in order, so `==` and [hashCode] cannot drift apart.
  List<Object?> get _fields => <Object?>[
    themeDensity,
    themeSpacing,
    themeShadows,
    cellBackground,
    cellForeground,
    todayBackground,
    selectedBackground,
    selectedForeground,
    rangeBackground,
    cellBorderRadius,
    cellWidth,
    cellHeight,
    gap,
    weekdayTextStyle,
    cellTextStyle,
  ];

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CalendarTheme && listEquals(other._fields, _fields);

  @override
  int get hashCode => Object.hashAll(_fields);
}

/// Token-derived baseline; every unset override field falls through here.
const CalendarTheme calendarDefaults = CalendarTheme(
  cellBackground: StateValue<ThemedColor>(
    rest: ThemedColor.value(Color(0x00000000)),
    hovered: ThemedColor.ref(ColorRef.accent),
  ),
  cellForeground: StateValue<ThemedColor>(
    rest: ThemedColor.ref(ColorRef.foreground),
  ),
  todayBackground: ThemedColor.ref(ColorRef.secondary),
  selectedBackground: ThemedColor.ref(ColorRef.primary),
  selectedForeground: ThemedColor.ref(ColorRef.primaryForeground),
  rangeBackground: ThemedColor.ref(ColorRef.secondary),
  gap: 4,
  cellTextStyle: TextStyle(fontSize: 14),
);

/// One keyboard move, as shadcn / react-day-picker defines it.
enum CalendarGridMove {
  previousDay,
  nextDay,
  previousWeek,
  nextWeek,
  startOfWeek,
  endOfWeek,
  previousMonth,
  nextMonth,
  previousYear,
  nextYear,
}

/// The keys a day grid answers to, and the move each one performs. `Shift` is a
/// plain prefix, so `Shift+PageUp` reaches [CalendarGridMove.previousYear].
final Map<LogicalKeySet, CalendarGridMove> calendarGridMoves =
    <LogicalKeySet, CalendarGridMove>{
      LogicalKeySet(LogicalKeyboardKey.arrowLeft): CalendarGridMove.previousDay,
      LogicalKeySet(LogicalKeyboardKey.arrowRight): CalendarGridMove.nextDay,
      LogicalKeySet(LogicalKeyboardKey.arrowUp): CalendarGridMove.previousWeek,
      LogicalKeySet(LogicalKeyboardKey.arrowDown): CalendarGridMove.nextWeek,
      LogicalKeySet(LogicalKeyboardKey.home): CalendarGridMove.startOfWeek,
      LogicalKeySet(LogicalKeyboardKey.end): CalendarGridMove.endOfWeek,
      LogicalKeySet(LogicalKeyboardKey.pageUp): CalendarGridMove.previousMonth,
      LogicalKeySet(LogicalKeyboardKey.pageDown): CalendarGridMove.nextMonth,
      LogicalKeySet(LogicalKeyboardKey.shift, LogicalKeyboardKey.pageUp):
          CalendarGridMove.previousYear,
      LogicalKeySet(LogicalKeyboardKey.shift, LogicalKeyboardKey.pageDown):
          CalendarGridMove.nextYear,
    };

/// Requests a [CalendarGridMove] on the focused day.
class CalendarGridMoveIntent extends Intent {
  /// Creates the intent for [move].
  const CalendarGridMoveIntent(this.move);

  /// The move the key asked for.
  final CalendarGridMove move;
}

/// The slot index [move] lands on, or null when it leaves the grid.
///
/// Horizontal and week moves walk *indices*, so [nextEnabledIndex],
/// [firstEnabledIndex] and [lastEnabledIndex] skip disabled cells and keep
/// `Home` / `End` in the row. A month or year move leaves the grid, so the
/// widget resolves it as a date move and this returns null.
int? calendarGridMoveIndex({
  required CalendarGridMove move,
  required int count,
  required int columns,
  required int current,
  required bool Function(int index) isEnabled,
}) {
  final int row = current ~/ columns;
  bool rowOf(int i) => i ~/ columns == row && isEnabled(i);
  return switch (move) {
    CalendarGridMove.previousDay ||
    CalendarGridMove.nextDay => nextEnabledIndex(
      count: count,
      current: current,
      forward: move == CalendarGridMove.nextDay,
      isEnabled: isEnabled,
    ),
    CalendarGridMove.previousWeek || CalendarGridMove.nextWeek => _stepOf(
      count,
      current,
      move == CalendarGridMove.nextWeek ? columns : -columns,
      isEnabled,
    ),
    CalendarGridMove.startOfWeek => firstEnabledIndex(count, isEnabled: rowOf),
    CalendarGridMove.endOfWeek => lastEnabledIndex(count, isEnabled: rowOf),
    _ => null,
  };
}

/// The first enabled index [delta] away from [from], or null at the edge.
int? _stepOf(int count, int from, int delta, bool Function(int) isEnabled) {
  for (var hop = 0; hop <= count; hop++) {
    final int index = from + delta * (hop + 1);
    if (index < 0 || index >= count) return null;
    if (isEnabled(index)) return index;
  }

  return null;
}

/// The shortcut map a day grid binds: every move, plus `Enter` and `Space`.
Map<ShortcutActivator, Intent> calendarGridShortcuts() =>
    <ShortcutActivator, Intent>{
      for (final MapEntry<ShortcutActivator, CalendarGridMove> entry
          in calendarGridMoves.entries)
        entry.key: CalendarGridMoveIntent(entry.value),
      const SingleActivator(LogicalKeyboardKey.enter): const ActivateIntent(),
      const SingleActivator(LogicalKeyboardKey.space): const ActivateIntent(),
    };

/// The seven weekday names a date grid starts at [firstDayOfWeek].
List<String> calendarWeekdayLabels(BuildContext context, int firstDayOfWeek) {
  final ShadcnLocalizations strings = ShadcnLocalizations.of(context);
  return <String>[
    for (int i = 0; i < 7; i++)
      strings.getAbbreviatedWeekday((firstDayOfWeek - 1 + i) % 7 + 1),
  ];
}

/// The date [move] lands on from [date], rebuilt from calendar parts so a
/// daylight-saving transition cannot shift it into the next day the way
/// `date.add(const Duration(days: 1))` can.
DateTime? calendarGridMove(
  DateTime date,
  CalendarGridMove move, {
  int firstDayOfWeek = DateTime.monday,
}) => switch (move) {
  CalendarGridMove.previousDay => _addDays(date, -1),
  CalendarGridMove.nextDay => _addDays(date, 1),
  CalendarGridMove.previousWeek => _addDays(date, -7),
  CalendarGridMove.nextWeek => _addDays(date, 7),
  CalendarGridMove.startOfWeek => startOfWeek(
    date,
    firstDayOfWeek: firstDayOfWeek,
  ),
  CalendarGridMove.endOfWeek => _addDays(
    startOfWeek(date, firstDayOfWeek: firstDayOfWeek),
    6,
  ),
  CalendarGridMove.previousMonth => addMonths(date, -1),
  CalendarGridMove.nextMonth => addMonths(date, 1),
  CalendarGridMove.previousYear => addMonths(date, -12),
  CalendarGridMove.nextYear => addMonths(date, 12),
};

/// [date] shifted by [days], rebuilt from its calendar parts.
DateTime _addDays(DateTime date, int days) =>
    DateTime(date.year, date.month, date.day + days);

/// The selection a tap or an `Enter` on [date] produces; pure, so a picker can
/// share the rule without building a widget.
CalendarValue? calendarSelect({
  required CalendarSelectionMode mode,
  required CalendarValue? value,
  required DateTime date,
}) => switch (mode) {
  CalendarSelectionMode.none => value,
  CalendarSelectionMode.single => switch (value) {
    final SingleCalendarValue current =>
      current.date == date ? null : CalendarValue.single(date),
    _ => CalendarValue.single(date),
  },
  CalendarSelectionMode.multi => _toggleMulti(value, date),
  CalendarSelectionMode.range => switch (value) {
    null => CalendarValue.single(date),
    final SingleCalendarValue current =>
      current.date == date ? null : CalendarValue.range(current.date, date),
    final RangeCalendarValue range => _extendRange(range, date),
    _ => CalendarValue.single(date),
  },
};

/// Adds or removes [date] from a multi selection. The list is copied first: a
/// `const <DateTime>[]` seed made the first tap throw "Cannot add to an
/// unmodifiable list" from the tap handler.
CalendarValue? _toggleMulti(CalendarValue? value, DateTime date) {
  final List<DateTime> dates = value is MultiCalendarValue
      ? value.dates.toList()
      : <DateTime>[];
  dates.contains(date) ? dates.remove(date) : dates.add(date);
  return dates.isEmpty ? null : CalendarValue.multi(dates);
}

/// Extends a range to [date], or clears it when an endpoint is tapped.
CalendarValue? _extendRange(RangeCalendarValue range, DateTime date) =>
    date == range.start
    ? null
    : date == range.end
    ? CalendarValue.single(range.end)
    : date.isBefore(range.start)
    ? CalendarValue.range(date, range.end)
    : CalendarValue.range(range.start, date);

/// The fill and label colour of one cell, exposed like `resolveInputSurface`
/// on `input`: a custom painter wants the built-in cell's own rules.
({Color fill, Color foreground}) calendarCellColors({
  required CalendarValueLookup lookup,
  required bool today,
  required CalendarTheme style,
  required ShadcnColors colors,
}) {
  const Set<WidgetState> rest = <WidgetState>{};
  final Color label =
      style.cellForeground?.resolve(rest)?.resolve(colors) ?? colors.foreground;
  final ThemedColor fill = switch (lookup) {
    CalendarValueLookup.selected =>
      style.selectedBackground ?? ThemedColor.ref(ColorRef.primary),
    CalendarValueLookup.none when today =>
      style.todayBackground ?? ThemedColor.ref(ColorRef.secondary),
    CalendarValueLookup.none =>
      style.cellBackground?.resolve(rest) ??
          ThemedColor.value(const Color(0x00000000)),
    _ => style.rangeBackground ?? ThemedColor.ref(ColorRef.secondary),
  };
  return (
    fill: fill.resolve(colors),
    foreground: lookup == CalendarValueLookup.selected
        ? (style.selectedForeground ??
                  ThemedColor.ref(ColorRef.primaryForeground))
              .resolve(colors)
        : label,
  );
}

/// The text a cell of [date] shows, at this grid's granularity.
String calendarCellLabel(
  BuildContext context,
  DateTime date,
  CalendarViewType viewType,
) => switch (viewType) {
  CalendarViewType.date => '${date.day}',
  CalendarViewType.year => '${date.year}',
  CalendarViewType.month => ShadcnLocalizations.of(
    context,
  ).getAbbreviatedMonth(date.month),
};

/// How [value] stands at [date] in a [viewType] grid.
CalendarValueLookup calendarCellLookup(
  CalendarValue? value,
  DateTime date,
  CalendarViewType viewType,
) => switch (viewType) {
  CalendarViewType.date => value?.lookupDate(date) ?? CalendarValueLookup.none,
  CalendarViewType.month =>
    value?.lookupMonth(date.year, date.month) ?? CalendarValueLookup.none,
  CalendarViewType.year =>
    value?.lookupYear(date.year) ?? CalendarValueLookup.none,
};

/// The action map a day grid binds: the widget supplies only the two verbs.
Map<Type, Action<Intent>> calendarGridActions({
  required ValueChanged<CalendarGridMove> onMove,
  required VoidCallback onActivate,
}) => <Type, Action<Intent>>{
  CalendarGridMoveIntent: CallbackAction<CalendarGridMoveIntent>(
    onInvoke: (CalendarGridMoveIntent intent) => onMove(intent.move),
  ),
  ActivateIntent: CallbackAction<ActivateIntent>(
    onInvoke: (ActivateIntent intent) => onActivate(),
  ),
};
