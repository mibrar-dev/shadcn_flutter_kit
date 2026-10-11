# Brief P6-H1 — home page: richer, more beautiful component showcase (shadcn home)

`KIT=/Users/ibrar/Desktop/infinora.noworkspace/shadcn_copy_paste/shadcn_flutter_kit`, `DOCS=$KIT/docs`. Read
`rearch/reports/P6_SHADCN_SITE_SPEC.md`, `P6-T1.md` (masonry primitive + studio blocks you can reuse), reference
`rearch/design/shadcn-ref/screens/home-1440-*.png` (do NOT open PNGs yourself — model crashes on images) and the live
https://ui.shadcn.com home (agent-browser, SHORT commands; list exactly which cards/sections it shows).

User request (2026-10-10): the home screen needs MANY more components, and they must look beautiful like shadcn's
(composed, realistic cards — not bare standard widgets), with shadcn spacing/typography.

## Do
- Rebuild the landing showcase (`landing_page.dart`, `collage*.dart`) like ui.shadcn.com home: hero + CTA, then the
  example showcase (shadcn's examples tabs if present: e.g. Examples / Dashboard / Tasks / Playground / Authentication
  — implement each as a composed page using registry components, or the card collage exactly as shadcn shows), on the
  registry masonry primitive; ≥ 30 composed cards/sections covering forms, overlays (opened demos), data display,
  navigation, feedback, date/time, charts-like stats, chat, settings, auth.
- Reuse/extend the Theme Studio blocks where identical; every card follows the live theme (colours, radius,
  density, fonts, shadows), light + dark, 375→1440, no fixed heights, no overflow.
Do NOT touch Theme Studio rail files or Blocks pages. Gates: docs format/analyze/test/codegen --check/build web
--release; widget tests (no overflow at 375/768/1440, theme follows). Captures via agent-browser to
`rearch/design/ours/screens/home-v2-*.png`. Report `$KIT/rearch/reports/P6-H1.md`, `## RESULT`. No git ops.
