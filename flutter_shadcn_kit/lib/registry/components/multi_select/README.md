# MultiSelect

A multi-selection dropdown built on `select`. The popup shows checkbox rows
(the `menu` component's `MenuCheckboxItem`) and stays open while several
values are toggled; the trigger shows the selection as removable chips.

## When to use

Use when several values of one list are picked together (tags, filters,
permissions). For one value use `select`; for free text suggestions use
`autocomplete`.

## Snippets

```dart
Iterable<String>? fruits;

MultiSelect<String>(
  value: fruits,
  onChanged: (value) => setState(() => fruits = value),
  placeholder: const Text('Select fruits'),
  itemBuilder: (context, value) =>
      MultiSelectChip<String>(value: value, child: Text(value)),
  items: [
    for (final fruit in options)
      MultiSelectItem<String>(value: fruit, child: Text(fruit)),
  ],
);
```

```dart
// Async + search: `builder` enables the search field.
MultiSelect<Country>(
  value: selected,
  onChanged: (value) => setState(() => selected = value),
  itemBuilder: (context, value) => MultiSelectChip<Country>(
    value: value,
    child: Text(value.name),
  ),
  searchPlaceholder: const Text('Search countries'),
  builder: (context, query) async => [
    for (final c in await repository.find(query))
      MultiSelectItem<Country>(value: c, child: Text(c.name)),
  ],
);
```

## API

| Member | Props |
|---|---|
| `MultiSelect<T>` | `itemBuilder` (trigger chips), `value`, `onChanged`, `enabled`, `placeholder`, `items`, `builder`, `searchPlaceholder`, `focusNode`, `expandIcon`, `canUnselect` (true), `autoClose` (false), `popupConstraints`, `valueSelectionHandler`, `valueSelectionPredicate`, `theme` |
| `MultiSelectItem<T>` | `value`, `child`, `enabled` |
| `MultiSelectChip<T>` | `value`, `child`, `enabled` |
| `multiSelectHandler<T>` | toggle mapping (`valueSelectionHandler`) |
| `multiSelectPredicate<T>` | `contains` test (`valueSelectionPredicate`) |

Keyboard: the select trigger opens the popup; arrows walk the rows,
Enter/Space toggles, Escape closes, typing selects by prefix. The popup
stays open between toggles (`autoClose: false`); a chip's × removes its
value (`canUnselect: true`).

## Theme fields

None of its own; `MultiSelect` forwards `theme: SelectTheme` and the popup
constraints to `select`. See the `select` README for the fields
(`variant`, `trigger`, `popup`, `itemPadding`, `constraints`).

## Notes

- Checkbox rows come from the menu component (`MenuCheckboxItem`), so the
  toggled state and keyboard behaviour match every menu in the app.
- `MultiSelect` is a sibling component of `select` (not a second class in
  it): the popup rows need `menu`/`chip` (layer 3), and `select`'s folder
  budget cannot hold the family. The plan gives different behaviour its own
  small component (toggle vs button, dropdown vs menubar).
