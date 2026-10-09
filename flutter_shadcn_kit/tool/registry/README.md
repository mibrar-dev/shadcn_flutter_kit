# Registry Scripts

Scripts for the post-cutover flat registry (`lib/registry/`).

## Generated manifest

`lib/registry/manifests/registry.json` (schemaVersion 2) is the single
registry manifest the CLI reads. Regenerate it after any change to the
registry tree:

- `dart run tool/registry/gen_registry_manifest.dart` — writes the manifest
  from `components/*/meta.json`, the foundation/theme/primitives layers,
  `themes/*.json` and `pubspec.yaml`. Deterministic; `--check` exits 1 when
  the file on disk is stale.
- Build logic: `src/registry_manifest.dart` (+ `src/layer_scan.dart`,
  `src/dart_imports.dart`). Contract:
  `rearch/reports/registry_manifest.v2.schema.json`.
- Guard: `test/rearch/registry_manifest_test.dart` (up to date + schema +
  dependency closure).

## Package barrel

- `dart run tool/registry/registry_barrel_generate.dart` — regenerates
  `lib/flutter_shadcn_kit.dart` (theme layer + every component entry).

## See also

- `tool/rearch/` — layers/single-owner/user-theme guardrails and
  `gen_app_theme.dart` (preset → `app_theme.dart`).
