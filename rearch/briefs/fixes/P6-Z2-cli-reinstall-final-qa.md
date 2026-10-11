# Brief P6-Z2 — CLI reinstall into the docs app + final full QA (report; fix only what fails)

KIT=/Users/ibrar/Desktop/infinora.noworkspace/shadcn_copy_paste/shadcn_flutter_kit (APP=$KIT/flutter_shadcn_kit,
DOCS=$KIT/docs), CLI=/Users/ibrar/Desktop/infinora.noworkspace/shadcn_copy_paste/shadcn_flutter_cli (branch
refactor/rearchitecture; never touch main). Do NOT open PNGs yourself (model crashes on images).

1. CLI reinstall acceptance: in a temporary copy of the docs app (`cp -R $DOCS /tmp/docs_cli_check` — never modify
   $DOCS for this step), delete `lib/ui/shadcn/`, then use the CLI (`dart run $CLI/bin/shadcn.dart --registry
   $APP/lib/registry ...`) to `init` (if needed) and `add` every component listed in the mirror plus all 16 blocks.
   Compare the result with `$DOCS/lib/ui/shadcn/` (`diff -r`): it must be identical except files the docs mirror
   intentionally adds/excludes (document each difference and whether it is expected). Then `flutter analyze` and
   `flutter test` the temp copy. Any unexpected difference = bug: fix it in the CLI or the sync script (minimal) and
   re-run.
2. Final full QA (paste outputs): `$KIT/rearch/qa_gate.sh`; manifest/previews/blocks generators `--check`;
   check_layers/check_single_owner/check_user_theme; docs format/analyze/test/codegen --check/sync --check/
   `flutter build web --release`; CLI format/analyze/test + `dart test -t e2e --run-skipped test/e2e/acceptance_test.dart`;
   `grep -rn "package:flutter/(material|cupertino)" $APP/lib/registry $DOCS/lib` must be empty; investigate the
   reported flaky markdown network-image tests (make them hermetic if flaky).
3. Write `$KIT/rearch/reports/P6_FINAL_QA.md`: per gate PASS/FAIL with numbers, CLI reinstall diff summary, known
   follow-ups (from rearch/reports/QA_LOG.md), and a PR summary draft (what changed in kit, CLI, docs; migration = clean
   break). `## RESULT` block. No git ops.
