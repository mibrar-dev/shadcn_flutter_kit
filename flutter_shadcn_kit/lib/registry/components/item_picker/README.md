# ItemPicker

Field that edits a value by picking one item from a collection. The trigger
shows the current pick (or a placeholder); tapping it opens a dialog (the
default) or popover prompt where a tap selects and closes. Built on the
`ObjectFormField` primitive, so it reports values to `ShadcnForm` like any
other field. Widgets-only.

## When to use

- Picking one of a small set: colors, icons, templates, avatars.
- A custom alternative to a dropdown when the choices need rich visuals.

For free-text-plus-suggestions use `autocomplete`; for large lists in a
menu use `select`.

## Snippets

Minimal:

```dart
ItemPicker<Color>(
  items: ItemList([red, green, blue]),
  value: selected,
  placeholder: const Text('Pick a color'),
  builder: (context, color) => ColorDot(color),
  onChanged: (color) => setState(() => selected = color),
);
```

List layout in a popover:

```dart
ItemPicker<String>(
  items: const ItemList(['Small', 'Medium', 'Large']),
  layout: ItemPickerLayout.list,
  mode: PromptMode.dialog,
  value: size,
  builder: (context, item) => ItemPickerOption<String>(
    value: item,
    label: Text(item),
    child: const Icon(LucideIcons.tag, size: 16),
  ),
  onChanged: setSize,
);
```

One-shot dialog without a field:

```dart
final icon = await showItemPickerDialog<IconData>(
  context,
  title: const Text('Choose icon'),
  items: ItemList(icons),
  builder: (context, icon) => Icon(icon),
);
```

## `ItemPicker` API

| Parameter | Type | Default | Notes |
|---|---|---|---|
| `items` | `ItemChildDelegate<T>` | required | `ItemList` or lazy `ItemBuilder` |
| `builder` | `ItemPickerBuilder<T>` | required | item visual; wrap in `ItemPickerOption` for selection chrome |
| `value` | `T?` | null | current pick |
| `onChanged` | `ValueChanged<T?>?` | null | null disables the field |
| `layout` | `ItemPickerLayout` | grid | `ItemPickerLayout.grid` (4 cols) or `.list` |
| `placeholder` | `Widget?` | null | trigger content while unpicked |
| `title` | `Widget?` | null | dialog prompt heading |
| `mode` | `PromptMode` | dialog | dialog or popover presentation |
| `constraints` | `BoxConstraints?` | theme | items-box bounds |
| `theme` | `ItemPickerTheme?` | null | widget-leg override |

`showItemPicker` opens an anchored popover and completes with the pick;
`showItemPickerDialog` opens a modal dialog and completes with the pick.

## Differences from old `item_picker`

- `ObjectFormField` now comes from `primitives/form_core` (no `form`
  component dependency); `ModalBackdrop`/`ModalContainer` are gone (the
  dialog shell paints the surface, the popover path uses `Card`).
- `IconButton` options become `Button` (the old widget was deleted);
  `AbstractButtonStyle` params become `ButtonVariantStyle`.
- `GridItemPickerLayout.call` is deleted; pass a new layout instead.
- `ItemBuilder` (lazy/infinite delegate) is deleted: prompts are bounded.
- Selection reports live (`immediateValueChange: true`): a tap calls
  `onChanged` and closes, in both modes.
