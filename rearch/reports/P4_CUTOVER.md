# Phase 4 cutover plan (P4-X)

Status: **BLOCKED** — 5 blocker components (B24/B25) have not landed.
`rearch/cutover.sh --apply` refuses to run until they do. `--dry-run` passes.

## 0. How this was verified

- Old tree: `find flutter_shadcn_kit/lib/registry/components -mindepth 2 -maxdepth 2`
  = **145** dirs (7 control, 31 display, 34 form, 25 layout, 12 navigation, 22 overlay, 14 utility).
- `p4_batches.json`: 119 batch components covering **126** unique old dirs
  (7 comps absorb a second dir: fade_scroll, form, sortable, tabs, file_picker).
  126 + 4 pilot (button, input, text_field, dialog) + 14 moved-to-primitive +
  1 deleted outright (tab_list) = 145. ✔ No gaps, no double-counts
  (text_field is counted in the pilot row per P4_PLAN §1).
- New tree: `lib/registry_next/components/` = **113** dirs =
  4 pilot + 108 batch-built + 1 extra (`multi_select`, split out of select in B20).
- Missing from new tree vs batches: 11 names. 6 are intentional (ratified
  verdicts, §2); **5 are real blockers** (B24/B25).
- Branch `refactor/rearchitecture`, `git status` clean (only the two new
  P4-X files are untracked). `--apply` was executed once to prove the
  refusal: exits 1, repo untouched.

## 1. Counts

| Fate | Old dirs | New dirs |
|---|---|---|
| Pilot (already built) | 4 | 4 (button, toggle*, dialog, input) |
| Migrated 1:1 (batch built) | 102 | 102 |
| Merged into sibling (batch built) | 9 (form_field, validated, file_input, form/sortable, display/fade_scroll, tab_container, tab_pane, text_field, +layout canonicals) | 0 (absorbed) |
| Absorbed by verdict, no dir | 2 (linear→progress, circular→spinner, B03) | 0 |
| Moved to primitive (P2, built) | 14 | 0 |
| Dropped to primitive (Q3: fade_scroll ×2) | 2 | 0 |
| Deleted outright / Q4 | 4 (tab_list, debug, flex, wrapper) | 0 |
| Blocked on B24/B25 | 5 | 0 (blockers) |
| Extra (no old dir) | — | 1 (multi_select) |
| **Total** | **145 old** | **113 now → 118 after B24/B25** |

\* `toggle` is pilot-new, no old dir. P4_PLAN §1 says "123 components" and
`p4_batches.json` cutover says "120 flat entries" — both predate the Q3/Q4
verdicts (−6 dirs) and `multi_select` (+1). Verified actual: **118**.
`p4_batches.json` `cutover[2]` should be corrected to 118 before Phase 5.

## 2. Blockers (cutover must wait)

`lib/registry_next/components/` lacks (verified by `ls`): `color_picker`,
`phone_input`, `filter_bar` (B24), `color_input`, `text_animate` (B25).
Intentional non-builds (NOT blockers): `linear_progress_indicator` →
`progress`, `circular_progress_indicator` → `spinner` (P4-B03 absorptions);
`fade_scroll` component dropped, primitive owns it (Q3, P4-B05 §0);
`debug` (P4-B06 §2.1), `flex` (P4-B11 F3), `wrapper` (P4-B23) deleted per Q4.

## 3. Exact steps (what `rearch/cutover.sh` does)

1. Preconditions (`--apply` only): zero blockers, `git status` clean, branch
   `refactor/rearchitecture`. Else exit 1.
2. Single commit, renames via `git mv` (history preserved):
   `flutter_shadcn_kit/lib/registry` → `lib/registry_old`,
   `flutter_shadcn_kit/lib/registry_next` → `lib/registry`.
3. Same commit: `git rm -r lib/registry_old` — removes `components/` (145 dirs),
   `shared/` (incl. `shared_manifest.json`), `themes_preset/` (42 JSONs),
   `manifests/` (9 files), `available_components.txt`,
   `COMMON_PATCHED_WIDGETS_README.md`.
4. Mechanical rewrite: `registry_next/` → `registry/` in 181 files under
   `lib/`, `test/`, `tool/`, `docs/lib` (sed; covers all `registry_next`
   imports incl. `test/registry_next/**`).
5. Manual rewrites (old category paths cease to exist; §7 file list):
   `lib/flutter_shadcn_kit.dart` (barrel, 153 refs — regenerate, do not sed),
   `lib/main.dart`, `lib/examples/*` (relative `../registry/...` imports).
