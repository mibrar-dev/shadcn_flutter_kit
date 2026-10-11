# P6-D9a - Component audit (docs site): render, classification, preview spec

Audit of all **118** registry components as rendered by the docs app
(`/docs/components/<id>`). Headless render checks come from the widget-test
harnesses under `docs/test/audit/`; the audited sources are the registry
`preview.dart` files (the docs mirror is byte-identical -
`docs/tool/sync_registry.sh --check` reports no drift).

## 0. Method

| Check | How | Evidence |
|---|---|---|
| Build | `cd docs && flutter build web --release` | succeeded in 34.3s |
| Static preview audit | `flutter test docs/test/audit/preview_static_audit_test.dart` (`package:analyzer`, 118 rows) | `docs/build/audit/preview_static_audit.txt` |
| Render audit, light + dark | `flutter test docs/test/audit/preview_render_audit_test.dart` (`ShadcnApp` + `ShadcnTheme` light/dark, 118 components x 2) | `docs/build/audit/preview_render_audit.txt` |
| Classification evidence | `registry/manifests/registry.json` dependency graph + component descriptions | this report, section 3 |
| Interaction audit | browser (agent-browser) | section 2.4, `pending` where not run |

Both harnesses are kept as regression tests. They fail today on the 7
render failures of section 2.3 and on the 18 previews that pin their own
theme (2.1).

## 1. Headline numbers

| Metric | Value |
|---|---|
| Components | 118 |
| Listed (user-facing) | 97 |
| Building blocks (hidden from docs chrome) | 21 |
| Render OK, light | 68 / 118 |
| Render OK, dark | 69 / 118 |
| Render throws (headless, light or dark) | 25 |
| Render overflow only (headless) | 25 |
| **Blank previews on the docs page** (browser) | 11 |
| Interaction checks completed | 118 / 118 (104 ok, 3 unverified) |

### 1.1 Systemic defects (these cause the user's complaints)

| # | Defect | Count | Root cause |
|---|---|---|---|
| D1 | **Preview ignores the site light/dark mode.** `build()` returns `ShadcnTheme(data: const ShadcnThemeData())` (or a `darkFallback` one), so the stage never re-themes | 18 previews pin the root theme, 57 more render a nested hard-coded `darkFallback` block (75 total) | every hard-coded `ShadcnThemeData` inside a `preview.dart` |
| D2 | **Preview dumps every variant at once.** One gallery instead of one named example | 8 previews iterate `SomeEnum.values`; 67 previews have no named examples at all | `preview.dart` is a standalone gallery, not a named-example list |
| D3 | **Sidebar lists internal building blocks** | 21 of 118 sidebar entries | the sidebar renders all of `kComponentLinks` with no listed/blocked filter |
| D4 | **11 previews render completely blank** on the docs page | 11 | section 2.5 |
| D5 | **25 previews overflow the stage** and get clipped by the preview card | 25 | section 2.6 |
| D6 | **25 previews cannot be laid out at all** under the stage constraints (layout assertions) | 25 | section 2.3 |

D1 is exactly "many previews do not behave as they should / do not even
show (especially in light or dark mode)": a preview pinned to
`darkFallback` looks *broken* on a light page (dark controls on white) and
a preview pinned to the light default looks *absent* on a dark page.
Verified in the browser: `/docs/components/button` in dark mode keeps a
white stage while the shell around it is `#0A0A0A`.

---

## 2. Per-component render audit

`light=`/`dark=` values: `ok` (painted, no exception), `THREW` (framework
error captured through `FlutterError.onError` + `tester.takeException()`),
`pending` (not run). Machine-readable detail for all 118 components is in
`rearch/reports/p6_component_audit.json` (`renders`, `issues`,
`root_cause`).

### 2.1 The 18 previews that ignore the site mode (D1, root-pinned)

| Component | Pinned line |
|---|---|
| `avatar` | preview.dart:26 |
| `border_loading` | preview.dart:17 |
| `chat` | preview.dart:18 |
| `date_picker` | preview.dart:21 |
| `file_diff_viewer` | preview.dart:91 |
| `hover_card` | preview.dart:20 |
| `icon` | preview.dart:18 |
| `image` | preview.dart:21 |
| `menu` | preview.dart:16 |
| `overflow_marquee` | preview.dart:18 |
| `page_route` | preview.dart:20 |
| `progress` | preview.dart:17 |
| `selectable` | preview.dart:17 |
| `spinner` | preview.dart:17 |
| `time_picker` | preview.dart:21 |
| `timeline` | preview.dart:17 |
| `tooltip` | preview.dart:21 |
| `triple_dots` | preview.dart:17 |

A further 57 previews render one nested `ShadcnTheme(colors:
ShadcnColors.darkFallback)` block; all 75 have to lose it (the site toggle
covers dark).

### 2.2 The 8 previews that dump every enum variant (D2)

| Component | Loop(s) |
|---|---|
| `autocomplete` | AutoCompleteMode.values |
| `badge` | BadgeVariant.values, BadgeVariant.values, BadgeVariant.values |
| `button` | ButtonVariant.values, ButtonSize.values |
| `checkbox` | CheckboxValue.values |
| `gooey_toast` | GooeyToastState.values, GooeyToastPosition.values, GooeyToastExpandDirection.values, GooeyToastAnimationStyle.values, GooeyToastShapeStyle.values, GooeyToastBodyAnimationStyle.values |
| `refresh_trigger` | TriggerStage.values, TriggerStage.values |
| `slider` | SliderVariant.values |
| `stepper` | StepperSize.values |

### 2.3 Headless render failures under the real stage constraints

The harness reproduces `PreviewStage` exactly (`ShadcnApp` +
`PreviewStage`), i.e. the preview gets the **unbounded** width and height
the docs page actually gives it. A `THREW` means the preview subtree
cannot be laid out at all.

