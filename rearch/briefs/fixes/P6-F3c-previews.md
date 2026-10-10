# Brief P6-F3c — helper for P6-F3: convert these previews to the ComponentPreview contract

P6-F3 (brief `rearch/briefs/fixes/P6-F3-previews.md` — read it fully, it is binding) is converting previews A–M.
You convert ONLY these components' `preview.dart` (and fix their render bugs listed in
`rearch/reports/P6_COMPONENT_AUDIT.md`):

spell_check_suggestions_toolbar stage_container star_rating stepper steps swiper switch switcher table tabs text_animate text_area time_picker timeline toast tooltip tracker tree window

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
`test/registry/previews_f3.dart` (keep it). Report `rearch/reports/P6-F3c.md` (component → examples,
bugs fixed), `## RESULT` block. Append progress after each component.
