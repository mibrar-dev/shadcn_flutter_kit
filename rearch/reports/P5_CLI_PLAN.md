# P5 — CLI rewrite plan (registry manifest v2)

Status: **planning (read-only)**. Outputs of brief P5-A: this file and
`rearch/reports/registry_manifest.v2.schema.json`. No CLI or kit file is
touched. The CLI repo is read-only here; the orchestrator applies the batches.

Source of truth: `REARCHITECTURE_PLAN.md` §6 + §9 (Phase 5), `rearch/reports/
P4_CUTOVER.md` §5/§10, `rearch/reports/THEME_DESIGN.md` §5, the post-cutover
tree `flutter_shadcn_kit/lib/registry_next/`, and the CLI at
`shadcn_flutter_cli` branch `refactor/rearchitecture` (HEAD `de35dd2`).

## 0. Verified facts (what this plan is built on)

- **Cutover state.** `lib/registry_next/` (new) and `lib/registry/` (old)
  still coexist; `rearch/cutover.sh --apply` has not run. All **118**
  component dirs now exist under `registry_next/components/`, including the
  five P4_CUTOVER §2 blockers (`color_picker`, `phone_input`, `filter_bar`,
  `color_input`, `text_animate`) — so the cutover is unblocked on components.
  P5 assumes the cutover commit renames `registry_next/ → registry/`.
- **Tree counts** (measured): 118 components, 118 `meta.json`, 118
  `preview.dart`, 93 `<name>_theme.dart`, 93 `<name>_style.dart`. Dart files:
  foundation 20, theme 6, primitives 202, components 423. Themes: 42 presets +
  `index.json` + `themes.schema.json`.
- **meta.json `files[]` is exact**: for all 118 components the declared file
  list equals the real `.dart` files in the directory (0 mismatches).
- **meta.json top-level keys**: `id name category description tier install
  import tags deps files api theme` (all 118) plus optional `notes`
  (39), `accessibility` (9), `sizes` (9), `strings` (1). **No `pubspec`,
  `assets`, `fonts`, `platform` or `locale` keys** — those metadata blocks no
  longer exist (see §7 open question on pubspec deps).
- **`deps` shape**: all 118 declare `{foundation,theme,primitives,components}`
  (enforced by `tool/rearch/check_layers.dart` `undeclared-dependency`).
  7 components declare a `theme` section whose `userFile` points at **another**
  component's theme file: `context_menu`/`dropdown_menu`/`menubar`/`popup` →
  `menu/menu_theme.dart`, `multi_select` → `select/select_theme.dart`,
  `text_area` → `input/input_theme.dart`, `spell_check_suggestions_toolbar` →
  no class. So `userOwned[]` must list only the `*_theme.dart` physically in
  the component directory.
- **Layer units** used by component deps: 15 foundation ids (files or folders;
  `icons` is a folder, `icons/lucide_icons` a nested stem), 5 theme ids (all
  files), 63 primitive ids (files or folders). **Primitive→primitive edges:
  27** (e.g. `form_core → clickable, localizations, overlay,
  popover_controller, widget_states`); foundation and theme have **no**
  internal edges. The closure therefore needs the primitive deps graph.
- **Relative imports only.** No component imports Material/Cupertino (matches
  are comments/READMEs only) and no file imports
  `package:flutter_shadcn_kit/...`. Real third-party imports in the tree:
  `intl` (primitives/localizations + number_ticker preview),
  `expressions` (formatter), `flutter_localizations` (app).
- **CLI**: 218 Dart files, ~29.8k LOC. Commands: `add remove dry-run list
  search info init registries default sync project assets locale theme platform
  reset doctor validate audit deps feedback version upgrade docs`. v1 lock file
  is `shadcn.lock` (`lockfileVersion: 1`) with `registries` + `components`.

## 1. The contract the CLI must implement

1. **Flat `components/<name>/`** — no category directories, no `shared/`.
2. **Layers are implicit**: `foundation/`, `theme/` and `primitives/` are
   installed as a dependency closure, never addressed as components.
3. **One generated manifest** `lib/registry/manifests/registry.json`
   (`schemaVersion: 2`, see the sibling JSON Schema) replaces
   `manifests/components.json` + `index.json` + `theme.index.json` +
   `shared_manifest.json` + per-component `meta.json` resolution.
