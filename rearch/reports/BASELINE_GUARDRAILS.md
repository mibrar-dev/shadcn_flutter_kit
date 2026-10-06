# Baseline guardrails (P1-B)

Date: 2026-10-06 · Branch: `refactor/rearchitecture` · Kit: `flutter_shadcn_kit`

Guardrail scripts written in this task:

| Script | Purpose | Output |
|---|---|---|
| `tool/rearch/check_single_owner.dart` | every top-level name in exactly one owner unit | `rearch/reports/baseline/single_owner.json` |
| `tool/rearch/check_layers.dart` | layer direction + hygiene + declared deps | `rearch/reports/baseline/layers.json` |
| `tool/rearch/api_snapshot.dart` | public API per component + `--diff` | `rearch/reports/baseline/api.json` |

All three scripts share helpers under `tool/rearch/src/` and are covered by
fixture tests in `test/rearch/` (33 tests).

## P2-C updates (guardrail tooling)

New/changed rules and checks since the P1-B baseline:

| Rule / tool | Behavior |
|---|---|
| `undeclared-dependency` | `preview.dart` files are now excluded (previews are not CLI-installed). Count moved from 71 to **19** with identical logic otherwise. |
| `installable` (new, error) | Every component directory (`components/<name>` in the new tree, `components/<category>/<name>` in the old tree): has `meta.json`, `meta.id` == directory name, entry file `<dir>.dart` exists, and every file listed in `meta.files` exists. |
| `no-impl-dir` (new, error) | New tree only (`--new-layout`, inferred when the root ends with `registry_next`): no `_impl/` directory under `components/`. |
| layer detection | Both trees supported: legacy `shared/**` is the shared layer; new tree maps root-level `foundation/` (L0), `theme/` (L1), `primitives/` (L2) and `components/` (L3). New-tree `foundation|theme|primitives` files are attributed to owner units exactly like `shared/<group>/<stem>` so `undeclared-dependency` applies there too. |
| `tool/rearch/check_user_theme.dart` (new) | Validates user-owned `components/<name>/<name>_theme.dart`: imports limited to `package:flutter/widgets.dart`, `<name>_style.dart`, `../../theme/*.dart`; only top-level `const` variable declarations; no function declarations, no closures, no `resolveWith`, no non-const constructor calls. `--json`, `--strict`. |

### OLD tree (`lib/registry`) baseline re-run with the new rules

`installable`: **6 findings** (all error) —

| Component | Problem |
|---|---|
| `components/navigation/tab_list` | missing entry file `tab_list.dart` |
| `components/layout/group` | missing entry file `group.dart` |
| `components/form/hsl` | missing entry file `hsl.dart` |
| `components/form/hsv` | missing entry file `hsv.dart` |
| `components/form/sortable` | meta id `form_sortable` != directory `sortable` |
| `components/display/fade_scroll` | meta id `fade_scroll_display` != directory `fade_scroll` |

`no-impl-dir`: 0 finding on the OLD tree (rule is new-layout only; legacy
`shared/**/_impl` stays allowed until cutover).
`undeclared-dependency`: 19 (was 71 — the 52 findings in `preview.dart`
files are now excluded). `layers.json` in this directory has been regenerated.

## How to reproduce

```bash
cd $APP
dart run tool/rearch/check_single_owner.dart --json $KIT/rearch/reports/baseline/single_owner.json
dart run tool/rearch/check_layers.dart       --json $KIT/rearch/reports/baseline/layers.json
dart run tool/rearch/api_snapshot.dart --all --out $KIT/rearch/reports/baseline/api.json
```

| Command | Outcome | Runtime |
|---|---|---|
| `dart format --set-exit-if-changed tool/rearch test/rearch` | clean (exit 0) | 0.1s |
| `dart analyze tool/rearch test/rearch` | 0 issues | 4s |
| `flutter test test/rearch` | 27/27 pass | 1s |
| `check_single_owner` (full registry) | exit 0 | 5.2s |
| `check_layers` (full registry) | exit 0 | 5.3s |
| `api_snapshot --all` (full registry) | exit 0 | 5.1s |

