# Re-architecture progress

Last updated: 2026-10-06 02:55 (Europe/London) by the orchestrator (Claude Opus 5.5).
Branch: `refactor/rearchitecture` in `/Users/ibrar/Desktop/infinora.noworkspace/shadcn_copy_paste/shadcn_flutter_kit`
(branched from `chore/upstream-parity-audit`).

## Status at a glance
| Phase | Status |
|---|---|
| 0 Baseline | ✅ done |
| 1 Audit (read-only) | ✅ done, user-approved 2026-10-06 |
| 2 Foundation + theme + primitives + presets | 🔄 foundation, theme, presets, tooling ✅ accepted; primitives (P2-E1, P2-E2) not started |
| 3 Pilot (button, input, dialog) | ⏳ not started |
| 4 Migrate remaining components + cutover | ⏳ not started |
| 5 CLI | ⏳ not started |
| 6 Docs gallery, final QA, PR | ⏳ not started |

## User decisions (binding)
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
| P2-E1 primitives (interaction/overlay/animation/layout) | deepseek-v4.1-flash#max | — | rearch/briefs/P2-E1-primitives-interaction.md | ⏸ NOT STARTED — brief ready (a launch was stopped by user request within minutes; no files written; start a FRESH session) |
| P2-E2 primitives (form_core/text/localizations) | space-bunny-free#max | — | rearch/briefs/P2-E2-primitives-form-text-l10n.md | ⏸ NOT STARTED — brief ready (same as above) |
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
- Behaviour changes approved: per-field theme merge; destructive button text uses destructiveForeground.
