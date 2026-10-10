# Brief P6-P2 — Blocks section polish (visual QA findings)

`KIT=/Users/ibrar/Desktop/infinora.noworkspace/shadcn_copy_paste/shadcn_flutter_kit`. Read `rearch/reports/P6-B3.md`
and compare with ui.shadcn.com/blocks (agent-browser, SHORT commands). Do NOT open/read PNGs yourself (model crashes on
images) — use widget tests + numeric checks (rects, text content, colours).

Fix (docs + registry blocks):
1. The install command in each block card is truncated to `flutter_shadcn add` (id missing) and floats tiny in the
   middle of the tab row — show the full `flutter_shadcn add <id>` in a proper copyable command chip (shadcn style,
   right side of the toolbar), never truncated at 1440/768; collapses gracefully at 375.
2. The block card's border stops under the tab row; the preview viewport must sit inside one continuous framed card
   (border + radius around header, tabs and viewport), like shadcn. Viewport background = background token, sizes
   desktop/tablet/mobile visibly change the frame width (centred).
3. Block page (`/blocks/<id>`): title/description are duplicated (page header + card header) — keep one.
4. Registry blocks: dashboard bar chart cycles rainbow colours per bar — use a single `chart1` token (shadcn); audit
   all 16 blocks for similar issues (misaligned label rows e.g. login "Forgot password?" must align to the field's
   right edge, uneven paddings, muted texts missing like "+20.1% from last month") and fix with theme tokens only.
5. Large empty space above short blocks (login) — the viewport height should fit the block (min height, max height
   with scroll), centred vertically only within a reasonable box.
Gates: `cd $KIT && rearch/qa_gate.sh`; manifest --check (regenerate); docs format/analyze/test/codegen --check/sync
--check/build web --release; tests for 1–5. Captures via agent-browser → `rearch/design/ours/screens/p6p2-*.png`.
Report `rearch/reports/P6-P2.md`, `## RESULT`. No git ops.
