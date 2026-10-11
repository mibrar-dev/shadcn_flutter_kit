# Brief P6-B3 — docs: Blocks section + categorized components

`KIT=/Users/ibrar/Desktop/infinora.noworkspace/shadcn_copy_paste/shadcn_flutter_kit`, `DOCS=$KIT/docs`. Read
`rearch/reports/P6_SHADCN_SITE_SPEC.md`, `P6-B1.md`, `P6-F3.md`, `P6-T1.md`, and ui.shadcn.com/blocks +
/docs/components (agent-browser, SHORT commands; do NOT open PNGs yourself — model crashes on images).

## Do
1. `/blocks` like ui.shadcn.com/blocks: header nav "Blocks"; hero; category tabs/pills (Featured + each block
   category); each block shown in a framed, resizable viewport (desktop/tablet/mobile toggles) with Preview | Code
   toggle; Code view = file tree of the block's files + highlighted, SELECTABLE, copyable code (registry CodeSnippet);
   CLI install command (`flutter_shadcn add <id>`) with copy; "Open in new tab" → `/blocks/<id>` full-page view.
   Deep links `/blocks`, `/blocks/<category>`, `/blocks/<id>` work.
2. Codegen (`tool/gen_docs_data.dart`) emits block catalog (id, title, description, category, files + source) and
   component categories; `--check`.
3. Components grouped by category: docs sidebar groups, `/docs/components` index sections, ⌘K groups — hide
   `listed:false` building blocks everywhere (they stay reachable via API links).
4. Mirror sync (`tool/sync_registry.sh` must copy `blocks/` too), deferred loading for block pages.
Do NOT touch the Theme Studio files (`themes.dart`, `studio_*`, `rail_*`, `theme_rail.dart`) or the landing collage.
Gates: docs format/analyze/test/codegen --check/sync --check/`flutter build web --release`; widget tests for the pages,
category grouping, hidden building blocks, deep links. Report `$KIT/rearch/reports/P6-B3.md`, `## RESULT`. No git ops.
