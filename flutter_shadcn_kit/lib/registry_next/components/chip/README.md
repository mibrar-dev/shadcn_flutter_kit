# Chip

A compact, deletable-token control (`px-2 py-0.5 text-xs`) plus `ChipButton`,
the borderless control embedded inside a chip (the remove "x", the expand
caret). A chip reuses the `button` component's style table for its per-state
paint, so a chip can never drift from the button colours.

## When to use

- A selected value that the user can remove (with `ChipButton` as its trailing
  remove control).
- A filter or tag selector.

Use `badge` for a read-only label and `toggle` for an on/off button.

## Snippets

```dart
const Chip(child: Text('flutter'));
```

Pressable:

```dart
Chip(onPressed: () {}, child: const Text('pressable'));
```

Removable (what `chip_input`, `select` and `filter_bar` build):

```dart
Chip(
  trailing: ChipButton(
    onPressed: () => setState(() => tags.remove(tag)),
    child: const Icon(LucideIcons.x, size: 12),
  ),
  child: Text(tag),
);
```

## `Chip` API

| Parameter | Type | Default | Notes |
|---|---|---|---|
| `child` | `Widget` | required | label |
| `onPressed` | `VoidCallback?` | null | presence makes the chip interactive |
| `leading` / `trailing` | `Widget?` | null | icons, shown after the label with a `spacing.sm` gap |
| `variant` | `ButtonVariant?` | `secondary` | selects the button style row |
| `padding` | `EdgeInsetsGeometry?` | 8 x 2 | |
| `onHover` / `onFocusChange` | `ValueChanged<bool>?` | null | observation only |
| `focusNode` / `autofocus` | | null / false | as in `Button` |
| `theme` | `ChipTheme?` | null | widget leg of the resolver |

`ChipButton` takes `child`, `onPressed`, `iconSize`, `focusNode`, `autofocus`
and `theme`; it renders the `ghost` button row with no padding.

## Theme resolution

`widget theme > ComponentTheme<ChipTheme> in tree > app overrides
(chip_theme.dart) > chipDefaults`, merged per field.

| `ChipTheme` field | Default |
|---|---|
| `variant` | `ButtonVariant.secondary` |
| `padding` | 8 x 2 |
| `textStyle` | 12px w500; colour comes from the button style |
| `style` | null; extra `ButtonVariantStyle` rows merged over the variant row |
| `buttonPadding` | `EdgeInsets.zero` |
| `buttonIconSize` | 12 |

## Differences from the old `display/chip`

- The old `Chip` passed `onPressed ?? () {}`, so a **read-only chip was still
  an enabled button**: it swallowed taps that no handler answered, showed the
  hover/press rows of its variant and exposed a click cursor. Without
  `onPressed` this chip builds no `Clickable` and paints the variant colours at
  full strength.
- The old padding theme leg was resolved inside a closure that ignored the
  widget value entirely, so a widget style could never change it.
- The old `Chip` passed an `AbstractButtonStyle` and drove `ButtonStyle`
  directly. `ChipTheme` now owns the variant choice and the metrics, and the
  per-state paint comes from `buttonDefaults.forVariant(...)`, so chips and
  buttons cannot diverge.
- `ChipButton` keeps its public name and behaviour: the `chip_input`, `select`
  and `filter_bar` batches import it from here.

## Deleted

`shared/utils/chip_utils.dart` (`isChipCharacter`, `isChipUnicode`) is **not**
ported. It had zero readers in the old tree: it was a private-use tokenizer
helper for chip-style *inputs*, which belong to the `chip_input` batch (B13).
