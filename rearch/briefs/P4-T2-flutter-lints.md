# Brief P4-T2 — registry files must pass a fresh app's default lints

The CLI e2e test (`$CLI/test/e2e/acceptance_test.dart`, run with `dart test -t e2e --run-skipped`) showed that registry
files installed into a fresh `flutter create` app fail its default lints (`package:flutter_lints/flutter.yaml`). The CLI
currently papers over it by writing a nested `analysis_options.yaml` into the install root. Fix it at the source:
1. In `$APP` add `flutter_lints` (dev) and make `$APP/analysis_options.yaml` include `package:flutter_lints/flutter.yaml`
   (keep any stricter existing rules). Run `flutter analyze` and fix every finding in `lib/registry/**` (and tests/tools
   if they now fail) — real fixes, no `// ignore`, no rule disabling.
2. Regenerate the manifest (`dart run tool/registry/gen_registry_manifest.dart`) — hashes change — and re-sync the docs
   mirror (`$KIT/docs/tool/sync_registry.sh`) + regenerate docs data (`cd $KIT/docs && dart run tool/gen_docs_data.dart`).
3. In `$CLI`: remove the nested analysis_options.yaml writer and its tests; the e2e must pass WITHOUT it
   (`cd $CLI && dart test -t e2e --run-skipped test/e2e/acceptance_test.dart`). You may edit those CLI files only.
Gates: `$KIT/rearch/qa_gate.sh` clean; `cd $APP && flutter analyze` 0; manifest --check; CLI `dart analyze` 0 + `dart test`
green + e2e green. Another agent edits `$APP/tool/**` + pubspec for an analyzer bump (P4-T1) — coordinate by only adding
`flutter_lints` to pubspec and not touching tool/**. Report `$KIT/rearch/reports/P4-T2.md`. `## RESULT` block.
