# P2-E2 — `primitives/{form_core,text,localizations}`

Layer 2 primitives for the new registry. Old tree (`lib/registry`) untouched:
`dart analyze lib/registry` → *No issues found*.

**Round 2 changes: F1** (`didUpdateWidget`), **F2** (locale-part enums moved
down + 4 extension members ported), **F3** (all 39 locale tables ported). Round 1
content is preserved below and marked where it changed.

## Files written

| File | LOC | Replaces (old tree) |
|---|---|---|
| `primitives/form_core/form_core.dart` | 187 | `shared/primitives/form_value_supplier.dart` + `_impl/core/{form_key,validation_result,replace_result}.dart`, `components/form/form/_impl/core/{form_key,validation_result,replace_result,form_validation_mode,form_field_handle}.dart`, `components/form/form/_impl/core/_form_entry_cached_value.dart` (cached box → `form_value.dart`), `components/form/form/form.dart:219-249` (`FormMapValues` + extension), `shared/utils/_impl/core/form_pending_builder.dart` |
| `primitives/form_core/form_control.dart` | 183 | `shared/primitives/form_control.dart` + `_impl/{core/controlled_component_adapter,core/controlled_component_data,state/__controlled_component_adapter_state,utils/component_value_controller}.dart`, `components/form/control/_impl/**` (identical fork, deleted) |
| `primitives/form_core/form_value.dart` | 93 | `shared/primitives/_impl/core/__form_entry_cached_value.dart` (`FormValueSupplier` half) |
| `primitives/text/text.dart` | 353 | `shared/primitives/text.dart` + `_impl/core/{text_modifier,wrapped_text,_text_then_widget,_rich_text_then_widget}.dart` (minus `TextExtension`), `components/display/text/_impl/core/{_text_then_widget,_rich_text_then_widget}.dart` |
| `primitives/text/text_extension.dart` | 379 | `shared/primitives/_impl/core/text_modifier.dart` (`TextExtension`) |
| `primitives/text/list.dart` | 65 | `shared/primitives/_impl/core/unordered_list_data.dart` + `_impl/core/__bullet_painter.dart` |
| `primitives/localizations/localizations.dart` | 397 | `shared/localizations/shadcn_localizations.dart` + `_impl/core/shadcn_localizations.dart`; `components/utility/shadcn_localizations/**` deleted |
| `primitives/localizations/localizations_delegate.dart` | 160 | `shared/localizations/_impl/utils/__shadcn_localizations_delegate.dart`, rewritten as an index over all 39 tables |
| `primitives/localizations/localizations_<code>.dart` ×39 | 12,7xx | `components/utility/shadcn_localizations/_impl/locale/*.dart` (data) |
| `primitives/localizations/locale_parts.dart` | 49 | **NEW** — `components/utility/locale_utils/_impl/core/{date_part,time_part,duration_part}.dart` (see F2) |
| `primitives/localizations/localizations_extensions.dart` | 179 | `shared/localizations/shadcn_localizations_extensions.dart` merged with `components/utility/shadcn_localizations_extensions/…` |
| `test/registry_next/primitives/{form_core,text,localizations}_test.dart` | 547/428/378 | — |

Code (non-data, non-test): 2,176 LOC. Data: 12,7xx LOC across 39 files, exempt
from the 400-line rule. Tests: 1,353 LOC / 75 cases.

---

## Round 2

### F1 — `ControlledComponentAdapter` controller hand-over

`didUpdateWidget` rewritten:

```dart
final controller = widget.controller;
if (oldWidget.controller == controller) return;      // nothing to move
oldWidget.controller?.removeListener(_onControllerChanged);
if (controller == null) return;                       // keep _value
controller.addListener(_onControllerChanged);
_value = controller.value;                            // no setState: build follows
```

- **controller → null**: the value currently on screen is kept, so the adapter
  continues in uncontrolled mode from where the controlled one left off. My
  round-1 version snapped back to `initialValue`; that was wrong and is gone.
- **null → controller**: re-reads the controller (unchanged, but the `setState`
  is dropped — the framework calls `build` right after `didUpdateWidget`, so
  the `setState` was a wasted second build).
