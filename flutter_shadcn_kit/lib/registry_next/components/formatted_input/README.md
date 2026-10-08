# FormattedInput

Masked/segmented field: a phone number, a date, a card number, a PIN. Static
separators sit between small editable segments, and the whole field is one
value.

Widgets-only. The segment machinery (controllers, focus order, value model)
lives in `primitives/text_editing/segmented_editing.dart` and
`segmented_value.dart`, so the component folder holds the widget, its style and
its theme.

## When to use

- Phone / date / card / PIN entry where each segment has a fixed length.
- Any field whose visible text is a mask over a shorter underlying value.

For free-form text use `input`; for a step-by-step wizard use `stepper`.

## Snippets

```dart
FormattedInput(
  initialValue: const SegmentedValue([
    SegmentPart.editable(length: 3, width: 32, placeholder: Text('555')),
    SegmentPart.separator(' ('),
    SegmentPart.editable(length: 3, width: 32, placeholder: Text('123')),
    SegmentPart.separator(') '),
    SegmentPart.editable(length: 4, width: 36, placeholder: Text('4567')),
  ]),
  validator: (text) => (text ?? '').replaceAll(RegExp(r'[^0-9]'), '').length == 10
      ? null
      : 'Enter a full number.',
);
```

Controller mode, for a field whose value other widgets also read:

```dart
final controller = FormattedInputController(_phone);
FormattedInput(controller: controller); // controller.value.text -> '555 () 4567'
```

## API

| Type | Notes |
|---|---|
| `FormattedInput` | `controller` **or** `value` + `onChanged`, `initialValue`, `leading`, `trailing`, `enabled`, `validator`, `autovalidateMode`, `theme` |
| `FormattedInputController` | `ValueNotifier<SegmentedValue>`; the value of a controller-driven field |
| `SegmentPart` | `.editable(length:, width:, value:, obscureText:, placeholder:, inputFormatters:)` and `.separator(' / ')` |
| `SegmentedValue` | the parts + each segment's value; `text`, `values`, `withValue(index, value)`, `hasShape(parts)` |
| `TextSegment` / `SegmentedTextController` | the segment primitive: one controller and focus node per segment |

The field is **controlled** when you pass `value` + `onChanged`; it reports the
next value and you decide whether to apply it. Pass `controller` (with no
`value`/`onChanged`) for uncontrolled-with-listener, or `initialValue` alone
for a purely uncontrolled field.

Keyboard:

- Typing a full segment hands the focus to the next one; <kbd>Enter</kbd>
  does the same from anywhere in a segment.
- <kbd>Backspace</kbd> or <kbd>←</kbd> at the start of a segment steps back to
  the previous one.
- <kbd>→</kbd> at the end of a segment steps forward.

A `SegmentPart.editable` gets a `LengthLimitingTextInputFormatter` for its
`length` automatically, plus whatever `inputFormatters` you pass (digit-only
masking, and so on).

## Theme resolution

`widget (theme:) > ComponentTheme<FormattedInputTheme> in field > app
overrides (formatted_input_theme.dart through ComponentThemes) >
formattedInputDefaults`, merged per field with receiver-wins
`Mergeable.merge`.

| `FormattedInputTheme` field | Default |
|---|---|
| `background` | `input` at 30% |
| `hoveredBackground` | `input` at 50% |
| `borderColor` | the `input` token |
| `borderWidth` | 1 |
| `borderRadius` | `theme.borderRadiusMd` |
| `padding` | `8 x 4` (scaled) |
| `height` | 36 (the shadcn input height) |
| `textStyle` | `text-sm` + `mono` |
| `placeholderStyle` | `text-sm` muted |
| `separatorStyle` | the segment style in `mutedForeground` |
| `leadingGap` | 8 (scaled) |
| `partGap` | 0 |

A disabled field is wrapped in `Opacity(0.5)` and `IgnorePointer`, and its
segments become `readOnly`.

## Validation