4. **Themes are JSON** (`themes/<id>.json`, schemaVersion 2). The CLI writes
   one values-only `theme/app_theme.dart` by running the `gen_app_theme` logic
   — full rewrite, no regex patching, no `preset_themes.dart`.
5. **`<name>_theme.dart` is user-owned** — `add`/`update` never overwrite or
   delete it; `remove` leaves it unless `--purge-user-themes`.
6. **Clean break** — no `migrate` command, no v1 config migration.

## 2. Command surface

Names users know are kept. "adapt" = same name/flags, new manifest source;
"rewrite" = same name, new implementation; "new" = new command.

| command | status | purpose |
|---|---|---|
| `init` | rewrite | pick target dir, copy layer core, choose preset → `app_theme.dart`, write lock |
| `add <ids…>` | rewrite | transitive closure, depth-preserving copy, user-owned safe, `--dry-run`, `--json` |
| `remove [ids…]` | adapt | delete registry-owned files, keep user-owned, refuse if dependents |
| `update [ids…]` | **new** | hash-based: overwrite unchanged, report modified, never touch user-owned |
| `list` / `ls` | adapt | list components from the manifest |
| `search <q>` | adapt | search manifest tags/name/description |
| `info <id>` | adapt | deps closure, files, api, theme class |
| `theme list` | adapt | read `themes` from the manifest |
| `theme apply <preset>` | rewrite | preset JSON → validate → generate `app_theme.dart` → lock |
| `doctor` | rewrite | closure + layout + drift + user-owned checks |
| `dry-run` | keep | thin alias of `add --dry-run` |
| `registries` / `default` | keep | multi-registry directory + default selection |
| `validate` | rewrite | validate the registry manifest against the v2 schema |
| `audit` | adapt | installed-vs-lock drift |
| `deps` | **retire or repurpose** | old: compare pubspec deps; v2 has no pubspec metadata (see §7) |
| `sync` / `project` / `reset` | adapt | scaffolding/reset, now layer-aware |
| `assets` / `locale` / `platform` | **retire** | no metadata source in v2 (see §7) |
| `version` / `upgrade` / `feedback` / `docs` | keep | unchanged |

### 2.1 `init [--dir <path>] [--theme <id>] [--yes] [--json]`
- Target dir default `lib/ui/shadcn` (`--dir`, else `.shadcn/config.json`
  `installPath`). Writes `.shadcn/config.json` (installPath, manifest ref).
- Copies the **always-on core**: every `foundation` unit and every `theme`
  unit from the manifest (no component).
- Chooses a preset (`--theme`; interactive list when TTY; `--yes` needs a
  default — see §7 open question) and runs `theme apply` to write
  `<installRoot>/theme/app_theme.dart`.
- Writes `shadcn.lock` v2 (§4). Does **not** install any component.
- Ensures `pubspec.yaml` has `intl` + `flutter_localizations` (and
  `expressions` only when `formatter` is later added); reports missing ones.

### 2.2 `add <ids…> [--dry-run] [--json] [--force] [--all] [--include-preview]`
- Resolve the **transitive closure**: requested components →
  `deps.components` (components) → `deps.primitives` + each primitive's
  `deps.primitives` → all `deps.foundation` / `deps.theme` units; plus the
  always-on core from `init` if absent.
- **Single-owner preflight** (v2 replacement for the old namespace-collision
  policy): union the manifest `api` symbols of the closure and of everything
  already installed; refuse with a clear list if any symbol would be defined
  twice (mirrors `tool/recheck/check_single_owner.dart`).
- Copy files **verbatim**, depth-preserving (§3); skip existing user-owned
  files; report every skipped/modified file.
- `--dry-run` prints the plan (`DryRunPlan` v2: components, primitives, layer
  units, files, pubspec deltas, symbols); `--json` emits it.
- Write/refresh lock v2 and regenerate the optional `app_components.dart`
  barrel (§5).
- `--include-preview` also copies `preview.dart` (default: never).

### 2.3 `update [ids…] [--all] [--check] [--json]`
- For every installed registry-owned file: if `sha256(disk) == sha256(lock)`
  → overwrite with the manifest's current content; if it differs → report
  **locally modified** and skip; if the file no longer exists in the manifest
  → report **removed upstream** and leave it.
- **Never** reads or writes `userOwned` paths (report drift only).
- `--check` = report-only; exit `1` when anything is behind or modified.
- Regenerates `app_theme.dart` from the lock's theme id and the current preset.
- Rewrites the lock hashes for files it updated.