- **controller → other controller**: unchanged (re-read + swap listener).

Two new tests: `dropping the controller keeps the current value` (also asserts
the dropped controller stops driving the widget) and `adding a controller takes
over from initialValue` (also asserts later controller writes still land).

### F2 — locale-part enums moved down, 4 extension members restored

New owner: `primitives/localizations/locale_parts.dart` holds `DatePart`,
`TimePart`, `DurationPart`. `components/utility/locale_utils` keeps only
`formatFileSize` / `SizeUnitLocale` and loses the three enums at migration.

Ported into `ShadcnLocalizationsExtensions`: `datePartsOrder`,
`getDatePartAbbreviation`, `getTimePartAbbreviation`,
`getDurationPartAbbreviation`. `getColorPickerMode` is **not** ported (needs
`ColorPickerMode` from the `color_picker` component, layer 3; 0 call sites) —
deleted as instructed.

**Deviation, needs ratification:** the old enums carry two fields,
`getter` (extracts the component from a `DateTime`/`TimeOfDay`/`Duration`) and
`computeValueRange` (valid min/max given the other components, i.e. month
lengths and leap years). Those fields referenced ~20 private helpers in
`locale_utils.dart` (`_getYear`, `_computeMonthValueRange`, …) and calendar
mathematics, which is not a locale concern. I verified **zero readers**:
`grep -rn 'computeValueRange' components/ | grep -v locale_utils` is empty, and
no consumer writes `part.getter`. The 108 real uses of the three enums outside
`locale_utils` are all switch labels and map keys
(`components/form/object_input/**`). So the enums are ported as plain value
enums and the two fields plus their helpers are dropped. If the calendar range
helpers are wanted back, they belong in the `object_input` component that would
consume them — not in `primitives`.

`ShadcnLocalizationsObjectInputExtensions` was renamed to
`ShadcnLocalizationsExtensions` in round 1 (one owner, one name); unchanged now.

### F3 — all 39 locale tables shipped

`lookupShadcnLocalizations` + `supportedLocales` now cover the full set the old
component shipped: `ar bg bn cs da de el es fa fi fil fr he hi hu id it ja ko mr
ms nb nl pl ps pt ro ru sk sv ta te th tr uk ur vi zh` + `zh_Hant`
(`zh_Hant` is a script variant of `zh`, hence 38 `case` arms).

- Generated with a throwaway Python script (`/tmp/locgen/gen.py`, not
  committed); each output is a normal library file with a real doc comment and no
  `ignore_for_file`.
- The 9 parameterized messages are rewritten to the winning base's signatures
  (`Object?` / `int limit`) with a private `_number()` helper that applies
  `intl.NumberFormat.decimalPattern(localeName)` only when the value is a `num`.
  Dart rejects the narrowing override the generated files used, so this rewrite
  is mandatory, not cosmetic.
- 6 members with no counterpart on the winning English base are dropped from
  every table (`colorPickerTabRecent`, `dataTableColumns`, `dataTableNext`,
  `dataTablePrevious`, `dataTableSelectedRows`, `noSpellCheckReplacements`) —
  nothing is lost, the base never declared them.
- Every table has 103 overrides; `localizations_de.dart` is now script-generated
  too, so the whole set is uniform.
- `zh` resolution follows the old logic: `scriptCode == 'Hant'`, or no script
  plus region `TW`/`HK`/`MO` → traditional; otherwise simplified.
- `localizations_zh_Hant.dart` was renamed to `localizations_zh_hant.dart` —
  `dart format` rewrites non-`lower_case_with_underscores` file names, so this
  is the name that survives the format gate.

**RTL: documented, not handled here.** `ar`, `fa`, `he`, `ps` and `ur` ship
tables, but text direction is not this class's business — Flutter resolves it
from `WidgetsLocalizations` and `Directionality`. The old component carried a
`textDirection` getter on the base that nothing read; it is not ported. Stated
in the doc comment of `localizations.dart` and of every table.

