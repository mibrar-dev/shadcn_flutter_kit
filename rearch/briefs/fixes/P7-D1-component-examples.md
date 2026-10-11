# Brief P7-D1 — component pages: every variant in its own Preview | Code card (shadcn docs layout) + better preview UI

KIT=/Users/ibrar/Desktop/infinora.noworkspace/shadcn_copy_paste/shadcn_flutter_kit, APP=$KIT/flutter_shadcn_kit, DOCS=$KIT/docs.
Reference: any ui.shadcn.com/docs/components/<name> page (agent-browser, SHORT commands, e.g. button, select, tabs,
calendar): a main demo card at the top (Preview | Code tabs), Installation, Usage, then an "Examples" section where EACH
example has its own heading (h3), its own framed preview card and its own Preview | Code tabs with that example's code.
Do NOT open PNG images yourself (the model crashes on images) — verify with widget tests + agent-browser text/console.

User (2026-10-11): show each variant in its own preview with its own View Code, and improve the preview UI. This
replaces P6-F4's single preview + example Select.

## Do (docs only: `lib/pages/component_page.dart`, `lib/widgets/{preview_stage,component_preview_card,component_sections,
live_preview,code_teaser,code_figure}.dart` and new widgets, `tool/**` codegen)
1. Codegen: for every `const <camel>Previews = [ComponentPreview('Name', _builderFn, description: ...)]`, extract the
   SOURCE of each example's builder function (and the private helper widgets/classes it uses from the same preview
   file) into the generated snippets, so each example's Code tab shows exactly the code for that example (imports for
   the component + the example body, formatted, selectable, syntax-highlighted, with copy). `--check` stays green.
2. Page layout: top = first example ("Default") as the main demo card; then Installation, Usage, then "Examples"
   with every remaining example as `### <Name>` + optional description + its own card. Each card: Preview | Code tabs
   (code with the faded "View Code" teaser + expand, as today), a per-card light/dark toggle, and a copy button. Add the
   examples to the right-hand "On This Page" TOC. Remove the example Select.
3. Preview UI polish (shadcn-like): card `rounded-lg border`, preview area min-height ~350px (main) / ~200px (examples),
   content centred with comfortable padding (p-10 desktop, p-4 mobile), subtle background (background token; optional
   dotted grid pattern from tokens), consistent toolbar row (tabs left; toggle + copy right), no layout jump when
   switching tabs, keyboard-accessible tabs, works 375→1440 light/dark and every preset. Deferred loading: load the
   preview chunk once per page, render all examples lazily as they scroll into view (keep long pages fast).
4. Tests: every listed component page renders all its examples (count == preview list length) each with Preview/Code;
   code tab text contains the example's builder body; TOC lists examples; no overflow at 375/1440; console clean.
Do NOT touch registry files (other agents are editing them) — if a preview file blocks extraction, report it.
Gates: docs `dart format --output=none --set-exit-if-changed lib test tool`, `flutter analyze`, `flutter test`,
`dart run tool/gen_docs_data.dart --check`, `bash tool/sync_registry.sh --check`, `flutter build web --release`.
Captures via agent-browser (button, select, calendar, tabs pages at 1440 dark + 375 light) →
`rearch/design/ours/screens/p7d1-*.png`. Report `rearch/reports/P7-D1.md`, `## RESULT`. No git ops.
