# Ownership & shared-layer audit (P1-C)

_Generated 2026-10-06 from `flutter_shadcn_kit/lib/registry`. Read-only audit; no source file was modified._

## Counts at a glance

| Metric | Value |
|---|---|
| Dart files scanned | 2,053 |
| Distinct top-level names (class/mixin/enum/extension/typedef) | 2,256 |
| Duplicated names — **all** | 160 |
| Duplicated names — **excluding `shared/theme`** (in scope) | **157** |
| Duplicated declaration sites (excluding theme) | 317 |
| … with byte-identical bodies | 101 |
| … with diverged bodies | 56 |
| Components (`components/<category>/<name>/`) | 143 |
| Shared Dart files excluding `shared/theme/**` | 142 |
| Merge decisions | 14 |
| External-package symbol references (`data_widget`, `gap`) | 231 |
| Top-level declarations with **zero references anywhere** (truly dead) | 0 |
| Top-level declarations used only inside their own library (prune candidates) | 1272 |

### Reconciling 157 with the orchestrator's 148

The orchestrator counted **148**; this audit counts **157** in-scope duplicate names. The orchestrator's script is not available, so the delta cannot be attributed name-by-name with certainty. What *is* verifiable is the exact composition of the 157, so any 148-subset can be checked against it.

| Category | Names | Note |
|---|---|---|
| component ↔ component | 83 | the duplicates a component-level grep finds |
| component ↔ shared | 65 | only a hash-based or cross-layer scan finds these |
| shared ↔ shared | 6 | only a hash-based or cross-layer scan finds these |
| same owner, two directories | 3 | only a hash-based or cross-layer scan finds these |

Likely sources of the 9-name delta, in order of confidence:

1. **The `shared/primitives` shadow layer (65 of the 157 names).** `shared/primitives/` holds 89 files / 8,743 LOC that are in large part forks of `components/*`. A scan restricted to `components/**` finds the 83 component↔component names but misses most of these 65. The largest hidden cluster is the **text family** (9 names: `TextModifier`, `TextExtension`, `WrappedText`, `WrappedTextDataBuilder`, `WidgetTextWrapper`, `UnorderedListData`, `_RichTextThenWidget`, `_SelectableTextThenWidget`, `_TextThenWidget`) — and note this copy is the *more* used of the two: `shared/primitives/text.dart` is imported by **19 components** vs 11 for `display/text`. It is also 523 LOC.
2. **The full subfocus family (8 names).** All 8 `SubFocus*` names are byte-identical between `components/navigation/subfocus/` and `shared/primitives/subfocus.dart`. Partial counting (e.g. only `SubFocus`/`SubFocusScope`) is plausible.
3. **6 `shared ↔ shared` duplicates** — `ColumnExtension`, `RowExtension` and `FlexExtension` are each declared **twice inside `shared/utils` itself** (in `widget_extensions.dart` and in `_impl/state/__separated_flex_state.dart`), plus `NeverWidgetBuilder`, `TextFieldClearIntent` and `RepeatedAnimationBuilder`. A scan that only compares across directories would miss the three in-file duplicates entirely.

**Action for the orchestrator:** treat **157** as the baseline for `tool/check_single_owner.dart`, not 148. The PLAN §5 target of "148 → 0" should read "**157 → 0**".

Further counting notes:

- **3 theme duplicates are excluded and out of scope** for this brief: `InstalledThemePreset`, `RegistryThemePreset`, `RegistryThemePresetTokens` (all inside `shared/theme/`, owned by the theme agent). Including them the all-in figure is 160.
- **10 anonymous `extension on X` declarations** were caught by a naive regex but carry no name, so they are not duplicates by name. They are excluded.
- Duplicates are counted by **name across all locations**, so a name declared 3× counts once (e.g. `FadeScroll` has 3 sites, `_ScaleGradient` has 3, `FadeScrollTheme` has 3). Counting by *site* instead gives **317**.

## Decision rules applied

From PLAN §5, in priority order:

| Rule | Test | Action |
|---|---|---|
| **R0** (PLAN §5 named resolutions) | The family is explicitly called out in PLAN §5 | Follow the PLAN decision verbatim |
| **R2** part of another component's public API | Name appears in the owner component's exported API | Owner component keeps it; others declare `components: [owner]` in `meta.json` and import |
| **R1** used by 1 component | Exactly one component library imports it | That component owns it |
| **R3** generic helper used by 2+ | ≥2 component libraries import it | Lowest shared layer that fits (`foundation` < `theme` < `primitives`) |
| **R4** prune | Zero importing libraries outside its own declaration (measured: 0 truly-dead names, 1,272 internal-only) | Delete the *copy*, keep one owner |

**Importer counting is library-aware.** Dart `part` files cannot import; they inherit their library root's imports. All importer counts below are resolved through the `part of '...'` closure, then rolled up to library roots and finally to distinct component directories. Without this closure the counts are badly wrong - a naive per-file import scan reports 0 importers for `shared/primitives/text.dart` when in fact **19 components** import it.

### How each component-vs-shared tie was broken

The 46 names duplicated between a component and `shared/` were not decided by taste. Each was scored on measured reach:

| Name | Bodies | Component side | Shared side | Winner | Rationale |
|---|---|---|---|---|---|
| `Basic` | diverged | `basic` 5 libs / 5 comps | `shared/primitives` 3 libs / 3 comps | **COMPONENT** | 5 libs / 5 components vs 3/3 shared. |
| `BasicLayout` | diverged | `basic` 5 libs / 5 comps | `shared/primitives` 3 libs / 3 comps | **COMPONENT** | 5/5 component vs 3/3 shared; both are forks of the same Basic API. |
| `BasicTheme` | identical | `basic` 5 libs / 5 comps | `shared/primitives` 3 libs / 3 comps | **COMPONENT** | Byte-identical; 5/5 component vs 3/3 shared. |
| `Hidden` | diverged | `hidden` 3 libs / 2 comps | `shared/primitives` 1 libs / 1 comps | **COMPONENT** | 3 libs / 2 components vs 1/1 shared. |
| `HiddenTheme` | diverged | `hidden` 3 libs / 2 comps | `shared/primitives` 1 libs / 1 comps | **COMPONENT** | The component theme is a superset (1,439 vs 1,037 chars); 2 components vs 1. |
| `Label` | diverged | `basic` 5 libs / 5 comps | `shared/primitives` 3 libs / 3 comps | **COMPONENT** | Doc-comment drift only; 5/5 component vs 3/3 shared. |
| `MenuGroupData` | diverged | `menu` 10 libs / 6 comps | `shared/primitives` 2 libs / 2 comps | **COMPONENT** | 10 libs / 6 components (menu, menubar, context_menu, dropdown_menu, select, spell_check_suggestions_toolbar) vs 2/2 shared. |
| `SheetOverlayHandler` | diverged | `drawer` 14 libs / 9 comps | `shared/primitives` 3 libs / 3 comps | **COMPONENT** | 14 libs / 9 components vs 3/3 shared (card, context_menu, popup). |
| `TextFieldClearIntent` | identical | `text_field` 22 libs / 17 comps | `shared/utils` 2 libs / 2 comps | **COMPONENT** | 22 libs / 17 components vs 2/2 shared; it is part of the input intent system. |
| `_HiddenLayout` | diverged | `hidden` 3 libs / 2 comps | `shared/primitives` 1 libs / 1 comps | **COMPONENT** | Private fork (1,534 vs 975 chars); 2 components vs 1. |
| `Clickable` | diverged | `clickable` 2 libs / 1 comps | `shared/primitives` 17 libs / 9 comps | **SHARED** | PLAN 4 L2 `primitives/clickable`. 17 libs / 9 components vs 2/1. |
| `ComponentController` | identical | `control` 1 libs / 1 comps | `shared/primitives` 20 libs / 13 comps | **SHARED** | PLAN 5 R0 + R3: the ControlledComponent family is already in shared/primitives/form_control.dart with 20 libs / 13 components; the form/control copies have 1 lib / 1 component. |
| `ComponentValueController` | identical | `control` 1 libs / 1 comps | `shared/primitives` 20 libs / 13 comps | **SHARED** | PLAN 5 R0 + R3: the ControlledComponent family is already in shared/primitives/form_control.dart with 20 libs / 13 components; the form/control copies have 1 lib / 1 component. |
| `ControlledComponent` | identical | `control` 1 libs / 1 comps | `shared/primitives` 20 libs / 13 comps | **SHARED** | PLAN 5 R0 + R3: the ControlledComponent family is already in shared/primitives/form_control.dart with 20 libs / 13 components; the form/control copies have 1 lib / 1 component. |
| `ControlledComponentAdapter` | identical | `control` 1 libs / 1 comps | `shared/primitives` 20 libs / 13 comps | **SHARED** | PLAN 5 R0 + R3: the ControlledComponent family is already in shared/primitives/form_control.dart with 20 libs / 13 components; the form/control copies have 1 lib / 1 component. |
| `ControlledComponentData` | identical | `control` 1 libs / 1 comps | `shared/primitives` 20 libs / 13 comps | **SHARED** | PLAN 5 R0 + R3: the ControlledComponent family is already in shared/primitives/form_control.dart with 20 libs / 13 components; the form/control copies have 1 lib / 1 component. |
| `FadeScroll` | diverged | `fade_scroll` 2 libs / 1 comps | `shared/primitives` 2 libs / 2 comps | SHARED → **COMPONENT** | Two component dirs plus a shared copy with 3 different bodies. `components/layout/fade_scroll` is the one with an external importer, so it keeps the name and the other two are deleted. tabs/tab_pane declare `components: [fade_scroll]`. |
| `FadeScrollTheme` | identical | `fade_scroll` 2 libs / 1 comps | `shared/primitives` 2 libs / 2 comps | SHARED → **COMPONENT** | 3 identical copies; keep the layout/fade_scroll one. |
| `FocusOutline` | diverged | `focus_outline` 2 libs / 1 comps | `shared/primitives` 10 libs / 9 comps | **SHARED** | 10 libs / 9 components vs 2/1. |
| `FocusOutlineTheme` | diverged | `focus_outline` 2 libs / 1 comps | `shared/primitives` 10 libs / 9 comps | **SHARED** | 9 components import the shared theme; the utility/focus_outline theme copy has 0 external importers. |
| `FormFieldHandle` | identical | `form` 5 libs / 4 comps | `shared/primitives` 21 libs / 15 comps | **SHARED** | PLAN 5 R0: form state lives once in primitives/form_core. Measured: the shared/primitives copies have 21 libs / 15 components vs 5 libs / 4 components for the form copies. |
| `FormKey` | diverged | `form` 5 libs / 4 comps | `shared/primitives` 21 libs / 15 comps | **SHARED** | PLAN 5 R0: form state lives once in primitives/form_core. Measured: the shared/primitives copies have 21 libs / 15 components vs 5 libs / 4 components for the form copies. |
| `FormPendingBuilder` | diverged | `form` 5 libs / 4 comps | `shared/utils` 39 libs / 33 comps | **SHARED** | The typedef is exported from form/form.dart (5 libs / 4 components) but the identical copy lives in shared/utils/_impl/core/context_callback_action.dart whose library has 39 libs / 33 components. It is form plumbing, so form_core owns it and shared/utils drops it. |
| `FormPendingWidgetBuilder` | diverged | `form` 5 libs / 4 comps | `shared/utils` 39 libs / 33 comps | **SHARED** | The typedef is exported from form/form.dart (5 libs / 4 components) but the identical copy lives in shared/utils/_impl/core/context_callback_action.dart whose library has 39 libs / 33 components. It is form plumbing, so form_core owns it and shared/utils drops it. |
| `FormValidationMode` | diverged | `form` 5 libs / 4 comps | `shared/primitives` 21 libs / 15 comps | **SHARED** | PLAN 5 R0: form state lives once in primitives/form_core. Measured: the shared/primitives copies have 21 libs / 15 components vs 5 libs / 4 components for the form copies. |
| `FormValueSupplier` | identical | `form` 5 libs / 4 comps | `shared/primitives` 21 libs / 15 comps | **SHARED** | PLAN 5 R0: form state lives once in primitives/form_core. Measured: the shared/primitives copies have 21 libs / 15 components vs 5 libs / 4 components for the form copies. |
| `KeyboardShortcutDisplayBuilder` | diverged | `keyboard_shortcut` 2 libs / 1 comps | `shared/utils` 2 libs / 2 comps | **SHARED** | 2 libs / 2 components (keyboard_shortcut, menu) vs 2/1. |
| `KeyboardShortcutDisplayHandle` | diverged | `keyboard_shortcut` 2 libs / 1 comps | `shared/utils` 2 libs / 2 comps | **SHARED** | 2/2 shared vs 2/1 component. |
| `OutlinedContainer` | diverged | `outlined_container` 11 libs / 10 comps | `shared/primitives` 14 libs / 12 comps | SHARED → **COMPONENT** | PLAN 5 R2 override. Measured reach slightly favours shared (14 libs / 12 comps vs 11/10), but OutlinedContainer is part of the `outlined_container` component public API, and R2 says such names stay with their owner component. The shared copy becomes the component implementation. |
| `OutlinedContainerTheme` | diverged | `outlined_container` 11 libs / 10 comps | `shared/primitives` 14 libs / 12 comps | SHARED → **COMPONENT** | PLAN 5 R2 override, same reason. The component theme is also a superset (2,238 vs 601 chars). |
| `RepeatedAnimationBuilder` | diverged | `repeated_animation_builder` 0 libs / 0 comps | `shared/utils` 39 libs / 33 comps | **SHARED** | The component file is a 65-char re-export stub with 0 importers; the 474-char implementation sits in shared/utils whose library has 39 libs / 33 components. |
| `ReplaceResult` | identical | `form` 5 libs / 4 comps | `shared/primitives` 21 libs / 15 comps | **SHARED** | PLAN 5 R0: form state lives once in primitives/form_core. Measured: the shared/primitives copies have 21 libs / 15 components vs 5 libs / 4 components for the form copies. |
| `ShadcnLocalizations` | diverged | `shadcn_localizations` 42 libs / 4 comps | `shared/localizations` 18 libs / 15 comps | **SHARED** | 18 libs / 15 components vs 42 libs / 4 components - the shared/localizations copy is the one 15 components actually use. |
| `StatedWidget` | diverged | `clickable` 4 libs / 1 comps | `shared/primitives` 17 libs / 9 comps | **SHARED** | Byte-level fork; 17/9 shared vs 4/1 component. |
| `SubFocus` | identical | `subfocus` 1 libs / 1 comps | `shared/primitives` 4 libs / 3 comps | **SHARED** | 4 libs / 3 components (command, menu, select) vs 1/1. |
| `SubFocusBuilder` | identical | `subfocus` 1 libs / 1 comps | `shared/primitives` 4 libs / 3 comps | **SHARED** | Byte-identical; 4/3 shared vs 1/1 component. |
| `SubFocusScope` | identical | `subfocus` 1 libs / 1 comps | `shared/primitives` 4 libs / 3 comps | **SHARED** | Byte-identical; 4/3 shared vs 1/1 component. |
| `SubFocusScopeBuilder` | identical | `subfocus` 1 libs / 1 comps | `shared/primitives` 4 libs / 3 comps | **SHARED** | Byte-identical; 4/3 shared vs 1/1 component. |
| `SubFocusScopeState` | identical | `subfocus` 1 libs / 1 comps | `shared/primitives` 4 libs / 3 comps | **SHARED** | Byte-identical; 4/3 shared vs 1/1 component. |
| `SubFocusState` | identical | `subfocus` 1 libs / 1 comps | `shared/primitives` 4 libs / 3 comps | **SHARED** | Byte-identical; 4/3 shared vs 1/1 component. |
| `SurfaceBlur` | diverged | `outlined_container` 11 libs / 10 comps | `shared/primitives` 14 libs / 12 comps | **COMPONENT** | Re-exported from `components/layout/outlined_container/outlined_container.dart`, which 10 components import; the shared/primitives copy has no external importer of its own. |
| `TextExtension` | diverged | `text` 11 libs / 11 comps | `shared/primitives` 25 libs / 19 comps | **SHARED** | Same measurement as TextModifier: 25/19 shared vs 11/11 component. |
| `TextModifier` | diverged | `text` 11 libs / 11 comps | `shared/primitives` 25 libs / 19 comps | **SHARED** | Text modifiers are PLAN 4 L2 `primitives/text`. The shared copy has 25 libs / 19 components vs 11/11 for the display/text fork, and display/text declares no `Text` widget at all - only modifiers. Its meta.json already says `"tier": "primitive"`. |
| `UnorderedListData` | identical | `text` 11 libs / 11 comps | `shared/primitives` 25 libs / 19 comps | **SHARED** | Byte-identical fork; 25/19 shared vs 11/11 component. |
| `ValidationResult` | identical | `form` 5 libs / 4 comps | `shared/primitives` 21 libs / 15 comps | **SHARED** | PLAN 5 R0: form state lives once in primitives/form_core. Measured: the shared/primitives copies have 21 libs / 15 components vs 5 libs / 4 components for the form copies. |
| `WidgetStateExtension` | identical | `clickable` 1 libs / 1 comps | `shared/primitives` 17 libs / 9 comps | **SHARED** | Byte-identical; 17/9 shared vs 1/1 component. |
| `WidgetStatesData` | identical | `clickable` 6 libs / 1 comps | `shared/primitives` 17 libs / 9 comps | **SHARED** | Byte-identical; 17/9 shared vs 6/1 component. |
| `WidgetStatesProvider` | identical | `clickable` 2 libs / 1 comps | `shared/primitives` 17 libs / 9 comps | **SHARED** | Byte-identical; 17/9 shared vs 2/1 component. |
| `WidgetTextWrapper` | identical | `text` 11 libs / 11 comps | `shared/primitives` 25 libs / 19 comps | **SHARED** | Byte-identical fork; 25/19 shared vs 11/11 component. |
| `WrappedText` | diverged | `text` 11 libs / 11 comps | `shared/primitives` 25 libs / 19 comps | **SHARED** | Same measurement: 25/19 shared vs 11/11 component; bodies differ only in doc comments. |
| `WrappedTextDataBuilder` | identical | `text` 11 libs / 11 comps | `shared/primitives` 25 libs / 19 comps | **SHARED** | Byte-identical fork; 25/19 shared vs 11/11 component. |
| `_ControlledComponentAdapterState` | identical | `control` 1 libs / 1 comps | `shared/primitives` 20 libs / 13 comps | **SHARED** | PLAN 5 R0 + R3: the ControlledComponent family is already in shared/primitives/form_control.dart with 20 libs / 13 components; the form/control copies have 1 lib / 1 component. |
| `_FormEntryCachedValue` | identical | `form` 5 libs / 4 comps | `shared/primitives` 21 libs / 15 comps | **SHARED** | PLAN 5 R0: form state lives once in primitives/form_core. Measured: the shared/primitives copies have 21 libs / 15 components vs 5 libs / 4 components for the form copies. |
| `_OutlinedContainerState` | diverged | `outlined_container` 11 libs / 10 comps | `shared/primitives` 14 libs / 12 comps | SHARED → **COMPONENT** | PLAN 5 R2 override; follows the widget it belongs to (2,615 vs 2,499 chars). |
| `_RichTextThenWidget` | diverged | `text` 11 libs / 11 comps | `shared/primitives` 25 libs / 19 comps | **SHARED** | Private fork; 25/19 shared vs 11/11 component. |
| `_ScaleGradient` | identical | `fade_scroll` 2 libs / 1 comps | `shared/primitives` 2 libs / 2 comps | SHARED → **COMPONENT** | 3 identical private copies; keep the layout/fade_scroll one. |
| `_SelectableTextThenWidget` | diverged | `text` 11 libs / 11 comps | `shared/primitives` 25 libs / 19 comps | **SHARED** | Private fork (1,430 vs 847 chars); 25/19 shared vs 11/11 component. |
| `_ShadcnLocalizationsDelegate` | diverged | `shadcn_localizations` 42 libs / 4 comps | `shared/localizations` 18 libs / 15 comps | **SHARED** | Follows ShadcnLocalizations; 15 components use the shared/localizations delegate. |
| `_SubFocusScopeState` | identical | `subfocus` 1 libs / 1 comps | `shared/primitives` 4 libs / 3 comps | **SHARED** | Byte-identical private fork; 4/3 shared vs 1/1 component. |
| `_SubFocusState` | identical | `subfocus` 1 libs / 1 comps | `shared/primitives` 4 libs / 3 comps | **SHARED** | Byte-identical private fork; 4/3 shared vs 1/1 component. |
| `_TextThenWidget` | diverged | `text` 11 libs / 11 comps | `shared/primitives` 25 libs / 19 comps | **SHARED** | Private fork (1,909 vs 699 chars); 25/19 shared vs 11/11 component. |
| `Hover` | diverged | `hover` 2 libs / 1 comps | `shared/primitives` 1 libs / 1 comps | TIE → **COMPONENT** | Tie at 1 component each; `control/hover` is the registry component with a preview/README/meta.json, so it owns Hover and HoverActivity (bodies differ by one line). |
| `HoverActivity` | diverged | `hover` 2 libs / 1 comps | `shared/primitives` 1 libs / 1 comps | TIE → **COMPONENT** | Tie at 1 component each; the control/hover copy is the registry component copy, so it keeps the name. |
| `HoverTheme` | identical | `hover` 5 libs / 1 comps | `shared/primitives` 1 libs / 1 comps | TIE → **COMPONENT** | Byte-identical; only the control/hover copy has an external importer, so the component owns it. |
| `PhoneNumber` | diverged | `phone_input` 2 libs / 1 comps | `shared/primitives` 1 libs / 1 comps | TIE → **COMPONENT** | Tie at 1 component each; the phone_input copy is a superset (694 vs 494 chars) and lives in the component that exposes it. |