### 2.4 `theme list` / `theme apply <preset> [--refresh] [--json]`
- `list`: `id`, `name`, `modes` from `manifests/registry.json`.
- `apply`: load `themes/<id>.json`, validate against `themes.schema.json`
  (schemaVersion 2), then emit `<installRoot>/theme/app_theme.dart` with the
  exact output of `tool/rearch/gen_app_theme.dart` (`build<Id>Theme`,
  `ShadcnColors`/`ShadcnTokens`/`ShadcnFonts` blocks). Update lock `theme`.
- Future (separate work): `theme import <css|json|url>` (THEME_DESIGN §5.3).

### 2.5 `doctor [--json]`
Checks: manifest loads + validates; every installed component's closure is
present; layer dirs exist at the right depth; each installed file hash matches
the lock (drift report); user-owned files are present and unmodified-or-drift;
`pubspec.yaml` has the required SDK deps; no relative import in an installed
file escapes `<installRoot>/{foundation,theme,primitives,components}`.
Exit codes: `0` clean, `1` drift/modified, `2` broken closure, `3` manifest
invalid.

## 3. Install layout + import rewriting rule

- Registry root `R` (source) = `flutter_shadcn_kit/lib/registry` (post-cutover).
- Install root = config `installPath` (default `lib/ui/shadcn`).

Depth-preserving, byte-for-byte mapping:

| source (`R/…`) | destination (`<root>/…`) | copied? |
|---|---|---|
| `foundation/<…>` | `foundation/<…>` | yes |
| `theme/<…>` | `theme/<…>` | yes |
| `primitives/<…>` | `primitives/<…>` | yes |
| `components/<name>/<…>` | `components/<name>/<…>` | yes |
| `themes/<id>.json` | — | no (consumed to generate `theme/app_theme.dart`) |
| `manifests/registry.json` | — | no (build-time input) |
| `meta.json` / `README.md` | — | no (lock replaces meta; README optional) |
| `preview.dart` | — | only with `--include-preview` |

**Rule: copy verbatim, no import rewriting.** Verified from the tree:

- component → layer: `../../foundation/geometry.dart`,
  `../../theme/theme.dart`, `../../primitives/clickable.dart` (a component is
  **2** levels below `R`; the layers are **1**).
- component → component: `../sortable/sortable.dart` (`tabs`) and the
  equivalent registry-root form `../../components/anchor/anchor.dart`
  (`overlay_configuration`). Both resolve under `R/components/`.
- top-level primitive → layer: `../theme/theme.dart`; a primitive in a
  subfolder → `../../theme/theme.dart`. Same depth rule.
- `preview.dart` uses the same depths as the main file.

Why flattening to `<root>/<name>/` breaks: `../../foundation/…` would resolve
to `lib/ui/foundation/…`, which does not exist. The CLI must keep
`components/` and the three layer directories at the same relative depth.

**Discrepancy to fix (flagged).** Every `meta.json` `"import"` string reads
`package:<your_app>/ui/shadcn/<name>/<name>.dart` — missing `components/`. The
physical imports require `ui/shadcn/components/<name>/<name>.dart`. The CLI
must compute the import path from `install.root` + `install.componentsDir` +
id rather than trust the meta string; the manifest generator should also
correct the meta strings. UNVERIFIED whether the flat path was an earlier
intent — the imports are authoritative.

**Guard before writing.** Parse every copied file's relative imports with
`package:analyzer` (already a dev dependency, `^6.4.1`, `parseString`) and
assert each resolves inside
`<root>/{foundation,theme,primitives,components}`. Any escape aborts the
install. This is cheap insurance against future meta/import drift.

## 4. Lock file format v2 (`shadcn.lock`)

`shadcn.lock` is the only install-state file (no `.shadcn/state.json`,
`.shadcn/components/*` or `shadcn.lock` v1). Shape:

```json
{
  "lockfileVersion": 2,
  "registry": {
    "name": "shadcn_flutter",
    "ref": "refactor/rearchitecture",
    "manifestSha256": "…",
    "generatedAt": "2026-10-09T00:00:00Z"
  },
  "installRoot": "lib/ui/shadcn",
  "theme": {
    "id": "modern-minimal",
    "path": "lib/ui/shadcn/theme/app_theme.dart",
    "sha256": "…"
  },
  "layers": {
    "foundation": {
      "units": ["data", "gap", "icons"],
      "files": { "lib/ui/shadcn/foundation/data.dart": "…sha…" }
    },
    "theme":      { "units": ["color_tokens"], "files": { "…": "…" } },
    "primitives": { "units": ["clickable", "form_core"], "files": { "…": "…" } }
  },
  "components": [
    {
      "id": "button",
      "version": "1.0.0",
      "files": {
        "lib/ui/shadcn/components/button/button.dart": "…sha…",
        "lib/ui/shadcn/components/button/button_style.dart": "…sha…",
        "lib/ui/shadcn/components/button/button_group.dart": "…sha…"
      },
      "userOwned": {
        "lib/ui/shadcn/components/button/button_theme.dart": "…sha@install…"
      },
      "deps": {
        "foundation": ["data", "gap", "geometry"],
        "theme": ["color_tokens", "density", "theme"],
        "primitives": ["clickable"],
        "components": []
      },
      "api": { "classes": ["Button", "ButtonGroup"], "enums": ["ButtonVariant", "ButtonSize"] }
    }
  ]
}
```

Rules:

- `files` maps a **project-relative** path to the sha256 of what the CLI
  wrote. `update`/`doctor` diff this against disk.
- `userOwned` records the path + its hash **at install time** so drift can be
  reported, but `update`/`add` never rewrite it and `remove` never deletes it
  (unless `--purge-user-themes`).
- `layers.*.units` lets `remove` drop a layer unit once no installed
  component's closure references it.
- `api` (per component) lets the single-owner preflight run without re-reading
  the manifest.
- `registry.manifestSha256` is the sha256 of `manifests/registry.json`; a
  mismatch on `update` means "registry moved".

## 5. Module-by-module disposition

Paths are relative to `shadcn_flutter_cli/lib/src/`. **keep** = unchanged;
**adapt** = same responsibility, new manifest source; **rewrite** = same name,
new implementation; **delete** = remove with the module it served.

### 5.1 Presentation (commands)

| path | disposition |
|---|---|
| `presentation/cli/cli_parser.dart` | adapt — add `update`; drop `assets`/`locale`/`platform`/`deps` |
| `presentation/cli/command_metadata.dart` | adapt — add `update`, remove retired commands |
| `presentation/cli/command_registry.dart`, `command_dispatcher.dart`, `arg_helpers.dart`, `usage.dart` | keep |
| `presentation/cli/bootstrap*.dart`, `registry_selection.dart`, `registry_bootstrap*.dart`, `runtime_roots.dart` | keep |
| `presentation/cli/commands/add_command.dart` | adapt — `--dry-run`, `--json`, `--include-preview` |
| `presentation/cli/commands/remove_command.dart` | adapt |
| `presentation/cli/commands/info_command.dart`, `list_command.dart`, `search_command.dart` | adapt — manifest source |
| `presentation/cli/commands/theme_command.dart` | rewrite — preset → `app_theme.dart` |
| `presentation/cli/commands/init_command.dart` | adapt |
| `presentation/cli/commands/dry_run_command.dart` | keep (thin alias) |
| `presentation/cli/commands/registries_command`, `default` (in `commands_registry.dart`) | keep |
| `presentation/cli/commands/validate_command.dart` | rewrite — validate manifest v2 |
| `presentation/cli/commands/audit_command.dart` | adapt |
| `presentation/cli/commands_doctor.dart` | rewrite |
| `presentation/cli/commands/assets_command.dart`, `locale_command.dart`, `platform_targets.dart` | delete (no metadata source) |
| `presentation/cli/commands/project_command.dart`, `reset_command.dart`, `sync_command.dart`, `version_command.dart`, `upgrade_command.dart`, `feedback_command.dart`, `docs_command.dart` | keep/adapt |
| `presentation/cli/commands/deps_command.dart` | delete (see §7) |

### 5.2 Application services

