# Brief P5-A — CLI rewrite plan + registry manifest v2 schema (read-only planning)

The kit is being cut over to the new registry (`flutter_shadcn_kit/lib/registry_next/` → `lib/registry/`):
`foundation/` (layer 0), `theme/` (1), `primitives/` (2), `components/<name>/` (3, flat: `<name>.dart`,
`<name>_style.dart`, user-owned `<name>_theme.dart`, `preview.dart`, `meta.json`, `README.md`), `themes/` (42 presets,
schema v2 JSON) and `tool/rearch/gen_app_theme.dart` (preset JSON → values-only `app_theme.dart`). Every component's
`meta.json` has `deps: {foundation:[stems], theme:[stems], primitives:[stems or folder names], components:[ids]}` that
match its imports exactly (enforced by `tool/rearch/check_layers.dart`). The CLI repo
(`CLI = /Users/ibrar/Desktop/infinora.noworkspace/shadcn_copy_paste/shadcn_flutter_cli`, branch
`refactor/rearchitecture`) must be rewritten to install from this layout. User decision: clean break, no migrate command.

## Read
Kit: `rearch/reports/P4_CUTOVER.md` (CLI section), `REARCHITECTURE_PLAN.md`, `rearch/reports/THEME_DESIGN.md` (§5 user-owned
theme files: CLI never overwrites `<name>_theme.dart` / `app_theme.dart`), several `components/*/meta.json`,
`primitives/README.md`, `foundation/README.md`, `theme/README.md`, `themes/` + `manifests/themes.schema.json`,
`tool/rearch/gen_app_theme.dart`, `tool/registry/**` (old manifest generators). CLI: `AGENTS.md`, `PLAN.md`,
`README.md`, `lib/**`, `bin/**`, `test/**` (especially installer, manifest resolver, multi-registry, theme, lock file).

## Produce (read-only — write only the two outputs)
1. `$KIT/rearch/reports/registry_manifest.v2.schema.json` — JSON Schema for ONE generated file
   `lib/registry/manifests/registry.json`: `schemaVersion: 2`, `registry` (name, version/ref), `foundation`, `theme`,
   `primitives` (id → files[] relative to lib/registry, deps), `components` (id → name, category, description, files[]
   (excluding preview.dart), userOwned[] (the *_theme.dart), deps{foundation,theme,primitives,components}, tags, api
   summary), `themes` (preset id → file, name, modes), plus per-file sha256 for update/diff. Keep it minimal.
2. `$KIT/rearch/reports/P5_CLI_PLAN.md`:
   - Command surface (keep names users know where sensible): `init` (pick target dir, default `lib/ui/shadcn`, copy
     foundation + theme core, generate `app_theme.dart` from a chosen preset, write lock file), `add <ids…>` (resolve
     transitive closure over components→primitives→foundation/theme, copy files preserving the layered layout, never
     overwrite user-owned files, dry-run + json output), `remove`, `update` (hash-based: overwrite unchanged files,
     report locally modified ones, never touch user-owned), `list`/`search`/`info`, `theme list|apply <preset>`,
     `doctor` (verify closure + imports compile layout), registry source (bundled vs remote GitHub ref, multi-registry
     if the CLI already supports it).
   - Install layout + import rewriting rule (registry files use relative imports, so copying the tree keeps them valid —
     confirm by reading files).
   - Lock file format v2.
   - Which CLI modules to delete/replace/keep (file-by-file table; the user's installer/alias WIP commit `de35dd2` is now
     on the branch — say what of it survives).
   - Test plan (unit + golden install of a fixture registry + e2e `add button` into a temp Flutter app that then passes
     `flutter analyze`).
   - Build batches for implementation agents (≤ ~3k LOC each, parallelisable), with exact outputs per batch.
Finish with the `## RESULT` block.
