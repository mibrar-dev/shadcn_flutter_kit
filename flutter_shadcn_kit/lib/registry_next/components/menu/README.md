# Menu

Keyboard-navigable menu family: `MenuGroup` (roving focus + typeahead),
actionable rows (`MenuButton`, `MenuCheckboxItem`, `MenuRadioItem`),
static rows (`MenuLabel`, `MenuShortcut`, `MenuSeparator`), submenus
(`MenuSub`), the `showShadcnMenu` helper, and the `MenuPopup` surface.
Owns `MenuPopupTheme` and `MenubarTheme` for the wave-D consumers
(`menubar`, `context_menu`, `dropdown_menu`, `popup`).

## When to use

Use for dropdown menus, context menus, and menubars. For a command palette
use `command`; for a delayed hover label use `tooltip`.

## Snippets

```dart
// A popup menu anchored to a button (needs an Overlay above).
await showShadcnMenu<void>(
  context: context,
  children: [
    MenuButton(child: Text('Cut'), onPressed: (_) {}),
    MenuButton(
      trailing: MenuShortcut(shortcut: '⌘C'),
      child: Text('Copy'),
      onPressed: (_) {},
    ),
    MenuSeparator(),
    MenuSub(
      trigger: Text('Share'),
      children: [
        MenuButton(child: Text('Email'), onPressed: (_) {}),
        MenuButton(child: Text('Link'), onPressed: (_) {}),
      ],
    ),
  ],
);
```

```dart
// Checkbox and radio rows.
MenuCheckboxItem(
  value: checked,
  onChanged: (context, next) => setState(() => checked = next),
  child: Text('Show toolbar'),
);
MenuRadioGroup<String>(
  value: picked,
  onChanged: (context, next) => setState(() => picked = next),
  child: Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      MenuRadioItem(value: 'a', child: Text('Option A')),
      MenuRadioItem(value: 'b', child: Text('Option B')),
    ],
  ),
);
```

## API

| Widget | Props |
|---|---|
| `MenuGroup` | `children: List<Widget>`, `builder` (defaults to a column), `parent`, `direction`, `itemPadding`, `subMenuOffset`, `onDismissed`, `autofocus` |
| `MenuButton` | `child`, `subMenu`, `onPressed: MenuPressedCallback?`, `leading`, `trailing`, `enabled`, `focusNode`, `autoClose`, `theme` |
| `MenuCheckboxItem` | `child`, `value`, `onChanged`, `trailing`, `enabled`, `autoClose` (false), `theme` |
| `MenuRadioGroup` | `value`, `onChanged`, `child` |
| `MenuRadioItem` | `value`, `child`, `trailing`, `enabled`, `autoClose` (true), `theme` |
| `MenuLabel` | `child` |
| `MenuShortcut` | `shortcut` (text-xs, widest tracking, muted) |
| `MenuSeparator` | — |
| `MenuSub` | `trigger`, `children`, `enabled`, `theme` |
| `MenuPopup` | `children`, `theme: MenuPopupTheme?` |
| `showShadcnMenu` | `context`, `children`, `alignment`, `anchorAlignment`, `offset`, `theme`, `popupTheme` |

Keyboard: one tab stop per group; arrows move and wrap; Home/End jump;
Enter/Space activates (toggles checkbox/radio); ArrowRight opens the
submenu; ArrowLeft closes one level; Escape closes one level (all at the
root); typing selects by prefix.

## Theme fields

`MenuTheme`: `background`, `foreground` (per-state; hovered/focused default
to `accent`/`accentForeground`), `itemPadding` (px-2 py-1.5), `textStyle`
(14px), `borderRadius` (sm), `subMenuOffset` (8, -4). `MenuPopupTheme`:
popover surface, 1px border, radius md, padding 4, min-width 192.
`MenubarTheme`: bordered bar for B20.

## Differences from old `menu`

`material.dart` (Divider) gone; `Button`/`ButtonVariance` rows are
`Clickable`; sheet/dialog sniffing deleted; `MenubarState` moved to B20;
`MenuGap` deleted. The traversal engine (`RovingGroup`, `MenuGroupData`,
`MenuNavSlot`) and the resolved-value row surfaces (`RovingRow`,
`MenuPopupSurface`, `showMenuPopover`, `MenuLabel`, `MenuShortcut`,
`MenuSeparator`, `columnMenuBuilder`) live in primitives and are
re-exported here; every row resolves its four theme legs in `menu.dart`.
B20/F1: rows measure the shadcn h-8 = 32 (padding is reserved inside the
minimum) and paint `focus:bg-accent focus:text-accent-foreground`;
`RovingRow` lives in `primitives/roving_row.dart`, re-exported by
`menu_rows.dart`.
Arrow keys reach the engine because the row surface rebinds them to an
unbound intent — the `Clickable` framework traversal would otherwise
swallow them (no wrap, no disabled-skip, no submenu keys).
