# Checkpoint: branch-p0-token-pipeline-pilot-fixup
Last updated: 2026-05-05 02:48
Status: IN_PROGRESS

## Completed Steps
- [x] Confirm the post-merge Task 3 failures locally and isolate the exact docs-mirror and test-validity gaps before changing code.
- [x] Fix the docs mirror or sync path so the docs app consumes the token-backed button config from the canonical registry source.
- [x] Replace the invalid button guard test with coverage that proves the intended resolution path and keep the test committed.
- [x] Re-run package verification, registry/docs sync, docs build, and docs route validation against the fixed mirror.

## Current Step
Commit, push, merge to `main`, then restart `branch-p1-theme-config-map-rollout` from the updated `main`.

## Blocked On
Nothing

## Remaining Steps
- [ ] Confirm the post-merge Task 3 failures locally and isolate the exact docs-mirror and test-validity gaps before changing code.
- [ ] Fix the docs mirror or sync path so the docs app consumes the token-backed button config from the canonical registry source.
- [ ] Replace the invalid button guard test with coverage that proves the intended resolution path and keep the test committed.
- [ ] Re-run package verification, registry/docs sync, docs build, and docs route validation against the fixed mirror.
- [ ] Commit, push, merge to `main`, then restart `branch-p1-theme-config-map-rollout` from the updated `main`.

## Verification Results
- `rg -n "static (const|final) .*ButtonTheme.*=.*null|resolved.*ButtonTheme" flutter_shadcn_kit/lib/registry/components/control/button/_impl/themes/config/button_theme_config.dart docs/lib/ui/shadcn/components/control/button/_impl/themes/config/button_theme_config.dart` → ✅ PASS (`Canonical package config uses resolved button themes; docs mirror still exposes `null` button globals`)
- `sed -n '1,240p' flutter_shadcn_kit/test/registry/components/control/button/component_theme_button_style_test.dart` → ✅ PASS (`Current test pumps ShadcnApp and only asserts token-backed padding, without isolating the explicit resolve-path contract`)
- `sed -n '1,140p' flutter_shadcn_kit/lib/registry/components/control/button/_impl/styles/component_theme_button_style.dart` → ✅ PASS (`Style resolution reads `findGlobal()` via `ButtonThemeConfig.resolve<T>()` and then widget-tree `find(context)``)
- `sed -n '1,140p' flutter_shadcn_kit/lib/registry/shared/theme/_impl/themes/component_theme.dart` → ✅ PASS (`ComponentTheme.maybeOf<T>() falls back to ComponentThemeGlobalRegistry.maybeOf<T>() when no inherited theme exists`)
- `sed -n '210,260p' flutter_shadcn_kit/lib/registry/components/layout/app/app.dart` → ✅ PASS (`ShadcnApp` eagerly calls `registerComponentThemeGlobalConfigs()` during build)
- `rg -n "docs/lib/ui/shadcn|docs mirror|registry_sync_all|copy.*docs|shadcn" flutter_shadcn_kit/tool/registry flutter_shadcn_kit/tool/theme -g '*.dart' -g '*.md'` → ✅ PASS (`Repo docs describe docs/lib/ui/shadcn as generated, but the drift requires a concrete sync-path fix`)
- `sed -n '1,260p' flutter_shadcn_kit/tool/registry/registry_sync_all.dart` → ✅ PASS (`Current sync script header and visible implementation focus on manifest/meta refresh; no obvious docs-mirror refresh path is present in the inspected section`)
- `sed -n '1,260p' docs/scripts/sync_registry.py` → ✅ PASS (`Docs mirror is refreshed by rsync from canonical registry plus manifest copy`)
- `dart analyze tool/registry/registry_sync_all.dart` → ✅ PASS (`No issues found!`)
- `cd flutter_shadcn_kit && dart run tool/registry/registry_sync_all.dart --force` → ✅ PASS (`Docs registry mirror synced: .../docs`; `Updated components.json`; `Components: 133`; `Manifest version: 1`; `Meta files updated: 0`)
- `rg -n "static (const|final) .*ButtonTheme.*=.*null|resolved.*ButtonTheme" flutter_shadcn_kit/lib/registry/components/control/button/_impl/themes/config/button_theme_config.dart docs/lib/ui/shadcn/components/control/button/_impl/themes/config/button_theme_config.dart` → ✅ PASS (`Docs mirror button config now matches canonical resolved theme fields`)
- `cd flutter_shadcn_kit && dart analyze test/registry/components/control/button/component_theme_button_style_test.dart` → ✅ PASS (`No issues found!`)
- `cd flutter_shadcn_kit && flutter test test/registry/components/control/button/component_theme_button_style_test.dart` → ✅ PASS (`00:00 +1: All tests passed!`)
- `cd flutter_shadcn_kit && flutter analyze` → ✅ PASS (`No issues found!`)
- `cd flutter_shadcn_kit && flutter test` → ✅ PASS (`00:00 +2: All tests passed!`)
- `cd flutter_shadcn_kit && dart run tool/registry/registry_verify.dart --ci` → ✅ PASS (`Registry verification summary: Total entries: 133; Status: OK`)
- `cd docs && flutter analyze && flutter build web` → ✅ PASS (`No issues found!`; `Built build/web`; same non-blocking Wasm dry-run warnings as before)
- `Playwright built-docs validation: http://127.0.0.1:7357/#/components/button and http://127.0.0.1:7357/#/components/dropdown-menu` → ✅ PASS (`Both built routes rendered cleanly after mirror refresh`)
- `graphify update .` → ✅ PASS (`graph.json` and `GRAPH_REPORT.md` updated in graphify-out`)

## Files Modified
- `docs/superpowers/plans/2026-05-04-registry-scalability-remediation.md`
- `docs/superpowers/checkpoints/MASTER_STATUS.md`
- `docs/superpowers/checkpoints/branch-p0-token-pipeline-pilot-fixup.md`
- `flutter_shadcn_kit/tool/registry/registry_sync_all.dart`
- `flutter_shadcn_kit/test/registry/components/control/button/component_theme_button_style_test.dart`
- `docs/lib/ui/shadcn/**` (mirror refresh)

## Decisions Made
- Paused Task 4 after post-merge review found Task 3 verification gaps on `main`.
- Added an explicit plan rule that every completed branch must be committed, pushed, and merged to `main` before the next branch starts.
- Confirmed two real Task 3 fix-up targets before touching code: refresh the docs mirror from canonical package sources, and replace the current test with one that cannot pass via global-registry fallback alone.
- Fixed the docs-mirror drift at the source by making `registry_sync_all.dart` invoke `docs/scripts/sync_registry.py` when the repo-level docs app is present, instead of relying on a separate manual docs-install workflow.
- Rewrote the button guard test to assert `ComponentThemeButtonStyle.findGlobal()` directly, which forces the `ButtonThemeConfig.resolve<T>()` seam instead of inheriting success from `ComponentThemeGlobalRegistry` fallback.
- Accepted the broader `docs/lib/ui/shadcn/**` refresh because the docs vendored mirror was stale beyond the button files; the built docs app and route validation are the correctness gate for that mirrored output.
