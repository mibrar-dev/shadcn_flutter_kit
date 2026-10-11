# Brief P6-D8 — staggered (masonry) grid for component blocks (user request)

The user wants the component/blocks showcases on the docs site to pack tightly — no large empty gaps between widget
blocks of different heights. Reference: the masonry-like card columns on ui.shadcn.com home and /create canvas
(`rearch/design/shadcn-ref/screens/home-1440-*.png`, `create-1440-*.png`).

1. Registry primitive `$APP/lib/registry/primitives/masonry_layout.dart` (layer 2, widgets-only, ≤ ~400 lines):
   a real `RenderBox`-based staggered grid — children placed one by one into the currently SHORTEST column (stable,
   left-most on ties), uniform `mainAxisSpacing` / `crossAxisSpacing`, column count from either a fixed `crossAxisCount`
   or a `maxCrossAxisExtent` (responsive), intrinsic sizes + baseline-free, correct hit-testing/semantics order, works
   inside scroll views (no unbounded height crash), RTL mirrors column order. A sliver variant only if needed by the docs.
   Tests: placement order (shortest column), spacing exact, responsive column count at 375/768/1024/1440, RTL, hit test,
   no overflow with very tall/short children, unbounded-height parent error message is clear.
2. Use it on the docs: home collage, Theme Studio canvas (`/themes`), and any other block/preview gallery grid (e.g.
   component examples galleries) — keep each card's content; just replace the grid. Match the reference gaps (spec values).
3. Regenerate manifest, re-sync docs mirror (`$KIT/docs/tool/sync_registry.sh`), regenerate docs data; README section in
   `primitives/README.md`.
Capture home + /themes at 1440 and 375, light + dark, before/after montages vs the reference in the report.

Gates: `$KIT/rearch/qa_gate.sh`, manifest `--check`; docs `flutter analyze`, `flutter test`, codegen/mirror `--check`,
`flutter build web --release`. Report `$KIT/rearch/reports/P6-D8.md`, `## RESULT` block.
