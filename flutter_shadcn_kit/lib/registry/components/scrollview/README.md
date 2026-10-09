# Scroll View Interceptor

Middle-button drag-to-scroll ("autoscroll") for desktop and web pointer
devices. Holding the middle mouse button anchors the pointer; moving away from
the anchor scrolls the subtree under it, faster the further you drag.

## When to use

- Desktop/web content areas where middle-button autoscroll is expected.
- Wrapping any scrollable subtree without changing its own widget type.

## Snippet

```dart
ScrollViewInterceptor(
  child: SingleChildScrollView(child: content),
);
```

## `ScrollViewInterceptor` API

| Parameter | Type | Default | Notes |
|---|---|---|---|
| `child` | `Widget` | required | the subtree that receives the synthetic scroll events |
| `enabled` | `bool` | true | when false the child renders untouched |

## Behaviour

- A middle-button press starts a ticker; each frame synthesises a
  `PointerScrollEvent` whose delta is the cubed distance from the anchor
  divided by the frame time, clamped to ±10 logical pixels per millisecond.
- The synthetic event is hit-tested at the anchor position, so the scrollable
  under the press point moves.
- The pointer switches to `SystemMouseCursors.allScroll` while active.
- Releasing the middle button (or disabling the widget mid-drag) always ends
  the drag.

## Differences from the old `control/scrollview`

- **Fixed:** releasing the button without moving the pointer left the ticker
  running forever (the old code only deactivated when a move had been seen).
  Every button release now deactivates.
- **Fixed:** disabling the interceptor mid-drag left the ticker and cursor
  active; `didUpdateWidget` now deactivates.
- The `DesktopPointerScrollEvent` subclass (an empty passthrough) is deleted;
  `PointerScrollEvent` is constructed directly.
- The public `pointerMoved` state field and the `{...}`-set hover callback are
  gone.