6. Regenerate manifests (§5) with the tools below.
7. Retire old tests (§6): `git rm -r test/registry/components` +
   the two shared-manifest/consumer tests.
8. Gates: `flutter analyze` (0), `flutter test` (green), `check_layers` +
   `check_single_owner` + `check_user_theme` (0 errors), CLI install of all
   118 into a scratch app that compiles with dependents.
9. Playground/docs: no `playground/` or `example/` dir exists in this repo
   (AGENTS.md `rsync` rule points at `playground/playground_app`, which is
   absent — UNVERIFIED/stale). The live mirror is `docs/lib/ui/shadcn/`
   (byte-mirrors old `components/`, `shared/`, `manifests/`, `themes_preset/`);
   re-mirror it from the new tree or regenerate it after step 2.

## 4. Full inventory: every old dir → fate

Columns: old dir | new component (`—` = dir deleted) | batch / decision.
Cross-checked against `p4_batches.json` (`batches`, `deleted`, `moved_to_primitive`).

| Old `lib/registry/components/…` | New `registry/components/…` | Via |
|---|---|---|
| `control/button` | `button` | pilot |
| `control/clickable` | — (primitive `primitives/clickable`) | primitive |
| `control/command` | `command` | B10 |
| `control/hover` | — (primitive `primitives/hover`) | primitive (Q1) |
| `control/patch` | `patch` | B06 |
| `control/scrollbar` | `scrollbar` | B05 |
| `control/scrollview` | `scrollview` | B05 |
| `display/avatar` | `avatar` | B03 |
| `display/badge` | `badge` | B01 |
| `display/border_loading` | `border_loading` | B17 |
| `display/calendar` | `calendar` | B07 |
| `display/carousel` | `carousel` | B07 |
| `display/chat` | `chat` | B17 |
| `display/chip` | `chip` | B01 |
| `display/circular_progress_indicator` | `spinner` (absorbed) | B03 verdict |
| `display/code_snippet` | `code_snippet` | B15 |
| `display/country_flag` | `country_flag` | B15 |
| `display/divider` | `divider` | B01 |
| `display/dot_indicator` | `dot_indicator` | B06 |
| `display/empty_state` | `empty_state` | B08 |
| `display/fade_scroll` | — (primitive `primitives/fade_scroll.dart`) | merged then dropped Q3/B05 |
| `display/feature_carousel` | `feature_carousel` | B19 |
| `display/file_diff_viewer` | `file_diff_viewer` | B17 |
| `display/icon` | `icon` | B03 |
| `display/keyboard_shortcut` | `keyboard_shortcut` | B08 |
| `display/linear_progress_indicator` | `progress` (absorbed) | B03 verdict |
| `display/markdown` | `markdown` | B16 |
| `display/number_ticker` | `number_ticker` | B15 |
| `display/pinned_sheet` | `pinned_sheet` | B21 |
| `display/progress` | `progress` | B03 |
| `display/selectable` | `selectable` | B03 |
| `display/skeleton` | `skeleton` | B07 |
| `display/spinner` | `spinner` | B03 |
| `display/text` | — (primitive `primitives/text`) | primitive |
| `display/text_animate` | `text_animate` | **B25 BLOCKER** |
| `display/tracker` | `tracker` | B19 |
| `display/tree` | `tree` | B14 |
| `display/triple_dots` | `triple_dots` | B03 |
| `form/autocomplete` | `autocomplete` | B08 |
| `form/checkbox` | `checkbox` | B01 |
| `form/chip_input` | `chip_input` | B13 |
| `form/color_field` | `color_field` | B08 |
| `form/color_input` | `color_input` | **B25 BLOCKER** |
| `form/color_picker` | `color_picker` | **B24 BLOCKER** |
| `form/control` | — (primitive `primitives/form_core`) | primitive |
| `form/date_picker` | `date_picker` | B13 |
| `form/dropzone` | `dropzone` | B08 |
| `form/file_input` | `file_picker` (absorbed) | B22 merge |
| `form/file_picker` | `file_picker` | B22 |
| `form/form` | `form` | B10 |
| `form/form_field` | `form` (absorbed) | B10 merge |
| `form/formatted_input` | `formatted_input` | B14 |
| `form/formatter` | `formatter` | B04 |
| `form/history` | `history` | B04 |
| `form/hsl` | `hsl` | B04 |
| `form/hsv` | `hsv` | B04 |
| `form/input` | `input` | pilot |
| `form/input_otp` | `input_otp` | B07 |
| `form/item_picker` | `item_picker` | B15 |
| `form/multiple_choice` | `multiple_choice` | B10 |
| `form/object_input` | `object_input` | B21 |
| `form/phone_input` | `phone_input` | **B24 BLOCKER** |
| `form/radio_group` | `radio_group` | B08 |
| `form/select` | `select` (+ split-out `multi_select`) | B20 |
| `form/slider` | `slider` | B02 |
| `form/sortable` | `sortable` (layout canonical) | B12 merge |
| `form/star_rating` | `star_rating` | B10 |
| `form/switch` | `switch` | B01 |
| `form/text_area` | `text_area` | B07 |
| `form/text_field` | `input` (merged) | pilot P3-D |
| `form/time_picker` | `time_picker` | B13 |
| `form/validated` | `form` (absorbed) | B10 merge |
| `layout/accordion` | `accordion` | B05 |
| `layout/alert` | `alert` | B23 |
| `layout/app` | `app` | B23 |
| `layout/basic` | — (primitives `layout`/`basic_layout`/`label`) | primitive (Q1) |
| `layout/card` | `card` | B01 |
| `layout/card_image` | `card_image` | B19 |
| `layout/collapsible` | `collapsible` | B05 |
| `layout/fade_scroll` | — (primitive `primitives/fade_scroll.dart`) | dropped Q3/B05 |
| `layout/filter_bar` | `filter_bar` | **B24 BLOCKER** |
| `layout/flex` | — | deleted Q4/B11 |
| `layout/group` | `group` | B11 |
| `layout/hidden` | — (primitive `primitives/hidden`) | primitive (Q1) |
| `layout/media_query` | `media_query` | B06 |
| `layout/outlined_container` | `outlined_container` | B05 |
| `layout/overflow_marquee` | `overflow_marquee` | B17 |
| `layout/resizable` | `resizable` | B12 |
| `layout/scaffold` | `scaffold` | B15 |
| `layout/scrollable` | `scrollable` | B05 |
| `layout/scrollable_client` | `scrollable_client` | B05 |
| `layout/sortable` | `sortable` | B12 |
| `layout/stage_container` | `stage_container` | B21 |
| `layout/steps` | `steps` | B09 |
| `layout/table` | `table` | B11 |
| `layout/timeline` | `timeline` | B17 |
| `layout/window` | `window` | B23 |
| `navigation/breadcrumb` | `breadcrumb` | B09 |
| `navigation/navigation_bar` | `navigation_bar` | B22 |
| `navigation/navigation_menu` | `navigation_menu` | B15 |
| `navigation/page_route` | `page_route` | B06 |
| `navigation/pagination` | `pagination` | B09 |
| `navigation/stepper` | `stepper` | B14 |
| `navigation/subfocus` | — (primitive `primitives/subfocus*`) | primitive |
| `navigation/switcher` | `switcher` | B06 |
| `navigation/tab_container` | `tabs` (absorbed) | B21 merge |
| `navigation/tab_list` | — | deleted (no entry file) |
| `navigation/tab_pane` | `tabs` (absorbed) | B21 merge |
| `navigation/tabs` | `tabs` | B21 |
| `overlay/alert_dialog` | `alert_dialog` | B01 |
| `overlay/anchor` | `anchor` | B06 |
| `overlay/backdrop_transform` | `backdrop_transform` | B06 |
| `overlay/context_menu` | `context_menu` | B20 |
| `overlay/dialog` | `dialog` | pilot |
| `overlay/drawer` | `drawer` | B09 |
| `overlay/drawer_container` | `drawer_container` | B12 |
| `overlay/dropdown_menu` | `dropdown_menu` | B20 |
| `overlay/eye_dropper` | `eye_dropper` | B23 |
| `overlay/gooey_toast` | `gooey_toast` | B18 |
| `overlay/hover_card` | `hover_card` | B13 |
| `overlay/menu` | `menu` | B13 |
| `overlay/menubar` | `menubar` | B20 |
| `overlay/overlay` | — (primitive `primitives/overlay`) | primitive |
| `overlay/overlay_configuration` | `overlay_configuration` | B12 |
| `overlay/popover` | — (primitive `primitives/popover*`) | primitive |
| `overlay/popup` | `popup` | B20 |
| `overlay/refresh_trigger` | `refresh_trigger` | B15 |
| `overlay/spell_check_suggestions_toolbar` | `spell_check_suggestions_toolbar` | B20 |
| `overlay/swiper` | `swiper` | B21 |
| `overlay/toast` | `toast` | B09 |
| `overlay/tooltip` | `tooltip` | B07 |
| `utility/alpha` | `alpha` | B04 |
| `utility/async` | `async` | B06 |
| `utility/color` | `color` | B04 |
| `utility/debug` | — | deleted Q4/B06 |
| `utility/error_system` | `error_system` | B19 |
| `utility/focus_outline` | — (primitive `primitives/focus_outline`) | primitive |
| `utility/image` | `image` | B06 |
| `utility/locale_utils` | `locale_utils` | B10 |
| `utility/repeated_animation_builder` | — (primitive `primitives/animation`) | primitive |
| `utility/shadcn_localizations` | — (primitive `primitives/localizations`) | primitive |
| `utility/shadcn_localizations_en` | — (primitive `localizations_en` data) | primitive |
| `utility/shadcn_localizations_extensions` | — (primitive `localizations_extensions`) | primitive |
| `utility/timeline_animation` | `timeline_animation` | B17 |
| `utility/wrapper` | — | deleted Q4/B23 |

