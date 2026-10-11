# Brief P4-T3 — remove per-file `// @dart=3.13` pins; one consistent SDK floor

17 files in `$APP/lib/registry/**` start with `// @dart=3.13` (added during the flutter_lints work), while
`$APP/pubspec.yaml` says `sdk: ^3.12.0` and `$KIT/docs/pubspec.yaml` says `^3.10.7`. Per-library version pins are wrong
for copy-paste source (they leak into users' apps). Fix:
1. Find which language feature each pinned file needs (`grep -n "^// @dart" -r lib/registry`; remove a pin and analyze).
2. Remove ALL `// @dart=` pins from lib/registry. Set ONE SDK floor = the minimum version supporting every feature used
   (likely ^3.12.0 or ^3.13.0 — prove it) in `$APP/pubspec.yaml`, `$KIT/docs/pubspec.yaml`, and the CLI's install docs /
   `init` pubspec check if it has one (`$CLI` — README/doc + any sdk constraint check; edit only those lines).
3. Prove `keyboard_shortcut` (which uses Dart private named parameters `this._keys`) is usable from OUTSIDE its library:
   add a test in a separate file that constructs it with the public parameter names.
4. Regenerate manifest (`dart run tool/registry/gen_registry_manifest.dart`), re-sync docs mirror
   (`$KIT/docs/tool/sync_registry.sh`), regenerate docs data (`dart run tool/gen_docs_data.dart`).
Gates: `$KIT/rearch/qa_gate.sh` clean; `cd $APP && flutter analyze` 0; `cd $KIT/docs && flutter analyze && flutter test`;
`grep -rn "^// @dart" $APP/lib/registry $KIT/docs/lib` empty; CLI `dart test -t e2e --run-skipped test/e2e/acceptance_test.dart`
green. Report `$KIT/rearch/reports/P4-T3.md`, `## RESULT` block.
