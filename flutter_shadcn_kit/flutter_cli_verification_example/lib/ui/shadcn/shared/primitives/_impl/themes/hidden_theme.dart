part of '../../hidden.dart';

/// HiddenTheme defines a reusable type for this registry module.
class HiddenTheme extends ComponentThemeData {
/// Stores `direction` state/configuration for this implementation.
  final Axis? direction;
/// Stores `duration` state/configuration for this implementation.
  final Duration? duration;
/// Stores `curve` state/configuration for this implementation.
  final Curve? curve;
/// Stores `reverse` state/configuration for this implementation.
  final bool? reverse;
/// Stores `keepCrossAxisSize` state/configuration for this implementation.
  final bool? keepCrossAxisSize;
/// Stores `keepMainAxisSize` state/configuration for this implementation.
  final bool? keepMainAxisSize;

/// Creates a `HiddenTheme` instance.
  const HiddenTheme({
    super.themeDensity,
    super.themeSpacing,
    super.themeShadows,
    this.direction,
    this.duration,
    this.curve,
    this.reverse,
    this.keepCrossAxisSize,
    this.keepMainAxisSize,
  });

/// Creates a `HiddenTheme` instance.
  HiddenTheme copyWith({
    ValueGetter<Axis?>? direction,
    ValueGetter<Duration?>? duration,
    ValueGetter<Curve?>? curve,
    ValueGetter<bool?>? reverse,
    ValueGetter<bool?>? keepCrossAxisSize,
    ValueGetter<bool?>? keepMainAxisSize,
  }) {
    return HiddenTheme(
      direction: direction == null ? this.direction : direction(),
      duration: duration == null ? this.duration : duration(),
      curve: curve == null ? this.curve : curve(),
      reverse: reverse == null ? this.reverse : reverse(),
      keepCrossAxisSize: keepCrossAxisSize == null
          ? this.keepCrossAxisSize
          : keepCrossAxisSize(),
      keepMainAxisSize: keepMainAxisSize == null
          ? this.keepMainAxisSize
          : keepMainAxisSize(),
    );
  }
}

/// A widget that conditionally hides its child with optional animation.