145/145 mapped. Extra new dir with no old counterpart: `multi_select` (B20 split-out).

## 5. Manifests: which tool, what schema changes

- `manifests/components.json`: old shape is per-file (`files[].source/destination`
  with `components/<category>/…` paths, plus `shared`, `dependsOn`, `pubspec`,
  `tier`). Must become **118 flat entries** (id == dir name, files are the
  ≤6 flat files, no category). Generator `tool/registry/registry_components_manifest.dart`
  currently reads the old layout — UNVERIFIED it handles flat dirs; expect a
  Phase-5 rewrite of its scanner. Fix `p4_batches.json` `cutover[2]` (120 → 118) first.
- `manifests/index.json` + `theme.index.json`: regenerate with
  `tool/registry/registry_index_generate.dart` and `tool/theme/theme_index_generate.dart`.
- Shared-manifest story ends: `shared/shared_manifest.json` is deleted with the
  old tree. Foundation/theme/primitives are implicit layers, not installed ids.
- `meta.json` `deps` shape change (enforced by `check_layers` `undeclared` rule):
  old `dependencies: {shared: [...], components: [...], pubspec: {...}}` →
  new `deps: {foundation: [...], theme: [...], primitives: [...], components: [...]}`.
  Legacy `dependencies.components` key is kept in pilot files only until Phase 5.
