# Brief P2-E2 — `primitives/` (layer 2): form_core, text, localizations

## Context
New architecture tree `NEXT = $APP/lib/registry_next/`. DONE and accepted — read first, use their real APIs:
`NEXT/foundation/` (README.md) and `NEXT/theme/` (README.md). Read PLAN §3–§6, `$KIT/rearch/reports/OWNERSHIP.md`
(merge decisions for form + form_field + shared form state, text, localizations) and `ownership.json`, and
`$KIT/rearch/reports/QA_LOG.md`. Clean break: no aliases/shims; old `$REG` untouched. Another agent builds the
rest of `primitives/` in parallel — only write inside the three folders below. These three groups import only
each other and theme today (verified by the orchestrator), so you should not need the other primitives; if you do,
stop and report it instead of copying code.

## Scope
1. `NEXT/primitives/form_core/` ← 10 files: form_key, validation_result, replace_result, form_control,
   form_value_supplier, controlled_component_adapter(+state), controlled_component_data, component_value_controller,
   form entry cached value. ALSO the duplicates the audit assigns here from `$REG/components/form/form/**`
   (FormKey, ValidationResult, FormValueSupplier, FormFieldHandle, FormValidationMode, ReplaceResult,
   FormPendingBuilder/WidgetBuilder …): compare both copies, keep ONE (the newer/behaviour-complete one — the
   audit marks identical vs diverged), and list what the `form` component must import later.
   Target ≤ 3–4 files, e.g. `form_core.dart` (keys, results, modes), `form_control.dart` (controlled component
   adapter/data/controller), `form_value.dart` (value supplier, cached value, pending builder).
2. `NEXT/primitives/text/` ← shared/primitives/text.dart + text_modifier, wrapped_text, unordered_list_data,
   bullet painter, text/rich_text/selectable_text "then" widgets — and the audit's decision that the
   `display/text` component dissolves into this primitive (absorb what it uniquely has). Target 2 files:
   `text.dart` (modifiers, wrapped text, then-widgets), `list.dart` (unordered list data + bullet painter).
3. `NEXT/primitives/localizations/` ← shared/localizations (delegate, ShadcnLocalizations, extensions) — the
   `components/utility/shadcn_localizations` component copy is deleted per the audit (keep one). Keep generated
   locale data as data; target `localizations.dart` + `localizations_extensions.dart` (+ data files if the
   locale tables are large — exempt from the 400-line rule). Uses `intl` (allowed: core dependency).

Rules: import only `../../foundation/*`, `../../theme/*`, files inside these three folders, `package:intl`,
`package:flutter_localizations` (localizations only) and Flutter non-Material libraries. Replace data_widget/gap with
foundation. New theme API names (`ShadcnTheme.of`, `ShadcnColors`…). No Material/Cupertino, `part`, `// ignore`,
dead code. Behaviour must not change.

## Tests (`$APP/test/registry_next/primitives/{form_core,text,localizations}_test.dart`)
Form key/value supplier registration + validation modes + pending builder; controlled component adapter
(controlled vs uncontrolled value flow); text modifiers produce the same TextStyles as the old code for a sample
theme; unordered list bullets render; localizations delegate loads `en` + one other locale and the extensions
format a sample number/date. Port behaviour from `$APP/test/shadcn_app_localizations_test.dart` where relevant.

## Outputs (only these)
`$APP/lib/registry_next/primitives/{form_core,text,localizations}/**`,
`$APP/test/registry_next/primitives/{form_core,text,localizations}_test.dart`,
`$KIT/rearch/reports/P2E2_PRIMITIVES.md` (old → new for every source file and every absorbed duplicate, which copy
won and why, LOC, open questions).

## Gates (paste results in the report)
```
cd $APP
dart format --set-exit-if-changed lib/registry_next/primitives test/registry_next/primitives
dart analyze lib/registry_next/primitives test/registry_next/primitives   # 0 issues
flutter test test/registry_next/primitives                                # all green
dart run tool/rearch/check_layers.dart --root lib/registry_next           # 0 errors
dart run tool/rearch/check_single_owner.dart --root lib/registry_next     # 0 duplicates
```