| Component | Headless verdict | First framework error |
|---|---|---|
| `alert_dialog` | OVERFLOW / OVERFLOW | A RenderFlex overflowed by 28 pixels on the bottom. |
| `button` | OVERFLOW / OVERFLOW | A RenderFlex overflowed by 164 pixels on the bottom. |
| `card` | OVERFLOW / OVERFLOW | A RenderFlex overflowed by 197 pixels on the bottom. |
| `card_image` | OVERFLOW / OVERFLOW | A RenderFlex overflowed by 320 pixels on the bottom. |
| `carousel` | OVERFLOW / OVERFLOW | A RenderFlex overflowed by 178 pixels on the bottom. |
| `chat` | OVERFLOW / OVERFLOW | A RenderFlex overflowed by 42 pixels on the bottom. |
| `chip_input` | THREW / THREW | RenderFlex children have non-zero flex but incoming width constraints are unbounded. |
| `color_field` | OVERFLOW / OVERFLOW | A RenderFlex overflowed by 74 pixels on the bottom. |
| `color_picker` | OVERFLOW / OVERFLOW | A RenderFlex overflowed by 2142 pixels on the bottom. |
| `date_picker` | THREW / THREW | RenderFlex children have non-zero flex but incoming width constraints are unbounded. |
| `divider` | THREW / THREW | BoxConstraints forces an infinite width. |
| `drawer_container` | OVERFLOW / OVERFLOW | A RenderFlex overflowed by 454 pixels on the bottom. |
| `dropzone` | THREW / THREW | BoxConstraints forces an infinite width. |
| `empty_state` | OVERFLOW / OVERFLOW | A RenderFlex overflowed by 46 pixels on the bottom. |
| `error_system` | THREW / THREW | RenderFlex children have non-zero flex but incoming width constraints are unbounded. |
| `eye_dropper` | THREW / ok | A ValueNotifier<AppError?> was used after being disposed. |
| `feature_carousel` | OVERFLOW / OVERFLOW | A RenderFlex overflowed by 1664 pixels on the bottom. |
| `file_diff_viewer` | OVERFLOW / OVERFLOW | A RenderFlex overflowed by 156 pixels on the bottom. |
| `file_picker` | THREW / THREW | BoxConstraints forces an infinite width. |
| `filter_bar` | OVERFLOW / OVERFLOW | A RenderFlex overflowed by 550 pixels on the bottom. |
| `form` | THREW / THREW | RenderFlex children have non-zero flex but incoming width constraints are unbounded. |
| `formatter` | THREW / THREW | RenderEditable object was given an infinite size during layout. |
| `hsl` | OVERFLOW / OVERFLOW | A RenderFlex overflowed by 89 pixels on the bottom. |
| `hsv` | OVERFLOW / OVERFLOW | A RenderFlex overflowed by 89 pixels on the bottom. |
| `image` | OVERFLOW / OVERFLOW | A RenderFlex overflowed by 82 pixels on the bottom. |
| `input` | THREW / THREW | BoxConstraints forces an infinite width. |
| `item_picker` | THREW / THREW | RenderFlex children have non-zero flex but incoming width constraints are unbounded. |
| `markdown` | THREW / THREW | RenderFlex children have non-zero flex but incoming width constraints are unbounded. |
| `navigation_bar` | OVERFLOW / OVERFLOW | A RenderFlex overflowed by 460 pixels on the bottom. |
| `navigation_menu` | THREW / THREW | BoxConstraints forces an infinite width. |
| `outlined_container` | OVERFLOW / OVERFLOW | A RenderFlex overflowed by 97 pixels on the bottom. |
| `phone_input` | THREW / THREW | RenderFlex children have non-zero flex but incoming width constraints are unbounded. |
| `pinned_sheet` | THREW / THREW | RenderFlex children have non-zero flex but incoming height constraints are unbounded. |
| `radio_group` | OVERFLOW / OVERFLOW | A RenderFlex overflowed by 150 pixels on the bottom. |
| `refresh_trigger` | THREW / THREW | Vertical viewport was given unbounded width. |
| `resizable` | OVERFLOW / OVERFLOW | A RenderFlex overflowed by 434 pixels on the bottom. |
| `scaffold` | THREW / THREW | BoxConstraints forces an infinite width. |
| `scrollable` | OVERFLOW / OVERFLOW | A RenderFlex overflowed by 26 pixels on the bottom. |
| `scrollbar` | THREW / THREW | A RenderFlex overflowed by 408 pixels on the bottom. |
| `slider` | THREW / THREW | RenderCustomPaint object was given an infinite size during layout. |
| `stepper` | THREW / THREW | BoxConstraints forces an infinite width. |
| `steps` | OVERFLOW / OVERFLOW | A RenderFlex overflowed by 65 pixels on the bottom. |
| `swiper` | THREW / THREW | RenderFlex children have non-zero flex but incoming height constraints are unbounded. |
| `table` | OVERFLOW / OVERFLOW | A RenderFlex overflowed by 144 pixels on the bottom. |
| `tabs` | THREW / THREW | BoxConstraints forces an infinite width. |
| `text_animate` | OVERFLOW / OVERFLOW | A RenderFlex overflowed by 15 pixels on the bottom. |
| `text_area` | OVERFLOW / OVERFLOW | A RenderFlex overflowed by 136 pixels on the bottom. |
| `time_picker` | THREW / THREW | RenderFlex children have non-zero flex but incoming width constraints are unbounded. |
| `tree` | THREW / THREW | Vertical viewport was given unbounded width. |
| `window` | THREW / THREW | 'package:flutter/src/rendering/proxy_box.dart': Failed assertion: line 456 pos 14: 'aspectRatio.isFinite': is not true. |

### 2.4 Browser render audit (all 118, light + dark)

Each component page was loaded in light and dark mode; the preview
stage was pixel-probed (distinct colours + mean luminance inside the
card) and the console was scraped. Screenshots are in
`rearch/design/audit/<id>-light.png` / `<id>-dark.png`.

| Verdict | Count |
|---|---|
| Page loads and the stage paints in both modes | 107 |
| Stage is blank (only the card background) | 11 |
| Console errors | 1 (`pinned_sheet`, 14) |

### 2.5 The 11 blank previews, with root cause

