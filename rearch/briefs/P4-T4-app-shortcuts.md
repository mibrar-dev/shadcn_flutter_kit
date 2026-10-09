# Brief P4-T4 — registry fixes found by the docs build

1. `$APP/lib/registry/components/app/` — `ShadcnApp` passes `shortcuts`/`actions` straight to `WidgetsApp`, which REPLACES
   Flutter's defaults: in any app that sets them, Tab traversal, activation (Enter/Space) and dismissal (Esc) silently
   stop working. Fix: merge — `{...WidgetsApp.defaultShortcuts, ...?shortcuts}` and the same for actions (caller entries win);
   document it; regression tests: with custom shortcuts supplied, Tab still moves focus, Enter activates a button, Esc
   dismisses a dialog. Then remove the docs app workaround (`$KIT/docs/lib/main.dart` or wherever it spreads the defaults)
   so the docs rely on the fixed component.
2. `primitives/table_layout/` — the docs suite hit a "negative minimum width" assert in a deep retained route stack
   (suspect table_layout sizing). Reproduce with a widget test (narrow constraints, resized columns, zero-width viewport),
   find the root cause, clamp correctly, regression test.
3. `components/formatter` + `components/color`: the docs API tables show `TimeFormatter` / 0 rows because the primary
   public API is a factory set / no-arg ctor. Make each component's `meta.json` `api` name its real primary entry points so
   the docs codegen picks them (coordinate: only meta.json + README here; the docs codegen reads them).
After: regenerate manifest, re-sync docs mirror (`$KIT/docs/tool/sync_registry.sh`), regenerate docs data.
Gates: `$KIT/rearch/qa_gate.sh`; `cd $APP && flutter analyze`; docs `flutter analyze && flutter test`; CLI e2e
(`cd $CLI && dart test -t e2e --run-skipped test/e2e/acceptance_test.dart`). Report `$KIT/rearch/reports/P4-T4.md`, `## RESULT`.
