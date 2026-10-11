# Brief P7-Q0b — finish P7-Q0 in a fresh session

Binding brief: `rearch/briefs/fixes/P7-Q0-classification-parity.md`. The previous session crashed before writing its
report; it already set `"listed": false` on several components (35 total now, see `git diff -- '*/meta.json'`).
1. Review the current listed/hidden state of all 118 components against the rule in the brief (app-usable widgets
   only in the sidebar); finish/adjust the meta edits (respect the "do not edit, recommend only" list).
2. Do the parity table vs `origin/main`.
3. Regenerate manifest (`dart run tool/registry/gen_registry_manifest.dart` in flutter_shadcn_kit) and docs data
   (`dart run tool/gen_docs_data.dart` + `bash tool/sync_registry.sh` in docs). Note: the orchestrator has an
   uncommitted docs codegen change (readable titles via `displayTitle(id)` in docs/tool/src) — keep it.
4. Write `rearch/reports/P7-Q0.md` (decision table with a reason per component, parity table) EARLY, then gates
   (manifest --check, docs codegen --check, sync --check, docs analyze/test — record failures that are only in other
   agents' in-flight files) and `## RESULT`. Pipe long outputs through `tail`. Do NOT open PNGs. No git ops.
