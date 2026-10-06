# Handoff — flutter_shadcn_kit re-architecture

Use this when the current orchestrator session ends. It explains the project, how work is run, and gives a
ready-to-paste prompt for the next agent. Current state lives in `rearch/PROGRESS.md` (always read it first).

## Key paths
| What | Absolute path |
|---|---|
| Kit repo (git, branch `refactor/rearchitecture`) | /Users/ibrar/Desktop/infinora.noworkspace/shadcn_copy_paste/shadcn_flutter_kit |
| Flutter app / registry host | /Users/ibrar/Desktop/infinora.noworkspace/shadcn_copy_paste/shadcn_flutter_kit/flutter_shadcn_kit |
| Old registry (untouched until cutover) | …/shadcn_flutter_kit/flutter_shadcn_kit/lib/registry |
| New registry being built | …/shadcn_flutter_kit/flutter_shadcn_kit/lib/registry_next |
| Guardrail scripts | …/shadcn_flutter_kit/flutter_shadcn_kit/tool/rearch |
| Plan (source of truth) | /Users/ibrar/Desktop/infinora.noworkspace/shadcn_copy_paste/shadcn_flutter_kit/REARCHITECTURE_PLAN.md |
| Progress | /Users/ibrar/Desktop/infinora.noworkspace/shadcn_copy_paste/shadcn_flutter_kit/rearch/PROGRESS.md |
| QA verdicts | /Users/ibrar/Desktop/infinora.noworkspace/shadcn_copy_paste/shadcn_flutter_kit/rearch/reports/QA_LOG.md |
| Agent briefs | /Users/ibrar/Desktop/infinora.noworkspace/shadcn_copy_paste/shadcn_flutter_kit/rearch/briefs/ |
| Agent logs (gitignored) | /Users/ibrar/Desktop/infinora.noworkspace/shadcn_copy_paste/shadcn_flutter_kit/rearch/logs/ |
| CLI repo (READ ONLY until Phase 5; 4 uncommitted files on main) | /Users/ibrar/Desktop/infinora.noworkspace/shadcn_copy_paste/shadcn_flutter_cli |
| shadcn CSS theme fixtures | /Users/ibrar/Desktop/infinora.noworkspace/shadcn_copy_paste/themes-css |

## Repositories & branches (snapshot 2026-10-06 01:45 — re-check with the commands below)
Workspace root `/Users/ibrar/Desktop/infinora.noworkspace/shadcn_copy_paste` is NOT a git repo; it holds several.

### 1. Kit — `/Users/ibrar/Desktop/infinora.noworkspace/shadcn_copy_paste/shadcn_flutter_kit`
Remote: `origin https://github.com/mibrar-dev/shadcn_flutter_kit.git`
| Branch | Head | Tracks | Notes |
|---|---|---|---|
| `main` | f4f48d8 | origin/main | published baseline |
| `chore/upstream-parity-audit` | ef06f55 | origin/chore/upstream-parity-audit (pushed 2026-10-06) | 35 commits ahead of main (docs previews, registry fixes); base of the refactor |
| `refactor/rearchitecture` ← **work happens here** | see `git log -1` | origin/refactor/rearchitecture (pushed; push after every commit) | branched from `chore/upstream-parity-audit` at ef06f55; all re-architecture commits |
- Contains: `flutter_shadcn_kit/` (Flutter app hosting the registry; old `lib/registry/`, new `lib/registry_next/`,
  guardrails `tool/rearch/`), `docs/` (Flutter web docs gallery = the "demo mode"; has a mirror of the registry under
  `docs/lib/ui/shadcn/`), `REARCHITECTURE_PLAN.md`, `rearch/` (briefs, reports, logs, handoff, progress).
- **User rule (2026-10-06): commit AND push after every accepted step** so everything is always backed up
  (`git push` on `refactor/rearchitecture`). Pushing these branches is pre-approved; anything else outward-facing
  (PRs, merging to main, publishing to pub.dev, force-push) still needs the user's OK.
- Only one worktree (the main checkout); no stashes.

