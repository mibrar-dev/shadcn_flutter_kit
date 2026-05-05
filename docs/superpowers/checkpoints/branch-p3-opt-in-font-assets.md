# Checkpoint: branch-p3-opt-in-font-assets
Last updated: 2026-05-06 00:35
Status: IN_PROGRESS

## Completed Steps
- [x] Inventory current bundled fonts and icon assets in `flutter_shadcn_kit/pubspec.yaml`.
- [x] Model icon/font asset groups explicitly in manifest/shared metadata.
- [x] Update CLI install logic so components pull only the asset groups they actually need.
- [x] Add verification around generated consumer `pubspec.yaml` changes if the CLI mutates assets automatically.
- [x] Document any installation contract changes for consumers.

## Current Step
Commit, push, and merge `branch-p3-opt-in-font-assets` to `main`.

## Blocked On
Nothing

## Remaining Steps
- [ ] Commit, push, and merge `branch-p3-opt-in-font-assets` to `main`.

## Verification Results
- `sed -n '1,260p' flutter_shadcn_kit/pubspec.yaml` → ✅ PASS (`package-level pubspec declares 6 font families and 38 font files under flutter.fonts, plus markdown assets`)
- `sed -n '660,980p' flutter_shadcn_kit/lib/registry/manifests/components.json` → ✅ PASS (`shared manifest already carries copied font files inside a malformed catch-all shared entry with id "README"`)
- `rg -n "assets:|fonts:|shared.*id|sharedGroups|pubspec" flutter_shadcn_kit/lib/registry/manifests flutter_shadcn_kit/tool -g '*.json' -g '*.dart'` → ✅ PASS (`schema already supports component-level assets/fonts; registry tooling currently models assets/shared/pubspec but no explicit font asset groups`)
- explorer trace (`components.schema.json`, `components.json`, `shared/shared_manifest.json`, `registry_shared_manifest.dart`, `registry_components_manifest.dart`, `flutter_cli_verification_example/pubspec.yaml`) → ✅ PASS (`opt-in fonts should attach through shared ids + component shared deps; schema supports fonts but manifest builder does not emit them today`)
- `cp flutter_shadcn_kit/assets/fonts/NotoSansSymbols2-Regular.ttf flutter_shadcn_kit/lib/registry/shared/fonts/NotoSansSymbols2-Regular.ttf` → ✅ PASS (`missing shared Noto symbol font added to registry copy tree`)
- `cd flutter_shadcn_kit && dart run tool/registry/registry_sync_all.dart --force` → ✅ PASS (`components.json regenerated and docs registry mirror synced`)
- `cd flutter_shadcn_kit && dart run tool/registry/registry_shared_manifest.dart --force` → ✅ PASS (`shared_manifest.json regenerated with 61 groups`)
- `rg -n '"id": "README"|"id": "bootstrap_icons"|"id": "lucide_icons"|"id": "radix_icons"|NotoSansSymbols2-Regular.ttf' flutter_shadcn_kit/lib/registry/manifests/components.json flutter_shadcn_kit/lib/registry/shared/shared_manifest.json` → ✅ PASS (`components.json now maps typography fonts into theme and icon binaries into explicit icon shared ids; shared_manifest reflects bootstrap/lucide/radix/theme grouping`)
- `find flutter_shadcn_kit/flutter_cli_verification_example/assets/fonts -type f | sort` → ✅ PASS (`fixture asset tree trimmed to typography + lucide; radix/bootstrap removed; Noto symbol font added`)
- `cd flutter_shadcn_kit/flutter_cli_verification_example && flutter analyze` → ✅ PASS (`No issues found! after selective font-set update`)
- `cd flutter_shadcn_kit/flutter_cli_verification_example && flutter build web` → ✅ PASS (`Built build/web; prior Lucide font-family warning is gone`)
- `cd flutter_shadcn_kit && flutter pub get` → ✅ PASS (`yaml` dev dependency resolved and `pubspec.lock` refreshed`)
- `cd flutter_shadcn_kit && flutter test test/registry/consumer_fixture_font_pubspec_alignment_test.dart` → ❌ FAIL (`expected fixture pubspec only predicted Lucide + Noto; Geist families were missed because canonical pubspec paths are flat while fixture installs under assets/fonts/geist/`)
- patched `test/registry/consumer_fixture_font_pubspec_alignment_test.dart` to match canonical font descriptors by basename and rewrite assets to manifest-derived fixture paths → ✅ PASS (`Geist family metadata now survives the path remap`)
- `cd flutter_shadcn_kit && flutter test test/registry/consumer_fixture_font_pubspec_alignment_test.dart` → ✅ PASS (`manifest-driven shared font groups now match the fixture pubspec and copied font asset tree exactly`)
- updated `flutter_shadcn_kit/README.md`, `flutter_cli_verification_example/README.md`, and `docs/superpowers/release-notes/branch-p3-opt-in-font-assets.md` → ✅ PASS (`consumer-facing contract now documents selective shared font groups and the required use of flutter.fonts`)
- `cd flutter_shadcn_kit && dart run tool/registry/registry_verify.dart --ci` → ✅ PASS (`registry verification summary: Total entries 133, Status OK`)
- `cd flutter_shadcn_kit && flutter test` → ✅ PASS (`8 tests passed, including the new consumer fixture font alignment regression`)
- `cd flutter_shadcn_kit && flutter analyze` → ❌ FAIL (`unused_local_variable warnings for normalizedFiles in registry_components_manifest.dart and registry_sync_all.dart`)
- removed dead `normalizedFiles` locals from both manifest tooling files → ✅ PASS (`branch returns to analyzer-clean state`)
- `cd flutter_shadcn_kit && flutter analyze` → ✅ PASS (`No issues found!`)
- `cd docs && flutter analyze` → ✅ PASS (`No issues found!`)
- `cd docs && flutter build web` → ✅ PASS (`Built build/web; wasm dry-run emitted existing file_picker/win32 ffi warnings only`)
- `cd flutter_shadcn_kit/flutter_cli_verification_example && flutter analyze` → ✅ PASS (`No issues found!`)
- `cd flutter_shadcn_kit/flutter_cli_verification_example && flutter build web` → ✅ PASS (`Built build/web; wasm dry-run emitted existing file_picker/win32 ffi warnings only`)
- `graphify update .` → ✅ PASS (`GRAPH_REPORT.md and graph.json refreshed`)
- Task 9 spec review subagent → ✅ PASS (`APPROVED`)
- Task 9 code quality review subagent → ✅ PASS (`APPROVED`)

## Files Modified
- `docs/superpowers/checkpoints/branch-p3-opt-in-font-assets.md`
- `docs/superpowers/checkpoints/MASTER_STATUS.md`
- `flutter_shadcn_kit/lib/registry/shared/fonts/NotoSansSymbols2-Regular.ttf`
- `flutter_shadcn_kit/tool/registry/registry_components_manifest.dart`
- `flutter_shadcn_kit/tool/registry/registry_sync_all.dart`
- `flutter_shadcn_kit/lib/registry/manifests/components.json`
- `docs/assets/registry/components.json`
- `docs/lib/ui/shadcn/manifests/components.json`
- `flutter_shadcn_kit/lib/registry/shared/shared_manifest.json`
- `flutter_shadcn_kit/flutter_cli_verification_example/assets/fonts/NotoSansSymbols2-Regular.ttf`
- `flutter_shadcn_kit/flutter_cli_verification_example/pubspec.yaml`
- `flutter_shadcn_kit/pubspec.lock`
- `flutter_shadcn_kit/pubspec.yaml`
- `flutter_shadcn_kit/test/registry/consumer_fixture_font_pubspec_alignment_test.dart`
- `flutter_shadcn_kit/README.md`
- `flutter_shadcn_kit/flutter_cli_verification_example/README.md`
- `docs/superpowers/release-notes/branch-p3-opt-in-font-assets.md`

## Decisions Made
- Task 9 starts from `main` after `branch-p3-explicit-theme-registration` merged.
- Current bundled asset inventory is 6 declared font families / 38 font files: `LucideIcons`, `RadixIcons`, `BootstrapIcons`, `NotoSansSymbols2`, `GeistSans`, and `GeistMono`.
- No font family in `pubspec.yaml` is component-scoped today; all are package-global.
- The current manifest already copies font files through `shared`, but the grouping is structurally wrong: all font files sit under a catch-all shared entry with id `README` instead of explicit opt-in asset groups.
- Task 9 should extend the existing `shared[]` / `dependencies.shared[]` contract for opt-in asset groups instead of adding a parallel asset-specific dependency system.
- `components.schema.json` already allows component-level `fonts`, but the live manifest builder path does not currently read or emit that field, so Step 2 should start with shared-group modeling first.
- Typography font binaries now ride with the existing `theme` shared id because shared `typography.dart` hard-references `GeistSans`, `GeistMono`, and `NotoSansSymbols2`.
- Icon font binaries now belong to explicit shared ids aligned with existing wrapper code: `lucide_icons`, `radix_icons`, and `bootstrap_icons`.
- Because the external `flutter_shadcn_cli` implementation is not present in this workspace, the strongest in-repo install seam is the consumer verification fixture. Step 3 is represented locally by bringing that fixture into alignment with the new shared-group contract.
- The consumer contract must register fonts via `flutter.fonts`, not raw `flutter.assets`, because installed code references concrete font families such as `LucideIcons`, `GeistSans`, `GeistMono`, and `NotoSansSymbols2`.
- The fixture verification test should derive its expected font list from manifest-selected shared assets, but it cannot compare canonical and fixture asset paths literally because the package pubspec keeps Geist assets flat while installed consumers place them under `assets/fonts/geist/`; basename-based remapping is the stable comparison seam.
- Consumer-facing selective-font guidance belongs in the package README, with the fixture README and a branch release note reinforcing the install-output contract for maintainers.
