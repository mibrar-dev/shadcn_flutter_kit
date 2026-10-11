# Brief P7-D1b — preview card polish (orchestrator visual QA of p7d1 captures)

Context: `rearch/reports/P7-D1.md` (your previous work, accepted). Do NOT open PNGs yourself (model crashes on images).
1. Preview content is NOT centred: on /docs/components/button (1440 dark) the "Button" demo sits at the left
   (x≈440 inside a 400–1040 card) instead of the centre. Wrap every example in the stage so it is centred both axes
   regardless of what the example returns (Row/Wrap/Column with max main-axis size, Align, etc.): e.g. Center +
   ConstrainedBox(maxWidth: stage) + IntrinsicWidth/`MainAxisSize.min` handling; must not stretch full-width
   examples (tables, inputs with explicit widths keep their size, centred). Check button, badge, input, table, tabs,
   calendar, card, alert, accordion examples.
2. At 375px the card toolbar wraps: Preview|Code tabs on one line, the Light toggle + copy on a second line. Keep ONE
   row at ≥ 320px: tabs left, compact icon-only light/dark toggle (tooltip) + copy right.
3. Remove the now-unused DocsState preview-selection/invert APIs (or re-key per card) and their stale tests if nothing
   uses them.
Tests: example centre == stage centre (±1px) for those components at 1440 and 375; toolbar single row at 320/375.
Gates: docs format/analyze/test/codegen --check/sync --check/build web --release. Captures → `p7d1b-*.png` (button,
badge, table at 1440 dark + 375 light). Update `rearch/reports/P7-D1.md` with a "D1b" section and `## RESULT`. No git ops.