| path | disposition |
|---|---|
| `application/use_cases/add/*` | adapt — closure over manifest layers |
| `application/use_cases/remove/*` | adapt |
| `application/use_cases/init/*` | adapt |
| `application/use_cases/search/*`, `registries/*` | keep |
| `application/use_cases/audit/*` | adapt |
| `application/use_cases/deps/*` | delete |
| `application/services/registry_dependency_graph.dart` | rewrite → `manifest_closure.dart` (component + primitive closure) |
| `application/services/registry_source.dart` | keep |
| `application/services/lockfile/shadcn_lock_repository.dart` | rewrite — lock v2 |
| `application/services/pubspec/*` | keep |
| `application/services/reset/*` | keep |
| `application/services/theme/theme_css.dart` | keep (future `theme import`) |
| `application/services/studio/studio_manager.dart` | adapt — read manifest + lock |
| `application/services/docs/docs_generator.dart` | adapt |
| `application/services/version/*`, `feedback/*` | keep |
| `application/services/command_health/*` | adapt |
| `application/services/installer_orchestrator.dart`, `init_config_overrides.dart` | keep |

### 5.3 Installer parts

| path | disposition |
|---|---|
| `installer/installer.dart` | adapt — init/add via closure; keeps `_topologicalLevels`/`installAllComponents` (de35dd2 survivor) |
| `installer/installer_file_install_part.dart` | adapt — depth-preserving destinations (de35dd2 survivor) |
| `installer/installer_platform_alias_part.dart` | adapt — barrel from manifest api; keep `_scanComponentLibrary` as `doctor` verifier; drop platform instructions |
| `installer/installer_manifest_part.dart` | rewrite — write lock v2 + barrel |
| `installer/installer_theme_part.dart` | rewrite — preset → `app_theme.dart` |
| `installer/installer_remove_part.dart` | adapt |
| `installer/installer_dry_run_part.dart`, `installer_dry_run_service.dart`, `dry_run_plan.dart` | adapt |
| `installer/installer_config_part.dart`, `installer_config_resolver.dart`, `install_target_policy.dart`, `installer_file_selection_policy.dart` | adapt |
| `installer/installer_manifest_service.dart` | adapt |
| `installer/installer_pubspec_part.dart`, `installer_pubspec_service.dart` | keep |
| `installer/installer_alias_entry.dart` | keep |
| `installer/component_manifest_resolver.dart` | **delete** (manifest is the single source; de35dd2 merge logic obsolete) |
| `installer/namespace_collision*.dart` (3 files) | **delete** → single-owner preflight |
| `installer/installer_shared_part.dart`, `installer_shared_service.dart`, `installer_registry_file_owner.dart` | **delete** (no shared groups) |
| `installer/installer_locale_part.dart` | **delete** (no locale metadata) |
| `installer/installer_platform_service.dart`, `installer_assets_update_result.dart`, `installer_fonts_update_result.dart` | **delete** |

### 5.4 Registry models + infrastructure

| path | disposition |
|---|---|
| `registry/registry_model.dart` | rewrite → `registry/manifest/registry_manifest.dart` |
| `registry/component.dart` | rewrite → manifest component/unit models |
| `registry/components_schema_validator.dart` | rewrite → `manifest_schema_validator.dart` (schemaVersion 2) |
| `registry/schema_source.dart`, `schema_validation_result.dart` | adapt |
| `registry/registry_location.dart` | keep |
| `registry/shared_item.dart`, `registry_file.dart`, `file_dependency.dart`, `font_asset.dart`, `font_entry.dart`, `platform_entry.dart` | **delete** |
| `infrastructure/registry/*` (index_loader, registry_loader, theme_index_loader, theme_preset_loader, registry_repository_adapter, theme_index_entry) | rewrite — manifest + themes |
| `infrastructure/registry_directory/*` | keep |
| `infrastructure/resolver/v1/*` (resolver_v1, init_path_mapper, project_path_guard) | rewrite — manifest resolver |
| `infrastructure/io`, `persistence`, `network`, `cache` | keep |
| `domain/entities/component.dart` | adapt |
| `domain/policies/add_resolution_policy.dart`, `include_exclude_policy.dart` | adapt |
| `domain/value_objects/*`, `domain/repositories/*` | keep |

### 5.5 What survives of `de35dd2` (installer/alias WIP)

| de35dd2 change | fate |
|---|---|
| `installer.dart` — `_topologicalLevels` + level-ordered bulk install | **survives** (used by `add --all` and core install) |
| `installer_file_install_part.dart` (37 lines) | **survives** (adapt destination roots) |
| `installer_platform_alias_part.dart` (455 lines) — `_scanComponentLibrary` transitive scanner + deterministic duplicate-owner hiding | **partial**: scanner + hiding survive as the `doctor` verifier and optional barrel source; platform-instruction code deleted |
| `component_manifest_resolver.dart` (167 lines) — meta/components.json union/merge | **obsolete** — deleted with the resolver |
| `test/installer_alias_part_test.dart` (265 lines) | survives (adapt) |
| `test/component_manifest_resolver_test.dart` (94 lines) | delete |
| `test/installer_test.dart` additions (127 lines) | adapt |
| `pubspec.lock` churn | keep |

