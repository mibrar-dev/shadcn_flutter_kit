Round 2 for P6-D2b — your new test is right and it FAILS: `flutter test tool/gen_docs_data_test.dart` → +25 −1:
"every declared api.methods/constants/functions name resolves" → `button` (and possibly others after it) declares api names
that do not exist in the source. Run the WHOLE test file (you only ran your new cases). Fix the DATA, not the test:
correct every `$APP/lib/registry/components/*/meta.json` `api` entry that does not resolve to a real public member (make the
test report ALL failing components at once first), regenerate the kit manifest (`dart run tool/registry/gen_registry_manifest.dart`),
re-sync the docs mirror (`tool/sync_registry.sh`), regenerate docs data. Gates: docs `flutter test` (all, incl. tool/),
`flutter analyze`, `--check`; kit `rearch/qa_gate.sh` + manifest `--check`. `## RESULT` block.
