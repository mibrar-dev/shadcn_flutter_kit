# Re-architecture progress

Last updated: 2026-10-08 (orchestrator stopped at usage limit)
Branch: `refactor/rearchitecture` in `/Users/ibrar/Desktop/infinora.noworkspace/shadcn_copy_paste/shadcn_flutter_kit`
(branched from `chore/upstream-parity-audit`).

## Status at a glance
| Phase | Status |
|---|---|
| 0 Baseline | ✅ done |
| 1 Audit (read-only) | ✅ done, user-approved 2026-10-06 |
| 2 Foundation + theme + primitives + presets | ✅ done (all units accepted) |
| 3 Pilot (button, input, dialog) | ✅ built + QA-accepted + user-approved (sizes fixed in P3-F) (button/button_group/toggle ee32250, dialog 587335e, input + text_editing + input_features) — ⏸ STOPPED for user review |
| 4 Migrate remaining components + cutover | ✅ migration done 2026-10-09: 118 components + all primitives (full gate 2652/2652, owner 0); 🔄 cutover P4-Z running (user-approved) |
| 5 CLI | 🔄 plan ✅ (rearch/reports/P5_CLI_PLAN.md + registry_manifest.v2.schema.json); CLI repo branch refactor/rearchitecture; batches B1 (models) + B3 (lock) running |
| 6 Docs gallery, final QA, PR | 🔄 P6-A docs design in Open Design running; Flutter rebuild next; PR needs user approval |

