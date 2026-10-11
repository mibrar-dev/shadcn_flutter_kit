# P2-B — theme/ (layer 1) build report (rev 2: QA round 1 fixes F1–F5)

## Files written (+ LOC, post-`dart format`)

`NEXT = flutter_shadcn_kit/lib/registry_next/theme/`:

| File | LOC | Contents |
|---|---|---|
| `color_tokens.dart` | 587 | `ShadcnColors` (32 + brightness, copyWith/lerp/==/hash, light/darkFallback), `ColorRef` (32 + resolve), `ThemedColor`/`LiteralColor`/`RefColor`, `Mergeable<S>`, `StateValue<T>` |
| `tokens.dart` | 452 | `SpacingScale`, `TrackingScale` (+tight/wide), `ShadowScale` (+tweakcn `derive`, `defaultShadowScale`), `ShadcnFonts`, `ShadcnTokens` |
| `theme.dart` | 448 | `ShadcnThemeData` (+copyWith/lerp/radius getters), `ShadcnTheme` (+dark normalisation), `AnimatedShadcnTheme`+tween, `ComponentThemeData`, `ComponentTheme<T>`, `ComponentThemes` (inherited app leg), `resolveComponentStyle` (Mergeable-bound), `ThemeMode` |
| `typography.dart` | 613 | `Typography` (38 styles, geist/copyWith/scale/applyFonts/lerp/==), `IconThemeProperties` |
| `density.dart` | 322 | pad/gap consts, `Density`, edge-insets helpers, `DensityContentPadding/ContainerPadding`, `AdaptiveScaling`, `AdaptiveScaler` |
| `color_utils.dart` | 313 | `fromAHSL`, `hexFromColor`/`colorToHex`, pruned `Colors`, `ColorShades` |
| `README.md` | 51 | token list, resolution order, component pattern + 15-line example |

Tests `flutter_shadcn_kit/test/registry_next/theme/` (7 files, 22 tests, all green).
No split beyond `tokens.dart` + `color_tokens.dart`. No `../foundation/` imports
(layer 0 not needed — orchestrator note: theme/ depends only on
`flutter/widgets.dart`, `flutter/foundation.dart`, `dart:ui`).

## Deviations from THEME_DESIGN (with reasons)

1. No deprecated aliases/shims (`Theme`/`ThemeData`/`ColorScheme` compat):
   clean break per PLAN §3 user decision + brief.
2. Fonts mode-independent: `ShadcnFonts{fontSans,Serif,Mono}` lives on
   `ShadcnThemeData`, not in `ShadcnTokens` (QA P1-D).
3. App leg is the inherited widget `ComponentThemes(themes: [...])` at the
   app root (QA F2), not a static registry; generated file exports
   `const appComponentThemes = <ComponentThemeData>[...]`.
4. `ShadcnThemeData` keeps direct defaulted fields (density/spacing/tracking/
   typography/iconTheme) instead of §5.2 constructor derivation — preserves
   const-constructibility and lerp granularity; `Density.fromSpacingScale`
   and `Typography.applyFonts` cover the derivation paths.
5. `RefColor.resolve` multiplies alpha + clamps (orchestrator fix); resolver
   merges via `Mergeable` (QA F3) — no caller lambda, override-wins is
   structural (`slice.merge(acc)`).
6. `Colors` pruned to black/white/transparent (counts below); 22 ramps +
   `primaries` cut; `ColorExtension` (scaleAlpha/contrast) cut — only HSL
   helpers kept per brief.
7. Dropped `DensityRow/Column/Flex/Gap` (`gap` package banned by PLAN; flex
   spacing is native now); kept paddings + edge-insets helpers.
8. Dropped `radiusXsRadius`-style getters; kept `radius*` + `borderRadius*`.
9. `ShadcnColors.copyWith` plain optionals (fields non-nullable — design's
   own wording); `Typography.copyWith` likewise. Theme-data copyWith keeps
   ValueGetter + density→spacing derivation.
