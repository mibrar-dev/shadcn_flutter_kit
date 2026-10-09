# Tooltip

Delayed hover label presented through the popover machinery, plus the themed
surface (`TooltipContainer`) and the handler an app installs to style tooltips
separately. Widgets-only: no Material, no component dependency.

## When to use

- An icon or a truncated label needs a short explanation.
- A control is meaningless without its label (icon-only toolbars).

## Snippets

```dart
Tooltip(
  child: Icon(LucideIcons.info, size: 16),
  tooltip: (context) => TooltipContainer(child: const Text('Details')),
);
```

Show it without the delay (the old `InstantTooltip`):

```dart
Tooltip(
  waitDuration: Duration.zero,
  child: anchor,
  tooltip: (context) => TooltipContainer(child: const Text('Now')),
);
```

Build your own overlay content (what `tracker` and `navigation_bar` do):

```dart
const TooltipContainer(child: Text('Label'));
```

Widget-leg theme override:

```dart
TooltipContainer(
  theme: const TooltipTheme(
    background: ThemedColor.ref(ColorRef.accent),
    foreground: ThemedColor.ref(ColorRef.accentForeground),
  ),
  child: const Text('Accent'),
);
```

## API

| Widget | Parameter | Default | Notes |
|---|---|---|---|
| `Tooltip` | `child` | required | the anchor |
| | `tooltip` | required | `WidgetBuilder`; wrap the result in `TooltipContainer` |
| | `alignment` | `Alignment.topCenter` | where the tooltip sits |
| | `anchorAlignment` | `Alignment.bottomCenter` | which anchor edge is pointed at |
| | `waitDuration` | 500 ms | delay before it appears |
| | `showDuration` | 200 ms | grace period after the pointer leaves |
| | `minDuration` | zero | minimum visible time |
| | `theme` | null | widget leg of `TooltipTheme` |
| `TooltipContainer` | `child` | required | the content |
| | `theme` | null | widget leg of `TooltipTheme` |
| | `padding` | null | applied once, never re-scaled |
| | `borderRadius` | null | null uses `TooltipTheme.borderRadius` |
| | `maxWidth` | null | content wraps past this width |

## Theme fields

| Field | Default | Notes |
|---|---|---|
| `background` | `ColorRef.primary` | surface fill |
| `foreground` | `ColorRef.primaryForeground` | label colour |
| `borderRadius` | `borderRadiusSm` | corner radius |
| `padding` | density base gap at 0.75x | inner padding |
| `textStyle` | 12 px / w500 | its colour is ignored |
| `surfaceBlur` | the app theme's `surfaceBlur` | backdrop blur sigma |

## Behaviour

- The tooltip is **not modal** and does **not** take focus: an outside tap
  never steals focus from the anchor.
- `Hover` debounces the enter and leave events, so a pointer crossing the
  anchor does not flap the overlay.
- Themes stay live while the tooltip is open: the popover primitive captures
  `InheritedTheme` at show time and re-resolves on a light/dark switch.

## Migrating from the old tooltip

| Old | New |
|---|---|
| `Tooltip(child:, tooltip:)` | unchanged |
| `Tooltip(adaptiveOverlay: true)` | removed; install `ShadcnLayer(tooltipHandler: ...)` instead |
| `InstantTooltip(child:, tooltipBuilder:)` | `Tooltip(waitDuration: Duration.zero, child:, tooltip:)` |
| `TooltipContainer(child:)` | unchanged |
| `TooltipContainer(surfaceOpacity:, surfaceBlur:, backgroundColor:)` | `TooltipContainer(theme: TooltipTheme(...))`; `backgroundColor` is a `ThemedColor` now |
| `FixedTooltipOverlayHandler` | deleted (no readers) |
| `OverlayManagerAsTooltipOverlayHandler` | `TooltipOverlayHandler` |