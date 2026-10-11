# Brief P6-P3 — block defects found in visual QA (orchestrator looked at the captures)

`KIT=/Users/ibrar/Desktop/infinora.noworkspace/shadcn_copy_paste/shadcn_flutter_kit`, `APP=$KIT/flutter_shadcn_kit`.
Evidence: `rearch/design/ours/screens/p6p2-login-1440-light.png` (do NOT open PNGs yourself — the model crashes on
images; the defects are described here precisely). Verify every fix with widget tests that read real values.

1. Disabled-looking demo controls: login-01 `const Button(child: Text('Sign in'))` has no onPressed and the "Remember
   me" `Checkbox` has no onChanged, so both render DISABLED (grey, 50% opacity). Audit ALL 16 blocks: every Button,
   Checkbox, Switch, Radio, Toggle, Select, Input, Slider, Tabs, etc. in a block must be interactive (stateful demo or
   a no-op handler) unless the design shows it disabled on purpose. Add a generated test asserting no control in any
   block is disabled (unless whitelisted with a reason) and that the primary Button's fill == theme `primary`.
2. Registry `Checkbox` with a label, placed in a `Column(crossAxisAlignment: stretch)`, renders as a full-width grey
   filled bar with the check icon and the label INSIDE the fill. Correct shadcn behaviour: the 16px box alone is
   filled/bordered; the label sits beside it uncoloured; the row hugs its content (never stretches) — gap from theme.
   Fix at the root in the registry checkbox (and check Switch / Radio / Toggle with labels for the same bug); tests
   under loose AND stretch constraints, light/dark, checked/unchecked/disabled.
3. login-01 (and similar label rows in every block): "Forgot password?" must end exactly at the input's right edge
   (shadcn `ml-auto`); test the rects.
4. Docs block viewport: the framed card border closes under the tab row and the preview area below has no frame —
   header + tabs + viewport must be ONE continuous bordered, rounded card (shadcn /blocks). Test: one border painter
   whose rect contains header and viewport.
5. Inputs in blocks look grey-filled in light mode; shadcn v4 input is `bg-transparent` (light) and `bg-input/30`
   (dark) with a `border-input` border — check the registry Input default and fix if it differs (tests).
Gates: `cd $KIT && rearch/qa_gate.sh`; manifest regen + --check; docs format/analyze/test/codegen --check/sync
--check (re-sync after registry fixes)/build web --release. Captures via agent-browser → `rearch/design/ours/screens/
p6p3-*.png` (login-01, dashboard-01, /blocks at 1440 light+dark). Report `rearch/reports/P6-P3.md`, `## RESULT`. No git.