### 2. CLI — `/Users/ibrar/Desktop/infinora.noworkspace/shadcn_copy_paste/shadcn_flutter_cli`
Remote: `origin https://github.com/mibrar-dev/flutter_shadcn_cli.git`. Branch `main` (tracks origin/main), head
02003d1 "Merge 0.2.7 line into main (fork reunion + 160/160)".
- **Uncommitted user work on main — do not discard**: 7 files, +918/−101 —
  `lib/src/application/services/installer/{component_manifest_resolver,installer,installer_file_install_part,installer_platform_alias_part}.dart`,
  `test/component_manifest_resolver_test.dart`, `test/installer_test.dart`, `pubspec.lock` (+ untracked `.DS_Store`).
  Backed up WITHOUT touching the working tree: remote branch `backup/installer-wip-2026-10-06` (eae8111, includes
  the untracked `test/installer_alias_part_test.dart`; someone is actively editing here). Refresh the backup the same
  way when the WIP changes: temp `GIT_INDEX_FILE` → `git add -A -- . ':!.DS_Store'` → `git write-tree` →
  `git commit-tree <tree> -p HEAD` → `git push origin "${SHA}:refs/heads/backup/<name>-<date>"` (braces matter in zsh).
  Phase 5 plan: review these with the user, commit them on a new branch (e.g. `chore/installer-wip`), then branch
  `refactor/rearchitecture-cli` for the CLI changes. READ ONLY until Phase 5.
- CLI docs worth reading in Phase 5: `PROGRESS.md`, `PLAN.md`, `doc/architecture/*.md`, `README.md`.
- The CLI holds the ORIGINAL tweakcn preset atoms: `lib/registry/shared/theme/preset_theme_data.dart` (used by P2-D).

### 3. Other repos in the workspace (not part of this work unless the user says so)
- `/Users/ibrar/Desktop/infinora.noworkspace/shadcn_copy_paste/registry-directory` (head 1764475 "fix: pin official
  registry to fixed kit manifest") — registry directory used by the CLI's multi-registry feature; will need its kit
  manifest pin updated after the cutover (Phase 5).
- `/Users/ibrar/Desktop/infinora.noworkspace/shadcn_copy_paste/canvas` — unrelated.
- Non-repo folders: `themes-css/` (12 shadcn CSS fixtures), `test_project/`, `flutter_cli_verify_test/` (CLI smoke apps).

### Commands to refresh this snapshot
```
K=/Users/ibrar/Desktop/infinora.noworkspace/shadcn_copy_paste/shadcn_flutter_kit
C=/Users/ibrar/Desktop/infinora.noworkspace/shadcn_copy_paste/shadcn_flutter_cli
git -C $K branch -vv; git -C $K status --short; git -C $K log --oneline -15
git -C $C branch -vv; git -C $C status --short; git -C $C diff --stat
ps -eo pid,etime,args | grep "opencode run"; opencode session list | grep rearch
```

## How work is run
- Launch a sub-agent: `rearch/run_agent.sh "<provider/model#variant>" rearch/briefs/<brief>.md <log-name>`
  (prepends `rearch/briefs/_common.md`; runs `opencode run --auto` from the kit root; log → `rearch/logs/<log-name>.log`).
- Send fixes to the same agent: write the fix list to `rearch/briefs/fixes/<unit>-rN.md`, then
  `rearch/continue_agent.sh <session-id> "<model#variant>" rearch/briefs/fixes/<unit>-rN.md <log-name>`.
  Session ids: `opencode session list` (titles are `rearch:<unit>`).
- Run agents in the background; start them a few seconds apart; a log still at 0 bytes after ~2 minutes means a
  hung start → kill that `opencode run` pid and relaunch.
- QA every result yourself: re-run all gates in the brief, read the critical code, compare claims to the source.
  Never accept an agent's self-report alone (past catches: truncated files, override-never-applies merge bug,
  alpha replace-vs-multiply, wrong shadow formula, global mutable registry, ignore comments).
