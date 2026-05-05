# Checkpoint: branch-p2-tier-and-version-governance
Last updated: 2026-05-05 05:18
Status: DONE

## Completed Steps
- [x] Extend the metadata schema with a `tier` field and allowed values `primitive`, `component`, and `pattern`.
- [x] Create `tool/registry/registry_tier_backfill.dart` to pre-populate `tier` across existing `meta.json` files.
- [x] Default the backfill script to `component` for all current entries, then apply an explicit override map for known primitives and patterns.
- [x] Seed the override map with the obvious edge cases first, including `clickable`, `control`, `form_field`, `basic`, `overlay`, `wrapper`, `app`, `scaffold`, and `filter_bar`, then do one human review pass to correct any remaining misclassifications.
- [x] Update `registry_meta_update.dart` and `scripts/new_component.dart` so new components receive `tier` metadata automatically.
- [x] Define the minimum viable versioning/deprecation policy and document where breaking changes must be recorded.

## Current Step
Task complete. Commit, push, merge to `main`, then create `branch-p3-explicit-theme-registration` from the updated `main`.

## Blocked On
Nothing

## Remaining Steps
- [ ] Extend the metadata schema with a `tier` field and allowed values `primitive`, `component`, and `pattern`.
- [ ] Create `tool/registry/registry_tier_backfill.dart` to pre-populate `tier` across existing `meta.json` files.
- [ ] Default the backfill script to `component` for all current entries, then apply an explicit override map for known primitives and patterns.
- [ ] Seed the override map with the obvious edge cases first, including `clickable`, `control`, `form_field`, `basic`, `overlay`, `wrapper`, `app`, `scaffold`, and `filter_bar`, then do one human review pass to correct any remaining misclassifications.
- [ ] Update `registry_meta_update.dart` and `scripts/new_component.dart` so new components receive `tier` metadata automatically.
- [ ] Define the minimum viable versioning/deprecation policy and document where breaking changes must be recorded.

