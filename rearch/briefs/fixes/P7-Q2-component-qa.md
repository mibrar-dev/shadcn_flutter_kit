# Brief P7-Q2 — QA every component preview: behaviour, spacing, functionality → report → FIX

KIT=/Users/ibrar/Desktop/infinora.noworkspace/shadcn_copy_paste/shadcn_flutter_kit, APP=$KIT/flutter_shadcn_kit, DOCS=$KIT/docs.
Do NOT open/read PNG images yourself (the model crashes on images) — test with widget tests and agent-browser text/console.

User (2026-10-11): test each component's previews; every component must behave the way its shadcn/ui counterpart (or
its README) says; spacing must be correct; find errors/bugs, report them and FIX them.

## Your components (only these; other agents own menus/select/command/popover/tooltip/hover_card, radio/checkbox/
switch/toggle/calendar/date&time pickers/dialog/slider/input/text_area/form, and lib/registry/blocks/**)
keyboard_shortcut markdown navigation_bar number_ticker object_input outlined_container overflow_marquee pagination phone_input pinned_sheet progress refresh_trigger resizable scaffold scrollable scrollbar scrollview selectable skeleton sortable spell_check_suggestions_toolbar spinner stage_container star_rating stepper steps swiper switcher table tabs text_animate timeline toast tracker tree triple_dots window

## For each component, every `<camel>Previews` example
1. Behaviour: drive it in a widget test like a user — tap/click, hover, focus + keyboard (Tab, Enter, Space, arrows,
   Escape), typing, drag where relevant, disabled state; open/close overlays it owns; verify callbacks + visible state
   change; compare with the shadcn/ui docs page of the equivalent component (agent-browser, SHORT commands) and the
   component README/API — anything that does not work or differs = bug.
2. Spacing/size: measure paddings, gaps, heights against the shadcn values × density (compact/default/comfortable);
   nothing stretched or compacted; icons never touch edges; RTL mirrors.
3. Theme: light/dark × neutral/claude render correct token colours (no hard-coded colours, no invisible text).
4. Robustness: 375 / 768 / 1440 widths with no overflow, no exceptions, no unbounded-constraint errors; reduced motion.
5. Docs page: open `/#/docs/components/<id>` on a locally served release build of $DOCS and check the browser console
   for errors while switching every example (Select) and the light/dark toggle.
## Then
Write `$KIT/rearch/reports/P7-Q2.md` FIRST as a table (component → examples checked → bugs found with file:line +
root cause → fixed? → test added) and update it after every ~5 components. FIX every bug at the root in the component's
own files (keep public API additive; update README/meta api when needed) and add a regression test under
`$APP/test/registry/qa/<id>_qa_test.dart`. If a fix needs a primitive shared with another agent's components, keep it
minimal and list it.
Gates: `cd $KIT && rearch/qa_gate.sh`; manifest/previews generators --check (regenerate); docs sync (run) + --check,
docs analyze/test. `## RESULT` block. No git ops.