Note: this Flutter version's `flutter analyze` has no directory arguments, so
`dart analyze tool/rearch test/rearch` was used for the scoped check. The
whole-project `flutter analyze` reports 7 pre-existing issues (6×
`use_null_aware_elements` in `tool/theme/*`, 1× `unnecessary_cast` in
`test/registry/*`) — none in `tool/rearch` or `test/rearch`. The earlier
`rearch/logs/baseline_analyze.txt` ("No issues found", "Analyzing registry...")
was produced against a different target and does not reflect the full package.

Environment: Dart 3.13.4, `analyzer` 6.4.1 (pinned dev dependency, `parseString`
unresolved AST), 1,969 Dart files scanned out of 2,053 in `lib/registry`
(84 files under `shared/theme/generated/**` skipped by default). **0 files with
syntax errors** — the pinned analyzer parses the current tree cleanly.

## 1. `check_single_owner` — baseline

```
files scanned:        1969
top-level declarations: 3060
duplicate names:       166  (public 131 = ERROR, private 35 = WARNING)
identical copies:      107
diverged copies:        59
same-owner repeats:      5  (name declared twice inside one owner unit; excluded)
duplicate declaration sites: 335  (169 excess copies beyond the first)
```

By declaration kind (duplicate names whose kind set is exactly one kind):
`class` 123, `typedef` 13, `mixin` 8, `enum` 6, `function` 6, `extension` 5,
`variable` 3, plus 2 mixed `class`+`typedef` names.

### Top duplicate clusters (owner units)

| Names | Owners |
|---|---|
| 28 | `input` ↔ `text_field` |
| 11 | `tab_container` ↔ `tabs` |
| 10 | `autocomplete` ↔ `text_field` |
| 10 | `UNKNOWN` ↔ `text` |
| 8 | `tab_pane` ↔ `tabs` |
| 8 | `UNKNOWN` ↔ `form` |
| 7 | `UNKNOWN` ↔ `subfocus` |
| 6 | `menu` ↔ `menubar` |
| 6 | `scrollable` ↔ `scrollable_client` |
| 5 | `menu` ↔ `popup` |
| 5 | `UNKNOWN` ↔ `control` |

### Top 20 owner units by duplicate names

| Owner unit | Duplicate names |
|---|---|
| `UNKNOWN` | 54 |
| `text_field` | 40 |
| `input` | 28 |
| `tabs` | 21 |
| `menu` | 12 |
| `tab_container` | 11 |
| `autocomplete` | 10 |
| `text` | 10 |
| `form` | 9 |
| `color_picker` | 8 |
| `subfocus` | 8 |
| `tab_pane` | 8 |
| `clickable` | 6 |
| `control` | 6 |
| `menubar` | 6 |
| `scrollable` | 6 |
| `scrollable_client` | 6 |
| `shared/utils/widget_extensions` | 6 |
| `fade_scroll` | 5 |
| `fade_scroll_display` | 5 |

### `UNKNOWN` owner units

41 shared files could not be attributed to an owning entry file (54 duplicate
names involve them). Examples:
`shared/utils/_impl/state/__separated_flex_state.dart`,
`shared/primitives/_impl/core/text_modifier.dart`,
`shared/primitives/_impl/utils/component_value_controller.dart`,
`shared/primitives/_impl/core/replace_result.dart`.
These are `_impl` files whose stem has no entry file at the group root and no
group-root entry file exports them; per the documented heuristic they fall back
to `UNKNOWN` (see "Definitions" below). Phase 1 should decide the owner for
each or delete dead ones.

### Sanity check vs the plan's "~148 duplicated names"

Our exact measurement is 166 names / 335 declaration sites. The difference is
methodology, not disagreement:

* 131 of the 166 are public; 35 are private (file-private names cannot collide
  at compile time, hence WARNING).
* Restricting to public `class`/`enum` names only gives **94**; including
  private ones gives **129**; adding mixins (8) and typedefs (13) gives **150**.
  The plan's 148 sits in that band — it most likely counted classes, enums,
  mixins and typedefs and/or excluded a couple of names.
