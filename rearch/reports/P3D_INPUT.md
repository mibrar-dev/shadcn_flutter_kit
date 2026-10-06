# P3-D report: `input` (merged with `text_field`) + text-editing/feature primitives

Status: **done** — QA round 2 restructure applied. All gates green: format
clean, analyzer clean, 301 tests, `check_layers` 0 errors with **no
file-too-long warnings from this brief**, `check_single_owner` 0 duplicates.

## QA round 2 restructure (what changed)

- `primitives/text_editing.dart` became the folder
  `primitives/text_editing/` with the selection controls/menu plus the
  reusable EditableText machinery extracted from `input.dart`.
- The feature system moved from `components/input/input_features.dart` (919
  lines) into `primitives/input_features/`, grouped by responsibility.
- `components/input/input_features.dart` was **deleted**; `input.dart` imports
  the primitives directly and re-exports only its own `input_style.dart`.
- Tests were split: the feature tests moved to
  `test/registry_next/primitives/input_features_test.dart`. Every pre-existing
  test still exists (7 + 11 + 18 = 36 input-related tests; suite total 301).
- `meta.json` deps now name the primitives (`text_editing`, `input_features`,
  `form_core`); README documents the primitive imports.
- Behaviour is unchanged: the extraction is mechanical (host ownership, the
  visual shell/row, validation glue, feature layout), verified by the same
  widget tests.

## Files written

| File | LOC | Contents |
|---|---|---|
| `lib/registry_next/primitives/text_editing/text_editing.dart` | 268 | `ShadcnSelectionControls` (ring-circle handles), `defaultShadcnContextMenuBuilder`, `ShadcnTextSelectionToolbar` |
| `lib/registry_next/primitives/text_editing/editable_text_host.dart` | 226 | `EditableTextHost`: controller/focus/state ownership + swaps, listener wiring, gesture-builder delegate, formatters, append/copy/clear |
| `lib/registry_next/primitives/text_editing/editable_text_shell.dart` | 219 | `EditableTextShell` (surface, gesture detector, focus ring, hover, disabled, error) + `EditableTextFieldRow` (adornments + placeholder) |
| `lib/registry_next/primitives/text_editing/editable_text_validation.dart` | 67 | `EditableTextValidation`: widget-leg validator + `FormValidationMode` |
| `lib/registry_next/primitives/input_features/input_features.dart` | 369 | framework: position, `SuggestionBuilder`, `InputFeatureCondition`/`InputFeatureVisibility` (`& \| ~`), `InputFeatureState`, `InputFeature`, `InputIconFeature`, `InputFeatureIconButton`, `InputFeatureSlots` |
| `lib/registry_next/primitives/input_features/input_feature_host.dart` | 61 | `InputFeatureHostState` mixin: implements the feature contract over an `EditableTextHost` state |
| `lib/registry_next/primitives/input_features/feature_layout.dart` | 68 | `collectInputFeatures` + `InputFeatureLayout` (visible features → leading/trailing/actions/shortcuts) |
| `lib/registry_next/primitives/input_features/adornment_features.dart` | 354 | affixes, above/below, clear/copy/paste, hint, password peek, revalidate + intents + `buildInputActions` |
| `lib/registry_next/primitives/input_features/numeric_features.dart` | 171 | `InputSpinnerFeature`, `InputStepperButtonFeature`, min/max clamping helpers |
| `lib/registry_next/primitives/input_features/suggestion_feature.dart` | 121 | `InputAutoCompleteFeature` generic suggestion slot (no `autocomplete` import) |
| `lib/registry_next/components/input/input.dart` | 379 | public `Input` widget + state wiring only |
| `lib/registry_next/components/input/input_style.dart` | 352 | `InputTheme`, `inputDefaults`, `InputSurface` + `resolveInputSurface` |
| `lib/registry_next/components/input/input_theme.dart` | 22 | user-owned `const inputThemeOverrides` |
| `lib/registry_next/components/input/preview.dart` | 158 | widgets-only gallery |
| `lib/registry_next/components/input/meta.json` / `README.md` | 96 / 165 | manifest + getting-started |
| `test/registry_next/primitives/text_editing_test.dart` | 275 | 7 tests |
| `test/registry_next/primitives/input_features_test.dart` | 426 | 11 tests (visibility + feature tests) |
| `test/registry_next/components/input_test.dart` | 470 | 18 tests (widget wiring/theme/selection/form) |
| `rearch/reports/OWNERSHIP.md` | 1-line edit | T1: audit row 4 now says the spinner `min`/`max` canonical copy is `input/` |

