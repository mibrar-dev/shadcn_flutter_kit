# Brief P6-F3d — helper for P6-F3: convert these previews to the ComponentPreview contract

P6-F3 (brief `rearch/briefs/fixes/P6-F3-previews.md` — read it fully, it is binding) is converting previews A–M (slowly); you take the tail of its list. If a preview already contains `List<ComponentPreview>` when you reach it, skip it (P6-F3 did it).
You convert ONLY these components' `preview.dart` (and fix their render bugs listed in
`rearch/reports/P6_COMPONENT_AUDIT.md`):

file_diff_viewer file_picker filter_bar form formatted_input gooey_toast hover_card item_picker markdown menu menubar multi_select

Follow the contract exactly as the already converted ones do — read `flutter_shadcn_kit/lib/registry/foundation/component_preview.dart`
and 3 converted examples first (button, card, chip). Examples from P6_COMPONENT_AUDIT.md §4.2; first = default; no
`ShadcnThemeData(`, no pinned brightness/colours, no fixed outer heights, bounded 720×420 + 375-wide fit, controllers
inside the example's own State, spacing from theme tokens.

## Do NOT touch
Any other component's files, `foundation/component_preview.dart`, any `meta.json`, the manifest/generator/schema,
`test/registry/previews_test.dart` (P6-F3 owns them), `docs/**`. No git state changes. If a component's
implementation has a render bug, fix it in that component's own files (same list) and say so.

## Gates
`cd flutter_shadcn_kit && dart format <your files> && flutter analyze lib/registry/components/<each>` clean, and a
throwaway test pumping each example (light/dark, 720×420 and 375 wide, no exception/overflow) — put it at
`test/registry/previews_f3.dart` (keep it). Report `rearch/reports/P6-F3d.md` (component → examples,
bugs fixed), `## RESULT` block. Append progress after each component.