## 1. Duplicated declarations (all 157)

101 are byte-identical (body-hash equal after whitespace normalization); 56 have diverged bodies. Grouped by owner family, largest first:

| # | Owner family | Names | Verdict |
|---|---|---|---|
| 1 | `input`, `text_field` | 28 | **28 name(s) -> `components/input`** |
| 2 | `tab_container`, `tabs` | 11 | **11 name(s) -> `components/tabs`** |
| 3 | `autocomplete`, `text_field` | 10 | **10 name(s) -> `components/autocomplete`** |
| 4 | `shared/primitives`, `text` | 9 | **9 name(s) -> `primitives/text`** |
| 5 | `shared/primitives`, `subfocus` | 8 | **8 name(s) -> `primitives/subfocus`** |
| 6 | `tab_pane`, `tabs` | 8 | **8 name(s) -> `components/tabs`** |
| 7 | `form`, `shared/primitives` | 7 | **7 name(s) -> `primitives/form_core`** |
| 8 | `shared/utils` | 6 | **6 name(s) -> `shared/utils`** |
| 9 | `control`, `shared/primitives` | 6 | **6 name(s) -> `primitives/form_core`** |
| 10 | `scrollable`, `scrollable_client` | 6 | **6 name(s) -> `components/scrollable_client`** |
| 11 | `clickable`, `shared/primitives` | 5 | **5 name(s) -> `primitives/clickable`** |
| 12 | `menu`, `menubar` | 5 | **5 name(s) -> `components/menu`, `components/menubar`** |
| 13 | `basic`, `shared/primitives` | 4 | **4 name(s) -> `components/basic`** |
| 14 | `color_picker`, `hsl` | 4 | **4 name(s) -> `components/hsl`** |
| 15 | `color_picker`, `hsv` | 4 | **4 name(s) -> `components/hsv`** |
| 16 | `menu`, `popup` | 4 | **4 name(s) -> `components/menu`** |
| 17 | `outlined_container`, `shared/primitives` | 4 | **4 name(s) -> `components/outlined_container`** |
| 18 | `fade_scroll`, `shared/primitives` | 3 | **3 name(s) -> `components/fade_scroll`** |
| 19 | `hidden`, `shared/primitives` | 3 | **3 name(s) -> `components/hidden`** |
| 20 | `hover`, `shared/primitives` | 3 | **3 name(s) -> `components/hover`** |
| 21 | `fade_scroll` | 2 | **2 name(s) -> `components/fade_scroll`** |
| 22 | `focus_outline`, `shared/primitives` | 2 | **2 name(s) -> `primitives/focus_outline`** |
| 23 | `form`, `shared/utils` | 2 | **2 name(s) -> `primitives/form_core`** |
| 24 | `keyboard_shortcut`, `shared/utils` | 2 | **2 name(s) -> `primitives/keyboard`** |
| 25 | `shadcn_localizations`, `shared/localizations` | 2 | **2 name(s) -> `primitives/localizations`** |
| 26 | `tab_list`, `tabs` | 2 | **2 name(s) -> `components/tabs`** |
| 27 | `menu`, `shared/primitives` | 1 | **1 name(s) -> `components/menu`** |
| 28 | `phone_input`, `shared/primitives` | 1 | **1 name(s) -> `components/phone_input`** |
| 29 | `repeated_animation_builder`, `shared/utils` | 1 | **1 name(s) -> `primitives/animation`** |
| 30 | `drawer`, `shared/primitives` | 1 | **1 name(s) -> `components/drawer`** |
| 31 | `sortable` | 1 | **1 name(s) -> `components/sortable`** |
| 32 | `shared/utils`, `text_field` | 1 | **1 name(s) -> `components/text_field (-> input)`** |
| 33 | `formatter`, `time_picker` | 1 | **1 name(s) -> `components/formatter`** |

### Full per-name table

**`reach` = number of libraries that import the *declaring library* (rolled up through the `part of` closure).** This is the reach of the file the copy lives in, not of the symbol — the exact per-symbol numbers are in the table above and in `ownership.json` under `external_referencing_components`.

