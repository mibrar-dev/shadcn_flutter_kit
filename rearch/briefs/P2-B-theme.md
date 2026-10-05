# Brief P2-B — Build `theme/` (layer 1) in the new tree

## Context
You designed this. Implement `$KIT/rearch/reports/THEME_DESIGN.md` **as amended** (A1–A5 + the two orchestrator
fixes recorded in `$KIT/rearch/reports/QA_LOG.md`: override-wins merge and alpha multiply) into
`NEXT = $APP/lib/registry_next/theme/`. The old `$REG` stays untouched. Clean break (PLAN §3, user decision):
NO deprecated aliases, NO compatibility shims — the old names simply do not exist in the new tree.

Also apply these decisions from QA_LOG (P1-D):
- Fonts are mode-independent: `ShadcnThemeData` carries one `fonts` value (fontSans/fontSerif/fontMono),
  not per brightness.
- Colours may carry alpha (8-digit ARGB); never assume opaque.
- Shadows: `ShadowScale` stays 8 sizes; add a `ShadowScale.derive(...)` factory that builds the 8 sizes from base
  atoms (color, opacity, blur, spread, offsetX, offsetY) calibrated so that, fed today's default base values, it
  reproduces today's hardcoded `ThemeData` default shadows exactly (write a test proving that).

## Files to create (exactly these 5 + README)
`tokens.dart`, `theme.dart`, `typography.dart`, `density.dart`, `color_utils.dart`, `README.md` (≤ 80 lines:
token list, resolution order, how a component defines `<Name>Theme` + defaults + user file, with a 15-line example).
Each Dart file ≤ ~400 lines; if `tokens.dart` would exceed it because of the 32 tokens × (fields, copyWith, lerp,
ColorRef.resolve), you may split into `tokens.dart` + `color_tokens.dart` — say so in the report.

Content (see THEME_DESIGN §1, §2.1, §3.5, §6): `ShadcnColors` (32 tokens incl. brightness, full copyWith/lerp,
no `// ...` elisions), `ShadcnTokens`, `ShadowScale`/`SpacingScale`/`TrackingScale`, `ColorRef`, `ThemedColor`
(ref with alpha multiply / value), `StateValue<T>`, `ShadcnThemeData` (+ copyWith, lerp, radius getters),
`ShadcnTheme` (InheritedTheme, `of`, dark readability normalisation kept), `AnimatedShadcnTheme`,
`ComponentThemeData`, `ComponentTheme<T>` (tree-only `maybeOf`), `ComponentThemes` (app registry leg),
`resolveComponentStyle<T, S>`, `Density`, `AdaptiveScaling` + applicator widget, typography + icon theme,
`ColorShades` + HSL helpers + the `Colors`-style palette that components really use (prune unused; grep `$REG`).
Keep `surfaceOpacity/surfaceBlur/enableFeedback/platform` only if `$REG/components` reads them (grep; report counts).

Imports allowed: `package:flutter/widgets.dart` (+ foundation/painting/services/scheduler), `dart:*`, other
`theme/` files, and `../foundation/*.dart` (layer 0 — being built in parallel by another agent; only import it if
you truly need something from it, and tell the orchestrator what). No packages, no Material/Cupertino.

## Tests (`$APP/test/registry_next/theme/*_test.dart`)
1. Resolver precedence — every leg overrides the one below: defaults < app (ComponentThemes) < scoped
   (ComponentTheme in tree) < widget; and a per-state case (widget sets only `hovered`, ancestor's `rest` survives).
2. `ComponentTheme.maybeOf` does NOT fall back to the app registry.
3. `StateValue.resolve` precedence (disabled > pressed > hovered > focused > selected > rest) and `merge`.
4. `ThemedColor.ref(..., alpha: 0.8)` on a token with alpha 0.1 → 0.08.
5. `ShadcnColors.lerp` / `ShadcnThemeData.lerp` endpoints; `AnimatedShadcnTheme` animates a colour.
6. Dark readability normalisation keeps today's behaviour (port a case from `$REG/shared/theme/_impl/themes/theme.dart`).
7. `ShadowScale.derive` reproduces today's default shadows (see above).

## Outputs (only these)
`$APP/lib/registry_next/theme/**`, `$APP/test/registry_next/theme/**`,
`$KIT/rearch/reports/P2B_THEME.md` (files + LOC, deviations from THEME_DESIGN with reasons, grep counts used for
pruning, open questions).

## Gates (run all; paste results in the report)
```
cd $APP
dart format --set-exit-if-changed lib/registry_next/theme test/registry_next/theme
dart analyze lib/registry_next/theme test/registry_next/theme      # 0 issues
flutter test test/registry_next/theme                               # all green
dart run tool/rearch/check_layers.dart --root lib/registry_next     # 0 errors for theme/
dart run tool/rearch/check_single_owner.dart --root lib/registry_next
```