Source total: **2,835 LOC** in 14 files (all ≤400) replacing **7,415 LOC** in
102 old files (`input` 28 files/1,451 LOC + `text_field` 74 files/5,964 LOC).

## What moved down into primitives (for `text_area`, `number_input`, `formatted_input`, `autocomplete`)

| Extracted from `input.dart` | New home |
|---|---|
| controller/focus/states ownership, swaps, listener wiring, gesture-builder delegate, formatters, append/select-all-copy/clear | `text_editing/editable_text_host.dart` |
| build scaffold: decorated container, gesture detector, focus ring, mouse cursor/hover, disabled opacity/ignore, error row | `text_editing/editable_text_shell.dart` |
| adornment row + placeholder (widget or hint text) | `text_editing/editable_text_shell.dart` |
| validator + `FormValidationMode` glue | `text_editing/editable_text_validation.dart` |
| feature framework, visibility composition, host contract, slot store | `input_features/input_features.dart` |
| `InputFeatureState` implementation | `input_features/input_feature_host.dart` |
| visible-feature collection (widgets/actions/shortcuts) | `input_features/feature_layout.dart` |
| concrete features | `input_features/{adornment,numeric,suggestion}_features.dart` |
| theme resolution + surface values | `components/input/input_style.dart` (component-owned style, as before) |

## Old → new mapping (input 28 + text_field 74 files)

| Old | New / fate |
|---|---|
| `input/_impl/core/*_feature.dart` (12) + `text_field` duplicates | `input_features/adornment_features.dart` + `numeric_features.dart` |
| `text_field/_impl/core/input_features_{basic,copy_paste,spinner}.dart` | same two files |
| `text_field/_impl/core/input_features_autocomplete.dart`, `auto_complete*.dart`, suggestion intents/states | later `autocomplete` component; `input_features/suggestion_feature.dart` keeps only the slot |
| feature base/visibility files + 10 visibility classes | `input_features/input_features.dart` |
| `_attached_input_feature.dart` + `input_feature_state.dart` + 12 feature states | `InputFeatureState` host contract + `InputFeatureSlots` + `InputFeatureHostState` |
| `text_field_widget.dart`, `text_input_stateful_widget{,_cont}.dart`, `text_input_mixin.dart`, `text_field_state_part1.dart` | `input.dart` + `text_editing/editable_text_host.dart` + `editable_text_shell.dart` + `editable_text_validation.dart` |
| `text_field_gestures.dart`, custom menu builders, Material/Cupertino selection controls | `text_editing/text_editing.dart` |
| intents (`input_show_hint`, `text_field_*_intent`) | `adornment_features.dart` (`InputClearIntent`, `InputAppendTextIntent`, `InputSelectAllAndCopyIntent`, `InputShowHintIntent`) |
| `text_field/_impl/themes/*` (theme + config + AutoCompleteTheme) | `input_style.dart` + `input_theme.dart`; AutoCompleteTheme moves to autocomplete |
| barrels / re-exports / previews | `input.dart` (imports primitives), `preview.dart` rewritten |

## Deviations from the design (deliberate, with reasons)

1. **No per-feature `createState()`.** Features are stateless descriptors
   building against one `InputFeatureState` host; mutable state lives in
   `slot()`. The design's "one `_InputFeatureState` mixin" intent is kept by
   `InputFeatureHostState` + `InputFeatureSlots`.
2. **Condition composition** uses one closure-backed `_CompositeCondition`.
3. **`InputFeature.*` factories dropped** (clean break); class constructors
   carry the old factory defaults.
4. **meta.json deps** are import-exact: `theme: [color_tokens, density,
   theme]`, `primitives: [form_core, input_features, text_editing]`,
   `foundation: []`; 0 undeclared/unused.
5. **`validator`** is `String? Function(String?)` (raw text, `''` when empty —
   accepted by QA) and `autovalidateMode` uses the real `FormValidationMode`;
   `form_core` has no `FormFieldValidator`. Error text renders below the field.
6. **Hint popover** uses the real `PopoverController`; old alignment values
   ported (visual pass accepted for later).