| Name | Kind | Sites | Bodies | Owner | Action | reach per copy | Rationale |
|---|---|---|---|---|---|---|---|
| `AcceptSuggestionIntent` | class | 2 | same | `components/autocomplete` | dedupe | `autocomplete`=3; `text_field`=22 | PLAN 5 R0: `autocomplete` owns AutoComplete. The autocomplete copies are the reachable ones (imported by autocomplete + chip_input); the text_field copies have no external importer. |
| `AutoComplete` | class | 2 | **differs** | `components/autocomplete` | dedupe | `autocomplete`=3; `text_field`=22 | PLAN 5 R0: `autocomplete` owns AutoComplete. The autocomplete copies are the reachable ones (imported by autocomplete + chip_input); the text_field copies have no external importer. |
| `AutoCompleteCompleter` | typedef | 2 | same | `components/autocomplete` | dedupe | `autocomplete`=3; `text_field`=22 | PLAN 5 R0: `autocomplete` owns AutoComplete. The autocomplete copies are the reachable ones (imported by autocomplete + chip_input); the text_field copies have no external importer. |
| `AutoCompleteIntent` | class | 2 | same | `components/autocomplete` | dedupe | `autocomplete`=3; `text_field`=22 | PLAN 5 R0: `autocomplete` owns AutoComplete. The autocomplete copies are the reachable ones (imported by autocomplete + chip_input); the text_field copies have no external importer. |
| `AutoCompleteMode` | enum | 2 | **differs** | `components/autocomplete` | dedupe | `autocomplete`=3; `text_field`=22 | PLAN 5 R0: `autocomplete` owns AutoComplete. The autocomplete copies are the reachable ones (imported by autocomplete + chip_input); the text_field copies have no external importer. |
| `AutoCompleteTheme` | class | 2 | **differs** | `components/autocomplete` | dedupe | `autocomplete`=3; `text_field`=22 | PLAN 5 R0: `autocomplete` owns AutoComplete. The autocomplete copies are the reachable ones (imported by autocomplete + chip_input); the text_field copies have no external importer. |
| `Basic` | class | 2 | **differs** | `components/basic` | dedupe | `basic`=5; `shared/primitives`=3 | 5 libs / 5 components vs 3/3 shared. |
| `BasicLayout` | class | 2 | **differs** | `components/basic` | dedupe | `basic`=5; `shared/primitives`=3 | 5/5 component vs 3/3 shared; both are forks of the same Basic API. |
| `BasicTheme` | class | 2 | same | `components/basic` | dedupe | `basic`=5; `shared/primitives`=3 | Byte-identical; 5/5 component vs 3/3 shared. |
| `Clickable` | class | 2 | **differs** | `primitives/clickable` | dedupe | `clickable`=2; `shared/primitives`=17 | PLAN 4 L2 `primitives/clickable`. 17 libs / 9 components vs 2/1. |
| `ColumnExtension` | extension | 2 | same | `shared/utils` | dedupe | `shared/utils`=39; `shared/utils`=0 | Declared twice inside shared/utils itself; no external importer. Collapse to one copy; `.separator()` has 0 call sites so it may be dropped entirely. |
| `ComponentController` | mixin | 2 | same | `primitives/form_core` | dedupe | `control`=1; `shared/primitives`=20 | PLAN 5 R0 + R3: the ControlledComponent family is already in shared/primitives/form_control.dart with 20 libs / 13 components; the form/control copies have 1 lib / 1 component. |
| `ComponentValueController` | class | 2 | same | `primitives/form_core` | dedupe | `control`=1; `shared/primitives`=20 | PLAN 5 R0 + R3: the ControlledComponent family is already in shared/primitives/form_control.dart with 20 libs / 13 components; the form/control copies have 1 lib / 1 component. |
| `ControlledComponent` | mixin | 2 | same | `primitives/form_core` | dedupe | `control`=1; `shared/primitives`=20 | PLAN 5 R0 + R3: the ControlledComponent family is already in shared/primitives/form_control.dart with 20 libs / 13 components; the form/control copies have 1 lib / 1 component. |
| `ControlledComponentAdapter` | class | 2 | same | `primitives/form_core` | dedupe | `control`=1; `shared/primitives`=20 | PLAN 5 R0 + R3: the ControlledComponent family is already in shared/primitives/form_control.dart with 20 libs / 13 components; the form/control copies have 1 lib / 1 component. |
| `ControlledComponentData` | class | 2 | same | `primitives/form_core` | dedupe | `control`=1; `shared/primitives`=20 | PLAN 5 R0 + R3: the ControlledComponent family is already in shared/primitives/form_control.dart with 20 libs / 13 components; the form/control copies have 1 lib / 1 component. |
| `FadeScroll` | class | 3 | **differs** | `components/fade_scroll` | dedupe | `fade_scroll`=1; `fade_scroll`=1; `shared/primitives`=2 | Two component dirs plus a shared copy with 3 different bodies. `components/layout/fade_scroll` is the one with an external importer, so it keeps the name and the other two are deleted. tabs/tab_pane declare `components: [fade_scroll]`. |
| `FadeScrollPreview` | class | 2 | same | `components/fade_scroll` | dedupe | `fade_scroll`=0; `fade_scroll`=0 | Two previews for the same component id; collapse to one after the dir merge. |
| `FadeScrollTheme` | class | 3 | same | `components/fade_scroll` | dedupe | `fade_scroll`=1; `fade_scroll`=1; `shared/primitives`=2 | 3 identical copies; keep the layout/fade_scroll one. |
| `FlexExtension` | extension | 2 | **differs** | `shared/utils` | dedupe | `shared/utils`=39; `shared/utils`=0 | Declared twice inside shared/utils itself; no external importer. Collapse to one copy. |
| `FocusOutline` | class | 2 | **differs** | `primitives/focus_outline` | dedupe | `focus_outline`=2; `shared/primitives`=10 | 10 libs / 9 components vs 2/1. |
| `FocusOutlineTheme` | class | 2 | **differs** | `primitives/focus_outline` | dedupe | `focus_outline`=2; `shared/primitives`=10 | 9 components import the shared theme; the utility/focus_outline theme copy has 0 external importers. |
| `FormFieldHandle` | mixin | 2 | same | `primitives/form_core` | dedupe | `form`=5; `shared/primitives`=21 | PLAN 5 R0: form state lives once in primitives/form_core. Measured: the shared/primitives copies have 21 libs / 15 components vs 5 libs / 4 components for the form copies. |
| `FormKey` | class | 2 | **differs** | `primitives/form_core` | dedupe | `form`=5; `shared/primitives`=21 | PLAN 5 R0: form state lives once in primitives/form_core. Measured: the shared/primitives copies have 21 libs / 15 components vs 5 libs / 4 components for the form copies. |
| `FormPendingBuilder` | class | 2 | **differs** | `primitives/form_core` | dedupe | `form`=5; `shared/utils`=39 | The typedef is exported from form/form.dart (5 libs / 4 components) but the identical copy lives in shared/utils/_impl/core/context_callback_action.dart whose library has 39 libs / 33 components. It is form plumbing, so form_core owns it and shared/utils drops it. |
| `FormPendingWidgetBuilder` | typedef | 2 | **differs** | `primitives/form_core` | dedupe | `form`=5; `shared/utils`=39 | The typedef is exported from form/form.dart (5 libs / 4 components) but the identical copy lives in shared/utils/_impl/core/context_callback_action.dart whose library has 39 libs / 33 components. It is form plumbing, so form_core owns it and shared/utils drops it. |
| `FormValidationMode` | enum | 2 | **differs** | `primitives/form_core` | dedupe | `form`=5; `shared/primitives`=21 | PLAN 5 R0: form state lives once in primitives/form_core. Measured: the shared/primitives copies have 21 libs / 15 components vs 5 libs / 4 components for the form copies. |
| `FormValueSupplier` | mixin | 2 | same | `primitives/form_core` | dedupe | `form`=5; `shared/primitives`=21 | PLAN 5 R0: form state lives once in primitives/form_core. Measured: the shared/primitives copies have 21 libs / 15 components vs 5 libs / 4 components for the form copies. |
| `HSLColorSlider` | class | 2 | same | `components/hsl` | dedupe | `color_picker`=1; `hsl`=1 | Byte-identical; hsl owns it and color_picker imports it under a private alias. |
| `HSLColorSliderPainter` | class | 2 | **differs** | `components/hsl` | dedupe | `color_picker`=1; `hsl`=1 | Bodies genuinely differ (2,041 vs 9,652 chars) so the painters stay private per component; hsl owns the small one. |
| `HSLColorSliderType` | enum | 2 | same | `components/hsl` | dedupe | `color_picker`=1; `hsl`=1 | Byte-identical; hsl owns it. |
| `HSVColorSlider` | class | 2 | same | `components/hsv` | dedupe | `color_picker`=1; `hsv`=1 | Byte-identical; hsv owns it and color_picker imports it under a private alias. |
| `HSVColorSliderPainter` | class | 2 | **differs** | `components/hsv` | dedupe | `color_picker`=1; `hsv`=1 | Bodies genuinely differ (1,989 vs 9,564 chars); hsv owns the small one. |
| `HSVColorSliderType` | enum | 2 | same | `components/hsv` | dedupe | `color_picker`=1; `hsv`=1 | Byte-identical; hsv owns it. |
| `Hidden` | class | 2 | **differs** | `components/hidden` | dedupe | `hidden`=3; `shared/primitives`=1 | 3 libs / 2 components vs 1/1 shared. |
| `HiddenTheme` | class | 2 | **differs** | `components/hidden` | dedupe | `hidden`=3; `shared/primitives`=1 | The component theme is a superset (1,439 vs 1,037 chars); 2 components vs 1. |
| `Hover` | class | 2 | **differs** | `components/hover` | dedupe | `hover`=2; `shared/primitives`=1 | Tie at 1 component each; `control/hover` is the registry component with a preview/README/meta.json, so it owns Hover and HoverActivity (bodies differ by one line). |
| `HoverActivity` | class | 2 | **differs** | `components/hover` | dedupe | `hover`=2; `shared/primitives`=1 | Tie at 1 component each; the control/hover copy is the registry component copy, so it keeps the name. |
| `HoverTheme` | class | 2 | same | `components/hover` | dedupe | `hover`=5; `shared/primitives`=1 | Byte-identical; only the control/hover copy has an external importer, so the component owns it. |
| `InputAboveBelowFeature` | class | 2 | same | `components/input` | dedupe | `input`=1; `text_field`=22 | PLAN 5 R0: `input` owns the feature system. All 12 feature classes are byte-identical except the `part of` line; neither side is imported from outside its own library, so the shadcn name wins and text_field becomes the alias. |
| `InputAutoCompleteFeature` | class | 2 | same | `components/input` | dedupe | `input`=1; `text_field`=22 | PLAN 5 R0: `input` owns the feature system. All 12 feature classes are byte-identical except the `part of` line; neither side is imported from outside its own library, so the shadcn name wins and text_field becomes the alias. |
| `InputClearFeature` | class | 2 | same | `components/input` | dedupe | `input`=1; `text_field`=22 | PLAN 5 R0: `input` owns the feature system. All 12 feature classes are byte-identical except the `part of` line; neither side is imported from outside its own library, so the shadcn name wins and text_field becomes the alias. |
| `InputCopyFeature` | class | 2 | same | `components/input` | dedupe | `input`=1; `text_field`=22 | PLAN 5 R0: `input` owns the feature system. All 12 feature classes are byte-identical except the `part of` line; neither side is imported from outside its own library, so the shadcn name wins and text_field becomes the alias. |
| `InputFeaturePosition` | enum | 2 | same | `components/input` | dedupe | `input`=1; `text_field`=22 | PLAN 5 R0: `input` owns the feature system. All 12 feature classes are byte-identical except the `part of` line; neither side is imported from outside its own library, so the shadcn name wins and text_field becomes the alias. |
| `InputHintFeature` | class | 2 | same | `components/input` | dedupe | `input`=1; `text_field`=22 | PLAN 5 R0: `input` owns the feature system. All 12 feature classes are byte-identical except the `part of` line; neither side is imported from outside its own library, so the shadcn name wins and text_field becomes the alias. |
| `InputLeadingFeature` | class | 2 | same | `components/input` | dedupe | `input`=1; `text_field`=22 | PLAN 5 R0: `input` owns the feature system. All 12 feature classes are byte-identical except the `part of` line; neither side is imported from outside its own library, so the shadcn name wins and text_field becomes the alias. |
| `InputPasswordToggleFeature` | class | 2 | same | `components/input` | dedupe | `input`=1; `text_field`=22 | PLAN 5 R0: `input` owns the feature system. All 12 feature classes are byte-identical except the `part of` line; neither side is imported from outside its own library, so the shadcn name wins and text_field becomes the alias. |
| `InputPasteFeature` | class | 2 | same | `components/input` | dedupe | `input`=1; `text_field`=22 | PLAN 5 R0: `input` owns the feature system. All 12 feature classes are byte-identical except the `part of` line; neither side is imported from outside its own library, so the shadcn name wins and text_field becomes the alias. |
| `InputRevalidateFeature` | class | 2 | same | `components/input` | dedupe | `input`=1; `text_field`=22 | PLAN 5 R0: `input` owns the feature system. All 12 feature classes are byte-identical except the `part of` line; neither side is imported from outside its own library, so the shadcn name wins and text_field becomes the alias. |
| `InputShowHintIntent` | class | 2 | same | `components/input` | dedupe | `input`=1; `text_field`=22 | PLAN 5 R0: `input` owns the feature system. All 12 feature classes are byte-identical except the `part of` line; neither side is imported from outside its own library, so the shadcn name wins and text_field becomes the alias. |
| `InputSpinnerFeature` | class | 2 | **differs** | `components/input` | dedupe | `input`=1; `text_field`=22 | PLAN 5 R0: `input` owns the feature system. All 12 feature classes are byte-identical except the `part of` line; neither side is imported from outside its own library, so the shadcn name wins and text_field becomes the alias. |
| `InputStepperButtonFeature` | class | 2 | same | `components/input` | dedupe | `input`=1; `text_field`=22 | PLAN 5 R0: `input` owns the feature system. All 12 feature classes are byte-identical except the `part of` line; neither side is imported from outside its own library, so the shadcn name wins and text_field becomes the alias. |
| `InputTrailingFeature` | class | 2 | same | `components/input` | dedupe | `input`=1; `text_field`=22 | PLAN 5 R0: `input` owns the feature system. All 12 feature classes are byte-identical except the `part of` line; neither side is imported from outside its own library, so the shadcn name wins and text_field becomes the alias. |
| `KeyboardShortcutDisplayBuilder` | typedef | 2 | **differs** | `primitives/keyboard` | dedupe | `keyboard_shortcut`=2; `shared/utils`=2 | 2 libs / 2 components (keyboard_shortcut, menu) vs 2/1. |
| `KeyboardShortcutDisplayHandle` | typedef | 2 | **differs** | `primitives/keyboard` | dedupe | `keyboard_shortcut`=2; `shared/utils`=2 | 2/2 shared vs 2/1 component. |
| `KeyedTabChild` | mixin | 2 | same | `components/tabs` | dedupe | `tab_container`=5; `tabs`=4 | PLAN 5 R0: one owner for the tab types. tabs (28 files, 2.4k LOC) already declares all 21 names; tab_container/tab_pane/tab_list import nothing from each other in Dart and hold no reachable public API. |
| `KeyedTabChildWidget` | class | 2 | same | `components/tabs` | dedupe | `tab_container`=5; `tabs`=4 | PLAN 5 R0: one owner for the tab types. tabs (28 files, 2.4k LOC) already declares all 21 names; tab_container/tab_pane/tab_list import nothing from each other in Dart and hold no reachable public API. |
| `KeyedTabItem` | class | 2 | same | `components/tabs` | dedupe | `tab_container`=5; `tabs`=4 | PLAN 5 R0: one owner for the tab types. tabs (28 files, 2.4k LOC) already declares all 21 names; tab_container/tab_pane/tab_list import nothing from each other in Dart and hold no reachable public API. |
| `Label` | class | 2 | **differs** | `components/basic` | dedupe | `basic`=5; `shared/primitives`=3 | Doc-comment drift only; 5/5 component vs 3/3 shared. |
| `MenuGroupData` | class | 2 | **differs** | `components/menu` | dedupe | `menu`=10; `shared/primitives`=2 | 10 libs / 6 components (menu, menubar, context_menu, dropdown_menu, select, spell_check_suggestions_toolbar) vs 2/2 shared. |
| `MenuPopup` | class | 2 | **differs** | `components/menu` | dedupe | `menu`=10; `popup`=2 | `overlay/popup` and `overlay/menu` each declare it; menu is the shadcn-named component that owns the menu family, popup re-exports. |
| `MenuPopupTheme` | class | 2 | same | `components/menu` | dedupe | `menu`=10; `popup`=2 | Byte-identical; menu owns it, popup re-exports. |
| `MenuPopupThemeDefaults` | class | 2 | same | `components/menu` | dedupe | `menu`=1; `popup`=1 | Byte-identical; menu owns it. |
| `MenuPopupThemeTokens` | class | 2 | same | `components/menu` | dedupe | `menu`=1; `popup`=1 | Byte-identical; menu owns it. |
| `Menubar` | class | 2 | **differs** | `components/menubar` | dedupe | `menu`=10; `menubar`=2 | `overlay/menubar` and `overlay/menu` each declare it; the standalone `menubar` component owns it. |
| `MenubarState` | class | 2 | **differs** | `components/menubar` | dedupe | `menu`=10; `menubar`=2 | Private fork with real drift (1,614 vs 1,598 chars); menubar owns it. |
| `MenubarTheme` | class | 2 | same | `components/menubar` | dedupe | `menu`=10; `menubar`=2 | Byte-identical; menubar owns it. |
| `MenubarThemeDefaults` | class | 2 | same | `components/menu` | dedupe | `menu`=1; `menubar`=1 | 2 external component importer(s) across the group; menu is the owner. |
| `MenubarThemeTokens` | class | 2 | same | `components/menu` | dedupe | `menu`=1; `menubar`=1 | 2 external component importer(s) across the group; menu is the owner. |
| `NavigateSuggestionIntent` | class | 2 | same | `components/autocomplete` | dedupe | `autocomplete`=3; `text_field`=22 | PLAN 5 R0: `autocomplete` owns AutoComplete. The autocomplete copies are the reachable ones (imported by autocomplete + chip_input); the text_field copies have no external importer. |
| `NeverWidgetBuilder` | typedef | 2 | same | `shared/utils` | dedupe | `shared/utils`=39; `shared/utils`=0 | typedef declared twice inside shared/utils, no external importer. Keep one copy. |
| `OutlinedContainer` | class | 2 | **differs** | `components/outlined_container` | dedupe | `outlined_container`=11; `shared/primitives`=14 | PLAN 5 R2 override. Measured reach slightly favours shared (14 libs / 12 comps vs 11/10), but OutlinedContainer is part of the `outlined_container` component public API, and R2 says such names stay with their owner component. The shared copy becomes the component implementation. |
| `OutlinedContainerTheme` | class | 2 | **differs** | `components/outlined_container` | dedupe | `outlined_container`=11; `shared/primitives`=14 | PLAN 5 R2 override, same reason. The component theme is also a superset (2,238 vs 601 chars). |
| `PasswordPeekMode` | enum | 2 | same | `components/input` | dedupe | `input`=1; `text_field`=22 | PLAN 5 R0: `input` owns the feature system. All 12 feature classes are byte-identical except the `part of` line; neither side is imported from outside its own library, so the shadcn name wins and text_field becomes the alias. |
| `PhoneNumber` | class | 2 | **differs** | `components/phone_input` | dedupe | `phone_input`=2; `shared/primitives`=1 | Tie at 1 component each; the phone_input copy is a superset (694 vs 494 chars) and lives in the component that exposes it. |
| `RenderScrollableClientViewport` | class | 2 | **differs** | `components/scrollable_client` | dedupe | `scrollable`=2; `scrollable_client`=2 | Private fork with real drift (1,771 vs 1,734 chars); scrollable_client owns it. |
| `RepeatedAnimationBuilder` | typedef | 2 | **differs** | `primitives/animation` | dedupe | `repeated_animation_builder`=0; `shared/utils`=39 | The component file is a 65-char re-export stub with 0 importers; the 474-char implementation sits in shared/utils whose library has 39 libs / 33 components. |
| `ReplaceResult` | class | 2 | same | `primitives/form_core` | dedupe | `form`=5; `shared/primitives`=21 | PLAN 5 R0: form state lives once in primitives/form_core. Measured: the shared/primitives copies have 21 libs / 15 components vs 5 libs / 4 components for the form copies. |
| `RowExtension` | extension | 2 | same | `shared/utils` | dedupe | `shared/utils`=39; `shared/utils`=0 | Declared twice inside shared/utils itself; no external importer. Collapse to one copy. |
| `ScrollableBuilder` | typedef | 2 | same | `components/scrollable_client` | dedupe | `scrollable`=2; `scrollable_client`=2 | Byte-identical typedef; scrollable_client owns it. |
| `ScrollableClient` | class | 2 | **differs** | `components/scrollable_client` | dedupe | `scrollable`=2; `scrollable_client`=2 | `layout/scrollable` and `layout/scrollable_client` both fork it; scrollable_client is imported by `table`, so it wins. |
| `ScrollableClientTheme` | class | 2 | same | `components/scrollable_client` | dedupe | `scrollable`=2; `scrollable_client`=2 | Byte-identical; only the scrollable_client copy has an external importer. |
| `ScrollableClientViewport` | class | 2 | same | `components/scrollable_client` | dedupe | `scrollable`=2; `scrollable_client`=2 | Byte-identical; scrollable_client owns it. |
| `SeparatedFlex` | class | 2 | **differs** | `shared/utils` | dedupe | `shared/utils`=39; `shared/utils`=0 | Both copies live in shared/ - keep one, in the lower layer. |
| `ShadcnLocalizations` | class | 2 | **differs** | `primitives/localizations` | dedupe | `shadcn_localizations`=42; `shared/localizations`=18 | 18 libs / 15 components vs 42 libs / 4 components - the shared/localizations copy is the one 15 components actually use. |
| `SheetOverlayHandler` | class | 2 | **differs** | `components/drawer` | dedupe | `drawer`=14; `shared/primitives`=3 | 14 libs / 9 components vs 3/3 shared (card, context_menu, popup). |
| `SortablePreview` | class | 2 | **differs** | `components/sortable` | dedupe | `sortable`=0; `sortable`=0 | Two component directories share the id `sortable`; only one preview survives. |
| `StatedWidget` | class | 2 | **differs** | `primitives/clickable` | dedupe | `clickable`=4; `shared/primitives`=17 | Byte-level fork; 17/9 shared vs 4/1 component. |
| `SubFocus` | class | 2 | same | `primitives/subfocus` | dedupe | `subfocus`=1; `shared/primitives`=4 | 4 libs / 3 components (command, menu, select) vs 1/1. |
| `SubFocusBuilder` | typedef | 2 | same | `primitives/subfocus` | dedupe | `subfocus`=1; `shared/primitives`=4 | Byte-identical; 4/3 shared vs 1/1 component. |
| `SubFocusScope` | class | 2 | same | `primitives/subfocus` | dedupe | `subfocus`=1; `shared/primitives`=4 | Byte-identical; 4/3 shared vs 1/1 component. |
| `SubFocusScopeBuilder` | typedef | 2 | same | `primitives/subfocus` | dedupe | `subfocus`=1; `shared/primitives`=4 | Byte-identical; 4/3 shared vs 1/1 component. |
| `SubFocusScopeState` | mixin | 2 | same | `primitives/subfocus` | dedupe | `subfocus`=1; `shared/primitives`=4 | Byte-identical; 4/3 shared vs 1/1 component. |
| `SubFocusState` | mixin | 2 | same | `primitives/subfocus` | dedupe | `subfocus`=1; `shared/primitives`=4 | Byte-identical; 4/3 shared vs 1/1 component. |
| `SuggestionBuilder` | typedef | 2 | same | `components/input` | dedupe | `input`=1; `text_field`=22 | PLAN 5 R0: `input` owns the feature system. All 12 feature classes are byte-identical except the `part of` line; neither side is imported from outside its own library, so the shadcn name wins and text_field becomes the alias. |
| `SurfaceBlur` | class | 2 | **differs** | `components/outlined_container` | dedupe | `outlined_container`=11; `shared/primitives`=14 | Re-exported from `components/layout/outlined_container/outlined_container.dart`, which 10 components import; the shared/primitives copy has no external importer of its own. |
| `TabBuilder` | typedef | 2 | same | `components/tabs` | dedupe | `tab_container`=5; `tabs`=4 | PLAN 5 R0: one owner for the tab types. tabs (28 files, 2.4k LOC) already declares all 21 names; tab_container/tab_pane/tab_list import nothing from each other in Dart and hold no reachable public API. |
| `TabChild` | mixin | 2 | same | `components/tabs` | dedupe | `tab_container`=5; `tabs`=4 | PLAN 5 R0: one owner for the tab types. tabs (28 files, 2.4k LOC) already declares all 21 names; tab_container/tab_pane/tab_list import nothing from each other in Dart and hold no reachable public API. |
| `TabChildBuilder` | typedef | 2 | same | `components/tabs` | dedupe | `tab_container`=5; `tabs`=4 | PLAN 5 R0: one owner for the tab types. tabs (28 files, 2.4k LOC) already declares all 21 names; tab_container/tab_pane/tab_list import nothing from each other in Dart and hold no reachable public API. |
| `TabChildWidget` | class | 2 | same | `components/tabs` | dedupe | `tab_container`=5; `tabs`=4 | PLAN 5 R0: one owner for the tab types. tabs (28 files, 2.4k LOC) already declares all 21 names; tab_container/tab_pane/tab_list import nothing from each other in Dart and hold no reachable public API. |
| `TabContainer` | class | 2 | same | `components/tabs` | dedupe | `tab_container`=5; `tabs`=4 | PLAN 5 R0: one owner for the tab types. tabs (28 files, 2.4k LOC) already declares all 21 names; tab_container/tab_pane/tab_list import nothing from each other in Dart and hold no reachable public API. |
| `TabContainerData` | class | 2 | same | `components/tabs` | dedupe | `tab_container`=5; `tabs`=4 | PLAN 5 R0: one owner for the tab types. tabs (28 files, 2.4k LOC) already declares all 21 names; tab_container/tab_pane/tab_list import nothing from each other in Dart and hold no reachable public API. |
| `TabContainerTheme` | class | 2 | same | `components/tabs` | dedupe | `tab_container`=5; `tabs`=4 | PLAN 5 R0: one owner for the tab types. tabs (28 files, 2.4k LOC) already declares all 21 names; tab_container/tab_pane/tab_list import nothing from each other in Dart and hold no reachable public API. |
| `TabItem` | class | 2 | same | `components/tabs` | dedupe | `tab_container`=5; `tabs`=4 | PLAN 5 R0: one owner for the tab types. tabs (28 files, 2.4k LOC) already declares all 21 names; tab_container/tab_pane/tab_list import nothing from each other in Dart and hold no reachable public API. |
| `TabList` | class | 2 | same | `components/tabs` | dedupe | `tab_list`=1; `tabs`=4 | PLAN 5 R0: one owner for the tab types. tabs (28 files, 2.4k LOC) already declares all 21 names; tab_container/tab_pane/tab_list import nothing from each other in Dart and hold no reachable public API. |
| `TabListTheme` | class | 2 | same | `components/tabs` | dedupe | `tab_list`=1; `tabs`=4 | PLAN 5 R0: one owner for the tab types. tabs (28 files, 2.4k LOC) already declares all 21 names; tab_container/tab_pane/tab_list import nothing from each other in Dart and hold no reachable public API. |
| `TabPane` | class | 2 | **differs** | `components/tabs` | dedupe | `tab_pane`=1; `tabs`=4 | PLAN 5 R0: one owner for the tab types. tabs (28 files, 2.4k LOC) already declares all 21 names; tab_container/tab_pane/tab_list import nothing from each other in Dart and hold no reachable public API. |
| `TabPaneData` | class | 2 | same | `components/tabs` | dedupe | `tab_pane`=1; `tabs`=4 | PLAN 5 R0: one owner for the tab types. tabs (28 files, 2.4k LOC) already declares all 21 names; tab_container/tab_pane/tab_list import nothing from each other in Dart and hold no reachable public API. |
| `TabPaneItemBuilder` | typedef | 2 | same | `components/tabs` | dedupe | `tab_pane`=1; `tabs`=4 | PLAN 5 R0: one owner for the tab types. tabs (28 files, 2.4k LOC) already declares all 21 names; tab_container/tab_pane/tab_list import nothing from each other in Dart and hold no reachable public API. |
| `TabPaneState` | class | 2 | **differs** | `components/tabs` | dedupe | `tab_pane`=1; `tabs`=4 | PLAN 5 R0: one owner for the tab types. tabs (28 files, 2.4k LOC) already declares all 21 names; tab_container/tab_pane/tab_list import nothing from each other in Dart and hold no reachable public API. |
| `TabPaneTheme` | class | 2 | same | `components/tabs` | dedupe | `tab_pane`=1; `tabs`=4 | PLAN 5 R0: one owner for the tab types. tabs (28 files, 2.4k LOC) already declares all 21 names; tab_container/tab_pane/tab_list import nothing from each other in Dart and hold no reachable public API. |
| `TextExtension` | extension | 2 | **differs** | `primitives/text` | dedupe | `text`=11; `shared/primitives`=25 | Same measurement as TextModifier: 25/19 shared vs 11/11 component. |
| `TextFieldClearIntent` | class | 2 | same | `components/text_field (-> input)` | dedupe | `text_field`=22; `shared/utils`=2 | 22 libs / 17 components vs 2/2 shared; it is part of the input intent system. |
| `TextModifier` | class | 2 | **differs** | `primitives/text` | dedupe | `text`=11; `shared/primitives`=25 | Text modifiers are PLAN 4 L2 `primitives/text`. The shared copy has 25 libs / 19 components vs 11/11 for the display/text fork, and display/text declares no `Text` widget at all - only modifiers. Its meta.json already says `"tier": "primitive"`. |
| `UnorderedListData` | class | 2 | same | `primitives/text` | dedupe | `text`=11; `shared/primitives`=25 | Byte-identical fork; 25/19 shared vs 11/11 component. |
| `ValidationResult` | class | 2 | same | `primitives/form_core` | dedupe | `form`=5; `shared/primitives`=21 | PLAN 5 R0: form state lives once in primitives/form_core. Measured: the shared/primitives copies have 21 libs / 15 components vs 5 libs / 4 components for the form copies. |
| `WidgetStateExtension` | extension | 2 | same | `primitives/clickable` | dedupe | `clickable`=1; `shared/primitives`=17 | Byte-identical; 17/9 shared vs 1/1 component. |
| `WidgetStatesData` | class | 2 | same | `primitives/clickable` | dedupe | `clickable`=6; `shared/primitives`=17 | Byte-identical; 17/9 shared vs 6/1 component. |
| `WidgetStatesProvider` | class | 2 | same | `primitives/clickable` | dedupe | `clickable`=2; `shared/primitives`=17 | Byte-identical; 17/9 shared vs 2/1 component. |
| `WidgetTextWrapper` | typedef | 2 | same | `primitives/text` | dedupe | `text`=11; `shared/primitives`=25 | Byte-identical fork; 25/19 shared vs 11/11 component. |
| `WrappedText` | class | 2 | **differs** | `primitives/text` | dedupe | `text`=11; `shared/primitives`=25 | Same measurement: 25/19 shared vs 11/11 component; bodies differ only in doc comments. |
| `WrappedTextDataBuilder` | typedef | 2 | same | `primitives/text` | dedupe | `text`=11; `shared/primitives`=25 | Byte-identical fork; 25/19 shared vs 11/11 component. |
| `_AutoCompleteFeatureState` | class | 2 | same | `components/input` | dedupe | `input`=1; `text_field`=22 | PLAN 5 R0: `input` owns the feature system. All 12 feature classes are byte-identical except the `part of` line; neither side is imported from outside its own library, so the shadcn name wins and text_field becomes the alias. |
| `_AutoCompleteItem` | class | 2 | same | `components/autocomplete` | dedupe | `autocomplete`=3; `text_field`=22 | PLAN 5 R0: `autocomplete` owns AutoComplete. The autocomplete copies are the reachable ones (imported by autocomplete + chip_input); the text_field copies have no external importer. |
| `_AutoCompleteItemState` | class | 2 | same | `components/autocomplete` | dedupe | `autocomplete`=3; `text_field`=22 | PLAN 5 R0: `autocomplete` owns AutoComplete. The autocomplete copies are the reachable ones (imported by autocomplete + chip_input); the text_field copies have no external importer. |
| `_AutoCompleteState` | class | 2 | **differs** | `components/autocomplete` | dedupe | `autocomplete`=3; `text_field`=22 | PLAN 5 R0: `autocomplete` owns AutoComplete. The autocomplete copies are the reachable ones (imported by autocomplete + chip_input); the text_field copies have no external importer. |
| `_ClipRectWithAdjustment` | class | 2 | same | `components/tabs` | dedupe | `tab_pane`=1; `tabs`=4 | PLAN 5 R0: one owner for the tab types. tabs (28 files, 2.4k LOC) already declares all 21 names; tab_container/tab_pane/tab_list import nothing from each other in Dart and hold no reachable public API. |
| `_ControlledComponentAdapterState` | class | 2 | same | `primitives/form_core` | dedupe | `control`=1; `shared/primitives`=20 | PLAN 5 R0 + R3: the ControlledComponent family is already in shared/primitives/form_control.dart with 20 libs / 13 components; the form/control copies have 1 lib / 1 component. |
| `_FadeScrollPreviewState` | class | 2 | **differs** | `components/fade_scroll` | dedupe | `fade_scroll`=0; `fade_scroll`=0 | Two preview states; collapse to one after the dir merge. |
| `_FormEntryCachedValue` | class | 2 | same | `primitives/form_core` | dedupe | `form`=5; `shared/primitives`=21 | PLAN 5 R0: form state lives once in primitives/form_core. Measured: the shared/primitives copies have 21 libs / 15 components vs 5 libs / 4 components for the form copies. |
| `_HSLColorSliderState` | class | 2 | same | `components/hsl` | dedupe | `color_picker`=1; `hsl`=1 | Byte-identical; hsl owns it. |
| `_HSVColorSliderState` | class | 2 | same | `components/hsv` | dedupe | `color_picker`=1; `hsv`=1 | Byte-identical; hsv owns it. |
| `_HiddenLayout` | class | 2 | **differs** | `components/hidden` | dedupe | `hidden`=3; `shared/primitives`=1 | Private fork (1,534 vs 975 chars); 2 components vs 1. |
| `_InputAboveBelowFeatureState` | class | 2 | same | `components/input` | dedupe | `input`=1; `text_field`=22 | PLAN 5 R0: `input` owns the feature system. All 12 feature classes are byte-identical except the `part of` line; neither side is imported from outside its own library, so the shadcn name wins and text_field becomes the alias. |
| `_InputClearFeatureState` | class | 2 | same | `components/input` | dedupe | `input`=1; `text_field`=22 | PLAN 5 R0: `input` owns the feature system. All 12 feature classes are byte-identical except the `part of` line; neither side is imported from outside its own library, so the shadcn name wins and text_field becomes the alias. |
| `_InputCopyFeatureState` | class | 2 | same | `components/input` | dedupe | `input`=1; `text_field`=22 | PLAN 5 R0: `input` owns the feature system. All 12 feature classes are byte-identical except the `part of` line; neither side is imported from outside its own library, so the shadcn name wins and text_field becomes the alias. |
| `_InputHintFeatureState` | class | 2 | same | `components/input` | dedupe | `input`=1; `text_field`=22 | PLAN 5 R0: `input` owns the feature system. All 12 feature classes are byte-identical except the `part of` line; neither side is imported from outside its own library, so the shadcn name wins and text_field becomes the alias. |
| `_InputLeadingFeatureState` | class | 2 | same | `components/input` | dedupe | `input`=1; `text_field`=22 | PLAN 5 R0: `input` owns the feature system. All 12 feature classes are byte-identical except the `part of` line; neither side is imported from outside its own library, so the shadcn name wins and text_field becomes the alias. |
| `_InputPasswordToggleFeatureState` | class | 2 | same | `components/input` | dedupe | `input`=1; `text_field`=22 | PLAN 5 R0: `input` owns the feature system. All 12 feature classes are byte-identical except the `part of` line; neither side is imported from outside its own library, so the shadcn name wins and text_field becomes the alias. |
| `_InputPasteFeatureState` | class | 2 | same | `components/input` | dedupe | `input`=1; `text_field`=22 | PLAN 5 R0: `input` owns the feature system. All 12 feature classes are byte-identical except the `part of` line; neither side is imported from outside its own library, so the shadcn name wins and text_field becomes the alias. |
| `_InputRevalidateFeatureState` | class | 2 | same | `components/input` | dedupe | `input`=1; `text_field`=22 | PLAN 5 R0: `input` owns the feature system. All 12 feature classes are byte-identical except the `part of` line; neither side is imported from outside its own library, so the shadcn name wins and text_field becomes the alias. |
| `_InputSpinnerFeatureState` | class | 2 | **differs** | `components/input` | dedupe | `input`=1; `text_field`=22 | PLAN 5 R0: `input` owns the feature system. All 12 feature classes are byte-identical except the `part of` line; neither side is imported from outside its own library, so the shadcn name wins and text_field becomes the alias. |
| `_InputStepperButtonFeatureState` | class | 2 | same | `components/input` | dedupe | `input`=1; `text_field`=22 | PLAN 5 R0: `input` owns the feature system. All 12 feature classes are byte-identical except the `part of` line; neither side is imported from outside its own library, so the shadcn name wins and text_field becomes the alias. |
| `_InputTrailingFeatureState` | class | 2 | same | `components/input` | dedupe | `input`=1; `text_field`=22 | PLAN 5 R0: `input` owns the feature system. All 12 feature classes are byte-identical except the `part of` line; neither side is imported from outside its own library, so the shadcn name wins and text_field becomes the alias. |
| `_OutlinedContainerState` | class | 2 | **differs** | `components/outlined_container` | dedupe | `outlined_container`=11; `shared/primitives`=14 | PLAN 5 R2 override; follows the widget it belongs to (2,615 vs 2,499 chars). |
| `_RichTextThenWidget` | class | 2 | **differs** | `primitives/text` | dedupe | `text`=11; `shared/primitives`=25 | Private fork; 25/19 shared vs 11/11 component. |
| `_ScaleGradient` | class | 3 | same | `components/fade_scroll` | dedupe | `fade_scroll`=1; `fade_scroll`=1; `shared/primitives`=2 | 3 identical private copies; keep the layout/fade_scroll one. |
| `_ScrollableClientChildVicinity` | class | 2 | same | `components/scrollable_client` | dedupe | `scrollable`=2; `scrollable_client`=2 | Byte-identical private fork; scrollable_client owns it. |
| `_SelectableTextThenWidget` | class | 2 | **differs** | `primitives/text` | dedupe | `text`=11; `shared/primitives`=25 | Private fork (1,430 vs 847 chars); 25/19 shared vs 11/11 component. |
| `_SeparatedFlexState` | class | 2 | **differs** | `shared/utils` | dedupe | `shared/utils`=39; `shared/utils`=0 | Both copies live in shared/ - keep one, in the lower layer. |
| `_ShadcnLocalizationsDelegate` | class | 2 | **differs** | `primitives/localizations` | dedupe | `shadcn_localizations`=42; `shared/localizations`=18 | Follows ShadcnLocalizations; 15 components use the shared/localizations delegate. |
| `_SubFocusScopeState` | class | 2 | same | `primitives/subfocus` | dedupe | `subfocus`=1; `shared/primitives`=4 | Byte-identical private fork; 4/3 shared vs 1/1 component. |
| `_SubFocusState` | class | 2 | same | `primitives/subfocus` | dedupe | `subfocus`=1; `shared/primitives`=4 | Byte-identical private fork; 4/3 shared vs 1/1 component. |
| `_TabGhostData` | class | 2 | same | `components/tabs` | dedupe | `tab_pane`=1; `tabs`=4 | PLAN 5 R0: one owner for the tab types. tabs (28 files, 2.4k LOC) already declares all 21 names; tab_container/tab_pane/tab_list import nothing from each other in Dart and hold no reachable public API. |
| `_TabItemPainter` | class | 2 | same | `components/tabs` | dedupe | `tab_pane`=1; `tabs`=4 | PLAN 5 R0: one owner for the tab types. tabs (28 files, 2.4k LOC) already declares all 21 names; tab_container/tab_pane/tab_list import nothing from each other in Dart and hold no reachable public API. |
| `_TextThenWidget` | class | 2 | **differs** | `primitives/text` | dedupe | `text`=11; `shared/primitives`=25 | Private fork (1,909 vs 699 chars); 25/19 shared vs 11/11 component. |
| `_TimeFormatter` | class | 2 | **differs** | `components/formatter` | dedupe | `formatter`=2; `time_picker`=2 | `formatter` and `time_picker` each declare it with different bodies (1,112 vs 930 chars); the standalone `formatter` component owns it and time_picker imports it. |

