# Phase 4 migration plan (P4-0)

Pilot is DONE (`registry_next/components/{button,toggle,dialog,input}` + `rearch/reports/P3_PILOT_DESIGN.md`).
This plan migrates every remaining old component into `flutter_shadcn_kit/lib/registry_next/components/<name>/`
for batch builders. Machine companion: `p4_batches.json` (same directory; validated with `python3 -m json.tool`).

Conventions (P3_PILOT_DESIGN §0 + QA_LOG lessons, binding on all batches):

- Folder per component: `<name>.dart`, `<name>_style.dart`, `<name>_theme.dart`, `preview.dart`, `meta.json`,
  `README.md`. Flat, no `_impl/`, each file <= ~400 LOC (tests exempt; dialog localizations 401-line warning accepted).
- widgets-only imports: `package:flutter/widgets.dart` + foundation/theme/primitives. No Material/Cupertino anywhere
  (old tree has 72 non-preview files importing material.dart + 1 cupertino — every batch below lists its share).
- Variants are data (one enum + exhaustive switch); interaction lives in primitives (`Clickable`, `focus_outline`);
  state styling via `WidgetStateProperty`/`StateValue`; resolution `widget > tree > app > defaults` with the built
  3-arg `resolveComponentStyle` (THEME_DESIGN §3.5 4-arg sketch is stale — T2, user-approved).
- `meta.json` uses the pilot `deps` shape (foundation/theme/primitives/components) read by `check_layers`
  (`undeclared` = error); legacy `dependencies.components` key kept until Phase 5 CLI rewrite.
- QA rejections to not repeat: input depending on autocomplete (dependency inverted: autocomplete → input);
  stock EditableText dropping selection (use primitives/text_editing); dialog barrier transparent (now black a0.5);
  theme frozen at show time (resolve inside route shell/barrier per P3-C F1); files > 400 LOC (input r1: 831/919);
  duplicate `dependencies` block in meta.json; `anchorPoint` on widgets ModalRoute (deleted).
- Pilot bugfixes that are now house rules, not per-batch decisions: disabled = whole control `Opacity(0.5)`
  (no disabled colour rows); destructive label = `destructiveForeground` (never hardcoded white);
  primary hover `/90`, secondary `/80`; `gap`/`data_widget` replaced by foundation `Gap`/`DataScope`.

## 1. Inventory: all 145 old dirs assigned

145 `meta.json` dirs (control 7, display 31, form 34, layout 25, navigation 12, overlay 22, utility 14).
143 unique ids (sortable + fade_scroll duplicated). Count cross-check (verified by script):

| Fate | Dirs | Result |
|---|---|---|
| DONE (pilot) | 4 (`control/button`, `form/input`, `form/text_field`, `overlay/dialog`; + new `toggle`) | 4 pilot components |
| MERGE INTO (absorbed, dir deleted) | 7 (`form/form_field` + `form/validated` → form; `form/file_input` → file_picker; `form/sortable` → sortable; `display/fade_scroll` → fade_scroll; `navigation/tab_container` + `tab_pane` → tabs; `form/text_field` → input counted in pilot row) | 0 new dirs |
| MOVE TO PRIMITIVE (dir deleted, owner already built) | 14 (table below) | 0 new dirs |
| DELETE outright | 1 (`navigation/tab_list`: no entry file, byte copy of tabs core) | 0 |
| MIGRATE (new component, §4 batches) | 119 dirs | 119 new components |

4 + 7 + 14 + 1 + 119 = 145. New tree total after Phase 4: 4 pilot + 119 = **123 components**.
Old LOC total ≈ 200k → target ≈ 80k (pilot ratio ~2.5x: input 7,415 → 2,835; button 7,770 → ~1,480).

### Moved to primitive (all built + tested in P2-E1/E2; dirs deleted, no rebuild)

