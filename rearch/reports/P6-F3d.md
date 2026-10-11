# P6-F3d — preview contract conversions, batch D (tail)

Covers 12 components: `file_diff_viewer`, `file_picker`, `filter_bar`, `form`,
`formatted_input`, `gooey_toast`, `hover_card`, `item_picker`, `markdown`,
`menu`, `menubar`, `multi_select`.

## Conversion pattern (same as button/card/chip + P6-F3b/P6-F3c)

- Each `preview.dart` now exports `const List<ComponentPreview> <camel>Previews`
  (first entry = default), one focused demo per example.
- Removed: root/nested `ShadcnTheme(data: const ShadcnThemeData(...))` pins,
  `darkFallback` legs, `Directionality`/`ColoredBox`/`SingleChildScrollView`
  gallery scaffolding, outer fixed-height boxes, shared controllers, `Expanded`
  under unbounded constraints.
- Spacing and colours read `ShadcnTheme.of(context)`; fixed widths are modest
  (`240`–`340`) so examples fit both the 720×420 stage and 375-wide phones.
- Controllers/state live in the example's own `StatefulWidget`.
- Inherently-measured components (diff viewer scroll regions, upload surfaces,
  filter search field, form rows, gooey layer) carry their own bounded box with
  a comment saying why — same dispensation as P6-F3c `toast` (`360×220`).
- `grep -rln "ShadcnThemeData("` over the 12 files: empty. No
  Material/Cupertino imports. No implementation files changed (all bugs were
  preview-side).

## Component → examples

| Component | Examples (first = default) |
|---|---|
| `file_diff_viewer` | Unified, Split |
| `file_picker` | Dropzone, Tile, Trigger |
| `filter_bar` | Default, With chips |
| `form` | Default, Validating |
| `formatted_input` | Phone, Date, Card |
| `gooey_toast` | Pill, Expanded |
| `hover_card` | Default, Rich content |
| `item_picker` | Grid, List |
| `markdown` | Default, Streaming tail |
| `menu` | Default, With checkbox item, With radio group |
| `menubar` | Default, With submenu |
| `multi_select` | Default, With badges, Disabled |

## Bugs fixed

- `file_diff_viewer` 156px overflow: split the three-leg gallery into two
  bounded examples; dropped the `ComponentTheme` leg with the literal green
  `additionColor` (pinned colour) and the `Navigator`/`ShadcnTheme` scaffolding
  (`SelectableRegion` needs no overlay until text is selected; the harness
  wraps in `Overlay` anyway). The viewer's internal horizontal scroller absorbs
  `minContentWidth: 720` at 375-wide, so no overflow.
- `file_picker` THREW (`BoxConstraints` infinite width,
  `file_picker.dart:253` stretch + old `preview.dart:385` `Expanded`): each
  example is `320` wide with its own `FileUploadController`.
- `filter_bar` 550px overflow: split into two `340`-wide `inline` examples
  (no sheet, no `900`-wide rich leg); dropped the `darkFallback` leg.
- `form` THREW (flex under unbounded width, `form.dart:170,301` `Expanded`):
  each example is `320` wide with its own `FormController`.
- `formatted_input` gallery + `darkFallback` leg: split into Phone/Date/Card
  (`300` wide); dropped the `components/icon` import (bare `Icon` with an
  explicit size) and the dark leg.
- `gooey_toast` `values`-loop gallery (D2): Pill + Expanded, each a `360×220`
  stage (same dispensation as P6-F3c `toast`) with its own controller and a
  persistent demo toast (`persistUntilDismissed` + `autoDismiss: false`, so no
  timer outlives the test).
- `hover_card` root-pinned `ShadcnThemeData` (`preview.dart:20`, §2.1): pin,
  `ColoredBox` and scroll scaffolding deleted; Default + Rich content read the
  ambient theme.
- `item_picker` THREW (flex under unbounded width): Grid + List, each `320`
  wide with its own selection state; the `_ColorSwatch` literal `Color(...)`
  fills are now `chart1/2/3` theme tokens; dropped the trigger and dark legs.
