# Sortable (`sortable`)

Drag-and-drop reordering primitives. A `SortableLayer` coordinates the drag
sessions between its `Sortable` descendants and renders the ghost; each
`Sortable<T>` reports which of its four edges the dragged item is over, and
calls the matching accept callback on drop.

## Install

```bash
flutter_shadcn add sortable
```

## Import

```dart
import 'package:<your_app>/ui/shadcn/sortable/sortable.dart';
```

## Minimal example

```dart
SortableLayer(
  child: Column(
    children: [
      for (final item in items)
        Sortable<String>(
          key: ValueKey(item),
          data: SortableData(item),
          onAcceptTop: (data) => move(data.data, item, above: true),
          onAcceptBottom: (data) => move(data.data, item, above: false),
          child: Text(item),
        ),
    ],
  ),
)
```

## API

- `SortableLayer` — required ancestor; owns the sessions, renders the ghost
  and settles it into place on drop. `dropDuration` (default 200ms) and
  `dropCurve` (default `easeOut`) control the settle; `Duration.zero` or
  `MediaQuery.disableAnimations` skips it. `lock` clips the layer.
- `Sortable<T>` — a draggable item with `canAccept*` predicates and `onAccept*`
  callbacks for the top/left/right/bottom edges, plus `ghost`, `fallback`,
  `candidateFallback`, `onDragStart/End/Cancel` and `onDropFailed`.
- `SortableDragHandle` — starts the parent `Sortable`'s drag from a specific
  child.
- `SortableData<T>` — the value wrapper identifying the dragged item.

## Behaviour

- Dragging is a pan gesture; the ghost is positioned in the layer from the
  item's layer-space bounds (`primitives/drag_sort`).
- The edge under the pointer is resolved by `resolveDragDropEdge`; a target
  with one accepted edge always reports that edge, a target with both compares
  against the midpoint.
- `candidateFallback` replaces the hovered item while it is the candidate;
  `fallback` (or a 40% opacity child) replaces the source while dragging.

## Deviations from the old component

- The `form/sortable` stub (which threw) is deleted; its change model
  (`ListChange`/`ListChanges`) is superseded by `primitives/drag_sort`'s
  `ReorderChange`/`ReorderChanges`.
- `SortableDropFallback` and the drop placeholder slot are dropped (no
  consumers); `SortableLayer.ensureAndDismissDrop` / `dismissDrop` are gone.
- The session/layer machinery lives in `primitives/sortable_layer.dart` because
  the component files must stay within the layout budget.