## User decisions (binding)
- 2026-10-09: Ibrar APPROVED (complete approval): Phase 4 cutover (replace lib/registry with registry_next, delete old tree,
  rewrite imports, regenerate manifests, drop the ~8 unused packages); Phase 5 CLI rewrite for the new component install
  (CLI repo branch `refactor/rearchitecture`, his installer WIP preserved as commit de35dd2; main untouched); Phase 6 docs (2026-10-09 UPDATE: Open Design mockups rejected — design must mirror https://ui.shadcn.com/, spec in rearch/reports/P6_SHADCN_SITE_SPEC.md):
  design a modern, motion-rich docs website with the Open Design CLI (`opendesign`, daemon :7456, project
  shadcn-flutter-kit-docs), then rebuild the whole docs app in Flutter with the new registry components. Parallel OpenCode agents.
- Agents: **OpenCode only** (no Claude subagents, Gemini/Antigravity dropped). The orchestrator plans, briefs, and
  QA-reviews; sub-agents do the heavy work. Loop per unit: plan → build → test → QA review → UI check → bug hunt.
- Models: muse-spark-1.3-contributor#xhigh (architect / QA reviewer), deepseek-v4.1-flash#max (builder A),
  space-bunny-free#max (builder B / bug hunter), fledge-alpha-free (mechanical), deepseek-v4-flash-vision-exp (UI vision).
- **Clean break**: no deprecated aliases, no migrate command (kit not marketed yet). Production-ready, minimal,
  easy to read.
- **Every real component installable on its own**; helper-only pieces live in foundation/ or primitives/.
- Flat layout `components/<name>/`; ≤ 3 Dart files per component (`<name>.dart`, `<name>_style.dart`, user-owned
  `<name>_theme.dart`) + `preview.dart`, `meta.json`, `README.md`; no `_impl/`, no `part`, no `ignore_for_file`,
  no Material/Cupertino; variants are data (enum + table).
- Single-owner rule: every declaration defined exactly once.
- Theme tokens = camelCase of shadcn CSS variables; 42 presets kept as JSON; each component has an isolated,
  Studio-editable theme; future CLI theme converter (CSS → JSON → Dart) and Studio theme builder.
- Build in a parallel tree `flutter_shadcn_kit/lib/registry_next/`; old `lib/registry/` untouched until cutover.

## Backups
- Kit branches pushed: `origin/refactor/rearchitecture`, `origin/chore/upstream-parity-audit`. Push after every commit.
- CLI uncommitted WIP snapshot: `origin/backup/installer-wip-2026-10-06` (eae8111); working tree untouched.

## Done
- Phase 0: branch; baseline — `flutter analyze lib/registry` 0 issues (masked by ignore_for_file; whole project has
  7 pre-existing issues in tool/theme + test/registry); `flutter test` 37 pass / 1 pre-existing failure
  (`test/registry/consumer_fixture_font_pubspec_alignment_test.dart`).
- Phase 1 (all reports in `rearch/reports/`, verdicts in `rearch/reports/QA_LOG.md`):
  - THEME_DESIGN.md — theme system design (accepted after 3 rounds + 2 orchestrator fixes).
  - BASELINE_GUARDRAILS.md + baseline/*.json — guardrail scripts `flutter_shadcn_kit/tool/rearch/` with tests:
    166 duplicates, 2,246 part directives, 1,964 ignore_for_file, 205 material imports, 71 undeclared deps.
  - OWNERSHIP.md + ownership.json — owner for every duplicate, layer for every shared file, 14 component merges.
  - TOKENS_AUDIT.md — shadow bug (84/84 preset modes identical), alpha never preserved, font tokens inconsistent.
- Commits: 8168659, 0e43df1, 34354a6, a85e641, a4f52c1, c25e10e (see `git log`).

## In progress (Phase 2)
| Unit | Model | OpenCode session | Brief | State |
|---|---|---|---|---|
| P2-A foundation/ | deepseek-v4.1-flash#max | ses_ef174b744ffeu19TNyEvVDPmcC | rearch/briefs/P2-A-foundation.md + fixes/P2-A-r2.md | ✅ ACCEPTED + pushed (14fa1fc) |
| P2-E1 primitives (interaction/overlay/animation/layout) | deepseek-v4.1-flash#max | — | rearch/briefs/P2-E1-primitives-interaction.md | ✅ ACCEPTED r2 + pushed (ses_ef1179393ffemfjo5UQLFYBbr9) |
| P2-E2 primitives (form_core/text/localizations) | space-bunny-free#max | — | rearch/briefs/P2-E2-primitives-form-text-l10n.md | ✅ ACCEPTED r2 + pushed (ses_ef1177469ffe45Lj1CqOsRpl3u) |
| P2-B theme/ | muse-spark-1.3-contributor#xhigh | ses_ef18472acffex09RhUxX5X1vPf | rearch/briefs/P2-B-theme.md + fixes/P2-B-r2.md | ✅ ACCEPTED + committed (c863786) |
| P2-D presets | space-bunny-free#max | rearch:P2-D-presets | rearch/briefs/P2-D-presets.md | ✅ ACCEPTED + pushed (22c0f20) |
| P2-C tooling | fledge-alpha-free | ses_ef1846c81ffenqH8vpcvvVb38i | rearch/briefs/P2-C-tooling.md | ✅ ACCEPTED + committed (8951dda) |
Working tree is clean: everything accepted so far is committed and pushed.
registry_next today: `foundation/` (layer 0), `theme/` (layer 1), `themes/` (42 presets v2). `primitives/` and `components/` do not exist yet.
Tests: `flutter test test/registry_next` 106/106, `flutter test test/rearch` 33/33.

## Next steps (in order)
1. ✅ DONE — P2-A, P2-B, P2-C, P2-D all QA-accepted, committed and pushed.
2. ✅ DONE P2-D presets: update `manifests/themes.schema.json` (alpha colours, top-level `fonts`, shadow base atoms +
   `shadowsDerived`), migrate the 42 presets into `registry_next/themes/`, write `tool/rearch/gen_app_theme.dart`
   (preset JSON → values-only `app_theme.dart` per THEME_DESIGN §5.2), tests incl. round-trip for all 42.
3. NEXT — launch both in parallel, a few seconds apart (both briefs ready): P2-E1 `rearch/briefs/P2-E1-primitives-interaction.md` (deepseek) and P2-E2 `rearch/briefs/P2-E2-primitives-form-text-l10n.md` (space-bunny), in parallel. Original note — primitives/: per ownership.json `shared_map` (layers primitives, primitives/*), incl. form_core, text,
   subfocus, animation, localizations, clickable, overlay/popover; must use registry_next foundation + theme.
4. Phase 3 pilot: button (+ toggle, button_group), input (merged with text_field, features in ≤ 3 files,
   autocomplete separate), dialog. User review checkpoint after the pilot.
5. Phase 4 batch migration, then cutover (registry_next → registry, manifests regenerated), Phase 5 CLI
   (CLI repo has the user's uncommitted installer WIP on `main` — 7 modified + 1 untracked file, backed up to `origin/backup/installer-wip-2026-10-06`; review with the user, then commit on a branch), Phase 6.

## Open items / known issues
- `flutter_shadcn_kit/.tmp/` appeared (untracked, created by an agent) — inspect before committing; do not commit.
- OpenCode launches now use `--standalone` (two hung starts on the shared service). Still start agents a few seconds apart; if a log stays 0 bytes for > 2 minutes the agent is hung —
  kill the `opencode run` process and relaunch.
- Rename Theme/ThemeData/ColorScheme → ShadcnTheme/ShadcnThemeData/ShadcnColors (approved).
- Phase 3 pilot decisions B1–B4, I1–I3, D1–D4, T1–T2 approved (see P3_PILOT_DESIGN.md §5).
- Models (user, 2026-10-07; highest variant each offers): Zen opencode/space-bunny-free#max, opencode/fledge-alpha-free#max, opencode/exo-free#high (endpoint down 10-07); Go opencode-go/deepseek-v4.1-flash#max + opencode-go/muse-spark-1.3-contributor#xhigh (enabled by user 2026-10-08), opencode-go/mimo-v2.6-flash (no variants), opencode-go/longcat-2.5-preview-free (no variants). Step 5 preview free in both: opencode-go/step-5-preview-free#high, opencode/step-5-preview-free#high. Never opencode-go/space-bunny*, deepseek-v4 non-4.1, vision-exp.
- Behaviour changes approved: per-field theme merge; destructive button text uses destructiveForeground.

## Phase 4 working notes (2026-10-08)
- Per-batch QA: `rearch/qa_batch.sh <components…>`; readiness: `rearch/ready_batches.py <running ids>`;
  briefs: `rearch/gen_batch_brief.py <id>` from `rearch/briefs/P4-batch-template.md` (+ name map, size + name-clash rules).
- Watch list for the orchestrator monitor: `rearch/logs/.watch` (one log name per line; exit line must be LAST line).
- Open follow-ups: split `primitives/localizations/localizations.dart` (416 lines) + l10n pass (error_system strings);
  re-run full `rearch/qa_gate.sh` once all batches are in; cutover checklist in `rearch/reports/P4_PLAN.md`.

## User requirements 2026-10-10 (binding for Phase 6 finish)
- Docs previews: one example at a time + Select to switch variants + light/dark toggle (shadcn style).
- Sidebar / index / ⌘K list only user-facing components; building blocks (color, history, hsl, …) hidden (still installable).
- Every component renders correctly in light AND dark and behaves correctly (audit P6-D9a).
- All paddings/margins/gaps are theme-dependent (spacing + density); no stretch/compact; icon gaps exact (audit P6-D9b).
- Staggered (masonry) grid for block showcases (P6-D8). Syntax colours in all code blocks (done P4-T5/T5b).
- Theme Studio like shadcn /create, applied site-wide (P6-D7). Sub-agents on FREE models (Step 5 preview for these fixes).
- Code blocks (code_snippet, markdown, docs code/View Code/Get Code) must be SELECTABLE + copyable with syntax colours; every component must follow the active theme live (e.g. calendar selection = primary, not black) — audit P6-D9c.
