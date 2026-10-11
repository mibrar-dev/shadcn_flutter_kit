# P2E1_PRIMITIVES — `primitives/` layer 2 (interaction / overlay / animation / layout)

Unit: P2-E1 · Builder A (deepseek-v4.1-flash#max) · 2026-10-06 · QA round 2 (F1–F3) applied
Outputs: `flutter_shadcn_kit/lib/registry_next/primitives/**` (except the parallel
`form_core/`, `text/`, `localizations/`), `lib/registry_next/foundation/{color_extensions,tween_utils}.dart`,
`test/registry_next/primitives/**` (my test files), this report.

## 1. New files (LOC at hand-off)

| File | LOC | Contents |
|---|---|---|
| `primitives/clickable.dart` | 199 | `Clickable` widget + `kDoubleTapMinTime` |
| `primitives/clickable_state.dart` | 296 | `ClickableState` (framework-internal; keyboard/tap/double-tap/animations) |
| `primitives/widget_states.dart` | 276 | `WidgetStateExtension`, `WidgetStatesData`, `WidgetStatesProvider`, `StatedWidget` + 3 private impls |
| `primitives/hover.dart` | 290 | `HoverTheme` (+`Mergeable`), `Hover`, `HoverActivity` + states |
| `primitives/focus_outline.dart` | 185 | `FocusOutlineTheme`, `FocusOutline` |
| `primitives/subfocus.dart` | 77 | `SubFocusBuilder`, `SubFocusScopeBuilder`, `SubFocusState` (+`isEnabled`), `SubFocusScopeState` mixins |
| `primitives/subfocus_item.dart` | 142 | `SubFocus` + `_SubFocusState` |
| `primitives/subfocus_scope.dart` | 216 | `SubFocusScope` + `_SubFocusScopeState` |
| `primitives/overlay.dart` | 171 | `FutureVoidCallback`, `PopoverFutureVoidCallback`, `PopoverConstraint`, `OverlayCompleter`, `OverlayHandler`, `OverlayBarrier`, `OverlayHandlerStateMixin`, `closeOverlay` |
| `primitives/overlay_manager.dart` | 370 | `OverlayManager` (tree-only lookup), `_FallbackOverlayManager`, `ShadcnLayer` |
| `primitives/overlay_manager_layer.dart` | 230 | `OverlayManagerLayer` + `OverlayManagerLayerState` (framework-internal) |
| `primitives/popover.dart` | 165 | `OverlayPopoverEntry`, `Popover` (+`Popover.from`), `showPopover` |
| `primitives/popover_controller.dart` | 200 | `PopoverController` |
| `primitives/popover_layout.dart` | 112 | `PopoverLayout` |
| `primitives/popover_layout_render.dart` | 365 | `PopoverLayoutRender` (+`updateConfiguration`) |
| `primitives/popover_overlay_widget.dart` | 122 | `PopoverOverlayWidget` |
| `primitives/popover_overlay_state.dart` | 399 | `PopoverOverlayWidgetState` |
| `primitives/popover_overlay_handler.dart` | 199 | `PopoverOverlayHandler` (default `OverlayHandler.popover`) |
| `primitives/sheet_overlay.dart` | 28 | `SheetOverlayMarker`, `SheetOverlayHandler.isSheetOverlay` |
| `primitives/animated_value_builder.dart` | 287 | `AnimatedValueWidgetBuilder`, `AnimatedValueLerp`, `AnimatedValueBuilder` + state |
| `primitives/animation_queue.dart` | 101 | `AnimationRequest`, `_AnimationRunner`, `AnimationQueueController` |
| `primitives/animation.dart` | 138 | `RepeatedAnimationWidgetBuilder`, `RepeatedAnimationBuilder` + state, `ControlledAnimation` |
| `primitives/layout.dart` | 320 | `BasicTheme`, `Basic` |
| `primitives/basic_layout.dart` | 156 | `BasicLayout` |
| `primitives/label.dart` | 39 | `Label` |
| `primitives/hidden.dart` | 316 | `HiddenTheme`, `Hidden`, `_HiddenLayout`, `_HiddenLayoutRender` |
| `primitives/fade_scroll.dart` | 227 | `FadeScrollTheme`, `FadeScroll` (stable `ShaderMask`), `_ScaleGradient` |
| `primitives/menu_group.dart` | 15 | `MenuGroupData` |
| `primitives/slider_value.dart` | 65 | `SliderValue` |
| `primitives/extensions.dart` | 385 | `IconExtensions`, `WidgetExtension`, `Column/Row/FlexExtension`, `Double/IntExtension`, `SeparatedFlex` + state |
| `primitives/phone_number.dart` | 83 | `Country`, `PhoneNumber` (superset body) |
| `primitives/README.md` | — | layer map + theme pattern |
| `foundation/color_extensions.dart` | 108 | `ColorExtension`, `HSLColorExtension`, `HSVColorExtension` |
| `foundation/tween_utils.dart` | 21 | `tweenValue`, `IconThemeDataTween` |

No file exceeds 400 lines (largest: `popover_overlay_state.dart`, 399).

## 2. Old → new mapping (every source file in the brief)

| Old file under `lib/registry/shared/` | New home | Note |
|---|---|---|
| `primitives/clickable.dart` | `primitives/clickable.dart` + `clickable_state.dart` | split for the 400-line rule |
| `primitives/_impl/core/clickable.dart` | `clickable.dart` | |
| `primitives/_impl/state/__clickable_state.dart` | `clickable_state.dart` | `_ClickableState` → public `ClickableState` (cross-file creation) |
| `primitives/_impl/core/__builder_stated_widget.dart` | `widget_states.dart` | |
| `primitives/_impl/core/__map_stated_widget.dart` | `widget_states.dart` | |
| `primitives/_impl/core/__param_stated_widget.dart` | `widget_states.dart` | |
| `primitives/_impl/core/stated_widget.dart` | `widget_states.dart` | |
| `primitives/_impl/core/widget_states_data.dart` | `widget_states.dart` | |
| `primitives/_impl/core/widget_states_provider.dart` | `widget_states.dart` | |
| `primitives/hover.dart` | `hover.dart` | |
| `primitives/_impl/core/hover.dart` | `hover.dart` | |
| `primitives/_impl/core/hover_activity.dart` | `hover.dart` | |
| `primitives/_impl/state/__hover_state.dart` | `hover.dart` | |
| `primitives/_impl/state/__hover_activity_state.dart` | `hover.dart` | |
| `primitives/_impl/themes/hover_theme.dart` | `hover.dart` | `ComponentThemeData` + `Mergeable` |
| `primitives/focus_outline.dart` | `focus_outline.dart` | |
| `primitives/_impl/core/focus_outline.dart` | `focus_outline.dart` | |
| `primitives/_impl/themes/focus_outline_theme.dart` | `focus_outline.dart` | `ComponentThemeData` + `Mergeable` |
| `primitives/subfocus.dart` | `subfocus.dart` + `subfocus_item.dart` + `subfocus_scope.dart` | mixins split from widgets/states |
| `primitives/_impl/core/sub_focus.dart` | `subfocus_item.dart` | |
| `primitives/_impl/core/sub_focus_scope.dart` | `subfocus_scope.dart` | |
| `primitives/_impl/state/__sub_focus_state.dart` | `subfocus_item.dart` | |
| `primitives/_impl/state/__sub_focus_scope_state.dart` | `subfocus_scope.dart` | |
| `primitives/basic.dart` | `layout.dart` + `basic_layout.dart` + `label.dart` | split for the 400-line rule |
| `primitives/_impl/core/basic.dart` | `layout.dart` | |
| `primitives/_impl/core/basic_layout.dart` | `basic_layout.dart` | |
| `primitives/_impl/core/label.dart` | `label.dart` | |
| `primitives/_impl/themes/basic_theme.dart` | `layout.dart` | `ComponentThemeData` + `Mergeable` |
| `primitives/hidden.dart` | `hidden.dart` | |
| `primitives/_impl/core/hidden.dart` | `hidden.dart` | |
| `primitives/_impl/core/__hidden_layout.dart` | `hidden.dart` | |
| `primitives/_impl/core/__hidden_layout_render.dart` | `hidden.dart` | **fixed** (see §4.1) |
| `primitives/_impl/themes/hidden_theme.dart` | `hidden.dart` | `ComponentThemeData` + `Mergeable` |
| `primitives/fade_scroll.dart` | `fade_scroll.dart` | |
| `primitives/_impl/core/fade_scroll.dart` | `fade_scroll.dart` | |
| `primitives/_impl/core/__scale_gradient.dart` | `fade_scroll.dart` | |
| `primitives/_impl/themes/fade_scroll_theme.dart` | `fade_scroll.dart` | `ComponentThemeData` + `Mergeable` |
| `primitives/menu_group.dart` | `menu_group.dart` | |
| `primitives/slider_value.dart` | `slider_value.dart` | |
| `primitives/icon_extensions.dart` | `extensions.dart` | |
| `utils/widget_extensions.dart` | `extensions.dart` | pruned (see §4) |
| `primitives/phone_number.dart` | `phone_number.dart` | |
| `primitives/_impl/core/phone_number.dart` | `phone_number.dart` | superset body from `components/form/phone_input` per OWNERSHIP |
| `primitives/_impl/core/country.dart` | `phone_number.dart` | value equality added (accepted in QA r2) |
| `primitives/overlay.dart` | `overlay.dart` + `overlay_manager.dart` + `overlay_manager_layer.dart` | split |
| `primitives/_impl/core/overlay_manager.dart` | `overlay_manager.dart` | no global registry; tree-only lookup |
| `primitives/_impl/core/__fallback_overlay_manager.dart` | `overlay_manager.dart` | |
| `primitives/_impl/core/overlay_manager_layer.dart` | `overlay_manager_layer.dart` | |
| `primitives/_impl/state/__overlay_manager_layer_state.dart` | `overlay_manager_layer.dart` | `OverlayManagerLayerState` public |
| `primitives/_impl/core/overlay_barrier.dart` | `overlay.dart` | |
| `primitives/_impl/utils/overlay_completer.dart` | `overlay.dart` | |
| `primitives/_impl/utils/overlay_handler.dart` | `overlay.dart` | |
| `primitives/_impl/core/shadcn_layer.dart` | `overlay_manager.dart` | tree-only lookup (no global fallback) |
| `primitives/popover.dart` (part) | `popover.dart` | `FutureVoidCallback` |
| `primitives/_impl/core/overlay_popover_entry.dart` | `popover.dart` | `OverlayPopoverEntry` + `showPopover` |
| `primitives/_impl/core/popover.dart` | `popover.dart` | `Popover._` → `Popover.from` |
| `primitives/_impl/utils/popover_controller.dart` | `popover_controller.dart` | |
| `primitives/_impl/core/popover_layout.dart` | `popover_layout.dart` | |
| `primitives/_impl/core/popover_layout_render.dart` | `popover_layout_render.dart` | |
| `primitives/_impl/core/popover_overlay_widget.dart` | `popover_overlay_widget.dart` | |
| `primitives/_impl/state/popover_overlay_widget_state.dart` | `popover_overlay_state.dart` | compacted setters |
| `primitives/_impl/utils/popover_overlay_handler.dart` | `popover_overlay_handler.dart` | |
| `primitives/sheet_overlay.dart` | `sheet_overlay.dart` | `Model` → `Data<SheetOverlayMarker>` (accepted in QA r2) |
| `primitives/animated_value_builder.dart` | `animated_value_builder.dart` | |
| `primitives/_impl/core/animated_value_builder.dart` | `animated_value_builder.dart` | |
| `primitives/_impl/state/__animated_value_builder_state.dart` | `animated_value_builder.dart` | |
| `utils/animation_queue.dart` | `animation_queue.dart` | |
| `utils/_impl/core/__animation_runner.dart` | `animation_queue.dart` | |
| `utils/_impl/core/animation_request.dart` | `animation_queue.dart` | |
| `utils/_impl/utils/animation_queue_controller.dart` | `animation_queue.dart` | |
| `utils/controlled_animation.dart` | `animation.dart` | |
| `utils/_impl/core/repeated_animation_builder.dart` | `animation.dart` | |
| `utils/_impl/state/__repeated_animation_builder_state.dart` | `animation.dart` | |
| `utils/_impl/core/form_pending_builder.dart` (`RepeatedAnimationWidgetBuilder` only) | `animation.dart` | form builders stayed with E2/form_core |
| `utils/color_extensions.dart` | `foundation/color_extensions.dart` | decision: needs nothing from theme |
| `utils/tween_utils.dart` | `foundation/tween_utils.dart` | decision: needs nothing from theme |

Not ported (as instructed): `outlined_container` (+state/theme), `surface_blur` (+state), `chip_utils`, `wrap_utils`.

## 3. `color_extensions` / `tween_utils` placement (brief question)

Both went to **`NEXT/foundation/`**:

- `foundation/color_extensions.dart` — `ColorExtension` (`scaleAlpha`, `getContrastColor`,
  `withLuminance`, `toHex`, `toHSL`, `toHSV`), `HSLColorExtension`, `HSVColorExtension`.
  They need only `dart:math`, `dart:ui` and `package:flutter/rendering.dart` — nothing from
  `theme/`. The top-level `colorToHex` from the old file is **not duplicated**: the theme
  layer already owns it in `theme/color_utils.dart` (`colorToHex`/`hexFromColor`), exactly
  where OWNERSHIP.md places the colour math. Keeping a second copy would have broken the
  single-owner rule for callers importing both.
- `foundation/tween_utils.dart` — `tweenValue`, `IconThemeDataTween`; both only need
  `package:flutter/widgets.dart`. The audit had provisionally tagged the file `theme`, but
  the layer-closed rule + zero theme references make foundation the correct home.

## 4. Behaviour notes and deliberate fixes

1. **`Hidden` relayout (bug fix, ported from the winning copy).**
   The old `shared/primitives/_impl/core/__hidden_layout_render.dart` assigned
   `progress`/`keep*` directly from `updateRenderObject` **without** marking layout, so
   toggling `hidden` did not collapse the child until an unrelated relayout. The component
   fork (`components/layout/hidden/_impl/core/hidden_layout.dart`, the ownership winner)
   compares fields and calls `markNeedsLayout()`. The primitive now ports the winner's
   behaviour; `test/registry_next/primitives/hidden_relayout_test.dart` locks it in
   (contracts mid-animation, reaches 0, expands again).
2. **`PhoneNumber` from the superset copy.** OWNERSHIP.md gives `phone_number` to the
   `phone_input` fork (694 vs 494 chars). The primitive uses that body: nullable `country`,
   `withCountry`, `fullNumber`, `fullCodeNumber`, and `value` that requires a country.
   `Country` keeps the shared copy's convention (`dialCode` includes `+`), but gains
   value equality (`==`/`hashCode`) because `PhoneNumber.==` compares countries; without it
   every `PhoneNumber` comparison would be identity-based. `fullCodeNumber` adds `+` only
   when the dial code lacks one, so both old conventions produce a single prefix.
3. **`sheet_overlay` is a marker now.** The old shared helper read a `Model` key
   (`#shadcn_flutter_sheet_overlay`); data_widget's `Model` family was deliberately not
   ported to foundation. `SheetOverlayHandler.isSheetOverlay` now reads
   `Data.maybeOf<SheetOverlayMarker>`; the future `drawer` component wraps its sheet content
   in that provider. The drawer copy of `SheetOverlayHandler` (extends `OverlayHandler`)
   cannot live in a primitive: it calls `openRawDrawer`/`SheetWrapper`/`OverlayPosition`,
   which belong to the drawer component.
4. **Icon extensions keep the old merge direction.** `theme.iconTheme.small.merge(inherited)`
   lets the ambient value win for non-null fields (`IconThemeData.merge` semantics), so the
   ambient `IconTheme` keeps size/colour and the theme only fills gaps. Ported 1:1; the test
   documents the direction (`extensions_test.dart`).
5. **Widget extensions pruned by the audit.** Removed `.center()`, `.positioned()`,
   `.clip()`, `.clipRRect()`, `.clipOval()`, `.intrinsicWidth()`, `.intrinsicHeight()`,
   `.intrinsic()`, `.separator()` (0 call sites each) and `.asBuilder` (0 external call
   sites — `phone_input`'s private `_WidgetAsPopupBuilder` is unrelated). `.sized()`,
   `.constrained()`, `.withAlign()`, `.clipPath()`, `.expanded()`, `.withPadding()`,
   `.transform()`, `.withOpacity()` and the three `.gap()` helpers are kept.
   `NeverWidgetBuilder` is not re-declared (foundation owns it).
6. **`popover_overlay_state.dart`/`layout_render.dart` are 399/365 lines.** To keep them
   importable across files, `ClickableState`, `OverlayManagerLayerState` and
   `PopoverOverlayWidgetState` are public (the old `_`-prefixed classes were `part`-local);
   their docs mark them as framework-internal (accepted in QA round 2).
   `PopoverLayoutRender.updateConfiguration(...)` replaces the old direct private-field
   assignment from the widget.
7. **Theme classes.** `HoverTheme`, `FocusOutlineTheme`, `BasicTheme`, `HiddenTheme`,
   `FadeScrollTheme` are `ComponentThemeData` + `Mergeable` subclasses with the old
   `copyWith` API and a first-non-null `merge` (receiver wins). Reads go through
   `resolveComponentStyle<X, X>(context, select: (t) => t, defaults: const X())` and
   `styleValue`; this keeps the old `widget > tree > app > default` precedence and adds the
   app leg from `ComponentThemes`.
8. **Overlay manager lookup is tree-only (QA round 2, F1).** The static `_current` and the
   `register`/`unregister` hooks were removed: `OverlayManager.of` resolves the nearest
   `Data<OverlayManager>` in the tree and otherwise returns the per-widget
   `_FallbackOverlayManager`; `ShadcnLayer` installs a layer only when no manager is in
   scope above it. A context above/outside a layer gets the fallback, never a stale global.
   `ShadcnLayer` lives in `overlay_manager.dart` (not `layout.dart`) because it wraps
   `OverlayManagerLayer` directly.
9. **Removed `closePopover`** (deprecated alias) per the clean-break rule.
10. **`FadeScroll` keeps one subtree shape (QA round 2, F2).** The builder always emits a
    `ShaderMask`; when the controller has no clients or no edge needs a fade it uses a
    fully opaque identity shader. The scrollable is never remounted, so the scroll offset
    survives fade transitions without a `PageStorage` bucket.
11. **Disabled `SubFocus` items cannot become current (QA round 2, F3).** `SubFocusState`
    exposes `isEnabled`; both `SubFocus.requestFocus` and `SubFocusScope.requestFocus`
    return `false` for a disabled item and leave the current item untouched.

## 5. Members pruned / not ported

- `widget_extensions.dart`: 9 extension members + `asBuilder` (see §4.5).
- `icon_extensions.dart`: nothing pruned — the actual file contains `iconSmall`,
  `iconXSmall`, `iconX3Small`, `iconMutedForeground` (call sites 14/12/2/2); the audit's
  `.fill()/.size()/.weight()/.onPrimary()` note refers to a different (component) copy.
- `overlay.dart`: `closePopover` (deprecated) not ported.
- `color_extensions.dart`: top-level `colorToHex` not duplicated (theme owns it).
- Nothing else was dropped; every public symbol from the source files above is reachable.

## 6. Tests (`test/registry_next/primitives/`, 52 tests)

| File | Covers |
|---|---|
| `clickable_test.dart` (8) | hover/press/focus/disabled states, enter+space activation, double tap, `WidgetStatesProvider.boundary`, `.map`/`.builder` |
| `hover_test.dart` (3) | `HoverActivity` enter/exit/ticks, `Hover` delays, `HoverTheme` |
| `focus_subfocus_test.dart` (4) | `FocusOutline` ring in/out + theme align, `SubFocusScope` navigation, disabled items refused by item and scope |
| `overlay_test.dart` (6) | `ShadcnLayer` installs a manager, handler default, sheet marker, barrier dismissal, two layers route to their own manager, disposed layer leaves no manager behind |
| `popover_test.dart` (4) | layout inversion/clamping H+V, `showPopover` close, `PopoverController` |
| `animation_test.dart` (6) | queue ordering/curve/snap, `AnimatedValueBuilder` lerp/onEnd/step types, repeated + controlled animation |
| `fade_scroll_test.dart` (3) | stable `ShaderMask` shape, scroll offset/state survive fade toggles without `PageStorage`, theme gradient |
| `layout_test.dart` (6) | `Basic`/`BasicLayout`/`Label`, `Hidden` collapse + theme, `keepMainAxisSize` |
| `phone_number_test.dart` (4) | formatting, single `+`, unknown country, empty value, equality |
| `extensions_test.dart` (7) | widget/flex/double/int extensions, icon merge semantics, `SliderValue`, `MenuGroupData` |
| `hidden_relayout_test.dart` (1) | mid-animation collapse regression (see §4.1) |

`hidden_relayout_test.dart` was briefly named `zz_debug_test.dart` during the session; the
file was renamed (content intact) — no leftover scratch files.

## 7. Gates (raw, run from `flutter_shadcn_kit/`)

```
$ dart format --set-exit-if-changed lib/registry_next test/registry_next
Formatted 141 files (0 changed) in 0.23 seconds.   exit=0

$ dart analyze lib/registry_next test/registry_next
Analyzing registry_next, registry_next...
No issues found!                                   exit=0

$ flutter test test/registry_next
00:05 +233: All tests passed!                      exit=0
  (52 of these are primitives; the rest are foundation/theme/themes + P2-E2)

$ dart run tool/rearch/check_layers.dart --root lib/registry_next
check_layers: 106 files scanned, 0 files with syntax errors
  no-material: 0 (error)
  no-part: 0 (error)
  no-ignore-for-file: 0 (error)
  layer-direction: 0 (error)
  undeclared-dependency: 0 (error)
  file-too-long: 7 (warning)   <- 3 foundation icons + 4 theme files, pre-existing
  installable: 0 (error)
  no-impl-dir: 0 (error)

$ dart run tool/rearch/check_single_owner.dart --root lib/registry_next
check_single_owner: 106 files scanned, 297 declarations, 0 files with syntax errors
duplicate names: 0 (public 0, private 0) - identical 0, diverged 0
```

All warnings are pre-existing (icon data + theme files by other agents); no primitive file
exceeds 400 lines (max: `popover_overlay_state.dart` 399).

## 8. Open questions

All five questions from round 1 were decided in QA round 2:

1. **`SheetOverlayMarker` API change — ACCEPTED.** The drawer component provides
   `Data<SheetOverlayMarker>.inherit` where it previously used `MultiModel`.
2. **`Country` equality added — ACCEPTED.** `PhoneNumber` equality is value-based by design.
3. **`FadeScroll` remount — FIXED (F2).** See §4.10.
4. **`SubFocus` disabled items — FIXED (F3).** See §4.11.
5. **Public state classes — ACCEPTED.** `ClickableState`, `OverlayManagerLayerState` and
   `PopoverOverlayWidgetState` are documented as framework-internal in their doc comments.

No open questions remain for this unit.

## RESULT

```
status: done
files_written:
- flutter_shadcn_kit/lib/registry_next/primitives/{animated_value_builder,animation,animation_queue,basic_layout,clickable,clickable_state,extensions,fade_scroll,focus_outline,hidden,hover,label,layout,menu_group,overlay,overlay_manager,overlay_manager_layer,phone_number,popover,popover_controller,popover_layout,popover_layout_render,popover_overlay_handler,popover_overlay_state,popover_overlay_widget,sheet_overlay,slider_value,subfocus,subfocus_item,subfocus_scope,widget_states}.dart + README.md
- flutter_shadcn_kit/lib/registry_next/foundation/{color_extensions,tween_utils}.dart
- flutter_shadcn_kit/test/registry_next/primitives/{animation,clickable,extensions,fade_scroll,focus_subfocus,hidden_relayout,hover,layout,overlay,phone_number,popover}_test.dart
- rearch/reports/P2E1_PRIMITIVES.md
commands_run:
- dart format --set-exit-if-changed lib/registry_next test/registry_next -> 141 files (0 changed), exit 0
- dart analyze lib/registry_next test/registry_next -> No issues found!, exit 0
- flutter test test/registry_next -> 00:05 +233: All tests passed! (52 primitives)
- check_layers --root lib/registry_next -> 0 errors, 7 pre-existing file-too-long warnings (3 foundation icons + 4 theme files)
- check_single_owner --root lib/registry_next -> duplicate names: 0
key_findings:
- QA round 2: removed the global OverlayManager registry (F1); FadeScroll now always mounts a ShaderMask (identity shader when idle) so the scrollable is never remounted (F2); disabled SubFocus items cannot become current (F3).
- Hidden never relaid out on toggle in the old shared copy; the component fork's markNeedsLayout fix was ported and is locked by hidden_relayout_test.dart.
- color_extensions/tween_utils need nothing from theme -> foundation/; top-level colorToHex not duplicated (theme/color_utils.dart owns it).
- PhoneNumber/Country follow the phone_input superset; Country value equality and the Data<SheetOverlayMarker> marker were accepted in QA round 2.
- popover `part`-local states are now public and documented framework-internal (ClickableState, OverlayManagerLayerState, PopoverOverlayWidgetState); Popover._ -> Popover.from.
- Theme classes are ComponentThemeData + Mergeable (receiver wins), resolved via resolveComponentStyle + styleValue; old widget > tree > app > default precedence kept.
- Pruned 0-call-site widget-extension members; deprecated closePopover and outlined_container/surface_blur/chip_utils/wrap_utils not ported.
open_questions:
- None. All round-1 questions were decided (Q1/Q2/Q5 accepted, Q3/Q4 fixed); see §8.
```


## 9. QA round 2 resolution (orchestrator)
All §8 questions resolved: Q1 `Data<SheetOverlayMarker>` accepted; Q2 `Country` value equality accepted;
Q3 FadeScroll remount FIXED (stable `ShaderMask` with identity shader); Q4 SubFocus disabled items FIXED
(`requestFocus` returns false); Q5 public state classes accepted. Global `OverlayManager._current` REMOVED
(tree lookup + per-widget fallback only).
