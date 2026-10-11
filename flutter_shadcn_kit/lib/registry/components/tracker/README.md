# Tracker

A compact row of coloured activity segments (shadcn has no equivalent). Each
segment carries a tooltip shown while the pointer rests on it. Widgets-only; it
depends on the `tooltip` component and the `gap` foundation primitive.

## When to use

- Uptime / status strips, a row of recent results, a compact activity history.
- Anywhere a list of discrete, colour-coded states should read as one bar.

For a paged set of cards use `carousel`; for a single progress value use
`progress`.

## Snippets

```dart
Tracker(
  data: <TrackerData>[
    TrackerData(tooltip: const Text('Healthy'), level: TrackerLevel.fine),
    TrackerData(tooltip: const Text('Degraded'), level: TrackerLevel.warning),
    TrackerData(tooltip: const Text('Down'), level: TrackerLevel.critical),
  ],
);
```

Per-segment tooltip content is a widget, so it can be rich:

```dart
TrackerData(
  level: TrackerLevel.critical,
  tooltip: Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[const Text('API'), const Text('500 · 2m ago')],
  ),
);
```

Customise the segments through the theme (widget leg):

```dart
Tracker(
  theme: const TrackerTheme(itemHeight: 24, gap: 4, radius: 4),
  data: data,
);
```

## `Tracker` API

| Parameter | Type | Default | Notes |
|---|---|---|---|
| `data` | `List<TrackerData>` | required | segments in visual order |
| `theme` | `TrackerTheme?` | null | widget leg of the resolver |

An empty `data` list renders a zero-size box.

## `TrackerData`

| Field | Type | Notes |
|---|---|---|
| `tooltip` | `Widget` | content shown on hover; the `Tooltip` supplies the surface |
| `level` | `TrackerLevel` | `fine`, `warning`, `critical`, `unknown` |

## Theme resolution

`widget theme > ComponentTheme<TrackerTheme> in tree > app overrides
(tracker_theme.dart) > trackerDefaults`, merged per field.

| Field | Default |
|---|---|
| `fine` | the `chart2` token (shadcn has no green token) |
| `warning` | the `chart4` token |
| `critical` | `destructive` token |
| `unknown` | `mutedForeground` token |
| `radius` | ambient `radiusMd` |
| `gap` | 2 |
| `itemHeight` | 32 |

## Differences from the old `display/tracker`

- `package:flutter/material.dart` (imported for `Colors`) is gone.
- The four level colours were `static const` literals and could not follow a
  preset; they are `ThemedColor` theme rows now. `critical` and `unknown` map
  to shadcn's own `destructive` / `mutedForeground`; `fine` and `warning`
  borrow the `chart2` / `chart4` slots, because shadcn defines no
  green/amber token of its own.
- `TrackerLevel` is an enum. Its `name` getter is dropped: the widget never
  rendered it (the caller supplies the tooltip), and custom level classes are
  no longer supported — a clean break, matching the "variants are data" rule.
- The old `TrackerThemeDefaults` values (radius 6 / gap 2 / height 32) were
  never read; they are the real defaults now.
- The old segment double-wrapped its tooltip in a `TooltipContainer`; the
  `Tooltip` already wraps content, so the bare tooltip widget is passed.
