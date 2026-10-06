# P4-PRIM-A — Phase 4 primitives batch (scroll_metrics, date_math, color_math, menu_nav)

Unit: P4-PRIM-A · Builder A (deepseek-v4.1-flash) · 2026-10-06 · QA round 1.

Outputs:
`flutter_shadcn_kit/lib/registry_next/primitives/{scroll_metrics,date_math,color_math,menu_nav}.dart`,
`flutter_shadcn_kit/test/registry_next/primitives/{scroll_metrics,date_math,color_math,menu_nav}_test.dart`,
this report. Nothing else was created or modified.

## 0. Why these four files exist

The old tree had no shared scroll/date/colour/menu-navigation primitives; the
math was duplicated inline per component (fade fractions, month grids, hex
parsing, menu focus intents) or lived inside `RawScrollbar`/`SubFocus`
internals. The four files below centralise only what the batch notes ask for
and deliberately leave layer-3 owners where the plan places them:
`ScrollableClient*` (scrollable_client), `MenuPopup`/`MenuGroupData` (menu),
`ColorPickerMode` (color_picker), `DatePart`/`TimePart`/`DurationPart`
(localizations). All imports are same-layer or lower:
`date_math.dart` is the only file with imports (`../foundation/time_of_day.dart`,
`localizations/locale_parts.dart`); the other three import only Flutter.

| ID | File | LOC | Imports | Needed by (batch data) |
|---|---|---|---|---|
| P4-PRIM-1 | `primitives/scroll_metrics.dart` | 214 | widgets | scrollbar, scrollview, scrollable, scrollable_client, table, carousel |
| P4-PRIM-2 | `primitives/date_math.dart` | 202 | foundation, localizations | calendar, date_picker, time_picker, object_input |
| P4-PRIM-3 | `primitives/color_math.dart` | 85 | dart:math, dart:ui | color, color_field, color_picker, hsl, hsv, eye_dropper, color_input |
| P4-PRIM-4 | `primitives/menu_nav.dart` | 110 | — | menu, menubar, select, command, dropdown_menu, context_menu |

No file is near the 400-line limit; no `meta.json` is involved (primitives are
implicit layers, same as P2-E1/P2-E2).

## 1. P4-PRIM-1 `primitives/scroll_metrics.dart`

### 1.1 API

- `const double kMinScrollbarThumbExtent = 48` — the old
  `_kScrollbarMinLength` from `shadcn_scrollbar_state.dart`, shared with any
  custom thumb painter.
- `ScrollMetricsSnapshot` — value type (`==`/`hashCode`/`toString`) with
  `pixels`, `minScrollExtent`, `maxScrollExtent`, `viewportDimension`, `axis`,
  `axisDirection`; `ScrollMetricsSnapshot.fromMetrics(ScrollMetrics)` reads a
  live notification. Derived members:
  - `scrollableExtent`, `canScroll`, `atStart`, `atEnd`, `reversed`, `progress`;
  - `overscrollPixels` (signed distance outside the edges);
  - `leadingFadeFraction(extent)` / `trailingFadeFraction(extent)` — the
    `FadedScrollableViewport` math;
  - `leadingOverscrollFraction(extent)` / `trailingOverscrollFraction(extent)`
    — edge-glow strength while dragging past an edge;
  - `thumbExtent(trackExtent, {minExtent})`, `thumbOffset(trackExtent,
    thumbExtent, {reversed})`, `pixelsForThumbOffset(...)` — scrollbar thumb
    geometry and its inverse (for thumb dragging).
- `clampScrollPixels(pixels, {min, max, allowOverscroll})` — the 2D viewport's
  per-axis clamp.
- `maxScrollExtentFor({contentExtent, viewportExtent})` — the
  `applyContentDimensions` bound.

### 1.2 Old → new mapping (math extracted from inline code)

| Old file (LOC) | Moved into | Note |
|---|---|---|
| `components/layout/scrollable/_impl/core/faded_scrollable_viewport.dart` (99) | `leadingFadeFraction` / `trailingFadeFraction` | old getters `pixels/extent` and `(max-pixels)/extent`, clamp 0..1 |
| `components/layout/scrollable[_client]/_impl/core/render_scrollable_client_viewport.dart` (90 + 87) | `clampScrollPixels`, `maxScrollExtentFor` | old `max(0, min(pixels, content - viewport))` per axis |
| `components/control/scrollbar/_impl/state/shadcn_scrollbar_state.dart` (119) | `kMinScrollbarThumbExtent`, thumb math | old constant + `RawScrollbar`'s internal fraction formula |
| `components/control/scrollview/_impl/state/scroll_view_interceptor_state.dart` (177) | not ported | middle-mouse auto-scroll is scrollview component business |
| `components/control/scrollbar/{scrollbar_widget,shadcn_scrollbar}.dart` (118) | not ported | widget/theme wiring stays in `scrollbar` (B05) |