| Old dir | Primitive target | Status |
|---|---|---|
| `display/text` | `primitives/text/` | DONE (declares no Text widget; tier already "primitive") |
| `control/clickable` | `primitives/clickable.dart` + `clickable_state.dart` | DONE |
| `control/hover` * | `primitives/hover.dart` | DONE (tie-break revised — open question Q1) |
| `layout/basic` * | `primitives/layout.dart` + `basic_layout.dart` + `label.dart` | DONE (tie-break revised — Q1) |
| `layout/hidden` * | `primitives/hidden.dart` | DONE (tie-break revised — Q1) |
| `form/control` | `primitives/form_core/` | DONE |
| `navigation/subfocus` | `primitives/subfocus*.dart` | DONE (8/8 byte-identical) |
| `overlay/overlay` | `primitives/overlay.dart` (+ manager/popover files) | DONE (2 files/30 LOC deleted) |
| `overlay/popover` | `primitives/popover*.dart` (7 files) | DONE (2 files/60 LOC deleted) |
| `utility/focus_outline` | `primitives/focus_outline.dart` | DONE (agrees with OWNERSHIP) |
| `utility/repeated_animation_builder` | `primitives/animation.dart` | DONE (65-char stub deleted) |
| `utility/shadcn_localizations` | `primitives/localizations/` (39 tables) | DONE |
| `utility/shadcn_localizations_en` | `primitives/localizations/` data | DONE |
| `utility/shadcn_localizations_extensions` | `primitives/localizations/localizations_extensions.dart` | DONE (`getColorPickerMode` dropped — needs ColorPickerMode, owned by color_picker B24) |

\* contested: OWNERSHIP awarded these to the component, P2-E1 built them as primitives and QA accepted.
Recommendation + ratification ask in §6 Q1. Builders treat the primitive as owner unless Q1 overturns.

### The 6 installability violations (P2-C) — each resolved, none left open

| # | Violation | Resolution (batch) |
|---|---|---|
| 1 | `navigation/tab_list`: no entry file (`_impl` + preview + JSON only) | DELETE outright (B21 tabs notes the deletion) |
| 2 | `layout/group`: no `group.dart` (only `group_widget.dart`) | MIGRATE as `group` with new `group.dart` entry (B11) |
| 3 | `form/hsl`: no `hsl.dart` (only `hsl_color_slider.dart`) | MIGRATE as `hsl` with new `hsl.dart` entry (B04) |
| 4 | `form/hsv`: same shape as hsl | MIGRATE as `hsv` with new `hsv.dart` entry (B04) |
| 5 | `form/sortable`: id `form_sortable` != dir | MERGE into canonical `layout/sortable` (B12); QA_LOG P1-C: layout canonical |
| 6 | `display/fade_scroll`: id `fade_scroll_display` != dir | MERGE into canonical `layout/fade_scroll` (B05) |
## 2. Missing primitives (P4-PRIM, build BEFORE the batches that need them)

Anything >= 2 components need that is not yet in `primitives/`. Two prim batches, parallel-safe
(disjoint files). All widgets-only, <= 400 LOC/file, with tests + meta-style docs per P2-E reports.

| ID | Files | Needed by (batches) | Notes |
|---|---|---|---|
| P4-PRIM-1 `scroll_metrics` | `primitives/scroll_metrics.dart` | scrollbar, scrollview, scrollable, scrollable_client, table (B05, B11), carousel (B07) | Scroll metrics + overscroll-glow helpers. Must NOT re-declare ScrollableClient* (B05 owns it). |
| P4-PRIM-2 `date_math` | `primitives/date_math.dart` | calendar (B07), date_picker (B13), time_picker (B13), object_input (B21) | Month grids, leap years, value ranges — the computeValueRange/getter logic P2E2 dropped as 0-reader code, re-added scoped to real callers only. DatePart/TimePart/DurationPart stay in localizations. |
| P4-PRIM-3 `color_math` | `primitives/color_math.dart` | color, color_field, color_picker, hsl, hsv, eye_dropper, color_input (B04, B08, B23–B25) | RGB/HSL/HSV conversion + contrast pick (destructiveForeground derivation). ColorPickerMode stays in color_picker (B24). |
| P4-PRIM-4 `menu_nav` | `primitives/menu_nav.dart` | menu (B13), menubar/select (B20), command (B10), dropdown/context (B20) | Roving-focus traversal + typeahead. MenuPopup/MenuGroupData stay in menu (B13); SubFocus stays separate. |
| P4-PRIM-5 `drag_sort` | `primitives/drag_sort.dart` | sortable (B12), tabs (B21) | Drag-reorder position math + reorderable helpers. |
| P4-PRIM-6 `file_value` | `primitives/file_value.dart` | file_picker (B22), dropzone (B08) | Upload-item value types + FileUpload* loading enums. Platform pick abstracts behind foundation/platform.dart (web/cross_file pkgs banned). |
| P4-PRIM-7 `toast_queue` | `primitives/toast_queue.dart` | toast (B09), gooey_toast (B18) | Single-owner toast queue/stack; both components use it, no duplicate queue. |

