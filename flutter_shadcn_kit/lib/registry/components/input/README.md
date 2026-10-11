# Input

A widgets-only text field. `Input` wraps `EditableText` directly: no
Material/Cupertino imports, no `_impl/`, no `part`. The gesture/menu layer and
the reusable field machinery live in `primitives/text_editing/`, the feature
system in `primitives/input_features/`, and form participation in
`primitives/form_core`.

`input` merges the old `input` + `text_field` components and owns the shadcn
name; `autocomplete` (later) depends on `input`, never the other way around.

## When to use

- Any single-line or multi-line text entry: email, password, search, notes.
- Numeric entry with spinner/stepper buttons.
- Form fields: supply a `validator` or plug into a `Form` through the shared
  `FormValueSupplier` machinery.

## Quick start

```dart
import 'package:<your_app>/ui/shadcn/input/input.dart';

const Input(hintText: 'Email');
```

Features are primitives, so import the file that owns the ones you use:

```dart
import 'package:<your_app>/ui/shadcn/primitives/input_features/adornment_features.dart';

Input(
  hintText: 'Password',
  obscureText: true,
  features: const [
    InputPasswordToggleFeature(),
    InputClearFeature(),
  ],
);
```

```dart
import 'package:<your_app>/ui/shadcn/primitives/input_features/numeric_features.dart';

Input(
  keyboardType: TextInputType.number,
  hintText: 'Quantity',
  features: const [InputSpinnerFeature(min: 0, max: 10)],
  validator: (value) => value == '0' ? 'Pick at least one.' : null,
);
```

## Features

Every feature is a const descriptor placed in `features:`. Visibility uses the
`InputFeatureVisibility` enum from
`primitives/input_features/input_features.dart`, composable with `&`, `|`, `~`:

```dart
Input(
  features: [
    InputClearFeature(
      visibility:
          InputFeatureVisibility.focused &
          InputFeatureVisibility.textNotEmpty,
    ),
  ],
);
```

| Feature (primitives/input_features) | Default position | Default visibility | Notes |
|---|---|---|---|
| `InputLeadingFeature` | leading | always | arbitrary widget |
| `InputTrailingFeature` | trailing | always | arbitrary widget |
| `InputAboveBelowFeature(.above/.below)` | below | always | wraps the field |
| `InputHintFeature` | trailing | always | popover + optional F1 |
| `InputClearFeature` | trailing | textNotEmpty | clears via `InputClearIntent` |
| `InputCopyFeature` | trailing | textNotEmpty | select-all + clipboard |
| `InputPasteFeature` | trailing | always | appends clipboard text |
| `InputPasswordToggleFeature` | trailing | always | `PasswordPeekMode.hold`/`toggle` |
| `InputRevalidateFeature` | trailing | always | re-runs `validator` |
| `InputSpinnerFeature` | trailing | always | up/down buttons + drag |
| `InputStepperButtonFeature(.decrement)` | trailing | always | one numeric step |
| `InputAutoCompleteFeature` | — | focused | generic suggestion slot only |

`InputAutoCompleteFeature` is dependency inversion: `input` never imports
`autocomplete`. It calls `suggestions(query)` and hands the result plus a
selection callback to `suggestionMenuBuilder` (widgets + theme types only).
When the builder is null the feature renders nothing.

## Theming

Resolution order per field:
`widget argument > ComponentTheme<InputTheme> tree > input_theme.dart app overrides > inputDefaults`.

| Field | Default |
|---|---|
| `background` | `input` @0.3 rest, @0.5 hovered, @0 disabled |
| `borderColor` / `borderWidth` | `input` token, 1.0; `destructive` while an error shows |
| `borderRadius` | `theme.borderRadiusMd` |
| `padding` | 12 x 8 (density-scaled when density padding is used) |
| `textStyle` | `typography.small` in `foreground` |
| `hintStyle` | `typography.small` in `mutedForeground` |
| `cursorColor` | `primary` |
| `height` | 36 |

The focus ring is drawn by `FocusOutline` (the `ring` token), not by a border
state.

## Primitives this component installs

- `primitives/text_editing/` — `ShadcnSelectionControls`,
  `defaultShadcnContextMenuBuilder`, `EditableTextHost` (controller/focus/state
  ownership + gesture builder), `EditableTextShell` (surface/gesture/disabled
  scaffold), `EditableTextFieldRow`, `EditableTextValidation`. Reused by
  `text_area`, `number_input`, `formatted_input` and `autocomplete`.
- `primitives/input_features/` — the feature framework (`InputFeature`,
  `InputFeatureState`, `InputFeatureVisibility`, `InputFeatureSlots`) plus
  `adornment_features.dart`, `numeric_features.dart` and
  `suggestion_feature.dart`.

## Differences from the old `input` / `text_field`

- One component. The old `text_field` barrel, `TextInputStatefulWidget`,
  `TextInput` mixin, custom gesture/menu glue (~2.5k LOC) and the `part`/`_impl`
  layout are gone.
- Selection handles + context menu are widgets-only (`ShadcnSelectionControls`,
  `defaultShadcnContextMenuBuilder`): Cut/Copy/Paste/Select-all labels come from
  `ShadcnLocalizations`; a read-only field shows the Copy/Select-all subset.
- Dropped `EditableText` params (plain defaults apply): spell-check
  configuration, magnifier configuration, content-insertion configuration,
  `enableIMEPersonalizedLearning`, `stylusHandwritingEnabled`,
  `dragStartBehavior`, `scrollController`/`scrollPhysics`, `strutStyle`,
  selection height/width styles, `clipBehavior`, `restorationId`,
  `textDirection`, `showCursor`, smart dashes/quotes, `onTapUpOutside`,
  `submitFormatters`, `skipInputFeatureFocusTraversal`.
- Dropped `InputFeature.*` factory constructors (clean break); class
  constructors carry the old factory defaults.
- Truly dropped: spell-check UI, `TextFieldClearIntent` menu action (clear
  lives on as the feature button), `select_all_and_copy` /
  `replace_current_word` intents (stock select-all + toolbar cover them),
  magnifier configuration.
- `validator` is the widget-leg validator (`String? Function(String?)`,
  receiving the raw text — `''` when empty); form-level validation still flows
  through `FormValueSupplier` / `FormFieldHandle`.
- Old bugs fixed: `input` no longer depends on `text_field` (install conflict
  removed); spinner `min`/`max` clamping comes from the `input` copy; no
  Material/Cupertino imports.
