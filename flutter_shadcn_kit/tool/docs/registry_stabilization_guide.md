# Registry Stabilization Guide

This document summarizes what was stabilized in the registry/theme architecture
and how to use the current system safely.

## What Was Done

### 1. Registry verification is now a merge gate

- `tool/registry/registry_verify.dart` supports CI mode with `--ci`
- `.github/workflows/registry-verify.yml` blocks drift before merge
- the consumer harness and docs app are part of the verification story

Use:

```bash
dart run tool/registry/registry_verify.dart --ci
```

### 2. Global theme registration is type-safe

- global theme resolvers now use `Map<Type, Object? Function()>`
- `T.toString()` string-key lookup is gone
- generated registration code is rename-safe and less brittle

You do not need to interact with this directly unless you are editing theme
generation or global registration internals.

### 3. The button token pipeline is wired through

- the button pilot now resolves token-backed theme values through the config
  path instead of leaving the token layer inert
- this establishes the working pattern for future token-backed components

If you are extending component theme tokens, follow the button pattern first.

### 4. Theme config variant lookup no longer uses `if (T == ...)` chains

- canonical `*_theme_config.dart` files now resolve variants through type maps
- adding a new variant no longer requires extending a manual open-coded chain

### 5. The root package barrel is generated

- `flutter_shadcn_kit.dart` is no longer hand-maintained
- generator output is part of the registry sync flow
- manual export drift is no longer part of adding components

Do not hand-edit generated root-barrel output.

### 6. Component barrel leakage was reduced

- several component barrels stopped leaking internal helper symbols
- top-level `hide` pressure is lower
- consumer-visible export changes were documented in branch release notes where
  needed

### 7. Tier and version governance was added

- registry metadata now carries stronger `tier` and `version` governance
- verifier coverage catches bad semver and metadata drift earlier

### 8. Theme registration supports selective preload

- `ShadcnApp` still supports compatibility preload by default
- apps can now explicitly register only the components they use
- this is the intended migration path away from full eager global preload

### 9. Shared font assets are opt-in

- typography fonts now ride with the `theme` shared group
- icon fonts now ride with explicit shared groups:
  - `lucide_icons`
  - `radix_icons`
  - `bootstrap_icons`
- consumer installs should only receive the font families required by the
  selected component set

## How To Use It

### Normal maintainer workflow

From `flutter_shadcn_kit/`:

```bash
dart run tool/registry/registry_sync_all.dart --force
dart run tool/registry/registry_verify.dart --ci
flutter analyze
flutter test
```

If docs mirror output changed, also verify:

```bash
cd ../docs
flutter analyze
flutter build web
```

If install behavior changed, also verify:

```bash
cd ../flutter_shadcn_kit/flutter_cli_verification_example
flutter analyze
flutter build web
```

### Selective theme registration in an app

Use full preload if you want compatibility behavior:

```dart
const ShadcnApp(
  preloadComponentThemeGlobals: true,
);
```

Use selective preload if you want to register only what the app uses:

```dart
import 'package:flutter_shadcn_kit/registry/components/component_theme_global_configs.dart';

void main() {
  registerButtonThemeGlobals();
  registerTextFieldThemeGlobals();
  registerDialogThemeGlobals();

  runApp(
    const ShadcnApp(
      preloadComponentThemeGlobals: false,
    ),
  );
}
```

Rule:

- if `preloadComponentThemeGlobals` is `false`, register the needed component
  theme globals before `runApp`

### Consumer font contract

Copy-paste consumers should treat generated `flutter.fonts` entries as part of
the install contract.

Rules:

- generated font families belong under `flutter.fonts`, not raw
  `flutter.assets`
- do not hand-trim installed font families after component installation
- if the installed component set changes, re-run the install/sync flow so the
  generated font families stay aligned with shared dependencies

Current shared-font grouping:

- `theme`:
  - `GeistSans`
  - `GeistMono`
  - `NotoSansSymbols2`
- `lucide_icons`:
  - `LucideIcons`
- `radix_icons`:
  - `RadixIcons`
- `bootstrap_icons`:
  - `BootstrapIcons`

Example:

- a consumer using components that depend on `theme` and `lucide_icons` should
  not receive `RadixIcons` or `BootstrapIcons`

## What Not To Do

- do not hand-edit `lib/registry/manifests/components.json`
- do not hand-edit generated docs mirror files under `docs/lib/ui/shadcn`
- do not add new root exports manually if the barrel generator owns them
- do not add new theme resolver branches with `if (T == ...)`
- do not use raw string keys for global theme registry lookups
- do not treat consumer font declarations as optional decoration; installed code
  depends on concrete font-family names

## Key Files

- `tool/registry/registry_sync_all.dart`
- `tool/registry/registry_verify.dart`
- `lib/registry/manifests/components.json`
- `lib/registry/shared/shared_manifest.json`
- `lib/registry/shared/theme/component_theme_global_registry.dart`
- `lib/registry/components/component_theme_global_configs.dart`
- `flutter_cli_verification_example/`

## Related Docs

- `README.md`
- `tool/docs/getting-started.md`
- `docs/README.md`
- `docs/superpowers/plans/2026-05-04-registry-scalability-remediation.md`
- `docs/superpowers/release-notes/branch-p3-opt-in-font-assets.md`