Not primitives (single-owner, stay in components): FormController-aware pending fan-out → form (B10, P2E2
carry); MenubarTheme*/MenuPopupTheme* → menu (B13); _TimeFormatter → formatter (B04); TabButton → tabs (B21);
chip_utils/wrap_utils → chip_input / single consumer (deleted with them); SheetOverlayHandler → drawer (B09,
consumers use the marker from primitives/sheet_overlay only).

## 3. Batches in dependency order

Rules: a component may depend only on foundation/theme/primitives, pilot components
(button/toggle/dialog/input), and components in EARLIER batches (declared in meta.json `deps.components`).
`parallel_group` = safe to run concurrently (no shared files, no inter-batch deps). 3 builders take one batch
each per wave. Sizes target <= ~3k new LOC per agent run (old LOC/2.5 pilot ratio); over-cap batches are flagged
and split by file between 2 builders. Waves run P0 → A → B → C → D → E → F.

### P0 — missing primitives (2 prim batches, parallel)

PRIM-A: P4-PRIM-1 scroll_metrics, P4-PRIM-2 date_math, P4-PRIM-3 color_math.
PRIM-B: P4-PRIM-4 menu_nav, P4-PRIM-5 drag_sort, P4-PRIM-6 file_value, P4-PRIM-7 toast_queue.

### Wave A — leaves (deps: pilot/prims only). B01–B06 parallel

B01 (7 comps, ~2.4k): alert_dialog 281→150 (deps dialog; thin dialog composition, inherits padding 24) /
badge 650→300 (button; Styleable-replace → per-state merge test) / card 913→400 (no deps; CardButton deleted) /
checkbox 1701→700 (form_core+Clickable) / chip 465→250 (button; absorbs chip_utils) / divider 991→400 (leaf) /
switch 810→350 (form_core leaf). Material sweep: none in this batch (all 72 Material files live elsewhere).

B02 (1 comp, ~3.2k, AT CAP): slider 7925→3200, no comp deps. 7 files import Material incl. slider.dart —
widgets-only rewrite (gesture + CustomPaint, no Material Slider). SliderValue already in primitive.
Split _controller.dart by responsibility if core passes 400 LOC.

B03 (8 comps, ~2.2k): avatar 1330→550 (unblocks skeleton) / spinner 362→200 / progress 491→250 (Material import
must go) / linear_progress_indicator 918→400 + circular_progress_indicator 545→250 (collapse to one component
if no visual delta vs progress — UNVERIFIED overlap, builder confirms) / triple_dots 100→100 (unblocks
pagination) / icon 449→250 (keep .fill only) / selectable 591→250 (reuses text_editing selection controls).

B04 (6 comps, ~1.7k; BUILD ORDER inside batch: alpha first — history/hsl/hsv declare components:[alpha]):
alpha 76→100 / color 1200→500 (RISK: old pubspec pulls animation_kit/cross_file/skeletonizer/country_flags/
phonecodes — all banned; widgets-only models + PRIM-3) / formatter 444→250 (owns _TimeFormatter; time_picker
imports it) / history 372→200 (button+alpha; unblocks eye_dropper) / hsl 691→300 + hsv 698→300 (entry-file fix
§1; own their slider+type enums; color_picker imports under private alias; 9.6k/9.5k painters stay private).

