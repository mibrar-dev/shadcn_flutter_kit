# Pinned Sheet (`pinned_sheet`)

Upstream-parity controller-driven sheet (`PinnedSheet` + `SheetController` + `SheetStage` algebra) that snaps between stages with drag gestures and backdrop transforms.

---

## When to use

- Use this when:
  - you need a persistent sheet with snap stages and drag gestures.
  - you drive sheet position from a controller.
- Avoid when:
  - one-off modal sheets (use the `drawer` component).

---

## Install

```bash
flutter_shadcn add pinned_sheet
```

---

## Import

```dart
import 'package:<your_app>/ui/shadcn/display/pinned_sheet/pinned_sheet.dart';
```

---

## Minimal example

```dart
PinnedSheet(
  controller: controller,
  stages: const [SheetStage.closed(), SheetStage.expanded()],
  child: DrawerContainer(child: Text('Sheet')),
)
```

---

## Derived stages

```dart
controller.stage = SheetStage.expanded() - SheetStage.fixed(100);
```

---

## Upstream parity

Ports `shadcn_flutter`'s `display/pinned_sheet.dart` public surface with identical names: `PinnedSheet` (all constructor parameters), `SheetController` (`offset`/`fraction`/`isOpen`/`stage`/`animateTo`/`jumpTo`/`open`/`close`), `SheetStageResolution`, and all stage types (`Closed`/`Expanded`/`Fixed`/`Fraction`/`PeekDragHandle`/`Additive`/`Subtracted`/`Multiplied`/`Divided`, including stage arithmetic and live-stage `==`).

Split across `_impl` files by concern (stage types, controller, widget, state). The upstream render-object slide/overscroll machinery is simplified to an animation-driven pixel offset with drag-to-snap; `contentIntrinsic` is accepted/stored (loose constraints preserve the intrinsic minimum).