- No `tool/gen_theme_schema.dart` exists (P4_PLAN §5 names it, never built).
  Per-component `theme` sections in new `meta.json` are hand-written; the
  closest existing tool is `tool/theme/component_theme_schema_generate.dart`
  (old layout). Generating the schema from `<Name>Theme` fields is Phase-5 work.

## 6. Tests to retire / port

- Retire: `test/registry/components/**` (8 files incl. `new_previews_render_test`,
  `component_theme_global_configs_*`, button style, file_diff_viewer, form bridge,
  gooey_toast controller, overlay_configuration adaptive) and
  `test/registry/consumer_fixture_font_pubspec_alignment_test.dart` +
  `test/registry/shared_font_manifest_test.dart` (assert the deleted shared manifest).
- Keep: `test/rearch/*_test.dart` + fixtures — `layers_next_deps_test`,
  `next_layout_test`, `single_owner_test` already target the new layout;
  `layers_test` + `api_snapshot_test` cover the old layout via fixtures and stay
  valid as tool unit tests (do not delete fixtures).
- Kept behavior assertions live in `test/registry_next/**` (built per batch).

## 7. Import sites to update (beyond the mechanical sed)

- `lib/flutter_shadcn_kit.dart` — generated barrel (153 refs); regenerate with
  `tool/registry/registry_barrel_generate.dart` after teaching it the flat layout.
- `lib/main.dart` — gallery entry, imports old `file_diff_viewer/preview`,
  `layout/app`, `shadcn_localizations`.
- `lib/examples/` (5 pages + README) — relative `../registry/components/<category>/…`
  imports, incl. removed `form/text_field` and `display/text`.
- `tool/registry/*`, `tool/theme/*`, `tool/maintenance/*` — ~20 files reference
  the `lib/registry` literal / old category paths (manifest + barrel + schema tools).
- `docs/lib/**` — `docs/lib/ui/shadcn/` mirror + `components_registry.dart`,
  `registry_guide_page.dart`; docs has its own `shadcn.lock`.
- CLI repo (READ ONLY, Phase 5): discovery/installer/manifest-resolver touchpoints
  in `shadcn_flutter_cli/lib/src/` (see §9).

## 8. Pubspec deps that become unused (verified by import grep)

