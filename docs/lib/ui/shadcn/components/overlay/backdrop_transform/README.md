# Backdrop Transform (`backdrop_transform`)

Upstream-parity backdrop transforms (`BackdropTransform`, `NoBackdropTransform`, `ScaleBackdropTransform`) for sheet/drawer zoom-out effects.

---

## When to use

- Use this when:
  - you render a pinned sheet or drawer container with a zoom-out backdrop.
  - you need the freed layout space a backdrop scale produces.
- Avoid when:
  - simple modal overlays without backdrop motion.

---

## Install

```bash
flutter_shadcn add backdrop_transform
```

---

## Import

```dart
import 'package:<your_app>/ui/shadcn/overlay/backdrop_transform/backdrop_transform.dart';
```

---

## Minimal example

```dart
PinnedSheet(
  backdrop: MyContent(),
  backdropTransform: const ScaleBackdropTransform(),
  child: const DrawerContainer(child: Text('Sheet')),
)
```

---

## Upstream parity

Ports `shadcn_flutter`'s `overlay/backdrop_transform.dart` verbatim (modulo import paths). The default `minScale` of `0.95` matches the drawer's `kBackdropScaleDown`.
