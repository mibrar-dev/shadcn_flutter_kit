# P6-F3b — preview contract conversions, batch B

Covers 19 components: `navigation_bar`, `navigation_menu`, `object_input`,
`overflow_marquee`, `pagination`, `phone_input`, `pinned_sheet`, `popup`,
`radio_group`, `refresh_trigger`, `resizable`, `scaffold`, `scrollable`,
`scrollbar`, `scrollview`, `select`, `selectable`, `slider`, `sortable`.

## Conversion pattern (same as button/card/chip + P6-F3c)

- Each `preview.dart` now exports `const List<ComponentPreview> <camel>Previews`
  (first entry = default), one focused demo per example.
- Removed: root/nested `ShadcnTheme(data: const ShadcnThemeData(...))` pins,
  `darkFallback` legs, `Directionality`/`ColoredBox`/`SingleChildScrollView`
  gallery scaffolding, outer gallery heights, shared controllers, `Expanded`
  under unbounded constraints.
- Spacing and colours read `ShadcnTheme.of(context)`; fixed widths are modest
  (`200`–`360`) so examples fit both the 720×420 stage and 375-wide phones.
- Controllers/state live in the example's own `StatefulWidget`.
- Inherently-measured components (sheet, scaffold, resizable, scrollbar,
  scrollview, refresh list, sidebar, vertical marquee) carry their own bounded
  box with a comment saying why — same dispensation as P6-F3c `toast`
  (`360×220`) and `swiper` (`320×200`).
- `grep -rln "ShadcnThemeData("` over the 19 files: empty. No
  Material/Cupertino imports. No implementation files changed (all bugs were
  preview-side).

## Component → examples

| Component | Examples (first = default) |
|---|---|
| `navigation_bar` | Default, With labels, Sidebar |
| `navigation_menu` | Bar, Content list |
| `object_input` | Date, Time, Duration |
| `overflow_marquee` | Horizontal, Vertical |
| `pagination` | Labelled, Icon only |
| `phone_input` | Default, Custom countries, Invalid |
| `pinned_sheet` | Default, Snapping |
| `popup` | Default, Anchored |
| `radio_group` | Default, Card items |
| `refresh_trigger` | Default, Refreshing |
| `resizable` | Absolute, Flexible |
| `scaffold` | Default, With loading |
| `scrollable` | Default, Vertical |
| `scrollbar` | Default, Always visible, Themed |
| `scrollview` | Default |
| `select` | Default, With groups, Disabled |
| `selectable` | Default, Long text |
| `slider` | Default, Range, Steps |
| `sortable` | Default, Grid |

Dropped legs: every `darkFallback`/pinned-theme leg, rail demo, horizontal
radio demo, controller-driven radio demo, disabled radio rows, resizable
vertical/constrained/controlled/themed demos, scaffold floating-header and
progress-reference legs, marquee "fits" leg, selectable disabled/caret legs,
slider wave/variant-loop legs, sort `fallback` gallery extras. Token-`ref`
legs kept (`scrollbar` primary thumb). Sortable `::` handle glyph replaced by
`LucideIcons.gripVertical`; resizable `Color(0x11000000)` pane fills replaced
by `colors.muted`.

## Bugs fixed (all preview-side; no impl changes)

- `navigation_bar` gallery 460px overflow: split into three bounded examples;
  sidebar in a `260×320` box (the container scrolls internally).
- `navigation_menu` THREW (`BoxConstraints` infinite width,
  `navigation_menu.dart:190` `maxWidth: double.infinity`): each example now
  carries its own `340`-wide box, which clamps the infinite max width.
- `phone_input` THREW (flex under unbounded width): examples use a
  widget-leg `PhoneInputTheme(selectWidth: 136, maxWidth: 160)` so the row
  totals 304px. The 136 (not 120) was measured: flag + dial code + chevron
  overflow a 120px selector by 2px at 375-wide (probe test, since removed).
- `pinned_sheet` THREW (height unbounded + `Expanded` + `Stack` at
  `pinned_sheet.dart:369`): each example is a bounded `320×280` / `320×240`
  box with its own `SheetController`; no `Expanded`.
- `radio_group` 150px overflow: split into Default rows / Card items, each
  with its own selection state (the shared `_controller` + `_plan` are gone).
- `refresh_trigger` THREW (viewport unbounded width) + `TriggerStage.values`
  dump: Default is a live list in a `320×200` box; Refreshing is one frozen
  `DefaultRefreshIndicator` (`TriggerStage.refreshing`).
- `resizable` 434px overflow: split into Absolute (`defaultSize` panes) /
  Flexible (`flex` panes), each `360×140`.
- `scaffold` THREW (infinite width): Default `360×280` shell, With loading
  `360×200` shell.
- `scrollable` 26px overflow: Default horizontal strip (`320×72`), Vertical
  list (`280×160`).
- `scrollbar` THREW (shared `ScrollController` across four lists,
  `preview.dart:22`) + 408px overflow: each example is its own `StatefulWidget`
  with its own controller (`320×180`).
- `slider` THREW (track given infinite size) + `SliderVariant.values` dump:
  Default / Range / Steps, each `320` wide with its own state.
- `pagination` right-overflow at 375-wide (Labelled 111px, Icon only 13px):
  each example scrolls horizontally (no-op at 720) — same fix as P6-F3c `tabs`.
- `selectable` / `overflow_marquee` root-pinned `ShadcnThemeData`: deleted;
  selectable width cut `420` → `320` (420 overflowed phones).

## Deviations from §4.2 (with cause)

- `phone_input` "With leading icon" → "Custom countries": `PhoneInput`
  exposes no leading-icon slot (verified in `phone_input.dart`: country
  `Select` + number `Input` only). "Custom countries" covers the `countries`
  API instead.
- `select` "With groups": no group widget exists in the select API, so groups
  are disabled header `SelectItem`s (tap-disabled via `SelectRow(enabled:
  false)` — verified in `primitives/select_popup.dart`).
- `scrollable` Default is the horizontal strip, Vertical the list (keeps the
  json example names `['Default', 'Vertical']`).
- Harness at `test/registry/previews_f3b_test.dart`, not `previews_f3.dart`:
  `flutter test` ignores files without the `_test.dart` suffix, so the brief's
  literal name would never run (follows the `previews_f3c_test.dart`
  precedent). `test/registry/previews_test.dart` untouched (P6-F3 owns it).

## Gates

- `dart format` on all 20 files (19 previews + harness): clean.
- `flutter analyze` on all 19 component dirs + harness: **No issues found**.
- `flutter test test/registry/previews_f3b_test.dart`: **115/115 pass**
  (19 components × (2 static + 4 combo); each combo pumps every example at
  720×420 and 375-wide under neutral/claude × light/dark).
- `flutter test test/registry/previews_test.dart` (P6-F3-owned, unmodified):
  **448/448 pass** — no regression.

## Progress log

All 19 components converted in one pass (batches of 4–5 files, analyze run
after batch 1–2, harness green after fixing pagination phone overflow and the
phone_input 136px selector width). Report written last. Done; nothing pending.
