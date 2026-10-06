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
- Run `git -C /Users/ibrar/Desktop/infinora.noworkspace/shadcn_copy_paste/shadcn_flutter_kit status` and
  `git log --oneline -10`; check `ps -eo pid,etime,args | grep "opencode run"` and `opencode session list` to see
  which sub-agents are still running; read the tail of their logs in rearch/logs/.
- For every finished-but-unreviewed unit: QA it (re-run gates, read code), log the verdict in QA_LOG.md, send fixes
  via rearch/continue_agent.sh or commit the accepted paths.
- Continue with "Next steps" in PROGRESS.md. Keep PROGRESS.md updated after every step.
- Binding user decisions are listed in PROGRESS.md ("User decisions"); do not reopen them.
```
