# Registry Scripts

Scripts for the post-cutover flat registry (`lib/registry/`).

`src/categories.dart` is the single source of truth for the two P6-B1
taxonomies (component categories and block categories) and for the viewport
hints a block may declare. `gen_registry_manifest.dart` and
`tool/rearch/check_layers.dart` both read it, so a typo in a `meta.json`
category fails the gate instead of reaching the docs.

## Generated manifest

`lib/registry/manifests/registry.json` (schemaVersion 2) is the single
registry manifest the CLI reads. Regenerate it after any change to the
registry tree:

- `dart run tool/registry/gen_registry_manifest.dart` — writes the manifest
  from `components/*/meta.json`, `blocks/*/meta.json`, the
  foundation/theme/primitives layers, `themes/*.json` and `pubspec.yaml`.
  Deterministic; `--check` exits 1 when the file on disk is stale. It also
  rejects an unknown component category, an unknown block category or
  viewport, and a block directory without a `README.md` or entry file.
- Build logic: `src/registry_manifest.dart` (+ `src/layer_scan.dart`,
  `src/dart_imports.dart`, `src/categories.dart`). Contract:
  `rearch/reports/registry_manifest.v2.schema.json`.
- Guard: `test/rearch/registry_manifest_test.dart` (up to date + schema +
  dependency closure).

## Blocks

`lib/registry/blocks/<id>/` is layer 4, above components: `<id>.dart`
(the public widget, which is also the preview), optional
`<id>_<part>.dart` parts, `meta.json` and `README.md`. A block may import
foundation/theme/primitives/components, never another block.

- `dart run tool/registry/gen_blocks_test.dart` — writes
  `test/registry/blocks/blocks_render_test.dart` (every block pumped at
  375/768/1440 under neutral + claude, light + dark) and
  `test/registry/blocks/blocks_meta_test.dart` (meta.json category,
  viewport, files, and deps == the real imports, derived here with
  `package:analyzer`). `--check` exits 1 when either file is stale.
- `tool/rearch/check_layers.dart` adds `block-imports` (a block importing
  another block) and `block-installable` (self-contained block directory).

Note: the Dart file stem is the id with `-` replaced by `_`, so
`dashboard-01` lives in `dashboard_01.dart` — Dart file names must satisfy
the `file_names` lint.

## Package barrel

- `dart run tool/registry/registry_barrel_generate.dart` — regenerates
  `lib/flutter_shadcn_kit.dart` (theme layer + every component entry).

## See also

- `tool/rearch/` — layers/single-owner/user-theme guardrails and
  `gen_app_theme.dart` (preset → `app_theme.dart`).