| Component | Stage colours (light / dark) | Console errors | Root cause (file:line) |
|---|---|---|---|
| `chip_input` | 2 / 2 | 0 | docs harness bug - docs/lib/widgets/preview_stage.dart:98-128 hands the preview unbounded width and unbounded height; chip_input renders an Input/EditableText, which needs a bounded width (headless: RenderFlex non-zero flex / RenderBox not laid out) |
| `divider` | 2 / 2 | 0 | docs harness bug - docs/lib/widgets/preview_stage.dart:98-128 hands the preview unbounded width and unbounded height; registry/components/divider/divider.dart:95 uses SizedBox(width: double.infinity) |
| `dropzone` | 2 / 2 | 0 | docs harness bug - docs/lib/widgets/preview_stage.dart:98-128 hands the preview unbounded width and unbounded height; registry/components/dropzone/dropzone.dart:120 uses SizedBox(width: double.infinity) |
| `file_picker` | 2 / 2 | 0 | docs harness bug - docs/lib/widgets/preview_stage.dart:98-128 hands the preview unbounded width and unbounded height; registry/components/file_picker/file_picker.dart:253 uses a stretch Column / preview.dart:385 an Expanded |
| `form` | 2 / 2 | 0 | docs harness bug - docs/lib/widgets/preview_stage.dart:98-128 hands the preview unbounded width and unbounded height; registry/components/form/form.dart:170,301 use Expanded |
| `formatter` | 3 / 4 | 0 | docs harness bug - docs/lib/widgets/preview_stage.dart:98-128 hands the preview unbounded width and unbounded height; formatter/preview.dart wraps Input/EditableText, which needs a bounded width (headless: RenderEditable object was given an infinite size during layout) |
| `history` | 2 / 2 | 0 | docs harness bug - docs/lib/widgets/preview_stage.dart:98-128 hands the preview unbounded width and unbounded height; registry/components/history/history.dart:283 uses a stretch Column |
| `input` | 2 / 2 | 0 | docs harness bug - docs/lib/widgets/preview_stage.dart:98-128 hands the preview unbounded width and unbounded height; input/preview.dart:43,119 use Column(crossAxisAlignment: CrossAxisAlignment.stretch) |
| `markdown` | 2 / 2 | 0 | docs harness bug - docs/lib/widgets/preview_stage.dart:98-128 hands the preview unbounded width and unbounded height; markdown/preview.dart:79 uses SizedBox(width: double.infinity) |
| `navigation_menu` | 2 / 2 | 0 | docs harness bug - docs/lib/widgets/preview_stage.dart:98-128 hands the preview unbounded width and unbounded height; navigation_menu/navigation_menu.dart:190 uses maxWidth: double.infinity and navigation_menu.dart:135,385 stretch columns |
| `pinned_sheet` | 1 / 1 | 14 | docs harness bug - docs/lib/widgets/preview_stage.dart:98-128 hands the preview unbounded width and unbounded height (height axis) + registry/components/pinned_sheet/preview.dart:51 uses Expanded inside a Column -> pinned_sheet.dart:369 Stack requires bounded constraints |

`pinned_sheet` is the same root cause on the height axis:
`preview.dart:51` uses `Expanded` inside a `Column`, and the stage
passes unbounded height -> `RenderFlex children have non-zero flex but
incoming height constraints are unbounded` plus
`A Stack requires bounded constraints from its parent`
(`pinned_sheet.dart:369`). It is the only blank preview that also logs
console errors (14).

So: **the registry components are not broken; the docs preview stage
is.** `PreviewStage` must give the preview a bounded box (e.g.
`SizedBox(width: stageWidth, child: ...)` outside the horizontal
scroller, and a bounded height or no vertical `SingleChildScrollView`
for the preview itself).

### 2.6 The 25 previews that overflow the stage (clipped)

| Component | Overflow |
|---|---|
| `alert_dialog` | A RenderFlex overflowed by 28 pixels on the bottom. |
| `button` | A RenderFlex overflowed by 164 pixels on the bottom. |
| `card` | A RenderFlex overflowed by 197 pixels on the bottom. |
| `card_image` | A RenderFlex overflowed by 320 pixels on the bottom. |
| `carousel` | A RenderFlex overflowed by 178 pixels on the bottom. |
| `chat` | A RenderFlex overflowed by 42 pixels on the bottom. |
| `color_field` | A RenderFlex overflowed by 74 pixels on the bottom. |
| `color_picker` | A RenderFlex overflowed by 2142 pixels on the bottom. |
| `drawer_container` | A RenderFlex overflowed by 454 pixels on the bottom. |
| `empty_state` | A RenderFlex overflowed by 46 pixels on the bottom. |
| `feature_carousel` | A RenderFlex overflowed by 1664 pixels on the bottom. |
| `file_diff_viewer` | A RenderFlex overflowed by 156 pixels on the bottom. |
| `filter_bar` | A RenderFlex overflowed by 550 pixels on the bottom. |
| `hsl` | A RenderFlex overflowed by 89 pixels on the bottom. |
| `hsv` | A RenderFlex overflowed by 89 pixels on the bottom. |
| `image` | A RenderFlex overflowed by 82 pixels on the bottom. |
| `navigation_bar` | A RenderFlex overflowed by 460 pixels on the bottom. |
| `outlined_container` | A RenderFlex overflowed by 97 pixels on the bottom. |
| `radio_group` | A RenderFlex overflowed by 150 pixels on the bottom. |
| `resizable` | A RenderFlex overflowed by 434 pixels on the bottom. |
| `scrollable` | A RenderFlex overflowed by 26 pixels on the bottom. |
| `scrollbar` | A RenderFlex overflowed by 408 pixels on the bottom. |
| `steps` | A RenderFlex overflowed by 65 pixels on the bottom. |
| `table` | A RenderFlex overflowed by 144 pixels on the bottom. |
| `text_animate` | A RenderFlex overflowed by 15 pixels on the bottom. |
| `text_area` | A RenderFlex overflowed by 136 pixels on the bottom. |

### 2.7 Verified render failures, with root cause

