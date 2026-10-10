# P6-F3c — preview contract conversions, batch C

Covers 19 components: `spell_check_suggestions_toolbar`, `stage_container`,
`star_rating`, `stepper`, `steps`, `swiper`, `switch`, `switcher`, `table`,
`tabs`, `text_animate`, `text_area`, `time_picker`, `timeline`, `toast`,
`tooltip`, `tracker`, `tree`, `window`.

## Conversion pattern (same as button/card/chip)

- Each `preview.dart` now exports `const List<ComponentPreview> <camel>Previews`
  (first entry = default), one focused demo per example.
- Removed: root/nested `ShadcnTheme(data: const ShadcnThemeData(...))` pins,
  `darkFallback` legs, `Directionality`/`ColoredBox`/`SingleChildScrollView`
  gallery scaffolding, outer fixed-height boxes, shared controllers,
  `Expanded` under unbounded constraints.
- Spacing and colours read `ShadcnTheme.of(context)`; fixed widths are modest
  (`320`–`400`) so examples fit both the 720×420 stage and 375-wide phones.
- Controllers/state live in the example's own `StatefulWidget` (`switch`,
  `stepper` failed-step, `table` resizable, `tabs` strip + pane, `toast` ×3,
  `window` ×2, `time_picker` triggers, `star_rating` interactive,
  `switcher` horizontal, `text_area` invalid).
- `grep -rln "ShadcnThemeData("` over the 19 files: empty. No
  Material/Cupertino imports.

## Component → examples

| Component | Examples (first = default) |
|---|---|
| `spell_check_suggestions_toolbar` | Default, No suggestions |
| `stage_container` | Default, Narrow |
| `star_rating` | Default, Read-only, Vertical, Disabled |
| `stepper` | Default, Vertical, Sizes, Failed step |
| `steps` | Default, Custom indicators, Single step |
| `swiper` | Default (drawer), Sheet |
| `switch` | Default, Controller, Disabled |
| `switcher` | Default, Vertical |
| `table` | Default, Resizable |
| `tabs` | Default, Disabled, Tab pane |
| `text_animate` | Default (fade), Slide, Blur, Scramble, Words |
| `text_area` | Default, Placeholder, Resizable, Invalid, Disabled |
| `time_picker` | Clock, Duration, Clock dialog, Duration dialog |
| `timeline` | Default, Compact |
| `toast` | Default, Destructive, With action |
| `tooltip` | Default, Instant, Rich content, Container |
| `tracker` | Default, Custom size, Themed |
| `tree` | Default, Line guides, No guides, Collapsed |
| `window` | Default, Maximized |

Dropped pinned-colour legs (star-rating amber style, timeline red entry,
tracker/track dark sections, all `darkFallback` blocks); token-`ref` legs
kept (`steps` primary indicators, `tracker` primary fine, `toast`
destructive surface). Dropped cross-component `Markdown` tail from
`text_animate` (markdown owns the streaming-tail demo). Dropped the 800/1200
`stage_container` widths (cannot fit 720 stage). `text_area` keeps 4-line
placeholder (was 6) so the example stays compact.

## Bugs fixed (all preview-side; no impl changes needed)

- `tabs` strip 1px right overflow at 375-wide: the padded container goes
  tight (369 inner) while 3 tabs measure ~370. Fixed by wrapping the Default
  strip in a horizontal `SingleChildScrollView` (no-op at 720, scrolls on a
  phone). Root cause verified via `FlutterError.onError` probe
  (`tabs.dart:107` Row, `w=369.0`).
- `toast` bottom overflow (52px): `ToastLayer` stacks toasts over a
  button-height box, so a bottom-placed card overflowed its slot. Fixed by
  giving each toast example a `360×220` stage box (commented as inherent).
- `toast` "With action" right overflow (34px): body `Row` wider than the card
  (`preview.dart:177`, `0<=w<=324`). Fixed by using `Wrap`.
- `stepper`/`steps`/`swiper`/`table`/`time_picker`/`tree`/`window` audit
  THREWs (flex/viewport under unbounded stage) and `table`/`steps`/
  `text_animate`/`text_area` overflows: fixed by construction — bounded,
  shrink-wrapped examples, `shrinkWrap: true` trees, per-example controllers,
  no `Expanded`, no `double.infinity` widths.
- `switch` gallery row overflow (`preview.dart:69`): replaced with `Wrap`.
- `window` audit `aspectRatio` THROW: no `AspectRatio` in the component;
  UNVERIFIED against current code — both window examples pump clean in all
  4 theme combos at both sizes, so nothing to fix.
- `scrollbar`-class shared-controller bug: not present in this batch; every
  controller here is example-local and disposed.

## Gates

- `dart format` on all 20 files (19 previews + `test/registry/previews_f3.dart`).
- `flutter analyze` on all 19 component dirs + the test file: **No issues found**.
- `flutter test test/registry/previews_f3.dart`: **115/115 pass** (19 components
  × (2 static + 4 combo) tests; each combo pumps every example at 720×420 and
  375-wide under neutral/claude × light/dark).
- `flutter test test/registry/previews_test.dart` (P6-F3-owned, regenerated to
  include this batch): **298/298 pass**; none of the 19 remain in `_pending`.
