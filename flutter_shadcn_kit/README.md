# flutter_shadcn_kit

Registry-driven Flutter component kit. This package powers the registry that the CLI
installs from and the docs that describe each component.

## Getting Started
1. Understand the registry layout:
   `lib/registry` is the source of truth for components and shared helpers.
2. Pick a theme-global registration mode for apps that use component theme configs:
   - Full preload: use `ShadcnApp` with the default `preloadComponentThemeGlobals: true`, which calls `registerComponentThemeGlobalConfigs()` for you.
   - Selective preload: import `registry/components/component_theme_global_configs.dart`, call only the helpers for the components you use, and set `preloadComponentThemeGlobals: false` on `ShadcnApp`.
3. Generate or update manifests:
   `dart run tool/registry/registry_sync_all.dart`
4. Validate outputs:
   `dart run tool/registry/registry_verify.dart`

For step-by-step instructions, see `tool/docs/getting-started.md`.

Selective preload example:

```dart
import 'package:flutter/widgets.dart';
import 'package:flutter_shadcn_kit/flutter_shadcn_kit.dart';
import 'package:flutter_shadcn_kit/registry/components/component_theme_global_configs.dart';

void main() {
  registerButtonThemeGlobals();
  registerTextFieldThemeGlobals();
  registerDialogThemeGlobals();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const ShadcnApp(
      preloadComponentThemeGlobals: false,
      home: SizedBox.shrink(),
    );
  }
}
```

## Registry Structure
The registry lives in `lib/registry`:
- `components/` holds component folders organized by category.
- `shared/` holds shared utilities, tokens, and theme helpers.
- `components.json` is the install manifest the CLI uses.
- `components.schema.json` is the schema for the manifest.
- `index.json` is a lightweight index used by docs and tooling.
- `shared/shared_manifest.json` lists shared file groups.

## Component Folder Structure
Each component folder is:
`lib/registry/components/<category>/<component_id>`

Typical contents:
- `README.md` component overview.
- `GETTING_STARTED.md` simple guide for the folder layout.
- `meta.json` component metadata (dependencies, tags, version, assets).
- `<component_id>.dart` main widget entry.
- `preview.dart` gallery preview entry.
- `_impl/` internal implementation helpers.

`_impl/` taxonomy folders:
- `core/` main building blocks.
- `extensions/` extension methods.
- `state/` controllers and state logic.
- `styles/` style classes and helpers.
- `themes/` theme data and helpers.
- `utils/` small utilities.
- `variants/` variant widgets and styles.

## Scripts
### Registry Tooling
Located in `tool/`. These scripts are the canonical source of truth for registry
manifests and metadata.

Common commands:
- `dart run tool/registry/registry_sync_all.dart` updates meta.json files, components.json,
  shared manifests, and index output.
- `dart run tool/registry/registry_components_manifest.dart` rebuilds `components.json`.
- `dart run tool/registry/registry_shared_manifest.dart` rebuilds `shared_manifest.json`.
- `dart run tool/registry/registry_meta_update.dart` refreshes `meta.json` files.
- `dart run tool/registry/registry_index_generate.dart` rebuilds `index.json`.
- `dart run tool/registry/registry_verify.dart` checks for missing entries and mismatches.

Docs for each tool live in `tool/docs/`:
- `tool/docs/registry_components_manifest.md`
- `tool/docs/registry_shared_manifest.md`
- `tool/docs/registry_meta_update.md`
- `tool/docs/registry_index_generate.md`
- `tool/docs/registry_verify.md`
- `tool/docs/registry_sync_all.md`
- `tool/docs/registry_tool.md`
- `tool/docs/registry_readme_meta.md`
- `tool/docs/registry_skill_bundle.md`

### Component Scaffolding
Located in `scripts/`.

Create a new component scaffold:
```bash
dart run scripts/new_component.dart button --category control --description "Shadcn-style button."
```

This will:
- Create the component folder and `_impl` taxonomy directories.
- Write `README.md`, `GETTING_STARTED.md`, `meta.json`, and stub Dart files.
- Update `components.json` and the docs snapshot.

## Notes
- Do not edit `components.json` by hand. Use the tooling in `tool/`.
- Keep `meta.json` as the single source of component dependencies and version.
- Run `dart run tool/registry/registry_sync_all.dart` after large changes.