LOC: old scroll math spread over ~300 lines of the files above (whole-file
counts include widget/theme code that stays in the components) → 214 generic
lines with the widget layers removed.

### 1.3 Fixes / deliberate deviations

1. **Overscroll support added.** The old fade viewport returned 0 for both
   fades whenever `maxScrollExtent <= 0` and had no notion of being dragged
   past an edge at all. The snapshot keeps the fade fractions for the
   in-range case and adds the two overscroll fractions, so a scrollable's
   glow can be driven without new per-component math.
2. **No per-notification `setState` bug carried over.** The old
   `_FadedScrollableViewportState` rebuilt on every `ScrollNotification`; the
   primitive is stateless — the component decides when to rebuild.
3. **Thumb minimum is capped at the track length**, matching
   `ScrollPainter._setThumbExtent` (`clamp(…, min(minLength, track), track)`).
   The iOS-style shrink during overscroll (`minOverscrollLength`) is *not*
   modelled; a component that wants it can drive it from
   `overscrollPixels` — open question Q1.
4. **`minScrollExtent` supported** (old fade math assumed 0) and reversed
   axes put the thumb at the far end, matching RTL scrollbars.

## 2. P4-PRIM-2 `primitives/date_math.dart`

### 2.1 API

- Calendar basics: `isLeapYear(year)`, `daysInMonth(year, month)`,
  `startOfMonth(year, month)`, `startOfWeek(date, {firstDayOfWeek})`,
  `addMonths(date, months)` (clamps the day to the target month and keeps the
  time of day), `clampDate(date, {min, max})`.
- `DateGridCell` (value type) + `monthGrid(year, month, {firstDayOfWeek})` —
  whole-week grids with `date`, `indexInRow`, `rowIndex`,
  `fromAnotherMonth`; configurable week start (`DateTime.monday` … `.sunday`).
- Value ranges (the `computeValueRange` logic P2-E2 dropped):
  `dayValueRange({year, month})`, `datePartValueRange(part, {year, month})`,
  `timePartValueRange(part)`, `durationPartValueRange(part)` — same semantics
  as the removed enum fields (`year` and duration days stay unbounded).
- Readers (the `getter` logic): `datePartValue(date, part)`,
  `timePartValue(date, part)`, `durationPartValue(duration, part)`.

`DatePart`/`TimePart`/`DurationPart` are imported from
`primitives/localizations/locale_parts.dart` and **not** re-declared.
`TimeOfDay` comes from `foundation/time_of_day.dart` (widgets-only).

### 2.2 Old → new mapping

| Old file (LOC) | Moved into | Note |
|---|---|---|
| `utility/locale_utils/_impl/core/{date,time,duration}_part.dart` (84) | `datePartValueRange`, `timePartValueRange`, `durationPartValueRange`, `*PartValue` | the two fields P2-E2 removed; enums stay in localizations |
| `utility/locale_utils/locale_utils.dart` (184) | `dayValueRange` + private `_compute*ValueRange` bodies | `_getYear/Month/Day` etc. become the `*PartValue` switches |
| `display/calendar/_impl/core/calendar_grid_data.dart` (99) | `monthGrid` + `DateGridCell` | same leading/trailing week fill |
| `display/calendar/_impl/core/calendar_grid_item.dart` (52) | `DateGridCell` | `isToday` dropped (component view concern) |
| `display/calendar/_impl/utils/calendar_view.dart` (165) | `startOfMonth` / `addMonths` | month navigation arithmetic; `CalendarView` class stays in `calendar` |

LOC: ~300 old lines of date math (whole-file counts include UI/classes that
stay in the calendar component) → 202 generic lines.

### 2.3 Fixes / deliberate deviations

1. **`monthGrid` is week-start aware.** The old `CalendarGridData` hard-coded
   `DateTime.weekday` (Monday) semantics via `firstDayOfMonth.weekday`; the
   primitive takes `firstDayOfWeek` so the calendar can honour locale week
   data without forking the grid code.