**Structural change:** the delegate and lookup moved out of `localizations.dart`
into `localizations_delegate.dart` (importing 39 tables + the base would have
pushed `localizations.dart` to ~550 lines). `localizations.dart` therefore
`export`s the delegate file, so `ShadcnLocalizations.delegate`,
`ShadcnLocalizationsDelegate` and `lookupShadcnLocalizations` remain reachable
from the one import a consumer already has — the round-2 test file imports only
`localizations.dart` and uses all three, which is what proves it.
This creates a plain Dart import cycle (`localizations.dart` ⇄
`localizations_delegate.dart`); it is legal, analyze-clean and layer-clean.

New tests: `every supported locale loads a translated table` (loops all 39:
delegate supports it, the right class comes back, no string is empty, the
parameterized messages interpolate), `regional variants resolve to their
language table`, `zh picks the table that matches the script and region`,
`an unknown language falls back to English instead of throwing`.

One assertion had to be rewritten during the run: `formBetweenInclusively(1, 2)`
does not contain an ASCII `1` under `bn` — `intl` renders it `১`. The test now
compares two inputs rather than hunting for digits, which is the real invariant.

---

## Round 1 — duplicates merged, which copy won and why

| Symbol | Copies | Winner | Reason |
|---|---|---|---|
| `FormKey` | `shared/primitives` (21 libs/15 comps) vs `form` (5/4) — **diverged** | **merged (superset)** | The `form` copy adds `getValue(FormMapValues)` and `operator []`; the audit says the superset body wins and `FormMapValues` moves with it. `==`/`hashCode` compare only the wrapped key in *both* copies, so `FormKey<String>('x') == FormKey<int>('x')` — preserved and asserted. |
| `ValidationResult`, `ReplaceResult`, `FormValueSupplier`, `FormFieldHandle`, `FormValidationMode` | shared vs `form` | shared copy, doc comments rewritten | Reach (15/13 vs 4/1 components) per PLAN §5 R0. |
| `FormMapValues`, `FormMapValuesExtension` | only in `form/form.dart` | moved into `form_core` | Needed by `FormKey.getValue`. |
| `FormPendingBuilder` / `FormPendingWidgetBuilder` | `shared/utils` (39 libs/33 comps) vs `form` (5/4) — **diverged** | **`shared/utils` copy** | The `form` copy reads `Data.maybeOf<FormController>` + `controller.validities`; `FormController` is owned by the `form` **component** (L3) and a primitive may not import upward — `check_layers layer-direction` would fail. The shared copy is controller-free. |
| `ComponentController`, `ComponentValueController`, `ControlledComponent`, `ControlledComponentAdapter`, `ControlledComponentData`, `_ControlledComponentAdapterState` | `shared/primitives` (20 libs/13 comps) vs `control` (1/1) | **`shared/primitives`** (identical per audit) | PLAN §5 R0 + R3. |
| `_FormEntryCachedValue` | shared vs `form` | **kept verbatim** | The state box `FormValueSupplier` stores its value in. |
| `TextModifier`, `WrappedText`, `WrappedTextDataBuilder`, `WidgetTextWrapper`, `UnorderedListData` | `shared/primitives/text.dart` (25 libs/19 comps) vs `display/text` (11/11) | **shared** | Audit + measured reach. `display/text` declares no `Text` widget at all, only modifiers, and its `meta.json` already says `"tier": "primitive"`. |
| `TextExtension` | same pair — **diverged** | **shared** | Same reach measurement (19 vs 11 components). |
| `_TextThenWidget`, `_RichTextThenWidget` | **diverged** (1,909 vs 699 chars) | **`display/text` bodies absorbed** | Strict supersets: they honour `TextStyle.inherit`, `MediaQuery.boldTextOf`, `SelectionContainer`/`MouseRegion`, `semanticsLabel`, `locale`, `strutStyle`, `textHeightBehavior`, `selectionColor`. Adapted to Flutter 3.47's `RichText(text: InlineSpan)` signature. |
| `getBullet`, `_BulletPainter` | shared only | shared | Disc/square/triangle cycling every 3 levels. |
| `ShadcnLocalizations`, `_ShadcnLocalizationsDelegate` | `shared/localizations` (18 libs/15 comps) vs `components/utility/shadcn_localizations` (42 libs/4 comps) — **diverged** | **`shared/localizations`** | The component copy's 42 "libs" are mostly its own locale data reaching itself. Only 4 real components use it; 15 use the shared copy. |
| locale data (`_impl/locale/shadcn_localizations_*.dart`) | component copy | `localizations_<code>.dart` ×39 | Data only — see F3. |
| `ShadcnLocalizationsExtensions` | `shared/localizations/…extensions.dart` vs `components/utility/shadcn_localizations_extensions/…` | **merged** | Union: the component copy uniquely has `formatNumber` and the three `date*Abbreviation` getters; the shared copy uniquely has the enum-dependent part mappings (F2). Renamed from `ShadcnLocalizationsObjectInputExtensions`. |
| `DatePart`, `TimePart`, `DurationPart` | `components/utility/locale_utils` only | **moved down** to `primitives/localizations/locale_parts.dart` | F2. |

