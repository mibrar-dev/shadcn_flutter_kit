# Brief P6-B1 — registry: component categories + installable Blocks

`KIT=/Users/ibrar/Desktop/infinora.noworkspace/shadcn_copy_paste/shadcn_flutter_kit`, `APP=$KIT/flutter_shadcn_kit`.
Read: `$KIT/REARCHITECTURE_PLAN.md` (layers, registry rules), `rearch/reports/registry_manifest.v2.schema.json`,
`$APP/tool/registry/gen_registry_manifest.dart`, `rearch/reports/p6_component_audit.json` (listed flags),
`rearch/reports/P6-F3.md` (preview contract), and ui.shadcn.com/blocks (agent-browser, SHORT commands).

User request (2026-10-10): a Blocks section like ui.shadcn.com/blocks — ready-made, copy-paste/installable blocks
with code; blocks AND components must be categorized.

## Do
1. Component categories: add `"category"` to every component `meta.json` from this taxonomy (refine names only with a
   reason in the report): Forms & Inputs, Buttons & Actions, Overlays, Menus, Navigation, Data Display, Feedback,
   Layout, Typography & Media, Date & Time, Color, Animation & Effects, Utilities (building blocks). Manifest + schema
   carry it; generator `--check` validates it is present and from the list.
2. Blocks layer: `lib/registry/blocks/<id>/` (layer 4, above components; may import foundation/theme/primitives/
   components only, never another block). Files: `<id>.dart` (+ `<id>_<part>.dart` parts if needed, each ≤ ~400
   lines), `meta.json` (`id`, `title`, `description`, `category`, `deps{foundation,theme,primitives,components}` =
   imports, `files[]`, `viewport` hint `desktop|mobile`), `README.md`. The block's public widget is the preview (no
   separate preview.dart). Extend manifest v2 with a `blocks` map, schema, generator `--check`, and the
   `tool/rearch/check_layers` / installability checks (a block installs with only its declared deps).
3. Author ≥ 16 polished blocks (shadcn-quality spacing/typography, theme tokens only, light + dark, responsive
   375→1440): Dashboard (2: stats + chart-like bars + recent table; analytics), Sidebar (3: collapsible icon sidebar,
   inset sidebar with groups, sidebar + header shell), Login (3: simple card, split image, with social buttons),
   Signup (2), OTP verify (1), Calendar (2: date range card, scheduling), Settings/Account (2: profile form,
   notifications), Marketing (1: pricing). Use ids like `dashboard-01`, `sidebar-01`, `login-01` (shadcn style).
4. Tests `$APP/test/registry/blocks/**`: each block pumps at 375/768/1440, light/dark, neutral/claude, no exceptions or
   overflow; meta deps = imports; manifest check.

## Do NOT touch
`docs/**`, the CLI repo, component implementation files (only `meta.json` category edits). If a block needs a missing
component feature, list it. No git state changes.

## Gates (paste output)
```
cd $KIT && rearch/qa_gate.sh
cd $APP && dart run tool/registry/gen_registry_manifest.dart --check && flutter test test/registry
```
Report `$KIT/rearch/reports/P6-B1.md` (category table with reasons, blocks list, schema diff). `## RESULT` block.
Append progress as you go. Do NOT open/read PNG images (model crashes) — use widget tests.