2. **`addMonths` fixes the classic month-overflow trap.** `DateTime(y, m+1, 31)`
   in Dart jumps into the next month; the helper clamps to `daysInMonth` (old
   calendar navigation only stepped one month at a time on day 1, so no bug was
   carried, but the helper is now safe for arbitrary day values; tested).
3. **`daysInMonth` drops the old `month == 12 ? 1 : month + 1` ternary** —
   `DateTime(year, month + 1, 0)` already rolls over correctly (tested for
   December).
4. `DateGridCell.isToday` is not ported: it called `DateTime.now()` inside a
   value type, which is untestable and belongs to the widget/render layer.

## 3. P4-PRIM-3 `primitives/color_math.dart`

### 3.1 API

- `colorFromHex(String) -> Color?` — accepts `#RGB`, `#RRGGBB`,
  `#AARRGGBB` (the format `colorToHex(showAlpha: true)` emits), with optional
  `#`/`0x` prefix; returns null for anything malformed.
- `contrastRatio(Color, Color)` — WCAG 2.1 relative-luminance ratio (1…21).
- `pickContrastingColor(background, {light, dark})` — the
  `destructiveForeground` derivation: dark destructive ⇒ light label and vice
  versa; ties prefer `light`.
- `isLightColor(color, {threshold})` — luminance threshold test.

### 3.2 Old → new mapping

| Old file (LOC) | Fate |
|---|---|
| `components/form/color_picker/_impl/core/color_controls.dart` (435) | hex parsing hand-rolled with `int.parse` → `colorFromHex` (`tryParse` + digit check); the rest is picker UI |
| `components/utility/color/color.dart` (62) | `colorToHex` stays with `theme/color_utils.dart` (already owned); gradients/`ColorDerivative` stay in the `color` component |
| `shared/utils/color_extensions.dart` (150) | already ported: `foundation/color_extensions.dart` (`toHSL`/`toHSV`, `scaleAlpha`, `getContrastColor`) + `theme/color_utils.dart` (`colorToHex`, `fromAHSL`). Not duplicated. |
| `components/layout/app/_impl/core/shadcn_ui.dart` / `display/chat/chat.dart` | inline `computeLuminance() >= 0.5` contrast picks → `isLightColor` / `pickContrastingColor` |

LOC: ~40 old lines of inline parse/contrast logic at the call sites → 85
dedicated lines (the conversions themselves were already owned elsewhere).

### 3.3 Fixes / deliberate deviations

1. **Old bug fixed (do not port):** the picker's hex handler used
   `int.parse(hex.substring(…), radix: 16)` — a malformed 6-character paste
   (`#zzzzzz`) throws `FormatException`. `colorFromHex` returns null instead
   and is covered by the `rejects unsupported input` test.
2. `int.tryParse` alone accepts a leading sign on radix 16 (`+ff` → 255); an
   explicit hex-digit check rejects it (test).
3. **Deviation, documented up front:** RGB/HSL/HSV *channel* conversion is not
   declared here because `foundation/color_extensions.dart` (accepted P2-E1)
   already owns `Color.toHSL`/`toHSV`, `HSLColor.toHSV`, `HSVColor.toHSL` and
   `theme/color_utils.dart` owns `fromAHSL`. Re-declaring them would fail
   `check_single_owner`; `color_math` adds the two pieces neither file has
   (parse + contrast pick).

## 4. P4-PRIM-4 `primitives/menu_nav.dart`

### 4.1 API

- `nextEnabledIndex({count, current, forward, wrap, isEnabled})` — roving
  index traversal that skips disabled entries; wraps by default, stops at the
  edge when `wrap: false`; null when nothing is enabled.
- `firstEnabledIndex(count, {isEnabled})` / `lastEnabledIndex(...)` — entry
  points for opening a menu on the first/last usable item.
- `MenuTypeahead` — the type-to-select buffer: `query`, `type(character,
  {now})` (accumulates within `resetDelay`, default 600 ms, then restarts;
  ignores non-single-rune input), `reset()`, and `match(labels, {start,
  isEnabled})` (case-insensitive prefix search from `start`, wrapping,
  skipping disabled entries; null when empty/no match).

`SubFocus`/`SubFocusScope` stay the focus-ownership primitive; this file only
replaces list-index math. No new `Intent` classes are declared — intents are
component-owned (menu/menubar/select author theirs).

### 4.2 Old → new mapping

