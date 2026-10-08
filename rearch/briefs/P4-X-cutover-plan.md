# Brief P4-X — cutover plan + dry-run script (READ-ONLY on the repo; do not move or delete anything)

When B24/B25 land, `lib/registry_next/` replaces the old `lib/registry/`. Prepare that so the orchestrator can
present it to the user for approval and then execute it in one step.

## Read
`rearch/reports/P4_PLAN.md` (cutover section), `rearch/reports/p4_batches.json` (`cutover`, `deleted`,
`moved_to_primitive`), `REARCHITECTURE_PLAN.md`, the tools under `flutter_shadcn_kit/tool/registry/**` and
`tool/rearch/**`, `flutter_shadcn_kit/pubspec.yaml`, `test/` (old registry tests), `playground/` if present, `example/`,
and any code that imports `registry/` (grep the whole kit repo).

## Produce
1. `rearch/reports/P4_CUTOVER.md`:
   - inventory: every old `lib/registry/components/*` dir → new component / merged into / primitive / deleted (must
     cover all; cross-check with p4_batches.json) and anything in the old tree NOT yet in registry_next (blockers);
   - exact steps: rename registry_next → registry (git mv), delete old tree, update imports in tool/, test/, example/,
     playground, docs; regenerate manifests (components.json, shared/primitives manifest, index) with which tool and
     what schema changes (meta.json `deps` shape); old tests to retire/port; pubspec deps that become unused
     (data_widget, gap, phonecodes, etc.);
   - risks + rollback (the branch is pushed; rollback = git revert of the cutover commit);
   - what the CLI (Phase 5) must change (manifest schema, install paths, primitives/foundation layout).
2. `rearch/cutover.sh` — a script that performs the steps, with `--dry-run` (default) that only PRINTS what it would do
   and `--apply` that does it. It must refuse to run `--apply` if `git status` is not clean or if any blocker exists.
   Do NOT run `--apply`. Run `--dry-run` and paste its output in the report.

## Outputs (only these)
`rearch/reports/P4_CUTOVER.md`, `rearch/cutover.sh`.
