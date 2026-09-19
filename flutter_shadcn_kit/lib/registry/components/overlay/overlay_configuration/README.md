# Overlay Configuration (`overlay_configuration`)

Upstream-parity overlay configurations (`OverlayConfiguration`, `Popover`/`Drawer`/`Sheet`/`Dialog`/`Menu`/`TooltipConfiguration`, `showOverlay`) plus `OverlayController`, adapted to the registry `PopoverController` architecture.

---

## When to use

- Use this when:
  - you port upstream code that drives overlays via `OverlayController`/`showOverlay`.
  - you need one configuration object shared across call sites.
- Avoid when:
  - native registry overlays (prefer `popover`, `dialog`, `menu` directly).

---

## Install

```bash
flutter_shadcn add overlay_configuration
```

---

## Import

```dart
import 'package:<your_app>/ui/shadcn/overlay/overlay_configuration/overlay_configuration.dart';
```

---

## Minimal example

```dart
showOverlay(
  context,
  const PopoverConfiguration(alignment: Alignment.topCenter),
  builder: (context) => const Text('Popover'),
)
```

---

## Upstream parity

Ports `shadcn_flutter`'s `overlay/overlay_configuration.dart` public surface (`OverlayController`, `OverlayConfiguration`, `showOverlay`, all six configuration classes with identical constructor parameters).

Adaptation: `show` delegates to a `PopoverController` presentation. `PopoverConfiguration`/`TooltipConfiguration` map 1:1; `Drawer`/`Sheet`/`Dialog`/`Menu` presentations are marked `@Deprecated` where the registry architecture differs (goal is API compile-parity). The registry's own `OverlayCompleter`/`OverlayBarrier`/`closeOverlay` are reused, not redefined.
