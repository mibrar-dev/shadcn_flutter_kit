# Brief P3-T — teach `check_layers` the registry_next dependency format (tooling, mechanical)

## Problem
`dart run tool/rearch/check_layers.dart --root lib/registry_next` reports `undeclared-dependency: 7 (error)` for the
new pilot components. Root cause: `tool/rearch/src/layer_checks.dart:~268` → `manifests.dart:loadSharedIdsByRelPath`
only reads the OLD tree's `shared/shared_manifest.json` + `manifests/components.json`, which do not exist in
`registry_next`.

## New format (source of truth for registry_next)
Each component has `components/<id>/meta.json` with
`"deps": {"foundation": [...], "theme": [...], "primitives": [...], "components": [...]}` where each entry is a file
stem (e.g. `foundation: ["data"]` = `registry_next/foundation/data.dart`; `primitives: ["form_core"]` may name a
folder `primitives/form_core/`). Example: `lib/registry_next/components/dialog/meta.json`.

## Do
1. When the root contains `components/*/meta.json` with a `deps` object (registry_next mode), check each component's
   imports against its own `deps`:
   - import of foundation/theme/primitives/components file not declared → `undeclared-dependency` (error)
   - declared dep never imported by any file of the component → `unused-dependency` (warning)
   - import of another component when `deps.components` does not list it → error (install-alone rule)
   Old-tree behaviour must stay exactly as it is (run the existing tests).
2. Tests in `test/rearch/` with small fixture trees: declared OK, undeclared, unused, folder-style primitive dep.
3. Update `tool/rearch/README` (or the checker's doc comment) with the new mode.

## Outputs (only these)
`$APP/tool/rearch/**`, `$APP/test/rearch/**`. Do NOT edit anything under `lib/`.

## Gates
```
cd $APP
dart format --set-exit-if-changed tool/rearch test/rearch
dart analyze tool/rearch test/rearch                                   # 0 issues
flutter test test/rearch                                               # all green
dart run tool/rearch/check_layers.dart --root lib/registry_next        # paste output (other agents are writing
                                                                       # components now; list remaining findings)
dart run tool/rearch/check_layers.dart --root lib/registry             # unchanged vs before your change
```
