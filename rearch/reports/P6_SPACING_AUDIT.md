# P6-D9b — Spacing / padding / density compliance audit

**Brief:** P6-D9b (spacing / padding / density compliance audit for every component — report + tests only)
**Date:** 2026-10-10
**Scope:** `flutter_shadcn_kit/lib/registry/**` (118 components + `foundation/`, `primitives/`, `theme/`), 1,320 spatial literals measured.

## Requirement

> Every component's paddings, margins and gaps must be THEME-DEPENDENT (spacing + density tokens), and every
> component must render exactly right — never stretched, never compacted. A Chip has the exact shadcn padding; a
> leading/trailing icon keeps the correct gap from the label AND from the chip edge (never touching the edge);
> same for table cells, menu rows, inputs, buttons, badges, tabs, cards, dialogs, toasts — everything.

## Method

Two independent evidence sources, both reproducible:

1. **Static scan** — `test/registry/layout_audit/spatial_scan.dart` parses every registry Dart file with
   `package:analyzer` (`parseString`, unresolved AST — no analysis context needed) and classifies every
   `EdgeInsets.*`, `Gap()`, `SizedBox(width/height:)`, `BoxConstraints(min/max…)`, `Padding` and Flex
   `spacing:` literal. `spatial_scan_rules.dart` holds the classifier, `spatial_scan_visitor.dart` the AST
   walk. Regenerate with
   `cd flutter_shadcn_kit && dart run test/registry/layout_audit/spatial_scan.dart` →
   `rearch/reports/p6_spacing_audit.json`.
   *Note:* `parseString` does not resolve types, so a bare `EdgeInsets.all(4)` parses as a
   `MethodInvocation` (target `EdgeInsets`, method `all`), not an `InstanceCreationExpression`. Both spellings
   are scanned, which is why the earlier `const`-only scan under-counted.
2. **Measurement tests** — `$APP/test/registry/layout_audit/*_test.dart` render each component under
   `Density.compactDensity` (8/8/4), `Density.defaultDensity` (16/16/8 — the shadcn reference) and
   `Density.spaciousDensity` (20/20/10) and measure with `tester.getSize` / `tester.getRect`.

## Totals (from `p6_spacing_audit.json`)

| | |
|---|---|
| Spatial literals found | **1,320** |
| Components/layers with sites | 121 |
| Findings in component implementation files | **112** |
| Findings in `preview.dart` demo galleries | **552** |
| Components with no implementation finding (**compliant**) | **84 / 118** |
| Measurement tests | 26 passing, 10 skipped-as-findings |

### Classification of all 1,320 sites

| classification | count | meaning |
|---|---|---|
| `raw` | 664 | **FINDING** — literal padding/gap/spacing that never scales |
| `theme_default` | 269 | resolved through a component theme / widget leg; compliant when its own default derives from density |
| `layout_cap` | 181 | a width/height layout cap (`maxWidth: 460`), not padding — allowed |
| `computed` | 130 | an expression over parameters (`_innerMin(...)`, `gap ?? 8`) — allowed |
| `derived_spacing` | 47 | `theme.spacing.<step>` — compliant |
| `derived_density` | 23 | `EdgeInsetsDensity.*`, `resolveEdgeInsets(.., density)`, a literal × the density base — compliant |
| `border_hairline` | 3 | 1px borders — allowed |
| `shadcn_fixed` | 3 | sizes shadcn pins in a box context — allowed |