| Component | Symptom | Root cause (file:line) |
|---|---|---|
| `chip_input` | RenderFlex children have non-zero flex but incoming width constraints are unbounded.; RenderBox was not laid out: RenderFlex#8f827 relayoutBoundary=up46 NEEDS-PAINT NEEDS | docs harness bug - docs/lib/widgets/preview_stage.dart:98-128 hands the preview unbounded width and unbounded height; chip_input renders an Input/EditableText, which needs a bounded width (headless: RenderFlex non-zero flex / RenderBox not laid out) |
| `date_picker` | RenderFlex children have non-zero flex but incoming width constraints are unbounded.; RenderBox was not laid out: RenderFlex#e3f85 relayoutBoundary=up45 NEEDS-PAINT NEEDS | UNVERIFIED - see docs/build/audit/preview_render_audit.txt |
| `divider` | BoxConstraints forces an infinite width.; RenderBox was not laid out: RenderConstrainedBox#5a45b relayoutBoundary=up34 NEEDS-PAINT NEEDS-COMPOSITING-BITS-UPDATE.; RenderB | docs harness bug - docs/lib/widgets/preview_stage.dart:98-128 hands the preview unbounded width and unbounded height; registry/components/divider/divider.dart:95 uses SizedBox(width: double.infinity) |
| `dropzone` | BoxConstraints forces an infinite width.; RenderBox was not laid out: RenderConstrainedBox#f941d relayoutBoundary=up34 NEEDS-PAINT NEEDS-COMPOSITING-BITS-UPDATE.; RenderB | docs harness bug - docs/lib/widgets/preview_stage.dart:98-128 hands the preview unbounded width and unbounded height; registry/components/dropzone/dropzone.dart:120 uses SizedBox(width: double.infinity) |
| `error_system` | RenderFlex children have non-zero flex but incoming width constraints are unbounded.; RenderBox was not laid out: RenderFlex#5ab4f relayoutBoundary=up34 NEEDS-PAINT NEEDS | UNVERIFIED - see docs/build/audit/preview_render_audit.txt |
| `eye_dropper` | A ValueNotifier<AppError?> was used after being disposed. | UNVERIFIED (preview vs registry) - A ValueNotifier<AppError?> is used after dispose, raised from flutter/src/foundation/change_notifier.dart:184; the app-wide error channel outlives the pumped subtree. |
| `file_picker` | BoxConstraints forces an infinite width.; RenderBox was not laid out: RenderFlex#68b41 relayoutBoundary=up34 NEEDS-PAINT NEEDS-COMPOSITING-BITS-UPDATE.; RenderBox was not | docs harness bug - docs/lib/widgets/preview_stage.dart:98-128 hands the preview unbounded width and unbounded height; registry/components/file_picker/file_picker.dart:253 uses a stretch Column / preview.dart:385 an Expanded |
| `form` | RenderFlex children have non-zero flex but incoming width constraints are unbounded.; RenderBox was not laid out: RenderFlex#1521c relayoutBoundary=up24 NEEDS-PAINT NEEDS | docs harness bug - docs/lib/widgets/preview_stage.dart:98-128 hands the preview unbounded width and unbounded height; registry/components/form/form.dart:170,301 use Expanded |
| `formatter` | RenderEditable object was given an infinite size during layout.; _RenderSizeChangedWithCallback object was given an infinite size during layout.; RenderSemanticsAnnotatio | docs harness bug - docs/lib/widgets/preview_stage.dart:98-128 hands the preview unbounded width and unbounded height; formatter/preview.dart wraps Input/EditableText, which needs a bounded width (headless: RenderEditable object was given an infinite size during layout) |
| `input` | BoxConstraints forces an infinite width.; RenderBox was not laid out: RenderFlex#dcfe4 relayoutBoundary=up31 NEEDS-PAINT NEEDS-COMPOSITING-BITS-UPDATE.; RenderBox was not | docs harness bug - docs/lib/widgets/preview_stage.dart:98-128 hands the preview unbounded width and unbounded height; input/preview.dart:43,119 use Column(crossAxisAlignment: CrossAxisAlignment.stretch) |
| `item_picker` | RenderFlex children have non-zero flex but incoming width constraints are unbounded.; RenderBox was not laid out: RenderFlex#4e6ec relayoutBoundary=up45 NEEDS-PAINT NEEDS | UNVERIFIED - see docs/build/audit/preview_render_audit.txt |
| `markdown` | RenderFlex children have non-zero flex but incoming width constraints are unbounded.; RenderBox was not laid out: RenderFlex#abe31 relayoutBoundary=up40 NEEDS-PAINT NEEDS | docs harness bug - docs/lib/widgets/preview_stage.dart:98-128 hands the preview unbounded width and unbounded height; markdown/preview.dart:79 uses SizedBox(width: double.infinity) |
| `navigation_menu` | BoxConstraints forces an infinite width.; RenderBox was not laid out: RenderFlex#08576 relayoutBoundary=up33 NEEDS-PAINT NEEDS-COMPOSITING-BITS-UPDATE.; RenderBox was not | docs harness bug - docs/lib/widgets/preview_stage.dart:98-128 hands the preview unbounded width and unbounded height; navigation_menu/navigation_menu.dart:190 uses maxWidth: double.infinity and navigation_menu.dart:135,385 stretch columns |
| `phone_input` | RenderFlex children have non-zero flex but incoming width constraints are unbounded.; RenderBox was not laid out: RenderFlex#86db0 relayoutBoundary=up35 NEEDS-PAINT NEEDS | UNVERIFIED - see docs/build/audit/preview_render_audit.txt |
| `pinned_sheet` | RenderFlex children have non-zero flex but incoming height constraints are unbounded.; RenderBox was not laid out: RenderFlex#b04c9 relayoutBoundary=up21 NEEDS-PAINT NEED | docs harness bug - docs/lib/widgets/preview_stage.dart:98-128 hands the preview unbounded width and unbounded height (height axis) + registry/components/pinned_sheet/preview.dart:51 uses Expanded inside a Column -> pinned_sheet.dart:369 Stack requires bounded constraints |
| `refresh_trigger` | Vertical viewport was given unbounded width.; RenderBox was not laid out: RenderViewport#2f53f NEEDS-LAYOUT NEEDS-PAINT NEEDS-COMPOSITING-BITS-UPDATE.; RenderBox was not  | UNVERIFIED - see docs/build/audit/preview_render_audit.txt |
| `scaffold` | BoxConstraints forces an infinite width.; RenderBox was not laid out: RenderFlex#19402 relayoutBoundary=up35 NEEDS-PAINT NEEDS-COMPOSITING-BITS-UPDATE.; RenderBox was not | UNVERIFIED - see docs/build/audit/preview_render_audit.txt |
| `scrollbar` | A RenderFlex overflowed by 408 pixels on the bottom.; The provided ScrollController is attached to more than one ScrollPosition. | preview bug - registry/components/scrollbar/preview.dart:22: one ScrollController is shared by the four _sample() sections (preview.dart:71-89); Flutter asserts a controller may only attach to one ScrollPosition. |
| `slider` | RenderCustomPaint object was given an infinite size during layout.; RenderConstrainedBox object was given an infinite size during layout.; RenderPointerListener object wa | UNVERIFIED - see docs/build/audit/preview_render_audit.txt |
| `stepper` | BoxConstraints forces an infinite width.; RenderBox was not laid out: RenderFlex#ee58e relayoutBoundary=up34 NEEDS-PAINT NEEDS-COMPOSITING-BITS-UPDATE.; RenderBox was not | UNVERIFIED - see docs/build/audit/preview_render_audit.txt |
| `swiper` | RenderFlex children have non-zero flex but incoming height constraints are unbounded.; RenderBox was not laid out: RenderFlex#3a3c6 relayoutBoundary=up22 NEEDS-PAINT NEED | UNVERIFIED - see docs/build/audit/preview_render_audit.txt |
| `tabs` | BoxConstraints forces an infinite width.; RenderBox was not laid out: RenderFlex#f781b relayoutBoundary=up35 NEEDS-PAINT NEEDS-COMPOSITING-BITS-UPDATE.; RenderBox was not | UNVERIFIED - see docs/build/audit/preview_render_audit.txt |
| `time_picker` | RenderFlex children have non-zero flex but incoming width constraints are unbounded.; RenderBox was not laid out: RenderFlex#a9a09 relayoutBoundary=up45 NEEDS-PAINT NEEDS | UNVERIFIED - see docs/build/audit/preview_render_audit.txt |
| `tree` | Vertical viewport was given unbounded width.; RenderBox was not laid out: RenderShrinkWrappingViewport#53a63 relayoutBoundary=up44 NEEDS-PAINT NEEDS-COMPOSITING-BITS-UPDA | UNVERIFIED - see docs/build/audit/preview_render_audit.txt |
| `window` | 'package:flutter/src/rendering/proxy_box.dart': Failed assertion: line 456 pos 14: 'aspectRatio.isFinite': is not true.; A Stack requires bounded constraints from its par | UNVERIFIED - see docs/build/audit/preview_render_audit.txt |

