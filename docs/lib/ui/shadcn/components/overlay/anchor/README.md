# Anchor (`anchor`)

Upstream-parity anchor primitives (`Anchor`, `ContextAnchor`, `LinkedAnchor`) and the overlay anchor registry/scope used for position-tracked overlays.

---

## When to use

- Use this when:
  - you need overlays that track an anchor widget's live position.
  - you want linked anchors resolved through a scoped registry.
- Avoid when:
  - a one-off popover without position tracking (use `popover`).

---

## Install

```bash
flutter_shadcn add anchor
```

---

## Import

```dart
import 'package:<your_app>/ui/shadcn/overlay/anchor/anchor.dart';
```

---

## Minimal example

```dart
OverlayAnchorScope(
  child: OverlayAnchor(
    anchor: 'demo',
    child: const Text('Anchor me'),
  ),
)
```

---

## Upstream parity

Ports `shadcn_flutter`'s `overlay/anchor.dart` (`Anchor`, `AnchorSubscription`, `anchorTransformRelativeTo`, `ContextAnchor`, `LinkedAnchor`) and the anchor subsystem of `overlay/overlay.dart` (`OverlayAnchorEntry`, `OverlayAnchorRegistry`, `OverlayAnchorScope`, `OverlayAnchor`, `RenderOverlayAnchor`).

The registry keeps its `OverlayManager`/`PopoverController` architecture; these primitives are additive and power `overlay_configuration`'s anchored presentations.