## 2. Component merge decisions

### input ← input + text_field

**Decision.** Keep the shadcn name `input`. `components/form/input/_impl` is a strict SUBSET of `components/form/text_field/_impl` - `comm` reports **0 files unique to input** and 46 unique to text_field. The 12 feature classes are byte-identical except the `part of` line; text_field additionally carries `min`/`max` clamping on the spinner. So the merge runs **text_field -> input**: move the text_field-only files (visibility helpers, autocomplete, intents, text_input_mixin, text_field_widget, theme config) into input, then delete text_field and leave a one-line `export` alias.

**Why.** shadcn calls it `input`; text_field re-declares all 12 feature classes plus the whole AutoComplete system that autocomplete owns.

**Removed.** `components/form/text_field/** (74 files, 6,038 LOC)`

**Files after migration**

```
  input/input.dart
  input/input_style.dart
  input/input_theme.dart
  input/preview.dart
  input/meta.json
  input/README.md
  input/_impl/features/{input_feature_base,input_feature_state,input_feature_visibility}.dart
  input/_impl/features/{input_above_below,input_auto_complete,input_clear,input_copy,input_hint,input_leading,input_password_toggle,input_paste,input_revalidate,input_spinner,input_stepper_button,input_trailing}_feature.dart
  input/_impl/intents/*.dart
```

