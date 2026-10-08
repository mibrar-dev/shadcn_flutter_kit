# Calendar

A date grid, a month grid and a year grid with single, range and multi
selection. Widgets-only, controlled, and driven by the `date_math` primitive.

## When to use

- A month picker inside a form or a sheet.
- A "book a slot" range picker.
- A month or year step-up from a date picker.

## Snippets

Single selection:

```dart
Calendar(
  view: CalendarView.now(),
  selectionMode: CalendarSelectionMode.single,
  onChanged: (value) => setState(() => picked = value),
);
```

Range selection, with Sundays disabled:

```dart
Calendar(
  view: CalendarView(2024, 3),
  now: DateTime(2024, 3, 14),
  value: CalendarValue.range(DateTime(2024, 3, 6), DateTime(2024, 3, 12)),
  selectionMode: CalendarSelectionMode.range,
  stateBuilder: (date) => date.weekday == DateTime.sunday
      ? DateState.disabled
      : DateState.enabled,
  onChanged: (value) => setState(() => range = value),
);
```

A Sunday-first grid:

```dart
Calendar(view: view, firstDayOfWeek: DateTime.sunday);
```

The month and year grids:

```dart
Calendar(view: view, viewType: CalendarViewType.month);
Calendar(view: view, viewType: CalendarViewType.year);
```

## API

| Parameter | Default | Notes |
|---|---|---|
| `view` | required | the month (`date`) or the year (`month`, `year`) on screen |
| `viewType` | `CalendarViewType.date` | `date`, `month` or `year` |
| `selectionMode` | `CalendarSelectionMode.none` | `none`, `single`, `range`, `multi` |
| `value` | null | the current selection; the widget is controlled |
| `onChanged` | null | next selection, or null when a tap cleared it |
| `now` | null | the date highlighted as today; injected for determinism |
| `stateBuilder` | null | `DateState.disabled` makes a cell inert; null enables all |
| `onViewChanged` | null | the new month when a keyboard move leaves the shown one |
| `firstDayOfWeek` | `DateTime.monday` | weekday the date grid starts on |
| `autofocus` | false | whether the grid takes focus when first shown |
| `theme` | null | widget leg of `CalendarTheme` |

Without `onChanged` the grid is read-only: a cell with no tap handler never
fires, which is how `selectionMode: none` behaves.

`Calendar.select(date)` is also the rule an `Enter` follows, so a keyboard
selection and a tap selection cannot drift apart.

## Keyboard

The grid is **one tab stop**, not one per cell — the roving-tabindex model a
35-cell day grid needs. The focused day carries a ring drawn from the `ring`
token (`FocusOutline`), and exactly one cell ever wears it.

| Key | Move |
|---|---|
| `ArrowLeft` / `ArrowRight` | one day, wrapping at the row edge |
| `ArrowUp` / `ArrowDown` | one week |
| `Home` / `End` | the first or last day of the focused week |
| `PageUp` / `PageDown` | one month |
| `Shift` + `PageUp` / `PageDown` | one year |
| `Enter` / `Space` | select the focused day |

A **disabled cell is always skipped**, by every move. An arrow that runs off the
edge leaves the focus where it is; a page or year move reports the new month
through `onViewChanged` and keeps the focused day, so a caller that follows
`onViewChanged` lands on the same day in the next month:

```dart
Calendar(
  view: view,
  autofocus: true,
  onChanged: (value) => setState(() => picked = value),
  onViewChanged: (next) => setState(() => view = next),
);
```

The keys, the move each one performs and the slot-index arithmetic live in
`calendar_style.dart` (`calendarGridMoves`, `calendarGridMoveIndex`,
`calendarGridMove`) and use `menu_nav`'s `nextEnabledIndex` /
`firstEnabledIndex` / `lastEnabledIndex` for the skipping, so they are testable
without a pointer and reusable by a date picker.

Accessibility: every cell is a `Semantics` node labelled with the **full
localized date** ("Mar 14, 2024"), not the number painted in the box, and marked
`button`, `enabled` and `selected`. The painted day number is wrapped in
`ExcludeSemantics` so a reader hears the date once.

## Sizes

A day cell is **32 x 32**, shadcn's `size-8`; a month or year cell is 56 x 40;
the weekday header is the same 32-wide box as a day cell, so both grids keep one
column pitch. `cellWidth` and `cellHeight` override the defaults.

## Selection rules

`Calendar.select(date)` is the whole rule set, and it is public so it can be
exercised without a pointer:

| Mode | Tap on an unselected date | Tap on the selection |
|---|---|---|
| `none` | nothing | nothing |
| `single` | `CalendarValue.single(date)` | `null` |
| `range` | first tap `single`, then `range` from the first date | the start clears it; the end narrows it to `single` |
| `multi` | adds to the list | removes; an empty list reports `null` |

A tap in `range` mode before the range exists reports a *single* value, so the
caller stores one value while the user picks the second date. The old widget
did the same, but through four untyped `if` branches on `CalendarValue`; here
it is one exhaustive `switch`.

## Theming

`CalendarTheme` has one flat set of rows; the three grids differ only in cell
size (`cellWidth` / `cellHeight` default to 32 for days and 56/40 for months
and years). All four legs work: widget arg → nearest `ComponentTheme` → app
`ComponentThemes` → `calendarDefaults`. See `calendar_theme.dart`.

