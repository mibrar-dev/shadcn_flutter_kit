# Brief P3-B — pilot build: `button` (+ button_group) and `toggle`

## Spec
Implement exactly `$KIT/rearch/reports/P3_PILOT_DESIGN.md` §0 and §1 (all decisions in §5 are USER-APPROVED).
Note the "ORCHESTRATOR QA FIX" above the §1.4 table: disabled = rest colours with the whole button at opacity 0.5.
Where the design says `ASSUMED` for a primitive API, read the real code in `$APP/lib/registry_next/primitives/`
and use it; record every deviation from the design in your report. If a needed primitive is missing or broken,
STOP and report — do not write a local copy.
Old sources: `$REG/components/**/button*`, `toggle`, `button_group`. Fix old bugs, never port them.

## Rules
Layers downward only (components import primitives/theme/foundation, never another component). Files ≤ ~400 lines,
no `_impl/`, `part`, `// ignore`, Material/Cupertino. `<name>_theme.dart` is user-owned: const values only
(must pass `dart run tool/rearch/check_user_theme.dart`). Variants are enum + exhaustive table.

## Outputs (only these)
- `$APP/lib/registry_next/components/button/{button.dart,button_style.dart,button_theme.dart,button_group.dart,preview.dart,meta.json,README.md}`
- `$APP/lib/registry_next/components/toggle/{toggle.dart,toggle_style.dart,toggle_theme.dart,preview.dart,meta.json,README.md}`
- `$APP/test/registry_next/components/{button,toggle}_test.dart` — the test list in design §1.9, plus: disabled
  label is readable (fg != bg) and opacity 0.5; per-field theme precedence (widget arg > ComponentTheme > app
  ComponentThemes > tokens); keyboard Enter/Space activation; focus ring shows on keyboard focus only.
- `$KIT/rearch/reports/P3B_BUTTON.md` (old → new mapping, deviations from design, LOC, gate output).

## Gates (paste output in the report)
```
cd $APP
dart format --set-exit-if-changed lib/registry_next test/registry_next
dart analyze lib/registry_next test/registry_next                     # 0 issues
flutter test test/registry_next                                        # all green
dart run tool/rearch/check_layers.dart --root lib/registry_next        # 0 errors
dart run tool/rearch/check_single_owner.dart --root lib/registry_next  # 0 duplicates
dart run tool/rearch/check_user_theme.dart --root lib/registry_next    # 0 errors (see tool for exact flags)
```