### autocomplete ← autocomplete

**Decision.** autocomplete owns AutoComplete, AutoCompleteMode, AutoCompleteTheme, AutoCompleteCompleter, AutoCompleteIntent, AcceptSuggestionIntent, NavigateSuggestionIntent and the private AutoComplete state classes. input imports it.

**Why.** PLAN 5 R0. Measured: the autocomplete copies are the reachable ones (autocomplete + chip_import); every text_field copy has 0 external importers.

**Removed.** `components/form/text_field/_impl/core/auto_complete*.dart`; `components/form/text_field/_impl/utils/{auto_complete_intent,accept_suggestion_intent,navigate_suggestion_intent}.dart`; `components/form/text_field/_impl/state/_auto_complete_item_state.dart`; `components/form/text_field/_impl/state/_auto_complete_state.dart`; `components/form/text_field/_impl/core/_auto_complete_item.dart`

**Files after migration**

```
  autocomplete/autocomplete.dart
  autocomplete/autocomplete_style.dart
  autocomplete/autocomplete_theme.dart
  autocomplete/preview.dart
  autocomplete/meta.json
  autocomplete/README.md
```

### form (+ primitives/form_core) ← form + form_field + shared form state

**Decision.** form owns the Form UI (Form, FormField, FormInline, FormTableLayout, validators). primitives/form_core owns FormKey, ValidationResult, FormValueSupplier, FormFieldHandle, ReplaceResult, FormValidationMode, FormPendingBuilder/FormPendingWidgetBuilder and the whole ControlledComponent family. form_field (11 files) folds into form.

**Why.** PLAN 5 R0. Measured: the shared/primitives copies have 21 libs / 15 comps (form_value_supplier) and 20 libs / 13 comps (form_control); every form and control copy has 1-5 libs. Note FormKey bodies differ - the form copy adds `getValue(FormMapValues)` and `operator []`, so the superset body wins and `FormMapValues` moves with it.

**Removed.** `components/form/form/_impl/core/{form_key,validation_result,replace_result,_form_entry_cached_value,form_value_supplier,form_field_handle,form_validation_mode}.dart`; `components/form/form/_impl/utils/form_pending_builder.dart`; `shared/utils/_impl/core/context_callback_action.dart (the FormPendingWidgetBuilder typedef)`; `components/form/control/_impl/** (ComponentController / ControlledComponent* family)`; `components/form/form_field/** (11 files) - absorbed into form`

**Files after migration**

```
  form/form.dart
  form/form_style.dart
  form/form_theme.dart
  form/preview.dart
  form/meta.json
  form/README.md
  primitives/form_core/form_key.dart
  primitives/form_core/validation_result.dart
  primitives/form_core/value_supplier.dart
  primitives/form_core/field_handle.dart
  primitives/form_core/component_controller.dart
  primitives/form_core/form_pending_builder.dart
```

### tabs ← tabs + tab_container + tab_pane + tab_list

**Decision.** tabs (28 files, 2,452 LOC) is the only member with real content and already declares all 21 shared names. tab_container and tab_pane become one-line aliases; tab_list is deleted outright because it has **no entrypoint .dart file at all** - the directory contains only `_impl/**`, `preview.dart` and JSON, so it cannot be installed today.

**Why.** 21 duplicated names, 20 of them byte-identical. tabs references tab_pane/tab_list only in `meta.json`, never in Dart - the dependency is phantom.

**Removed.** `components/navigation/tab_container/** (9 files, 473 LOC)`; `components/navigation/tab_pane/** (9 files, 717 LOC)`; `components/navigation/tab_list/** (5 files, 329 LOC)`

**Files after migration**

```
  tabs/tabs.dart
  tabs/tabs_style.dart
  tabs/tabs_theme.dart
  tabs/preview.dart
  tabs/meta.json
  tabs/README.md
```

### button, toggle, button_group ← button family (variants + toggle + group + selected/tab/card button)

**Decision.** `button` owns Button + ButtonStyle + a `ButtonVariant` enum (primary/secondary/outline/ghost/link/text/destructive) + one exhaustive switch. `toggle` becomes its own component (a stateful on/off control, not a button style) and absorbs SelectedButton, which 3 components use. `button_group` stays a sub-widget of button (only color_picker uses it). TabButton moves into `tabs` (2 users, 100% tabs-specific). CardButton is deleted.

**Why.** PLAN 4 rule 1 - variants are data, never a class per variant. Measured: after name-normalising, `diff` between any two of the 7 wrappers shows **only doc-comment differences**; the entire behavioural difference is the single `style: ButtonStyle.X(...)` line.

**Removed.** `button/_impl/variants/{primary,secondary,outline,ghost,link,text,destructive}_button.dart (7 files x ~174 LOC)`; `button/_impl/themes/variants/{primary,secondary,outline,ghost,link,text,destructive,card,fixed,menu,menubar,muted}_button_theme.dart (12 files)`; `button/_impl/styles/button_variance_class.dart (270 LOC)`; `button/_impl/variants/selected_button.dart + selected_button_widget.dart (fold into toggle)`; `button/_impl/variants/tab_button.dart (move into tabs)`; `button/_impl/variants/card_button.dart (241 LOC, no importer)`

**Files after migration**

```
  button/button.dart
  button/button_style.dart
  button/button_theme.dart
  button/button_group.dart
  button/preview.dart
  button/meta.json
  button/README.md
  toggle/toggle.dart
  toggle/toggle_style.dart
  toggle/toggle_theme.dart
  toggle/toggle_controller.dart
  toggle/preview.dart
  toggle/meta.json
  toggle/README.md
```

### fade_scroll ← fade_scroll (display) + fade_scroll (layout) + shared/primitives/fade_scroll

**Decision.** Keep components/layout/fade_scroll. Delete components/display/fade_scroll and all 3 shared/primitives copies. tabs and tab_pane (the only external users of the shared copy) declare `components: [fade_scroll]`.

**Why.** Two component directories share the id `fade_scroll` and there are 3 different FadeScroll bodies. PLAN 5 forbids duplicate component ids.

**Removed.** `components/display/fade_scroll/** (duplicate component id)`; `shared/primitives/fade_scroll.dart`; `shared/primitives/_impl/core/fade_scroll.dart`; `shared/primitives/_impl/themes/fade_scroll_theme.dart`; `shared/primitives/_impl/core/__scale_gradient.dart`

**Files after migration**

```
  fade_scroll/fade_scroll.dart
  fade_scroll/fade_scroll_style.dart
  fade_scroll/fade_scroll_theme.dart
  fade_scroll/preview.dart
  fade_scroll/meta.json
  fade_scroll/README.md
```

### sortable ← sortable (form) + sortable (layout)

**Decision.** Two directories share the id `sortable` with different previews (267 vs 510 chars) and different `meta.json`. **UNVERIFIED which one the CLI actually installs** - the orchestrator must check before the merge. Delete one, keep one.

**Why.** PLAN 5 requires unique component ids; two dirs with id `sortable` cannot both be installed.

**Removed.** `one of components/form/sortable/** or components/layout/sortable/**`

**Files after migration**

```
  sortable/sortable.dart
  sortable/sortable_style.dart
  sortable/sortable_theme.dart
  sortable/preview.dart
  sortable/meta.json
  sortable/README.md
```

### hsl, hsv (standalone); color_picker depends on them ← hsl + hsv + color_picker

**Decision.** hsl and hsv own their slider widgets and slider-type enums; color_picker imports them under a private alias instead of re-declaring.

**Why.** The widget and type classes are byte-identical; only the painters genuinely differ (9,652 vs 2,041 LOC for HSL), so the painters must stay private per component.

**Removed.** `components/form/color_picker/_impl/core/hsl_color_slider.dart (import under a private alias instead)`; `components/form/color_picker/_impl/core/hsv_color_slider.dart (import under a private alias instead)`; `components/form/color_picker/_impl/core/{hsl,hsv}_color_slider_type.dart`

**Files after migration**

```
  hsl/hsl.dart
  hsl/hsl_color_slider.dart
  hsl/hsl_style.dart
  hsv/hsv.dart
  hsv/hsv_color_slider.dart
  hsv/hsv_style.dart
```

### menu (MenuPopup family), menubar (MenubarState) ← menu + popup + menubar

**Decision.** menu owns MenuPopup + MenuPopupTheme/Defaults/Tokens. menubar owns MenubarState (real drift). popup and menu re-export MenuPopup from the single owner.

**Why.** MenuPopup* theme classes are byte-identical; the MenuPopup widgets and Menubar widgets differ only in doc comments.

**Removed.** `components/overlay/popup/_impl/core/menu_popup_widget.dart`; `components/overlay/menu/_impl/core/menu_popup.dart`; `components/overlay/menu/_impl/core/menubar.dart`; `components/overlay/menu/_impl/state/menubar_state.dart`

**Files after migration**

```
  menu/menu.dart
  menu/menu_style.dart
  menu/menu_theme.dart
  popup/popup.dart
  menubar/menubar.dart
  menubar/menubar_style.dart
```

### primitives/text (the display/text component dissolves) ← text + shared/primitives/text

**Decision.** promote shared/primitives/text.dart to `primitives/text` (PLAN 4 already lists `text` as an L2 primitive) and delete the display/text component. Its 11 importers switch to the primitive.

**Why.** Measured 25 libs / 19 comps (shared) vs 11 libs / 11 comps (display/text). display/text declares **no `Text` widget at all** - only modifiers - and its own `meta.json` already says `"tier": "primitive"`.

**Removed.** `components/display/text/text.dart`; `components/display/text/_impl/core/{_text_then,_rich_text_then,_selectable_text_then}_widget.dart`; `components/display/text/_impl/core/{wrapped_text,unordered_list_data}.dart`

**Files after migration**

```
  primitives/text/text.dart
  primitives/text/style.dart
```

### scrollable_client ← scrollable + scrollable_client

**Decision.** scrollable_client owns ScrollableClient, ScrollableBuilder, ScrollableClientTheme, ScrollableClientViewport, RenderScrollableClientViewport and _ScrollableClientChildVicinity. `scrollable` keeps only its own scrollbar/overscroll concern.

**Why.** scrollable_client is the reachable copy (table imports it) and is a superset of the scrollable fork.

**Removed.** `components/layout/scrollable/_impl/core/scrollable_client*.dart`; `components/layout/scrollable/_impl/core/render_scrollable_client_viewport.dart`; `components/layout/scrollable/_impl/core/_scrollable_client_child_vicinity.dart`; `components/layout/scrollable/_impl/themes/base/scrollable_client_theme.dart`

**Files after migration**

```
  scrollable_client/scrollable_client.dart
  scrollable_client/scrollable_client_style.dart
  scrollable_client/scrollable_client_theme.dart
```

### primitives/subfocus ← subfocus (component) + shared/primitives/subfocus

**Decision.** shared/primitives/subfocus.dart keeps the single copy. The subfocus component directory becomes a one-line re-export alias or is removed.