## 6. Test plan

### 6.1 Unit
- **Manifest load + validate**: parse `manifests/registry.json`; reject
  `schemaVersion != 2`, unknown `deps` keys, missing files, bad relPaths.
- **Closure**: component → `deps.components` → `deps.primitives` (+ the 27
  primitive→primitive edges) → foundation/theme; cycles rejected.
- **Lock v2**: round-trip; sha256 of written files; `update` diff
  (unchanged / modified / removed-upstream); user-owned never written.
- **Single-owner preflight**: two components sharing a symbol refused; a
  component's own repeated symbols fine.
- **Import-depth guard**: a fixture with `../../../foundation/…` is refused.
- **Destination map**: `R/components/x/y.dart` → `<root>/components/x/y.dart`;
  layers → `<root>/<layer>/…`.
- **gen_app_theme**: run the kit generator over all 42 presets; the CLI's
  vendored/shared copy must match byte-for-byte.

### 6.2 Golden fixture install
A tiny fixture registry (`test/fixtures/registry_v2/`): 3–4 components, 2
primitives, 1 theme, a precomputed `registry.json`, expected file tree and
expected `shadcn.lock`. Golden test: run `add a b` into a temp dir and assert
the tree and lock byte-for-byte.

### 6.3 e2e (acceptance gate)
`flutter create` a temp app → `init --theme claude` → `add button` →
**`flutter analyze` must pass with 0 issues**. Extend to
`add input select tabs` (exercises the primitives closure,
component→component and a user-owned theme). Then: `update` is a no-op;
mutate `button_theme.dart` → `update --check` reports drift and `update`
leaves it; `remove button` leaves the user file.

### 6.4 Regression / compatibility
- `command_matrix_test.dart` updated (retired commands gone).
- Exit-code table unchanged.
- Multi-registry: two registries both provide `button` → unqualified `add`
  fails, `@ns/button` works.

## 7. Open questions

1. **pubspec deps.** v2 `meta.json` has no `pubspec` block, but the tree
   imports `intl` (`primitives/localizations`), `expressions` (`formatter`)
   and `flutter_localizations` (`app`). Plan: `init` adds `intl` +
   `flutter_localizations`; `add` warns when `expressions` is needed.
   Recommend either a manifest extension (`registry.pubspec` / per-unit
   `pubspec`) or a small built-in map — **decision needed**. UNVERIFIED
   which the orchestrator prefers.
2. **Default preset for `init --yes`.** No preset is named
   `default`/`neutral`. Either add `defaultThemeId` to the manifest schema or
   hardcode one (e.g. `modern-minimal`). UNVERIFIED.
3. **`meta.json import` string** (flat vs `components/`, §3) — confirm the fix
   lands in the generator or the meta files.
4. **Retire `assets`/`locale`/`platform`/`deps`** — v2 has no metadata for
   them. Confirm clean-break deletion vs no-op stubs.
5. **Barrel `app_components.dart`** — keep generating it, or drop it in favour
   of explicit imports? The manifest makes it optional.
6. **Bundled vs remote registry** — the manifest can ship in the CLI package
   (bundled) or be fetched from GitHub at a ref. Multi-registry already exists
   (`registries.json` + `@ns/id`); v2 only adds `paths.manifestJson`. Confirm
   the bundled default.
7. **`theme import` (CSS)** — THEME_DESIGN §5.3; out of scope for the P5 core,
   separate batch.

## 8. Build batches (≤ ~3k LOC each, parallelisable)

Order: B1 → {B2 ∥ B3} → B4 → {B5 ∥ B6} → B7.