`validator` receives the **joined** text (separators included), so a digit
count has to strip them first — see the snippet above. `autovalidateMode` is
`FormValidationMode.initial`, `changed` (default) or `submitted`. Once an error
is on screen it stays live in every mode, so it clears as soon as the value
becomes valid instead of sticking.

## Fixed bugs (old `registry/components/form/formatted_input`)

- The old tree was **2,084 lines across 23 files** of `part` files, with a
  `// ignore_for_file` list on nearly every one of them (including
  `dead_code` and `deprecated_member_use`). It is now 4 files.
- **Every keystroke was dropped in controller mode.** The mirror value was
  seeded from `value ?? initialValue` only, so a controller-driven field wrote
  its next value into an empty `SegmentedValue` — the part list was lost and the
  controller always read back as `''`.
- **A same-shape value swap tore down every segment.** The rebuild check
  compared the whole part list including values, so each parent rebuild (every
  keystroke in controlled mode) disposed the live `TextEditingController`s and
  lost the caret. `SegmentedValue.hasShape` compares the *shape* only; a value
  swap now flows through the existing controllers.
- **Backspace at the start of a segment did nothing.** The key handler looked
  the segment up by node identity, but `Focus.onKeyEvent` is invoked on the
  *handler's* node, not the primary focus, so the lookup always returned `-1`.
  It now finds the focused segment by focus.
- **A visible error could never clear.** `FormValidationMode.initial` and
  `submitted` validate once; the error stayed on screen while the user fixed
  the field. A shown error now revalidates on every change.
- **`SegmentPart.editable(inputFormatters:)` was ignored** — the widget passed
  `part.segment.formatters()`, and `SegmentPart.segment` never copied the
  formatters across, so a digits-only mask silently did nothing.
- The dead cross-part drag selection (`_FormattedSelectionCoordinator`'s
  `onDragStart`/`onDragUpdate`/`onDragEnd`, `_estimateOffset`, `_dragging`,
  `_dragAnchorPart`, `_dragAnchorOffset`) was never wired to a gesture hook —
  the file says so itself — and walked the live element tree on every call to
  find mounted states. It is dropped; `SegmentedTextController` keeps focus
  tracking, `selectAll` and `selectedText` without the tree walk.
- The composing region lost its underline in the port: the old
  `_EditablePartController` styled `textInside` with `TextDecoration.underline`
  and the first port concatenated the three composing spans with no style.
- The filler `_` padding used `theme.colorScheme.mutedForeground` (a non-token
  colour) and `max(0, …)`; it now resolves `ShadcnTheme.of(context).colors
  .mutedForeground` and clamps.
- `FormattedObjectInput` (and its `_impl` state + controller) is dropped; see
  below.

## Not carried over

- **`FormattedObjectInput`** built a whole object out of several masked fields
  with its own state class and controller. B21 should compose `FormattedInput`
  with `ObjectFormField` instead, so no caller loses the capability.
- **`WidgetPart`** — a part whose content is an arbitrary widget, which made
  the value model describe layout as well as data. Use `leading`/`trailing` for
  decoration.
- **Per-part `FormKey` wiring.** Every segment used to register its own form
  entry; the field registers one `SegmentedValue` now, so a form reports one
  error for one field.
- **`onPartsChanged`, `readOnly`, `autofocus`, `maxLengthEnforcement` and the
  per-part widget list.** Read-only comes from `enabled: false`; autofocus is
  not meaningful when the field owns N focus nodes; the length enforcement mode
  is not used by any shadcn text field.
- **Cross-part select-all / copy and the `Copy` context-action override.**
  `SegmentedTextController.selectAll`/`selectedText` remain available for a
  caller that wants them.

## Getting started

1. Install the component (`flutter_shadcn add formatted_input`) or copy the
   folder into `lib/ui/shadcn/formatted_input/`.
2. Import `formatted_input.dart`; it re-exports `SegmentPart`, `SegmentedValue`
   and the theme API.
3. App-wide overrides go in `formatted_input_theme.dart`; per-field overrides
   use `ComponentTheme<FormattedInputTheme>(data: ..., child: ...)`.