B05 (8 comps, ~2.4k, scroll wave): scrollbar 692→300 / scrollview 259→150 / scrollable 904→400 (strip the
scrollable_client fork) / scrollable_client 515→250 (superset wins; table imports it; unblocks table) /
outlined_container 1148→450 (R2 owner; merge shared fork body in; unblocks chat/card_image/nav_menu/window) /
collapsible 666→300 (button) / accordion 1013→400 (Material x2 must go) / fade_scroll 322+284→150 (dup-id merge
§1; RECONCILE with built primitives/fade_scroll.dart — one FadeScroll or re-export, keep single_owner green;
tabs/tab_pane declare components:[fade_scroll]).

B06 (10 tiny files, ~1.4k): async 82→100 (unblocks select) / debug 102→100 (UNVERIFIED purpose — confirm shippable
UI before theming; may belong in tool/) / image 69→100 / media_query 136→100 / page_route 233→150 /
patch 196→150 (needed by window) / switcher 465→250 / dot_indicator 897→400 (unblocks carousel) /
anchor 476→200 (unblocks overlay_configuration) / backdrop_transform 157→100 (unblocks pinned_sheet).

### Wave B — deps on A/pilot/prims. B07–B12 parallel

B07 (6, ~3.0k AT CAP): calendar 2597→1050 (button; needs PRIM-2; owns Calendar* enums; unblocks date_picker +
object_input) / skeleton 484→250 (avatar; skeletonizer BANNED — widgets-only shimmer) / carousel 1537→650
(dot_indicator) / tooltip 1009→400 (popover+hover prims; unblocks tracker/hover_card/nav_bar) /
input_otp 1381→550 (input prims) / text_area 312→150 (input prims; own theme only if delta vs Input(maxLines)).

B08 (6, ~2.0k): autocomplete 653→300 (button+card; AutoCompleteMode drift → reachable copy wins; AutoCompleteTheme
moves here; declares components:[input]) / radio_group 1616→650 (card) / empty_state 968→400 (card+button) /
keyboard_shortcut 603→250 (card; Display* typedefs owned by primitives/keyboard) / dropzone 269→150 (button;
needs PRIM-6; unblocks file_picker) / color_field 392→200 (alpha).

B09 (5, ~2.5k): drawer 3082→1250 (dialog; OWNS SheetOverlayHandler — card/context_menu/popup use only the
primitive marker; Material must go; unblocks drawer_container/swiper/pinned/overlay_config/dropdown/menu/
scaffold) / toast 1854→750 (PRIM-7 queue; unblocks gooey_toast + error_system) / pagination 351→150
(button+triple_dots) / breadcrumb 250→150 / steps 310→150 (text; Material must go).
B10 (5, ~3.0k AT CAP): form 3939+706+139→1900 (button+checkbox+input; CARRY from P2E2: form owns
FormController-aware pending fan-out; absorbs form_field + validated; FormKey superset already in form_core —
do not re-declare; unblocks formatted_input/item_picker/phone_input/object_input/filter_bar/time_picker) /
command 774→350 (button+dialog+divider+input; Material x4 must go; unblocks select) /
multiple_choice 913→400 (DataScope remap) / star_rating 1108→450 (Material must go) / locale_utils 284→150
(keeps formatFileSize/SizeUnitLocale ONLY; enums already in primitive; unblocks object_input).

B11 (3, ~2.4k): table 4526→1800 (scrollable_client; Data.inherit x4 → DataScope) / flex 1127→450 (UNVERIFIED
overlap with primitive SeparatedFlex — builder audits first; collapse if duplicate) / group 352→150 (entry fix
§1; needed by window).

B12 (4, ~2.7k): resizable 2281→900 (Material must go; engine in foundation/resizer.dart) / sortable 2035+451→1000
(dup-id merge §1, layout canonical; PRIM-5; single SortablePreview; unblocks tabs) /
overlay_configuration 1037→450 (anchor+drawer) / drawer_container 893→350 (drawer; unblocks pinned_sheet).

### Wave C — deps on B or earlier. B13–B19 parallel

B13 (5, ~3.1k AT CAP): menu 2922→1200 (button+dialog+drawer; Material must go; Data.maybeOf x11 → DataScope;
owns MenuPopup/MenuPopupTheme/MenubarTheme*/MenuGroupData; needs PRIM-4; unblocks menubar/context/dropdown/
spell/select/popup) / hover_card 686→300 (tooltip) / chip_input 1649→650 (chip+input+autocomplete) /
date_picker 952→400 (calendar+form; PRIM-2; unblocks object_input) / time_picker 1396→550 (button+form+input+
text; imports _TimeFormatter from formatter B04).

