# Carousel

Paged carousel with a sliding or fading transition, drag with fling, optional
autoplay and a controller that also drives a dot row. Widgets-only: no
Material, no component dependency.

## When to use

- You show a fixed set of pages and want one visible at a time.
- You need an auto-advancing banner/hero.

## Snippets

```dart
final controller = CarouselController();

Carousel(
  itemCount: pages.length,
  controller: controller,
  onIndexChanged: (int index) => setState(() => _page = index),
  itemBuilder: (context, index) => pages[index],
);
```

Half-width pages that cross-fade:

```dart
Carousel(
  itemCount: pages.length,
  transition: CarouselTransition.fading,
  viewportFraction: 0.5,
  itemBuilder: (context, index) => pages[index],
);
```

Autoplay that pauses on hover:

```dart
Carousel(
  itemCount: pages.length,
  autoplayInterval: const Duration(seconds: 3),
  itemBuilder: (context, index) => pages[index],
);
```

Dot row driven by the controller:

```dart
DotIndicator(
  index: controller.value.round(),
  length: pages.length,
  onChanged: (int page) => controller.animateTo(page.toDouble(), kDefaultDuration),
);
```

## API

| Widget / member | Notes |
|---|---|
| `Carousel.itemBuilder` | `(context, index) => Widget` |
| | `itemCount` null means unbounded (external controller) |
| | `controller` null → the carousel creates and disposes its own |
| | `transition` sliding (default) or fading |
| | `alignment` start / center (default) / end |
| | `direction` horizontal (default) or vertical |
| | `viewportFraction` share of the viewport per page, default 1 |
| | `itemExtent` fixed page extent, wins over `viewportFraction` |
| | `gap`, `speed`, `curve` transition tuning |
| | `autoplayInterval` hold time per page, null disables autoplay |
| | `autoplayReverse` walk backwards |
| | `pauseOnHover` default true |
| | `draggable` default true |
| | `wrap` default true; a non-wrapping carousel clamps and bounces |
| | `onIndexChanged` rounded page index |
| | `onPageChanged` fractional page position |
| | `theme` widget leg of `CarouselTheme` |
| `CarouselController` | `value`, `next`, `previous`, `animateTo`, `jumpTo`, `resolvedIndex` |

## Fixed bugs (old → new)

1. **`details.primaryVelocity!` was force-unwrapped** at the end of a drag.
   `GestureDragEndDetails.primaryVelocity` is nullable and null whenever the
   gesture was cancelled, so cancelling a drag threw.
2. **The horizontal drag measured the page on the wrong axis**: it used
   `constraints.maxHeight` while the layout used `maxWidth`, so a
   `viewportFraction < 1` horizontal carousel moved at the wrong speed.
3. **Snapping used the page the drag started on**
   (`_lastDragValue.floor ± 1`), so a fling that crossed three pages always
   snapped back to the first. The target is now the rounded projection of the
   fling.
4. **A non-wrapping carousel clamped through
   `_controller._controller.value`**, reaching into the controller's private
   `AnimationQueueController`; the plain setter clears the queue, so the clamp
   killed the in-flight animation and fought it every frame.
5. **`getCurrentIndex` wrapped the page even when `wrap` was false**, so
   `onIndexChanged` reported a wrapped index for a non-wrapping carousel.
6. **`reverse` passed `(-index).toInt()` to `itemBuilder`** — a negative index
   (a `RangeError` in any list-backed builder).
7. **`(gapBeforeItem / size).ceil()` divided by a zero `size`**, and `ceil` on
   an infinity throws.
8. **A controller the widget created for itself was never disposed.**
9. `hovered` / `dragging` were public mutable fields on the `State`.
10. `disableOverheadScrolling` / `disableDraggingVelocity` are gone: snapping
    now always follows the fling, and a dead fling is simply ignored.
11. Only `ComponentTheme.maybeOf` was read (2 of 4 theme legs), and the theme
    had no token-derived defaults at all.
12. The old `durationBuilder` doubled as "how long a page is held" *and* the
    transition duration (`duration += autoplaySpeed`); autoplay now has its own
    `autoplayInterval`.

## Migrating from the old carousel

| Old | New |
|---|---|
| `Carousel(transition: CarouselTransition.sliding(gap: 8))` | `Carousel(transition: CarouselTransition.sliding, gap: 8)` |
| `Carousel(transition: CarouselTransition.fading())` | `Carousel(transition: CarouselTransition.fading)` |
| `Carousel(sizeConstraint: CarouselFixedConstraint(200))` | `Carousel(itemExtent: 200)` |
| `Carousel(sizeConstraint: CarouselFractionalConstraint(0.5))` | `Carousel(viewportFraction: 0.5)` |
| `Carousel(duration: d)` / `durationBuilder` | `autoplayInterval` |
| `Carousel(speed:, curve:)` | `speed:`, `curve:` (same) |
| `CarouselDotIndicator(itemCount:, controller:)` | `DotIndicator(index:, length:, onChanged:)` |
| `Carousel(theme:)` | `Carousel(theme: CarouselTheme(...))` |