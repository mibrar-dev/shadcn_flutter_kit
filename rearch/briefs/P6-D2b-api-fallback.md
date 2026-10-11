# Brief P6-D2b — docs codegen: API tables for static/factory-first components

`$KIT/docs/tool/gen_docs_data.dart` (+ `dart_scan.dart`) builds API tables only from a component's primary class
constructor (`meta.json` `api.classes`). `color` renders 0 rows (its only unnamed ctor is no-arg; the real API is 4 static
factories) and `formatter` surfaces `TimeFormatter.length` (real API: a factory set on a class with a private ctor).
`meta.json` now names the real entry points under `api.methods` / `api.functions` / `api.constants`.
Extend the codegen: when the primary constructor has no params (or is private), emit the declared static methods /
factories / top-level functions from `meta.json api` as API rows (name, params with types/defaults, doc first line).
Regenerate; update the golden test (add color + formatter cases); `--check` must pass. Outputs: docs/tool/**,
docs/lib/generated/**, docs/tool tests, `$KIT/rearch/reports/P6-D2b.md`. Do not touch docs pages/widgets (D6 is editing them).
Gates: `cd $KIT/docs && flutter analyze && flutter test && dart run tool/gen_docs_data.dart --check`. `## RESULT` block.
