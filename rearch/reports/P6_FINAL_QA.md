# P6_FINAL_QA — CLI reinstall + final full QA

Unit: **P6-Z2** · Date: 2026-10-10 · Scope: CLI reinstall acceptance into a
temp docs copy, full gate matrix (kit/docs/CLI), flaky markdown hermetic fix.
No PNG opened (brief rule). No git ops (orchestrator commits).

## 1. CLI reinstall acceptance — PASS

Temp copy: `cp -R $DOCS /tmp/docs_cli_check`, `rm -rf lib/ui/shadcn`, then:

```
dart run $CLI/bin/shadcn.dart --registry $APP/lib/registry init --yes --dir lib/ui/shadcn
dart run $CLI/bin/shadcn.dart --registry $APP/lib/registry add --all --blocks --include-preview
```

Result: `Installed 118 component(s) + 16 block(s)`, 681 Dart files
(mirror 680 + `theme/app_theme.dart`).

`diff -r $DOCS/lib/ui/shadcn /tmp/docs_cli_check/lib/ui/shadcn`:

- PASS: identical except one expected file:
  - `theme/app_theme.dart` — only in CLI output (expected: CLI generates it
    per project from the chosen preset; `sync_registry.sh` explicitly excludes
    it from deletion and the mirror never contains it).
- No content differences in the other 680 files (`--exclude=app_theme.dart`
  diff is empty).
- Expected side files outside the diff root (not bugs): `shadcn.lock`,
  `.shadcn/config.json` (CLI install record).

Temp copy gates:

- `flutter analyze`: 3 issues, all expected `/tmp` artefacts —
  `tool/gen_docs_data_test.dart` + `tool/src/render_*.dart` reference
  `../../../flutter_shadcn_kit/...` which does not exist under `/tmp`.
  Zero errors in `lib/` (docs widgets using `masonry_layout` /
  `subfocus_list_item` now resolve).
- `flutter test test/`: `+206 ~1: All tests passed!` (same as docs).

### Bugs found and fixed (minimal, CLI-only)

1. **Preflight treated map keys as symbols.** `lockApiFor` /
   `LockComponentApi.fromJson` flattened `providedByPrimitives` /
   `reExportedFromComponents` map keys (`file_value`, `text_editing`, `menu`)
   as owned symbols, so `add --all` failed with
   `file_value (dropzone, file_picker); text_editing (...); menu (...)`.
   Fix: ignore map groups; `symbols` excludes non-owned kinds (backward
   compatible with old locks). Files:
   `cli/lib/src/application/services/installer/installer_lock_part.dart`,
   `cli/lib/src/application/services/lockfile/shadcn_lock_component.dart`,
   `cli/test/shadcn_lock_v2_test.dart` (updated expectation).
2. **Re-export counted as duplicate.** `drawer` and `drawer_container` both
   list `OverlayPosition` in `enums`, but `drawer_container` re-exports it
   (`export '../drawer/drawer.dart' show OverlayPosition`) and depends on
   `drawer`. Fix: preflight exempts a symbol when claimants share a
   component-dependency edge (re-export, not second definition). File:
   `cli/lib/src/application/services/installer/installer.dart`.
3. **`add --all` missed unused primitives.** Closure omitted the 5 primitives
   no component declares (`extensions`, `label`, `masonry_layout`,
   `subfocus_item`, `subfocus_list_item`), so the CLI tree had 675 files vs
   mirror 680 and docs widgets (`collage`, `studio_canvas`) plus the `command`
   preview broke. Fix: `add --all` / `dry-run --all` / `installAll` set
   `includeAllPrimitives` so `--all` ships every primitive (selective adds
   unchanged). Files: `cli/lib/src/application/services/manifest_closure.dart`,
   `installer.dart`, `commands/add_command.dart`, `commands/dry_run_command.dart`.
   Re-ran: 5 files written, diff now identical (modulo `app_theme.dart`).

Registry follow-up (NOT fixed here, documented): `drawer_container/meta.json`
lists re-exported `AxisSize*` as `classes` and `OverlayPosition` as `enums`
(it `export`s both); `drawer/meta.json` lists primitive-owned
`OverlayPosition` / `DrawerOverlayCompleter` as owned. Correct shape is
`providedByPrimitives` / `reExportedFromComponents` (cf. `calendar`,
`menubar`, `popup`). `extensions` / `label` have zero non-test importers.

