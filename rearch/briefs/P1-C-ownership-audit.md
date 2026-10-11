# Brief P1-C — Ownership & shared-layer audit (analyst)

## Goal
Decide, for every duplicated declaration and every shared file, where it will live in the new architecture
(PLAN §4 and §5). This drives the whole migration, so be exhaustive and exact.

## Method
1. Find every top-level class/mixin/enum/extension/typedef name declared in more than one place under $REG
   (exclude shared/theme/generated). Use a script you write in /tmp (python or dart) — do NOT write into the repo
   except Outputs. The orchestrator's count was 148 names; explain differences.
2. For each duplicate group: list locations, whether bodies are identical or diverged (summarize the divergence in
   one line), who imports which copy (grep import lines), and DECIDE the single owner using PLAN §5 placement rules:
   - part of a component's public API → that component owns it, others depend on it
   - generic helper used by 2+ → lowest shared layer (foundation / theme / primitives)
   - dead (no importers) → delete
3. Component merges: decide and justify for these families, with the final component name and file list:
   - input + text_field (+ which features belong where), autocomplete
   - form + form_field + shared/primitives form state (FormKey, ValidationResult, FormValueSupplier, …) → primitives/form_core?
   - tabs + tab_container + tab_pane
   - button family: toggle, button_group, selected_button, tab_button, card_button → own components or variants?
   - any other family you discover with >5 shared names (report them all)
4. Shared layer map: for EVERY .dart file under $REG/shared (excluding theme/generated and theme/** which another
   agent designs), assign: foundation | primitives | move-into-component <name> | delete (dead) and give the
   number of components importing it. Use $REG/manifests/components.json shared ids to cross-check.
5. External packages: list every import of data_widget and gap (file:line count per symbol used, e.g. Data.inherit,
   Data.of, Gap) so foundation replacements can be sized.

## Outputs (only these)
- $KIT/rearch/reports/OWNERSHIP.md   (decisions + rationale, tables)
- $KIT/rearch/reports/ownership.json (machine-readable: {duplicates:[{name,locations,identical,owner,action}],
  merges:[...], shared_map:[{file,layer,importers,action}], external:{data_widget:[...],gap:[...]}})

## Acceptance
- Every duplicate name and every non-theme shared file appears exactly once in ownership.json.
- Every decision has a one-line rationale. Counts at the top of OWNERSHIP.md.