| Old file | Fate |
|---|---|
| `components/overlay/menu/_impl/state/menu_group_state.dart` (274), `_impl/utils/{menu_directional_intent,next_menu_focus_intent,open_sub_menu_intent,menu_intents}.dart`, `_impl/state/menubar_state.dart` (93) | old traversal was `SubFocusScope.nextFocus` (geometry) + intent classes; the enabled-skipping/wrap/typeahead math is now in the primitive, the intents stay in the components for B10/B13/B20 |
| (none) | typeahead did not exist in the old menu — behaviour ADD, tested |

LOC: ~110 new lines; the old menu's intent/focus wiring (~150 lines across the
files above) is replaced where used, and the geometry part remains SubFocus.

### 4.3 Fixes / deliberate deviations

1. **Disabled entries are skipped deterministically.** `SubFocusScope` moves
   by geometry and only refuses *focused* disabled items; list traversal in
   the new menus uses `isEnabled` so mouse/keyboard agree.
2. **Typeahead is a buffer, not a global timer** — no global mutable state;
   tests inject `now`, so behaviour is deterministic.

## 5. Tests (`test/registry_next/primitives/`, 56 cases, all passing)

| File | Cases | Covers |
|---|---|---|
| `scroll_metrics_test.dart` (214) | 14 | `fromMetrics` field copy; progress/clamps; signed overscroll; fade fractions vs old `FadedScrollableViewport` math; overscroll fractions; thumb extent/offset incl. min clamp, track cap, non-scrollable, reversed axis; inverse round-trip; equality; `clampScrollPixels` (incl. NaN and inverted range) / `maxScrollExtentFor` |
| `date_math_test.dart` (190) | 19 | leap years (2000/1900/2024/2023); month lengths; four-week and five-week grids incl. Sunday-start; `indexInRow`/`rowIndex`/outside flags; startOfWeek/startOfMonth; `addMonths` clamping + time preservation + negative shifts; `clampDate`; all range functions; all part readers incl. Duration normalisation; `DateGridCell` equality |
| `color_math_test.dart` (102) | 9 | hex forms (`#RGB`, `#RRGGBB`, `#AARRGGBB`, `0x`, no prefix, lowercase); malformed input incl. the old `int.parse` crash case and sign characters; WCAG ratio (21, 1, symmetry, alpha ignored); contrast pick dark/light/custom; `isLightColor` threshold |
| `menu_nav_test.dart` (164) | 14 | forward/backward skip, wrap and no-wrap edges, all-disabled/empty, default predicate; first/last; typeahead accumulation, reset delay, non-rune rejection, reset; case-insensitive match from offset, wrap, disabled skip, empty/no-match |

Test LOC: 670. They are unit tests (the unit is a value helper); there is no
widget surface to pump, so light/dark token rendering and interaction states do
not apply — the contracts are the numbers these helpers return, and the
consuming components' tests will exercise them through widgets.

## 6. Gates (raw, from `flutter_shadcn_kit/`)

Scoped to this batch:

```
$ dart format --set-exit-if-changed <4 primitives> <4 tests>
Formatted 8 files (0 changed) in 0.01 seconds.        exit=0

$ dart analyze lib/registry_next/primitives/{scroll_metrics,date_math,color_math,menu_nav}.dart \
      test/registry_next/primitives/{scroll_metrics,date_math,color_math,menu_nav}_test.dart
No issues found!

$ flutter test test/registry_next/primitives/{scroll_metrics,date_math,color_math,menu_nav}_test.dart
00:00 +56: All tests passed!

$ dart run tool/rearch/check_layers.dart --root lib/registry_next   (JSON filtered to my 4 files)
findings on my files: 0

$ dart run tool/rearch/check_single_owner.dart --root lib/registry_next
check_single_owner: 140 files scanned, 480 declarations, 0 files with syntax errors
duplicate names: 0 (public 0, private 0) - identical 0, diverged 0

$ dart run tool/rearch/check_user_theme.dart --root lib/registry_next --strict
check_user_theme: 0 finding(s)

$ grep -rlnE "// ignore|^import 'package:flutter/(material|cupertino).dart'|^part " <my 8 files>
(no matches)
```

Directory-wide `rearch/qa_gate.sh lib/registry_next` (last run 2026-10-06):

```
format:  Formatted 187 files (0 changed)
analyze: No issues found! | tests: 43 issues found.
test:    (fails to load test/registry_next/visual/pilot_screenshots_test.dart — not this batch)
rearch:  +38: All tests passed!
layers:  file-too-long: 10 (warning)
owner:   duplicate names: 0
theme:   check_user_theme: 0 finding(s)
banned:  (empty)
stray:   (empty)
```

