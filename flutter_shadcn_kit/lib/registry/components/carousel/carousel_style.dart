// Registry-owned side of the `carousel` component: the [CarouselTheme]
// container, the [CarouselTransition] / [CarouselAlignment] enums, the
// [CarouselController], the pure layout math and the token-derived
// `carouselDefaults`. User-owned overrides live in `carousel_theme.dart`.
//
// Fixes against the old theme:
//   * `CarouselTransition` and `CarouselSizeConstraint` were abstract classes
//     with a `const factory` per variant; the transition is an enum with an
//     exhaustive switch and the two size constraints are two nullable numbers.
//   * `copyWith` dropped the `ComponentThemeData` slots and there was no
//     `Mergeable`, so an override leg replaced the whole slice.
//   * `ignoreGlobalScaling` / `ignoreGlobalRadius` were tokens-file-only knobs
//     with zero readers anywhere in the registry.

import 'package:flutter/widgets.dart';

import '../../foundation/util.dart' show wrapDouble;
import '../../primitives/animation_queue.dart';

import '../../foundation/constants.dart';
import '../../theme/color_tokens.dart';
import '../../theme/theme.dart';

/// How the carousel moves between pages.
enum CarouselTransition {
  /// Pages slide along the scroll axis.
  sliding,

  /// Pages cross-fade in place.
  fading,
}

/// Where the current page sits inside the viewport.
enum CarouselAlignment {
  /// The page is pinned to the leading edge.
  start(0),

  /// The page is centred.
  center(0.5),

  /// The page is pinned to the trailing edge.
  end(1);

  const CarouselAlignment(this.alignment);

  /// Fraction of the free space before the page, 0..1.
  final double alignment;
}