## What the `form` component must import later

```dart
import '../../../registry_next/primitives/form_core/form_core.dart';     // FormKey, FormMapValues, FormValidationMode, ValidationResult, ReplaceResult, FormFieldHandle, FormPendingBuilder, FormPendingWidgetBuilder
import '../../../registry_next/primitives/form_core/form_control.dart';  // ComponentController, ComponentValueController, ControlledComponent, ControlledComponentData, ControlledComponentAdapter
import '../../../registry_next/primitives/form_core/form_value.dart';    // FormValueSupplier
```
Paths as installed; the registry installer rewrites them. `form` declares none
of these names, and `components/form/control/**` is deleted outright.

`text` consumers import `primitives/text/{text,text_extension,list}.dart`.
`localizations` consumers import `primitives/localizations/localizations.dart`
(alone is enough — it re-exports the delegate) plus
`localizations_extensions.dart` for formatting and `locale_parts.dart` for
`DatePart`/`TimePart`/`DurationPart`.

## Deviations from the old code — all deliberate, all listed

1. **`context.mounted` → `mounted`** in `FormValueSupplier`. The old
   post-frame callback read `context.mounted`; on the current SDK `State.context`
   *throws* once the State is defunct, so a replacement arriving after teardown
   crashed. Same precedent as the two P2-A "faithful port of an old bug" fixes
   in `QA_LOG.md`.
2. **`didUpdateWidget` fixes** — see F1.
3. **`then()` no longer supports `SelectableText`.** `SelectableText` lives in
   `packages/flutter/lib/src/material/selectable_text.dart`; there is no
   widgets-library equivalent, and hard rule 4 / `check_layers no-material`
   forbids the import. Verified **0 call sites** in the old registry. `Text` and
   `RichText` are supported; anything else throws `ArgumentError` instead of the
   old bare `Exception`.
4. **`_TextThenWidget` / `_RichTextThenWidget` adapted to Flutter 3.47's
   `RichText`**, which takes a single `text: InlineSpan`
   (`MultiChildRenderObjectWidget`). The absorbed bodies were written against
   the older `style:` + `children:` signature. `MediaQuery.textScalerOf(context)`
   kept for the `Text` path (framework behaviour; the shared copy agreed).
5. **`copyWithStyle` semantics documented, not changed.** The style already on
   the modifier wins where both define a property. My round-1 doc comment
   claimed the opposite; the test caught it and the comment was corrected. Same
   for `TextModifier.call`.
