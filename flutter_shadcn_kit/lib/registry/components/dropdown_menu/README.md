# DropdownMenu

A menu anchored below the widget that opened it. Rows, keyboard traversal
and the popup surface come from the `menu` component, so a dropdown is
visually identical to every other menu.

## When to use

Use when a control (button, caret) owns a menu. For a menu inside a popover
use `showShadcnMenu`; for right-click use `context_menu`; for a bar use
`menubar`.

## Snippets

```dart
// Imperative: anchored to the tapped widget.
await showShadcnDropdown<void>(
  context: context,
  children: [
    MenuButton(child: Text('Profile'), onPressed: (_) {}),
    MenuSeparator(),
    MenuButton(child: Text('Sign out'), onPressed: (_) {}),
  ],
);
```

```dart
// Standalone surface (own overlay plumbing):
DropdownMenu(
  children: [MenuButton(child: Text('Profile'), onPressed: (_) {})],
);
```

## API

| Member | Props |
|---|---|
| `DropdownMenu` | `children: List<Widget>`, `theme: MenuPopupTheme?` |
| `showShadcnDropdown<T>` | `context`, `children`, `alignment` (topCenter), `anchorAlignment`, `offset` (0,4), `widthConstraint` (anchorFixedSize), `heightConstraint`, `theme` |

## Theme fields

None of its own. The surface resolves `MenuPopupTheme` and the rows
`MenuTheme` (both owned by `menu`; user overrides in
`menu/menu_theme.dart`). `DropdownMenu` accepts a `MenuPopupTheme` as its
widget-leg override.

## Differences from old `dropdown_menu`

- `DropdownMenuTheme` (`surfaceOpacity`, `surfaceBlur`: the only fields) is
  deleted; those surface fields were dropped with the dialog pilot and the
  surface tokens are menu-owned now.
- `DropdownMenuData`/`regionGroupId` are gone (single popover per menu).
- The `drawer` dependency is gone: sheet-overlay detection reads the
  `primitives/sheet_overlay.dart` marker directly.
- `showDropdown` became `showShadcnDropdown` and returns `Future<T?>`
  instead of an `OverlayCompleter`.
- The old module imported `material.dart` transitively through menu; the new
  chain is widgets-only.