**In-flight parallel work (not mine) accounts for every non-clean line:**
`test/registry_next/visual/pilot_screenshots_test.dart` has 43 analyzer
errors/warnings (missing imports and undefined helpers) and cannot load;
`primitives/file_value.dart` (499 lines) and `primitives/toast_queue.dart`
(P4-PRIM-B) are the 9th and 10th `file-too-long` warnings. My four primitives
contribute 0 findings to `check_layers` (verified by filtering the JSON
report), `check_single_owner` is 0 across the whole tree, and the directory
`dart analyze lib/registry_next` is clean as of the last run.
`file-too-long` baseline before this batch was 7 (3 icon files + 4 theme
files), so my files add **zero** new warnings.

## 7. Deviations and open questions

Deviations:

1. P4-PRIM-1 grew two helpers beyond the literal "metrics + glow" note
   (`clampScrollPixels`, `maxScrollExtentFor`) because the 2D viewport render
   object (B05) otherwise re-inlines them; both are 5 lines and tested.
2. P4-PRIM-3 does not declare HSL/HSV channel conversions — they are already
   owned by `foundation/color_extensions.dart` / `theme/color_utils.dart`
   (see §3.3.3). If QA wants the primitive to re-export them for ergonomics,
   that would change single-owner (say so and I will add `export`s).
3. `menu_nav` adds typeahead as new behaviour (the old menu had none); the
   note asked for it, so this is expected rather than a port.

Open questions:

- **Q1** Scrollbar thumb during overscroll: keep the clamped minimum (Flutter
  3.47 behaviour, implemented) or model the iOS shrink
  (`minOverscrollLength`) in B05's component using `overscrollPixels`?
  Recommendation: component-level, not primitive.
- **Q2** `MenuTypeahead.resetDelay` (600 ms) — does QA want the platform
  constant exposed a different way (e.g. per-theme field), or is the ctor
  parameter enough? Recommendation: ctor parameter; no theme field until a
  component asks.
- **Q3** `datePartValueRange` returns nullable bounds to keep the old
  "unbounded year" semantics. If the object_input builders prefer non-null
  record bounds, the functions can gain defaults later; no caller exists yet.

## RESULT

```
status: done
files_written:
- flutter_shadcn_kit/lib/registry_next/primitives/scroll_metrics.dart
- flutter_shadcn_kit/lib/registry_next/primitives/date_math.dart
- flutter_shadcn_kit/lib/registry_next/primitives/color_math.dart
- flutter_shadcn_kit/lib/registry_next/primitives/menu_nav.dart
- flutter_shadcn_kit/test/registry_next/primitives/scroll_metrics_test.dart
- flutter_shadcn_kit/test/registry_next/primitives/date_math_test.dart
- flutter_shadcn_kit/test/registry_next/primitives/color_math_test.dart
- flutter_shadcn_kit/test/registry_next/primitives/menu_nav_test.dart
- rearch/reports/P4-PRIM-A.md
commands_run:
- dart format (4 primitives + 4 tests) -> 0 changed, exit 0
- dart analyze (same 8 files) -> No issues found!
- flutter test (same 4 test files) -> +56: All tests passed!
- check_layers --root lib/registry_next -> 0 findings on my files (others' file_value.dart is the 9th warning)
- check_single_owner --root lib/registry_next -> 0 duplicates
- check_user_theme --strict -> 0 findings
- banned grep -> no matches
key_findings:
- All four primitives are new shared machinery; the old tree had no direct source files (the math was inline in scrollbar/scrollable/calendar/locale_utils/colour components).
- Old bug fixed: picker hex parsing used int.parse and threw on malformed input -> colorFromHex returns null (regression test included).
- Deliberate: HSL/HSV channel conversion stays in foundation/theme (single-owner); color_math adds hex parse + WCAG contrast pick.
- date_math re-adds the getter/computeValueRange logic P2E2 dropped, scoped to DatePart/TimePart/DurationPart callers; month grids are now week-start aware.
- scroll_metrics adds overscroll fractions the old fade viewport never had and keeps the old fade math intact for the in-range case.
- Directory gate noise comes from parallel batches' in-flight files (visual/pilot_screenshots_test.dart, primitives/file_value.dart); my folders are clean.
open_questions:
- Q1 scrollbar thumb overscroll shrink: component-level (recommended) or primitive?
- Q2 MenuTypeahead reset delay as ctor param (recommended) or theme field?
- Q3 nullable year bounds in datePartValueRange — keep (old semantics) or non-null?
```
