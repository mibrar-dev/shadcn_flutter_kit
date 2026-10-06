# Brief P3-C — pilot build: `dialog`

## Spec
Implement exactly `$KIT/rearch/reports/P3_PILOT_DESIGN.md` §0 and §3 (all decisions in §5 are USER-APPROVED:
`showShadcnDialog`, Navigator route only, default barrier black alpha 0.5, Escape dismisses).
Where the design says `ASSUMED` for a primitive API, read the real code in `$APP/lib/registry_next/primitives/`
and use it; record every deviation in your report. If a needed primitive is missing or broken, STOP and report.
Old sources: `$REG/components/**/dialog*`. Drop Material `RawDialogRoute`/`Colors`; use widgets `ModalRoute`/
`PageRoute`/`RawDialogRoute` from `package:flutter/widgets.dart` only. Fix old bugs, never port them.
Do NOT import the `button` component (another agent builds it in parallel); dialog actions are caller-supplied widgets.

## Rules
Layers downward only. Files ≤ ~400 lines, no `_impl/`, `part`, `// ignore`, Material/Cupertino. `dialog_theme.dart`
is user-owned: const values only. Focus is trapped inside the dialog and restored to the previous node on close.

## Outputs (only these)
- `$APP/lib/registry_next/components/dialog/{dialog.dart,dialog_style.dart,dialog_theme.dart,preview.dart,meta.json,README.md}`
- `$APP/test/registry_next/components/dialog_test.dart` — design §3.7 list, incl. barrier tap dismiss (and
  `barrierDismissible: false`), Escape, focus trap + restore, result value returned from `showShadcnDialog`,
  theme precedence, barrier colour default = black a0.5.
- `$KIT/rearch/reports/P3C_DIALOG.md` (old → new mapping, deviations, LOC, gate output).

## Gates (paste output in the report)
```
cd $APP
dart format --set-exit-if-changed lib/registry_next/components/dialog test/registry_next/components/dialog_test.dart
dart analyze lib/registry_next test/registry_next                     # 0 issues in your files
flutter test test/registry_next/components/dialog_test.dart           # all green
dart run tool/rearch/check_layers.dart --root lib/registry_next        # 0 errors
dart run tool/rearch/check_single_owner.dart --root lib/registry_next  # 0 duplicates
```