- `markdown` THREW (flex under unbounded width, old `preview.dart:79`
  `SizedBox(width: double.infinity)`): Default (`320` wide, images through a
  bounded local `imageBuilder` placeholder — no network) + Streaming tail (a
  static mid-stream snapshot: the stable prefix via the parser's own
  `computeStableMarkdownPrefixLength` plus a `▍` cursor in the primary token;
  no timers, no `text_animate` import). Dropped the link-taps, themed-override
  and dark legs.
- `menu` root-pinned `ShadcnThemeData` (`preview.dart:16`, §2.1): pin,
  `ColoredBox` and scroll scaffolding deleted; `MenuPopup(width: 240)` renders
  inline with `MenuGroup(autofocus: false)`; checkbox/radio rows are live
  (example-local state). Dropped the horizontal bar leg (owned by `menubar`).
- `menubar` needed no bug fix (old preview already shrink-wrapped with no
  pin); converted to Default + With submenu (`MenuSub` zoom levels).
- `multi_select`: Default + With badges (three removable chips) + Disabled
  (`enabled: false`); each `260` wide with its own selection. Only the trigger
  renders (the popup opens on tap).

## Deviations from §4.2 (with cause)

- `filter_bar` "With chips" keeps the date-range/trailing/custom-filter legs
  dropped: they need `900`-wide stages and cannot fit 720×420 or 375-wide.
- `form` "Validating" shows a `changed`-mode error on an empty field instead
  of a submitting/error toggle: submit is user-driven, so idle/submitting/error
  cannot be three static examples.
- `formatted_input` has no separate "Card state" leg: kinds are Phone/Date/Card
  (state is covered by the validating Date leg).
- `item_picker` Grid/List only: `mode: dialog/popover` needs overlay
  interaction, which a static example cannot show; the dialog body is the same
  widget both modes present.
- `markdown` "Streaming tail" is a static stable-prefix snapshot, not a live
  stream: live streaming needs timers, which must not outlive the test; the
  animation itself belongs to `text_animate` (`withTextStreaming`).
- `menu` drops the "Menubar bar (horizontal group)" leg: it belongs to
  `menubar` (converted there).
- `multi_select` adds "Disabled" beyond §4.2 (matches §4.2's own
  `state: enabled/disabled` control).
- Harness at `test/registry/previews_f3d_test.dart`, not `previews_f3.dart`:
  `flutter test` ignores files without the `_test.dart` suffix, so the brief's
  literal name would never run (same deviation as P6-F3b, which P6-F3 accepted
  for `previews_f3b_test.dart`). `test/registry/previews_test.dart` untouched
  (P6-F3 owns it; this batch stays in its `_pending` list until P6-F3
  regenerates it).

## Gates

- `dart format` on all 13 files (12 previews + harness): clean.
- `flutter analyze` on all 12 component dirs + harness: **No issues found**
  (three batch runs, one per batch of four).
- `flutter test test/registry/previews_f3d_test.dart`: **73/73 pass**
  (12 components × (2 static + 4 combo); each combo pumps every example at
  720×420 and 375-wide under neutral/claude × light/dark).
- `flutter test test/registry/previews_test.dart` (P6-F3-owned, unmodified):
  **448/448 pass** — no regression.
- `grep -rln "ShadcnThemeData("` over the 12 previews: empty. No
  Material/Cupertino imports in written Dart (the two `material.dart` grep hits
  under `menu/` are pre-existing prose in `README.md`/`meta.json`, untouched).
- Truncation check (`grep 'truncated'` over all 13 files): clean.

## Progress log

- Batch 1 (`file_diff_viewer`, `file_picker`, `filter_bar`, `form`): written,
  `dart format` clean, `flutter analyze` **No issues found**.
- Batch 2 (`formatted_input`, `gooey_toast`, `hover_card`, `item_picker`):
  written, `dart format` clean, `flutter analyze` **No issues found** (one
  fix during writing: `FormValidationMode` needs a direct
  `primitives/form_core/form_core.dart` import — `formatted_input.dart` does
  not re-export it).
- Batch 3 (`markdown`, `menu`, `menubar`, `multi_select`): written,
  `dart format` clean, `flutter analyze` **No issues found**.
- Harness `test/registry/previews_f3d_test.dart`: **73/73 pass**.
  P6-F3-owned `test/registry/previews_test.dart`: **448/448 pass**.
  Report finished. Done; nothing pending.
