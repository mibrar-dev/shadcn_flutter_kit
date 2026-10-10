# Brief P7-U3 — Theme Studio: apply on SELECT, never on hover (user feedback 2026-10-11)

KIT=/Users/ibrar/Desktop/infinora.noworkspace/shadcn_copy_paste/shadcn_flutter_kit, DOCS=$KIT/docs.
Do NOT open/read PNG images yourself (model crashes on images).

User: hovering over colours/themes/fonts in the Theme Studio rail pickers changes the site theme. Every hover rebuilds
the whole site; hovering across 4–5 options quickly causes rebuild jank. Wanted: browse (hover, scroll, arrow keys)
freely with ZERO site rebuilds; the theme changes only when an option is SELECTED (click/tap, Enter/Space).

## Do (docs only: `lib/widgets/theme_rail.dart`, `rail_*.dart`, `lib/state/*` as needed)
1. Remove every hover-preview / highlight-apply path (P6-T2 added "hover-apply"): highlight is local visual state in
   the popup only; `DocsState`/theme model is touched only on commit (select). Keyboard: arrows move the highlight,
   Enter/Space selects, Escape closes without change.
2. Sliders (radius, spacing, etc.): no site rebuild per drag frame — show the value in the popup while dragging and
   commit on drag end (onChangeEnd) and on discrete preset taps. Presets apply on tap.
3. A single commit must trigger exactly ONE theme rebuild (no duplicate notifyListeners / persistence-triggered second
   rebuild); persist after commit without blocking the frame.
4. Tests (`test/theme_rail_ux_test.dart`, update the P6-T2 hover/live tests): hovering over N options → theme model
   unchanged and site rebuild count 0 (count via a listener on DocsState/theme notifier); arrow-key navigation → no
   change; click/Enter → exactly one change + one notification; slider drag → no change until drag end, then one.
Do NOT touch registry files or overlay/popup/menu/select primitives (agent P7-U1 owns them) — if the rail needs a popup
API change, report it instead.
Gates: docs `dart format --output=none --set-exit-if-changed lib test tool`, `flutter analyze`, `flutter test`,
`dart run tool/gen_docs_data.dart --check`. (If docs fails to compile because of P7-U1/U2's in-flight registry work,
note it and run your targeted tests.) Report `$KIT/rearch/reports/P7-U3.md`, `## RESULT`. No git ops.
