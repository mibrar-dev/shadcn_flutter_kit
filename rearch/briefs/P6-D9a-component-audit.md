# Brief P6-D9a — audit every component on the docs site + classify user-facing vs building blocks (report only)

User feedback (2026-10-10): many components do not behave as they should in the docs app; many previews don't even show
(especially in light or dark mode); previews dump every variant at once; the sidebar lists internal building blocks
(e.g. `color`, `history`/color history) that users don't use directly. This batch is the AUDIT that the fix batches use.
Write ONLY the outputs below — another agent is editing docs pages right now.

## 1. Render audit (every component, both modes)
Build the docs (`cd $KIT/docs && flutter build web --release`), serve `build/web` locally, and with `agent-browser`
(isolated session, SHORT commands) open `/docs/components/<id>` for all 118 components in light AND dark (toggle via
the header). For each: does the preview render? errors in the console? blank/zero-size? overflow? wrong colours in one
mode (e.g. invisible text)? do interactions work (click/hover/type/open-close/keyboard)? Also run each component's
`preview.dart` in a widget test harness (`ShadcnApp` + ShadcnTheme light/dark) to catch exceptions headlessly — a quick
throwaway test under `docs/test/audit/` is fine (list it in the report; it may be kept as a regression test).
For every failure find the ROOT CAUSE (registry component bug vs preview.dart bug vs docs harness bug) with file:line.

## 2. Classification
Classify all 118 components: **listed** (a user-facing UI component you would drop into a screen: button, dialog,
select, table, …) vs **building block** (used inside other components or a utility: e.g. color, history, hsl, hsv, alpha,
formatter, locale_utils, media_query, async, patch, page_route, anchor, backdrop_transform, scrollable_client,
overlay_configuration, … — decide each with a one-line reason). Building blocks stay installable but are hidden from the
docs sidebar, components index and ⌘K component group (their API stays reachable from the components that use them).
Propose the mechanism: a `meta.json` field (e.g. `"docs": {"listed": false}` or `tier: "building-block"`) read by the docs
codegen.

## 3. Preview variant spec
For each LISTED component, propose the preview's named examples (e.g. Button: Default, Secondary, Outline, Ghost,
Destructive, Link, Icon, With icon, Loading, Disabled; Sizes as a separate example), the default one, and which controls
a select should switch (variant/size/state). The docs page will show ONE example at a time with a Select + a light/dark
toggle (shadcn shows one demo per section). Propose the preview contract (e.g. each preview.dart exports
`const previews = <ComponentPreview>[ComponentPreview('Default', builder), …]`).

## Outputs (only these)
`$KIT/rearch/reports/P6_COMPONENT_AUDIT.md` (table per component: renders light/dark, interaction ok, issues + root cause
file:line, classification, proposed examples), `$KIT/rearch/reports/p6_component_audit.json` (machine-readable: id,
listed, issues[], examples[]), screenshots under `$KIT/rearch/design/audit/`, optional `docs/test/audit/**`.
Finish with the `## RESULT` block.
