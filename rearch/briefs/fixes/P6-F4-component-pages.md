# Brief P6-F4 — docs component pages: one example at a time (Select) + light/dark toggle + selectable code

`KIT=/Users/ibrar/Desktop/infinora.noworkspace/shadcn_copy_paste/shadcn_flutter_kit`, `DOCS=$KIT/docs`. Read
`rearch/reports/P6_COMPONENT_AUDIT.md` (§3 harness root causes, §4 contract), `P6-F3.md` (the new
`<camel>Previews` lists), `P6-T2.md` (fixed fade), `P6_THEME_AUDIT.md` (selectability §3). Do NOT open PNGs yourself
(model crashes on images) — use widget tests + agent-browser text/console.

User requirements: previews render in light AND dark and follow the selected theme; ONE named example at a time with a
Select to switch (shadcn style) + a light/dark toggle on the preview; ALL code (install block, usage, View Code teaser,
Get Code dialog) selectable + copyable with syntax colours; the Calendar selection on the docs site under the `claude`
preset must be the theme primary (registry is correct — find the docs-side cause and prove it fixed).

## Do
1. Preview stage (`widgets/preview_stage.dart` & co.): bounded constraints (fix the unbounded width/height harness bug),
   centered example, Select of example names (from codegen `kComponentPreviews`), per-preview light/dark toggle that
   wraps only the stage in the opposite brightness of the current theme (same preset), selection kept in DocsState.
2. Codegen reads the `const List<ComponentPreview>` exports (analyzer) → names/count per component; `--check`.
3. Every code surface uses the registry CodeSnippet (selectable) or SelectableRegion; keep highlighting; copy buttons.
4. Theme propagation: the site theme (Theme Studio model) reaches every preview (no nested default ShadcnApp/Theme);
   test: claude preset → Calendar selected day = claude primary; theme change at runtime updates previews.
5. Re-run the render audit (`AUDIT_RENDER=1 flutter test test/audit/preview_render_audit_test.dart`): threw=0,
   overflow=0 for listed components in light + dark.
Do NOT touch Theme Studio files, sidebar/index/⌘K grouping (P6-B3), landing/collage (P6-H1), registry (report bugs).
Gates: docs format/analyze/test/codegen --check/sync --check/`flutter build web --release`. Report
`$KIT/rearch/reports/P6-F4.md`, `## RESULT`. No git ops.
