# Brief P6-D9b — spacing / padding / density compliance audit for every component (report + tests only)

User requirement (2026-10-10): every component's paddings, margins and gaps must be THEME-DEPENDENT (spacing + density
tokens), and every component must render exactly right — never stretched, never compacted. Example: a Chip has the exact
shadcn padding; a leading/trailing icon keeps the correct gap from the label AND from the chip edge (never touching the
edge); same for table cells, menu rows, inputs, buttons, badges, tabs, cards, dialogs, toasts — everything.
Another agent is editing docs pages; another is auditing rendering (P6-D9a). Write ONLY the outputs below.

## 1. Static scan (all 118 components + primitives)
Using package:analyzer (kit dev-dep), list every hard-coded spatial literal in `$APP/lib/registry/**`: `EdgeInsets.*`,
`SizedBox(width/height:)`, `Gap(n)`, `Padding`, `SizedBox.square`, `BoxConstraints(min/max…)`, `spacing:` args, magic
numbers in layout math — and whether it is derived from the theme (density / spacing scale / tokens via `ShadcnTheme`,
`resolveEdgeInsets`, `EdgeInsetsDensity`, component theme defaults) or a raw literal. Raw literals that should scale with
density are findings (file:line, current value, the token/expression it should use). Allowed raw values: hairline
borders (1px), icon glyph sizes defined by the component theme, and values documented as fixed by shadcn — justify each.

## 2. Measurement tests (keep them — they become the regression suite)
Write `$APP/test/registry/layout_audit/*_test.dart`: for every LISTED user-facing component (use the classification from
`rearch/reports/p6_component_audit.json` if it exists yet, else all components with a visual), render its default and
key variants under density compact / default / comfortable and assert with `tester.getSize/getRect`:
- padding inside the component equals the shadcn value × density (cite the shadcn class, e.g. chip/badge `px-2 py-0.5`,
  button `px-4`, table cell `p-2`, menu item `px-2 py-1.5`, input `px-3`);
- leading/trailing icon: gap to label = the component's gap token (e.g. `gap-1.5`/`gap-2`), gap to the outer edge = the
  horizontal padding — icon never touches the edge, label never overlaps the icon;
- no stretch: placed in a `Row`/`Column` with loose constraints and in a wide parent, the component keeps its intrinsic
  size unless it is documented as full-width (input, table, card…); no compact: long labels don't clip the padding;
- density scaling is monotonic (compact < default < comfortable) and proportional where the theme says so;
- RTL mirrors leading/trailing gaps.
Mark failing assertions with `skip:` + a reason ONLY in this audit batch so the suite is committable; the fix batches
remove the skips.

## Outputs (only these)
`$APP/test/registry/layout_audit/**`, `$KIT/rearch/reports/P6_SPACING_AUDIT.md` (per component: compliant? findings with
file:line → fix), `$KIT/rearch/reports/p6_spacing_audit.json` (id, findings[{file,line,value,should_be}], failing_tests[]).
Gates: `cd $APP && flutter analyze && flutter test test/registry/layout_audit`. `## RESULT` block.