6. **`supportedLocales` grew from `[Locale('en')]` (shared copy) to all 39
   tables** (the component copy's full list). Additive, and F3's instruction.
7. **`DatePart`/`TimePart`/`DurationPart` lost `getter` and
   `computeValueRange`** — 0 readers; see F2.
8. **`getter`-based calendar helpers dropped** (~20 private functions in
   `locale_utils.dart`) — same reason.
9. **`getColorPickerMode` not ported** (layer-3 dependency, 0 call sites).
10. **6 members dropped from every locale table** because the winning English
    base declares no such members.
11. **Old auto-generated doc comments stripped** ("Stores `x` state/configuration
    for this implementation") and replaced with real ones on non-obvious members
    only.
12. **New public API:** `ShadcnLocalizationsDelegate` (was private
    `_ShadcnLocalizationsDelegate`), `lookupShadcnLocalizations`,
    `ShadcnLocalizations.localeName`, 39 `ShadcnLocalizations<Code>` classes,
    `DatePart`/`TimePart`/`DurationPart`, `TextThenExtension` (the `then()` half
    of the old `TextExtension`, split out to stay under 400 lines).

## Open questions

1. **`FormPendingBuilder` can no longer report pending validations.** See the
   merge table. The `form` component must either inline the
   `FormController.validities` fan-out into a private widget of its own (no name
   clash) or form_core gains a pluggable pending source.
2. **40 of 42 → now 0 of 42 skipped, but the `shadcn_localizations_en`
   *component* never existed as data**: English is the base class. The old
   component shipped 42 tables (`ar…zh` + `zh_Hant`); `localizations_<code>.dart`
   now ships the same 39 non-English ones plus the English base. Nothing was
   dropped.
3. **`text` is 3 files, not the 2 the brief suggested.** `text.dart` (353) +
   `text_extension.dart` (379) + `list.dart` (65). Merging would be ~800 lines
   and trip `file-too-long` plus hard rule 7.
4. **`<KIT>/lib/registry_next/primitives/layout.dart` still exists at the kit
   root** — a stray file from the parallel primitives agent (which is why
   `primitives/layout.dart` reported `text.dart: URI doesn't exist`). Not mine,
   not deleted (hard rule 4). That agent should be told.
5. **`rearch/reports/QA_LOG.md` and `OWNERSHIP.md` still not updated** — outside
   my Outputs. Lines to add: these three merges, F1–F3, and the answers to
   questions 1–3.

## Gates (round 2)

```
$ dart format --set-exit-if-changed lib/registry_next/primitives/{form_core,text,localizations} \
      test/registry_next/primitives/{form_core,text,localizations}_test.dart
Formatted 52 files (0 changed)
exit=0

$ dart analyze lib/registry_next/primitives/{form_core,text,localizations}
Analyzing form_core...      No issues found!
Analyzing text...           No issues found!
Analyzing localizations...   No issues found!
$ dart analyze test/registry_next/primitives/{form_core,text,localizations}_test.dart
No issues found!  (x3)

$ flutter test test/registry_next/primitives/{form_core,text,localizations}_test.dart
+75: All tests passed!      (26 form_core, 23 text, 26 localizations)

$ dart run tool/rearch/check_layers.dart --root lib/registry_next
check_layers: 106 files scanned, 0 files with syntax errors
  no-material: 0 (error)
  no-part: 0 (error)
  no-ignore-for-file: 0 (error)
  layer-direction: 0 (error)
  undeclared-dependency: 0 (error)
  file-too-long: 7 (warning)      <- all 7 pre-existing: foundation/icons/*, theme/*
  installable: 0 (error)
  no-impl-dir: 0 (error)

$ dart run tool/rearch/check_single_owner.dart --root lib/registry_next
check_single_owner: 106 files scanned, 297 declarations, 0 files with syntax errors
duplicate names: 0 (public 0, private 0) - identical 0, diverged 0
```

Regression check (my work must not disturb the accepted layers):

```
$ flutter test test/registry_next/{foundation,theme,themes} + my 3 suites
+181: All tests passed!

$ dart analyze lib/registry          # old tree untouched
No issues found!

$ git status --porcelain | grep -E '^ ?M|^M'
NONE
```

**Directory-wide gates still cannot be run clean while the parallel primitives
agent's in-flight files sit in the same folders.** `dart format` over
`lib/registry_next/primitives` + `test/registry_next/primitives` reports
changes in `test/registry_next/primitives/{clickable,popover,zz_debug}_test.dart`,
and `dart analyze lib/registry_next/primitives` reports issues in
`primitives/*.dart` (layout, popover, hover, focus_outline) — all theirs, none
in the three folders I own. `flutter test test/registry_next/primitives` (all
suites) exceeds the 120 s tool timeout on their popover test. The per-folder
runs above are the equivalent evidence for my scope.