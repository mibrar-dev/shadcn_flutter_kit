# Brief P6-Z1 — final visual polish (orchestrator visual QA of p6p3 captures)

`KIT=/Users/ibrar/Desktop/infinora.noworkspace/shadcn_copy_paste/shadcn_flutter_kit`. Do NOT open PNGs yourself (model
crashes on images) — verify with widget tests reading real rects/colours.
1. "Forgot password?" (login-01/02/03, signup, any similar trailing link) ends ~30px short of the input's right edge
   because it is a link `Button` with horizontal padding. shadcn uses a plain `ml-auto` anchor: render the link with
   zero horizontal padding (link variant/size or a Link-style text button) so its text's right edge == input's right
   edge (±1px). Test the rects in every block that has such a row.
2. Docs block viewport (`/blocks` cards and `/blocks/<id>`): in the capture the bordered card closes right under the
   tab row (y≈312) and the preview area below has NO border/background frame. Make header + tabs + viewport one
   continuous bordered rounded card (shadcn /blocks) — the existing continuous-card test evidently checks the wrong
   painter; rewrite it to find the DecoratedBox/border that actually paints and assert its rect contains BOTH the tab
   row and the block content.
3. calendar-01/02 month steppers use raw '<' / '>' text glyphs → registry icon buttons (LucideIcons.chevronLeft/Right,
   ghost icon size), as shadcn.
4. Scan home, /themes and every block for any other control with a missing handler (looks disabled) or text glyph
   used as an icon; fix.
Gates: `cd $KIT && rearch/qa_gate.sh`; manifest regen + --check; docs format/analyze/test/codegen --check/sync --check/
build web --release. Captures via agent-browser → `rearch/design/ours/screens/p6z1-*.png` (login-01 block page,
/blocks, calendar-01 at 1440 light+dark). Report `rearch/reports/P6-Z1.md`, `## RESULT`. No git ops.
