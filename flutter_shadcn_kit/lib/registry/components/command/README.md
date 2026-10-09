# Command

A command palette: a search field, a debounced asynchronous result stream and
keyboard navigation through the rows. `showCommandDialog` presents it modally;
`Command` composes inline.

## When to use

- Global actions / navigation palettes (Cmd+K style).
- Inline searchable pickers whose results stream in.

## Snippets

```dart
Command(
  builder: (context, query) async* {
    final items = allItems.where(
      (item) => query == null || item.label.contains(query),
    );
    yield <Widget>[
      for (final item in items)
        SubFocusListItem(title: Text(item.label), onTap: item.run),
    ];
  },
);
```

Modal:

```dart
showCommandDialog<void>(
  context: context,
  builder: (context, query) async* => ...,
);
```

Rows are `primitives/subfocus_list_item.dart` widgets; the palette owns the
keyboard traversal (`arrowUp` / `arrowDown` / `enter`) through `SubFocus`.

Rows can carry a shortcut hint in their trailing slot:

```dart
SubFocusListItem(
  title: const Text('Search'),
  trailing: const CommandShortcut(label: '⌘K'),
  onTap: () => search(),
);
```

## API

| Member | Type | Notes |
|---|---|---|
| `Command` | widget | `builder`, `autofocus`, `debounceDuration`, `emptyBuilder`, `errorBuilder`, `loadingBuilder`, `searchPlaceholder`, `theme` |
| `CommandShortcut` | widget | shortcut label: `text-xs`, wide tracking, muted, right-aligned (`label`) |
| `CommandEmpty` | widget | default empty state (localized) |
| `CommandBuilder` | typedef | `Stream<List<Widget>> Function(BuildContext, String? query)` |
| `CommandErrorBuilder` | typedef | `Widget Function(BuildContext, Object, StackTrace?)` |
| `showCommandDialog<T>` | function | modal palette with `constraints` + `CommandTheme.maxWidth/maxHeight` |
| `CommandTheme` | theme | surface, item and dialog-size fields |

## Theme resolution

`widget CommandTheme > ComponentTheme<CommandTheme> in tree > app overrides
(ComponentThemes) > commandDefaults`, per field. The dialog leg passes a
transparent `DialogTheme` so the palette paints its own surface.

## Differences from the old `command`

- Four Material imports (`command_widget`, `command_dialog`, `command_state`,
  `command_item_state`) and the `OutlinedContainer`/`SurfaceCard` blur path are
  gone; the surface paints from `CommandTheme`.
- `CommandItem` moved to `primitives/subfocus_list_item.dart` as
  `SubFocusListItem`, shared with future menu/select lists. A row without
  `onTap` is now truly read-only (the old row dimmed its label but still
  swallowed clicks and showed hover states).
- **Fixed:** stale requests leaked: the old generator kept consuming the
  previous builder stream forever (`continue` instead of stop). A new query now
  cancels the old request.
- **Fixed:** `errorBuilder` was dead (the `StreamBuilder` never checked
  `hasError`). Errors now render the builder's widget or the empty state.
- **Fixed:** the old palette appended a spinner to the list whenever the stream
  was active, so an infinite stream showed a spinner forever.
- Dropped: `CommandCategory`, `CommandKeyboardDisplay` and the keyboard-hint
  footer (apps compose their own headers/footers); `surfaceOpacity` /
  `surfaceBlur` params (glass was removed in the pilots).
- The search field is the `input` component (close button via `Button`), not a
  themed `TextField`, so the palette installs with its declared component deps.
- `CommandShortcut` is ported as a text-only widget (shadcn's
  `text-xs tracking-widest` label); keyboard-key visuals are owned by the
  `keyboard_shortcut` component (B08).
