// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../../linear_progress_indicator.dart';

/// Theme data for [LinearProgressIndicator].
class LinearProgressIndicatorTheme extends ComponentThemeData {
  /// Color value used by linear progress indicator painting or state styling.
  final Color? color;

  /// Color value used by linear progress indicator painting or state styling.
  final Color? backgroundColor;

  /// Layout/size setting that affects linear progress indicator rendering.
  final double? minHeight;

  /// Layout/size setting that affects linear progress indicator rendering.
  final BorderRadiusGeometry? borderRadius;

  /// Input parameter used by `LinearProgressIndicatorTheme` during rendering and behavior handling.
  final bool? showSparks;

  /// Animation/progress setting used by linear progress indicator transitions.
  final bool? disableAnimation;

  /// Creates `LinearProgressIndicatorTheme` for configuring or rendering linear progress indicator.
  const LinearProgressIndicatorTheme({
    super.themeDensity,
    super.themeSpacing,
    super.themeShadows,
    this.color,
    this.backgroundColor,
    this.minHeight,
    this.borderRadius,
    this.showSparks,
    this.disableAnimation,
  });

  LinearProgressIndicatorTheme copyWith({
    ValueGetter<Color?>? color,
    ValueGetter<Color?>? backgroundColor,
    ValueGetter<double?>? minHeight,
    ValueGetter<BorderRadiusGeometry?>? borderRadius,
    ValueGetter<bool?>? showSparks,
    ValueGetter<bool?>? disableAnimation,
  }) {
    return LinearProgressIndicatorTheme(
      color: color == null ? this.color : color(),
      backgroundColor: backgroundColor == null
          ? this.backgroundColor
          : backgroundColor(),
      minHeight: minHeight == null ? this.minHeight : minHeight(),
      borderRadius: borderRadius == null ? this.borderRadius : borderRadius(),
      showSparks: showSparks == null ? this.showSparks : showSparks(),
      disableAnimation: disableAnimation == null
          ? this.disableAnimation
          : disableAnimation(),
    );
  }

  /// Compares two linear progress indicator values for structural equality.
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is LinearProgressIndicatorTheme &&
        other.color == color &&
        other.backgroundColor == backgroundColor &&
        other.minHeight == minHeight &&
        other.borderRadius == borderRadius &&
        other.showSparks == showSparks &&
        other.disableAnimation == disableAnimation;
  }

  @override
  int get hashCode => Object.hash(
    color,
    backgroundColor,
    minHeight,
    borderRadius,
    showSparks,
    disableAnimation,
  );
}