| batch | exact outputs | needs | est LOC |
|---|---|---|---|
| **B1** Manifest models + validator | `registry/manifest/*.dart` (`RegistryManifest`, `ManifestComponent`, `ManifestUnit`, `ThemePreset`), `manifest_schema_validator.dart`; deletes §5.4 model files | — | ~900 |
| **B2** Kit manifest generator | `flutter_shadcn_kit/tool/registry/registry_manifest_generate.dart` + test → writes `lib/registry/manifests/registry.json` per the schema | schema | ~700 |
| **B3** Lock v2 + hashing | rewrite `application/services/lockfile/shadcn_lock_repository.dart` + `hashing.dart` | — | ~500 |
| **B4** Installer core | `manifest_closure.dart`, `installer.dart`, `installer_file_install_part.dart` (depth map + import guard), `installer_remove_part.dart`, `dry_run_plan.dart`; deletes §5.3 files | B1, B3 | ~1600 |
| **B5** Commands | `add`/`remove`/`init`/`info`/`list`/`search`/`update` commands, `commands_doctor.dart`, `command_metadata.dart`, `cli_parser.dart` | B4 | ~1500 |
| **B6** Theme | rewrite `installer_theme_part.dart`, `theme_command.dart`, shared `gen_app_theme` library | B1 | ~800 |
| **B7** Tests + e2e | unit suites, fixture golden, e2e harness (§6) | B5, B6 | ~1200 |

Parallelism: B2 needs only the schema and can run alongside B1/B3; B3 needs
nothing. B5 and B6 run in parallel after B4. B7 is last.

## RESULT
status: done
files_written:
- /Users/ibrar/Desktop/infinora.noworkspace/shadcn_copy_paste/shadcn_flutter_kit/rearch/reports/registry_manifest.v2.schema.json
- /Users/ibrar/Desktop/infinora.noworkspace/shadcn_copy_paste/shadcn_flutter_kit/rearch/reports/P5_CLI_PLAN.md
commands_run:
- read/glob/grep over the kit registry_next tree and the CLI repo (read-only)
- `python3` scans of `components/*/meta.json` -> verified 118 components, deps shape, 27 primitive edges, files[]==actual, 7 shared-theme components
- `python3 -c json.load(...)` -> schema is valid JSON (190 lines, no truncation)
- `git log/status/show` in the CLI repo (read-only) -> HEAD de35dd2, branch refactor/rearchitecture
key_findings:
- Cutover not applied yet; all 118 components (incl. the 5 P4 blockers) are present in lib/registry_next -> P5 targets the post-cutover `lib/registry/`.
- Registry files use only depth-stable relative imports, so the install layout MUST be `<root>/{foundation,theme,primitives,components/<name>}/`; flattening to `<root>/<name>/` breaks `../../foundation/...`. No import rewriting needed.
- Every meta.json `import` string omits `components/` and is therefore wrong for the required layout (flagged; CLI should compute the path).
- v2 meta.json dropped `pubspec`/`assets`/`fonts`/`platform`/`locale`, so the old CLI's assets/locale/platform/deps machinery and shared-group installer become dead code; pubspec SDK deps need a new source (open question).
- de35dd2 survivors: the topological bulk-install and the file-install part changes; the transitive alias scanner survives as a doctor verifier; the component_manifest_resolver rewrite is obsolete.
open_questions:
- pubspec dep source (intl/flutter_localizations/expressions) not encoded in v2 meta.json.
- default preset id for `init --yes`.
- confirm retiring assets/locale/platform/deps vs no-op stubs.
- keep or drop the generated app_components.dart barrel.
- bundled vs remote manifest default.

## 9. Orchestrator decisions (2026-10-09, binding for all CLI batches)
1. Pub dependencies: every manifest unit gets optional `packages: [{name, sdk?: bool, constraint?: string}]`, DERIVED by
   the kit generator from the unit's `package:` imports (excluding `package:flutter/*` and the kit itself;
   `flutter_localizations` → `{name: flutter_localizations, sdk: true}`), constraints from the kit pubspec. `add` adds the
   missing ones to the app pubspec (`--dry-run` prints them) and runs `flutter pub get`. Schema updated accordingly.
2. `init --yes` default preset: `vercel` (neutral black/white, closest to shadcn's default).
3. Retire the old assets/locale/platform/deps/shared-group machinery entirely (clean break, no stubs).
4. Drop the generated `app_components.dart` barrel — users import each component file.
5. Registry source: remote by default (GitHub raw at the ref/tag matching the CLI version), `--registry <path|url>`
   override, local cache for offline re-installs; bundled-in-package copy not needed.
6. B2 (kit manifest generator) is folded into the kit cutover (P4-Z step 4). Fix every meta.json `import` string
   (missing `components/`) as part of the cutover.
