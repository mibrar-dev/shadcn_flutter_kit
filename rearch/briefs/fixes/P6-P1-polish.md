# Brief P6-P1 — polish batch (home + studio + one registry bug)

`KIT=/Users/ibrar/Desktop/infinora.noworkspace/shadcn_copy_paste/shadcn_flutter_kit`, `APP=$KIT/flutter_shadcn_kit`,
`DOCS=$KIT/docs`. Context: `rearch/reports/QA_LOG.md` (P6-T1, P6-F5, P6-H1 entries), `P6-H1.md`, `P6-T1.md`.
Do NOT open/read PNGs yourself (model crashes on images); verify with widget tests + numeric checks.

1. Registry `MenuGroup` autofocuses its RovingGroup on mount, stealing focus from the page (docs works around it with
   `FocusScope(canRequestFocus:false)`). Fix at the root: no autofocus unless an `autofocus` param is true (additive);
   keyboard nav unchanged once focused; tests. Then REMOVE the docs workarounds.
2. Remove the horizontal-scroll workarounds T1/H1 added around Pagination/Calendar/InputOtp (fixed in P6-F5) and restore
   the 6-slot OTP; no overflow at 375/768/1440.
3. Home cards: the "View Analytics" button reads as a disabled grey — use the proper variant; payout-threshold slider
   min/max labels must align to the slider's edges; check every home + studio card for similar issues (disabled-looking
   enabled controls, misaligned label rows, uneven padding) and fix.
4. Split `docs/lib/widgets/collage_cards.dart` (500 lines) and any other docs file > ~400 lines you touch.
Do NOT touch Blocks pages, sidebar/index/⌘K, `components/*/meta.json`, `lib/registry/blocks/**` (other agents).
Gates: `cd $KIT && rearch/qa_gate.sh`; docs format/analyze/test/codegen --check/sync --check (run sync after the
registry fix)/`flutter build web --release`. Report `rearch/reports/P6-P1.md`, `## RESULT`. No git ops.