- New tree has **zero** real imports of `data_widget` (vendored as
  `foundation/data.dart` + `data_messenger.dart`), `gap` (vendored as
  `foundation/gap.dart`), `phonecodes`/`country_flags` (vendored as
  `primitives/countries.dart` + `primitives/phone_number.dart`), `cross_file`
  (abstracted behind `foundation/platform.dart`), `web` (only old
  `file_drop_adapter_web.dart` used it), `skeletonizer` (widgets-only shimmer),
  `animation_kit` (one old checkbox import), `email_validator` (regex in
  `primitives/form_core/validators.dart`). All were imported only by the old
  tree → **remove** after cutover (keep `flutter`, `flutter_localizations`,
  `cupertino_icons`, `intl` (localizations), `expressions` (new `formatter`
  imports it)). Verify with `flutter pub deps` + analyze before removing.

## 9. Risks + rollback

- Risks: (1) cutover commit is huge (delete 145-dir tree + rename) — review by
  `git status`/`git diff --stat`, never by reading files; (2) old-layout
  manifest/barrel tools silently generate wrong output — gate on §3.8 checks,
  not on tool exit codes; (3) `docs/lib/ui/shadcn` mirror drifts — rebuild it
  in the same commit or file a follow-up; (4) stale counts (120/123 vs 118) and
  the missing `gen_theme_schema` tool confuse Phase-5 builders — fixed by §5 notes.
- Rollback: branch `refactor/rearchitecture` is pushed; rollback =
  `git revert <cutover-commit>` (single commit per §3.2). Pushed-state of the
  branch was NOT independently verified from here (no fetch per hard rules) —
  confirm `git status -sb` shows no divergence before running `--apply`.

## 10. What the CLI (Phase 5) must change

Flat `components/<name>/` resolution (no category dirs); topological install of
foundation → theme → primitives → requested components; single-owner preflight
(refuse install if a symbol would be defined twice); preserve user-owned
`*_theme.dart` on update (never overwrite); generate one `app_theme.dart` from
the chosen theme JSON (replaces regex-patching + `preset_themes.dart` + 168
generated files); new `components.json` schema matching the `deps`
(foundation/theme/primitives/components) shape; install paths
`ui/shadcn/<name>/` (flat). No `migrate` command (clean break, user decision
2026-10-06 — contradicts REARCHITECTURE_PLAN.md §9 Phase 5 line; amend PLAN).
Touchpoints: `shadcn_flutter_cli/lib/src/` discovery, installer,
`component_manifest_resolver.dart`, `studio_manager.dart`.

## 11. Dry-run output (`.rearch/cutover.sh --dry-run`, 2026-10-08)

```
=== P4 cutover --dry-run ===
kit: /Users/ibrar/Desktop/infinora.noworkspace/shadcn_copy_paste/shadcn_flutter_kit
BLOCKERS (5): color_picker phone_input filter_bar color_input text_animate — not yet in lib/registry_next/components/
--- step 1: rename trees (single commit) ---
[dry-run] git -C … mv flutter_shadcn_kit/lib/registry flutter_shadcn_kit/lib/registry_old
[dry-run] git -C … mv flutter_shadcn_kit/lib/registry_next flutter_shadcn_kit/lib/registry
--- step 2: delete old tree (same commit) ---
[dry-run] git -C … rm -r -q flutter_shadcn_kit/lib/registry_old
--- step 3: rewrite registry_next/ imports to registry/ ---
[dry-run] rewrite registry_next/ -> registry/ in      181 files (sed)
--- step 4: manual rewrites (old category paths no longer exist) ---
[dry-run] listed: lib/main.dart, lib/flutter_shadcn_kit.dart, lib/examples/* (8 files)
--- step 5: regenerate manifests ---
[dry-run] registry_components_manifest + registry_index_generate + theme_index_generate
--- step 6: retire old tests ---
[dry-run] git rm -r test/registry/components + 2 shared-manifest tests
--- step 7: post-cutover gates ---
[dry-run] flutter analyze / flutter test / check_layers / check_single_owner / check_user_theme
=== done (--dry-run) ===
```

(Full verbatim output in the P4-X session log; paths abbreviated here with `…`.)

## Open questions

- `p4_batches.json` `cutover[2]` says 120 entries; P4_PLAN §1 says 123. Verified
  118 — orchestrator to correct the JSON before Phase 5 (or confirm `multi_select`
  + B24/B25 accounting if it disagrees).
- `tool/gen_theme_schema.dart` (P4_PLAN §5) was never built — confirm it is
  Phase-5 scope and the hand-written `theme` sections in new `meta.json` are
  acceptable until then.
- `docs/lib/ui/shadcn/` mirror + stale `playground/playground_app` rsync rule in
  AGENTS.md — orchestrator to rule: re-mirror docs in the cutover commit or follow-up.

