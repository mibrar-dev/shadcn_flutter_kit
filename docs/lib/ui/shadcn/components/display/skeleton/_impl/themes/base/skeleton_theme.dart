// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../../skeleton.dart';

/// Theme configuration for skeleton loading effects.
class SkeletonTheme extends ComponentThemeData {
  /// Animation/progress setting used by skeleton transitions.
  final Duration? duration;

  /// Color value used by skeleton painting or state styling.
  final Color? fromColor;

  /// Color value used by skeleton painting or state styling.
  final Color? toColor;

  /// Animation/progress setting used by skeleton transitions.
  final bool? enableSwitchAnimation;

  /// Creates `SkeletonTheme` for configuring or rendering skeleton.
  const SkeletonTheme({
    super.themeDensity,
    super.themeSpacing,
    super.themeShadows,
    this.duration,
    this.fromColor,
    this.toColor,
    this.enableSwitchAnimation,
  });

  SkeletonTheme copyWith({
    ValueGetter<Duration?>? duration,
    ValueGetter<Color?>? fromColor,
    ValueGetter<Color?>? toColor,
    ValueGetter<bool?>? enableSwitchAnimation,
  }) {
    return SkeletonTheme(
      duration: duration == null ? this.duration : duration(),
      fromColor: fromColor == null ? this.fromColor : fromColor(),
      toColor: toColor == null ? this.toColor : toColor(),
      enableSwitchAnimation: enableSwitchAnimation == null
          ? this.enableSwitchAnimation
          : enableSwitchAnimation(),
    );
  }

  /// Compares two skeleton values for structural equality.
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SkeletonTheme &&
        other.duration == duration &&
        other.fromColor == fromColor &&
        other.toColor == toColor &&
        other.enableSwitchAnimation == enableSwitchAnimation;
  }

  @override
  int get hashCode =>
      Object.hash(duration, fromColor, toColor, enableSwitchAnimation);
}