**Why.** Measured 4 libs / 3 comps (command, menu, select) vs 1 lib / 1 comp for the component copy. All 8 SubFocus* names are byte-identical.

**Removed.** `components/navigation/subfocus/_impl/** (all 8 names are byte-identical to shared/primitives)`

**Files after migration**

```
  primitives/subfocus/subfocus.dart
  primitives/subfocus/subfocus_scope.dart
```

### primitives/animation ← repeated_animation_builder

**Decision.** Delete the component directory; the 474-char implementation already lives in shared/utils and belongs to `primitives/animation`.

**Why.** The stub adds nothing and its library has 0 importers, while the shared implementation sits in a library with 39 libs / 33 comps.

**Removed.** `components/utility/repeated_animation_builder/repeated_animation_builder.dart (65-char re-export stub)`

**Files after migration**

```
  primitives/animation/repeated_animation_builder.dart
```

### primitives/localizations ← localizations (shared/localizations vs components/utility/shadcn_localizations)

**Decision.** shared/localizations is the single owner; the shadcn_localizations component directory (42 files, 16.5k LOC) keeps only its locale data (shadcn_localizations_en) and delegates the delegate class.

**Why.** Measured 18 libs / 15 comps use the shared copy vs 42 libs / 4 comps for the component copy - the component copy is mostly its own locale data reaching itself.

**Removed.** `components/utility/shadcn_localizations/_impl/core/shadcn_localizations.dart`; `components/utility/shadcn_localizations/_impl/utils/shadcn_localizations_delegate.dart`

**Files after migration**

```
  primitives/localizations/shadcn_localizations.dart
  primitives/localizations/localizations_extensions.dart
```

## 3. Shared-layer map (every non-theme file under `shared/`)

142 files. By layer: **primitives** 52, **foundation** 39, **primitives/form_core** 10, **primitives/clickable** 9, **primitives/text** 8, **delete** 8, **primitives/subfocus** 5, **primitives/animation** 5, **primitives/localizations** 4, **theme** 2. By action: **keep** 88, **dedupe** 31, **split** 15, **delete** 5, **prune** 3.

`n comp` = number of component libraries importing this file (through its `part of` root).

| File | LOC | n comp | Layer | Action | Rationale |
|---|---|---|---|---|---|
| `shared/primitives/_impl/core/outlined_container.dart` | 72 | 12 | delete | dedupe | part of `shared/primitives/outlined_container.dart`; moves with its library root. |
| `shared/primitives/_impl/core/surface_blur.dart` | 28 | 12 | delete | dedupe | part of `shared/primitives/outlined_container.dart`; moves with its library root. |
| `shared/primitives/_impl/state/__outlined_container_state.dart` | 100 | 12 | delete | dedupe | part of `shared/primitives/outlined_container.dart`; moves with its library root. |
| `shared/primitives/_impl/state/__surface_blur_state.dart` | 29 | 12 | delete | dedupe | part of `shared/primitives/outlined_container.dart`; moves with its library root. |
| `shared/primitives/_impl/themes/outlined_container_theme.dart` | 52 | 12 | delete | dedupe | part of `shared/primitives/outlined_container.dart`; moves with its library root. |
| `shared/primitives/outlined_container.dart` | 19 | 12 | delete | dedupe | PLAN 5 R2 override. Measured reach favours this copy (14 libs / 12 comps vs layout/outlined_container 11/10), but OutlinedContainer is part of the outlined_container component public API, so the component owns the name and this file is deleted - its body is merged INTO the component. |
| `shared/utils/chip_utils.dart` | 19 | 1 | delete | delete | 1 library importer (chip_input). Move into the chip_input component or delete with it. |
| `shared/utils/wrap_utils.dart` | 22 | 1 | delete | delete | 1 library importer. Move into the single consumer. |
| `shared/icons/bootstrap_icons.dart` | 6959 | 0 | foundation | keep | Icon codepoints are pure data. Only 1 library imports it today but it is a documented shared id. |
| `shared/icons/bootstrap_icons_list.dart` | 6424 | 0 | foundation | delete | Lookup table with 0 importers. |
| `shared/icons/lucide_icons.dart` | 6498 | 11 | foundation | keep | Icon codepoints are pure data with no registry dependency. 12 libs / 11 comps. |
| `shared/icons/lucide_icons_list.dart` | 4765 | 0 | foundation | delete | Lookup table with 0 importers; the *_icons.dart barrel already carries the map. |
| `shared/icons/radix_icons.dart` | 1335 | 11 | foundation | keep | Icon codepoints are pure data. 21 libs / 11 comps. |
| `shared/icons/radix_icons_list.dart` | 1021 | 0 | foundation | delete | Lookup table with 0 importers. |
| `shared/utils/_impl/core/__borrow_info.dart` | 15 | 2 | foundation | keep | generic utility; defaults to foundation per PLAN 4. |
| `shared/utils/_impl/core/axis_alignment.dart` | 54 | 3 | foundation | keep | generic utility; defaults to foundation per PLAN 4. |
| `shared/utils/_impl/core/axis_alignment_directional.dart` | 22 | 3 | foundation | keep | generic utility; defaults to foundation per PLAN 4. |
| `shared/utils/_impl/core/axis_alignment_geometry.dart` | 15 | 3 | foundation | keep | generic utility; defaults to foundation per PLAN 4. |
| `shared/utils/_impl/core/axis_insets.dart` | 45 | 3 | foundation | keep | generic utility; defaults to foundation per PLAN 4. |
| `shared/utils/_impl/core/axis_insets_directional.dart` | 29 | 3 | foundation | keep | generic utility; defaults to foundation per PLAN 4. |
| `shared/utils/_impl/core/axis_insets_geometry.dart` | 22 | 3 | foundation | keep | generic utility; defaults to foundation per PLAN 4. |
| `shared/utils/_impl/core/bi_directional_convert.dart` | 45 | 33 | foundation | split | part of `shared/utils/util.dart`; moves with its library root. |
| `shared/utils/_impl/core/cached_value_widget.dart` | 24 | 33 | foundation | split | part of `shared/utils/util.dart`; moves with its library root. |
| `shared/utils/_impl/core/callback_context_action.dart` | 21 | 33 | foundation | split | part of `shared/utils/util.dart`; moves with its library root. |
| `shared/utils/_impl/core/captured_wrapper.dart` | 28 | 33 | foundation | split | part of `shared/utils/util.dart`; moves with its library root. |
| `shared/utils/_impl/core/context_callback_action.dart` | 25 | 33 | foundation | split | part of `shared/utils/util.dart`; moves with its library root. |
| `shared/utils/_impl/core/form_pending_builder.dart` | 25 | 33 | foundation | split | part of `shared/utils/util.dart`; moves with its library root. |
| `shared/utils/_impl/core/repeated_animation_builder.dart` | 41 | 33 | foundation | split | part of `shared/utils/util.dart`; moves with its library root. |
| `shared/utils/_impl/core/resizer.dart` | 649 | 2 | foundation | keep | generic utility; defaults to foundation per PLAN 4. |
| `shared/utils/_impl/core/separated_flex.dart` | 56 | 33 | foundation | split | part of `shared/utils/util.dart`; moves with its library root. |
| `shared/utils/_impl/core/time_of_day.dart` | 115 | 33 | foundation | split | part of `shared/utils/util.dart`; moves with its library root. |
| `shared/utils/_impl/state/__cached_value_widget_state.dart` | 34 | 33 | foundation | split | part of `shared/utils/util.dart`; moves with its library root. |
| `shared/utils/_impl/state/__captured_wrapper_state.dart` | 197 | 33 | foundation | split | part of `shared/utils/util.dart`; moves with its library root. |
| `shared/utils/_impl/state/__repeated_animation_builder_state.dart` | 44 | 33 | foundation | split | part of `shared/utils/util.dart`; moves with its library root. |
| `shared/utils/_impl/state/__separated_flex_state.dart` | 120 | 33 | foundation | split | part of `shared/utils/util.dart`; moves with its library root. |
| `shared/utils/_impl/utils/converted_controller.dart` | 79 | 33 | foundation | split | part of `shared/utils/util.dart`; moves with its library root. |
| `shared/utils/axis.dart` | 42 | 3 | foundation | keep | generic utility; defaults to foundation per PLAN 4. |
| `shared/utils/border_utils.dart` | 46 | 5 | foundation | keep | generic utility; defaults to foundation per PLAN 4. |
| `shared/utils/constants.dart` | 22 | 35 | foundation | keep | Spacing/radius/duration constants: 40 libs / 35 comps. No dependency on theme or widgets. |
| `shared/utils/geometry_extensions.dart` | 37 | 8 | foundation | prune | EdgeInsets/BorderRadius/Alignment extensions: 11 components import the file, but 3 of its extensions have no external importer. Keep used members only. |
| `shared/utils/keyboard_shortcut_utils.dart` | 64 | 2 | foundation | keep | generic utility; defaults to foundation per PLAN 4. |
| `shared/utils/platform_utils.dart` | 18 | 7 | foundation | keep | Platform detection helper; PLAN 4 puts platform helpers in foundation. |
| `shared/utils/resizable_item.dart` | 89 | 2 | foundation | keep | generic utility; defaults to foundation per PLAN 4. |
| `shared/utils/resizer.dart` | 7 | 2 | foundation | keep | generic utility; defaults to foundation per PLAN 4. |
| `shared/utils/style_value.dart` | 7 | 58 | foundation | keep | StyleValue is the universal token wrapper: 68 libraries / 58 components import it. Pure value type, no Flutter widget dependency -> lowest layer. |
| `shared/utils/text_input_utils.dart` | 113 | 2 | foundation | keep | generic utility; defaults to foundation per PLAN 4. |
| `shared/utils/util.dart` | 377 | 33 | foundation | split | 377 LOC, 39 libs / 33 comps. Mixed bag: platform/geometry/animation helpers belong in foundation, widget-shape helpers belong in primitives, and the `gap()` wrapper is replaced by PLAN 3. |
| `shared/primitives/_impl/core/__fallback_overlay_manager.dart` | 188 | 20 | primitives | keep | part of `shared/primitives/overlay.dart`; moves with its library root. |
| `shared/primitives/_impl/core/__hidden_layout.dart` | 63 | 1 | primitives | dedupe | part of `shared/primitives/hidden.dart`; moves with its library root. |
| `shared/primitives/_impl/core/__hidden_layout_render.dart` | 98 | 1 | primitives | dedupe | part of `shared/primitives/hidden.dart`; moves with its library root. |
| `shared/primitives/_impl/core/__scale_gradient.dart` | 24 | 2 | primitives | dedupe | part of `shared/primitives/fade_scroll.dart`; moves with its library root. |
| `shared/primitives/_impl/core/animated_value_builder.dart` | 49 | 17 | primitives | keep | part of `shared/primitives/animated_value_builder.dart`; moves with its library root. |
| `shared/primitives/_impl/core/basic.dart` | 204 | 3 | primitives | dedupe | part of `shared/primitives/basic.dart`; moves with its library root. |
| `shared/primitives/_impl/core/basic_layout.dart` | 177 | 3 | primitives | dedupe | part of `shared/primitives/basic.dart`; moves with its library root. |
| `shared/primitives/_impl/core/country.dart` | 18 | 1 | primitives | dedupe | part of `shared/primitives/phone_number.dart`; moves with its library root. |
| `shared/primitives/_impl/core/fade_scroll.dart` | 145 | 2 | primitives | dedupe | part of `shared/primitives/fade_scroll.dart`; moves with its library root. |
| `shared/primitives/_impl/core/focus_outline.dart` | 118 | 9 | primitives | keep | part of `shared/primitives/focus_outline.dart`; moves with its library root. |
| `shared/primitives/_impl/core/hidden.dart` | 103 | 1 | primitives | dedupe | part of `shared/primitives/hidden.dart`; moves with its library root. |
| `shared/primitives/_impl/core/hover.dart` | 36 | 1 | primitives | dedupe | part of `shared/primitives/hover.dart`; moves with its library root. |
| `shared/primitives/_impl/core/hover_activity.dart` | 40 | 1 | primitives | dedupe | part of `shared/primitives/hover.dart`; moves with its library root. |
| `shared/primitives/_impl/core/label.dart` | 49 | 3 | primitives | dedupe | part of `shared/primitives/basic.dart`; moves with its library root. |
| `shared/primitives/_impl/core/overlay_barrier.dart` | 34 | 20 | primitives | keep | part of `shared/primitives/overlay.dart`; moves with its library root. |
| `shared/primitives/_impl/core/overlay_manager.dart` | 161 | 20 | primitives | keep | part of `shared/primitives/overlay.dart`; moves with its library root. |
| `shared/primitives/_impl/core/overlay_manager_layer.dart` | 38 | 20 | primitives | keep | part of `shared/primitives/overlay.dart`; moves with its library root. |
| `shared/primitives/_impl/core/overlay_popover_entry.dart` | 220 | 20 | primitives | keep | part of `shared/primitives/overlay.dart`; moves with its library root. |
| `shared/primitives/_impl/core/phone_number.dart` | 40 | 1 | primitives | dedupe | part of `shared/primitives/phone_number.dart`; moves with its library root. |
| `shared/primitives/_impl/core/popover.dart` | 119 | 20 | primitives | keep | part of `shared/primitives/overlay.dart`; moves with its library root. |
| `shared/primitives/_impl/core/popover_layout.dart` | 155 | 20 | primitives | keep | part of `shared/primitives/overlay.dart`; moves with its library root. |
| `shared/primitives/_impl/core/popover_layout_render.dart` | 362 | 20 | primitives | keep | part of `shared/primitives/overlay.dart`; moves with its library root. |
| `shared/primitives/_impl/core/popover_overlay_widget.dart` | 157 | 20 | primitives | keep | part of `shared/primitives/overlay.dart`; moves with its library root. |
| `shared/primitives/_impl/core/shadcn_layer.dart` | 58 | 20 | primitives | keep | part of `shared/primitives/overlay.dart`; moves with its library root. |
| `shared/primitives/_impl/state/__animated_value_builder_state.dart` | 228 | 17 | primitives | keep | part of `shared/primitives/animated_value_builder.dart`; moves with its library root. |
| `shared/primitives/_impl/state/__hover_activity_state.dart` | 72 | 1 | primitives | dedupe | part of `shared/primitives/hover.dart`; moves with its library root. |
| `shared/primitives/_impl/state/__hover_state.dart` | 69 | 1 | primitives | dedupe | part of `shared/primitives/hover.dart`; moves with its library root. |
| `shared/primitives/_impl/state/__overlay_manager_layer_state.dart` | 205 | 20 | primitives | keep | part of `shared/primitives/overlay.dart`; moves with its library root. |
| `shared/primitives/_impl/state/popover_overlay_widget_state.dart` | 568 | 20 | primitives | keep | part of `shared/primitives/overlay.dart`; moves with its library root. |
| `shared/primitives/_impl/themes/basic_theme.dart` | 133 | 3 | primitives | dedupe | part of `shared/primitives/basic.dart`; moves with its library root. |
| `shared/primitives/_impl/themes/fade_scroll_theme.dart` | 57 | 2 | primitives | dedupe | part of `shared/primitives/fade_scroll.dart`; moves with its library root. |
| `shared/primitives/_impl/themes/focus_outline_theme.dart` | 52 | 9 | primitives | keep | part of `shared/primitives/focus_outline.dart`; moves with its library root. |
| `shared/primitives/_impl/themes/hidden_theme.dart` | 63 | 1 | primitives | dedupe | part of `shared/primitives/hidden.dart`; moves with its library root. |
| `shared/primitives/_impl/themes/hover_theme.dart` | 77 | 1 | primitives | dedupe | part of `shared/primitives/hover.dart`; moves with its library root. |
| `shared/primitives/_impl/utils/overlay_completer.dart` | 30 | 20 | primitives | keep | part of `shared/primitives/overlay.dart`; moves with its library root. |
| `shared/primitives/_impl/utils/overlay_handler.dart` | 81 | 20 | primitives | keep | part of `shared/primitives/overlay.dart`; moves with its library root. |
| `shared/primitives/_impl/utils/popover_controller.dart` | 251 | 20 | primitives | keep | part of `shared/primitives/overlay.dart`; moves with its library root. |
| `shared/primitives/_impl/utils/popover_overlay_handler.dart` | 199 | 20 | primitives | keep | part of `shared/primitives/overlay.dart`; moves with its library root. |
| `shared/primitives/animated_value_builder.dart` | 14 | 17 | primitives | keep | Generic animation builder: 21 libs / 17 comps. PLAN 4 L2 `animation`. |
| `shared/primitives/basic.dart` | 19 | 3 | primitives | dedupe | 3 libs / 3 comps vs the layout/basic fork 5/5. layout/basic owns Basic/BasicLayout/Label/BasicTheme; this fork is deleted. |
| `shared/primitives/fade_scroll.dart` | 16 | 2 | primitives | dedupe | 2 libs / 2 comps, but FadeScroll also exists as 2 component dirs. components/layout/fade_scroll keeps the name; delete this fork. |
| `shared/primitives/focus_outline.dart` | 13 | 9 | primitives | keep | 10 libs / 9 comps vs 2/1 for the utility/focus_outline fork. |
| `shared/primitives/hidden.dart` | 17 | 1 | primitives | dedupe | 1 lib / 1 comp vs the layout/hidden fork 3 libs / 2 comps. layout/hidden wins; delete this fork. |
| `shared/primitives/hover.dart` | 17 | 1 | primitives | dedupe | 1 lib / 1 comp (tooltip) vs control/hover 2 libs / 1 comp. control/hover wins; delete this fork. |
| `shared/primitives/icon_extensions.dart` | 67 | 5 | primitives | prune | `.fill()` has 38 call sites across 26 files; `.size()`, `.weight()`, `.onPrimary()` have 0 - delete them. |
| `shared/primitives/menu_group.dart` | 15 | 2 | primitives | dedupe | 2 libs / 2 comps vs overlay/menu 10 libs / 6 comps. menu owns MenuGroupData; delete this fork. |
| `shared/primitives/overlay.dart` | 125 | 20 | primitives | keep | The overlay/popover manager: 21 libs / 20 comps. PLAN 4 L2. |
| `shared/primitives/phone_number.dart` | 7 | 1 | primitives | dedupe | 1 lib / 1 comp vs the phone_input fork which is a superset (694 vs 494 chars). phone_input owns PhoneNumber; delete this fork. |
| `shared/primitives/popover.dart` | 12 | 20 | primitives | keep | Sub-entrypoint of overlay.dart; merges into the overlay primitive rather than standing alone. |
| `shared/primitives/sheet_overlay.dart` | 13 | 3 | primitives | dedupe | 3 libs / 3 comps vs the drawer fork 14/9. drawer owns SheetOverlayHandler; delete this fork. |
| `shared/primitives/slider_value.dart` | 71 | 2 | primitives | keep | Slider value model shared by the slider variants (2 components). |
| `shared/utils/widget_extensions.dart` | 413 | 0 | primitives | prune | 413 LOC. 9 of 19 extension members have 0 call sites (see report section 5); delete those, keep the 10 that are used. |
| `shared/utils/_impl/core/__animation_runner.dart` | 26 | 1 | primitives/animation | keep | part of `shared/utils/animation_queue.dart`; moves with its library root. |
| `shared/utils/_impl/core/animation_request.dart` | 19 | 1 | primitives/animation | keep | part of `shared/utils/animation_queue.dart`; moves with its library root. |
| `shared/utils/_impl/utils/animation_queue_controller.dart` | 77 | 1 | primitives/animation | keep | part of `shared/utils/animation_queue.dart`; moves with its library root. |
| `shared/utils/animation_queue.dart` | 10 | 1 | primitives/animation | keep | Animation queue; promoted to the animation primitive that owns RepeatedAnimationBuilder. |
| `shared/utils/controlled_animation.dart` | 70 | 1 | primitives/animation | keep | Controlled animation helper, 1 importer. |
| `shared/primitives/_impl/core/__builder_stated_widget.dart` | 56 | 9 | primitives/clickable | keep | part of `shared/primitives/clickable.dart`; moves with its library root. |
| `shared/primitives/_impl/core/__map_stated_widget.dart` | 55 | 9 | primitives/clickable | keep | part of `shared/primitives/clickable.dart`; moves with its library root. |
| `shared/primitives/_impl/core/__param_stated_widget.dart` | 110 | 9 | primitives/clickable | keep | part of `shared/primitives/clickable.dart`; moves with its library root. |
| `shared/primitives/_impl/core/clickable.dart` | 210 | 9 | primitives/clickable | keep | part of `shared/primitives/clickable.dart`; moves with its library root. |
| `shared/primitives/_impl/core/stated_widget.dart` | 133 | 9 | primitives/clickable | keep | part of `shared/primitives/clickable.dart`; moves with its library root. |
| `shared/primitives/_impl/core/widget_states_data.dart` | 31 | 9 | primitives/clickable | keep | part of `shared/primitives/clickable.dart`; moves with its library root. |
| `shared/primitives/_impl/core/widget_states_provider.dart` | 99 | 9 | primitives/clickable | keep | part of `shared/primitives/clickable.dart`; moves with its library root. |
| `shared/primitives/_impl/state/__clickable_state.dart` | 338 | 9 | primitives/clickable | keep | part of `shared/primitives/clickable.dart`; moves with its library root. |
| `shared/primitives/clickable.dart` | 88 | 9 | primitives/clickable | keep | PLAN 4 L2 `clickable`. 17 libs / 9 comps vs 2/1 for the control/clickable fork. |
| `shared/primitives/_impl/core/__form_entry_cached_value.dart` | 84 | 15 | primitives/form_core | keep | part of `shared/primitives/form_value_supplier.dart`; moves with its library root. |
| `shared/primitives/_impl/core/controlled_component_adapter.dart` | 73 | 13 | primitives/form_core | keep | part of `shared/primitives/form_control.dart`; moves with its library root. |
| `shared/primitives/_impl/core/controlled_component_data.dart` | 69 | 13 | primitives/form_core | keep | part of `shared/primitives/form_control.dart`; moves with its library root. |
| `shared/primitives/_impl/core/form_key.dart` | 39 | 15 | primitives/form_core | keep | part of `shared/primitives/form_value_supplier.dart`; moves with its library root. |
| `shared/primitives/_impl/core/replace_result.dart` | 53 | 15 | primitives/form_core | keep | part of `shared/primitives/form_value_supplier.dart`; moves with its library root. |
| `shared/primitives/_impl/core/validation_result.dart` | 21 | 15 | primitives/form_core | keep | part of `shared/primitives/form_value_supplier.dart`; moves with its library root. |
| `shared/primitives/_impl/state/__controlled_component_adapter_state.dart` | 75 | 13 | primitives/form_core | keep | part of `shared/primitives/form_control.dart`; moves with its library root. |
| `shared/primitives/_impl/utils/component_value_controller.dart` | 63 | 13 | primitives/form_core | keep | part of `shared/primitives/form_control.dart`; moves with its library root. |
| `shared/primitives/form_control.dart` | 42 | 13 | primitives/form_core | keep | ControlledComponent contract: 20 libs / 13 comps. This is the form_core home. |
| `shared/primitives/form_value_supplier.dart` | 18 | 15 | primitives/form_core | keep | FormKey/ValidationResult/FormValueSupplier: 21 libs / 15 comps. This is the form_core home. |
| `shared/localizations/_impl/core/shadcn_localizations.dart` | 433 | 15 | primitives/localizations | keep | part of `shared/localizations/shadcn_localizations.dart`; moves with its library root. |
| `shared/localizations/_impl/utils/__shadcn_localizations_delegate.dart` | 25 | 15 | primitives/localizations | keep | part of `shared/localizations/shadcn_localizations.dart`; moves with its library root. |
| `shared/localizations/shadcn_localizations.dart` | 9 | 15 | primitives/localizations | keep | 18 libs / 15 comps - this is the copy components actually use. |
| `shared/localizations/shadcn_localizations_extensions.dart` | 180 | 3 | primitives/localizations | keep | 3 comps; localizations helper extensions. |
| `shared/primitives/_impl/core/sub_focus.dart` | 106 | 3 | primitives/subfocus | keep | part of `shared/primitives/subfocus.dart`; moves with its library root. |
| `shared/primitives/_impl/core/sub_focus_scope.dart` | 120 | 3 | primitives/subfocus | keep | part of `shared/primitives/subfocus.dart`; moves with its library root. |
| `shared/primitives/_impl/state/__sub_focus_scope_state.dart` | 299 | 3 | primitives/subfocus | keep | part of `shared/primitives/subfocus.dart`; moves with its library root. |
| `shared/primitives/_impl/state/__sub_focus_state.dart` | 141 | 3 | primitives/subfocus | keep | part of `shared/primitives/subfocus.dart`; moves with its library root. |
| `shared/primitives/subfocus.dart` | 65 | 3 | primitives/subfocus | keep | 4 libs / 3 comps (command, menu, select) vs 1/1 for the subfocus component copy. Single owner. |
| `shared/primitives/_impl/core/__bullet_painter.dart` | 46 | 19 | primitives/text | keep | part of `shared/primitives/text.dart`; moves with its library root. |
| `shared/primitives/_impl/core/__rich_text_then_widget.dart` | 37 | 19 | primitives/text | keep | part of `shared/primitives/text.dart`; moves with its library root. |
| `shared/primitives/_impl/core/__selectable_text_then_widget.dart` | 41 | 19 | primitives/text | keep | part of `shared/primitives/text.dart`; moves with its library root. |
| `shared/primitives/_impl/core/__text_then_widget.dart` | 35 | 19 | primitives/text | keep | part of `shared/primitives/text.dart`; moves with its library root. |
| `shared/primitives/_impl/core/text_modifier.dart` | 523 | 19 | primitives/text | keep | part of `shared/primitives/text.dart`; moves with its library root. |
| `shared/primitives/_impl/core/unordered_list_data.dart` | 24 | 19 | primitives/text | keep | part of `shared/primitives/text.dart`; moves with its library root. |
| `shared/primitives/_impl/core/wrapped_text.dart` | 178 | 19 | primitives/text | keep | part of `shared/primitives/text.dart`; moves with its library root. |
| `shared/primitives/text.dart` | 24 | 19 | primitives/text | keep | Text modifiers: 25 libs / 19 comps vs 11/11 for the display/text fork. PLAN 4 L2 `text`. |
| `shared/utils/color_extensions.dart` | 151 | 23 | theme | keep | HSL/shade math over colours. PLAN 6.5 puts this in theme/color_utils.dart; 27 libs / 23 comps. |
| `shared/utils/tween_utils.dart` | 23 | 0 | theme | keep | Tween/lerp helpers; depends on the theme types. |

