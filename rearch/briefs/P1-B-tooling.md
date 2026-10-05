# Brief P1-B — Guardrail tooling (builder)

## Goal
Write three pure-Dart CLI scripts that will gate every later change, plus tests, and produce today's baseline.

## Outputs (only these)
- $APP/tool/rearch/check_single_owner.dart
- $APP/tool/rearch/check_layers.dart
- $APP/tool/rearch/api_snapshot.dart
- $APP/tool/rearch/src/*.dart   (shared helpers: file walking, owner-unit detection, AST parsing)
- $APP/test/rearch/*_test.dart  (fixture-based tests; fixtures under $APP/test/rearch/fixtures/)
- $KIT/rearch/reports/BASELINE_GUARDRAILS.md and $KIT/rearch/reports/baseline/*.json (script outputs)

## Shared definitions
- Scan root default: $REG (flag `--root <dir>`). Skip `shared/theme/generated/**` only with `--skip-generated` (default on).
- Owner unit of a Dart file = nearest ancestor directory containing `meta.json` (a component), else for files under
  `shared/` the path `shared/<group>/<file-stem>` with `_impl/**` files attributed to the shared group's owning entry
  file when determinable (document the heuristic), else `UNKNOWN`.
- Parse with `package:analyzer` `parseString` (unresolved). Never regex Dart source.

## Script 1: check_single_owner.dart
- Collect top-level declarations: class, mixin, enum, extension (named), extension type, typedef, top-level
  function, top-level variable. Record name, kind, file, line, owner unit, public/private.
- A name declared in more than one owner unit = duplicate. Public duplicates = ERROR, private = WARNING.
- For each duplicate, compute whether the declarations are textually identical after whitespace/comment
  normalization (`identical: true/false`) — this tells us copy-paste vs diverged forks.
- Flags: `--json <path>`, `--strict` (exit 1 on any ERROR). Human output: summary counts + grouped list.

## Script 2: check_layers.dart
Rules, each with its own id and count:
- `no-material`: import/export of package:flutter/material.dart, package:flutter/cupertino.dart,
  package:material_ui, package:cupertino_ui.
- `no-part`: any `part` or `part of` directive.
- `no-ignore-for-file`: any `// ignore_for_file:` comment.
- `layer-direction`: layer by path segment: `foundation`=0, `theme`=1, `primitives`=2, `components`=3. Legacy
  `shared/**` = layer "shared" (allowed to import shared; importing components is a violation). A file may only
  import same-or-lower layers.
- `undeclared-dependency`: a component importing another component's files must list it in its meta.json
  `dependencies.components`; importing shared files must be covered by `dependencies.shared` ids
  (map ids → files via $REG/shared/shared_manifest.json and $REG/manifests/components.json; read both to learn the
  shape, document it).
- `file-too-long` (warning): > 400 lines.
- Flags: `--json <path>`, `--strict`, `--rule <id>` (repeatable) to run a subset.

## Script 3: api_snapshot.dart
- For a component dir (or `--all`), list the public API reachable from its entry file `<name>.dart` following
  `export` directives: top-level public names, and for classes their public constructors (with named/positional
  parameter names + types as written), public fields, methods, getters, static members.
- Output stable sorted JSON (`--out <path>`). `--diff <old.json> <new.json>` prints added/removed/changed members.

## Tests
- Small fixture registries under test/rearch/fixtures exercising each rule and the duplicate detection
  (identical vs diverged). Run with `cd $APP && flutter test test/rearch`.

## Baseline run (must do)
- `dart run tool/rearch/check_single_owner.dart --json $KIT/rearch/reports/baseline/single_owner.json`
- `dart run tool/rearch/check_layers.dart --json $KIT/rearch/reports/baseline/layers.json`
- `dart run tool/rearch/api_snapshot.dart --all --out $KIT/rearch/reports/baseline/api.json`
- Write BASELINE_GUARDRAILS.md: counts per rule, top 20 offending components, duplicates (public/private,
  identical/diverged). Sanity check: the orchestrator measured ~148 duplicated names, ~1,123 files with `part of`,
  ~20 component files importing material.dart. Explain any large difference.

## Acceptance
- `dart format --set-exit-if-changed tool/rearch test/rearch` clean; `flutter analyze tool/rearch test/rearch` 0 issues;
  `flutter test test/rearch` all green. Scripts finish on the full registry in < 60s.