## Compliant components — no implementation finding

  `accordion`, `alert_dialog`, `alpha`, `anchor`, `app`
  `async`, `avatar`, `backdrop_transform`, `border_loading`, `breadcrumb`
  `button`, `calendar`, `card_image`, `carousel`, `checkbox`
  `chip_input`, `code_snippet`, `collapsible`, `color`, `color_field`
  `color_input`, `color_picker`, `context_menu`, `country_flag`, `dialog`
  `drawer_container`, `dropdown_menu`, `eye_dropper`, `feature_carousel`, `form`
  `formatter`, `foundation`, `gooey_toast`, `group`, `history`
  `hover_card`, `hsl`, `hsv`, `icon`, `image`
  `locale_utils`, `markdown`, `media_query`, `menubar`, `multi_select`
  `multiple_choice`, `navigation_menu`, `number_ticker`, `outlined_container`, `overflow_marquee`
  `overlay_configuration`, `page_route`, `pagination`, `patch`, `pinned_sheet`
  `popup`, `progress`, `resizable`, `scaffold`, `scrollable`
  `scrollable_client`, `scrollbar`, `scrollview`, `selectable`, `skeleton`
  `slider`, `sortable`, `spell_check_suggestions_toolbar`, `spinner`, `stage_container`
  `star_rating`, `stepper`, `steps`, `swiper`, `switch`
  `switcher`, `text_animate`, `text_area`, `theme`, `timeline`
  `timeline_animation`, `tooltip`, `tracker`, `triple_dots`

## Findings per component (implementation files only)

`✗` = has at least one non-scaling literal in a component file. Line numbers point at the literal.

