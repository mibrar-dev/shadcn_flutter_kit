# Brief P4-Z — execute the registry cutover (USER-APPROVED 2026-10-09)

Ibrar approved: replace `flutter_shadcn_kit/lib/registry/` with `lib/registry_next/`, delete the old tree, rewrite
imports, regenerate manifests, drop the unused packages. Follow `$KIT/rearch/reports/P4_CUTOVER.md` (plan + inventory)
and use `$KIT/rearch/cutover.sh` for the mechanical steps. You are allowed to run `rearch/cutover.sh --apply` and the git
operations it performs (git mv / git rm) — this OVERRIDES hard rule 2 of _common.md for those commands only. Do NOT
commit or push; the orchestrator commits.

## Steps
1. Preconditions: `rearch/cutover.sh` (dry-run) shows 0 blockers; working tree clean except your own changes.
2. Run the cutover (rename trees, delete old, rewrite `registry_next/` → `registry/`).
3. Manual rewrites (P4_CUTOVER.md §7): every file outside the registry that imports old category paths
   (`registry/components/<category>/<name>/…`, `registry/shared/…`, `registry/themes_preset/…`) — `lib/flutter_shadcn_kit.dart`
   barrel, `lib/main.dart`, `lib/examples/**`, `tool/**`, `test/**`, `docs/lib/**` mirror if it imports the kit tree —
   rewritten to the flat layout or deleted if obsolete (list each).
4. Manifest: implement `tool/registry/gen_registry_manifest.dart` producing `lib/registry/manifests/registry.json` that
   validates against `$KIT/rearch/reports/registry_manifest.v2.schema.json` (from P5-A; if that file is missing, STOP and
   report). Data comes from each `components/*/meta.json` + the primitives/foundation/theme trees + `themes/`. Add a test
   that the generated manifest is up to date and schema-valid, and that every component's dependency closure exists.
   Retire old manifest generators/old manifests that only served the old layout (list them).
5. Old tests: retire `test/registry/**` that target the old tree; keep/port anything still meaningful (list).
6. pubspec: remove the packages that are no longer imported anywhere in `flutter_shadcn_kit` (expected: data_widget,
   gap, phonecodes, country_flags, cross_file, web, skeletonizer, animation_kit, email_validator — verify each with grep
   before removing; keep intl, flutter_localizations, expressions or anything still used). `flutter pub get`.
7. Tooling defaults: `tool/rearch/check_*.dart` default `--root` → `lib/registry` (new layout); update
   `rearch/qa_gate.sh` / `rearch/qa_batch.sh` paths from registry_next → registry and test/registry_next → test/registry
   (move `test/registry_next/**` → `test/registry/**`).
8. Gates: `flutter analyze` (whole project) 0 issues; `flutter test` (whole project) all green;
   `dart run tool/rearch/check_layers.dart --strict`, `check_single_owner.dart --strict`, `check_user_theme.dart --strict`
   all clean; `rearch/qa_gate.sh` clean.

## Outputs
Everything the steps above touch inside `$APP` and `$KIT/rearch/{qa_gate.sh,qa_batch.sh}`, plus
`$KIT/rearch/reports/P4_CUTOVER_RESULT.md` (what moved/was deleted/rewritten, packages removed, gate output).
Finish with the `## RESULT` block.
