# Brief P4-T1 — bump the kit's analyzer dev dependency so guardrail tools parse every file (small, mechanical)

`flutter_shadcn_kit/pubspec.yaml` has `analyzer: ^6.4.1` (dev). It cannot parse Dart 3.8+ syntax (null-aware elements):
`dart run tool/rearch/check_layers.dart` reports "9 files with syntax errors" and docs codegen flags 3 entry files
(badge, scaffold, swiper) `parseClean: false`. Bump `analyzer` to the newest version compatible with the Flutter SDK
in use (`flutter --version`; resolve with `flutter pub get`), fix any API changes in `flutter_shadcn_kit/tool/rearch/**`
and `tool/registry/**`, and in `$KIT/docs/tool/gen_docs_data.dart` if it uses analyzer (docs/pubspec.yaml too).
Gates: `cd $APP && flutter test test/rearch test/registry` green; `dart run tool/rearch/check_layers.dart --strict` shows
**0 files with syntax errors**; `check_single_owner --strict` and `check_user_theme --strict` clean;
`dart run tool/registry/gen_registry_manifest.dart --check` up to date; `cd $KIT/docs && dart run tool/gen_docs_data.dart
--check` up to date with parseClean true for all 118. Outputs: the pubspecs/locks, tool/** fixes, regenerated files if
they change, `$KIT/rearch/reports/P4-T1.md`. Do not touch lib/registry/** or docs/lib/** pages. `## RESULT` block.
