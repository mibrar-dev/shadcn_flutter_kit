# Overlay Configuration (`overlay_configuration`)

Describe *what* overlay to show and *how* behind one configuration object,
independent of the mechanism. One `show` call site can switch between a
popover, drawer, sheet, dialog or tooltip by swapping the configuration.

## Install

```bash
flutter_shadcn add overlay_configuration
```

## Import

```dart
import 'package:<your_app>/ui/shadcn/overlay_configuration/overlay_configuration.dart';
```

## Minimal example

```dart
showOverlay<void>(
  context,
  const PopoverConfiguration(alignment: Alignment.bottomCenter),
  builder: (context) => const Text('Popover'),
);
```

## API

- `OverlayConfiguration` — abstract base: `show`, `adaptiveConversion`,
  `nonAdaptive`, `maybeOf`.
- `showOverlay(context, configuration, builder: ...)` — presents any
  configuration; `adaptive: true` (default) runs `adaptiveConversion` first.
- `PopoverConfiguration` — popover; on mobile it converts to a bottom
  `DrawerConfiguration` (so there is no separate `MenuConfiguration`).
- `TooltipConfiguration` — a non-modal popover that never follows on mobile.
- `DrawerConfiguration` / `SheetConfiguration` — drive the `drawer`
  component's real routes.
- `DialogConfiguration` — a centered modal dialog.
- `OverlayController` — a `ChangeNotifier` managing one overlay: `show`,
  `close`, `closeLater`, `hasOpenOverlay`, `hasMountedOverlay`, `config`.

## Behaviour

- Every presented content subtree receives the active
  `OverlayConfiguration`, so `OverlayConfiguration.maybeOf(context)` works
  inside the overlay.
- `adaptiveConversion` runs when the overlay is shown (or pass
  `adaptive: false`). `nonAdaptive` is a no-op getter on the base because the
  registry resolves adaptivity at show time.

## Breaking change (anchors)

Custom anchors are resolved through the widget tree. An `Anchor` that is not a
`ContextAnchor` (for example a `LinkedAnchor`) only resolves when an
`OverlayAnchorScope` wraps both the anchor and the `show` call site. The old
process-wide anchor registry is gone; wrap each screen that reuses anchor keys
in its own `OverlayAnchorScope`.

## Removed from the old port

`MenuConfiguration` (identical to an adaptive `PopoverConfiguration`) and the
unused upstream parity parameters (`position`, `key`, `rootOverlay`,
`clipBehavior`, `regionGroupId`, `transitionAlignment`, `onTickFollow`,
`animationController`, `autoOpen`, `traverseEdgeBehavior`, …) are gone.