7. **Revalidate** is a direct `validateNow()`; no `FormPendingBuilder` spinner.
8. **Suggestion slot** renders nothing without `suggestionMenuBuilder`;
   selecting sets the text and calls `onSuggestionSelected`.
9. **Selection handles** stay off the text line (left/right below, collapsed
   above) — a centered cursor handle swallowed the next tap of a double tap.
10. **`rendererIgnoresPointer: true`** so the stock gesture builder owns tap
    sequencing (Material parity).
11. **Feature buttons** are `Clickable`-based (`InputFeatureIconButton`), no
    component imports; toolbar labels are localized.
12. **Disabled** = `Opacity(0.5)` + read-only + `IgnorePointer`.
13. **Programmatic text changes** update the form value/validator but do not
    call `onChanged` (behaviour change vs old spinner; Material parity).
14. **Two helper files inside the prescribed primitive folders**
    (`input_feature_host.dart`, `feature_layout.dart`) keep the framework file
    under 400; they are grouping helpers, not new feature categories.
15. **`InputFeatureIconButton` is public** so the password/spinner features in
    sibling files can share the button.
16. **`meta.json` `theme` section is hand-written** until
    `tool/gen_theme_schema.dart` exists.

## Gates (exact output)

```
$ dart format --set-exit-if-changed lib/registry_next test/registry_next
Formatted 174 files (0 changed) in 0.25 seconds.
exit=0

$ dart analyze lib/registry_next test/registry_next
Analyzing registry_next, registry_next...
No issues found!
exit=0

$ flutter test test/registry_next
00:05 +301: All tests passed!

$ dart run tool/rearch/check_layers.dart --root lib/registry_next
check_layers: 133 files scanned, 0 files with syntax errors
  no-material: 0 (error)
  no-part: 0 (error)
  no-ignore-for-file: 0 (error)
  layer-direction: 0 (error)
  undeclared-dependency: 0 (error)
  file-too-long: 8 (warning)
  unused-dependency: 0 (warning)
  installable: 0 (error)
  no-impl-dir: 0 (error)
exit=0

$ dart run tool/rearch/check_single_owner.dart --root lib/registry_next
check_single_owner: 133 files scanned, 422 declarations, 0 files with syntax errors
duplicate names: 0 (public 0, private 0) - identical 0, diverged 0
exit=0

$ dart run tool/rearch/check_user_theme.dart --root lib/registry_next
check_user_theme: 0 finding(s)
```

The 8 remaining `file-too-long` warnings are all pre-existing
foundation/theme files; none of this brief's files is over 400 lines
(largest: `input_features.dart` 369, `input.dart` 379, tests
`input_features_test.dart` 426 / `input_test.dart` 470 — test files are not
scanned by `check_layers`).

## Test coverage (36 input-related tests)

- `text_editing_test.dart` (7): handle size/anchor; `buildHandle` CustomPaint;
  toolbar labels + callbacks; custom labels; default builder with a real
  `EditableTextState` (Cut/Copy/Paste/Select-all); read-only subset; collapsed
  selection.
- `input_features_test.dart` (11): visibility leaves + `& | ~`; password
  toggle; clear iff non-empty; clipboard mock copy/paste; spinner
  step/clamp/invalidValue; stepper buttons; leading/trailing/above/below;
  hint popover; hint focus visibility; suggestion slot with a mock menu
  builder (and no builder → no menu).
- `input_test.dart` (18): token surface; controller/initialValue assert;
  onChanged/onSubmitted; validator border+message and changed mode;
  disabled dims+blocks; read-only; form participation with a fake
  `FormFieldHandle` + `ReplaceResult`; focus ring; Tab traversal; RTL;
  tap/double-tap/long-press selection; default selection controls; 4-leg theme
  precedence; stacked hovered-only override; dark tokens.

## Open questions / notes for QA

1. Hint popover alignment is ported from the old code; visual pass deferred.
2. `suggestionMenuBuilder` selection sets the whole text; word/append modes
   belong to the later `autocomplete` component.
3. `EditableTextHost` is the intended seam for `text_area`/`number_input`/
   `formatted_input`; `InputFeatureHostState` + `feature_layout.dart` are the
   feature seams. Confirm names before Phase 4.
4. Old-tree migration note: `TextInputStatefulWidget` / `TextInput` are
   deleted with the clean break; old tree untouched until cutover.