B14 (3, ~3.0k AT CAP): formatted_input 2084→850 (button+form+outlined+input; unblocks object_input) /
tree 3136→1250 (icon; Material must go; Clickable rows) / stepper 2058→850 (icon+text; Material must go;
Data.inherit x7 → DataScope).

B15 (7, ~2.6k): scaffold 1356→550 (drawer+linear+text; Material must go; unblocks file_picker + filter_bar) /
item_picker 972→400 (basic+button+card+dialog+form) / refresh_trigger 1250→500 (card+checkbox; Material must go) /
number_ticker 755→300 (intl-policy question Q2 — flagged, not blocking) / code_snippet 528→250 /
country_flag 416→200 (phonecodes/country_flags BANNED → primitives/phone_number.dart) /
navigation_menu 1112→450 (button+popover+basic+outlined+text).

B16 (1, ~3.6k OVER CAP — accepted, 2 builders by file): markdown 9028→3600. Material must go; likely vendored
parser — keep widgets-only parser files, split widget/theme/_controller by responsibility. Unblocks text_animate.

B17 (6, ~2.7k): chat 2192→900 (basic+button+outlined) / file_diff_viewer 1350→550 (button; Material must go) /
border_loading 1300→550 / timeline 480→200 (text; Material must go) / timeline_animation 293→150 (confirm no dup
with animation_queue primitive) / overflow_marquee 801→350 (Material must go; unblocks navigation_bar).

B18 (1, ~3.1k AT CAP): gooey_toast 7733→3100 (toast + PRIM-7; Material must go; keep render code; split renderer
vs widget/theme by file if needed).

B19 (4, ~2.7k): error_system 3257→1300 (button+card+divider+alert_dialog+dialog+toast; split models/rules/scopes/
ui per responsibility) / feature_carousel 2549→1000 (Material x2 must go) / card_image 351→150 (P3B notes:
Button.fixed → ButtonSize.icon, SelectedButton → Toggle(activeStyle:)) / tracker 431→200 (tooltip; Material
must go).

### Wave D — deps on C or earlier. B20–B23 parallel

B20 (6, ~2.8k): menubar 722→300 (menu; owns MenubarState drift; imports MenubarTheme* from menu) /
context_menu 1377→550 (menu; sheet marker only, no drawer dep) / dropdown_menu 626→250 (menu+drawer) /
spell_check_suggestions_toolbar 217→150 (menu) / select 3179→1300 (async+button+chip+command+dialog+hover+input+
menu; Material must go; SubFocus from primitive; unblocks phone_input/color_picker/filter_bar) /
popup 590→250 (dialog+menu; MenuPopup re-exported from menu — this dep is why popup waits for wave D).

B21 (5, ~3.1k AT CAP): tabs 2424+473+717→1450 (button+fade_scroll+sortable+text; absorbs tab_container+tab_pane —
TabPane drift → tabs copy wins; tab_list deleted; TabButton moves here from button; PRIM-5 drag) /
pinned_sheet 944→400 (drawer+drawer_container+backdrop) / object_input 1223→500 (calendar+card+date_picker+form+
formatted_input+locale_utils; 108 enum uses are switch labels — plain enums) / swiper 1169→450 (drawer) /
stage_container 578→250 (unblocks filter_bar).

B22 (2, ~3.3k OVER CAP — accepted, 2 builders, disjoint files): file_picker 4053+194→1700 (button+dropzone+
linear+scaffold; RISK: web/cross_file banned — abstract behind foundation/platform.dart + PRIM-6; absorbs
file_input) / navigation_bar 4116→1650 (button+hidden(prim)+overflow_marquee+tooltip; Material must go;
Data.maybeOf x13 → DataScope; Button.fixed/SelectedButton remaps per card_image note).

