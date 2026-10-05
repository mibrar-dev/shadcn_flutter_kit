# Brief P2-C — Guardrail tooling updates

## Context
`$APP/tool/rearch/` (check_single_owner, check_layers, api_snapshot) gate all work. New architecture is built
in `$APP/lib/registry_next/` with layers at the root: `foundation/`, `theme/`, `primitives/`, `components/<name>/`
(flat — no category folders), plus `themes/` (preset JSON). Read PLAN §3–§6 and the existing scripts + tests first.
Other agents are writing into `lib/registry_next/` concurrently — do NOT touch it.

## Changes
1. `check_layers.dart`
   - Exclude `preview.dart` files from `undeclared-dependency` (keep them in every other rule).
   - New rule `installable` (error): for every directory directly under `components/`:
     has `meta.json`; meta `id` == directory name; entry file `<dir>.dart` exists; every file listed in meta.json
     `files` (if present) exists. Report missing items per component.
   - New rule `no-impl-dir` (error) for the new tree only: no `_impl/` directory under `components/` (old tree is
     allowed; enable via `--new-layout`, default on when root ends with `registry_next`).
   - Make layer detection work for both trees: old (`shared/**`, `components/<category>/<name>`) and new
     (`foundation|theme|primitives|components/<name>` at root). Document it.
2. New `check_user_theme.dart`: validates user-owned component theme files (`components/<name>/<name>_theme.dart`
   in the new tree): only `import` of `package:flutter/widgets.dart` and `<name>_style.dart` / `../../theme/*.dart`;
   only top-level `const` variable declarations; no function declarations, no closures/function expressions,
   no `resolveWith`, no non-const constructor calls. Flags `--json`, `--strict`.
3. Tests for every new rule with fixtures under `$APP/test/rearch/fixtures/` (add a `next_layout/` fixture tree
   with a good component, one missing entry file, one id≠dir, one with `_impl/`, a valid and an invalid user theme file).
4. Update `$KIT/rearch/reports/BASELINE_GUARDRAILS.md` with a short "new rules" section and re-run the baseline on
   the OLD tree to record the `installable` count (expect tab_list to fail; list all failures).

## Outputs (only these)
`$APP/tool/rearch/**`, `$APP/test/rearch/**`, `$KIT/rearch/reports/BASELINE_GUARDRAILS.md`,
`$KIT/rearch/reports/baseline/*.json`.

## Gates
```
cd $APP
dart format --set-exit-if-changed tool/rearch test/rearch
dart analyze tool/rearch test/rearch          # 0 issues
flutter test test/rearch                      # all green (existing 27 + new)
```