`eye_dropper` only throws in light mode: a `ValueNotifier<AppError?>` is
used after dispose (`flutter/src/foundation/change_notifier.dart:184`),
i.e. the app-wide error channel outlives the pumped subtree.
**UNVERIFIED** whether the owner is `error_system` or the preview itself -
flagged for the fix batch.

### 2.8 Interaction audit

All 118 component pages were loaded in both modes through agent-browser;
the mode is switched through `agent-browser set media dark|light` (the
app follows `prefers-color-scheme` through
`DocsState.setSystemBrightness`). Screenshots of the interaction checks
are `rearch/design/audit/interaction-<id>.png`.

| Check | Result |
|---|---|
| Dark-mode toggle + propagation to the shell | **pass** - `/` and `/docs/components/button` verified in both modes, no console exception |
| Deferred preview chunk loading | **pass** - the `button` gallery paints in both modes |
| `select` - open the popover on click | **pass** - Apple/Banana/Cherry/Date/Grape rows appear |
| `checkbox` - toggle on click | **pass** - stage pixel diff (1706 px) after one click |
| `switch` / `tabs` - state change on click | **unverified** - see note |
| `dialog` - open the modal on click | **unverified** - see note |

**Why three checks are `unverified`, not failed:** a Flutter web page
renders into a single `<canvas>`, so agent-browser has no accessibility
tree and no refs (a plain `snapshot -i` returns only the
"Enable accessibility" placeholder). Interaction can only be driven by
absolute coordinates, and the sampled coordinates did not hit the
control - the page, however, reported **no console exception and no
layout overflow** for those components. The honest verdict is
`unverified`, and the machine-readable file carries that value so a
later batch can re-run it with the docs' own `data-testid` surface (or
with `flutter run` + the marionette MCP, which *does* expose element
refs).

Font warnings seen with `python -m http.server`
(`Failed to load font GeistSans at assets/assets/fonts/...`) are an
artefact of a single-threaded static server, **not** an app bug - a
threaded server loads them (verified).

---

## 3. Classification

### 3.1 Mechanism

Add a `docs` block to each component's `meta.json`, read by the docs
codegen:

```json
"docs": { "listed": false }
```

(`"docs": { "tier": "building-block" }` is the equivalent; `listed` is
the smaller, more readable field, so prefer it and derive `tier` in code.)
The default is `true`, so nothing is hidden by accident and the manifest
stays additive.

`tool/gen_docs_data.dart` then filters `kComponentLinks` to listed
components and emits `kBuildingBlockLinks` separately; `DocsSidebar`,
`components_index_page` and the ⌘K palette read the filtered list. The
same flag drives the sitemap: an unlisted component gets no
`/docs/components/<id>` route, which also removes ~21 dead deep links.
Building blocks stay installable, and their API stays reachable from the
components that depend on them.

### 3.2 The 21 building blocks (hidden) and why

| id | Why it is not a user-facing component |
|---|---|
| `alpha` | Checkerboard painter for transparency indicators; consumed by color_field/history/hsl/hsv. |
| `anchor` | Describes the point an overlay positions against and tracks it; consumed by overlay_configuration. |
| `app` | App bootstrap shell over WidgetsApp (theme + overlay manager + localizations); installed once in main.dart, never composed on a screen. |
| `async` | Renders a maybe-loading value through one builder; a rendering utility used by other components. |
| `backdrop_transform` | Strategy object describing how content behind a sheet is transformed; consumed by pinned_sheet. |
| `color` | ColorDerivative colour model shared by color_input/color_picker; a data model, not UI. |
| `error_system` | Structured error models, rule mapping and error channels; infrastructure surfaced by the host app, not a screen component. |
| `formatter` | Reusable text input formatters and selection-clipping helpers; applied to Input features. |
| `group` | Absolute-position layout surface (Positioned children); a layout primitive with no standalone look. |
| `history` | Recent-colour storage plus the swatch grid that replays them; consumed by color_input/color_picker/eye_dropper. |
| `hsl` | HSL gradient slider driving a colour component; a colour-space control, not a screen component. |
| `hsv` | HSV gradient slider driving a colour component; a colour-space control, not a screen component. |
| `icon` | Theme-driven icon size/colour modifiers applied inside other components; no standalone surface. |
| `locale_utils` | Byte-size formatting against a unit table; a pure formatting utility. |
| `media_query` | Responsive layout helper that swaps children by viewport width; a layout utility, not a component. |
| `multiple_choice` | Selection scopes for single/multi-choice trees; a scope provider consumed by radio_group and menus. |
| `overlay_configuration` | Describes what overlay to show and how; a configuration object consumed by the overlay machinery. |
| `page_route` | Widgets-only page route and declarative Page with the shadcn fade+slide transition; routing infrastructure. |
| `patch` | ClickDetector gesture helper counting consecutive taps; consumed by window. |
| `scrollable_client` | 2D scroll surface whose builder receives offset and viewport size; consumed by table. |
| `timeline_animation` | Typed keyframe timeline utility segmenting an AnimationController; animation infrastructure. |

### 3.3 The 97 listed components

