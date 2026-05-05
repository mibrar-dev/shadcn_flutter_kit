# Theme Scripts

Scripts for theme schema/index/config generation and exports.

## Production Layout

- Per-component top-level `theme.schema.json` files are canonical.
- Nested component `registry/theme.schema.json` files are legacy compatibility artifacts and should be removed.
- Run registry sync and verify after schema changes:
  - `dart run tool/registry/registry_sync_all.dart --force`
  - `dart run tool/registry/registry_verify.dart`

## Theme Config Rollout Contract

Task 3 establishes the pilot contract that later theme-config rollouts must keep.

- `*_theme_tokens.dart` is the only independent source of component theme values.
- `*_theme_defaults.dart` is a derived compatibility layer over tokens, or is removed once surrounding tooling no longer needs it.
- `*_theme_config.dart` must expose real resolved theme instances or getters. Do not leave theme globals as `null`.
- Component styles must resolve through the component config path so token changes alter runtime behavior without per-widget hardcoding.
- When migrating `resolve<T>()`, preserve the runtime values proven by the button pilot before changing the lookup structure.

Button pilot reference:

- Tokens: `lib/registry/components/control/button/_impl/themes/config/button_theme_tokens.dart`
- Defaults compatibility layer: `lib/registry/components/control/button/_impl/themes/config/button_theme_defaults.dart`
- Config resolution: `lib/registry/components/control/button/_impl/themes/config/button_theme_config.dart`
- Runtime consumer: `lib/registry/components/control/button/_impl/styles/component_theme_button_style.dart`
- Guard test: `test/registry/components/control/button/component_theme_button_style_test.dart`

Required verification for generated or mirrored theme changes:

- `dart run tool/registry/registry_sync_all.dart --force`
- `cd ../docs && flutter analyze && flutter build web`
- `cd ../flutter_shadcn_kit && flutter analyze && flutter test`

## Scripts

- `component_theme_schema_generate.dart`
  - Generates per-component top-level `theme.schema.json` files.
  - Command: `dart run tool/theme/component_theme_schema_generate.dart`
  - Docs: `component_theme_schema_generate_readme.md`
- `component_theme_global_configs_generate.dart`
  - Regenerates global component theme config registration.
  - Command: `dart run tool/theme/component_theme_global_configs_generate.dart`
  - Docs: `component_theme_global_configs_generate_readme.md`
- `theme_index_generate.dart`
  - Generates `lib/registry/manifests/theme.index.json`.
  - Command: `dart run tool/theme/theme_index_generate.dart`
  - Docs: `theme_index_generate_readme.md`
- `theme_preset_dart_parser.dart`
  - Parser utility for theme preset extraction.
  - Docs: `theme_preset_dart_parser_readme.md`
- `theme_preset_export_all.dart`
  - Exports all presets.
  - Command: `dart run tool/theme/theme_preset_export_all.dart`
  - Docs: `theme_preset_export_all_readme.md`
- `theme_preset_export_one.dart`
  - Exports a single preset.
  - Command: `dart run tool/theme/theme_preset_export_one.dart <theme-id>`
  - Docs: `theme_preset_export_one_readme.md`

## Help

Use `-h` or `--help` on supported scripts.
