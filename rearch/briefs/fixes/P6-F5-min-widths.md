# Brief P6-F5 — Pagination, Calendar, InputOtp must shrink to narrow columns

`APP=/Users/ibrar/Desktop/infinora.noworkspace/shadcn_copy_paste/shadcn_flutter_kit/flutter_shadcn_kit`.
Found by P6-T1 (`rearch/reports/P6-T1.md`): these three registry components cannot lay out in a ~300 px masonry column
(or a 375 px phone minus padding), so docs blocks have to scroll them horizontally. Fix at the root in each component
(shadcn behaviour: pagination collapses to prev/ellipsis/current/next; calendar cells shrink to the available width with
a sensible minimum ~ 7×32 px; input-otp slots shrink/stay square within bounds) — theme spacing/density tokens only,
no fixed widths. Keep the public API (additive only), keep layout_audit/theme_audit/previews tests green, add width
tests at 240/300/375 px (no overflow, all controls reachable).
Only touch `components/{pagination,calendar,input_otp}/**` + their tests. No meta.json edits (another agent), no docs,
no git ops. Gates: `cd $APP && flutter analyze lib/registry && flutter test test/registry` (all green).
Report `rearch/reports/P6-F5.md` with `## RESULT`.
