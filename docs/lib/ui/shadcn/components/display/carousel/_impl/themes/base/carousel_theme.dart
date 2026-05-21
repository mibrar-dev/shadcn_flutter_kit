// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../../carousel.dart';

/// Theme data for [Carousel].
class CarouselTheme extends ComponentThemeData {
  /// The alignment of carousel items.
  final CarouselAlignment? alignment;

  /// The scroll direction (horizontal or vertical).
  final Axis? direction;

  /// Whether to wrap around to the beginning after reaching the end.
  final bool? wrap;

  /// Whether to pause autoplay on hover.
  final bool? pauseOnHover;

  /// The duration between automatic slides.
  final Duration? autoplaySpeed;

  /// Whether the carousel can be dragged.
  final bool? draggable;

  /// The transition animation speed.
  final Duration? speed;

  /// The transition animation curve.
  final Curve? curve;

  /// Creates a carousel theme.
  const CarouselTheme({
    super.themeDensity,
    super.themeSpacing,
    super.themeShadows,
    this.alignment,
    this.direction,
    this.wrap,
    this.pauseOnHover,
    this.autoplaySpeed,
    this.draggable,
    this.speed,
    this.curve,
  });

  /// Creates a copy of this theme with the given fields replaced.
  CarouselTheme copyWith({
    ValueGetter<CarouselAlignment?>? alignment,
    ValueGetter<Axis?>? direction,
    ValueGetter<bool?>? wrap,
    ValueGetter<bool?>? pauseOnHover,
    ValueGetter<Duration?>? autoplaySpeed,
    ValueGetter<bool?>? draggable,
    ValueGetter<Duration?>? speed,
    ValueGetter<Curve?>? curve,
  }) {
    return CarouselTheme(
      alignment: alignment == null ? this.alignment : alignment(),
      direction: direction == null ? this.direction : direction(),
      wrap: wrap == null ? this.wrap : wrap(),
      pauseOnHover: pauseOnHover == null ? this.pauseOnHover : pauseOnHover(),
      autoplaySpeed: autoplaySpeed == null
          ? this.autoplaySpeed
          : autoplaySpeed(),
      draggable: draggable == null ? this.draggable : draggable(),
      speed: speed == null ? this.speed : speed(),
      curve: curve == null ? this.curve : curve(),
    );
  }

  /// Compares two carousel values for structural equality.
  @override
  bool operator ==(Object other) {
    return other is CarouselTheme &&
        other.alignment == alignment &&
        other.direction == direction &&
        other.wrap == wrap &&
        other.pauseOnHover == pauseOnHover &&
        other.autoplaySpeed == autoplaySpeed &&
        other.draggable == draggable &&
        other.speed == speed &&
        other.curve == curve;
  }

  @override
  int get hashCode => Object.hash(
    alignment,
    direction,
    wrap,
    pauseOnHover,
    autoplaySpeed,
    draggable,
    speed,
    curve,
  );
}
