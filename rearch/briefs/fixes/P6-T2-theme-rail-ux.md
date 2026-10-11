# Brief P6-T2 — Theme Studio rail UX: fade, scrollable dropdowns, radius presets, live apply

`KIT=/Users/ibrar/Desktop/infinora.noworkspace/shadcn_copy_paste/shadcn_flutter_kit`, `APP=$KIT/flutter_shadcn_kit`,
`DOCS=$KIT/docs`. Reference: ui.shadcn.com/create (live, agent-browser SHORT commands) and
`$KIT/rearch/design/shadcn-ref/screens/create-dark-user-2026-10-10.webp`. Bug capture from the user:
`$KIT/rearch/design/ours/screens/themes-rail-fade-bug-user-2026-10-10.png` (do NOT open PNGs — model crashes on
images; this note describes it: in dark mode the rail's top scroll fade paints an opaque BLACK block over the first
row ("Theme colour / Orange"), hiding it).

## Do
1. Scroll fade: root cause is almost certainly the registry `primitives/fade_scroll.dart` colour-gradient mask
   (P6-F2 found the same bug in scrollable/marquee: `BlendMode.modulate` never multiplies alpha, so a
   colour→transparent gradient paints black/white). Fix the PRIMITIVE: alpha-only mask (`BlendMode.dstIn`,
   opaque→transparent), no colour needed, correct in light + dark on any surface; update every caller (rail, docs code
   teaser, others — grep). Tests: pixels under the fade blend to the real surface, never black/white blocks.
2. Every rail dropdown/popup (theme colour, chart colours, base colour, fonts, icon library, radius, spacing, shadow,
   menu, menu accent, presets, …) gets a max height (≤ min(360, available viewport below/above the anchor)) with its own
   scroll area (+ the fixed fade), keyboard navigation keeps the selected item scrolled into view, and the popup never
   goes off-screen. Fix the registry `MenuRow` layout assertion (a `LayoutBuilder` inside `IntrinsicWidth`, see
   `$DOCS/test/themes_page_test.dart` _ErrorRecorder note) at its root in the registry so no error is recorded.
3. Radius presets like shadcn: None (0), Small, Default, Medium, Large, Full-ish — use the shadcn /create values
   (check the live site) as a segmented/option list, plus the fine slider. Same idea for spacing/density and shadows if
   shadcn offers presets.
4. LIVE APPLY: every control applies immediately to the whole site while you interact (dragging the radius slider,
   hovering/selecting a colour, choosing a font) — no Save/Done step needed; "Done" only closes. Escape closes and
   keeps the current value (a separate Reset exists). Persisted as today.
5. Rail rows look like the reference (row card spacing, label/value typography, glyphs) in light + dark.

## Do NOT touch
The canvas (`studio_canvas.dart`, `studio_blocks/**`, `collage*.dart`) — agent P6-T1 owns it; registry
`components/*/preview.dart` (P6-F3). Registry edits limited to `fade_scroll` + `MenuRow`/menu internals and their
callers. No git state changes.

## Gates (paste output)
```
cd $KIT && rearch/qa_gate.sh && (cd $APP && dart run tool/registry/gen_registry_manifest.dart --check)
cd $DOCS && dart format --output=none --set-exit-if-changed lib test tool && flutter analyze && flutter test \
  && dart run tool/gen_docs_data.dart --check && tool/sync_registry.sh --check && flutter build web --release
```
Widget tests: fade colour correctness (light/dark), popup max height + scroll + selected item visible, radius presets,
live apply during slider drag (theme changes before release), Escape keeps value, no recorded framework errors.
Report `$KIT/rearch/reports/P6-T2.md`, `## RESULT` block. Append progress as you go.