* Our rule also excludes 5 same-owner repeats (per the single-owner definition).

## 2. `check_layers` — baseline

```
files scanned:  1969, files with syntax errors: 0
errors: 4441, warnings: 92  (post-P2-C recount; undeclared-dependency
previews excluded (-52), installable added (+6))
```

| Rule | Count (P1-B → P2-C) | Severity | Notes |
|---|---|---|---|
| `no-material` | 205 | error | 203× `package:flutter/material.dart`, 2× `package:flutter/cupertino.dart`; 203 distinct files |
| `no-part` | 2246 | error | 1123 `part of` + 1123 `part` directives |
| `no-ignore-for-file` | 1964 | error | every file except 5 has a blanket ignore comment |
| `layer-direction` | 1 | error | see below |
| `undeclared-dependency` | 71 → **19** | error | aggregated per (file, missing dependency); `preview.dart` now excluded |
| `file-too-long` | 92 | warning | >400 physical lines |
| `installable` | **6** | error | see "P2-C updates" |
| `no-impl-dir` | 0 | error | new layout only |

### Top offending components (all rules combined)

| Findings | Owner |
|---|---|
| 234 | `shared/primitives` |
| 215 | `components/form/text_field` |
| 156 | `components/form/form` |
| 108 | `components/layout/table` |
| 103 | `components/navigation/navigation_bar` |
| 95 | `shared/utils` |
| 89 | `components/display/markdown` |
| 89 | `components/overlay/menu` |
| 85 | `components/overlay/drawer` |
| 81 | `components/form/input` |
| 80 | `components/form/select` |
| 75 | `components/display/calendar` |
| 75 | `components/display/tree` |
| 74 | `components/navigation/tabs` |
| 70 | `shared/theme` |
| 69 | `components/control/button` |
| 64 | `components/display/chat` |
| 64 | `components/form/formatted_input` |
| 57 | `components/form/color_picker` |
| 57 | `components/navigation/stepper` |

### Rule details

* **`no-material`** — 203 distinct files: 131 `preview.dart` files and 72
  non-preview files (49 of them component top-level entry files such as
  `slider.dart`, `tabs.dart`, `form.dart`, `text_field.dart`; 21 `_impl`
  files; `components/preview_types.dart`; `shared/primitives/text.dart`).
  The plan's "~20 component files importing material.dart" does not match any
  single straightforward metric on the current tree (bare non-preview imports
  without `show`/`hide`: 10; non-preview files: 72; entry-style files: 49).
  The orchestrator should re-check the original query — this baseline reports
  the exact per-directive count (205) and file count (203).
* **`no-part`** — exactly 1123 `part of` directives, which matches the
  orchestrator's "~1,123 files with `part of`" 1:1. The rule counts the
  matching `part` directives as well (another 1123), hence 2246 findings.
* **`no-ignore-for-file`** — 1964 of 1969 files start with
  `// ignore_for_file: duplicate_import, ...`; only 5 files are clean.
* **`layer-direction`** — a single violation:
  `shared/localizations/shadcn_localizations_extensions.dart:3` imports
  `components/utility/locale_utils/locale_utils.dart` (shared → components).
  Every other cross-layer import is downward or same-layer; components
  importing the legacy `shared/**` tree are tolerated during migration.
* **`undeclared-dependency`** — 71 aggregated findings: 60 missing
  `dependencies.components` ids and 11 missing `dependencies.shared` ids.
  52 of the 71 are in `preview.dart` files (previews are not installed by the
  CLI, so a later revision may want to exclude them; the brief did not).
  Most common missing deps: `button` (13), `scaffold` (5), `card` (4),
  `text_field` (4), `overlay_configuration` (4), `outlined_container` (4),
  `platform_utils` (3). Top files: `navigation_bar/preview.dart` (6),
  `markdown/preview.dart` (3), `color_picker/preview.dart` (3),
  `file_picker/preview.dart` (3), `card/preview.dart` (3),
  `hover_card/preview.dart` (3).
