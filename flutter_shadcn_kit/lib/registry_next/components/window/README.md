# Window

A desktop-style window frame: draggable title bar, eight resize edges,
minimize / maximize / close buttons, z-order and focus, and edge snapping.
Put one or more `Window`s in a `WindowNavigator`; each is driven by a
`WindowController`.

```dart
final controller = WindowController(bounds: const Rect.fromLTWH(40, 40, 320, 220));

WindowNavigator(
  initialWindows: <Window>[
    Window(
      controller: controller,
      title: const Text('Notes'),
      content: const Text('Drag the title bar; resize from any edge.'),
    ),
  ],
);
```

## API

| Member | Notes |
|---|---|
| `Window(controller, title, actions, content, theme)` | one window; `actions` defaults to `WindowActions()` |
| `WindowController` | bounds, maximized (relative), minimized, alwaysOnTop, closable/resizable/draggable/maximizable/minimizable, enableSnapping, constraints |
| `WindowHandle` | live handle exposed to the title bar via `Data<WindowHandle>` |
| `WindowNavigator(initialWindows, child, theme)` | z-order, focus, snap strips |
| `WindowActions` | default minus / maximize / close buttons |
| `WindowSnapBar` / `windowSnapPresets` | the drag-reveal preset bar and its layouts |
| `WindowTheme` | title bar height, resize thickness, title colour, snap overlay |

Snapping: while dragging, the top strip snaps to full screen, the left /
right strips to the corresponding half, and dragging to the top edge reveals
the preset bar (halves, 70/30, thirds, 2-3-2, quarters). Hovering a preset
previews it and releasing applies it. `WindowController.maximized` stores the
target as a relative rect (`Rect.fromLTWH(0, 0, 0.5, 1)` = left half); set
`WindowNavigator(showTopSnapBar: false)` to disable the bar.

## Differences from the old `layout/window`

- One widget: the old `Window` data object and `WindowWidget` renderer are
  merged into `Window`, and a controller is now required (the old
  uncontrolled constructor's fields became `WindowController` arguments).
- The old snapshot `Window.closed`/`Window.handle` accessors are gone; close
  through `WindowHandle.close()` and read state from the controller.
- Snap bar presets (the six top-bar layouts) are dropped; edge snapping to
  full/left-half/right-half remains. The old presets were 250 lines of
  hardcoded layouts.
- `WindowNavigatorHandle`/`WindowViewport` navigator field is now the
  `WindowManager` interface; `isFocused`/`push`/`focus`/`unfocus`/`remove`/
  `setAlwaysOnTop` behave the same.
- Material `Icons` and the two Material imports are gone (Lucide icon set).
- The window model and host live in `primitives/window_manager.dart` and
  `primitives/window_host.dart` (file budget); `window.dart` re-exports them.
- Bugs fixed: dual `maximized` update paths in the controller, `WindowActions`
  throwing on a detached handle, ghost navigator entries when `close()` raced
  the exit animation, and the 0x0 viewport flash on first layout.