/// Visual contract of the carousel viewport.
class CarouselTheme extends ComponentThemeData
    implements Mergeable<CarouselTheme> {
  /// Creates a carousel theme.
  const CarouselTheme({
    super.themeDensity,
    super.themeSpacing,
    super.themeShadows,
    this.transition,
    this.alignment,
    this.direction,
    this.viewportFraction,
    this.itemExtent,
    this.gap,
    this.speed,
    this.curve,
    this.autoplayInterval,
    this.pauseOnHover,
    this.draggable,
    this.wrap,
  });

  /// Page transition; null resolves [CarouselTransition.sliding].
  final CarouselTransition? transition;

  /// Page alignment; null resolves [CarouselAlignment.center].
  final CarouselAlignment? alignment;

  /// Scroll axis; null resolves [Axis.horizontal].
  final Axis? direction;

  /// Fraction of the viewport one page occupies; null resolves 1.
  final double? viewportFraction;

  /// Fixed page extent in logical pixels; wins over [viewportFraction].
  final double? itemExtent;

  /// Gap between two pages; null resolves zero.
  final double? gap;

  /// Page-change duration; null resolves [kDefaultDuration].
  final Duration? speed;

  /// Page-change curve; null resolves [Curves.easeInOut].
  final Curve? curve;

  /// Time one page is held during autoplay; null disables autoplay.
  final Duration? autoplayInterval;

  /// Whether autoplay pauses while the pointer rests on the carousel.
  final bool? pauseOnHover;

  /// Whether the carousel can be dragged; null resolves true.
  final bool? draggable;

  /// Whether the last page wraps to the first; null resolves true.
  final bool? wrap;

  /// Returns a copy with the given fields replaced.
  CarouselTheme copyWith({
    ValueGetter<CarouselTransition?>? transition,
    ValueGetter<CarouselAlignment?>? alignment,
    ValueGetter<Axis?>? direction,
    ValueGetter<double?>? viewportFraction,
    ValueGetter<double?>? itemExtent,
    ValueGetter<double?>? gap,
    ValueGetter<Duration?>? speed,
    ValueGetter<Curve?>? curve,
    ValueGetter<Duration?>? autoplayInterval,
    ValueGetter<bool?>? pauseOnHover,
    ValueGetter<bool?>? draggable,
    ValueGetter<bool?>? wrap,
  }) {
    return CarouselTheme(
      themeDensity: themeDensity,
      themeSpacing: themeSpacing,
      themeShadows: themeShadows,
      transition: transition == null ? this.transition : transition(),
      alignment: alignment == null ? this.alignment : alignment(),
      direction: direction == null ? this.direction : direction(),
      viewportFraction: viewportFraction == null
          ? this.viewportFraction
          : viewportFraction(),
      itemExtent: itemExtent == null ? this.itemExtent : itemExtent(),
      gap: gap == null ? this.gap : gap(),
      speed: speed == null ? this.speed : speed(),
      curve: curve == null ? this.curve : curve(),
      autoplayInterval: autoplayInterval == null
          ? this.autoplayInterval
          : autoplayInterval(),
      pauseOnHover: pauseOnHover == null ? this.pauseOnHover : pauseOnHover(),
      draggable: draggable == null ? this.draggable : draggable(),
      wrap: wrap == null ? this.wrap : wrap(),
    );
  }

  /// First-non-null-wins merge; the receiver (higher-priority leg) wins.
  @override
  CarouselTheme merge(CarouselTheme? fallback) {
    if (fallback == null) {
      return this;
    }
    return CarouselTheme(
      themeDensity: themeDensity ?? fallback.themeDensity,
      themeSpacing: themeSpacing ?? fallback.themeSpacing,
      themeShadows: themeShadows ?? fallback.themeShadows,
      transition: transition ?? fallback.transition,
      alignment: alignment ?? fallback.alignment,
      direction: direction ?? fallback.direction,
      viewportFraction: viewportFraction ?? fallback.viewportFraction,
      itemExtent: itemExtent ?? fallback.itemExtent,
      gap: gap ?? fallback.gap,
      speed: speed ?? fallback.speed,
      curve: curve ?? fallback.curve,
      autoplayInterval: autoplayInterval ?? fallback.autoplayInterval,
      pauseOnHover: pauseOnHover ?? fallback.pauseOnHover,
      draggable: draggable ?? fallback.draggable,
      wrap: wrap ?? fallback.wrap,
    );
  }

  /// State scales step at t < 0.5; dimensions lerp.
  static CarouselTheme lerp(CarouselTheme a, CarouselTheme b, double t) {
    return CarouselTheme(
      themeDensity: t < 0.5 ? a.themeDensity : b.themeDensity,
      themeSpacing: t < 0.5 ? a.themeSpacing : b.themeSpacing,
      themeShadows: t < 0.5 ? a.themeShadows : b.themeShadows,
      transition: t < 0.5 ? a.transition : b.transition,
      alignment: t < 0.5 ? a.alignment : b.alignment,
      direction: t < 0.5 ? a.direction : b.direction,
      viewportFraction: t < 0.5 ? a.viewportFraction : b.viewportFraction,
      itemExtent: t < 0.5 ? a.itemExtent : b.itemExtent,
      gap: t < 0.5 ? a.gap : b.gap,
      speed: t < 0.5 ? a.speed : b.speed,
      curve: t < 0.5 ? a.curve : b.curve,
      autoplayInterval: t < 0.5 ? a.autoplayInterval : b.autoplayInterval,
      pauseOnHover: t < 0.5 ? a.pauseOnHover : b.pauseOnHover,
      draggable: t < 0.5 ? a.draggable : b.draggable,
      wrap: t < 0.5 ? a.wrap : b.wrap,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is CarouselTheme &&
        other.themeDensity == themeDensity &&
        other.themeSpacing == themeSpacing &&
        other.themeShadows == themeShadows &&
        other.transition == transition &&
        other.alignment == alignment &&
        other.direction == direction &&
        other.viewportFraction == viewportFraction &&
        other.itemExtent == itemExtent &&
        other.gap == gap &&
        other.speed == speed &&
        other.curve == curve &&
        other.autoplayInterval == autoplayInterval &&
        other.pauseOnHover == pauseOnHover &&
        other.draggable == draggable &&
        other.wrap == wrap;
  }

  @override
  int get hashCode => Object.hash(
    themeDensity,
    themeSpacing,
    themeShadows,
    transition,
    alignment,
    direction,
    viewportFraction,
    itemExtent,
    gap,
    speed,
    curve,
    autoplayInterval,
    pauseOnHover,
    draggable,
    wrap,
  );
}

/// The colour the dot indicator uses for the page it points at.
const ThemedColor carouselDefaultIndicatorActive = ThemedColor.ref(
  ColorRef.primary,
);

/// Token-derived baseline; every unset override field falls through here.
const CarouselTheme carouselDefaults = CarouselTheme(
  transition: CarouselTransition.sliding,
  alignment: CarouselAlignment.center,
  direction: Axis.horizontal,
  viewportFraction: 1,
  gap: 0,
  speed: kDefaultDuration,
  curve: Curves.easeInOut,
  pauseOnHover: true,
  draggable: true,
  wrap: true,
);

/// The fractional page position a [Carousel] is animating towards.
/// The fractional page position a [Carousel] is animating towards.
///
/// The value is a page index (`2.5` is halfway between page 2 and page 3), so
/// a drag and an autoplay step share one scale.
class CarouselController extends ChangeNotifier {
  final AnimationQueueController _queue = AnimationQueueController();

  bool _disposed = false;

  /// Creates a controller. One handed to a [Carousel] is never disposed by
  /// that carousel; one it created for itself is.
  CarouselController();

  /// The current fractional page position.
  double get value => _queue.value;

  /// Whether a queued page animation is still running.
  bool get isAnimating => _queue.shouldTick;

  /// Advances a running animation; called by the owning [Carousel].
  void tick(Duration delta) => _queue.tick(delta);

  void next() => jumpTo((_queue.value + 1).roundToDouble());

  void previous() => jumpTo((_queue.value - 1).roundToDouble());

  /// Animates to [target] over [duration], replacing a queued animation.
  void animateTo(
    double target,
    Duration duration, [
    Curve curve = Curves.easeInOut,
  ]) => _queue.push(AnimationRequest(target, duration, curve), false);

  /// Jumps to [target] without animating.
  void jumpTo(double target) => _queue.value = target;

  /// The index [value] resolves to inside `[0, itemCount)`: wraps when [wrap]
  /// is true, clamps otherwise, and is untouched for an unbounded carousel.
  double resolvedIndex({required int? itemCount, required bool wrap}) {
    final count = itemCount;
    if (count == null || count <= 0) {
      return _queue.value;
    }
    if (wrap) {
      return wrapDouble(_queue.value, 0, count.toDouble());
    }
    return _queue.value.clamp(0.0, count.toDouble() - 1);
  }

  /// Marks this controller as owned by a [Carousel], which must therefore
  /// not dispose it.
  void attach() {}

  @override
  void addListener(VoidCallback listener) => _queue.addListener(listener);

  @override
  void removeListener(VoidCallback listener) => _queue.removeListener(listener);

  @override
  void dispose() {
    if (_disposed) {
      return;
    }
    _disposed = true;
    _queue.dispose();
    super.dispose();
  }
}

// ---------------------------------------------------------------------------
// Layout math (pure functions, no widget state).
// ---------------------------------------------------------------------------

/// Pages before and after the current one the [viewport] still needs. Guarded
/// against a zero [extent]: `ceil` on the resulting infinity throws.
(int, int) carouselVisibleRange(
  CarouselTheme theme,
  double extent,
  double viewport,
) {
  if (extent <= 0) {
    return (0, 0);
  }
  final double free = (viewport - extent).abs();
  final double offset = free * theme.alignment!.alignment;
  return (1 + _ceilDiv(offset, extent), 1 + _ceilDiv(free - offset, extent));
}

int _ceilDiv(double numerator, double denominator) =>
    numerator <= 0 ? 0 : (numerator / denominator).ceil();

/// The page [index] shows, wrapping into `[0, itemCount)`.
int carouselPageAt(int index, int? itemCount) {
  final int? count = itemCount;
  if (count == null) {
    return index;
  }
  final int wrapped = index % count;
  return wrapped < 0 ? wrapped + count : wrapped;
}

/// Whether a page at [index] may be built at all.
bool carouselPageVisible(int index, int? itemCount, bool wrap) {
  final int? count = itemCount;
  return count == null || wrap || (index >= 0 && index < count);
}

/// The page an autoplay step lands on; a non-wrapping carousel stops at the
/// ends instead of looping.
double carouselStepTarget({
  required double value,
  required int? itemCount,
  required bool wrap,
  required bool reverse,
}) {
  final double to = value + (reverse ? -1 : 1);
  final int? count = itemCount;
  if (count == null || wrap) {
    return to;
  }
  return to.clamp(0.0, count.toDouble() - 1);
}

/// The whole page a drag fling lands on: the pointer velocity (px/s) is
/// projected forward over a short horizon, capped at one page (a violent
/// flick must not skip ten), then rounded. A [velocity] of 0 snaps to the
/// nearest page.
double carouselSnapTarget({
  required double value,
  required double velocity,
  required double extent,
  required int? itemCount,
  required bool wrap,
}) {
  final double page = extent > 0 ? extent : 1;
  // 100 ms of travel at release velocity, in pages, capped at one page.
  final double fling = (-velocity * 0.1 / page).clamp(-1.0, 1.0);
  final double target = (value + fling).roundToDouble();
  final int? count = itemCount;
  if (count == null || wrap) {
    return target;
  }
  return target.clamp(0.0, count.toDouble() - 1);
}