* **`file-too-long`** — 92 files over 400 lines, led by
  `shared/icons/bootstrap_icons.dart` (6959),
  `shared/icons/lucide_icons.dart` (6498),
  `shared/icons/bootstrap_icons_list.dart` (6424),
  `shared/icons/lucide_icons_list.dart` (4765),
  `shared/theme/preset_themes.dart` (4390),
  `components/overlay/gooey_toast/preview.dart` (3161),
  `markdown/_impl/state/markdown_state.dart` (1858).
  Top areas: `markdown` (9), `slider` (8), `shared/theme` (7),
  `shadcn_localizations` (6), `shared/icons` (6).

## 3. `api_snapshot --all` — baseline

```
components: 144 (of 145 meta.json components)
symbols:    1352
skipped:    1  - tab_list has no entry dart file at all
warnings:   2  - flex exports package:flutter/widgets.dart and rendering.dart
```

Symbol kinds: `class` 984, `typedef` 141, `function` 87, `enum` 83,
`mixin` 23, `extension` 19, `variable` 15.

Largest public APIs: `button` (86 symbols), `form` (81), `error_system` (47),
`text_field` (40), `file_picker` (38), `markdown` (35), `navigation_bar` (29),
`select` (29), `table` (28), `tree` (27).

Two components have `id` ≠ directory name and are resolved by falling back to
`<dir>.dart` / the single top-level dart file: `form_sortable` (dir
`sortable`) and `fade_scroll_display` (dir `fade_scroll`). `hsv`, `hsl`,
`group` use their meta-listed single top-level entry
(`hsv_color_slider.dart`, `hsl_color_slider.dart`, `group_widget.dart`).

## Definitions (as implemented)

* **Owner unit** — nearest ancestor directory containing `meta.json` (a
  component, labelled by its `meta.json` id); otherwise for `shared/**` the
  path `shared/<group>/<file-stem>`. `_impl/**` files are attributed to the
  shared group's owning entry file when determinable: (1) same-stem entry file
  at the group root (`shared/<group>/<stem>.dart`), else (2) a group-root entry
  file that directly exports the `_impl` file; otherwise `UNKNOWN`.
* **Shared id → files** — union of `shared/shared_manifest.json`
  (`groups[].files[].source`, falling back to `root` + `path`) and
  `manifests/components.json` (`shared[].files[].source`); the leading
  `registry/` prefix is stripped so paths are relative to the registry root.
* **Layers** — first path segment: `foundation`=0, `theme`=1, `primitives`=2,
  `components`=3; legacy `shared/**` is the special `shared` layer. A file may
  import same-or-lower layers; numbered layers may import `shared` (migration
  tolerance); `shared` may import shared/foundation/theme/primitives but never
  `components`.
* **`undeclared-dependency`** — checked for component-owned files only
  (owner kind `component`), for both `import` and `export` directives that
  resolve inside the registry: importing another component's file requires its
  id in `dependencies.components`; importing a shared file requires an id in
  `dependencies.shared` that maps to that file. Findings are aggregated per
  (importer file, missing dependency) with up to 5 example import sites.
* **Identity for duplicates** — token stream of the declaration with comments
  and whitespace removed; `identical: true` when all copies normalize to the
  same token sequence.
* **`--skip-generated` (default on)** — excludes `shared/theme/generated/**`.

## Open items for Phase 1

1. `tab_list` has no Dart entry file (`meta.json` lists no top-level dart
   file) — needs an entry or removal.
2. 41 shared `_impl` files resolve to owner `UNKNOWN`; decide owners or delete.
3. Preview files inflate `no-material` and `undeclared-dependency`; decide
   whether previews are in scope for the CLI guardrails.
4. `id` ≠ directory for `form_sortable`/`sortable` and
   `fade_scroll_display`/`fade_scroll`; the flat-layout migration must fix this.
5. `no-ignore-for-file` is at 1964/1969 files — blanket ignores are the norm
   today; the migration removes them.
6. The plan's "~20 material files" and "148 duplicates" figures differ from
   the exact measurements above; reconcile when writing ARCHITECTURE v2.
