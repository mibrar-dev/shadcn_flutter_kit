# Brief P6-F2 — fix theme-dependent colours + code selectability (registry)

`KIT=/Users/ibrar/Desktop/infinora.noworkspace/shadcn_copy_paste/shadcn_flutter_kit`, `APP=$KIT/flutter_shadcn_kit`.
Read first: `$KIT/rearch/reports/P6_THEME_AUDIT.md` (§4 fix list) + `p6_theme_audit.json`.

User requirement: every component follows the selected theme live, in light and dark; code is selectable + copyable.

## Do
1. Fix all 19 "fix" literals: gooey_toast (status tones → chart1..chart5, destructive, mutedForeground as proposed),
   gooey_surface, overflow_marquee + number_ticker + scrollable edge fades (fade to the actual surface token, correct
   in dark), feature_carousel, tracker (fine/warning → theme tokens: chart2 / chart4 or the closest semantic token —
   document the choice). Colours via `ThemedColor.ref(...)`, resolved in build; alpha multiplies.
2. `code_snippet`: make text selectable + copyable with widgets-only `SelectableRegion`/`SelectionArea` around the
   existing `Text.rich` — syntax colours identical; copy button still works; keyboard select-all/copy works.
   Also check `markdown` fenced code and make it selectable the same way.
3. Remove the `skip:` in `$APP/test/registry/theme_audit/**`; add tests for each fixed component under neutral/claude/
   tangerine light+dark + runtime theme swap; add a selection test (drag/select-all → clipboard has the code).

## Do NOT touch
`docs/**` (another agent), and components owned by P6-F1 (chip, badge, input, table, select, menu*, tabs, and
`primitives/`/`theme/` spacing). If a colour fix needs a primitive change, keep it minimal and list it. No docs
sync. No git state changes.

## Rules
Registry rules unchanged (layers, ≤ ~400 lines/file, no Material/Cupertino, no `// ignore`, meta.json deps = imports,
user-owned `_theme.dart` const only, clean break).

## Gates (paste output)
```
cd $KIT && rearch/qa_gate.sh
cd $APP && flutter test test/registry/theme_audit && grep -rn "skip:" test/registry/theme_audit
dart run tool/registry/gen_registry_manifest.dart --check
```
Report `$KIT/rearch/reports/P6-F2.md`. `## RESULT` block.
