# Select

A single-selection dropdown picker. The trigger reuses the `button` variant
table and the popover primitive, the popup is the `menu` component's surface
and rows, and the search field is the `input` component.

## When to use

Use for choosing one value from a list. For a search-only suggestion field
use `autocomplete`; for a command palette use `command`; for a plain menu of
actions use `menu`/`dropdown_menu`.

## Snippets

```dart
String? fruit;

Select<String>(
  value: fruit,
  onChanged: (value) => setState(() => fruit = value),
  placeholder: const Text('Select a fruit'),
  itemBuilder: (context, value) => Text(value),
  items: [
    for (final f in fruits) SelectItem<String>(value: f, child: Text(f)),
  ],
);
```

```dart
// Searchable, backed by an async source; search is enabled by `builder`.
Select<Country>(
  value: country,
  onChanged: (value) => setState(() => country = value),
  itemBuilder: (context, value) => Text(value.name),
  searchPlaceholder: const Text('Search countries'),
  builder: (context, query) async {
    final matches = await repository.find(query);
    return [
      for (final c in matches) SelectItem<Country>(value: c, child: Text(c.name)),
    ];
  },
);
```

## API

| Member | Props |
|---|---|
| `Select<T>` | `itemBuilder`, `value`, `onChanged`, `enabled`, `placeholder`, `items`, `builder`, `searchPlaceholder`, `focusNode`, `expandIcon`, `canUnselect` (false), `autoClose` (true), `popupConstraints`, `valueSelectionHandler`, `valueSelectionPredicate`, `theme` |
| `SelectItem<T>` | `value`, `child`, `enabled` |
| `SelectItemsBuilder` | `FutureOr<List<Widget>> Function(BuildContext, String? query)` |

Keyboard: the trigger opens on Enter/Space; the popup uses the menu engine
(arrows wrap, Home/End, Enter/Space activates, Escape closes, typeahead).
The search field takes focus when it is shown.

## Theme fields

`SelectTheme`: `variant` (trigger button row, default outline), `trigger`
(per-state `ButtonVariantStyle` merged over the variant), `popup`
(`MenuPopupTheme` surface override; the class is re-exported by
`select_style.dart`), `itemPadding` (px-2 py-1.5), `constraints` (popup size;
default 192-320 wide, 240 high, always trigger-wide). User overrides live in
`select_theme.dart`.

## Differences from old `select`

- Multi selection is the sibling `multi_select` component (`MultiSelect`,
  `MultiSelectItem`, `MultiSelectChip`); `Select` exposes the selection hooks
  (`valueSelectionHandler`/`valueSelectionPredicate`) it builds on.
- `canUnselect` (click the selected item to clear) and `autoClose` (default
  true for single selection) are restored, and the popup size is themeable
  through `SelectTheme.constraints` / `popupConstraints`.
- The popup family collapsed into `items`/`builder`: `SelectPopup`,
  `SelectItemList`, `SelectItemBuilder`, `SelectItemButton`, `SelectGroup`,
  `SelectLabel`, `EmptySelectItem`, `SelectPopupHandle` are gone.
- `filled`, the trigger `constraints`, `alignment`, `widthConstraint`,
  `overlayConfiguration` and `adaptiveOverlay` are gone; the trigger sizes
  from its parent constraints and the popup opens topCenter at trigger width
  (192 min / 320 max, 240 max height; themeable via `constraints`).
- The scroll-chevron affordances and the Material mouse-cursor override on
  rows are not ported.
- `material.dart` is gone: the old `hide` list (`Theme`, `TextField`,
  `ButtonStyle`, `Chip`, `ErrorWidgetBuilder`) no longer exists.
- The old `_onChanged` returned a bool the trigger ignored; the new
  `_enabled` is the single source of truth for interactivity.