## Verification Results
- Subagent inventory of Task 7 schema/version source-of-truth → ✅ PASS (`components.schema.json` is the explicit manifest schema; `registry_sync_all.dart`, `registry_components_manifest.dart`, and `registry_meta_update.dart` currently define/merge meta.json shape; `new_component.dart` scaffolds `version`; `index.schema.json` and `registry_index_generate.dart` should be updated too if `tier` must flow into docs/discovery output`)
- `dart format flutter_shadcn_kit/tool/registry/registry_sync_all.dart flutter_shadcn_kit/tool/registry/registry_components_manifest.dart flutter_shadcn_kit/tool/registry/registry_meta_update.dart flutter_shadcn_kit/scripts/new_component.dart` → ✅ PASS (`Formatted 4 files; 1 changed`)
- `dart analyze flutter_shadcn_kit/tool/registry/registry_sync_all.dart flutter_shadcn_kit/tool/registry/registry_components_manifest.dart flutter_shadcn_kit/tool/registry/registry_meta_update.dart flutter_shadcn_kit/scripts/new_component.dart` → ✅ PASS (`No issues found!`)
- schema/tier wiring spot-check script → ✅ PASS (`components.schema.json` contains tier enum with exact allowed values; touched Dart files contain tier wiring`)
- `dart flutter_shadcn_kit/tool/registry/registry_tier_backfill.dart --help` → ✅ PASS (`Usage printed successfully`)
- `dart flutter_shadcn_kit/tool/registry/registry_tier_backfill.dart --check --components clickable,control,form_field,basic,overlay,wrapper,app,scaffold,filter_bar` → ✅ PASS (`Pending changes matched the seeded primitive/pattern overrides`)
- `dart flutter_shadcn_kit/tool/registry/registry_tier_backfill.dart --check` → ✅ PASS (`133 pending change(s) before write`)
- `dart flutter_shadcn_kit/tool/registry/registry_tier_backfill.dart` → ✅ PASS (`Processed 133 component metadata file(s); updated 133 file(s).`)
- `dart flutter_shadcn_kit/tool/registry/registry_tier_backfill.dart --check` → ✅ PASS (`0 pending change(s) after write`)
- `cd flutter_shadcn_kit && dart run tool/registry/registry_tier_backfill.dart` → ✅ PASS (`Processed 133 component metadata file(s); updated 0 file(s).`)
- `cd flutter_shadcn_kit && dart run tool/registry/registry_meta_update.dart` → ✅ PASS (`Meta generation complete; Meta files updated: 0.`)
- `cd flutter_shadcn_kit && dart run tool/registry/registry_verify.dart --ci` → ❌ FAIL (`Registry verification summary: Total entries 133; Status: FAILED; Docs snapshot mismatch (1): docs/assets/registry/components.json`)
- `cd flutter_shadcn_kit && flutter analyze` → ✅ PASS (`No issues found!`)
- `cd flutter_shadcn_kit && dart run tool/registry/registry_sync_all.dart --force` → ✅ PASS (`Docs registry mirror synced; updated docs/assets/registry/components.json; Components: 133; Manifest version: 1; Meta files updated: 0.`)
- `cd flutter_shadcn_kit && dart run tool/registry/registry_verify.dart --ci` → ✅ PASS (`Registry verification summary: Total entries 133; Status: OK`)
- `docs/superpowers/policies/component-versioning-and-deprecation.md` → ✅ PASS (`Task 7 policy doc added with version rules, deprecation rules, and required breaking-change recording surfaces`)
- `cd docs && flutter analyze` → ❌ FAIL (`lib/shadcn_ui.dart` still hides `formatFileSize`, `NextItemIntent`, `PreviousItemIntent`, and `FutureVoidCallback` after the mirror refresh removed those public exports`)
- spec review (`Banach`) → ❌ FAIL (`version` was required but malformed values still passed; Task 7 not merge-ready until version validation is fail-fast`)
- code quality review (`Herschel`) → ❌ FAIL (`verify did not detect manifest/docs mirror drift for tier/version; legacy registry scaffolding still omitted tier/version; tier backfill would overwrite future manual classifications`)
- `cd docs && flutter analyze` → ✅ PASS (`No issues found!` after removing stale `hide` clauses from docs/lib/shadcn_ui.dart)
- invalid-version negative repro (`button` meta temporarily set to `foo`, then `cd flutter_shadcn_kit && dart run tool/registry/registry_meta_update.dart --components button`) → ✅ PASS (`Exited 2 with "has invalid version" and the original meta.json was restored`)
- `dart format flutter_shadcn_kit/tool/registry/registry_verify.dart flutter_shadcn_kit/tool/registry/registry_tool.dart flutter_shadcn_kit/tool/registry/registry_tier_backfill.dart flutter_shadcn_kit/tool/registry/registry_components_manifest.dart flutter_shadcn_kit/tool/registry/registry_meta_update.dart flutter_shadcn_kit/tool/registry/registry_sync_all.dart docs/lib/shadcn_ui.dart` → ✅ PASS (`Formatted files successfully after post-review fixes`)
- `cd flutter_shadcn_kit && dart run tool/registry/registry_sync_all.dart --force` → ✅ PASS (`Docs registry mirror synced; updated components.json/docs mirror; Meta files updated: 0.`)
- `cd flutter_shadcn_kit && dart run tool/registry/registry_verify.dart --ci` → ✅ PASS (`Registry verification summary: Total entries 133; Status: OK`)
- `cd flutter_shadcn_kit && flutter analyze` → ✅ PASS (`No issues found!`)
- `cd flutter_shadcn_kit && dart run tool/registry/registry_tier_backfill.dart --check` → ✅ PASS (`Checked 133 component metadata file(s); 0 pending change(s).`)
- manifest-drift negative repro (`clickable` tier/version changed only in manifest + docs asset snapshot, then `cd flutter_shadcn_kit && dart run tool/registry/registry_verify.dart --ci`) → ✅ PASS (`Exited 2 with "Manifest tier/version mismatches (1): clickable"`)
- docs-mirror negative repro (`docs/lib/ui/shadcn/components/control/clickable/meta.json` version changed to `9.9.9`, then `cd flutter_shadcn_kit && dart run tool/registry/registry_verify.dart --ci`) → ✅ PASS (`Exited 2 with "Docs mirror meta mismatch (1): clickable"`)
- `cd docs && flutter analyze` → ✅ PASS (`No issues found!`)
- `cd flutter_shadcn_kit && dart run tool/registry/registry_verify.dart --ci` → ✅ PASS (`Registry verification summary: Total entries 133; Status: OK` after negative repro cleanup)
- `cd docs && flutter build web` → ✅ PASS (`Built build/web`; wasm dry-run warnings from `file_picker`/`dart:ffi` only, build still succeeded)
- `graphify update .` → ✅ PASS (`GRAPH_REPORT.md and graph.json refreshed`)
- `cd flutter_shadcn_kit && dart run tool/registry/registry_components_manifest.dart --components clickable --force` → ✅ PASS (`Components generation complete; Components updated: 1; docs mirror now refreshed as part of the command`)
- `cd flutter_shadcn_kit && dart run tool/registry/registry_meta_update.dart --components clickable` → ✅ PASS (`Meta generation complete; Meta files updated: 0; docs mirror remains verifier-clean`)
- `cd flutter_shadcn_kit && dart run tool/registry/registry_tool.dart sync` → ✅ PASS (`Sync complete.` after guarding missing composites dir and refreshing docs outputs)
- `cd flutter_shadcn_kit && dart run tool/registry/registry_tier_backfill.dart --check --components button,typo` → ✅ PASS (`Exited 2 with "Unknown component ids: [typo]."`)
- `cd flutter_shadcn_kit && dart run tool/registry/registry_verify.dart --ci` → ✅ PASS (`Registry verification summary: Total entries 133; Status: OK` after standalone command follow-up fixes)
- `cd flutter_shadcn_kit && flutter analyze` → ✅ PASS (`No issues found!` after legacy sync/docs-output fixes)
- `cd docs && flutter analyze` → ✅ PASS (`No issues found!` after final sync-path fixes)
- `cd docs && flutter build web` → ✅ PASS (`Built build/web`; wasm dry-run warnings only)
- `graphify update .` → ✅ PASS (`GRAPH_REPORT.md and graph.json refreshed after the last tooling changes`)
- final spec re-review (`Erdos`) → ✅ PASS (`No findings; merge-ready`)
- final code-quality re-review (`Huygens`) → ✅ PASS (`No findings; merge-ready`)