10. `Styleable` deleted entirely (QA F4); components just carry a nullable
    `theme` field. Zero `// ignore` comments in `lib/registry_next/theme`
    (the old `value`-override ignore was cargo-cult — override stands clean).
11. `ensureReadableDarkTheme` public static (testable), thresholds verbatim.
12. 4 files exceed ~400 lines (warning-level only, 0 errors): mechanical
    32-token × methods / 38-style × methods repetition with zero elisions,
    as the brief required (`// ...` forbidden).
13. `ShadowScale.derive` implements the tweakcn formula (QA F1), not the
    round-1 subtractive version: absolute detail layers (y, b per size),
    alpha ratios 0.5/1.0/2.5, default opacity 0.15 (≈ 0x26/255, the dominant
    old ambient alpha — chosen so sm..xl reproduce byte-exactly and every
    size lands within 1/255 of the old literals).

## Grep counts used for pruning/retention (`$REG`)

- `surfaceOpacity` 280 hits / `surfaceBlur` 247: ~32 read `theme.*`
  (surface_card, app_bar, navigation_menu, dropdown_menu, …) → KEPT.
- `enableFeedback` 76: `theme.enableFeedback` read in button_state → KEPT.
- `theme.platform`/`specifiedPlatform`: navigation_menu, context_menu,
  button_state + adaptive_scaler → `platform` KEPT.
- `Colors.<x>` in components (282): blue 78, white 51, grey 33, red 27,
  green 23, transparent 21, black 11 — all resolve to **Material's** Colors
  (banned dep), not the local palette. Local `generated_colors` imported by
  4 files; real member use = `Colors.white` ×1 (button_helpers destructive
  text → component layer must use `destructiveForeground` token instead);
  fade_scroll ×2 + number_ticker ×1 use zero members (dead imports).
- `Density` 199 files, `AdaptiveScaling` 37 → kept. `Typography`: every one
  of the 38 members has ≥1 consumer in components, so F5 prunes nothing:
  `small` 31, `medium` 17, `xSmall` 14, `semiBold` 12, `large`/`normal` 6,
  `x4Large` 4, `sans`/`mono`/`base`/`p`/`textMuted`/`x2Large` 2–3, and 23
  members exactly once — all 23 solely via the `display/text` showcase
  component (`text.dart`), which binds every style. `iconTheme.*` likewise
  all used (small 8, xSmall 5, medium/xLarge/x3Small 2, 6 more ×1). Cutting
  any member would break the future `text` migration; typography stays 613
  lines of mechanical repetition. Per-member table verified 2026-10-06.
- `SpacingScale|TrackingScale|ShadowScale` 0 direct refs (via ThemeData) →
  safe to relocate; `IconThemeProperties` 0 direct (via iconTheme) → kept.

## Gates (all run, results pasted)

- `dart format --set-exit-if-changed lib/registry_next/theme
  test/registry_next/theme` → 13 files, 0 changed.
- `dart analyze lib/registry_next/theme test/registry_next/theme` →
  No issues found!
- `flutter test test/registry_next/theme` → 22/22 passed (incl.
  tweakcn derive: exact geometry + alpha ≤1/255 vs defaults, tailwind ramp
  values, no-negative-blur; 0.1*0.8→0.08; mid-animation color; dark
  normalisation port; 4-leg precedence + per-state survival, no merge lambda).
- `dart run tool/rearch/check_layers.dart --root lib/registry_next` →
  0 errors (no-material/part/ignore/layer/undeclared/installable/no-impl);
  file-too-long: 4 warnings (see deviation 12).
- `dart run tool/rearch/check_single_owner.dart --root lib/registry_next` →
  57 declarations, 0 duplicates.
- `grep -rn '// ignore' lib/registry_next/theme` → nothing.
- Old `$REG` untouched (git status clean for `lib/registry`).

## Open questions

- `fontSerif` stored, unwired (no serif slot in `Typography`).
- `tracking.normal` not auto-applied as letterSpacing (matches old runtime;
  0 direct consumers).
- Fallback `destructiveForeground` = transparent (faithful transcription);
  contrast derivation belongs to the CLI importer, not runtime.