## 4. External packages to replace (PLAN §3: replace `gap` and `data_widget`)

### `package:data_widget`

- **60** libraries import `package:data_widget`, covering **673** Dart files (counted through the `part of` closure).
- **199** symbol references in total.

| Symbol | Refs | Components | Files |
|---|---|---|---|
| `Data.capture` | 6 | 4 | 6 |
| `Data.find` | 1 | 1 | 1 |
| `Data.inherit` | 56 | 28 | 43 |
| `Data.maybeFind` | 16 | 9 | 11 |
| `Data.maybeFindMessenger` | 4 | 3 | 3 |
| `Data.maybeFindRoot` | 1 | 1 | 1 |
| `Data.maybeOf` | 93 | 31 | 80 |
| `Data.of` | 22 | 12 | 17 |

Top components by reference count:

| Component | References |
|---|---|
| `navigation_bar` (`Data.maybeOf`) | 13 |
| `menu` (`Data.maybeOf`) | 11 |
| `shared/primitives` (`Data.maybeOf`) | 11 |
| `form` (`Data.maybeOf`) | 6 |
| `clickable` (`Data.maybeOf`) | 5 |
| `drawer` (`Data.maybeOf`) | 5 |
| `button` (`Data.maybeOf`) | 4 |
| `radio_group` (`Data.maybeOf`) | 4 |
| `navigation_bar` (`Data.inherit`) | 7 |
| `stepper` (`Data.inherit`) | 7 |
| `table` (`Data.inherit`) | 4 |
| `select` (`Data.inherit`) | 3 |
| `drawer` (`Data.inherit`) | 3 |
| `button` (`Data.inherit`) | 2 |
| `form` (`Data.inherit`) | 2 |
| `radio_group` (`Data.inherit`) | 2 |
| `sortable` (`Data.of`) | 3 |
| `table` (`Data.of`) | 3 |
| `form` (`Data.of`) | 2 |
| `multiple_choice` (`Data.of`) | 2 |
| `accordion` (`Data.of`) | 2 |
| `collapsible` (`Data.of`) | 2 |
| `resizable` (`Data.of`) | 2 |
| `drawer_container` (`Data.of`) | 2 |

### `package:gap`

- **26** libraries import `package:gap`, covering **243** Dart files (counted through the `part of` closure).
- **32** symbol references in total.

| Symbol | Refs | Components | Files |
|---|---|---|---|
| `Gap` | 32 | 13 | 13 |

Top components by reference count:

| Component | References |
|---|---|
| `drawer` (`Gap`) | 12 |
| `file_picker` (`Gap`) | 4 |
| `phone_input` (`Gap`) | 3 |
| `form` (`Gap`) | 2 |
| `history` (`Gap`) | 2 |
| `timeline` (`Gap`) | 2 |
| `card_image` (`Gap`) | 1 |
| `collapsible` (`Gap`) | 1 |

**Sizing the replacement.**

- `data_widget`: `Data.maybeOf` (93), `Data.of` (22), `Data.maybeFind` (16) and `Data.inherit` (56) account for 187 of the 199 references. A `DataScope<T>` in `foundation` must therefore cover 4 static methods plus the inherited-holder widget. The remaining 12 references are `Data.capture` (6), `Data.maybeFindMessenger` (4), `Data.find` (1) and `Data.maybeFindRoot` (1) - all messenger/lookup helpers that can map onto a small messenger API.
- `gap`: a single symbol, `Gap` (32 refs in 13 components). `shared/utils/util.dart:249` already wraps it in a local `gap()` helper, so call sites that go through `gap()` need no change at all; the rest are a direct `Gap(n)` -> `SizedBox` substitution.

**Pubspec cleanup is wider than one component.** `gap` appears in **117** component `meta.json` files and `data_widget` in **80**; the root `manifests/components.json` lists a `pubspec.dependencies` block for all **145** components. Phase 2 must strip these from every manifest, not just the form components, or installs will keep pulling both packages.

## 5. Dead code & pruning candidates

**Result: 0 truly dead declarations.** Every one of the 2,199 non-theme top-level names is referenced *somewhere* in the registry, so rule **R4 (delete-if-dead) never fires on a name.**

What the numbers actually measure:

| Bucket | Count | Meaning | Action |
|---|---|---|---|
| truly dead | 0 | zero references anywhere in the registry | n/a — R4 never fires |
| internal-only | 1272 | referenced only inside its own library (no external importer) | prune candidates, **not** automatic deletions |
| shared | 927 | ≥1 library outside the declaring one imports it | keep |

Of the 1272 internal-only names, **88 live under `shared/`** — these are the real prize, because a `shared/` file with no external importer is pure install weight for every consumer. Per §3 they are the forks that get deleted.

### Pruning: `shared/utils/widget_extensions.dart` (413 LOC)

The registry-wide extension-member scan (`.member(` call sites outside the declaring file) shows 9 of 19 members are **never called**:

