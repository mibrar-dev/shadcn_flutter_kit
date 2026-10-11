# Drawer

Modal panel that slides in from a screen edge, plus a `sheet` variant that
expands along its edge. Follows the `dialog` pilot: one `ModalRoute` on the
Navigator, widgets-only, no Material/Cupertino.

## When to use

- Side navigation, filters or detail panels that need to cover content.
- A bottom/top sheet that can be dragged away.

For a small confirmation use `dialog`; for transient feedback use `toast`.

## Snippets

Side drawer:

```dart
await openDrawer<void>(
  context: context,
  position: OverlayPosition.end,
  builder: (context) => DrawerContent(),
);
```

Draggable sheet that expands along its edge:

```dart
openSheet<void>(
  context: context,
  draggable: true,
  maxSize: 240,
  builder: (context) => SheetContent(),
);
```

Close from inside the content:

```dart
closeDrawer(context, 'result');
```

## API

| Function | Returns | Notes |
|---|---|---|
| `openDrawer<T>` | `Future<T?>` | completes with `closeDrawer`'s value |
| `openDrawerOverlay<T>` | `DrawerOverlayCompleter<T?>` | handle with `remove()` / `future` |
| `openSheet<T>` | `Future<T?>` | `expands: true`, `draggable: false` by default |
| `openSheetOverlay<T>` | `DrawerOverlayCompleter<T?>` | sheet handle |
| `closeDrawer<T>(context, [result])` | `Future<void>` | pops the nearest drawer |
| `closeSheet<T>(context, [result])` | `Future<void>` | alias of `closeDrawer` |

Common parameters: `position` (`OverlayPosition.left/right/top/bottom/start/end`),
`expands`, `draggable`, `barrierDismissible`, `useSafeArea`, `showDragHandle`,
`borderRadius`, `maxSize`, `barrierLabel`, `useRootNavigator`, `routeSettings`,
`theme` (widget leg).

The barrier is `black @ 50%` by default (shadcn `bg-black/50`), dismisses on tap
and Escape, traps Tab, and restores the opener's focus on close. A sheet's
content is marked with the `primitives/sheet_overlay` marker so a `Card` inside
it drops its chrome.

## Theme resolution

`widget (theme:) > ComponentTheme<DrawerTheme> in tree > app overrides
(drawer_theme.dart through ComponentThemes) > drawerDefaults`, merged per field
with receiver-wins `Mergeable.merge`. The panel resolves the theme live, so a
light/dark or preset switch restyles an open drawer.

| `DrawerTheme` field | Default |
|---|---|
| `background` / `foreground` | `background` / `foreground` |
| `borderColor` / `borderWidth` | `border` / `1` |
| `borderRadius` / `shadows` | null → ambient `radiusLg` / `shadowLg` |
| `padding` | `EdgeInsets.all(24)` |
| `barrierColor` | black @ 50% |
| `maxSize` | `320` |
| `showDragHandle` / `dragHandleSize` / `dragHandleColor` | `true` / `Size(36,4)` / `muted` |
| `transitionDuration` | `250ms` |

## Differences from the old drawer (`registry/components/overlay/drawer`)

- One show path: a widgets `ModalRoute` (the old `DrawerOverlay` layer stack,
  `DrawerLayerData`, `MountedOverlayEntryData` and `BackdropTransformData` are
  gone). Backdrop scaling is dropped; it belongs to a future backdrop primitive.
- The `package:flutter/material.dart` and `data_widget` / `gap` imports are gone.
- `SheetOverlayHandler` is no longer owned here; consumers read
  `SheetOverlayMarker` from `primitives/sheet_overlay`, never from `drawer`.
- The `surfaceOpacity` / `surfaceBlur` glass fields are dropped.
- The reusable route/shell machinery lives in `primitives/drawer_route/` so the
  component files stay within the layout budget.

## Getting started

1. Install the component (`flutter_shadcn add drawer`) or copy the folder into
   `lib/ui/shadcn/drawer/`.
2. Import `drawer.dart`; it re-exports `DrawerTheme`, `OverlayPosition`,
   `DrawerOverlayCompleter` and `drawerDefaults`.
3. App-wide overrides go in `drawer_theme.dart`; per-subtree overrides use
   `ComponentTheme<DrawerTheme>(data: ..., child: ...)`.
