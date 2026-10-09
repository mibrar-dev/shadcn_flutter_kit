# Scrollable Client

A two-dimensional scroll surface. The `builder` receives the current offset
and the viewport size, so content can translate itself, zoom, or virtualise
without exposing a `Viewport`.

## When to use

- Pan/zoom canvases, tile grids and boards that scroll on both axes.
- Any layout that needs the live offset/size inside its own build.

## Snippet

```dart
ScrollableClient(
  builder: (context, offset, viewportSize, child) {
    return Transform.translate(
      offset: Offset(-offset.dx, -offset.dy),
      child: child,
    );
  },
  child: SizedBox(width: 640, height: 420, child: canvas),
);
```

## `ScrollableClient` API

| Parameter | Type | Default | Notes |
|---|---|---|---|
| `builder` | `ScrollableBuilder` | required | receives `(context, offset, viewportSize, child)` |
| `child` | `Widget?` | null | handed through to `builder` |
| `primary` | `bool?` | inferred | primary controller inheritance for `mainAxis` |
| `mainAxis` | `Axis` | vertical | axis that inherits the primary controller |
| `verticalDetails` / `horizontalDetails` | `ScrollableDetails` | default vertical/horizontal | controllers, physics, direction |
| `diagonalDragBehavior` | `DiagonalDragBehavior?` | none | |
| `dragStartBehavior` | `DragStartBehavior?` | start | |
| `keyboardDismissBehavior` | `ScrollViewKeyboardDismissBehavior?` | manual | `onDrag` unfocuses while dragging |
| `clipBehavior` | `Clip?` | hardEdge | |
| `hitTestBehavior` | `HitTestBehavior?` | opaque | |
| `overscroll` | `bool?` | false | offsets may leave the content bounds |
| `theme` | `ScrollableClientTheme?` | null | widget leg of the resolver |

## Theme resolution

`widget theme > ComponentTheme<ScrollableClientTheme> in tree > app overrides
(scrollable_client_theme.dart) > scrollableClientDefaults`, merged per field.

## Differences from the old `layout/scrollable_client`

- **Fixed:** `ScrollableClientViewport` only overrode `createRenderObject`;
  the render object kept its first delegate, offsets, clip behaviour and
  `overscroll` flag, so changing the `child`/`builder` or any runtime flag was
  silently ignored. It now overrides `updateRenderObject` (with a public
  `overscroll` setter on the render object) and rebuilds the child.
- `ScrollableClient.theme` previously replaced the tree lookup
  (`this.theme ?? ComponentTheme.maybeOf`), skipping the app-level leg; the
  four-leg resolver now merges all of them.
- The render object clamps with `primitives/scroll_metrics.dart`
  (`clampScrollPixels` / `maxScrollExtentFor`), which also fixes the negative
  maximum that the old inline `min(pixels, content - viewport)` could produce
  when the content is smaller than the viewport.
- The duplicate `ScrollableClient*` fork in `layout/scrollable` is deleted;
  this directory is the single owner of `ScrollableClient`, `ScrollableBuilder`,
  `ScrollableClientViewport`, `RenderScrollableClientViewport` and
  `ScrollableClientTheme`.