| component | ok | n | findings (file:line → current value) |
|---|---|---|---|
| `alert` | ✗ | 2 | `components/alert/alert_style.dart:267` `EdgeInsets.symmetric` = `16`; `components/alert/alert_style.dart:267` `EdgeInsets.symmetric` = `12` |
| `autocomplete` | ✗ | 3 | `components/autocomplete/autocomplete_style.dart:115` `EdgeInsets.symmetric` = `8`; `components/autocomplete/autocomplete_style.dart:116` `EdgeInsets.symmetric` = `6`; `components/autocomplete/autocomplete_style.dart:337` `EdgeInsets.all` = `4` |
| `badge` | ✗ | 2 | `components/badge/badge_style.dart:274` `EdgeInsets.symmetric` = `8`; `components/badge/badge_style.dart:275` `EdgeInsets.symmetric` = `2` |
| `card` | ✗ | 1 | `components/card/card_style.dart:156` `EdgeInsets.all` = `24` |
| `chat` | ✗ | 4 | `components/chat/chat_style.dart:336` `EdgeInsets.symmetric` = `12`; `components/chat/chat_style.dart:336` `EdgeInsets.symmetric` = `8`; `components/chat/chat_style.dart:346` `EdgeInsets.symmetric` = `6`; `components/chat/chat_style.dart:346` `EdgeInsets.symmetric` = `4` |
| `chip` | ✗ | 2 | `components/chip/chip_style.dart:30` `EdgeInsets.symmetric` = `8`; `components/chip/chip_style.dart:31` `EdgeInsets.symmetric` = `2` |
| `command` | ✗ | 5 | `components/command/command.dart:239` `EdgeInsets.only` = `8`; `components/command/command.dart:306` `SizedBox` = `48`; `components/command/command_style.dart:236` `EdgeInsets.symmetric` = `8`; `components/command/command_style.dart:237` `EdgeInsets.symmetric` = `6`; `components/command/command_style.dart:247` `EdgeInsets.all` = `4` |
| `date_picker` | ✗ | 3 | `components/date_picker/date_picker.dart:378` `EdgeInsets.symmetric` = `8`; `components/date_picker/date_picker.dart:385` `SizedBox` = `32`; `components/date_picker/date_picker.dart:386` `SizedBox` = `32` |
| `divider` | ✗ | 1 | `components/divider/divider_style.dart:181` `EdgeInsets.symmetric` = `8` |
| `dot_indicator` | ✗ | 1 | `components/dot_indicator/dot_indicator_style.dart:248` `EdgeInsets.all` = `8` |
| `drawer` | ✗ | 1 | `components/drawer/drawer_style.dart:247` `EdgeInsets.all` = `24` |
| `dropzone` | ✗ | 1 | `components/dropzone/dropzone_style.dart:244` `EdgeInsets.all` = `24` |
| `empty_state` | ✗ | 4 | `components/empty_state/empty_state_style.dart:263` `EdgeInsets.all` = `24`; `components/empty_state/empty_state_style.dart:270` `EdgeInsets.all` = `10`; `components/empty_state/empty_state_style.dart:279` `EdgeInsets.all` = `32`; `components/empty_state/empty_state_style.dart:286` `EdgeInsets.all` = `12` |
| `error_system` | ✗ | 10 | `components/error_system/error_system.dart:79` `Gap` = `6`; `components/error_system/error_system.dart:127` `Gap` = `8`; `components/error_system/error_system.dart:182` `Gap` = `12`; `components/error_system/error_system.dart:192` `Gap` = `4`; `components/error_system/error_system.dart:202` `Gap` = `12`; `components/error_system/error_system.dart:203` `Gap` = `8`; `components/error_system/error_system.dart:260` `Gap` = `8`; `components/error_system/error_system_style.dart:120` `EdgeInsets.all` = `24`; `components/error_system/error_system_style.dart:123` `EdgeInsets.symmetric` = `16`; `components/error_system/error_system_style.dart:123` `EdgeInsets.symmetric` = `12` |
| `file_diff_viewer` | ✗ | 2 | `components/file_diff_viewer/file_diff_viewer.dart:171` `SizedBox` = `8`; `components/file_diff_viewer/file_diff_viewer.dart:180` `SizedBox` = `12` |
| `file_picker` | ✗ | 2 | `components/file_picker/file_picker_style.dart:124` `EdgeInsets.symmetric` = `16`; `components/file_picker/file_picker_style.dart:124` `EdgeInsets.symmetric` = `12` |
| `filter_bar` | ✗ | 3 | `components/filter_bar/filter_bar_style.dart:153` `SizedBox` = `36`; `components/filter_bar/filter_bar_style.dart:323` `EdgeInsets.fromLTRB` = `0`; `components/filter_bar/filter_bar_style.dart:334` `EdgeInsets.fromLTRB` = `0` |
| `formatted_input` | ✗ | 2 | `components/formatted_input/formatted_input_style.dart:155` `EdgeInsets.symmetric` = `8`; `components/formatted_input/formatted_input_style.dart:155` `EdgeInsets.symmetric` = `4` |
| `input` | ✗ | 2 | `components/input/input_style.dart:209` `EdgeInsets.symmetric` = `12`; `components/input/input_style.dart:209` `EdgeInsets.symmetric` = `8` |
| `input_otp` | ✗ | 1 | `components/input_otp/input_otp_style.dart:206` `EdgeInsets.symmetric` = `6` |
| `item_picker` | ✗ | 1 | `components/item_picker/item_picker_style.dart:109` `EdgeInsets.all` = `8` |
| `keyboard_shortcut` | ✗ | 2 | `components/keyboard_shortcut/keyboard_shortcut_style.dart:19` `EdgeInsets.symmetric` = `6`; `components/keyboard_shortcut/keyboard_shortcut_style.dart:20` `EdgeInsets.symmetric` = `4` |
| `menu` | ✗ | 6 | `components/menu/menu.dart:269` `SizedBox` = `16`; `components/menu/menu.dart:269` `SizedBox` = `16`; `components/menu/menu.dart:308` `SizedBox` = `16`; `components/menu/menu.dart:308` `SizedBox` = `16`; `components/menu/menu_style.dart:366` `EdgeInsets.all` = `4`; `components/menu/menu_style.dart:376` `EdgeInsets.all` = `4` |
| `navigation_bar` | ✗ | 2 | `components/navigation_bar/navigation_bar_style.dart:133` `EdgeInsets.symmetric` = `8`; `components/navigation_bar/navigation_bar_style.dart:133` `EdgeInsets.symmetric` = `12` |
| `object_input` | ✗ | 1 | `components/object_input/object_input.dart:213` `Gap` = `8` |
| `phone_input` | ✗ | 2 | `components/phone_input/phone_input_style.dart:146` `EdgeInsets.symmetric` = `12`; `components/phone_input/phone_input_style.dart:146` `EdgeInsets.symmetric` = `8` |
| `primitives` | ✗ | 28 | `primitives/drawer_route/drawer_panel_surface.dart:100` `SizedBox` = `16`; `primitives/form_core/object_form_field.dart:331` `EdgeInsets.symmetric` = `12`; `primitives/form_core/object_form_field.dart:331` `EdgeInsets.symmetric` = `8`; `primitives/form_core/object_form_prompt.dart:276` `EdgeInsets.symmetric` = `16`; `primitives/form_core/object_form_prompt.dart:276` `EdgeInsets.symmetric` = `8`; `primitives/gooey/gooey_content.dart:97` `SizedBox` = `8`; `primitives/gooey/gooey_content.dart:274` `SizedBox` = `24`; `primitives/gooey/gooey_content.dart:275` `SizedBox` = `24`; `primitives/markdown_parser/blocks.dart:156` `SizedBox` = `8`; `primitives/markdown_parser/media.dart:169` `SizedBox` = `4`; `primitives/markdown_parser/view.dart:29` `SizedBox` = `8`; `primitives/navigation/navigation_theme.dart:176` `EdgeInsets.symmetric` = `12`; `primitives/navigation/navigation_theme.dart:176` `EdgeInsets.symmetric` = `8`; `primitives/navigation/navigation_theme.dart:189` `EdgeInsets.symmetric` = `12`; `primitives/navigation/navigation_theme.dart:189` `EdgeInsets.symmetric` = `8`; `primitives/roving_row.dart:149` `SizedBox` = `16`; `primitives/roving_row.dart:149` `SizedBox` = `16`; `primitives/roving_row.dart:151` `SizedBox` = `16`; `primitives/roving_row.dart:151` `SizedBox` = `16`; `primitives/roving_row.dart:246` `SizedBox` = `8`; `primitives/roving_row.dart:249` `SizedBox` = `8`; `primitives/select_popup.dart:80` `SizedBox` = `16`; `primitives/select_popup.dart:80` `SizedBox` = `16`; `primitives/select_popup.dart:180` `SizedBox` = `48`; `primitives/select_popup.dart:194` `SizedBox` = `48`; `primitives/selectable_radio/selectable_radio_theme.dart:236` `EdgeInsets.all` = `2`; `primitives/text/text_extension.dart:282` `SizedBox` = `8`; `primitives/window_host.dart:296` `EdgeInsets.all` = `6` |
| `radio_group` | ✗ | 1 | `components/radio_group/radio_group_style.dart:208` `EdgeInsets.all` = `16` |
| `refresh_trigger` | ✗ | 1 | `components/refresh_trigger/refresh_trigger.dart:336` `Gap` = `8` |
| `select` | ✗ | 4 | `components/select/select.dart:346` `SizedBox` = `8`; `components/select/select_style.dart:21` `EdgeInsets.symmetric` = `12`; `components/select/select_style.dart:27` `EdgeInsets.symmetric` = `8`; `components/select/select_style.dart:28` `EdgeInsets.symmetric` = `6` |
| `table` | ✗ | 2 | `components/table/table_style.dart:273` `EdgeInsets.all` = `8`; `components/table/table_style.dart:278` `EdgeInsets.symmetric` = `8` |
| `tabs` | ✗ | 2 | `components/tabs/tabs_style.dart:247` `EdgeInsets.all` = `3`; `components/tabs/tabs_style.dart:248` `EdgeInsets.symmetric` = `8` |
| `time_picker` | ✗ | 1 | `components/time_picker/time_picker.dart:207` `SizedBox` = `4` |
| `toast` | ✗ | 3 | `components/toast/toast.dart:334` `SizedBox` = `8`; `components/toast/toast_style.dart:236` `EdgeInsets.all` = `16`; `components/toast/toast_style.dart:243` `EdgeInsets.all` = `24` |
| `toggle` | ✗ | 1 | `components/toggle/toggle_style.dart:211` `EdgeInsets.symmetric` = `8` |
| `tree` | ✗ | 2 | `components/tree/tree_style.dart:135` `EdgeInsets.symmetric` = `8`; `components/tree/tree_style.dart:135` `EdgeInsets.symmetric` = `4` |
| `window` | ✗ | 1 | `components/window/window_style.dart:172` `EdgeInsets.symmetric` = `8` |

