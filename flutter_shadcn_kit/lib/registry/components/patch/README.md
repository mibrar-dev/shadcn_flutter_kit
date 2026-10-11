# patch

Counts consecutive taps so you can implement double-click, triple-click and
similar gestures without hand-rolling timers.

## Getting started

```dart
ClickDetector(
  threshold: const Duration(milliseconds: 300),
  onClick: (ClickDetails details) {
    if (details.clickCount == 2) openFile();
  },
  child: const FileTile(),
)
```

## API

| Member | Type | Notes |
|---|---|---|
| `onClick` | `ClickCallback<ClickDetails>?` | Called on every tap with the running count. `null` builds no gesture recogniser at all. |
| `child` | `Widget` | Required. |
| `behavior` | `HitTestBehavior` | Defaults to `HitTestBehavior.deferToChild`. |
| `threshold` | `Duration` | Longest gap that still counts as consecutive. Default 300 ms. |

`ClickDetails` carries `clickCount` and `localPosition`, and compares with
`==`/`hashCode`. `ClickCallback<T>` is generic in the details type.

## Theme

None. The component paints nothing, so there is no `<name>_style.dart` /
`<name>_theme.dart` pair.

## Differences from the old `control/patch`

| Old | New |
|---|---|
| `patch.dart` was a barrel re-exporting three `_impl` files, one of which was a Material `Scaffold` preview | one flat `patch.dart` |
| `ClickDetectorState` was public, with public mutable `count` and `lastClick` fields any app could write | private `_ClickDetectorState` |
| timing came from `DateTime.now()` — a system clock change reset or extended a click sequence | a `Stopwatch`, which reads the VM's monotonic clock and cannot be moved by the user |
| the count ignored **where** the tap landed, so two taps at opposite ends of a large canvas inside `threshold` read as a double click | taps further than `kDoubleTapSlop` from the previous one restart the sequence |
| `ClickDetails` had no `==`/`hashCode` | value equality |
| `ClickDetails` had no position | `localPosition` reported with every click |
| blank `theme.schema.json` | none |