- Record each verdict in QA_LOG.md; commit only accepted paths, then `git push` immediately; end commit messages with
  `Co-Authored-By: Claude Opus 5.5 (1M context) <noreply@anthropic.com>` (or your own attribution line).
- After each step update `rearch/PROGRESS.md`.

## Standard gates (run from flutter_shadcn_kit/)
```
dart format --set-exit-if-changed <paths>
dart analyze <paths>                                         # 0 issues
flutter test <test paths>                                    # all green
dart run tool/rearch/check_layers.dart --root lib/registry_next
dart run tool/rearch/check_single_owner.dart --root lib/registry_next
flutter analyze lib/registry                                 # old tree must keep compiling
```


## Prompt for the next agent (copy everything in the block)
````
You are taking over the flutter_shadcn_kit re-architecture as ORCHESTRATOR and QA REVIEWER.

YOUR ROLE
- You do NOT do the heavy work yourself. You plan, write exact briefs, launch OpenCode sub-agents, and QA-review every
  result. All heavy coding/analysis goes to OpenCode sub-agents. NEVER spawn Claude sub-agents. Gemini/Antigravity
  were dropped by the user.
- Sub-agent models (OpenCode Go/Zen, pass as provider/model#variant):
  - opencode-go/muse-spark-1.3-contributor#xhigh — architect/designer and QA reviewer
  - opencode-go/deepseek-v4.1-flash#max — builder A
  - opencode-go/space-bunny-free#max — builder B / bug hunter
  - opencode/fledge-alpha-free — mechanical tasks (tooling, manifests)
  - opencode-go/deepseek-v4-flash-vision-exp — UI screenshot checks
- Loop for every unit of work: plan → build → test → QA review → UI check → bug hunt → repeat until accepted.
- QA means: re-run every gate yourself, read the critical code, compare claims against the source. Never accept an
  agent's self-report alone. Past catches you must keep looking for: truncated files, a merge that let defaults
  always win, alpha replaced instead of multiplied, a shadow formula that only worked for default values, global
  mutable state, `// ignore` comments, transparent fallback colours, old bugs ported "faithfully".
- The user is Ibrar. After EVERY accepted step: commit (end the message with your attribution line) and
  `git push` (pre-approved backup rule). Ask before anything else outward-facing or destructive (PRs, merging to
  main, publishing, force-push, deleting user work).

THE PROJECT
flutter_shadcn_kit is a shadcn/ui-style Flutter design system distributed as copy-paste components through a CLI.
Goal: re-architect it into a minimal, production-ready, easy-to-contribute design system built only on
package:flutter/widgets.dart (no Material/Cupertino; Flutter 3.47 split them into material_ui/cupertino_ui), where
every real component is installable on its own and every declaration is defined exactly once.

BINDING USER DECISIONS (do not reopen)
- Clean break: no deprecated aliases, no migrate command (kit not marketed yet). Fix old bugs rather than port them.
- Flat layout components/<name>/ with at most: <name>.dart, <name>_style.dart, user-owned <name>_theme.dart,
  preview.dart, meta.json, README.md. No _impl/, no part/part of, no ignore_for_file, files ≤ ~400 lines.
- Variants are data (enum + exhaustive table), not classes. E.g. Button(variant: .ghost).
- Layers import downward only: foundation (0) → theme (1) → primitives (2) → components (3).
- Every real component installable alone; helper-only pieces live in foundation/ or primitives/.
- Theme tokens = camelCase of shadcn CSS variables; 42 presets kept as JSON; each component has an isolated theme
  that a future Studio theme builder rewrites (user-owned <name>_theme.dart = const values only);
  precedence: widget arg > nearest ComponentTheme<T> > app ComponentThemes (root) > token defaults.
- Rename Theme/ThemeData/ColorScheme → ShadcnTheme/ShadcnThemeData/ShadcnColors.
- Build in a parallel tree flutter_shadcn_kit/lib/registry_next/; old lib/registry/ stays untouched and compiling
  until one cutover at the end of Phase 4.

WHERE THINGS STAND (2026-10-06 ~03:00)
- Phase 0 baseline ✅, Phase 1 audit ✅ (user-approved).
- Phase 2: ✅ theme/ (layer 1), ✅ foundation/ (layer 0, local Data + Gap replace data_widget/gap), ✅ themes/
  (42 presets, schema v2, shadow bug fixed, JSON→Dart generator), ✅ guardrail tooling. All committed + pushed.
- NEXT: Phase 2 primitives — two briefs are written but NOT started:
  rearch/briefs/P2-E1-primitives-interaction.md (deepseek) and rearch/briefs/P2-E2-primitives-form-text-l10n.md
  (space-bunny). They can run in parallel (verified: form_core/text/localizations import only each other + theme).
  Start them in FRESH sessions (an earlier launch was stopped before writing anything).
- Then: Phase 3 pilot (button + toggle + button_group, input merged with text_field, dialog) → STOP for user review
  → Phase 4 migrate all components + cutover → Phase 5 CLI → Phase 6 docs gallery, final QA, PR.

READ THESE FILES FULLY BEFORE DOING ANYTHING (in this order)
1. /Users/ibrar/Desktop/infinora.noworkspace/shadcn_copy_paste/shadcn_flutter_kit/rearch/HANDOFF.md
   (repos, branches, remotes, backups, how to launch/continue agents, gates, full context index)
2. /Users/ibrar/Desktop/infinora.noworkspace/shadcn_copy_paste/shadcn_flutter_kit/rearch/PROGRESS.md
3. /Users/ibrar/Desktop/infinora.noworkspace/shadcn_copy_paste/shadcn_flutter_kit/REARCHITECTURE_PLAN.md
4. /Users/ibrar/Desktop/infinora.noworkspace/shadcn_copy_paste/shadcn_flutter_kit/rearch/reports/QA_LOG.md
5. /Users/ibrar/Desktop/infinora.noworkspace/shadcn_copy_paste/shadcn_flutter_kit/rearch/reports/THEME_DESIGN.md
6. /Users/ibrar/Desktop/infinora.noworkspace/shadcn_copy_paste/shadcn_flutter_kit/rearch/reports/OWNERSHIP.md
   (+ ownership.json in the same folder)
7. /Users/ibrar/Desktop/infinora.noworkspace/shadcn_copy_paste/shadcn_flutter_kit/rearch/reports/TOKENS_AUDIT.md
8. /Users/ibrar/Desktop/infinora.noworkspace/shadcn_copy_paste/shadcn_flutter_kit/rearch/reports/BASELINE_GUARDRAILS.md
9. /Users/ibrar/Desktop/infinora.noworkspace/shadcn_copy_paste/shadcn_flutter_kit/rearch/reports/P2A_FOUNDATION.md,
   P2B_THEME.md, P2D_PRESETS.md (same folder)
10. /Users/ibrar/Desktop/infinora.noworkspace/shadcn_copy_paste/shadcn_flutter_kit/flutter_shadcn_kit/lib/registry_next/foundation/README.md
    and /Users/ibrar/Desktop/infinora.noworkspace/shadcn_copy_paste/shadcn_flutter_kit/flutter_shadcn_kit/lib/registry_next/theme/README.md
11. /Users/ibrar/Desktop/infinora.noworkspace/shadcn_copy_paste/shadcn_flutter_kit/rearch/briefs/_common.md,
    rearch/briefs/P2-E1-primitives-interaction.md, rearch/briefs/P2-E2-primitives-form-text-l10n.md
12. /Users/ibrar/Desktop/infinora.noworkspace/shadcn_copy_paste/shadcn_flutter_kit/AGENTS.md

FIRST ACTIONS
1. Verify state:
   K=/Users/ibrar/Desktop/infinora.noworkspace/shadcn_copy_paste/shadcn_flutter_kit
   git -C $K branch -vv          # must be on refactor/rearchitecture, tracking origin
   git -C $K status --short      # expect clean
   git -C $K log --oneline chore/upstream-parity-audit..refactor/rearchitecture
   ps -eo pid,etime,args | grep "opencode run"; opencode session list | grep rearch
   cd $K/flutter_shadcn_kit && flutter test test/registry_next && flutter test test/rearch   # expect all green
   The CLI repo (/Users/ibrar/Desktop/infinora.noworkspace/shadcn_copy_paste/shadcn_flutter_cli) has the user's
   uncommitted WIP on main — never touch it until Phase 5 (backed up on origin/backup/installer-wip-2026-10-06).
2. Launch the two primitives briefs (a few seconds apart, in the background):
   cd $K && rearch/run_agent.sh "opencode-go/deepseek-v4.1-flash#max" rearch/briefs/P2-E1-primitives-interaction.md P2-E1-primitives
   cd $K && rearch/run_agent.sh "opencode-go/space-bunny-free#max" rearch/briefs/P2-E2-primitives-form-text-l10n.md P2-E2-primitives
   A log in rearch/logs/ still at 0 bytes after ~2 minutes = hung start → kill that pid and relaunch.
   A run that ends with ECONNRESET is a network drop → check what it left, then continue the SAME session with
   rearch/continue_agent.sh <session-id> <model#variant> rearch/briefs/fixes/<unit>-rN.md <log-name>.
3. QA each result (gates in the brief + read code), log the verdict in rearch/reports/QA_LOG.md, send fixes via
   continue_agent.sh, or commit + push only the accepted paths. Update rearch/PROGRESS.md after every step.
4. Then write the Phase 3 pilot briefs (start with muse-spark planning the button file split against
   THEME_DESIGN §3), build, QA, and STOP for the user's review after the pilot.
````

## Full context index (absolute paths)
Root: K = /Users/ibrar/Desktop/infinora.noworkspace/shadcn_copy_paste/shadcn_flutter_kit

Planning & state
- K/REARCHITECTURE_PLAN.md — goals, decisions, target structure, theming, agent team, loop, phases
- K/rearch/PROGRESS.md — live status, running agents + session ids, next steps
- K/rearch/HANDOFF.md — this file
- K/AGENTS.md, K/flutter_shadcn_kit/README.md — repo conventions

Phase 1 reports (K/rearch/reports/)
- QA_LOG.md — every QA verdict and orchestrator fix (read before trusting any report)
- THEME_DESIGN.md — theme system spec (as amended in QA_LOG)
- OWNERSHIP.md + ownership.json — owner per duplicate, layer per shared file, 14 merges, data_widget/gap usage
- TOKENS_AUDIT.md — preset token audit, shadow bug root cause
- BASELINE_GUARDRAILS.md + baseline/{single_owner,layers,api}.json — guardrail baseline on the old tree

Phase 2 outputs
- K/flutter_shadcn_kit/lib/registry_next/theme/ (+ README.md), report K/rearch/reports/P2B_THEME.md — accepted
- K/flutter_shadcn_kit/lib/registry_next/foundation/ — P2-A (check PROGRESS for status), report P2A_FOUNDATION.md
- K/flutter_shadcn_kit/lib/registry_next/themes/ + tool/rearch/{migrate_presets,gen_app_theme}.dart — P2-D, report P2D_PRESETS.md
- Tests: K/flutter_shadcn_kit/test/registry_next/{theme,foundation,themes}/, K/flutter_shadcn_kit/test/rearch/

Guardrail tools (K/flutter_shadcn_kit/tool/rearch/)
- check_single_owner.dart, check_layers.dart (rules: no-material, no-part, no-ignore-for-file, layer-direction,
  undeclared-dependency, file-too-long, installable, no-impl-dir), check_user_theme.dart, api_snapshot.dart, src/

Agent operations (K/rearch/)
- briefs/_common.md (rules prepended to every brief), briefs/P*.md, briefs/fixes/*.md
- run_agent.sh, continue_agent.sh (both use `opencode run --standalone --auto`)
- logs/*.log (gitignored; agent transcripts — tail them to see what an agent did)

Old registry being replaced (read-only reference)
- K/flutter_shadcn_kit/lib/registry/{components,shared,manifests,themes_preset}
- K/docs/ (docs gallery app; mirror at K/docs/lib/ui/shadcn/) — updated in Phase 6
