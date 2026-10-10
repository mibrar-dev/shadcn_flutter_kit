# Brief P6-F3 — preview contract (one example at a time) + building-block flag + preview/registry render bugs

`KIT=/Users/ibrar/Desktop/infinora.noworkspace/shadcn_copy_paste/shadcn_flutter_kit`, `APP=$KIT/flutter_shadcn_kit`.
Read first: `$KIT/rearch/reports/P6_COMPONENT_AUDIT.md` (§2 classification, §3 root causes, §4 contract + §4.2 examples)
and `p6_component_audit.json`. Also `P6-F1.md` / `P6-F2.md` reports (they just changed spacing/colours — keep those).

User requirement: previews render correctly in light AND dark and follow the selected theme; the docs page shows ONE
named example at a time chosen by a Select (shadcn style); building blocks (color, history, …) are not listed.

## Do (registry only — `$APP/lib/registry/**`, `$APP/tool/registry/**`, `$APP/test/**`)
1. Contract: add `foundation/component_preview.dart` — `class ComponentPreview { const ComponentPreview(this.name,
   this.builder, {this.description}); final String name; final WidgetBuilder builder; final String? description; }`.
2. Rewrite EVERY listed component's `preview.dart` (97, per json `listed:true`) to export
   `const List<ComponentPreview> <camelName>Previews = [...]` with the §4.2 examples (first = default). Each example:
   ONE focused demo (variants as separate examples, not a wall — a "Sizes"/"Variants" row example is fine when shadcn
   does it); NO `ShadcnThemeData(...)`/pinned brightness/colours (read `ShadcnTheme.of(context)`); NO outer fixed
   height boxes; must lay out inside a bounded box of 720×420 and shrink-wrap (no Expanded/unbounded assumptions);
   controllers/state created inside the example's own StatefulWidget; spacing from theme tokens. Remove the old
   `XxxPreview` gallery class (clean break). Building-block previews: keep or delete — they are not shown.
3. `meta.json`: add `"listed": false` for the 21 building blocks (alpha, anchor, app, async, backdrop_transform, color,
   error_system, formatter, group, history, hsl, hsv, icon, locale_utils, media_query, multiple_choice,
   overlay_configuration, page_route, patch, scrollable_client, timeline_animation); default true. Update
   `rearch/reports/registry_manifest.v2.schema.json` + `gen_registry_manifest.dart` so `listed` lands in registry.json.
4. Fix the render bugs: `chat/chat.dart:225-245` overflow, `eye_dropper` notifier used after dispose (find the owner),
   `empty_state` intrinsic width, `scrollbar` shared controller, `file_diff_viewer`, `switch` row overflow, `image`
   preview (no remote network asset — use a local/generated image), `pinned_sheet` Stack under loose constraints, and
   every other `threw`/`overflow` row in the audit.
5. Test `$APP/test/registry/previews_test.dart`: for every listed component, every example pumps inside a 720×420
   box AND at 375 wide, under neutral + claude, light + dark, with no exception and no overflow; example names unique;
   no `ShadcnThemeData(` in any preview.dart (static check).

## Do NOT touch
`docs/**` (another agent rebuilds the docs harness to consume the contract after you). No git state changes.

## Gates (paste output)
```
cd $KIT && rearch/qa_gate.sh
cd $APP && dart run tool/registry/gen_registry_manifest.dart --check && flutter test test/registry
grep -rln "ShadcnThemeData(" lib/registry/components/*/preview.dart   # must be empty
```
Report `$KIT/rearch/reports/P6-F3.md` (component → examples list, bugs fixed with root cause). `## RESULT` block.
Large rewrite: work in batches of ~15 components, run `flutter analyze` + the previews test after each batch, and
append progress to the report as you go so a resumed session can continue.
