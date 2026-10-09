# Brief P6-B — Flutter docs website rebuild plan (read-only planning)

Rebuild the docs website (`$KIT/docs/`, Flutter web app, deployed to GitHub Pages) from scratch to match the accepted
Open Design mockups (`$KIT/rearch/design/docs/*.html`, `screens/*.png`, spec `rearch/reports/P6_DOCS_DESIGN.md`), built
ONLY on the new registry components. The kit's registry is being cut over right now (`flutter_shadcn_kit/lib/registry_next/`
→ `lib/registry/`, manifest `lib/registry/manifests/registry.json`, schema `rearch/reports/registry_manifest.v2.schema.json`).

## Ground rules from the user
- The docs app must CONSUME the components the way a user would: installed into the docs app with the new CLI
  (`flutter_shadcn init` + `add --all`, layout `docs/lib/ui/shadcn/{foundation,theme,primitives,components/<name>}`).
  Until the new CLI lands, a temporary mirror copy of that same layout is acceptable (same files, same paths) so the build
  can start; the final step re-installs via the CLI and must produce no diff.
- Modern, motion-rich, exactly per the mockups + motion spec; widgets-only (no Material/Cupertino) wherever the kit
  provides it; reduced-motion respected.
- All component facts (API params, theme fields, deps, file counts, keyboard tables, stats) are GENERATED from the real
  registry (manifest + meta.json + README.md + source via package:analyzer at build time / a codegen tool) — never typed
  by hand. Live previews use each component's `preview.dart`.

## Read
The mockups + spec, the current `docs/` app (what to delete/keep: routing, web bridge, loaders, search, code highlighter,
deployment scripts, pubspec), `rearch/reports/P5_CLI_PLAN.md`, a few `components/*/{meta.json,README.md,preview.dart}`,
`theme/README.md`, `themes/` (42 presets) and `tool/rearch/gen_app_theme.dart`.

## Produce `$KIT/rearch/reports/P6_DOCS_BUILD_PLAN.md`
- Architecture: app shell, routing (go_router or a minimal router — justify), state (theme mode, preset, density/radius),
  live re-theming (AnimatedShadcnTheme tween 300ms), search index (generated), code highlighting (keep/replace), web build
  + GitHub Pages deploy, performance budget (deferred loading per component page, first paint).
- Codegen: `docs/tool/gen_docs_data.dart` → generated Dart data (component catalog, API tables from source, theme fields,
  deps, keyboard tables from README sections, preset list) — exact inputs/outputs and how CI checks it is fresh.
- Page → widget map (every mockup element → registry component or docs-only widget).
- Motion implementation map (spec item → Flutter mechanism).
- Old docs code: delete/keep table.
- Build batches for parallel agents (≤ ~3k LOC each, exact outputs, dependencies), incl. a final UI-check batch that
  screenshots the built site against the mockups (desktop 1440 + mobile 375, light + dark).
Do not write app code. Finish with the `## RESULT` block.