### The three components the brief names explicitly

| component | compliant? | why |
|---|---|---|
| `chip` | ✗ | `chip_style.dart:29-32` `chipDefaultPadding = EdgeInsets.symmetric(horizontal: 8, vertical: 2)` — a raw literal. Additionally `chip.dart:132-146` pads only `child`, so `leading`/`trailing` are laid out **outside** the padding. |
| `badge` | ✗ | `badge_style.dart:273-276` `badgeDefaultPadding` is the same raw literal, and `badge.dart:157` wraps only `child` in it. |
| `button` | ✓ | The reference implementation: `button.dart:319-350` `_buttonMetricsFor` scales the size table by `density.baseContentPadding / 16`, and `chip.dart`'s sibling layout puts the padding around the whole leading/label/trailing row. |

## Preview galleries

552 of the 664 findings are in `preview.dart` files — demo scaffolding (`Gap(24)`, `SizedBox(width: 460)`,
`padding: EdgeInsets.all(24)`). They do not affect an installed app, but they are shipped source and they
demonstrate the wrong habit. Recommended as a mechanical follow-up: replace with `theme.spacing.<step>` /
`EdgeInsets.all(theme.spacing.md)`.

## Measurement test suite

| file | covers |
|---|---|
| `layout_audit_shadcn_values_test.dart` | the shadcn value at the default density for chip / badge / input / button (all sizes + icon) / table cell + header / menu row / card / alert — every expectation cites its Tailwind class |
| `layout_audit_density_test.dart` | compact < default < comfortable scaling + proportionality for button, dialog (compliant) and chip, badge, input, table cell, select, menu row, tabs (findings) |
| `layout_audit_icon_gaps_test.dart` | leading/trailing icon → edge distance and → label distance in LTR **and** RTL, plus the no-overlap rule |
| `layout_audit_no_stretch_test.dart` | intrinsic width in a loose `Row` and in a 600px wide parent; padding survival under a 48px tight host |
| `layout_audit_support.dart` | the shared harness (3 densities, `looseHost`, `resolvedPaddingOf`, …) |