| Field | Default | Notes |
|---|---|---|
| `cellBackground` | transparent / accent on hover | per-state |
| `cellForeground` | `foreground` | per-state |
| `todayBackground` | `secondary` | |
| `selectedBackground` | `primary` | |
| `selectedForeground` | `primaryForeground` | |
| `rangeBackground` | `secondary` | start, end and in-between |
| `cellBorderRadius` | `borderRadiusMd` | |
| `cellWidth` / `cellHeight` | 32 (days) / 56 x 40 (months, years) | |
| `gap` | 4 | cell and row gap |
| `weekdayTextStyle` | `typography.xSmall` | colour is muted |
| `cellTextStyle` | 14 px | colour comes from the colour rows |

A disabled cell is the whole cell at 50%, and a day outside the shown month is
also 50% — shadcn's `opacity-50`, not a fourth colour.

## Fixed bugs

Old → new:

1. **The grid always started on a Monday.** `CalendarGridData` hard-coded
   `prevMonthDays = firstDayOfMonth.weekday`, ignoring any locale. The port
   uses `monthGrid(..., firstDayOfWeek:)` and exposes it as a parameter.
2. **Dates around a DST boundary were wrong.** The grid stepped with
   `prevMonthLastDay.add(Duration(days: i))` and
   `nextMonthFirstDay.add(Duration(days: i))`. A 23- or 25-hour day shifts that
   arithmetic, so the same calendar day appeared twice or vanished. `monthGrid`
   builds every cell from `DateTime(y, m, d + i)`, which is calendar-based.
3. **`CalendarGridItem.isToday` called `DateTime.now()` from inside the widget**,
   so a grid could not be rendered for any day but today. `now` is injected.
4. **`isDateEnabled` and `stateBuilder` were one knob twice**, with
   `stateBuilder` silently winning. Only `stateBuilder` survives.
5. **`CalendarItemType` had ten cases for six visual rows.** Four of them
   (`startRangeSelectedShort`, `endRangeSelectedShort`,
   `inRangeSelectedShort`, `startRange` / `endRange`) were never assigned by
   any caller, and the 341-line switch re-read `width ?? scaling * 32` in
   every branch. One cell painter driven by `CalendarValueLookup` replaces it.
6. **A range that starts in the previous month rendered wrong.** The old
   `CalendarItem` rewrote `startRangeSelected` into a plain `selected`
   whenever `indexAtRow == 0`, so a range starting on a Sunday lost its left
   cap. Lookup is by date, not by column, so the cap follows the date.
7. **`_CalendarState` kept its grid in `_gridData` and rebuilt it only in
   `initState` / `didUpdateWidget`** — fine, but it meant `CalendarGridData`
   was a mutable cache of `(month, year)` that could not be reasoned about.
   The view is now the single source of truth.

Found while porting:

8. **`MultiCalendarValue.toRange` asserted on an empty list** but
   `toSingle` used `dates.first` with no check, so an empty multi value threw
   a raw `RangeError` from inside a tap handler.
9. **`RangeCalendarValue.toMulti` expanded the span into a `DateTime` per day.**
   A ten-year range allocated 3,650 objects on every call. `toMulti` on a range
   now yields the two endpoints, and multi-select starts from an explicit list.
10. **`CalendarValue.lookup(year, [month, day])` took three optional arguments
    that defaulted to `1`**, so `lookup(2024)` and `lookup(2024, 3)` meant
    different things through a private `_convertNecessarry` helper. The three
    granularities are now three named methods (`lookupDate`, `lookupMonth`,
    `lookupYear`), and the class is `sealed`.
11. **`DatePickerDialog` was 600 LOC in the same `part` chain** and is not
    migrated; it belongs to batch B13's `date_picker`, which is built on this
    component.

Found by the keyboard-navigation tests:

12. **An arrow that ran off the grid moved the wrong way.** The focus move
    resolves an index for `ArrowDown`, and when there was no row below it fell
    through to the *date* branch — which stepped `previousWeek`, so one press
    of "a week down" from the last row silently became "a week earlier". Only
    a month or year move may leave the grid now.
13. **The focus started on the 1st of the month.** It was resolved in
    `initState`, before the slot list existed, so the fallback to "the first
    selectable day" read an empty list and returned `view`'s first day. It is
    resolved from the built slots instead.
14. **A month or year cell could hold neither the focus nor "today".** Those
    cells hold the *first* of the month (or of January), and the comparison was
    by day, so the ring and the today fill never appeared in those two grids.
    Matching is now at the grid's own granularity.
15. **The screen reader heard the date twice.** The `Semantics` label said
    "Mar 14, 2024" and the `Text` inside added "14"; the painted number is now
    excluded.

## Migrating from the old Calendar

| Old | New |
|---|---|
| `Calendar(view:, selectionMode:)` | same |
| `CalendarView(year, month)` / `.now()` / `.fromDateTime()` | same (`.now()` → `CalendarView.fromDateTime(DateTime.now())`) |
| `CalendarValue.single/range/multi` | same names, now in `primitives/date_math.dart` |
| `value.lookup(y, m, d)` | `value.lookupDate(date)` |
| `MonthCalendar` / `YearCalendar` | `viewType: month` / `viewType: year` |
| `isDateEnabled:` | `stateBuilder:` |
| `CalendarItem`, `CalendarItemType`, `CalendarGrid*` | private; a cell is not constructed by a caller |
| `DatePickerDialog` | batch B13's `date_picker` |
| `CalendarGridItem.isToday` | `Calendar(now: ...)` |