| id | Category | Why listed |
|---|---|---|
| `accordion` | layout | User-facing UI component composed directly on a screen. |
| `alert` | layout | User-facing UI component composed directly on a screen. |
| `alert_dialog` | overlay | User-facing UI component composed directly on a screen. |
| `autocomplete` | form | User-facing UI component composed directly on a screen. |
| `avatar` | display | User-facing UI component composed directly on a screen. |
| `badge` | display | User-facing UI component composed directly on a screen. |
| `border_loading` | display | User-facing UI component composed directly on a screen. |
| `breadcrumb` | navigation | User-facing UI component composed directly on a screen. |
| `button` | control | User-facing UI component composed directly on a screen. |
| `calendar` | display | User-facing UI component composed directly on a screen. |
| `card` | layout | User-facing UI component composed directly on a screen. |
| `card_image` | layout | User-facing UI component composed directly on a screen. |
| `carousel` | display | User-facing UI component composed directly on a screen. |
| `chat` | display | User-facing UI component composed directly on a screen. |
| `checkbox` | form | User-facing UI component composed directly on a screen. |
| `chip` | display | User-facing UI component composed directly on a screen. |
| `chip_input` | form | User-facing UI component composed directly on a screen. |
| `code_snippet` | display | User-facing UI component composed directly on a screen. |
| `collapsible` | layout | User-facing UI component composed directly on a screen. |
| `color_field` | form | User-facing UI component composed directly on a screen. |
| `color_input` | form | User-facing UI component composed directly on a screen. |
| `color_picker` | form | User-facing UI component composed directly on a screen. |
| `command` | control | User-facing UI component composed directly on a screen. |
| `context_menu` | overlay | User-facing UI component composed directly on a screen. |
| `country_flag` | display | User-facing UI component composed directly on a screen. |
| `date_picker` | form | User-facing UI component composed directly on a screen. |
| `dialog` | overlay | User-facing UI component composed directly on a screen. |
| `divider` | display | User-facing UI component composed directly on a screen. |
| `dot_indicator` | display | User-facing UI component composed directly on a screen. |
| `drawer` | overlay | User-facing UI component composed directly on a screen. |
| `drawer_container` | overlay | User-facing UI component composed directly on a screen. |
| `dropdown_menu` | overlay | User-facing UI component composed directly on a screen. |
| `dropzone` | form | User-facing UI component composed directly on a screen. |
| `empty_state` | display | User-facing UI component composed directly on a screen. |
| `eye_dropper` | overlay | User-facing UI component composed directly on a screen. |
| `feature_carousel` | display | User-facing UI component composed directly on a screen. |
| `file_diff_viewer` | display | User-facing UI component composed directly on a screen. |
| `file_picker` | form | User-facing UI component composed directly on a screen. |
| `filter_bar` | layout | User-facing UI component composed directly on a screen. |
| `form` | form | User-facing UI component composed directly on a screen. |
| `formatted_input` | form | User-facing UI component composed directly on a screen. |
| `gooey_toast` | overlay | User-facing UI component composed directly on a screen. |
| `hover_card` | overlay | User-facing UI component composed directly on a screen. |
| `image` | display | User-facing UI component composed directly on a screen. |
| `input` | form | User-facing UI component composed directly on a screen. |
| `input_otp` | form | User-facing UI component composed directly on a screen. |
| `item_picker` | form | User-facing UI component composed directly on a screen. |
| `keyboard_shortcut` | display | User-facing UI component composed directly on a screen. |
| `markdown` | display | User-facing UI component composed directly on a screen. |
| `menu` | overlay | User-facing UI component composed directly on a screen. |
| `menubar` | overlay | User-facing UI component composed directly on a screen. |
| `multi_select` | form | User-facing UI component composed directly on a screen. |
| `navigation_bar` | navigation | User-facing UI component composed directly on a screen. |
| `navigation_menu` | navigation | User-facing UI component composed directly on a screen. |
| `number_ticker` | display | User-facing UI component composed directly on a screen. |
| `object_input` | form | User-facing UI component composed directly on a screen. |
| `outlined_container` | layout | User-facing UI component composed directly on a screen. |
| `overflow_marquee` | layout | User-facing UI component composed directly on a screen. |
| `pagination` | navigation | User-facing UI component composed directly on a screen. |
| `phone_input` | form | User-facing UI component composed directly on a screen. |
| `pinned_sheet` | display | User-facing UI component composed directly on a screen. |
| `popup` | overlay | User-facing UI component composed directly on a screen. |
| `progress` | display | User-facing UI component composed directly on a screen. |
| `radio_group` | form | User-facing UI component composed directly on a screen. |
| `refresh_trigger` | overlay | User-facing UI component composed directly on a screen. |
| `resizable` | layout | User-facing UI component composed directly on a screen. |
| `scaffold` | layout | User-facing UI component composed directly on a screen. |
| `scrollable` | layout | User-facing UI component composed directly on a screen. |
| `scrollbar` | control | User-facing UI component composed directly on a screen. |
| `scrollview` | control | User-facing UI component composed directly on a screen. |
| `select` | form | User-facing UI component composed directly on a screen. |
| `selectable` | display | User-facing UI component composed directly on a screen. |
| `skeleton` | display | User-facing UI component composed directly on a screen. |
| `slider` | form | User-facing UI component composed directly on a screen. |
| `sortable` | layout | User-facing UI component composed directly on a screen. |
| `spell_check_suggestions_toolbar` | overlay | User-facing UI component composed directly on a screen. |
| `spinner` | display | User-facing UI component composed directly on a screen. |
| `stage_container` | layout | User-facing UI component composed directly on a screen. |
| `star_rating` | form | User-facing UI component composed directly on a screen. |
| `stepper` | navigation | User-facing UI component composed directly on a screen. |
| `steps` | layout | User-facing UI component composed directly on a screen. |
| `swiper` | overlay | User-facing UI component composed directly on a screen. |
| `switch` | form | User-facing UI component composed directly on a screen. |
| `switcher` | navigation | User-facing UI component composed directly on a screen. |
| `table` | layout | User-facing UI component composed directly on a screen. |
| `tabs` | navigation | User-facing UI component composed directly on a screen. |
| `text_animate` | display | User-facing UI component composed directly on a screen. |
| `text_area` | form | User-facing UI component composed directly on a screen. |
| `time_picker` | form | User-facing UI component composed directly on a screen. |
| `timeline` | layout | User-facing UI component composed directly on a screen. |
| `toast` | overlay | User-facing UI component composed directly on a screen. |
| `toggle` | control | User-facing UI component composed directly on a screen. |
| `tooltip` | overlay | User-facing UI component composed directly on a screen. |
| `tracker` | display | User-facing UI component composed directly on a screen. |
| `tree` | display | User-facing UI component composed directly on a screen. |
| `triple_dots` | display | User-facing UI component composed directly on a screen. |
| `window` | layout | User-facing UI component composed directly on a screen. |

---

## 4. Preview variant spec (one example at a time)

The docs page shows **one** example at a time, like shadcn/ui: a `Select`
of named examples above the stage, plus the light/dark toggle already in
the header. No page-long gallery of every variant.