Run: `cd flutter_shadcn_kit && flutter test test/registry/layout_audit` → **36 passing, 0 skipped**
(since P6-F1, see `P6-F1.md`: 26 passing + 10 skipped before the fix).
Every skipped test was a FINDING below; P6-F1 removed both the `skip: true` and its line in
`test/registry/layout_audit/failing_tests.txt`.

### The 10 failing tests

| test | finding (file:line → fix) |
|---|---|
| density / chip | `chip_style.dart:29-32` raw `EdgeInsets.symmetric(horizontal: 8, vertical: 2)` → derive from `density.baseContentPadding` (the `button` `pad()` pattern) |
| density / badge | `badge_style.dart:273-276` same raw literal → derive from density |
| density / input | `input_style.dart:209` `inputDefaults.padding` raw `EdgeInsets.symmetric(horizontal: 12, vertical: 8)` → `EdgeInsetsDensity` or density-scaled |
| density / table cell | `table_style.dart:273` `tableCellPadding = EdgeInsets.all(8)`, `:278` `tableHeadCellPadding` → derive from density |
| density / select trigger | `select_style.dart:20-22` `selectDefaultTriggerPadding = EdgeInsets.symmetric(horizontal: 12)` and `:26-29` `selectDefaultItemPadding` → derive from density |
| density / menu row | `menu.dart:206-209` inlines `EdgeInsets.symmetric(horizontal: 8, vertical: 6)` → move into `MenuTheme.itemPadding` and derive |
| density / tabs | `tabs_style.dart:247-248` `containerPadding: EdgeInsets.all(3)`, `tabPadding: EdgeInsets.symmetric(horizontal: 8)` → derive from density |
| icon gaps / chip LTR | `chip.dart:132-146` the row is `[content, Gap, leading, Gap, trailing]`, so `leading` renders **after** the label (measured 84px from the outer edge instead of 8) and the trailing icon touches the edge → pad the whole row and emit `leading` before the content |
| icon gaps / chip RTL | same root cause — the slots are not mirrored either |
| icon gaps / badge | `badge.dart:157` `Padding` wraps only `child`; the leading icon starts at the badge edge (measured **0px** gap — exactly the "icon touching the edge" the requirement forbids) → wrap the icon row in the padding |