## 2. Final full QA — per gate

### Kit (`flutter_shadcn_kit`)

- format: PASS — `Formatted 899 files (0 changed)`.
- analyze lib/test: PASS — `No issues found!` / `No issues found!`.
- test registry: PASS — `+4005: All tests passed!`
  (markdown 31 incl. 2 hermetic network tests, see §4).
- test rearch: PASS — `+42: All tests passed!`.
- manifest/previews/blocks `--check`: PASS — `registry.json is up to date.`,
  `blocks tests are up to date (16 blocks).`,
  `previews_test.dart is up to date (97 components).`
- check_layers: PASS — `680 files, 0 errors`; 27 `file-too-long` warnings
  (pre-existing, accepted).
- check_single_owner: PASS — 0 public duplicates; 17 private preview-only
  warnings (pre-existing, e.g. `_vertical`, `_default`).
- check_user_theme `--strict`: PASS — `0 finding(s)`.
- banned (`^import package:flutter/(material|cupertino)`, `^part `,
  `^import package:(data_widget|gap)/`, `// ignore`): PASS — empty.
  Raw `grep package:flutter/(material|cupertino)` hits are only doc comments
  (`REMOVED ... material.dart ... is gone`), no imports.
- Whole-project `flutter analyze`: 3 pre-existing issues in `lib/main.dart`
  (stale gallery app, untouched since cutover; not a registry gate).
- `rearch/qa_gate.sh`: legs run individually (single run exceeds tool
  timeout, as in P6-Z1); stray: empty (no files outside
  `lib/registry|test/registry|rearch/`).

### Docs (`docs/`)

- format: PASS — `Formatted 841 files (0 changed)`.
- analyze: PASS — `No issues found!`.
- test: PASS — `+206 ~1: All tests passed!` (~1 pre-existing skip).
- codegen `--check`: PASS — `generated data is up to date (12 files checked).`
- sync `--check`: PASS — `mirror is up to date.`
- build web release: PASS — `✓ Built build/web` (only warning: framework
  font notice for Cupertino/MaterialIcons families, pre-existing).

### CLI (`shadcn_flutter_cli`, branch `refactor/rearchitecture`)

- format: PASS — `Formatted 291 files (0 changed)`.
- analyze: PASS — `No issues found!`.
- test: PASS — `+522 ~1: All tests passed!` (~1 pre-existing skip).
- e2e acceptance: PASS —
  `dart test -t e2e --run-skipped test/e2e/acceptance_test.dart`
  `+1: All tests passed!` (init/add/analyze/remove/update/doctor/theme).

## 3. Flaky markdown network-image tests — FIXED (hermetic)

Report (P6-Z1): full-suite runs intermittently failed 2 tests in
`markdown_test.dart` (network-image fallback); they pass in isolation.
Root cause: `Image.network("https://example.com/x.png")` hits the sandbox
network; `pumpAndSettle` hangs/flakes on DNS/timeout.

Fix (`flutter_shadcn_kit/test/registry/components/markdown_test.dart`):
`_FailingHttpClient extends Fake implements HttpClient` whose `getUrl`
returns an immediate `SocketException`; both network tests run inside
`HttpOverrides.runZoned(..., createHttpClient: (_) => _FailingHttpClient())`.
The `Image.network` loading/errorBuilder path still executes, but no packet
leaves the test. Gates: analyze 0, `markdown_test.dart` 31/31, full
`test/registry` 4005/4005.

## 4. Known follow-ups (from `rearch/reports/QA_LOG.md` + this run)

- `calendar/preview.dart` `<`/`>` demo steppers (would add a `button` dep;
  component-owner follow-up).
- Terms inline link buttons ride 36px `Button` minima (text-height link
  primitive idea, kept `Button` for single-owner simplicity).
- `rearch/screenshots/pilot/*.png` binary diffs pre-date P6-P2/P6-P3/P6-Z1;
  orchestrator to verify before committing.
- 9 files over ~400 lines (chat×2, error_system, input_otp, object_input,
  refresh_trigger, time_picker, tree, window); `menu.dart` 431; `theme.dart`
  ~470; `dart_scan.dart` 562; `collage_cards.dart` was split in P6-P1.
