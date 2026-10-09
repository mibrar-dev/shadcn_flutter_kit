# Resizable (`resizable`)

Split panes with draggable dividers. Panes size themselves either absolutely
(`defaultSize`) or proportionally (`flex`), and can carry min/max constraints,
a collapsed size and an external controller.

## Install

```bash
flutter_shadcn add resizable
```

## Import

```dart
import 'package:<your_app>/ui/shadcn/resizable/resizable.dart';
```

## Minimal example

```dart
SizedBox(
  width: 400,
  height: 240,
  child: ResizablePanelGroup(
    children: const [
      ResizablePanel(defaultSize: 140, child: Text('Sidebar')),
      ResizableHandle(withHandle: true),
      ResizablePanel(flex: 1, child: Text('Main')),
    ],
  ),
)
```

## API

- `ResizablePanelGroup` — lays panes and handles along `direction`.
- `ResizablePanel` — one pane: `defaultSize` (absolute) or `flex`
  (proportional), plus `minSize`, `maxSize`, `collapsedSize`, `collapsed` and
  an optional `controller`.
- `ResizableHandle` — a draggable divider between two panes. The default is a
  1px themed line with a 10px hit area; `withHandle: true` draws a grip bar.
  It is focusable: arrow keys move it 10px, Home/End move it to the extremes.
  Its semantics label comes from `ShadcnLocalizations.resizableHandle`.
- `ResizablePaneController` — absolute/flexible pane state; `setSize`,
  `setFlex`, `collapse`, `expand`. Provide exactly one of `size`/`flex`.
- `ResizableTheme` — divider colour/thickness, hit area and grip.

## Behaviour

- A drag borrows space from the neighbouring pane through
  `foundation/resizer`; min/max and `collapsedSize` are respected.
- Hovering or dragging a divider highlights it (`handleColor.hovered`/
  `pressed`) and shows the grip.
- A collapsed pane renders at `collapsedSize` (or 0) until expanded.

## Deviations from the old component

- The custom `RenderBox`, the Material `Divider`/`VerticalDivider` defaults and
  the `data_widget` channel are gone; layout uses `LayoutBuilder` + `Stack`.
- `ResizablePanel` / `ResizablePanelGroup` replace `ResizablePane` /
  `ResizablePanel` (shadcn naming); the `HorizontalResizableDragger` /
  `VerticalResizableDragger` pair is replaced by `ResizableHandle`.
- `AbsoluteResizablePaneController` / `FlexibleResizablePaneController` merge
  into `ResizablePaneController`; `PanelSibling` and the `tryExpand` /
  `tryCollapse` helpers are dropped (use the controller directly).
- The pane controller model lives in `primitives/resizable_pane.dart` and the
  handle in `primitives/resizable_handle.dart` because the component files must
  stay within the layout budget.
