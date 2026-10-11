Your run was cut by a network error (502) before you wrote the report. The 24 PNGs in rearch/screenshots/pilot/
exist. Continue — do not re-render everything unless needed. Keep each shell command short (< 5 min); a probe that
hangs = stop it and move on.

1. Remove your probe files (`test/probe*_test.dart`, `rearch/screenshots/pilot/_probe.png`) — they are not Outputs.
2. Orchestrator observations to settle FIRST, with measurements (logical px = PNG px / 2):
   a. Button heights look too tall: md ≈ 52 vs shadcn h-9 = 36; xs/sm/lg similarly inflated. Measure every size
      from the widget tree (`tester.getSize`) and compare with shadcn (sm h-8=32, md h-9=36, lg h-10=40, icon 36×36;
      xs ≈ 28). Find the cause (padding? line height? density?) and name file:line in `components/button/`.
   b. dialog_dark.png: the page behind the modal is LIGHT grey in dark mode. Decide: harness bug (stale theme/background
      in your test) or a real component bug (e.g. route/barrier using a stale theme). Prove it either way.
   c. Same height check for input (shadcn h-9 = 36, px-3) and toggle (h-9).
3. Then review every PNG as in the brief and write `rearch/reports/P3V_VISUAL.md` (per scene verdict + ranked
   issues with measured vs expected values and file:line). Fix only harness bugs in your own test file; do NOT edit
   component code.
Finish with the `## RESULT` block.
