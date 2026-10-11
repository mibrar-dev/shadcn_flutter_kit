# Brief P2-D — Presets: new JSON schema, 42 migrated presets, JSON → Dart generator

## Context
Read: PLAN §6; `$KIT/rearch/reports/THEME_DESIGN.md` §1, §5; `$KIT/rearch/reports/TOKENS_AUDIT.md`;
`$KIT/rearch/reports/QA_LOG.md` (P1-D decisions + P2-B entries). The new theme layer is DONE and accepted:
`$APP/lib/registry_next/theme/` (read `tokens.dart`, `color_tokens.dart`, `theme.dart`, `README.md`) — use its
real API (`ShadcnColors`, `ShadcnTokens`, `ShadowScale.derive(...)`, `ShadcnThemeData`). Do not modify theme/.
Old files are read-only: `$REG/themes_preset/*.json`, `$REG/manifests/themes.schema.json`, `$REG/manifests/theme.index.json`.

## Source of truth for tokens (important)
The old preset JSONs have a known bug: all 8 shadow sizes identical (copied), and fonts inconsistent. The ORIGINAL
tweakcn atoms exist in the CLI repo: `$CLI/lib/registry/shared/theme/preset_theme_data.dart` (42 presets;
`lightTokens`/`darkTokens` with `shadowBlur/shadowColor/shadowOffsetX/shadowOffsetY/shadowOpacity/shadowSpread`,
`fontSans/fontSerif/fontMono`, `radius`, `spacing`, `tracking`; colours as ARGB hex). Use it for shadow atoms and
fonts. Use the old JSON for colours, but cross-check every colour against the CLI data and report mismatches.
`darkTokens: {}` means "same as light". For presets with no shadow atoms (expected: caffeine, claude, t3-chat —
verify), derive atoms from the old JSON's single shadow entry and mark `"shadowsDerived": "from-legacy"` (explain).

## Outputs (only these)
1. `$APP/lib/registry_next/themes/themes.schema.json` (draft 2020-12). Per preset:
   `id`, `name`, `schemaVersion: 2`, `light` / `dark` colour maps (all 32 tokens required; values `#RRGGBB` or
   `#RRGGBBAA` strings — alpha allowed; document the format), top-level `fonts` {`sans`,`serif`,`mono`} (optional
   strings, NOT per mode), `radius` (rem number), `spacing` (rem number), `tracking` {`normal`, optional `tight`,
   `wide`} (em number), `shadow` base atoms per mode {`color`, `opacity`, `blur`, `spread`, `offsetX`, `offsetY`}
   (px numbers). No derived shadow sizes stored — sizes always come from `ShadowScale.derive`.
   `additionalProperties: false` everywhere.
2. `$APP/lib/registry_next/themes/<id>.json` × 42 + `$APP/lib/registry_next/themes/index.json` (id, name, file).
3. `$APP/tool/rearch/migrate_presets.dart` — the one-off converter that produced (2) (keep it: reproducible).
4. `$APP/tool/rearch/gen_app_theme.dart` — `dart run tool/rearch/gen_app_theme.dart <preset.json> <out.dart>`
   writes a values-only, `dart format`-clean `app_theme.dart` per THEME_DESIGN §5.2 using the real registry_next
   API: `const ShadcnColors <id>LightColors/<id>DarkColors`, token values, `ShadowScale.derive(...)` calls
   (derive is a factory → use `final`, not `const`, where needed), and `ShadcnThemeData build<Id>Theme(Brightness)`.
   Imports must point at the installed theme layer via a `--theme-import <uri>` flag (default
   `package:flutter_shadcn_kit/registry_next/theme/theme.dart` + siblings as needed).
5. Tests `$APP/test/registry_next/themes/`:
   - every preset validates against the schema (use a small validator in Dart, or the `json_schema` approach
     already available — no new pub dependencies; if none available, implement structural checks in the test);
   - round-trip: for ALL 42 presets, generate app_theme.dart into a temp dir inside `$APP/.dart_tool/rearch_gen/`,
     then compile-check it (`dart analyze` on the generated files) — batch this for speed;
   - a widget test that loads 2 generated themes and asserts a few resolved values (primary colour, radius,
     shadowSm second layer) match the JSON;
   - colour parsing: `#RRGGBBAA` alpha preserved.
6. `$KIT/rearch/reports/P2D_PRESETS.md`: schema summary, per-preset table (fonts present?, shadow source CLI/legacy,
   colour mismatches JSON vs CLI), decisions, anything unresolved.

## Gates
```
cd $APP
dart format --set-exit-if-changed tool/rearch test/registry_next/themes
dart analyze tool/rearch test/registry_next/themes      # 0 issues
flutter test test/registry_next/themes                  # all green
flutter test test/rearch                                # existing tooling tests still green
```
