# ContextMenu

A menu shown at the pointer: right-click on desktop, long-press on touch
platforms. Rows, keyboard traversal and the surface come from the `menu`
component.

## When to use

Use to attach commands to an arbitrary area (canvas, list row, preview).
For a menu owned by a button use `dropdown_menu`; for a menu bar use
`menubar`; for editable text use `primitives/text_editing`
(`defaultShadcnContextMenuBuilder`), which the `input` component wires.

## Snippets

```dart
ContextMenu(
  items: [
    MenuButton(child: Text('Copy link'), onPressed: (_) {}),
    MenuSeparator(),
    MenuButton(child: Text('Reload'), onPressed: (_) {}),
  ],
  child: Card(child: Text('Right-click me')),
);
```

```dart
// Explicit position (e.g. from a custom gesture or a canvas hit):
await showShadcnContextMenu<void>(
  context: context,
  position: pointerPosition,
  children: [MenuButton(child: Text('Inspect'), onPressed: (_) {})],
);
```

## API

| Member | Props |
|---|---|
| `ContextMenu` | `child`, `items`, `behavior` (translucent), `direction` (vertical), `enabled`, `theme: MenuTheme`, `popupTheme: MenuPopupTheme?` |
| `showShadcnContextMenu<T>` | `context`, `position` (global), `children`, `direction`, `theme`, `popupTheme` |

Keyboard: the menu's own engine: arrows, Home/End, Enter/Space, Escape and
typeahead. An outside tap closes the menu without reaching the content
behind it.

## Theme fields

None of its own. Rows resolve `MenuTheme`, the surface
`MenuPopupTheme` (both owned by `menu`; user overrides in
`menu/menu_theme.dart`). Both are accepted as widget-leg overrides.

## Differences from old `context_menu`

- `ContextMenuTheme` (`surfaceOpacity`/`surfaceBlur` only) is deleted with
  the surface fields.
- The editable-text menus (`DesktopEditableTextContextMenu`,
  `MobileEditableTextContextMenu`, `buildEditableTextContextMenu`) are not
  ported; the widgets-only editing menu lives in
  `primitives/text_editing`, and this component is only the
  pointer-positioned row menu.
- `material.dart`, the custom `OverlayManager.showMenu` call and the
  `ContextMenuPopup` public widget are gone; the positioned show helper uses
  the popover primitive (`showPopover(position: ...)`).
- The old `_children` `ValueNotifier` (updated post-frame in
  `didUpdateWidget`) is gone; a stateless wrapper reads the current items
  when the gesture fires.
- Sheet-overlay detection reads the `primitives/sheet_overlay.dart` marker
  directly (no drawer import).
