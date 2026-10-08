# Menubar

A horizontal bar of menu triggers; each trigger opens its submenu as a
popover below the bar. Rows, keyboard traversal and the popup surface are
the `menu` component's, so a menu opened from the bar matches every other
menu in the app.

## When to use

Use for application-level menu bars (File / Edit / View). For a menu
anchored to one button use `showShadcnMenu`; for right-click use
`context_menu`.

## Snippets

```dart
Menubar(
  children: [
    MenuButton(
      child: Text('File'),
      subMenu: [
        MenuButton(child: Text('New'), onPressed: (_) {}),
        MenuButton(child: Text('Open'), onPressed: (_) {}),
      ],
    ),
  ],
);
```

```dart
// Borderless bar; submenus stay below the bar.
Menubar(
  border: false,
  popoverOffset: const Offset(0, 4),
  children: [...],
);
```

## API

| Prop | Type | Default |
|---|---|---|
| `children` | `List<Widget>` | required |
| `border` | `bool?` | `MenubarTheme.border` (true) |
| `popoverOffset` | `Offset?` | `MenubarTheme.subMenuOffset` (`Offset(-4, 8)`) |
| `theme` | `MenubarTheme?` | widget leg |

Keyboard: one tab stop for the bar. ArrowUp/Down move and wrap between
triggers, Home/End jump, ArrowRight opens the focused submenu, ArrowLeft
closes it, Escape closes one level, typing selects a trigger by prefix.

## Theme fields

`MenubarTheme` is owned by `menu` (B13) and resolved here:
`border`, `background`, `borderColor`, `borderWidth`, `borderRadius`,
`padding`, `subMenuOffset`. User overrides live in
`menu/menu_theme.dart`; row colours resolve `MenuTheme`, the submenu
surface `MenuPopupTheme`.

## Differences from old `menubar`

- The public `MenubarState` is deleted. It had drifted from the copy in the
  old menu module and owned traversal state; `menu_nav.RovingGroup` owns
  traversal now and the bar is stateless.
- `OutlinedContainer` is replaced by a local `DecoratedBox`; `AnimatedPadding`
  became plain padding (no visual dependency on the 150 ms tween).
- `border: false` keeps its old meaning: no border, background or padding.
- The old `MenubarTheme` (background/border/radius/padding/subMenuOffset)
  now lives in `menu_style.dart` with the other menu themes; this component
  declares no theme of its own.
