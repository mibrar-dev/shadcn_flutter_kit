# switcher

A swipeable view that animates between child widgets. Useful for paging,
onboarding steps and any "one card at a time" surface.

## Getting started

```dart
Switcher(
  index: currentIndex,
  direction: AxisDirection.right,
  onIndexChanged: (int index) => setState(() => currentIndex = index),
  children: pages,
)
```

`direction` names the axis the *content* travels along: with
`AxisDirection.right` the next page arrives from the left, so the drag goes
rightwards. This matches the old widget's sign convention exactly.

## API

| Member | Type | Notes |
|---|---|---|
| `index` | `int` | Clamped to `0..children.length - 1`. Changing it from outside cancels an in-flight drag. |
| `children` | `List<Widget>` | Required, never empty (asserted). **The length must not change after the first build** — see below. |
| `direction` | `AxisDirection` | Required. |
| `onIndexChanged` | `ValueChanged<int>?` | Called only when a drag snaps to an index **different** from `index`. |
| `duration` | `Duration?` | null = `SwitcherTheme.duration` (150 ms). |
| `curve` | `Curve?` | null = `SwitcherTheme.curve` (`easeInOut`). |
| `theme` | `SwitcherTheme?` | Widget-leg override. |

### Changing `children` at runtime

The position is an `AnimationController` value whose range is fixed when the
controller is created, so `children.length` must stay constant after the first
build. Changing it **asserts in debug** (with a message pointing at the fix).

To swap the page list, give the `Switcher` a new `Key` (or wrap it in a fresh
`KeyedSubtree`) so a new state — and a new controller — is created:

```dart
KeyedSubtree(key: ValueKey(pages.length), child: Switcher(...))
```

The old widget re-read `widget.children.length` on every frame and clamped
against it, so a shrinking list crashed with a `RangeError` there instead.

## Theme

`SwitcherTheme` carries the motion rows (`duration`, `curve`) and resolves
through all four legs: widget argument > nearest `ComponentTheme` >
`ComponentThemes` app entry > `switcherDefaults`.

## Differences from the old `navigation/switcher`

| Old | New |
|---|---|
| barrel + four `part`s | one flat `switcher.dart` (the render object is private and file-local) |
| `onPanStart` set `_dragging = true` **without `setState`**, so the first drag frame still animated over `duration` | `onPanStart` stops the controller, so the position follows the finger exactly |
| `_snapIndex()` always called `onIndexChanged`, so a one-pixel drag notified the caller | notified only when the snapped index differs from `index` |
| `widget.index` was never clamped: `index: 5` with 3 children indexed past the end and threw a `RangeError` on the first frame | `index` is clamped everywhere; `children` is asserted non-empty, and a runtime change of `children.length` asserts with a message instead of crashing silently |
| `context.size!` was a null assertion on the State's own context — a pan in an unbounded or not-yet-laid-out slot crashed | extent comes from `LayoutBuilder`, with a zero guard on every axis |
| `didUpdateWidget` ignored `direction` changes | the axis is read fresh on every build |
| the render object's `absolute` branch was unreachable; `paint` and `hitTestChildren` overrode mixin methods with the mixin implementations | dead branch and dead overrides removed |
| `performLayout` silently collapsed to `Size.zero` unless there were exactly two children | one or two children are both laid out |
| `AnimatedValueBuilder(value:, duration:)` from `shared/primitives` | an `AnimationController` owned by the state |
| `AnimatedValueBuilder` imported from shared | `package:flutter/widgets.dart` only |