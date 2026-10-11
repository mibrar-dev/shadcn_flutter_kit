# Brief P3-D — pilot build: `input` (merged with text_field) + `primitives/text_editing.dart`

## Spec
Implement exactly `$KIT/rearch/reports/P3_PILOT_DESIGN.md` §0, §2 and §2.2b (all decisions in §5 USER-APPROVED).
- `primitives/text_editing.dart`: widgets-only selection controls/handles, `TextSelectionGestureDetectorBuilder`
  wiring, default context menu (Cut/Copy/Paste/Select all, labels from `primitives/localizations`). No
  Material/Cupertino.
- `input`: wraps widgets `EditableText`; generic suggestion slot only (autocomplete is NOT built here and must
  never be imported); form integration via `primitives/form_core`.
- Also apply design item T1: edit the one sentence in `$KIT/rearch/reports/OWNERSHIP.md` so spinner `min/max`
  canonical copy is `input/` (one-line change, nothing else in that file).
Where the design says `ASSUMED`, use the real primitive APIs and record deviations. Missing primitive → STOP + report.
Old sources: `$REG/components/**/input*`, `text_field*`. Fix old bugs, never port them.

## Rules
Layers downward only; do not import other components. Files ≤ ~400 lines, no `_impl/`, `part`, `// ignore`,
Material/Cupertino. `input_theme.dart` user-owned const values only.

## Outputs (only these)
- `$APP/lib/registry_next/primitives/text_editing.dart`
- `$APP/lib/registry_next/components/input/{input.dart,input_features.dart (if in design),input_style.dart,input_theme.dart,preview.dart,meta.json,README.md}`
- `$APP/test/registry_next/primitives/text_editing_test.dart`, `$APP/test/registry_next/components/input_test.dart`
  — design §2.7 list incl. tap/double-tap/long-press selection, copy/paste via Clipboard mock, context menu
  items, controller + form validation, disabled/readOnly, theme precedence.
- One-line edit in `$KIT/rearch/reports/OWNERSHIP.md` (T1).
- `$KIT/rearch/reports/P3D_INPUT.md` (old → new mapping, what of the old ~2.5k LOC was replaced vs dropped,
  deviations, LOC, gate output).

## Gates (paste output in the report)
```
cd $APP
dart format --set-exit-if-changed lib/registry_next test/registry_next
dart analyze lib/registry_next test/registry_next                     # 0 issues
flutter test test/registry_next                                        # all green
dart run tool/rearch/check_layers.dart --root lib/registry_next        # 0 errors
dart run tool/rearch/check_single_owner.dart --root lib/registry_next  # 0 duplicates
```
