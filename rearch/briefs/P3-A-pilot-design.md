# Brief P3-A — Phase 3 pilot design (read-only, design doc only)

## Goal
Design (do NOT implement) the pilot components in the new architecture so builders can implement them mechanically:
1. `button` (absorbs toggle + button_group per OWNERSHIP.md merges, or keeps them as separate installable
   components if the audit says so — decide and justify),
2. `input` (merged with `text_field`; all features in ≤ 3 Dart files; `autocomplete` stays a separate component),
3. `dialog`.

## Read first
PLAN (`$KIT/REARCHITECTURE_PLAN.md`) §3–§6; `$KIT/rearch/reports/THEME_DESIGN.md` (esp. §3 component theme
contract, §5 user-owned theme files); `OWNERSHIP.md` + `ownership.json` (merges for these families);
`$APP/lib/registry_next/theme/README.md`, `$APP/lib/registry_next/foundation/README.md`; the old sources under
`$REG/components/**/button*`, `toggle`, `button_group`, `input*`, `text_field*`, `dialog*` (incl. `_impl/`).
Primitives are being built right now in `$APP/lib/registry_next/primitives/` (clickable, focus, hover, overlay,
popover, animation, form_core, text, localizations). They may be incomplete — reference the PLANNED file names
from `$KIT/rearch/briefs/P2-E1-primitives-interaction.md` / `P2-E2-primitives-form-text-l10n.md`, and mark any
API you assume as `ASSUMED`.

## For each pilot component, specify
- Final folder `components/<name>/` with exact files: `<name>.dart`, `<name>_style.dart`, `<name>_theme.dart`
  (user-owned, const values only), `preview.dart`, `meta.json`, `README.md`. Estimated LOC per file (≤ ~400).
- Public API: constructor signatures (named params, types, defaults), variant/size enums
  (e.g. `Button(variant: .ghost, size: .sm)`), and the exhaustive variant → style table (which tokens per state:
  idle/hover/pressed/focused/disabled). Use real token names from `registry_next/theme`.
- Theme class: fields, `merge` semantics (per-field, widget arg > nearest ComponentTheme > app ComponentThemes >
  token defaults), how `_theme.dart` const values plug in.
- Primitives/foundation it imports (layers downward only). Nothing shared between components except via primitives.
- Old → new mapping: every old file/class → where it goes or why it is deleted. Old bugs found (fix, don't port).
- `meta.json` contents (deps on primitives/foundation/theme, no undeclared deps).
- Test list (widget tests per behaviour: variants render tokens, states, keyboard activation, focus ring,
  input controller/validation/form integration, dialog open/close/barrier/escape/focus trap).

## Outputs (only this file)
`$KIT/rearch/reports/P3_PILOT_DESIGN.md` — under ~600 lines, concrete, no prose padding. End with a list of
decisions that need the user's approval.
