# Checkpoint: branch-p3-explicit-theme-registration
Last updated: 2026-05-05 05:48
Status: IN_PROGRESS

## Completed Steps
- [x] Introduce explicit per-component registration helpers such as `registerButtonThemeGlobals()`.
- [x] Keep `registerComponentThemeGlobalConfigs()` as a compatibility bootstrap function that simply calls all per-component registrars.
- [x] Ensure registration remains idempotent so repeated setup calls are safe.
- [x] Migrate the explicit pilot set first: `button`, `text_field`, and `dialog`, then expand once the explicit pattern is stable.
- [x] Update docs and examples so consumers know they can register only the components they use or call the compatibility bootstrap for full preload.

## Current Step
Commit, push, and merge `branch-p3-explicit-theme-registration` into `main`, then start `branch-p3-opt-in-font-assets` from updated `main`.

## Blocked On
Nothing

## Remaining Steps
(none)

## Verification Results
- seam discovery (`component_theme_global_configs.dart`, `button_theme_config.dart`, `text_field_theme_config.dart`, `dialog_theme_config.dart`, and `layout/app/app.dart`) → ✅ PASS (`explicit registrar seam is the generated bootstrap file plus the pilot component config files; current runtime bootstrap call remains in ShadcnApp.build()`)
- `dart run tool/theme/component_theme_global_configs_generate.dart` → ✅ PASS (`Generated component_theme_global_configs.dart; Configs: 68; Registrations: 86`)
- `dart analyze lib/registry/components/component_theme_global_configs.dart tool/theme/component_theme_global_configs_generate.dart lib/registry/components/layout/app/app.dart` → ✅ PASS (`No issues found!`)
- `dart analyze lib/registry/shared/theme/component_theme_global_registry.dart lib/registry/components/component_theme_global_configs.dart test/registry/components/component_theme_global_configs_registration_test.dart` → ✅ PASS (`No issues found!`)
- `flutter test test/registry/components/component_theme_global_configs_registration_test.dart` → ✅ PASS (`4 tests passed`)
- `cd flutter_shadcn_kit && flutter test` → ✅ PASS (`6 tests passed`)
- `cd flutter_shadcn_kit && flutter analyze` → ✅ PASS (`No issues found!`)
- `cd docs && flutter analyze` → ✅ PASS (`No issues found!`)
- `cd docs && flutter build web` → ✅ PASS (`Built build/web`; wasm dry-run warnings from transitive FFI packages only)
- `graphify update .` → ✅ PASS (`graph.json and GRAPH_REPORT.md updated`)
- `cd flutter_shadcn_kit && dart run tool/registry/registry_sync_all.dart --force` → ✅ PASS (`Docs registry mirror synced; components.json updated; Components: 133`)
- `cd flutter_shadcn_kit && flutter test` → ✅ PASS (`7 tests passed after review fixes`)
- `cd flutter_shadcn_kit && flutter analyze` → ✅ PASS (`No issues found! after review fixes`)
- `cd flutter_shadcn_kit/flutter_cli_verification_example && flutter analyze` → ✅ PASS (`No issues found!`)
- `cd flutter_shadcn_kit/flutter_cli_verification_example && flutter build web` → ✅ PASS (`Built build/web`; wasm dry run succeeded`)
- `cd docs && flutter analyze` → ✅ PASS (`No issues found! after mirror sync`)
- `cd docs && flutter build web` → ✅ PASS (`Built build/web`; wasm dry-run warnings from transitive FFI packages only after mirror sync`)
- `graphify update .` → ✅ PASS (`graph.json and GRAPH_REPORT.md updated after review fixes`)

## Files Modified
- `docs/superpowers/checkpoints/MASTER_STATUS.md`
- `docs/superpowers/checkpoints/branch-p3-explicit-theme-registration.md`
- `flutter_shadcn_kit/tool/theme/component_theme_global_configs_generate.dart`
- `flutter_shadcn_kit/lib/registry/components/component_theme_global_configs.dart`
- `flutter_shadcn_kit/lib/registry/shared/theme/component_theme_global_registry.dart`
- `flutter_shadcn_kit/test/registry/components/component_theme_global_configs_registration_test.dart`
- `flutter_shadcn_kit/lib/registry/components/layout/app/app.dart`
- `flutter_shadcn_kit/README.md`
- `docs/lib/pages/docs/app_setup_page.dart`
- `flutter_shadcn_kit/test/shadcn_app_theme_registration_test.dart`
- `flutter_shadcn_kit/test/registry/components/component_theme_global_configs_bootstrap_test.dart`
- `docs/lib/ui/shadcn/components/component_theme_global_configs.dart`
- `docs/lib/ui/shadcn/components/layout/app/app.dart`
- `docs/lib/ui/shadcn/shared/theme/component_theme_global_registry.dart`
- `flutter_shadcn_kit/lib/registry/manifests/components.json`
- `docs/lib/ui/shadcn/manifests/components.json`
- `docs/assets/registry/components.json`

## Decisions Made
- Task 8 starts from merged `main` after Task 7 completed and landed.
- Steps 1-3 are implemented at the generator seam so helper functions stay derived from canonical theme config files instead of being hand-maintained.
- Pilot registrar coverage uses `hasResolver<T>()` for `TextFieldTheme` and `ModalBackdropTheme` because those helpers currently register nullable theme values.
- Consumer-facing guidance for Task 8 lands in the package README and the docs app setup page so both package users and copy-paste/docs users see the explicit-vs-bootstrap registration paths.
- Task 8 review fixes add an explicit `ShadcnApp` opt-out for the compatibility bootstrap so selective registration is a real runtime path instead of docs-only guidance.
- Aggregate bootstrap coverage moved into its own fresh test file so `registerComponentThemeGlobalConfigs()` is validated independently of earlier pilot-helper test state.
