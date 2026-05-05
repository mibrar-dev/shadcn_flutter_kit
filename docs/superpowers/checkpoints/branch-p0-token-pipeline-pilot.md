# Checkpoint: branch-p0-token-pipeline-pilot
Last updated: 2026-05-05 02:35
Status: IN_PROGRESS

## Completed Steps
- [x] Refactor the button theme pipeline so `button_theme_tokens.dart` is the only independent source of theme values.
- [x] Replace `static const ...Theme? ... = null;` in `button_theme_config.dart` with real resolved theme instances or getters built directly from token constants.
- [x] Convert `button_theme_defaults.dart` into a derived compatibility layer over token values, or remove it for button immediately if the surrounding tooling allows that without churn.
- [x] Make `component_theme_button_style.dart` read the resolved global theme path in a way that changes behavior when token values change.
- [x] Add a narrow test proving that a non-default tokenized value changes the resolved button theme used by the component.
- [x] Run `cd flutter_shadcn_kit && dart run tool/registry/registry_sync_all.dart --force`.
- [x] Verify the docs app still builds after the button pilot sync.
- [x] Run branch-wide package verification: `cd flutter_shadcn_kit && flutter test` and `cd flutter_shadcn_kit && flutter analyze`.
- [x] Validate the pilot in the docs app before merge to main. If the visual or behavioral diff extends beyond intended button theme behavior, stop and fix the branch before merge.
- [x] Document the button pilot pattern in theme tooling docs so Task 4 has a single rollout contract.

## Current Step
Run Task 3 review gates, then commit, push, merge to `main`, and start the next branch from updated `main` if the branch is clean.

## Blocked On
Nothing

## Remaining Steps
- [ ] Refactor the button theme pipeline so `button_theme_tokens.dart` is the only independent source of theme values.
- [ ] Replace `static const ...Theme? ... = null;` in `button_theme_config.dart` with real resolved theme instances or getters built directly from token constants.
- [ ] Convert `button_theme_defaults.dart` into a derived compatibility layer over token values, or remove it for button immediately if the surrounding tooling allows that without churn.
- [ ] Make `component_theme_button_style.dart` read the resolved global theme path in a way that changes behavior when token values change.
- [ ] Add a narrow test proving that a non-default tokenized value changes the resolved button theme used by the component.
- [ ] Run `cd flutter_shadcn_kit && dart run tool/registry/registry_sync_all.dart --force` and verify the docs app still builds.
- [ ] Validate the pilot in the docs app before merge to main. If the visual or behavioral diff extends beyond intended button theme behavior, stop and fix the branch before merge.
- [ ] Document the button pilot pattern in theme tooling docs so Task 4 has a single rollout contract.

## Verification Results
- `dart format flutter_shadcn_kit/lib/registry/components/control/button/_impl/themes/config/button_theme_tokens.dart flutter_shadcn_kit/lib/registry/components/control/button/_impl/themes/config/button_theme_defaults.dart flutter_shadcn_kit/lib/registry/components/control/button/_impl/themes/config/button_theme_config.dart` → ✅ PASS (`Formatted 3 files (0 changed) in 0.01 seconds.`)
- `dart analyze flutter_shadcn_kit/lib/registry/components/control/button/_impl/themes/config/button_theme_tokens.dart flutter_shadcn_kit/lib/registry/components/control/button/_impl/themes/config/button_theme_defaults.dart flutter_shadcn_kit/lib/registry/components/control/button/_impl/themes/config/button_theme_config.dart flutter_shadcn_kit/lib/registry/components/control/button/_impl/styles/component_theme_button_style.dart` → ✅ PASS (`No issues found!`)
- `graphify update .` → ❌ FAIL (`[graphify] WARNING: new graph has 22769 nodes but existing graph.json has 22770. Refusing to overwrite — you may be missing chunk files from a previous session. Pass force=True to override.`)
- `graphify force rebuild via graphify Python runtime` → ✅ PASS (`graph.json` and `GRAPH_REPORT.md` updated in `graphify-out`; HTML viz skipped due graph size)
- `rg -n "extends .*Tokens|class .*Defaults" flutter_shadcn_kit/lib/registry/components/control/button/_impl/themes/config/button_theme_defaults.dart` → ✅ PASS (`All button default classes now extend their corresponding token classes`)
- `rg -n "findGlobal|ButtonThemeConfig\\.resolve<|find\\(context\\)" flutter_shadcn_kit/lib/registry/components/control/button/_impl/styles/component_theme_button_style.dart` → ✅ PASS (`Global button theme resolution still flows through ButtonThemeConfig.resolve<T>() before local widget-tree overrides`)
- `cd flutter_shadcn_kit && flutter test test/registry/components/control/button/component_theme_button_style_test.dart` → ✅ PASS (`00:00 +1: All tests passed!`)
- `cd flutter_shadcn_kit && dart run tool/registry/registry_sync_all.dart --force` → ✅ PASS (`Updated components.json`; `Components: 133`; `Manifest version: 1`; `Meta files updated: 0`)
- `cd docs && flutter analyze && flutter build web` → ✅ PASS (`No issues found!`; `Built build/web`; wasm dry-run warnings only)
- `cd flutter_shadcn_kit && flutter test` → ✅ PASS (`00:00 +2: All tests passed!`)
- `cd flutter_shadcn_kit && flutter analyze` → ✅ PASS (`No issues found!`)
- `docs app pilot validation via Playwright: http://127.0.0.1:7357/#/components/button and http://127.0.0.1:7357/#/components/dropdown-menu` → ✅ PASS (`Both routes rendered cleanly; screenshots captured in button-docs-page.png and dropdown-menu-docs-page.png`)
- `rg -n "Theme Config Rollout Contract|Button pilot reference|Required verification for generated or mirrored theme changes" flutter_shadcn_kit/tool/theme/README.md` → ✅ PASS (`Rollout contract and button pilot references documented in theme tooling README`)

## Files Modified
- `flutter_shadcn_kit/lib/registry/components/control/button/_impl/themes/config/button_theme_tokens.dart`
- `flutter_shadcn_kit/lib/registry/components/control/button/_impl/themes/config/button_theme_defaults.dart`
- `flutter_shadcn_kit/lib/registry/components/control/button/_impl/themes/config/button_theme_config.dart`
- `flutter_shadcn_kit/tool/theme/README.md`
- `flutter_shadcn_kit/test/registry/components/control/button/component_theme_button_style_test.dart`

## Decisions Made
- Active branch initialized to `branch-p0-token-pipeline-pilot`.
- Step counting for Task 3 uses the 8 checkbox steps listed in the plan.
- Implemented the smallest coherent boundary by making token values the sole source, deriving compatibility defaults from token classes, and resolving global button themes directly from token-backed adapters.
- Left `component_theme_button_style.dart` unchanged because it already reads through `ButtonThemeConfig.resolve<T>()`; behavior now changes when token values change without widening the edit scope.
- Forced the Graphify rebuild through the installed Graphify Python runtime because the CLI wrapper still refuses node-count shrink updates without exposing a working force flag.
- Re-ran the docs pilot validation on resume because the previous checkpoint had no recorded result for the active step; treated it as incomplete until new evidence was recorded.
- Chose `flutter_shadcn_kit/tool/theme/README.md` as the rollout-contract home because the contract spans theme generation, token/config invariants, and downstream registry sync rather than a single script.
