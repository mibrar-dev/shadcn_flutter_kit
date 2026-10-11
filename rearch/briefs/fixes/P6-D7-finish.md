Finish P6-D7 (brief: rearch/briefs/P6-D7.md). A previous session did most of the work and crashed; the tree is committed
and green (docs analyze 0, 132 tests). Captures already exist in rearch/design/ours/screens (themes-*, component-button-*)
— do NOT re-capture them and do NOT open/read PNG images (it crashes the model); use numeric pixel stats only if needed.

Remaining:
1. Release TypeError `minified:CI is not a subtype of minified:V`: `cd docs && flutter build web --release`, serve
   build/web, open `/`, `/themes`, `/docs/components/button` with agent-browser (short commands) and read the console.
   If it reproduces, build with `--no-minify` (or `--profile`/`--source-maps`) to get real names, find the root cause
   (unsafe `as`/generic in docs code or registry) and fix it + add a test. If it no longer reproduces, say so with the
   console output as evidence.
2. Deep links: confirm cold-loading `/docs/components/button`, `/themes`, `/docs/cli` and the GitHub Pages form
   `/shadcn_flutter_kit/docs/components/button` all open the right page (console clean). Tests exist in
   docs/test/initial_route_test.dart — extend if a case is missing.
3. Write rearch/reports/P6-D7.md: what was built (Theme Studio, site-wide theming of all tokens, Get Code, code teaser,
   scroll fades, member rows, syntax colours), the fixes, gate output, the capture list. `## RESULT` block.
Do NOT touch flutter_shadcn_kit/** (other agents). Gates: docs format/analyze/test/codegen --check/build web --release.
