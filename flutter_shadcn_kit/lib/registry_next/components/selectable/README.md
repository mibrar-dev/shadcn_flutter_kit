# SelectableText

Read-only text that users can select, copy and long-press. Built on the
widgets-layer `EditableText`, so no Material or Cupertino is involved.

The old component delegated to Material's `SelectableText`; this port reuses
`primitives/text_editing` (`ShadcnSelectionControls` handles and the
`defaultShadcnContextMenuBuilder` Cut/Copy/Paste toolbar), which is the same
selection machinery `Input` uses.

## When to use

- Code blocks, logs and diff output the user should be able to copy.
- Rich text (`SelectableText.rich`) with per-span styles.

For editable text use `Input`.

## Snippets

```dart
const SelectableText('Select this text');

SelectableText.rich(
  TextSpan(
    children: <TextSpan>[
      TextSpan(text: 'Bold', style: TextStyle(fontWeight: FontWeight.bold)),
      TextSpan(text: ' and normal text.'),
    ],
  ),
);
```

## API

| Parameter | Default | Notes |
|---|---|---|
| `data` / `textSpan` | required | plain or rich constructors |
| `focusNode` | internal | created and disposed when null |
| `style` | null | merged over theme and `DefaultTextStyle` |
| `showCursor` / `autofocus` | false | |
| `minLines` / `maxLines` | null | asserts guard the pair |
| `cursorWidth` / `cursorHeight` / `cursorRadius` / `cursorColor` | theme | caret |
| `selectionHeightStyle` / `selectionWidthStyle` | tight | selection boxes |
| `enableInteractiveSelection` | true | |
| `selectionControls` | `ShadcnSelectionControls` | |
| `contextMenuBuilder` | shadcn toolbar | |
| `onTap` / `onSelectionChanged` | null | |
| `semanticsLabel` | null | replaces the text semantics |
| `theme` | null | widget-leg `SelectableTextTheme` |

## Theming

`SelectableTextTheme` follows the standard four legs: widget `theme` argument
> nearest `ComponentTheme<SelectableTextTheme>` > app `ComponentThemes` >
`selectableDefaults`. Overrides are values only; see
`selectable_theme.dart`.

## Regression fixed

The old component resolved `this.theme ?? ComponentTheme.maybeOf<...>()`
wholesale: a widget-leg theme that set one field discarded every field of a
scoped or app theme. The new resolution merges per field.
