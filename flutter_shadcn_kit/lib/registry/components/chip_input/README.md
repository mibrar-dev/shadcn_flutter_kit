# `chip_input`

A token field: text typed next to inline chips, each with its own remove
button. Suggestions, validation, form participation and a clipboard round-trip
are all composed — nothing is re-implemented.

```dart
ChipInput<String>(
  hintText: 'Add a tag',
  onChipSubmit: (text) => text.trim().toLowerCase(),
  initialChips: const <String>['flutter'],
  suggestions: (query) => _tags.where((t) => t.startsWith(query)),
);
```

## Old → new

Ported from `lib/registry/components/form/chip_input/**` (1,649 Dart LOC across
14 files, 8 `part` files, a Material `TextField` subclass).

| Old | New |
|---|---|
| `chip_input.dart` + `_impl/state/chip_input_state.dart` (367) | `chip_input.dart` (399) — `ChipInput<T>`, widgets-only, plus `_ChipInputFeature` |
| `_impl/state/_chip_input_preview_state.dart` (81) | `preview.dart` (173) |
| `_impl/themes/**` (252) | `chip_input_style.dart` (153) + `chip_input_theme.dart` (20) |
| `_impl/utils/chip_editing_controller.dart` (545) | `primitives/text_editing/token_editing.dart` (441) |
| `_impl/utils/chip_span.dart` (25) | `primitives/text_editing/token_span.dart` (138) |
| `_impl/utils/chip_clipboard_handler.dart` (345) | `primitives/text_editing/token_clipboard.dart` (157) |
| `_impl/utils/chip_submit_intent.dart` (9) | `ChipSubmitIntent` in `chip_input.dart` |
| `_impl/utils/_chip_provider.dart` (8) | deleted — `TokenEditingController` is the state |
| `meta.json`, `chip_input.meta.json`, `theme.schema.json` | one `meta.json` |

745 component LOC + 736 shared token-primitive LOC = 1,481, against 1,649.

The token machinery lives in `primitives/text_editing/token_*.dart`, not an
`_impl/` folder, because it is generic: any field whose value contains
placeholders (chips, mentions, tags) can reuse it, and it knows nothing about
`Chip`, `Input` or any component theme.

## Fixed defects

1. **The `padding` theme leg read inside a closure that ignored the widget
   value** (the P3-B QA pattern). All four legs now go through
   `resolveComponentStyle<ChipInputTheme, ChipInputTheme>` with a per-field
   `theme` argument, so the widget leg wins.
2. **Copy produced an unreadable string.** The old default separator was `''`,
   so copying `["ab", "cd"]` wrote `abcd`. `PlainTokenClipboardHandler` now
   joins adjacent chips with `', '` (and the round-trip splits on it again).
3. **`DecoratedChipClipboardHandler` had zero callers.** Its prefix/suffix/
   escape grammar was dead code and is not ported; the delimiter behaviour it
   carried (separator on copy, token boundary on paste) is now reachable through
   `PlainTokenClipboardHandler.chipDeserializer`, and `ChipInput` wires it to
   `onChipSubmit` by default.
4. **The controller assigned a Private-Use code unit without registering a
   token.** The value grew an invisible character nobody could remove.
   `TokenEditingController` strips unregistered units and shifts the selection
   to match.
5. **`ChipSpan` carried no token index**, so removing the second of two equal
   values was ambiguous. `TokenSpan` has `index`, and `chipBuilder` receives it
   too.
6. **`InputFeature.onFocusGained` was documented but never called**, so a field
   that starts out with text — or one focused without typing — never told its
   features. `input.dart` now announces it once per focus session; `chip_input`
   is the reader that needs it (tap a populated field, the suggestion list opens
   for the next chip). Covered by two new tests in `input_test.dart`.
7. **`removable: false` dropped the chip wrapper entirely**, so a read-only or
   disabled field rendered its tokens as bare text. `removable` only controls
   the button now.
8. **A disabled or read-only field still accepted `Enter`.** The submit action
   is only registered when the field is editable; copy stays registered (a
   read-only field must serialize chips, not code units) and paste is consumed
   but inert.

## API changes

- `placeholder`, `autofocus`, `textInputAction` and `textCapitalization` are
  gone; the keyboard action is always `done`, and the hint is `hintText`.
- `autovalidateMode` is the registry's `FormValidationMode`.
- `theme` is a `ChipInputTheme` (this component) and `inputTheme` an
  `InputTheme` (the field surface) — two legs, matching the two components
  underneath.
- The old `ClipboardHandler`/`DefaultChipClipboardHandler` names become
  `TokenClipboardHandler`/`PlainTokenClipboardHandler` in the shared primitive.

## Notes

- The token builder runs while `EditableText` paints, so it may not read an
  inherited widget. `ChipInput` resolves the theme and the localized remove
  label during `build` and caches them on the state.
- A controlled list (`chips`) seeds the field on the first build when the
  component owns its controller. With a caller-supplied `controller` it is
  applied from `didUpdateWidget`, so it lands on the parent's *next* rebuild —
  pass one or the other, not both.

## Tests

`test/registry/components/chip_input_test.dart` — 42 tests covering word
submission, backspace-removes-a-chip, the remove button and its localized
label, delimited paste, copy serialization, suggestion acceptance, arrow-key
navigation across tokens, controlled/uncontrolled value, disabled/read-only,
the four theme-precedence legs, the shadcn h-9 minimum height, light/dark, and
unit tests for `token_editing`, `token_span` and `token_clipboard`.
