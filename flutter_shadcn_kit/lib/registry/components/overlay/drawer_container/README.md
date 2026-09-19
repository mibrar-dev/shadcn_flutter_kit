# Drawer Container (`drawer_container`)

Upstream-parity drawer/sheet chrome (`AxisSize` algebra, `DrawerRawContainer`, `SheetRawContainer`, `DrawerContainerData`, `DrawerContainer`, `SheetContainer`) for pinned sheets and drawer overlays.

---

## When to use

- Use this when:
  - you build pinned sheets or custom drawer chrome around content.
  - you need cross-axis sizing algebra for sheets.
- Avoid when:
  - simple dialogs or popovers (use `dialog`, `popover`).

---

## Install

```bash
flutter_shadcn add drawer_container
```

---

## Import

```dart
import 'package:<your_app>/ui/shadcn/overlay/drawer_container/drawer_container.dart';
```

---

## Minimal example

```dart
DrawerContainerData(
  position: OverlayPosition.bottom,
  size: Size.zero,
  stackIndex: 0,
  child: DrawerContainer(child: Text('Sheet')),
)
```

---

## Upstream parity

Ports `shadcn_flutter`'s `overlay/drawer_container.dart` public surface: the `AxisSize` algebra is verbatim; the containers keep identical constructor parameters. Two deliberate simplifications are documented in code:

- The overscroll growth render object is simplified to equivalent leading-edge padding.
- The `ModalBackdrop` stacking behavior is simplified to a `FadeTransition` barrier wash driven by `fadeAnimation` when `barrierColor` is set.