## Allowed raw values (justified)

* **1px hairline borders** — `borderWidth: 1`, `Divider(height: 1)` (3 sites). shadcn itself uses `border`;
  these are never spacing.
* **Icon glyph sizes owned by a component theme** — e.g. `chipButtonDefaultIconSize = 12`, `iconSize:`
  arguments. Fixed by the component's type scale, not by spacing.
* **shadcn-pinned box sizes** (3 sites) — `size-2.5` = 10 (`AvatarBadge`, `Badge(showAsDot)`), `size-4` = 16
  (`Checkbox`), `Switch` `h-[1.15rem] w-8` = 32 x 18.4. Upstream pins these with `size-*`, not `p-*/m-*`.
* **Layout caps** (181 sites) — `maxWidth: 460`, `minWidth: 192` (`menuPopupDefaults.minWidth` = shadcn
  `w-48`), `maxHeight` on scroll areas. Viewport layout, not component padding.

## Recommended fix order

1. **Icon geometry first** (`chip.dart:132-146`, `badge.dart:157`) — user-visible misplacement, and it makes the
   padding question moot for those two components. Pattern to copy: `button.dart:210-224` (row of
   leading/Gap/label/Gap/trailing *inside* the padding).
2. **The shared layer** (28 findings in `primitives/`, 8 in `theme/`) — the largest component-visible blast
   radius.
3. **The seven density findings** with a live test (chip, badge, input, table, select, menu, tabs) — each one
   is a `→ derive from density` edit plus removing one `skip: true`.
4. **The remaining 26 components' literal defaults** (alert, autocomplete, card, chat, command, …) — mechanical
   once the pattern is settled.
5. **Preview galleries** (552) — mechanical, no behaviour change.

## Open questions

* `tableHeadCellPadding` is `EdgeInsets.symmetric(horizontal: 8)` (vertical 0). Upstream `TableHead` is
  `h-10 px-2`, so this matches shadcn, but it is asymmetric with `tableCellPadding`'s `p-2`. Confirm the
  intent before making both density-derived.
* `menu_popup` / `menubar` padding is `EdgeInsets.all(4)` (`menu_style.dart:366,376`) — shadcn `p-1`. Currently
  reported as a finding (it is a raw literal) but it *is* the shadcn value; only the scaling is missing.
* `Input` has no `Clickable`: its content padding is the **second** `Padding` in its subtree (the first
  reserves the 1px border). Any future refactor must keep that ordering or the measurement helper breaks.
* **Stray file outside the repo (needs a decision):** an early version of the scanner resolved the report path
  to `../../rearch/reports/…` relative to the package root, i.e. one level above the git repo, and wrote
  `shadcn_copy_paste/rearch/reports/p6_spacing_audit.json`. It is a stale 178 KB duplicate of the correct
  `$KIT/rearch/reports/p6_spacing_audit.json` (219 KB) and lives outside the repo, so nothing tracks it. The
  scanner now resolves the path against its own script location. Per the brief's "never delete files" rule the
  stray copy was left in place — please remove it manually.
