# Brief P6-T1 — Theme Studio canvas: shadcn-style staggered (masonry) blocks with many examples

`KIT=/Users/ibrar/Desktop/infinora.noworkspace/shadcn_copy_paste/shadcn_flutter_kit`, `APP=$KIT/flutter_shadcn_kit`,
`DOCS=$KIT/docs`. Read: `$KIT/rearch/briefs/P6-D8-masonry.md` (primitive spec — implement it as part 1 here),
`$KIT/rearch/reports/P6_SHADCN_SITE_SPEC.md`, and the user's reference capture
`$KIT/rearch/design/shadcn-ref/screens/create-dark-user-2026-10-10.webp` (ui.shadcn.com/create, dark) plus
`create-1440-*.png`. Also look at the live https://ui.shadcn.com/create (agent-browser, SHORT commands) to list the
blocks they show.

## User feedback (2026-10-10)
"My blocks are not looking good." On shadcn the canvas is a staggered grid: every card is only as tall as its content
(no fixed/stretched heights, no forced main/cross-axis sizes), columns pack tightly with even gaps, and there are MANY
realistic example blocks so users can see the theme on lots of components.

## Do
1. Registry primitive `$APP/lib/registry/primitives/masonry_layout.dart` per P6-D8 (RenderBox, shortest-column
   placement, spacing, crossAxisCount or maxCrossAxisExtent, RTL, intrinsic heights, works in scroll views, tests in
   `$APP/test/registry/primitives/masonry_layout_test.dart`). meta/manifest/README per registry rules.
2. Rebuild the Theme Studio canvas (`$DOCS/lib/widgets/studio_canvas.dart`, `studio_blocks/**`) on the masonry
   primitive, matching the reference: columns ~ 3 at 1440 (with the rail), 2 at tablet, 1 at 375; gap = reference;
   cards hug content (remove any fixed heights/Expanded/stretch). Provide ≥ 24 realistic blocks built ONLY from registry
   components, e.g. contribution chart, payout threshold (select + slider + textarea + button), savings targets with
   progress, recent transactions list, claimable balance with badge + rows, distribute track empty state, QR/share card,
   preferences (switches/selects), sidebar nav (Overview/Account groups), breadcrumb + pagination/stepper, calendar,
   date range, team members with avatars + role select, cookie settings, create account form, payment method (radio
   cards), report an issue (select + textarea), chat, notifications list, OTP, file upload, data table excerpt, tabs,
   accordion/FAQ, pricing, stats with sparkline, toggles/toolbar. Every block must follow the current theme live
   (colours, radius, spacing/density, fonts, shadows) in light + dark. Split into files ≤ ~400 lines.
3. Use the same masonry primitive for the home collage (`collage*.dart`) and any other card gallery.
4. Sync mirror (`$DOCS/tool/sync_registry.sh`), regenerate docs data (`gen_docs_data.dart`).

## Do NOT touch
The theme rail (`theme_rail.dart`, `rail_*.dart`) — agent P6-T2 owns it; registry `components/**` (P6-F3 is rewriting
previews; if a component bug blocks a block, list it in the report instead). No git state changes.

## Gates (paste output)
```
cd $KIT && rearch/qa_gate.sh && (cd $APP && dart run tool/registry/gen_registry_manifest.dart --check)
cd $DOCS && dart format --output=none --set-exit-if-changed lib test tool && flutter analyze && flutter test \
  && dart run tool/gen_docs_data.dart --check && tool/sync_registry.sh --check && flutter build web --release
```
Captures (agent-browser; do NOT open/read PNGs yourself — model crashes on images; use numeric checks): /themes and /
at 1440 + 375, light + dark → `$KIT/rearch/design/ours/screens/studio-masonry-*.png`. Widget tests: no card has a
fixed height; column packing (each card goes to the shortest column); no overflow at 375/768/1440.
Report `$KIT/rearch/reports/P6-T1.md`, `## RESULT` block. Append progress to the report as you go.
