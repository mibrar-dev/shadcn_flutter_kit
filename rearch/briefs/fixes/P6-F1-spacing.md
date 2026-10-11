# Brief P6-F1 — fix spacing / density / icon geometry (registry)

`KIT=/Users/ibrar/Desktop/infinora.noworkspace/shadcn_copy_paste/shadcn_flutter_kit`, `APP=$KIT/flutter_shadcn_kit`.
Read first: `$KIT/rearch/reports/P6_SPACING_AUDIT.md` + `p6_spacing_audit.json`, and the reference implementations
`$APP/lib/registry/components/button/button.dart` (~L319-350, sizes scale by `density.baseContentPadding / 16`) and
`components/dialog/dialog_style.dart:193` (`EdgeInsetsDensity`).

User requirement: every padding / margin / gap comes from the theme (density + spacing scale); components never
stretch or compact; leading/trailing icons keep the exact gap to the label AND to the outer edge (never touch it).

## Do
1. Fix every density finding in the audit (chip, badge, input, table, select, menu/menu_popup/menubar, tabs, and the
   rest listed in §findings) so the shadcn values (cite the class) are derived from density/spacing tokens — same
   mechanism as button/dialog; no new mechanism unless the audit proves one is missing (then put it in `theme/`).
2. Fix the 3 icon-geometry bugs (chip row order: leading BEFORE label; edge gap = horizontal padding; gap token).
3. Replace the raw literals in `primitives/` (28) and `theme/` (8) that should scale; keep justified fixed values.
4. Remove EVERY `skip:` in `$APP/test/registry/layout_audit/**` — all assertions must pass for real. Don't weaken
   assertions; if one is wrong vs shadcn, fix it and say why.
5. `preview.dart` literals: convert to theme spacing where a preview shows the component (mechanical), skip pure
   gallery layout.

## Do NOT touch
`docs/**` (another agent), the 7 colour components owned by P6-F2 (gooey_toast, gooey_surface, overflow_marquee,
number_ticker, scrollable, tracker, feature_carousel) and `code_snippet`. Do not run docs sync. No git state changes.

## Rules
Registry rules unchanged (layers, ≤ ~400 lines/file, no Material/Cupertino, no `// ignore`, meta.json deps = imports,
user-owned `_theme.dart` const only, clean break). Update README/meta `api` if a public param changes.

## Gates (paste output)
```
cd $KIT && rearch/qa_gate.sh
cd $APP && flutter test test/registry/layout_audit test/registry/theme_audit && grep -rn "skip:" test/registry/layout_audit
dart run tool/registry/gen_registry_manifest.dart --check
```
Report `$KIT/rearch/reports/P6-F1.md` (per component: before → after values, test evidence). `## RESULT` block.