B23 (5, ~2.3k): window 3357→1350 (button+card+group+outlined+patch+text; Material must go) /
eye_dropper 791→350 (history; pairs with color_picker) / app 379→200 (Material must go; verify against
registry_next theme root — do not duplicate ShadcnTheme) / wrapper 128→100 (UNVERIFIED purpose — read first,
same caveat as debug) / alert 489→250 (basic_layout+outlined prims; Material x2 must go).

### Wave E/F — fan-in tails. B24 (E), B25 (F) sequential

B24 (3, ~3.0k AT CAP): color_picker 3322→1350 (alpha+button+color+eye_dropper+formatter+history+select+input —
old meta lists text_field: remap to input; hsl/hsv under private alias; OWNS ColorPickerMode; ButtonGroup user
already in pilot) / phone_input 1139→450 (form+input+select; Material must go; phonecodes banned → primitive) /
filter_bar 2994→1200 (11 comp deps incl. select+stage+scaffold — all earlier; placed E as largest fan-in).

B25 (2, ~1.4k): color_input 1143→450 (button+color+color_picker+eye_dropper+form+history; waits for color_picker,
hence own wave F) / text_animate 2337→950 (markdown; shares parser, own theme).

Wave/parallel summary: P0 (PRIM-A ∥ PRIM-B) → A (B01–B06) → B (B07–B12) → C (B13–B19) → D (B20–B23) → E (B24) →
F (B25). Within a wave, batches share no files and have no inter-batch deps (verified by script except the
documented intra-B04 alpha build order) — any batch can go to any of the 3 builders.
## 4. Per-component variants/sizes (builder reference)

Only components with variant/size enums get an enum + exhaustive-switch style table (pilot pattern).
Single-shape components get a flat `<Name>Theme` (dialog pattern). Source: old variant/theme files + meta api.

have enum: slider (shad presets → SliderVariant audit), badge/chip (style rows), calendar (CalendarViewType,
CalendarSelectionMode), input_otp (none — box styling only), radio_group/multiple_choice/star_rating/switch/
checkbox (on/off + states, no variant enum), toast (position/style — GooeyToast* enums stay in gooey_toast),
menu/menubar/select/command (item-state rows, no variant enum), tabs (TabVariant only if visual delta found),
table (TableCellResizeMode kept), markdown (MarkdownBlockKind/LinkKind render dispatch — internal, not theme),
file_picker (FileUploadVariant/LoadingMode kept), error_system (ErrorScopeType/ErrorActionType kept),
carousel/feature_carousel (CarouselAlignment/AnimationStyle kept), empty_state (EmptyStateVariant/Size kept),
border_loading (BorderLoadingMode kept), color_picker (ColorPickerMode kept — owned here), text_animate
(animation-style rows), navigation_bar (Navigation* enums kept), pagination/breadcrumb/steps (none).
Everything else: flat theme. Builders delete per-variant classes on sight (button-pilot rule); any enum with
exactly one surviving visual row collapses to a field (muted→text precedent).

## 5. Cutover checklist (end of Phase 4; also in p4_batches.json `cutover`)

1. Freeze `lib/registry` (no new PRs) one wave before the end; all work in `registry_next`.
2. Single-commit rename `lib/registry_next` → `lib/registry`; delete old tree + `shared/` + `themes_preset/` +
   old `manifests/` files in the same commit. (Branch `refactor/rearchitecture` per PLAN §3.)
3. Regenerate manifests: `manifests/components.json` (123 flat entries), `manifests/index.json` +
   `theme.index.json`, per-component `theme` sections via `tool/gen_theme_schema.dart` (hand-written pilot
   placeholders replaced), shared-manifest story ends (foundation/theme/primitives are implicit layers).
4. Playground sync: AGENTS.md `rsync` rule re-pointed at the new tree + gallery entries for every new preview.
5. Retire old tests: `test/registry/components/*`, `test/rearch` layers fixtures asserting old counts/paths
   (205/2246/1964 baselines, layers.json); port kept behavior assertions into `test/registry_next`.
6. Post-cutover gates: `flutter analyze` 0, full suite green, `check_layers` + `check_single_owner` +
   `check_user_theme` 0 errors, CLI install of all 123 into a scratch app compiles with dependents (pilot loop §3).
