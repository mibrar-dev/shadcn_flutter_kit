# Brief P6-D9c — theme-dependence audit for every component (report + tests only)

User report (2026-10-10): many components do NOT follow the selected theme. Example: with the `claude` preset selected on
the docs site, the Calendar's selected day renders BLACK instead of the theme's `primary`. Also: code blocks (incl. the
expanded "View Code" pane) are not selectable. Other agents are editing docs pages and auditing rendering/spacing —
write ONLY the outputs below.

## 1. Static scan
Using package:analyzer, list every colour in `$APP/lib/registry/**` that does not come from the theme: `Color(0x…)`,
`Color.fromARGB/RGBO`, `Colors.*`-like constants, `const Color` defaults in component themes/styles that should be
`ThemedColor.ref(...)`, colours captured once (e.g. resolved in initState / stored in a field / const default) instead of
resolved in `build` from `ShadcnTheme.of(context)`, and alpha handling that REPLACES instead of multiplies. Allowed:
transparent where the design says so, black/white overlays the spec defines (e.g. dialog barrier) — justify each.

## 2. Live theme tests (keep — regression suite)
`$APP/test/registry/theme_audit/*_test.dart`: for every user-facing component (use `rearch/reports/p6_component_audit.json`
listed ids if present, else every component with a visual), render the default + selected/active/hover/focus states under
three contrasting presets (`neutral`, `claude`, and one saturated preset e.g. `tangerine` or `cyberpunk`) in light and dark,
and assert the key colours equal the theme tokens (selected/active → primary + primaryForeground, borders → border,
focus ring → ring, muted text → mutedForeground, surfaces → card/popover/background). Also assert a theme CHANGE at runtime
(swap ShadcnTheme data, pump) updates the colours (no stale captures). Calendar selected day is a required case.
Failing assertions → `skip:` with reason in this audit batch only (the fix batch removes the skips).

## 3. Selectability
List every code-showing surface (registry `code_snippet`, `markdown` fenced code, docs code block / code teaser / Get Code
dialog / install block) and whether text is selectable + copyable; propose the fix (SelectableRegion / SelectionArea
compatible widgets-only, keeping syntax colours).

## Outputs (only these)
`$APP/test/registry/theme_audit/**`, `$KIT/rearch/reports/P6_THEME_AUDIT.md`, `$KIT/rearch/reports/p6_theme_audit.json`
(id, hardcoded[{file,line,value,should_be}], failing_tests[], stale_capture[], selectable). Gates:
`cd $APP && flutter analyze && flutter test test/registry/theme_audit`. `## RESULT` block.
