# Common rules for every sub-agent (read fully before starting)

You are a sub-agent on the flutter_shadcn_kit re-architecture. An orchestrator (QA lead) will review every
line you produce. Accuracy beats speed. Do not guess: when a fact is not verified from the code, write `UNVERIFIED`.

## Paths
- KIT  = /Users/ibrar/Desktop/infinora.noworkspace/shadcn_copy_paste/shadcn_flutter_kit
- APP  = $KIT/flutter_shadcn_kit            (Flutter project; run flutter/dart commands here)
- REG  = $APP/lib/registry                  (the registry: components/, shared/, manifests/, themes_preset/)
- CLI  = /Users/ibrar/Desktop/infinora.noworkspace/shadcn_copy_paste/shadcn_flutter_cli   (READ ONLY)
- CSS  = /Users/ibrar/Desktop/infinora.noworkspace/shadcn_copy_paste/themes-css           (READ ONLY)
- PLAN = $KIT/REARCHITECTURE_PLAN.md        (read it; it is the source of truth for goals and conventions)

## Hard rules
1. Only create or modify the files listed under "Outputs" in your brief. Everything else is read-only.
2. Never run git commands that change state (no commit, checkout, switch, stash, reset, add, branch). `git log/diff/show` are fine.
3. Never delete files. Never run `flutter pub upgrade` or edit pubspec.yaml unless your brief says so.
4. No Material or Cupertino imports in any Dart you write (`package:flutter/material.dart`, `cupertino.dart`).
5. Dart you write must pass `dart format` and `flutter analyze` with zero issues, without `ignore_for_file`.
6. Prefer `package:analyzer` (already a dev dependency, ^6.4.1, use `parseString` / unresolved AST) over regex for parsing Dart.
7. Keep files under ~400 lines. Clear names, short doc comments only where non-obvious.
8. Large writes get truncated by the tool layer. Write any file longer than ~150 lines in several appended chunks,
   then verify: `grep -n 'truncated' <file>` returns nothing and the file ends where you intended (`tail -5`).

## Finish with a report (last thing you print)
```
## RESULT
status: done | partial | blocked
files_written: [absolute paths]
commands_run: [command -> outcome]
key_findings: [bullets]
open_questions: [bullets]
```
