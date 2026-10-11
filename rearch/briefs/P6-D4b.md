# Brief P6-D4b — docs website rebuild batch

## Context
Rebuild of the Flutter docs website `DOCS = $KIT/docs/` per the plan `$KIT/rearch/reports/P6_DOCS_BUILD_PLAN.md` AS AMENDED BY `$KIT/rearch/reports/P6_SHADCN_SITE_SPEC.md` (the spec wins on any conflict; §7 = orchestrator decisions)
(read both fully) and the reference captures of ui.shadcn.com in `$KIT/rearch/design/shadcn-ref/screens/*.png`.
The Open Design mockups (`rearch/design/docs/`, `P6_DOCS_DESIGN.md`) were REJECTED by the user — do NOT use them. The registry cutover is DONE: components live in
`$APP/lib/registry/` with the generated manifest `$APP/lib/registry/manifests/registry.json`.

Component source for the docs app: `DOCS/lib/ui/shadcn/{foundation,theme,primitives,components/<name>}` — the exact
layout the new CLI installs. Until the new CLI exists, it is a MIRROR of `$APP/lib/registry/` (excluding `manifests/`
and `themes/`, excluding every `preview.dart` except where the plan says previews are loaded) produced by
`DOCS/tool/sync_registry.sh` (D1 writes it; rsync-based, deterministic). Never edit files inside `DOCS/lib/ui/shadcn/`
by hand — fix the registry instead and report it.

## Your batch
D4b — remaining docs content + shell polish:
1. Write real `/docs/theming` and `/docs/dark-mode` pages (currently placeholders), mirroring the structure of shadcn's
   /docs/theming and /docs/dark-mode (see rearch/design/shadcn-ref/screens/theming-*.png, dark-mode-*.png and the spec), with
   OUR facts: tokens = shadcn CSS variable names in camelCase, `ShadcnTheme`/`ShadcnThemeData`, per-component theme files
   (`<name>_theme.dart`, user-owned), precedence (widget arg > ComponentTheme > app ComponentThemes > tokens), 43 presets
   incl. `neutral` default, `flutter_shadcn theme apply`, `AnimatedShadcnTheme`, system/light/dark. Code samples must
   compile against the registry (add a test that analyzes each snippet or uses them in a widget test). Source the facts from
   `flutter_shadcn_kit/lib/registry/theme/README.md` and `rearch/reports/THEME_DESIGN.md`.
2. Shell Tab order: header first, then sidebar, content, TOC (restructure the shell's focus traversal order; test it).
3. Re-measure the web JS size (`flutter build web --release`, record main.dart.js size) and list the top contributors;
   use deferred loading if the generated data blew the budget in the plan (§1.8).
Do NOT touch lib/ui/shadcn (registry mirror) — another agent is fixing ShadcnApp shortcuts; after it lands the docs
workaround is removed by that agent.

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
Your batch's files + `$KIT/rearch/reports/P6-D4b.md` (files, decisions, gate output, screenshots if any, open questions).
Finish with the `## RESULT` block.
