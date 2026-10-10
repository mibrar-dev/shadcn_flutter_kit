# Brief P7-Q0 — sidebar shows only app-usable widgets + parity check vs main

KIT=/Users/ibrar/Desktop/infinora.noworkspace/shadcn_copy_paste/shadcn_flutter_kit, APP=$KIT/flutter_shadcn_kit.
Do NOT open PNGs yourself.

1. User: only widgets a developer would drop into a normal app screen belong in the docs sidebar/index/⌘K. Widgets that
   exist mainly to build other widgets (e.g. `color_input`, `color_field`, `eye_dropper`, history/hsv/hsl-like parts,
   `drawer_container`, `stage_container`, `outlined_container`, `scrollable`, `scrollview`, `selectable`, `swiper`,
   `switcher`, `triple_dots`, `spell_check_suggestions_toolbar`, `text_animate`?, `window`?, …) should be hidden
   (`"listed": false`, still installable). Review ALL 118 components with this rule, using: which other components
   import it (registry.json deps), whether shadcn/ui has it as a top-level component, and whether a typical app would use
   it directly. Produce a decision table with a one-line reason each; apply `listed` edits in meta.json EXCEPT for
   components currently being edited by other agents (menu, menubar, dropdown_menu, context_menu, navigation_menu, popup,
   select, multi_select, command, autocomplete, popover, hover_card, tooltip, radio_group, checkbox, switch, toggle,
   calendar, date_picker, time_picker, dialog, slider, input, text_area, form) — list those as recommendations only.
   Regenerate manifest + docs data/mirror.
2. Parity vs `origin/main` (old registry, `git show origin/main:flutter_shadcn_kit/lib/registry/available_components.txt`
   and the old tree): for every old component/feature, state where it lives now (component, primitive, merged into X
   per `rearch/reports/P4_PLAN.md` / `p4_batches.json`) or that it is MISSING. Old names to resolve include basic,
   circular_progress_indicator, linear_progress_indicator, control, debug, file_input, flex, form_field,
   repeated_animation_builder, shadcn_localizations*, tab_list, tab_pane, text_field, validated, wrapper. Anything
   genuinely missing that an app would use → list with a recommendation (don't implement).
Report `$KIT/rearch/reports/P7-Q0.md` (both tables), `## RESULT`. Gates: manifest --check, docs codegen --check,
sync --check, docs analyze/test. No git ops.
