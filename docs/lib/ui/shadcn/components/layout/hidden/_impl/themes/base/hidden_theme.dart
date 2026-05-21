// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../../hidden.dart';

/// Theme data for [Hidden].
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

  @override
  /// Executes `operator ==` behavior for this component/composite.
  bool operator ==(Object other) {
    return other is HiddenTheme &&
        other.direction == direction &&
        other.duration == duration &&
        other.curve == curve &&
        other.reverse == reverse &&
        other.keepCrossAxisSize == keepCrossAxisSize &&
        other.keepMainAxisSize == keepMainAxisSize;
  }

  @override
  int get hashCode => Object.hash(
    direction,
    duration,
    curve,
    reverse,
    keepCrossAxisSize,
    keepMainAxisSize,
  );
}
