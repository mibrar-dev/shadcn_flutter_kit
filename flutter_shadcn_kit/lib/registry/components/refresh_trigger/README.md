# RefreshTrigger

Pull-to-refresh wrapper for any scrollable: pulling past the arming extent
runs an async refresh and shows a completion state. The default indicator is
a card pill (rotating arrow while pulling, spinning arc while refreshing, a
check when complete), each with a localized label. Widgets-only.

## When to use

- Refreshing list content with a pull gesture.
- A custom refresh surface via `indicatorBuilder`.

Set `onRefresh` to null to disable pulling.

## Snippets

Minimal:

```dart
RefreshTrigger(
  onRefresh: () async => reload(),
  child: ListView(children: rows),
);
```

Custom indicator and extents:

```dart
RefreshTrigger(
  minExtent: 60,
  maxExtent: 120,
  completeDuration: const Duration(milliseconds: 800),
  indicatorBuilder: (context, stage) => MyIndicator(stage: stage),
  onRefresh: () async => reload(),
  child: ListView(children: rows),
);
```

Programmatic refresh:

```dart
final key = GlobalKey<RefreshTriggerState>();
RefreshTrigger(key: key, onRefresh: reload, child: list);
// later:
await key.currentState!.refresh();
```

## `RefreshTrigger` API

| Parameter | Type | Default | Notes |
|---|---|---|---|
| `child` | `Widget` | required | scrollable content |
| `onRefresh` | `Future<void> Function()?` | null | null disables pulling |
| `minExtent` | `double?` | theme (75) | pull distance arming the refresh |
| `maxExtent` | `double?` | theme (150) | maximum pull distance |
| `direction` | `Axis` | vertical | pull gesture direction |
| `reverse` | `bool` | false | invert the pull direction |
| `indicatorBuilder` | `RefreshIndicatorBuilder?` | theme (default pill) | `(context, stage)` surface |
| `curve` | `Curve?` | theme (`easeOutSine`) | extent animation curve |
| `completeDuration` | `Duration?` | theme (500ms) | completion display time |
| `theme` | `RefreshTriggerTheme?` | null | widget-leg override |

Extents are logical pixels multiplied by the ambient scaling. `TriggerStage`
is `idle`, `pulling`, `refreshing` or `completed`; `RefreshTriggerStage`
carries the stage plus the live extent animation, direction and reverse flag.

## Differences from old `refresh_trigger`

- Deleted: the `material.dart` import (`CircularProgressIndicator`, `Icons`),
  the dead `checkbox` import, and `RefreshTriggerPhysics` (an empty
  `ScrollPhysics` subclass with zero readers).
- The completion check painter (from the deleted checkbox painter) is a
  small inline `CustomPainter` driven by the completion animation.
- Pulls with null `onRefresh` no longer animate a fake refresh cycle.
- Zero/negative `minExtent` no longer divides by zero (treated as 1px).
