# Registry Scripts

Scripts for building and validating registry metadata/manifests.

## Production Layout

- Component-level `meta.json`, `<id>.meta.json`, and `theme.schema.json` are canonical.
- Nested component `registry/` metadata directories are legacy compatibility artifacts and should be removed.
- `docs/lib/ui/shadcn` is generated from the registry mirror for the docs app. Do not hand-edit generated docs mirror files.

## Main Workflow

1. `dart run tool/registry/registry_readme_meta.dart`
2. `dart run tool/registry/registry_sync_all.dart --force`
3. `dart run tool/registry/registry_index_generate.dart`
4. `dart run tool/registry/registry_verify.dart`

## Pre-PR Check

Run these commands before opening a PR:

1. `cd flutter_shadcn_kit && dart run tool/registry/registry_verify.dart --ci`
2. `cd docs && flutter analyze && flutter build web`
3. `cd flutter_shadcn_kit/flutter_cli_verification_example && flutter analyze && flutter build web`
4. Optional harness smoke test: `cd flutter_shadcn_kit/flutter_cli_verification_example && flutter test test/widget_test.dart`

## Scripts

- `registry_sync_all.dart`
  - Syncs top-level component metadata + `components.json` + docs snapshot.
  - Docs: `registry_sync_all_readme.md`
- `registry_components_manifest.dart`
  - Rebuilds `components.json` from component metadata and filesystem.
  - Docs: `registry_components_manifest_readme.md`
- `registry_meta_update.dart`
  - Updates existing top-level component `meta.json` files (files/deps/version/api merge).
  - Docs: `registry_meta_update_readme.md`
- `registry_readme_meta.dart`
  - Generates `<id>.meta.json` from README content.
  - Docs: `registry_readme_meta_readme.md`
- `registry_index_generate.dart`
  - Generates `lib/registry/manifests/index.json`.
  - Docs: `registry_index_generate_readme.md`
- `registry_verify.dart`
  - Validates manifest/files/dependencies consistency.
  - Docs: `registry_verify_readme.md`
- `registry_shared_manifest.dart`
  - Generates `shared_manifest.json` from `registry/shared`.
  - Docs: `registry_shared_manifest_readme.md`
- `registry_skill_bundle.dart`
  - Creates skill snapshot bundles under `skills/`.
  - Docs: `registry_skill_bundle_readme.md`
- `registry_tool.dart`
  - Interactive helper (`init`, `sync`, `add-impl`).
  - Docs: `registry_tool_readme.md`
- `generate_available_components.dart`
  - Generates available components listing.
  - Docs: `generate_available_components_readme.md`

## Help

Each script supports:

- `-h`
- `--help`