| Member | Call sites | Verdict |
|---|---|---|
| `.center()` | 0 | **delete** |
| `.positioned()` | 0 | **delete** |
| `.clip()` | 0 | **delete** |
| `.clipRRect()` | 0 | **delete** |
| `.clipOval()` | 0 | **delete** |
| `.intrinsicWidth()` | 0 | **delete** |
| `.intrinsicHeight()` | 0 | **delete** |
| `.intrinsic()` | 0 | **delete** |
| `.separator()` | 0 | **delete** |
| `.sized()` | 1 | keep |
| `.constrained()` | 1 | keep |
| `.withAlign()` | 1 | keep |
| `.clipPath()` | 2 | keep |
| `.expanded()` | 5 | keep |
| `.gap()` | 15 | keep |
| `.withPadding()` | 18 | keep |
| `.transform()` | 27 | keep |
| `.withOpacity()` | 41 | keep |

`shared/primitives/icon_extensions.dart`: `.fill()` has 38 call sites across 26 files; `.size()`, `.weight()`, `.onPrimary()` have **0** and should be deleted.

### Internal-only names under `shared/`

| Name | Kind | File |
|---|---|---|
| `_RichTextThenWidget` | class | `components/display/text/_impl/core/_rich_text_then_widget.dart` |
| `_SelectableTextThenWidget` | class | `components/display/text/_impl/core/_selectable_text_then_widget.dart` |
| `_TextThenWidget` | class | `components/display/text/_impl/core/_text_then_widget.dart` |
| `UnorderedListData` | class | `components/display/text/_impl/core/unordered_list_data.dart` |
| `WrappedText` | class | `components/display/text/_impl/core/wrapped_text.dart` |
| `TextExtension` | extension | `components/display/text/text.dart` |
| `TextModifier` | class | `components/display/text/text.dart` |
| `WidgetTextWrapper` | typedef | `components/display/text/text.dart` |
| `WrappedTextDataBuilder` | typedef | `components/display/text/text.dart` |
| `TextFieldClearIntent` | class | `components/form/text_field/_impl/utils/text_field_clear_intent.dart` |
| `_SubFocusScopeState` | class | `components/navigation/subfocus/_impl/state/_sub_focus_scope_state.dart` |
| `_SubFocusState` | class | `components/navigation/subfocus/_impl/state/_sub_focus_state.dart` |
| `SubFocusBuilder` | typedef | `components/navigation/subfocus/subfocus.dart` |
| `SubFocusScopeBuilder` | typedef | `components/navigation/subfocus/subfocus.dart` |
| `SubFocusState` | mixin | `components/navigation/subfocus/subfocus.dart` |
| `BootstrapIconEntry` | class | `shared/icons/bootstrap_icons_list.dart` |
| `LucideIconEntry` | class | `shared/icons/lucide_icons_list.dart` |
| `RadixIconEntry` | class | `shared/icons/radix_icons_list.dart` |
| `ShadcnLocalizationsObjectInputExtensions` | extension | `shared/localizations/shadcn_localizations_extensions.dart` |
| `_BuilderStatedWidget` | class | `shared/primitives/_impl/core/__builder_stated_widget.dart` |
| `_BulletPainter` | class | `shared/primitives/_impl/core/__bullet_painter.dart` |
| `_FallbackOverlayManager` | class | `shared/primitives/_impl/core/__fallback_overlay_manager.dart` |
| `_HiddenLayoutRender` | class | `shared/primitives/_impl/core/__hidden_layout_render.dart` |
| `_MapStatedWidget` | class | `shared/primitives/_impl/core/__map_stated_widget.dart` |
| `_ParamStatedWidget` | class | `shared/primitives/_impl/core/__param_stated_widget.dart` |
| `Popover` | class | `shared/primitives/_impl/core/popover.dart` |
| `PopoverLayout` | class | `shared/primitives/_impl/core/popover_layout.dart` |
| `PopoverLayoutRender` | class | `shared/primitives/_impl/core/popover_layout_render.dart` |
| `PopoverFutureVoidCallback` | typedef | `shared/primitives/_impl/core/popover_overlay_widget.dart` |
| `ShadcnLayer` | class | `shared/primitives/_impl/core/shadcn_layer.dart` |
| `_AnimatedValueBuilderState` | class | `shared/primitives/_impl/state/__animated_value_builder_state.dart` |
| `_ClickableState` | class | `shared/primitives/_impl/state/__clickable_state.dart` |
| `_HoverActivityState` | class | `shared/primitives/_impl/state/__hover_activity_state.dart` |
| `_HoverState` | class | `shared/primitives/_impl/state/__hover_state.dart` |
| `_OverlayManagerLayerState` | class | `shared/primitives/_impl/state/__overlay_manager_layer_state.dart` |
| `_SurfaceBlurState` | class | `shared/primitives/_impl/state/__surface_blur_state.dart` |
| `AnimatedValueLerp` | typedef | `shared/primitives/animated_value_builder.dart` |
| `AnimatedValueWidgetBuilder` | typedef | `shared/primitives/animated_value_builder.dart` |
| `IconExtensions` | extension | `shared/primitives/icon_extensions.dart` |
| `FutureVoidCallback` | typedef | `shared/primitives/popover.dart` |
| `_AnimationRunner` | class | `shared/utils/_impl/core/__animation_runner.dart` |
| `_BorrowInfo` | class | `shared/utils/_impl/core/__borrow_info.dart` |
| `AxisInsets` | class | `shared/utils/_impl/core/axis_insets.dart` |
| `AxisInsetsDirectional` | class | `shared/utils/_impl/core/axis_insets_directional.dart` |
| `AxisInsetsGeometry` | class | `shared/utils/_impl/core/axis_insets_geometry.dart` |
| `Convert` | typedef | `shared/utils/_impl/core/bi_directional_convert.dart` |
| `OnContextedCallback` | typedef | `shared/utils/_impl/core/callback_context_action.dart` |
| `RepeatedAnimationWidgetBuilder` | typedef | `shared/utils/_impl/core/form_pending_builder.dart` |
| `SeparatedFlex` | class | `shared/utils/_impl/core/separated_flex.dart` |
| `_CachedValueWidgetState` | class | `shared/utils/_impl/state/__cached_value_widget_state.dart` |
| `WidgetAlignmentExtension` | extension | `shared/utils/_impl/state/__captured_wrapper_state.dart` |
| `WidgetPaddingExtension` | extension | `shared/utils/_impl/state/__captured_wrapper_state.dart` |
| `WidgetSizingExtension` | extension | `shared/utils/_impl/state/__captured_wrapper_state.dart` |
| `_CapturedWrapperState` | class | `shared/utils/_impl/state/__captured_wrapper_state.dart` |
| `_RepeatedAnimationBuilderState` | class | `shared/utils/_impl/state/__repeated_animation_builder_state.dart` |
| `ColumnExtension` | extension | `shared/utils/_impl/state/__separated_flex_state.dart` |
| `FlexExtension` | extension | `shared/utils/_impl/state/__separated_flex_state.dart` |
| `RowExtension` | extension | `shared/utils/_impl/state/__separated_flex_state.dart` |
| `_SeparatedFlexState` | class | `shared/utils/_impl/state/__separated_flex_state.dart` |
| `ColorExtension` | extension | `shared/utils/color_extensions.dart` |
| `HSLColorExtension` | extension | `shared/utils/color_extensions.dart` |
| `HSVColorExtension` | extension | `shared/utils/color_extensions.dart` |
| `SortDirection` | enum | `shared/utils/constants.dart` |
| `AlignmentGeometryExtension` | extension | `shared/utils/geometry_extensions.dart` |
| `BorderRadiusGeometryExtension` | extension | `shared/utils/geometry_extensions.dart` |
| `EdgeInsetsGeometryExtension` | extension | `shared/utils/geometry_extensions.dart` |
| `ReplacementInfo` | typedef | `shared/utils/text_input_utils.dart` |
| `TextEditingControllerExtension` | extension | `shared/utils/text_input_utils.dart` |
| `TextEditingValueExtension` | extension | `shared/utils/text_input_utils.dart` |
| `WordInfo` | typedef | `shared/utils/text_input_utils.dart` |
| `IconThemeDataTween` | class | `shared/utils/tween_utils.dart` |
| `BinaryOperator` | typedef | `shared/utils/util.dart` |
| `FutureOrExtension` | extension | `shared/utils/util.dart` |
| `IterableExtension` | extension | `shared/utils/util.dart` |
| `Joinable` | extension | `shared/utils/util.dart` |
| `ListExtension` | extension | `shared/utils/util.dart` |
| `NeverWidgetBuilder` | typedef | `shared/utils/util.dart` |
| `OnContextInvokeCallback` | typedef | `shared/utils/util.dart` |
| `SafeLerp` | class | `shared/utils/util.dart` |
| `SafeLerpExtension` | extension | `shared/utils/util.dart` |
| `SearchPredicate` | typedef | `shared/utils/util.dart` |
| `SeparatedIterable` | class | `shared/utils/util.dart` |
| `WidgetTreeChangeDetector` | class | `shared/utils/util.dart` |
| `WidgetTreeChangeDetectorState` | class | `shared/utils/util.dart` |
| `_SeparatedIterator` | class | `shared/utils/util.dart` |
| `DoubleExtension` | extension | `shared/utils/widget_extensions.dart` |
| `IntExtension` | extension | `shared/utils/widget_extensions.dart` |
| `WidgetExtension` | extension | `shared/utils/widget_extensions.dart` |

Note: `Popover`, `PopoverLayout`, `PopoverLayoutRender` and `ShadcnLayer` show as internal-only because they are reached through `shared/primitives/overlay.dart`'s own `part` closure, not by a separate import. They are **not** dead — this is a known limitation of counting importers per-file instead of per-library, and it is why the shared-map layer assignment, not the dead-code count, is the authoritative artifact.

## 6. Structural findings that block or reshape the migration

| # | Finding | Evidence | Impact |
|---|---|---|---|
| 1 | **`tab_list` cannot be installed.** The directory has only `_impl/**`, `preview.dart` and JSON — there is no `tab_list.dart` entrypoint. | `find components/navigation/tab_list` → 5 files, 0 non-`_impl` library files | Delete the component outright (it is a byte-identical copy of `tabs/_impl/core/tab_list.dart`). |
| 2 | **Two component directories share the id `sortable`** (`components/form/sortable`, `components/layout/sortable`) with different previews and different `meta.json`. | duplicate dir scan | PLAN §5 forbids duplicate ids; one must be deleted. UNVERIFIED which one is richer. |
| 3 | **Two component directories share the id `fade_scroll`** (`components/display/fade_scroll`, `components/layout/fade_scroll`) with 3 different `FadeScroll` bodies. | duplicate dir scan | Same as above; `layout` is the reachable one. |
| 4 | **`input` is a strict subset of `text_field`** — `comm` shows 0 files unique to `input`, 46 unique to `text_field`. The 12 feature classes are byte-identical except the `part of` line; the spinner `min`/`max` clamping exists only in `input` (canonical copy). | `diff` on 13 pairs | The merge keeps the `input` spinner copy; the shadcn name `input` wins. |
| 5 | **`input` depends on `text_field` while also redeclaring its classes.** | `components/form/input/meta.json` `dependencies.components = [button, text_field]`; `input/input.dart` imports `../../control/button/button.dart` **and** `../text_field/text_field.dart` | Installing both components today would define `InputClearFeature` twice — this is the concrete collision PLAN §5's preflight must catch. |
| 6 | **`FormKey` bodies genuinely differ.** `components/form/form/_impl/core/form_key.dart` adds `getValue(FormMapValues)` and `operator []`; `shared/primitives/_impl/core/form_key.dart` does not. | direct read | When `form_key` moves to `primitives/form_core`, the superset body (the `form` one) wins, and `FormMapValues` must move with it. |
| 7 | **`FormPendingWidgetBuilder` is declared twice** — inline in `form/form.dart:373` (4 components) and again inside `shared/utils/_impl/core/context_callback_action.dart`, whose library is imported by **33 components**. Neither copy has an importer that the other lacks, so reach cannot break the tie. | `decls_all` + per-name importer table | It is form plumbing by type signature (`Map<FormKey, Future<ValidationResult?>>`), so `primitives/form_core` owns it and `shared/utils` drops it. |
| 8 | **`72` non-preview files import `package:flutter/material.dart`** (203 including previews), including `shared/primitives/text.dart` and `components/form/form/form.dart`. | grep | PLAN §2 forbids Material entirely; this is the real number for Phase 2, not the ~20 in the PLAN table. |
| 9 | **The 7 button-variant wrappers are 174 LOC each and differ only in the `style: ButtonStyle.X(...)` line.** | `diff` after name normalization → only doc comments differ | PLAN §4 rule 1 collapses them to a `ButtonVariant` enum + one switch. |
| 10 | **`shared/primitives` is a shadow copy of the component layer**, not a genuine shared layer: 89 files / 8,743 LOC, of which 31 files across **8 library roots** are forks that lose to their component copy (`basic`, `fade_scroll`, `hidden`, `hover`, `menu_group`, `outlined_container`, `phone_number`, `sheet_overlay`). | §3 shared map, rows with action `dedupe` | `shared/primitives` shrinks to genuine cross-component primitives: `overlay`, `animated_value_builder`, `form_core`, `subfocus`, `clickable`, `focus_outline`, `text`, `localizations`. |
| 11 | **`display/text` declares no `Text` widget at all.** It holds only text modifiers, and its `meta.json` already says `"tier": "primitive"`. | `grep '^class Text'` over `components/display/text/` → no match; `text.dart` contains only `TextExtension`, 2 typedefs and 5 `part` files | Promote it to `primitives/text` per PLAN §4 and drop it as a component; its 11 importers switch to the primitive. |
| 12 | **`FormPendingWidgetBuilder` is declared inside `shared/utils/_impl/core/context_callback_action.dart`** — a file whose name has nothing to do with it. | direct read | Form plumbing must not live in `shared/utils`; it moves to `primitives/form_core`. |

## 7. Ordering recommendation

Phase 2 should build in this order, because later steps depend on earlier ones:

1. **`foundation/`** — `package:gap` → local `Gap`/`gap()`, `package:data_widget` → `DataScope<T>`, plus `style_value`, `constants`, `platform_utils`, `geometry_extensions` (used members only) and the 3 icon codepoint files. Zero behaviour change, and it drops 2 pubspec dependencies from every component that lists them.
2. **`theme/`** — owned by the theme agent (excluded here).
3. **`primitives/form_core/`** — the 14 form-state names. Unblocks the `form` merge.
4. **`primitives/`** — `overlay`, `animated_value_builder`, `text` (promoted from `display/text`), `subfocus`, `clickable`, `focus_outline`, `localizations`. Note `menu_group`, `basic`, `hidden`, `hover`, `outlined_container`, `phone_number`, `sheet_overlay` and `fade_scroll` are **deleted** here, not promoted - their owning component keeps the name.
5. **Pilot merges** — `tabs`, `input`, `button` (PLAN §9 Phase 3).
6. **CLI preflight** (`tool/check_single_owner.dart`) — the gate that keeps the count at 0.

## 8. Method & reproducibility

The scan is reproducible from three scripts (kept out of the repo, in `/tmp/p1c/`):

| Script | Purpose |
|---|---|
| `analysis3.py` | part-of closure, import graph, declaration extraction, body hashing → `full.json` |
| `usage.py` | per-declaration external-reference scan (dead-code detection) → `usage.json` |
| `compaudit.py` | per-component entrypoint / LOC / dependency audit → `components.json` |
| `sharedids.py` | cross-checks `manifests/components.json` shared ids against the measured import graph |

Declaration extraction is column-0 anchored (`class|mixin|enum|extension|typedef`), with anonymous `extension on X` excluded and body size measured by brace balancing. The brief preferred `package:analyzer`; this audit used brace-balanced parsing because the run had to cover 2,053 files in a single pass. **Caveat:** the extractor will miss a declaration that begins on the same line as another statement (e.g. `class A extends B {}; class C {}`), which the codebase does not use — but `tool/check_single_owner.dart` should use `package:analyzer` as specified so the CI gate is exact.

