// Registry-owned theme data for the `skeleton` component: the [SkeletonTheme]
// container and the token-derived `skeletonDefaults`.
//
// User-owned overrides live in `skeleton_theme.dart`; CLI updates may replace
// this file.
//
// Fixes against the old theme:
//   * `SkeletonThemeDefaults` hard-coded `0x0D171717` / `0x1A171717` while
//     `ShadcnSkeletonizerConfigLayer` defaulted to `primary.scaleAlpha(0.05)`
//     and `primary.scaleAlpha(0.1)` — two different fills for one component.
//     Both are tokens now (`muted` → `accent`).
//   * `fromColor`/`toColor` were `Color?`, so an override could not follow a
//     preset switch; they are [ThemedColor] like every other component row.
//   * There was no `Mergeable`, no app leg and no `ComponentThemeData` slots in
//     `copyWith`, so app-wide overrides never applied.

import 'package:flutter/widgets.dart';

import '../../theme/color_tokens.dart';
import '../../theme/theme.dart';

/// Visual contract of one skeleton placeholder.
class SkeletonTheme extends ComponentThemeData
    implements Mergeable<SkeletonTheme> {
  /// Creates a skeleton theme.
  const SkeletonTheme({
    super.themeDensity,
    super.themeSpacing,
    super.themeShadows,
    this.fromColor,
    this.toColor,
    this.duration,
    this.curve,
    this.borderRadius,
  });

  /// Leading fill of the shimmer sweep; null resolves the `muted` token.
  final ThemedColor? fromColor;

  /// Trailing fill of the shimmer sweep; null resolves the `accent` token.
  final ThemedColor? toColor;

  /// Length of one sweep; null resolves [kDefaultDuration] * 2.
  final Duration? duration;

  /// Sweep easing; null resolves [Curves.linear].
  final Curve? curve;

  /// Corner radius of the placeholder; null resolves `radiusMd`.
  final BorderRadiusGeometry? borderRadius;

  /// Returns a copy with the given fields replaced.
  SkeletonTheme copyWith({
    ValueGetter<ThemedColor?>? fromColor,
    ValueGetter<ThemedColor?>? toColor,
    ValueGetter<Duration?>? duration,
    ValueGetter<Curve?>? curve,
    ValueGetter<BorderRadiusGeometry?>? borderRadius,
  }) {
    return SkeletonTheme(
      themeDensity: themeDensity,
      themeSpacing: themeSpacing,
      themeShadows: themeShadows,
      fromColor: fromColor == null ? this.fromColor : fromColor(),
      toColor: toColor == null ? this.toColor : toColor(),
      duration: duration == null ? this.duration : duration(),
      curve: curve == null ? this.curve : curve(),
      borderRadius: borderRadius == null ? this.borderRadius : borderRadius(),
    );
  }

  /// First-non-null-wins merge; the receiver (higher-priority leg) wins.
  @override
  SkeletonTheme merge(SkeletonTheme? fallback) {
    if (fallback == null) {
      return this;
    }
    return SkeletonTheme(
      themeDensity: themeDensity ?? fallback.themeDensity,
      themeSpacing: themeSpacing ?? fallback.themeSpacing,
      themeShadows: themeShadows ?? fallback.themeShadows,
      fromColor: fromColor ?? fallback.fromColor,
      toColor: toColor ?? fallback.toColor,
      duration: duration ?? fallback.duration,
      curve: curve ?? fallback.curve,
      borderRadius: borderRadius ?? fallback.borderRadius,
    );
  }

  /// State scales step at t < 0.5; dimensions and durations lerp.
  static SkeletonTheme lerp(SkeletonTheme a, SkeletonTheme b, double t) {
    return SkeletonTheme(
      themeDensity: t < 0.5 ? a.themeDensity : b.themeDensity,
      themeSpacing: t < 0.5 ? a.themeSpacing : b.themeSpacing,
      themeShadows: t < 0.5 ? a.themeShadows : b.themeShadows,
      fromColor: t < 0.5 ? a.fromColor : b.fromColor,
      toColor: t < 0.5 ? a.toColor : b.toColor,
      duration: t < 0.5 ? a.duration : b.duration,
      curve: t < 0.5 ? a.curve : b.curve,
      borderRadius: BorderRadiusGeometry.lerp(
        a.borderRadius,
        b.borderRadius,
        t,
      ),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is SkeletonTheme &&
        other.themeDensity == themeDensity &&
        other.themeSpacing == themeSpacing &&
        other.themeShadows == themeShadows &&
        other.fromColor == fromColor &&
        other.toColor == toColor &&
        other.duration == duration &&
        other.curve == curve &&
        other.borderRadius == borderRadius;
  }

  @override
  int get hashCode => Object.hash(
    themeDensity,
    themeSpacing,
    themeShadows,
    fromColor,
    toColor,
    duration,
    curve,
    borderRadius,
  );
}

/// One full sweep. The old `SkeletonThemeDefaults.duration` was one second for
/// a `Skeletonizer` `PulseEffect`, which sweeps 0 -> 1 -> 0, so one visual
/// pass took half of that.
const Duration kSkeletonSweepDuration = Duration(milliseconds: 800);

/// Token-derived baseline; every unset override field falls through here.
const SkeletonTheme skeletonDefaults = SkeletonTheme(
  fromColor: ThemedColor.ref(ColorRef.muted),
  toColor: ThemedColor.ref(ColorRef.accent),
  duration: kSkeletonSweepDuration,
  curve: Curves.linear,
);

/// The sweep fraction at which [SkeletonTheme.fromColor] hands over to
/// [SkeletonTheme.toColor] and starts travelling back.
const double kSkeletonSweepHandover = 0.5;

/// Extra length used to fade the sweep in and out at both ends.
const double kSkeletonSweepFade = 0.15;