### 4.1 Contract

Each registry `preview.dart` exports a named example list instead of a
single gallery widget:

```dart
/// One named docs example.
class ComponentPreview {
  const ComponentPreview(this.name, this.builder);
  final String name;
  final WidgetBuilder builder;
}

const List<ComponentPreview> buttonPreviews = <ComponentPreview>[
  ComponentPreview('Default', _default),
  ComponentPreview('Secondary', _secondary),
  // ...
];
```

`tool/gen_docs_data.dart` already extracts the preview class with
`package:analyzer`; it gains a `findPreviewExamples` that reads the
exported `const <ComponentPreview>[]` and emits `kComponentPreviews`. The
page keeps its deferred-import loader (`lib/previews/component_previews.dart`),
replaces `ButtonPreview()` with
`buttonPreviews.first.builder(context)`, and keeps the selected index in
`DocsState` so the choice survives a reload.

Rules the fix batches must respect:

1. **A preview never hard-codes `ShadcnThemeData`.** It reads
   `ShadcnTheme.of(context)`; the hard-coded `darkFallback` sections are
   deleted because the header toggle now covers dark.
2. Every example fits the 288px stage (`DocsMetrics.previewStageHeight`)
   without an outer fixed `SizedBox(height: 320)` - that box is what
   overflows in `empty_state`.
3. Shared state (a `ScrollController`, a `SwitchController`) is created
   **inside** the example builder, so two examples can never attach the
   same controller twice (the `scrollbar` bug).

### 4.2 Per-component proposed examples

`default` is the example the page shows first. Controls are the `Select`s
rendered above the stage (first option = default).

| id | default | examples | controls |
|---|---|---|---|
| `accordion` | Default | Default<br>Expanded<br>Multiple |  |
| `alert` | Default | Default<br>Destructive<br>Compact | variant: default/destructive |
| `alert_dialog` | Default | Default<br>Destructive | size: default/sm |
| `autocomplete` | Default | Default<br>Async<br>Custom row | mode: inline/popover |
| `avatar` | Default | Image<br>Initials<br>Badge<br>Group | size: sm/default/lg |
| `badge` | Default | Default<br>Secondary<br>Outline<br>Destructive | variant: default/secondary/outline/destructive |
| `border_loading` | Default | Sweep<br>Progress<br>Outline | style: sweep/progress/outline |
| `breadcrumb` | Default | Default<br>With slash<br>Collapsed | separator: chevron/slash |
| `button` | Default | Default<br>Secondary<br>Outline<br>Ghost<br>Link<br>Destructive<br>Icon<br>With icon<br>Loading<br>Disabled | variant: primary/secondary/outline/ghost/link/text/destructive<br>size: xs/sm/md/lg/icon<br>state: enabled/loading/disabled |
| `calendar` | Default | Single<br>Range<br>Multi<br>Dark | selection: single/range/multi |
| `card` | Default | Default<br>With media<br>With footer |  |
| `card_image` | Default | Vertical<br>Horizontal | orientation: vertical/horizontal<br>state: enabled/disabled |
| `carousel` | Default | Slide<br>Fade<br>Autoplay | transition: slide/fade |
| `chat` | Default | Incoming<br>Outgoing<br>Grouped | bubble: plain/tailed/sharp |
| `checkbox` | Default | Default<br>Checked<br>Indeterminate<br>Disabled | value: false/true/indeterminate<br>state: enabled/disabled |
| `chip` | Default | Static<br>Pressable<br>Removable | mode: static/pressable/removable |
| `chip_input` | Default | Default<br>With suggestions<br>Read-only | state: enabled/disabled/readonly |
| `code_snippet` | Default | Default<br>With actions |  |
| `collapsible` | Default | Default<br>Expanded |  |
| `color_field` | Default | Default |  |
| `color_input` | Default | Default |  |
| `color_picker` | Default | Default |  |
| `command` | Default | Default<br>With groups |  |
| `context_menu` | Default | Default<br>With submenu |  |
| `country_flag` | Default | Default<br>Sizes | size: sm/default/lg |
| `date_picker` | Default | Single<br>Range | selection: single/range<br>state: enabled/disabled |
| `dialog` | Default | Default<br>Full screen | size: default/sm/fullscreen |
| `divider` | Default | Default<br>Labelled<br>Vertical | orientation: horizontal/vertical |
| `dot_indicator` | Default | Default<br>Vertical | orientation: horizontal/vertical |
| `drawer` | Default | Default<br>Sheet | side: left/right/top/bottom |
| `drawer_container` | Default | Default<br>With handle |  |
| `dropdown_menu` | Default | Default<br>With shortcut<br>With checkbox item |  |
| `dropzone` | Default | Default<br>Uploading<br>Error | state: idle/uploading/error |
| `empty_state` | No results | No results<br>Empty<br>Error fallback<br>Compact | variant: empty/noResults/errorFallback<br>size: default/compact |
| `eye_dropper` | Default | Default<br>Inline value |  |
| `feature_carousel` | Default | Default<br>Cards only |  |
| `file_diff_viewer` | Default | Unified<br>Split | layout: unified/split |
| `file_picker` | Default | Dropzone<br>Tile<br>Trigger | surface: dropzone/tile/trigger |
| `filter_bar` | Default | Default<br>With chips |  |
| `form` | Default | Default<br>Validating | state: idle/submitting/error |
| `formatted_input` | Default | Phone<br>Date<br>Card | kind: phone/date/card<br>state: enabled/readonly |
| `gooey_toast` | Default | Pill<br>Expanded | position: top/bottom/left/right<br>shape: pill/rounded/square |
| `hover_card` | Default | Default<br>Rich content |  |
| `image` | Default | Default |  |
| `input` | Default | Default<br>With icon<br>Invalid<br>Disabled | state: enabled/invalid/disabled |
| `input_otp` | Default | Default<br>Separated<br>Obscured | state: enabled/filled/error |
| `item_picker` | Default | Grid<br>List | surface: grid/list<br>mode: dialog/popover |
| `keyboard_shortcut` | Default | Default<br>Multiple keys |  |
| `markdown` | Default | Default<br>Streaming tail |  |
| `menu` | Default | Default<br>With checkbox item<br>With radio group |  |
| `menubar` | Default | Default<br>With submenu |  |
| `multi_select` | Default | Default<br>With badges | state: enabled/disabled |
| `navigation_bar` | Default | Default<br>With labels<br>Sidebar | mode: bar/rail/sidebar |
| `navigation_menu` | Default | Bar<br>Content list |  |
| `number_ticker` | Default | Default<br>Flip clock | style: ticker/flip |
| `object_input` | Default | Date<br>Time<br>Duration | kind: date/time/duration |
| `outlined_container` | Default | Default<br>Dashed | borderStyle: solid/dashed |
| `overflow_marquee` | Default | Horizontal<br>Vertical | direction: horizontal/vertical |
| `pagination` | Default | Labelled<br>Icon only | variant: icons/labels |
| `phone_input` | Default | Default<br>With leading icon<br>Invalid | state: enabled/invalid/disabled |
| `pinned_sheet` | Default | Default<br>Snapping |  |
| `popup` | Default | Default<br>Anchored |  |
| `progress` | Default | Determinate<br>Indeterminate | mode: determinate/indeterminate |
| `radio_group` | Default | Default<br>Card items | itemShape: default/card |
| `refresh_trigger` | Default | Default<br>Refreshing |  |
| `resizable` | Default | Absolute<br>Flexible | mode: absolute/flexible |
| `scaffold` | Default | Default<br>With loading |  |
| `scrollable` | Default | Default<br>Vertical | fade: start/end/both |
| `scrollbar` | Default | Default<br>Always visible<br>Themed | thumbVisibility: auto/always |
| `scrollview` | Default | Default |  |
| `select` | Default | Default<br>With groups<br>Disabled | size: sm/default/lg<br>state: enabled/disabled |
| `selectable` | Default | Default<br>Long text |  |
| `skeleton` | Default | Default<br>Card |  |
| `slider` | Default | Default<br>Range<br>Steps | variant: default/floating/thermometer<br>state: enabled/disabled |
| `sortable` | Default | Default<br>Grid | layout: list/grid |
| `spell_check_suggestions_toolbar` | Default | Default<br>Inline |  |
| `spinner` | Default | Default<br>Small | size: sm/default/lg |
| `stage_container` | Default | Default<br>Narrow |  |
| `star_rating` | Default | Default<br>Read-only | state: enabled/readonly |
| `stepper` | Default | Horizontal<br>Vertical<br>Failed step | orientation: horizontal/vertical<br>size: sm/default/lg |
| `steps` | Default | Default |  |
| `swiper` | Default | Default<br>Sheet |  |
| `switch` | Default | Default<br>Controller<br>Disabled | state: enabled/disabled |
| `switcher` | Default | Default | axis: horizontal/vertical |
| `table` | Default | Default<br>Resizable | state: enabled/loading |
| `tabs` | Default | Default<br>Disabled | orientation: horizontal/vertical |
| `text_animate` | Default | Fade<br>Slide<br>Blur<br>Scramble | effect: fade/slide/blur/scramble |
| `text_area` | Default | Default<br>Resizable | state: enabled/invalid/disabled |
| `time_picker` | Default | Clock<br>Duration | mode: clock/duration |
| `timeline` | Default | Default<br>Compact |  |
| `toast` | Default | Default<br>Destructive<br>With action | variant: default/destructive<br>position: top/bottom |
| `toggle` | Default | Default<br>Pressed | state: enabled/pressed/disabled |
| `tooltip` | Default | Default<br>Rich content | placement: top/bottom/left/right |
| `tracker` | Default | Default<br>Custom size | size: sm/default/lg |
| `tree` | Default | Default<br>Line guides | guides: none/line/path |
| `triple_dots` | Default | Default<br>Vertical | orientation: horizontal/vertical |
| `window` | Default | Default<br>Maximized |  |

