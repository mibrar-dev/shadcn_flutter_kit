# Brief P1-A — Theme system design (architect)

## Goal
Design the new, minimized theme system described in PLAN §6 (6.1–6.5). This is a DESIGN document with exact
Dart API signatures, not an implementation. It must preserve today's token system and all 42 presets.

## Read first (all of it)
- PLAN §4, §5, §6
- REG/shared/theme/** (excluding generated/ — skim one folder only: generated/claude)
- REG/themes_preset/claude.json, REG/manifests/themes.schema.json, REG/manifests/theme.index.json
- Button theme today: REG/components/control/button/_impl/themes/** and REG/components/control/button/theme.schema.json
- One simpler component theme for contrast: REG/components/display/badge/_impl/themes/**
- REG/components/component_theme_global_configs.dart (head), REG/shared/theme/component_theme_global_registry.dart
- REG/shared/theme/schema/component_schema.dart
- CLI/lib/src/application/services/theme/theme_css.dart and CLI/lib/src/application/services/studio/studio_manager.dart
- How components consume theme: grep REG/components for `Theme.of(context)`, `ComponentTheme`, `Styleable` (sample 5 components)

## Design requirements
1. Global tokens: names = camelCase of shadcn CSS variables (table in PLAN §6.1). Light + dark. Include radius
   (+ derived steps), fontSans/fontSerif/fontMono, tracking, spacing, shadow base values + derived shadow2xs..shadow2xl.
2. `shared/theme` collapses to ~5 files (PLAN §6.5): tokens.dart, theme.dart, typography.dart, density.dart,
   color_utils.dart. For EACH of today's 27 files state: merged into which new file / deleted (why) / kept.
   Flag anything consumers rely on (grep usage counts across REG/components).
3. Component theme pattern, shown fully for Button (variants: primary, secondary, outline, ghost, link, destructive,
   plus whatever today's variants are — list them all and say which collapse into others):
   - `button_style.dart`: `ButtonTheme` (nullable fields, copyWith, merge, lerp), `ButtonVariant` enum,
     defaults computed from tokens, exhaustive variant table, use `WidgetStateProperty` / `WidgetState`.
   - `button_theme.dart` (USER-OWNED, values only, rewritten by Studio): exact file shape, incl. token references
     (`ThemeRef.primary`-style) vs literals. Show a complete example file.
   - Resolution order: widget arg > nearest `ComponentTheme<ButtonTheme>` > app overrides (button_theme.dart) >
     token defaults. Give the resolver code.
   - How the app registers installed component themes (generated `component_themes.dart` in the user app) — exact shape.
4. Editor schema: define the `theme` section inside `meta.json` (JSON example for Button), and how
   `tool/gen_theme_schema.dart` derives it from `ButtonTheme` fields (supported field types → editor controls).
5. Presets: JSON stays canonical. Define the generated `app_theme.dart` (values-only) the CLI writes for the chosen
   preset, replacing preset_themes.dart (4.4k LOC) and generated/** (168 files) and the regex patcher in theme_css.dart.
6. Theme switching at runtime (light/dark + preset swap) and animated transitions — keep today's behaviour, list it.
7. Migration map: table "old file → new location" for shared/theme and for the button's 18 theme files.
8. Risks + open questions.

## Outputs
- $KIT/rearch/reports/THEME_DESIGN.md (only this file)

## Acceptance (the QA lead will check)
- Every one of the 27 shared/theme files and 18 button theme files appears in the migration map.
- All Dart snippets are valid Dart 3.10+ and import only flutter/widgets.dart (or foundation/painting).
- Token list exactly matches the keys in REG/themes_preset/claude.json light/dark/tokens.
