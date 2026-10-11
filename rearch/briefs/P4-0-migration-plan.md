# Brief P4-0 — Phase 4 migration plan (read-only, planning only)

## Goal
Plan the migration of EVERY remaining component from the old tree `$REG/components/**` (145 meta.json today) into
`$APP/lib/registry_next/components/<name>/`, so builders can execute batch by batch. Pilot is DONE and is the
pattern to copy: `registry_next/components/{button,toggle,dialog,input}` + `rearch/reports/P3_PILOT_DESIGN.md`
(read §0 conventions and the QA_LOG entries for P3-B/C/D — they list the bugs QA rejected).

## Read
PLAN §3–§6, `rearch/reports/OWNERSHIP.md` + `ownership.json` (merges, deletions, owner of every duplicate),
`THEME_DESIGN.md` §3, `rearch/reports/QA_LOG.md`, `registry_next/primitives/README.md` and the folder listing of
`registry_next/primitives/` (what already exists: clickable, focus, hover, overlay, popover, sheet_overlay, animation,
layout, form_core, text, localizations, text_editing/, input_features/ …), and the old components' meta.json files.

## Produce
1. Inventory: every old component → one of MIGRATE (new name), MERGE INTO <x>, MOVE TO PRIMITIVE <file>,
   DELETE (reason), DONE (pilot). Include the 6 known installability violations (fade_scroll, hsl, hsv, sortable,
   group, tab_list) and say how each is resolved. Nothing may be left unassigned — cross-check the count.
2. Missing primitives: anything ≥ 2 components need that is not yet in primitives/ (e.g. scroll/scrollbar helpers,
   date/calendar math, color math, menu/item navigation, sortable/drag) — list each with owner batch "P4-PRIM-n",
   to be built BEFORE the batches that need them.
3. Batches in dependency order (a component may only depend on primitives/foundation/theme and on components in
   EARLIER batches, declared in meta.json `deps.components`). 4–7 components per batch, sized so one agent run can
   finish (≈ ≤ 3k new LOC). Balance across 3 parallel builders: mark which batches can run in parallel (no shared
   files, no inter-batch deps). Large components (markdown, calendar, table, chat, tree, select, menu, command,
   navigation_menu, color_picker, drawer…) get their own batch or share with small ones.
4. Per component in a batch: new folder name; old paths (incl. _impl/); merges absorbed; primitives used; component
   deps; variants/sizes enum if any; known old bugs to fix (from TOKENS_AUDIT/OWNERSHIP/your reading — be concrete);
   approx old LOC → target LOC; risk notes (Material-only APIs to replace, platform specifics).
5. Cutover checklist (end of Phase 4): what replaces `lib/registry/` (registry_next → registry rename), manifests to
   regenerate (components.json, shared manifest, index), playground sync, old tests to retire/port, CLI touchpoints
   (Phase 5).

## Outputs (only these)
- `$KIT/rearch/reports/P4_PLAN.md` (human-readable; ≤ ~900 lines)
- `$KIT/rearch/reports/p4_batches.json`: `{ "prims": [{id, files, needed_by, notes}], "batches": [{id, parallel_group,
  components: [{name, old_paths, merges, primitives, component_deps, bugs_to_fix, old_loc, target_loc, notes}]}],
  "deleted": [{name, reason}], "moved_to_primitive": [...], "cutover": [...] }` — valid JSON (verify with
  `python3 -m json.tool`).
Finish with the `## RESULT` block.
