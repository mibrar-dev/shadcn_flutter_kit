# Brief P4-PRIM-1+PRIM-2+PRIM-3+PRIM-4 — Phase 4 migration batch

## What to build
Migrate the components listed in "Batch data" from the old tree `$REG/components/**` into
`$APP/lib/registry_next/components/<name>/`. Batch data comes from `$KIT/rearch/reports/P4_PLAN.md` /
`p4_batches.json` (read your batch section there too).

## The pattern (copy it exactly)
The accepted pilot is the reference — read before writing anything:
`registry_next/components/button/` (variants as enum + exhaustive table, theme merge), `dialog/` (overlay route,
live theme via InheritedTheme.capture), `input/` (state wiring on top of primitives), `toggle/` (form value),
`rearch/reports/P3_PILOT_DESIGN.md` §0, and the QA_LOG entries P3-B/P3-C/P3-D (what QA rejects).

## Rules (binding; QA rejects any violation)
- Folder holds at most: `<name>.dart`, `<name>_style.dart`, `<name>_theme.dart` (user-owned, const values only),
  `preview.dart`, `meta.json`, `README.md`. Every Dart file ≤ ~400 lines. If a component cannot fit, move REUSABLE
  machinery down into a primitive (only if listed in your batch data or clearly shared — say so in the report);
  never add extra files to the component folder.
- Imports downward only: foundation → theme → primitives → components. A component may import another component
  ONLY if it is listed in its batch-data `component_deps`, and must declare it in `meta.json` `deps.components`.
  `meta.json` `deps` must match the imports exactly (checker enforces it). No top-level `dependencies` block.
- No Material/Cupertino, no `part`, no `// ignore`, no `_impl/`, no global mutable state, no dead code, no aliases.
- Theme: `<Name>Theme extends ComponentThemeData` resolved with `resolveComponentStyle`; per-field merge, receiver
  wins (widget arg > nearest ComponentTheme > app ComponentThemes > defaults). Colours via `ThemedColor.ref(...)`;
  alpha MULTIPLIES (never replaces); no transparent/fallback colours standing in for tokens; disabled = Opacity 0.5
  of the rest style unless shadcn says otherwise. Overlays capture themes (InheritedTheme.capture) so they stay live.
- Strings come from `primitives/localizations` (add keys with real translations copied from Flutter's
  `flutter_localizations` ARB files when an equivalent exists; otherwise English fallback — never invent).
- FIX old bugs listed in batch data (and any you find — list them); never port them "faithfully".
- New public names follow shadcn naming; old named constructors/aliases are dropped (clean break).

## Tests
`$APP/test/registry_next/components/<name>_test.dart` per component: renders with tokens (light + dark), each
variant/size, interaction states (hover/press/focus/disabled), keyboard behaviour, controlled + uncontrolled value
flow where applicable, theme precedence (all 4 legs), and a regression test for every old bug you fixed.

## Outputs (only these)
`$APP/lib/registry_next/components/<name>/**` for your batch's components, any primitive files named in your batch
data, their tests, and `$KIT/rearch/reports/P4-PRIM-1+PRIM-2+PRIM-3+PRIM-4.md` (per component: old → new file mapping, LOC before/after,
bugs fixed, deviations, open questions). Write large files in ~150-line appended chunks; verify with `tail -5`.

## Gates (run, paste output in the report)
```
cd $KIT && rearch/qa_gate.sh lib/registry_next
```
Everything must be clean: format 0 changed, analyze 0 issues, all tests pass, layers 0 errors (no NEW
file-too-long from your files), owner 0 duplicates, theme 0 findings, banned empty.
Other agents may be writing other batches in parallel: never edit their folders; if their in-flight files break a
directory-wide gate, report it and show your own folders are clean (`dart analyze <your folders>`).

## Batch data
```json
[
  {
    "files": [
      "primitives/scroll_metrics.dart"
    ],
    "id": "P4-PRIM-1",
    "needed_by": [
      "scrollbar",
      "scrollview",
      "scrollable",
      "scrollable_client",
      "table",
      "carousel"
    ],
    "notes": "Scroll metrics + overscroll-glow helpers shared by scroll components. Must NOT re-declare ScrollableClient* (owned by scrollable_client, B05). Build BEFORE wave A."
  },
  {
    "files": [
      "primitives/date_math.dart"
    ],
    "id": "P4-PRIM-2",
    "needed_by": [
      "calendar",
      "date_picker",
      "time_picker",
      "object_input"
    ],
    "notes": "Calendar math only: month grids, leap years, value ranges (the computeValueRange/getter logic P2E2 dropped as 0-reader code, re-added here scoped to real callers). DatePart/TimePart/DurationPart stay in localizations/locale_parts.dart. Build BEFORE B07."
  },
  {
    "files": [
      "primitives/color_math.dart"
    ],
    "id": "P4-PRIM-3",
    "needed_by": [
      "color",
      "color_field",
      "color_picker",
      "hsl",
      "hsv",
      "eye_dropper",
      "color_input"
    ],
    "notes": "Color-space conversion (RGB/HSL/HSV), contrast pick for destructiveForeground derivation. ColorPickerMode stays in color_picker component (B24). Build BEFORE B04."
  },
  {
    "files": [
      "primitives/menu_nav.dart"
    ],
    "id": "P4-PRIM-4",
    "needed_by": [
      "menu",
      "menubar",
      "select",
      "command",
      "dropdown_menu",
      "context_menu"
    ],
    "notes": "Menu item keyboard traversal (roving focus) + typeahead helpers. SubFocus stays separate. MenuPopup/MenuGroupData stay in menu component (B13). Build BEFORE B10 (command) / B13 (menu)."
  }
]
```