- Registry meta corrections owed: `drawer_container` (`AxisSize*`,
  `OverlayPosition`) and `drawer` (`OverlayPosition`,
  `DrawerOverlayCompleter`) should use `providedByPrimitives` /
  `reExportedFromComponents`; `extensions` / `label` primitives have zero
  consumers (delete or attach); `masonry_layout` is docs-used but not
  component-reachable (fine now that `--all` ships every primitive).
- Docs: selection persistence in-memory only; canvas gap 24px vs ref 40px;
  P6-B1 ideas (Badge semantic variants, Input label slot, mobile blocks).

## 5. PR summary draft

**Kit (`flutter_shadcn_kit`, `refactor/rearchitecture`)**: re-architected
registry — 145 dirs / 1,800 files / ~200k LOC → 118 components + 16 blocks
(680 Dart files, flat `components/<id>/`, ≤3 files per component, no
`part`/`ignore_for_file`, widgets-only, variants-as-data, single-owner,
layered foundation→theme→primitives→components→blocks, per-component
Studio-editable themes, 42 JSON presets, generated `registry.json` +
`previews`/`blocks` tests, guardrails green (4005 + 42 tests).
Clean break, no aliases, no `migrate` (pre-marketing decision).

**CLI (`flutter_shadcn_cli`, `refactor/rearchitecture`)**: v2 manifest models
+ validator, cycle-tolerant closure, verbatim installer + single-owner
preflight + lock v2 + theme service (byte-identical `app_theme.dart`) +
commands (init/add/remove/update/list/search/info/doctor/theme/audit) +
blocks + categories + e2e acceptance (522 + 1 tests). P6-Z2 fixes: preflight
ignores non-owned api maps, re-export exemption via dependency edge,
`--all` ships every primitive.

**Docs (`docs/`)**: rebuilt Flutter web gallery to the shadcn site spec —
shell/home/palette/index, 118 component pages (one example + Select +
light/dark + selectable code), 16 blocks with framed viewport + Preview|Code,
themes studio + masonry canvas, generated catalog/API/search (12 files),
registry mirror in `lib/ui/shadcn` (680 files, `--check` clean), release
`build/web` green (206 tests).

Migration: clean break — delete old `lib/registry`, copy new tree; CLI
`init` + `add` reinstalls; user-owned `*_theme.dart` never overwritten;
no deprecated aliases.

## RESULT
```
status: done
files_written:
  /Users/ibrar/Desktop/infinora.noworkspace/shadcn_copy_paste/shadcn_flutter_kit/rearch/reports/P6_FINAL_QA.md
commands_run:
  kit format/analyze/test/rearch/layers/owner/user-theme/banned -> PASS (899/0, 4005, 42, 680/0/27w, 0 public, 0, empty)
  docs format/analyze/test/codegen/sync/build -> PASS (841/0, 0, 206, 12 up to date, mirror up to date, Built build/web)
  cli format/analyze/test/e2e -> PASS (291/0, 0, 522, e2e +1)
  cli reinstall (init + add --all --blocks --include-preview) -> 118+16, 681 files, diff identical except theme/app_theme.dart
  temp copy analyze/test -> 3 expected /tmp tool-path errors, test +206 pass
  grep material/cupertino imports -> empty (comments only)
  markdown hermetic fix -> 31/31, full 4005/4005
key_findings:
  * CLI preflight flattened providedBy/reExported map keys as owned symbols; ignoring maps fixes 3/4 --all violations.
  * drawer_container re-exports OverlayPosition from drawer (dependency edge); exempting dependency-linked duplicates fixes --all.
  * add --all omitted 5 unused primitives (extensions/label/masonry/subfocus_*); --all now ships every primitive and matches the mirror.
  * Markdown network flakes were real sandbox-network hangs; failing-HttpClient makes them hermetic with identical assertions.
open_questions:
  * drawer/drawer_container meta.json still list re-exports as owned (registry follow-up, CLI works around it).
  * extensions/label have zero consumers; masonry reachable only via --all/docs (registry follow-up).
  * pilot screenshots binary diffs + 9 over-length files remain accepted warnings.
```
