# Brief P3-F — pilot follow-up: sizes vs shadcn, hover test, dark dialog background, visual report

The pilot components (`registry_next/components/{button,toggle,input,dialog}`) are accepted, but a screenshot pass
(`rearch/screenshots/pilot/*.png`, rendered at DPR 2 by `test/registry_next/visual/pilot_screenshots_test.dart`)
raised questions that were never settled. Settle them with WIDGET TESTS (deterministic `tester.getSize` /
`tester.getRect`), not pixel probing. Keep each shell command under 5 minutes.

## 1. Sizes must match shadcn/ui (new-york, default density)
Write `test/registry_next/components/pilot_metrics_test.dart` asserting logical sizes:
- Button heights: sm 32, md (default) 36, lg 40; icon 36×36 (icon-sm 32×32, icon-lg 40×40 if those sizes exist);
  xs 28 if the design has xs. Horizontal padding: sm px-3 (12), md px-4 (16), lg px-6 (24) (icon: square).
  Text 14px / font-weight 500.
- Input height 36, horizontal padding 12, 1px border, radius = radiusMd token.
- Toggle default height 36 (min-width 36, px-2), sm 32, lg 40.
- Dialog card: max width 512 (sm:max-w-lg), padding 24, radius radiusLg, gap 16 between header/body/footer.
The screenshots suggest buttons are too tall (md ≈ 52). If a test fails, FIX THE COMPONENT (style tables /
padding / line height — likely text line-height or vertical padding stacking with a min height) so the tests pass.
Keep all existing tests green; update any that encoded the wrong sizes and say which.

## 2. Hover test that passes for the wrong reason
`test/registry_next/components/button_test.dart`: the hover assertion passes only because hovered and pressed share
alpha 0.9, and FocusableActionDetector delivers no hover unless
`FocusManager.instance.highlightStrategy = FocusHighlightStrategy.alwaysTraditional` (restore it with addTearDown).
Fix the test so it truly drives hover (mouse TestGesture) and asserts the hovered colour; same check in
toggle_test.dart.

## 3. Dark-mode dialog background
`rearch/screenshots/pilot/dialog_dark.png` shows the page behind the modal as LIGHT grey in dark mode. Decide with a
test whether this is the screenshot harness (page not wrapped in the dark theme / stale background) or a real dialog
bug (route or barrier using a stale theme). Fix whichever it is.

## 4. Re-render + report
Re-run `flutter test test/registry_next/visual` to regenerate the PNGs after fixes. Write
`rearch/reports/P3V_VISUAL.md`: the measured-vs-shadcn table from §1 (before → after), what §2 and §3 found and
fixed, and a short per-PNG verdict list (OK / ISSUE + reason) for the regenerated screenshots.

## Outputs (only these)
`lib/registry_next/components/{button,toggle,input,dialog}/**`, the tests named above,
`test/registry_next/visual/pilot_screenshots_test.dart`, `rearch/screenshots/pilot/*.png`, `rearch/reports/P3V_VISUAL.md`.

## Gates
`cd $KIT && rearch/qa_batch.sh button toggle input dialog` — all clean; plus
`cd $APP && flutter test test/registry_next/visual` green.