## Files Modified
- `docs/superpowers/checkpoints/MASTER_STATUS.md`
- `docs/superpowers/checkpoints/branch-p2-tier-and-version-governance.md`
- `flutter_shadcn_kit/lib/registry/manifests/components.schema.json`
- `flutter_shadcn_kit/scripts/new_component.dart`
- `flutter_shadcn_kit/tool/registry/registry_components_manifest.dart`
- `flutter_shadcn_kit/tool/registry/registry_meta_update.dart`
- `flutter_shadcn_kit/tool/registry/registry_sync_all.dart`
- `flutter_shadcn_kit/tool/registry/registry_tier_backfill.dart`
- `flutter_shadcn_kit/lib/registry/components/**/meta.json`
- `docs/superpowers/policies/component-versioning-and-deprecation.md`

## Decisions Made
- Task 7 step 1 will start with the minimal schema/source-of-truth set identified by inventory: `components.schema.json`, `registry_sync_all.dart`, `registry_components_manifest.dart`, `registry_meta_update.dart`, and `new_component.dart`, with `index.schema.json` / `registry_index_generate.dart` added if `tier` is propagated into generated index metadata.
- Step 1 intentionally did not propagate `tier` into `index.schema.json` or `registry_index_generate.dart`; that discovery/docs surface can be handled later if Task 7 requires it after backfill lands.
- The tier backfill is deterministic and idempotent, defaults every component to `component`, and applies an explicit reviewed override map instead of heuristics.
- Step 5 is already satisfied by the step-1 changes in `registry_meta_update.dart` and `new_component.dart`; no separate implementation pass is needed there.
- Breaking-change recording is now explicitly defined to use metadata/manifests plus `docs/superpowers/release-notes/` until a repo-wide changelog exists.
- The forced docs mirror sync surfaced stale `hide` clauses in `docs/lib/shadcn_ui.dart`; Task 7 now includes the minimal docs-barrel cleanup required to keep the mirror buildable after sync.
- Post-review follow-up is required before merge: invalid SemVer must be rejected, verifier coverage must expand to canonical/docs metadata parity, legacy scaffolding must emit tier/version, and the backfill script must stop overwriting valid existing tiers by default.
- Post-review fixes landed locally: SemVer is now validated, verifier checks manifest/docs metadata parity, legacy `registry_tool.dart` emits `tier`/`version`, and tier backfill preserves valid existing classifications unless `--force`/`--normalize` is used.
- Final follow-up fixes landed locally: standalone `registry_components_manifest.dart`, `registry_meta_update.dart`, and `registry_tool.dart sync` now keep docs outputs verifier-clean; verifier also flags orphaned docs-mirror `meta.json` files; targeted backfill invocations now reject unknown ids.
- SESSION END — Next session should resume from: `branch-p3-explicit-theme-registration` step 1 after Task 7 is committed, pushed, and merged.
