## Prompt for the next agent (copy everything in the block)
````
You are taking over the flutter_shadcn_kit re-architecture as ORCHESTRATOR and QA REVIEWER.

YOUR ROLE
- You do NOT do the heavy work yourself. You plan, write exact briefs, launch OpenCode sub-agents, and QA-review every
  result. All heavy coding/analysis goes to OpenCode sub-agents. NEVER spawn Claude sub-agents.
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
