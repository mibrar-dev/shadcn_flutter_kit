# Brief P4-T5b — syntax highlighter polish (registry only)
1. `$APP/lib/registry/primitives/syntax_highlight/syntax_scanners.dart` is 443 lines → split by language family into files
   ≤ ~400 (e.g. syntax_scanners_c_like.dart, syntax_scanners_markup.dart, syntax_scanners_script.dart); no behaviour change.
2. Per-language golden tests in `$APP/test/registry/primitives/syntax_highlight_test.dart` (or split files): for EACH of
   dart, javascript, typescript, python, json, yaml, bash, html, css, kotlin, swift, markdown — a representative snippet with
   the expected token-kind sequence, incl. edge cases (multi-line strings/comments, Dart `${}` / `$x` interpolation, JS
   template literals, raw strings, escapes, decorators/annotations). Plus a fuzz test running every .dart file in
   lib/registry through the dart scanner (no throw, concatenated span text == input).
3. `$APP/lib/registry/theme/theme.dart` grew to 473 lines — move the syntax token wiring out into `theme/syntax_colors.dart`
   if that brings it back toward ≤ ~450 without changing the public API.
Regenerate manifest; re-sync docs mirror (`$KIT/docs/tool/sync_registry.sh`); regenerate docs data. Do not edit docs/lib
pages/widgets (another agent is). Gates: `$KIT/rearch/qa_gate.sh`, manifest --check, docs `flutter analyze` + codegen/mirror
--check. Report `$KIT/rearch/reports/P4-T5b.md`. `## RESULT` block.
