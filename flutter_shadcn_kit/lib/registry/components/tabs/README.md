# Tabs

Pill tab strip with roving arrow-key navigation, plus a sortable IDE-style
tab pane over a content card. Widgets-only, built on `primitives/clickable`,
`primitives/roving_group`, `primitives/tab_container`, `FadeScroll` and the
`sortable` component.

## When to use

- Switch between a few views of equal weight (`Tabs`).
- IDE-style document tabs with drag-reorder (`TabPane`).
- Custom strips: compose `TabContainer` + `TabItem` + `TabButton` directly.

For page hierarchies use `breadcrumb`; for wizards use `steps`.

## Snippets

```dart
Tabs(
  index: index,
  onChanged: (i) => setState(() => index = i),
  children: const [
    TabItem(child: Text('Account')),
    TabItem(child: Text('Password')),
  ],
);
```

```dart
TabPane<String>(
  items: tabs,
  focused: focused,
  onFocused: (i) => setState(() => focused = i),
  onSort: (next) => setState(() => tabs = next),
  itemBuilder: (context, item, i) => Text(item.data),
  child: Editor(document: docs[focused]),
);
```

## API

- `Tabs(index, children, onChanged, expand, theme, containerTheme)` —
  strip h-9 = 36 (p-[3px]); triggers h-30, px-2, text-sm. Null `onChanged`
  disables.
- `TabPane(items, itemBuilder, focused, onFocused, onSort, theme,
  containerTheme, child)` — null `onSort` renders a static bar.
- `TabContainer(selected, onSelect, children, builder, childBuilder)` —
  assigns indices to `TabItem` children; non-indexed children pass through.
- `TabButton(child, onPressed, ...)` — tight pressable, no minimum size.
- `itemBuilder` returns the plain tab content (a `TabItem` there would read
  tab data outside the container scope in the drag ghost and crash).
- Themes: `TabsTheme` (strip), `TabPaneTheme` (bar + card),
  `TabContainerTheme` (default builders, forwarded by `Tabs`/`TabPane`).

## Differences from old tabs / tab_container / tab_pane

- Three dirs merge into one; `TabList` (underline look) is deleted —
  shadcn default is the pill. The 21 shared names are defined once in
  `primitives/tab_container.dart`.
- `TabPane` fixes: reorder copies the list (old mutated `widget.items`
  in place); the scroll controller is disposed; focus tracking compares
  indices (old compared `widget.focused == value.data`, index vs data).
- Hardcoded light colors (`0xFFF5F5F5`, `0xFF171717`, ...) become tokens;
  the old `Colors.white.withAlpha(0)` fade gradient is gone: `FadeScroll`
  is an alpha-only `dstIn` mask now and takes no colours.
- `TabChildWidget`/`KeyedTabChildWidget`/`KeyedTabItem` wrappers are gone
  (zero consumers); `TabItem` covers indexed tabs. Material
  `VerticalDivider` separators become 1px token boxes.
- Old `TabButton` wrapped `Button` (28–40px minima + padding broke tab
  metrics); the new one is `Clickable`-based with no minimums.
