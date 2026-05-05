# Checkpoint: branch-p1-component-barrel-cleanup
Last updated: 2026-05-05 04:49
Status: IN_PROGRESS

## Completed Steps
- [x] Inventory all current `hide` clauses in `flutter_shadcn_kit/lib/flutter_shadcn_kit.dart`.
- [x] Move symbol filtering into the owning component barrel where practical.
- [x] Where collisions are caused by poorly named public types, rename or internalize those types instead of endlessly hiding them.
- [x] Re-generate the root barrel once component barrels become self-contained.
- [x] Update the consumer harness if copied imports or symbol names need adjustment.
- [x] Document all consumer-visible renames or export changes in changelog/release notes before merge.

## Current Step
Commit, push, merge to `main`, and create the next branch from updated `main`.

## Blocked On
Nothing

## Remaining Steps
- Commit, push, merge to `main`, and create the next branch from updated `main`.

## Verification Results
- `cd flutter_shadcn_kit && rg -n " hide " lib/flutter_shadcn_kit.dart` → ✅ PASS (`9` root-barrel exports still carry hide clauses at inventory time`)
- Subagent inventory review of `flutter_shadcn_kit/lib/flutter_shadcn_kit.dart` → ✅ PASS (`9` hide-clause cases mapped to owning barrels; cleanest movable candidates are `flex`, `tabs`, and `menu`; deepest internalization candidates are `file_picker`, `radio_group`, and `refresh_trigger`)
- `cd flutter_shadcn_kit && flutter analyze` after the first step-2 tranche → ❌ FAIL (`6` `undefined_hidden_name` warnings remain in `lib/flutter_shadcn_kit.dart` for `flex.dart`; root cause confirmed that `tabs.dart` and `menu.dart` are `part`-based component libraries and cannot be cleaned by removing their `part` declarations)
- Step-3 probe: `file_picker` → ✅ INVESTIGATED (`formatFileSize` is declared in `_impl/utils/file_upload_formatters.dart` and cannot be internalized safely from `file_picker.dart` alone`)
- Step-3 probe: `radio_group` → ✅ INVESTIGATED (`NextItemIntent` and `PreviousItemIntent` are declared in `_impl/utils/*intent.dart` and used from `_radio_card_state.dart` / `_radio_item_state.dart`; single-file ownership is insufficient`)
- Step-3 probe: `refresh_trigger` → ✅ INVESTIGATED (`FutureVoidCallback` is declared in `refresh_trigger.dart` but used in public signatures from `part` files; coordinated same-library edits are required`)
- Step-3 implementation: `file_picker` → ✅ PASS (`formatFileSize` renamed private as `_formatFileSize`; subtree analyze passed`)
- Step-3 implementation: `radio_group` → ✅ PASS (`NextItemIntent` / `PreviousItemIntent` renamed private and usages updated; subtree analyze passed`)
- Step-3 implementation: `refresh_trigger` → ✅ PASS (`FutureVoidCallback` removed from public API and replaced inline where needed; subtree analyze passed`)
- `cd flutter_shadcn_kit && dart run tool/registry/registry_barrel_generate.dart` → ✅ PASS (`Root barrel regenerated after component-library cleanup`)
- `cd flutter_shadcn_kit && rg -n "hide" lib/flutter_shadcn_kit.dart` → ✅ PASS (`Root barrel now carries 5 remaining hide blocks: text_field, scrollable, table, tabs, menu`)
- `cd flutter_shadcn_kit && flutter analyze` → ✅ PASS (`No issues found!`)
- `cd flutter_shadcn_kit/flutter_cli_verification_example && flutter analyze && flutter build web` → ✅ PASS (`No issues found!`; web build succeeded without consumer harness code changes)
- `docs/superpowers/release-notes/branch-p1-component-barrel-cleanup.md` → ✅ PASS (`Release note added because the repo has no existing changelog or release-notes file`)
- `cd flutter_shadcn_kit && dart run tool/registry/registry_verify.dart --ci` → ✅ PASS (`Registry verification summary: Total entries 133; Status: OK`)
- `graphify update .` → ✅ PASS (`GRAPH_REPORT.md and graph.json refreshed after the final code changes`)

## Files Modified
- `docs/superpowers/checkpoints/MASTER_STATUS.md`
- `docs/superpowers/checkpoints/branch-p1-component-barrel-cleanup.md`
- `docs/superpowers/release-notes/branch-p1-component-barrel-cleanup.md`
- `flutter_shadcn_kit/lib/flutter_shadcn_kit.dart`
- `flutter_shadcn_kit/tool/registry/registry_barrel.dart`
- `flutter_shadcn_kit/lib/registry/components/layout/flex/flex.dart`
- `flutter_shadcn_kit/lib/registry/components/form/file_picker/README.md`
- `flutter_shadcn_kit/lib/registry/components/form/file_picker/_impl/core/file_item.dart`
- `flutter_shadcn_kit/lib/registry/components/form/file_picker/_impl/state/file_upload_state_surfaces.dart`
- `flutter_shadcn_kit/lib/registry/components/form/file_picker/_impl/utils/file_upload_formatters.dart`
- `flutter_shadcn_kit/lib/registry/components/form/radio_group/_impl/state/_radio_card_state.dart`
- `flutter_shadcn_kit/lib/registry/components/form/radio_group/_impl/state/_radio_item_state.dart`
- `flutter_shadcn_kit/lib/registry/components/form/radio_group/_impl/utils/next_item_intent.dart`
- `flutter_shadcn_kit/lib/registry/components/form/radio_group/_impl/utils/previous_item_intent.dart`
- `flutter_shadcn_kit/lib/registry/components/overlay/refresh_trigger/README.md`
- `flutter_shadcn_kit/lib/registry/components/overlay/refresh_trigger/_impl/core/refresh_trigger_widget.dart`
- `flutter_shadcn_kit/lib/registry/components/overlay/refresh_trigger/_impl/state/refresh_trigger_state.dart`
- `flutter_shadcn_kit/lib/registry/components/overlay/refresh_trigger/meta.json`
- `flutter_shadcn_kit/lib/registry/components/overlay/refresh_trigger/refresh_trigger.dart`
- `flutter_shadcn_kit/lib/registry/components/overlay/refresh_trigger/refresh_trigger.meta.json`

## Decisions Made
- Task 6 will start by cleaning the low-ambiguity movable cases first: `flex`, `tabs`, and `menu`.
- The ambiguous cases (`text_field`, `scrollable`, `table`) stay for a later pass after the straightforward barrel-local fixes land.
- Only `flex.dart` is a valid step-2 cleanup. It now owns the Flutter-symbol filtering that was previously hidden again at the root barrel.
- `tabs.dart` and `menu.dart` are not simple re-export barrels; their public APIs depend on local `part` files. Removing those `part` declarations broke the component libraries, so both files were reverted and reclassified out of the step-2 bucket.
- Step 3 will focus next on the clearest internalization cases: `file_picker`, `radio_group`, and `refresh_trigger`.
- The real ownership unit for step-3 fixes is the component library subtree, not the top-level `<component>.dart` file. Each remaining leak crosses into `part` files that must be renamed or updated together.
- Step 3 is complete for the clearest internalization cases: `file_picker`, `radio_group`, and `refresh_trigger`.
- Step 4 removed four stale root-barrel hide cases: `file_picker`, `radio_group`, `flex`, and `refresh_trigger`.
- Step 5 required no consumer harness code change; verification example still builds as-is.
- Step 6 is documented in `docs/superpowers/release-notes/branch-p1-component-barrel-cleanup.md`.
