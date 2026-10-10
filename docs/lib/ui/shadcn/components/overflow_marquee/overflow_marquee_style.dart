// Registry-owned theme data for the `overflow_marquee` component: the
// [OverflowMarqueeTheme] container and `overflowMarqueeDefaults`.
//
// User-owned overrides live in `overflow_marquee_theme.dart`; CLI updates may
// replace this file. All defaults are plain values, so the default theme
// stays const and resolves at build.

import 'dart:ui' show lerpDouble;

import 'package:flutter/widgets.dart';

import '../../theme/color_tokens.dart';
import '../../theme/theme.dart';

/// Direction, timing and edge fade of one marquee.
///
/// Every field is nullable: an override leg sets only what it changes and
/// [merge] keeps the lower leg's remaining fields.
class OverflowMarqueeTheme extends ComponentThemeData
    implements Mergeable<OverflowMarqueeTheme> {
  /// Creates a marquee theme.
  const OverflowMarqueeTheme({
    super.themeDensity,
    super.themeSpacing,
    super.themeShadows,
    this.direction,
    this.duration,
    this.delayDuration,
    this.step,
    this.fadePortion,
    this.curve,
  });

  /// Scroll axis; null resolves `Axis.horizontal`.
  final Axis? direction;

  /// Time of one `step` run; null resolves `1s`.
  final Duration? duration;

  /// Pause at each end of a run; null resolves `500ms`.
  final Duration? delayDuration;

  /// Pixels per [duration]; null resolves `100`.
  final double? step;

  /// Edge fade as a fraction of the visible extent; null resolves `0.1`.
  final double? fadePortion;

  /// Easing of each run; null resolves `Curves.linear`.
  final Curve? curve;

  /// Returns a copy with the given fields replaced.
  OverflowMarqueeTheme copyWith({
    ValueGetter<Axis?>? direction,
    ValueGetter<Duration?>? duration,
    ValueGetter<Duration?>? delayDuration,
    ValueGetter<double?>? step,
    ValueGetter<double?>? fadePortion,
    ValueGetter<Curve?>? curve,
  }) {
    return OverflowMarqueeTheme(
      themeDensity: themeDensity,
      themeSpacing: themeSpacing,
      themeShadows: themeShadows,
      direction: direction == null ? this.direction : direction(),
      duration: duration == null ? this.duration : duration(),
      delayDuration: delayDuration == null
          ? this.delayDuration
          : delayDuration(),
      step: step == null ? this.step : step(),
      fadePortion: fadePortion == null ? this.fadePortion : fadePortion(),
      curve: curve == null ? this.curve : curve(),
    );
  }

  /// First-non-null-wins merge; the receiver (higher-priority leg) wins.
  @override
  OverflowMarqueeTheme merge(OverflowMarqueeTheme? fallback) {
    if (fallback == null) {
      return this;
    }
    return OverflowMarqueeTheme(
      themeDensity: themeDensity ?? fallback.themeDensity,
      themeSpacing: themeSpacing ?? fallback.themeSpacing,
      themeShadows: themeShadows ?? fallback.themeShadows,
      direction: direction ?? fallback.direction,
      duration: duration ?? fallback.duration,
      delayDuration: delayDuration ?? fallback.delayDuration,
      step: step ?? fallback.step,
      fadePortion: fadePortion ?? fallback.fadePortion,
      curve: curve ?? fallback.curve,
    );
  }

  /// Discrete values step at t < 0.5; scalars are lerped.
  static OverflowMarqueeTheme lerp(
    OverflowMarqueeTheme a,
    OverflowMarqueeTheme b,
    double t,
  ) {
    return OverflowMarqueeTheme(
      themeDensity: t < 0.5 ? a.themeDensity : b.themeDensity,
      themeSpacing: t < 0.5 ? a.themeSpacing : b.themeSpacing,
      themeShadows: t < 0.5 ? a.themeShadows : b.themeShadows,
      direction: t < 0.5 ? a.direction : b.direction,
      duration: t < 0.5 ? a.duration : b.duration,
      delayDuration: t < 0.5 ? a.delayDuration : b.delayDuration,
      step: lerpDouble(a.step, b.step, t),
      fadePortion: lerpDouble(a.fadePortion, b.fadePortion, t),
      curve: t < 0.5 ? a.curve : b.curve,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is OverflowMarqueeTheme &&
        other.themeDensity == themeDensity &&
        other.themeSpacing == themeSpacing &&
        other.themeShadows == themeShadows &&
        other.direction == direction &&
        other.duration == duration &&
        other.delayDuration == delayDuration &&
        other.step == step &&
        other.fadePortion == fadePortion &&
        other.curve == curve;
  }

  @override
  int get hashCode => Object.hash(
    themeDensity,
    themeSpacing,
    themeShadows,
    direction,
    duration,
    delayDuration,
    step,
    fadePortion,
    curve,
  );
}

/// Token-derived baseline; every unset override field falls through here.
const OverflowMarqueeTheme overflowMarqueeDefaults = OverflowMarqueeTheme(
  direction: Axis.horizontal,
  duration: Duration(seconds: 1),
  delayDuration: Duration(milliseconds: 500),
  step: 100,
  fadePortion: 0.1,
);

// ---------------------------------------------------------------------------
// Build-time resolution.
// ---------------------------------------------------------------------------

/// Resolved geometry for one marquee build.
class MarqueeSurface {
  /// Creates a resolved surface.
  const MarqueeSurface({
    required this.direction,
    required this.duration,
    required this.delayDuration,
    required this.step,
    required this.fadePortion,
    required this.curve,
    required this.fadeColor,
  });

  /// Scroll axis.
  final Axis direction;

  /// Time of one `step` run.
  final Duration duration;

  /// Pause at each end.
  final Duration delayDuration;

  /// Pixels per [duration].
  final double step;

  /// Edge fade as a fraction of the visible extent.
  final double fadePortion;

  /// Easing of each run.
  final Curve curve;

  /// Colour the edge fade blends into; the ambient `background` token, so the
  /// fade tracks the selected preset in light and dark.
  final Color fadeColor;
}

/// Resolves the four theme legs plus widget-leg overrides into concrete
/// build values.
MarqueeSurface resolveMarqueeSurface(
  BuildContext context, {
  OverflowMarqueeTheme? widgetTheme,
  Axis? direction,
  Duration? duration,
  Duration? delayDuration,
  double? step,
  double? fadePortion,
  Curve? curve,
}) {
  final OverflowMarqueeTheme resolved =
      resolveComponentStyle<OverflowMarqueeTheme, OverflowMarqueeTheme>(
        context,
        widget: widgetTheme,
        select: (t) => t,
        defaults: overflowMarqueeDefaults,
      );
  return MarqueeSurface(
    direction: direction ?? resolved.direction ?? Axis.horizontal,
    duration: duration ?? resolved.duration ?? const Duration(seconds: 1),
    delayDuration:
        delayDuration ??
        resolved.delayDuration ??
        const Duration(milliseconds: 500),
    step: step ?? resolved.step ?? 100,
    fadePortion: (fadePortion ?? resolved.fadePortion ?? 0.1).clamp(0.0, 0.5),
    curve: curve ?? resolved.curve ?? Curves.linear,
    fadeColor: ShadcnTheme.of(context).colors.background,
  );
}
