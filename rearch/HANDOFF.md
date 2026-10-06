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
| `chore/upstream-parity-audit` | ef06f55 | **none — never pushed** | 35 commits ahead of main (docs previews, registry fixes); base of the refactor |
| `refactor/rearchitecture` ← **work happens here** | see `git log -1` | **none — never pushed** | branched from `chore/upstream-parity-audit` at ef06f55; all re-architecture commits |
- Contains: `flutter_shadcn_kit/` (Flutter app hosting the registry; old `lib/registry/`, new `lib/registry_next/`,
  guardrails `tool/rearch/`), `docs/` (Flutter web docs gallery = the "demo mode"; has a mirror of the registry under
  `docs/lib/ui/shadcn/`), `REARCHITECTURE_PLAN.md`, `rearch/` (briefs, reports, logs, handoff, progress).
- Neither non-main branch is on GitHub. Ask the user before pushing anything (push = outward-facing).
- Only one worktree (the main checkout); no stashes.

### 2. CLI — `/Users/ibrar/Desktop/infinora.noworkspace/shadcn_copy_paste/shadcn_flutter_cli`
Remote: `origin https://github.com/mibrar-dev/flutter_shadcn_cli.git`. Branch `main` (tracks origin/main), head
02003d1 "Merge 0.2.7 line into main (fork reunion + 160/160)".
- **Uncommitted user work on main — do not discard**: 7 files, +918/−101 —
  `lib/src/application/services/installer/{component_manifest_resolver,installer,installer_file_install_part,installer_platform_alias_part}.dart`,
  `test/component_manifest_resolver_test.dart`, `test/installer_test.dart`, `pubspec.lock` (+ untracked `.DS_Store`).
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
- Record each verdict in QA_LOG.md; commit only accepted paths; end commit messages with
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
```
You are taking over as ORCHESTRATOR and QA LEAD for the flutter_shadcn_kit re-architecture. You plan, write exact
briefs, launch OpenCode sub-agents (never Claude sub-agents), and QA-review every result yourself. Sub-agents do
the heavy coding. The user is Ibrar; ask before anything destructive or outward-facing (push, PR, publishing).

Before doing anything, read these files fully, in this order:
1. /Users/ibrar/Desktop/infinora.noworkspace/shadcn_copy_paste/shadcn_flutter_kit/rearch/HANDOFF.md
2. /Users/ibrar/Desktop/infinora.noworkspace/shadcn_copy_paste/shadcn_flutter_kit/rearch/PROGRESS.md
3. /Users/ibrar/Desktop/infinora.noworkspace/shadcn_copy_paste/shadcn_flutter_kit/REARCHITECTURE_PLAN.md
4. /Users/ibrar/Desktop/infinora.noworkspace/shadcn_copy_paste/shadcn_flutter_kit/rearch/reports/QA_LOG.md
5. /Users/ibrar/Desktop/infinora.noworkspace/shadcn_copy_paste/shadcn_flutter_kit/rearch/reports/THEME_DESIGN.md
6. /Users/ibrar/Desktop/infinora.noworkspace/shadcn_copy_paste/shadcn_flutter_kit/rearch/reports/OWNERSHIP.md
7. /Users/ibrar/Desktop/infinora.noworkspace/shadcn_copy_paste/shadcn_flutter_kit/rearch/reports/TOKENS_AUDIT.md
8. /Users/ibrar/Desktop/infinora.noworkspace/shadcn_copy_paste/shadcn_flutter_kit/rearch/reports/BASELINE_GUARDRAILS.md
9. /Users/ibrar/Desktop/infinora.noworkspace/shadcn_copy_paste/shadcn_flutter_kit/rearch/briefs/_common.md and the
   briefs of any unit marked in progress in PROGRESS.md (rearch/briefs/*.md, rearch/briefs/fixes/*.md)
10. /Users/ibrar/Desktop/infinora.noworkspace/shadcn_copy_paste/shadcn_flutter_kit/AGENTS.md

Then:
- Verify branches exactly as in HANDOFF.md "Repositories & branches": the kit must be on
  `refactor/rearchitecture` (`git -C /Users/ibrar/Desktop/infinora.noworkspace/shadcn_copy_paste/shadcn_flutter_kit
  branch -vv`); the CLI repo stays on `main` with the user's uncommitted installer work untouched until Phase 5.
  Never push, force-push, reset, or discard anything without asking the user.
- Run `git -C /Users/ibrar/Desktop/infinora.noworkspace/shadcn_copy_paste/shadcn_flutter_kit status` and
  `git log --oneline chore/upstream-parity-audit..refactor/rearchitecture` (every re-architecture commit); check `ps -eo pid,etime,args | grep "opencode run"` and `opencode session list` to see
  which sub-agents are still running; read the tail of their logs in rearch/logs/.
- For every finished-but-unreviewed unit: QA it (re-run gates, read code), log the verdict in QA_LOG.md, send fixes
  via rearch/continue_agent.sh or commit the accepted paths.
- Continue with "Next steps" in PROGRESS.md. Keep PROGRESS.md updated after every step.
- Binding user decisions are listed in PROGRESS.md ("User decisions"); do not reopen them.
```

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