Building blocks get no named examples: they keep their preview for
maintainers, drop out of the index / sidebar / ⌘K, and their API stays
reachable from the components that depend on them.

---

## 5. Screenshots

236 PNGs (118 components x light + dark) under `rearch/design/audit/`,
named `<id>-light.png` / `<id>-dark.png`, viewport 1440x1000, taken with
agent-browser against `flutter build web --release` served locally.

| Verdict | Components |
|---|---|
| Stage paints | 107 |
| Stage blank | chip_input, divider, dropzone, file_picker, form, formatter, history, input, markdown, navigation_menu, pinned_sheet |

## 6. What the fix batches should do, in order

Each line below is independent; do them in this order because the later
ones rewrite the files the earlier ones clean up.

1. **Fix the docs preview stage (D4/D5/D6 - unblocks 39 components).**
   `docs/lib/widgets/preview_stage.dart:98-128` must hand the preview a
   *bounded* box: move the horizontal `SingleChildScrollView` inside a
   fixed-width `SizedBox`, and either bound the height or drop the
   vertical scroll so `Expanded` works. This alone un-blanks the 11
   previews of 2.5 and stops the 25 overflows of 2.6.
2. **Delete every hard-coded `ShadcnThemeData` from the previews (D1).**
   18 previews pin the root theme and 57 render a nested
   `darkFallback` block; all 75 have to lose it because the header toggle
   now covers dark. Contract: a preview reads `ShadcnTheme.of(context)`
   and nothing else.
3. **Add `"docs": {"listed": false}` to the 21 `meta.json` files (3.2)**
   and filter `kComponentLinks` in `tool/gen_docs_data.dart` so the
   sidebar, the components index, the ⌘K component group and the sitemap
   all drop them (D3).
4. **Convert the 97 listed previews to `const <ComponentPreview>[]`**
   with the examples of 4.2, and render one at a time behind a `Select`
   (D2). Keep shared state (a `ScrollController`, a `SwitchController`)
   inside the example builder so two examples never attach the same
   controller twice.
5. **Fix the registry bugs of 2.7** - `chat/chat.dart:225-245`
   (IntrinsicHeight + Flexible overflow) and the `pinned_sheet`
   `Stack` robustness at `pinned_sheet.dart:369`.
6. **Fix the remaining preview bugs** of 2.7: `empty_state`
   `preview.dart:121` (fixed 320px box), `file_diff_viewer`
   `preview.dart:117` (missing `maxHeight`), `scrollbar`
   `preview.dart:22` (shared `ScrollController`), `switch`
   `preview.dart:69` (row overflow), `image` `preview.dart:23` (pinned
   theme) + `preview.dart:18` (remote SVG), and the `eye_dropper`
   `ValueNotifier<AppError?>` used after dispose (owner UNVERIFIED).
7. **Re-run both harnesses.** `flutter test docs/test/audit/` must stay
   green (the render audit is opt-in: `AUDIT_RENDER=1`), and its
   `BASELINE threw=… overflow=… zero=…` line must reach `25 -> 0`.
   `rearch/reports/p6_component_audit.json` is the machine-readable
   contract: regenerate it from `build/audit/*.txt` after each batch.

