# Drawer Container (`drawer_container`)

Reusable drawer/sheet chrome: edge border, rounded outer corners, an optional
drag handle and an optional barrier wash. It is the bare container behind
pinned sheets and custom drawer overlays — it owns the visuals, not the drag
gesture or the route.

## Install

```bash
flutter_shadcn add drawer_container
```

## Import

```dart
import 'package:<your_app>/ui/shadcn/drawer_container/drawer_container.dart';
```

## Minimal example

```dart
Data<DrawerContainerData>.inherit(
  data: const DrawerContainerData(
    position: OverlayPosition.bottom,
    isSheet: true,
  ),
  child: const DrawerContainer(child: Text('Sheet content')),
);
```

## API

- `DrawerRawContainer` — the fully-parameterized container.
- `DrawerContainerData` — configuration provided through a `Data` ancestor;
  `build(child, ...)` returns the container.
- `DrawerContainer` — takes only a `child` and reads its configuration from
  the nearest `DrawerContainerData`.
- `AxisSize` (+ `FixedAxisSize`, `FractionAxisSize`, arithmetic combinators) —
  cross-axis sizing so a sheet does not stretch edge-to-edge.

## Behaviour

- Drawer chrome borders the three inner sides and rounds the two outer
  corners; `isSheet: true` switches to a single inner-edge border and square
  corners.
- The drag handle is drawn when `draggable` and `showDragHandle` are true;
  gaps default to 8 above and 4 below.
- `crossAxisSize`/`crossAxisAlignment` size and align the panel along the
  cross axis instead of stretching.
- When `fadeAnimation` and `barrierColor` are both set, a barrier wash is
  drawn behind the container.

## Notes

The old `SheetRawContainer`/`SheetContainer` classes and the
`surfaceOpacity`/`surfaceBlur` glass fields are gone: sheet chrome is
`isSheet: true`, and the accepted `drawer` component already dropped glass.
