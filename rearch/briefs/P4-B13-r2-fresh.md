# Brief P4-B13 round 2 (fresh session) — menu, hover_card, date_picker, time_picker

A previous agent session worked on this round and ran out of context mid-way. Its changes are on disk (uncommitted).
FIRST: inspect the current state (`git status --short`, `git diff --stat`, read rearch/reports/P4-B13.md and the
fix list below), then finish whatever is not done. Do not redo finished work. Delete any debug-only files the
previous session left (e.g. `test/registry_next/components/zz_debug_test.dart`, probe files) — they are not outputs.

## Fix list (QA round 2)
F1 Single owner: `MenuGroupData` stays in `primitives/menu_nav.dart`. Delete the 16-line zero-reader stub from
   `primitives/menu_group.dart` (delete the file if nothing else remains; update imports/README/tests).
F2 Popover crash (your minimal repro: two TimeFormatter Inputs in a popover + field tap → zombie OverlayEntry
   _TypeError): find and FIX the root cause in the owning primitive (primitives/popover*.dart / overlay*.dart /
   text_editing / input_features — you may edit them for this). Add the repro as a regression test.
F3 `formatTimeOfDay` 12h prints a zero-padded 24h hour ("14:30 PM") — fix in primitives/localizations (12h → "2:30 PM",
   midnight 12:00 AM, noon 12:00 PM) with tests. Do not reformat other members (a split of that file comes next).
F4 Do NOT defer core shadcn API: add to `menu` the DropdownMenu-style rows — `MenuCheckboxItem` (checked state +
   indicator), `MenuRadioGroup`/`MenuRadioItem`, `MenuLabel`, `MenuShortcut` (text-xs tracking-widest muted, end-aligned),
   `MenuSeparator`, `MenuSub` (submenu) if not present — and `showShadcnMenu(context, ...)` helper. Keyboard: arrows,
   Home/End, typeahead, Enter/Space toggles checkbox/radio, Right/Left open/close submenus, Escape closes.
   `date_picker`: add the range mode trigger (`DateRangePicker` or `mode: range`) on top of calendar's range selection.
   If files exceed ~400 lines push reusable row/submenu machinery into primitives/menu_nav.dart or a new primitive.
Tests for every item. Rerun `rearch/qa_batch.sh menu hover_card date_picker time_picker primitives/menu_nav.dart`; `## RESULT`.

## Rules
Same as the original B13 brief (`rearch/briefs/P4-B13.md`): flat component folders, ≤ ~400 lines per file, layers
downward, no Material/Cupertino/part/ignore, meta.json deps exact, theme 4-leg precedence, sizes vs shadcn.
Another agent is building `chip_input` and another `file_picker`/`navigation_bar`/`button` fixes in parallel — do not
touch those folders. Write the report update to `rearch/reports/P4-B13.md`.