7. CLI Phase 5 (separate phase): flat `components/<name>/` resolution, topological shared install, single-owner
   preflight, user-owned `*_theme.dart` preserved on update, theme JSON → `app_theme.dart` generation,
   `components.json` schema for the new `deps` shape. References: `shadcn_flutter_cli/lib/src/` discovery,
   installer, `component_manifest_resolver.dart`, `studio_manager.dart`.

## 6. Open questions (orchestrator decisions needed before builders start)

- Q1 (ownership): OWNERSHIP awards Hover/Basic/Hidden to components; P2-E1 built them as primitives and QA
  accepted (0 duplicates). RECOMMENDATION: keep the primitives, delete the 3 component dirs (this plan).
  Overturning means reworking accepted P2-E1 files + tests — expensive, no measured benefit (component forks have
  <= 5 importing libs each vs primitive integration already shipped).
- Q2 (number_ticker intl): `intl` is allowed in primitives/localizations; number_ticker's `intl` dep needs a
  ruling — primitive helper, narrow allowed dep, or drop formatting. RECOMMENDATION: primitive helper.
- Q3 (fade_scroll): component (OWNERSHIP owner) vs built primitive copy both exist. RECOMMENDATION: component
  owns `FadeScroll`; primitive file becomes a re-export or is deleted in B05 — builder proposes, QA ratifies.
- Q4 (flex vs SeparatedFlex; debug/wrapper purpose): builder audits first day; collapse/delete if duplicate or
  dev-only. Nomata — flagging so QA expects the verdict in batch reports.
- Q5 (sortable canonical): QA_LOG P1-C says layout canonical; OWNERSHIP says UNVERIFIED which is richer.
  Layout copy is 18 files/2035 LOC vs form copy 7/451 — RECOMMENDATION: layout canonical confirmed, close Q5.
- Q6 (PLAN contradiction): PLAN §3 clean break (no `migrate` command, user decision 2026-10-06) vs PLAN §9 Phase 5
  `migrate` command. RECOMMENDATION: drop the migrate command; amend PLAN. Cutover item 7 reflects this.
- Q7 (over-cap batches): B02 slider, B16 markdown, B18 gooey_toast, B22 file_picker+nav_bar at/over ~3k.
  RECOMMENDATION: as planned (own batch + 2 builders by file); orchestrator confirms builder budget.

## Sources (all read)

PLAN §3–§6; OWNERSHIP.md (full) + ownership.json (structure + per-name reach); THEME_DESIGN.md
(rearch/reports/THEME_DESIGN.md, §1–§5 read); QA_LOG.md (all entries incl. P3-B/C/D + P2 rounds);
primitives/README.md + folder listings (form_core, text, text_editing, input_features, localizations);
P3_PILOT_DESIGN.md §0 + P3B/P3C/P3D reports; P2E1/P2E2 reports; TOKENS_AUDIT.md (shadow identity root cause,
alpha flattening, font drift); all 145 old meta.json (ids, deps, api); per-dir file/LOC counts;
Material-import grep (72 non-preview files); CLI lib/src touchpoints (discovery/installer/studio);
test/ + manifests/ layouts. Inferred items are marked UNVERIFIED inline. No code written (planning only).

## Orchestrator decisions on open questions (2026-10-06, binding for builders)
- Q1 hover/basic/hidden: stay primitives (already built + accepted in P2-E1). No component copies.
- Q2 number_ticker: use `package:intl` (core dependency) for number formatting.
- Q3 fade_scroll: primitive only (`primitives/fade_scroll.dart`, accepted). Drop the component from B05; components
  that need it declare `deps.primitives: [fade_scroll]`. Delete-reason: helper-only.
- Q4 flex/debug/wrapper: builder audits first; if helper-only or zero-value, DELETE with a one-line reason in the
  batch report (no shims). Keep only if a user would install it on its own.
- Q5 sortable: layout copy is canonical (QA_LOG P1-C). Confirmed.
- Q6 migrate command: none — clean break (user decision). PLAN wording is superseded.
- Q7 over-cap batches (B02 slider, B16 markdown, B18 gooey_toast, B22): one agent each; the builder may push
  reusable machinery into a primitive named in its report; still ≤ ~400 lines per file.
