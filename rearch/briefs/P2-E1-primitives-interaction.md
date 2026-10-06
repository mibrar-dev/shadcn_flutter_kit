# Brief P2-E1 — `primitives/` (layer 2): interaction, overlay, animation, layout helpers

## Context
New architecture tree `NEXT = $APP/lib/registry_next/`. DONE and accepted — read them first and use their real APIs:
- `NEXT/foundation/` (layer 0: `Data`, `Gap`, geometry, platform, keyboard, … — read `NEXT/foundation/README.md`)
- `NEXT/theme/` (layer 1: `ShadcnTheme`, `ShadcnThemeData`, `ComponentTheme`, `ComponentThemes`,
  `resolveComponentStyle`, `Mergeable`, `StateValue`, `ThemedColor` — read `NEXT/theme/README.md`)
Read PLAN §3–§6, `$KIT/rearch/reports/OWNERSHIP.md` / `ownership.json` (`shared_map`), `$KIT/rearch/reports/QA_LOG.md`.
Clean break: NO aliases/shims; old `$REG` untouched. Another agent builds `primitives/form_core`, `primitives/text`,
`primitives/localizations` in parallel — do not touch those folders.

## Scope (source files in `$REG/shared`, per ownership.json)
- clickable group (9 files): clickable, stated widgets, widget states data/provider
- hover, hover_activity, focus_outline, subfocus (5 files), basic, basic_layout, hidden (+ hidden layout render),
  label, shadcn_layer, menu_group, slider_value, icon_extensions, widget_extensions, fade_scroll (+ scale gradient)
- overlay + popover family: overlay, overlay_manager(+layer), overlay_barrier, overlay_popover_entry,
  fallback overlay manager, overlay_completer/handler, popover, popover_layout(+render), popover_controller,
  popover_overlay_widget(+state), popover_overlay_handler, sheet_overlay
- animation: animated_value_builder, animation_queue (+ runner, request, controller), controlled_animation,
  repeated_animation_builder (from shared/utils split)
- phone_number + country (used by form and phone_input → stays a primitive)
- `shared/utils/color_extensions.dart` and `tween_utils.dart` (audit says theme layer, but theme/ is closed):
  put them in `NEXT/foundation/` if they need nothing from theme, else in `NEXT/primitives/` — say which.
- DELETE (do not port): outlined_container (+ state/theme), surface_blur (+ state), chip_utils, wrap_utils.

## Target shape (`NEXT/primitives/`)
Group by responsibility into few readable files, each ≤ ~400 lines, no `_impl/`, e.g.:
`clickable.dart`, `hover.dart` (hover + hover activity), `focus.dart` (focus_outline + subfocus),
`overlay.dart` (manager, layer, barrier, handler, completer), `popover.dart` (popover, layout, controller, overlay widget),
`sheet_overlay.dart`, `animation.dart` (animated value builder, queue, controlled, repeated), `layout.dart` (basic,
basic_layout, hidden, label, shadcn_layer), `fade_scroll.dart`, `menu_group.dart`, `slider_value.dart`,
`extensions.dart` (icon + widget extensions, pruned of 0-call-site members per the audit), `phone_number.dart`.
If a group legitimately exceeds 400 lines, split by responsibility (e.g. `popover.dart` + `popover_layout.dart`).
Old per-primitive `*_theme.dart` classes (basic_theme, hover_theme, focus_outline_theme, hidden_theme,
fade_scroll_theme) become `ComponentThemeData` subclasses resolved via `resolveComponentStyle` / `ComponentTheme`
— keep them next to their primitive, no separate theme files.

Rules: import only `../foundation/*`, `../theme/*`, sibling primitives, and Flutter non-Material libraries.
Replace every `package:data_widget` / `package:gap` use with foundation. Rename old theme API to the new one
(`Theme.of` → `ShadcnTheme.of`, `ColorScheme` → `ShadcnColors`, etc.). No Material/Cupertino, no `part`,
no `// ignore`, no dead code. Behaviour must not change (keyboard, focus traversal, hover, overlay stacking,
popover positioning/flip, sheet drag, animation timing).

## Tests (`$APP/test/registry_next/primitives/*_test.dart`)
Clickable states (hover/press/focus/disabled + keyboard activation), focus outline, subfocus navigation, hover
activity, popover open/close + alignment/flip near screen edge, overlay barrier dismissal, sheet overlay, animation
queue ordering, animated value builder, fade_scroll gradient visibility, phone number parsing. Port behaviour from
the old implementation; where the old code has tests or docs examples, mirror them.

## Outputs (only these)
`$APP/lib/registry_next/primitives/**` (except form_core/, text/, localizations/), possibly
`$APP/lib/registry_next/foundation/{color_extensions,tween_utils}.dart` (new files only — do not edit existing
foundation files; if a foundation change is needed, report it), `$APP/test/registry_next/primitives/**`,
`$KIT/rearch/reports/P2E1_PRIMITIVES.md` (old file → new file for every source file listed above, LOC, members
pruned, behaviour notes, open questions).

## Gates (paste results in the report)
```
cd $APP
dart format --set-exit-if-changed lib/registry_next test/registry_next
dart analyze lib/registry_next test/registry_next                     # 0 issues
flutter test test/registry_next                                        # all green
dart run tool/rearch/check_layers.dart --root lib/registry_next        # 0 errors
dart run tool/rearch/check_single_owner.dart --root lib/registry_next  # 0 duplicates
```
