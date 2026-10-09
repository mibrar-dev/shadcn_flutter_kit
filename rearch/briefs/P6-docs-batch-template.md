# Brief {ID} — docs website rebuild batch

## Context
Rebuild of the Flutter docs website `DOCS = $KIT/docs/` per the accepted plan `$KIT/rearch/reports/P6_DOCS_BUILD_PLAN.md`
(read it fully — your batch is in §6) and the accepted Open Design mockups `$KIT/rearch/design/docs/*.html` +
`screens/*.png` + `$KIT/rearch/reports/P6_DOCS_DESIGN.md` (motion spec). The registry cutover is DONE: components live in
`$APP/lib/registry/` with the generated manifest `$APP/lib/registry/manifests/registry.json`.

Component source for the docs app: `DOCS/lib/ui/shadcn/{foundation,theme,primitives,components/<name>}` — the exact
layout the new CLI installs. Until the new CLI exists, it is a MIRROR of `$APP/lib/registry/` (excluding `manifests/`
and `themes/`, excluding every `preview.dart` except where the plan says previews are loaded) produced by
`DOCS/tool/sync_registry.sh` (D1 writes it; rsync-based, deterministic). Never edit files inside `DOCS/lib/ui/shadcn/`
by hand — fix the registry instead and report it.

## Your batch
{BATCH}

## Rules
- Only touch your batch's outputs; other docs batches may run in parallel.
- No Material/Cupertino imports anywhere in the docs app; registry components first, docs-only widgets only where the
  plan says so. No hand-typed component facts (API, theme fields, deps, counts) — they come from the D2 codegen.
- `dart format`, `flutter analyze` 0 issues (no `// ignore`), files ≤ ~400 lines, widget tests for your pages/widgets.
- Respect the motion spec and reduced motion (`MediaQuery.disableAnimations`).
- No git state changes. Write large files in ~150-line chunks and verify with `tail -5`.

## Gates (paste output in the report)
```
cd $KIT/docs
dart format --output=none --set-exit-if-changed lib test tool
flutter analyze            # 0 issues
flutter test               # all green
grep -rnE "package:flutter/(material|cupertino).dart" lib   # must be empty
flutter build web --release   # D1, D4, D5 and D6 only
```

## Outputs
Your batch's files + `$KIT/rearch/reports/{ID}.md` (files, decisions, gate output, screenshots if any, open questions).
Finish with the `## RESULT` block.
