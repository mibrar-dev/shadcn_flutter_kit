// Registry-owned theme data for the `spinner` component: the [SpinnerTheme]
// container and the token-derived `spinnerDefaults`.
//
// User-owned overrides live in `spinner_theme.dart`; CLI updates may replace
// this file. The widget reads the resolved theme through
// `resolveComponentStyle<SpinnerTheme, SpinnerTheme>` from `theme/theme.dart`.

import 'dart:ui' show lerpDouble;

import 'package:flutter/widgets.dart';

import '../../theme/color_tokens.dart';
import '../../theme/theme.dart';

/// One spinner's visual contract.
///
/// Every field is nullable: an override leg sets only what it changes and
/// [merge] keeps the lower leg's remaining fields. `strokeWidth` resolves at
/// build because its default follows the diameter (`size / 12`).
class SpinnerTheme extends ComponentThemeData
    implements Mergeable<SpinnerTheme> {
  /// Creates a spinner theme.
  const SpinnerTheme({
    super.themeDensity,
    super.themeSpacing,
    super.themeShadows,
    this.size,
    this.strokeWidth,
    this.color,
  });

  /// Diameter in logical pixels; null resolves `24 * scaling`.
  final double? size;

  /// Arc thickness; null resolves `size / 12`.
  final double? strokeWidth;

  /// Arc colour; null resolves the `primary` token.
  final ThemedColor? color;

  /// Returns a copy with the given fields replaced.
  SpinnerTheme copyWith({
    ValueGetter<double?>? size,
    ValueGetter<double?>? strokeWidth,
    ValueGetter<ThemedColor?>? color,
  }) {
    return SpinnerTheme(
      themeDensity: themeDensity,
      themeSpacing: themeSpacing,
      themeShadows: themeShadows,
      size: size == null ? this.size : size(),
      strokeWidth: strokeWidth == null ? this.strokeWidth : strokeWidth(),
      color: color == null ? this.color : color(),
    );
  }

  /// First-non-null-wins merge; the receiver (higher-priority leg) wins.
  @override
  SpinnerTheme merge(SpinnerTheme? fallback) {
    if (fallback == null) {
      return this;
    }
    return SpinnerTheme(
      themeDensity: themeDensity ?? fallback.themeDensity,
      themeSpacing: themeSpacing ?? fallback.themeSpacing,
      themeShadows: themeShadows ?? fallback.themeShadows,
      size: size ?? fallback.size,
      strokeWidth: strokeWidth ?? fallback.strokeWidth,
      color: color ?? fallback.color,
    );
  }

  /// Colours step at t < 0.5; dimensions are lerped.
  static SpinnerTheme lerp(SpinnerTheme a, SpinnerTheme b, double t) {
    return SpinnerTheme(
      themeDensity: t < 0.5 ? a.themeDensity : b.themeDensity,
      themeSpacing: t < 0.5 ? a.themeSpacing : b.themeSpacing,
      themeShadows: t < 0.5 ? a.themeShadows : b.themeShadows,
      size: lerpDouble(a.size, b.size, t),
      strokeWidth: lerpDouble(a.strokeWidth, b.strokeWidth, t),
      color: t < 0.5 ? a.color : b.color,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is SpinnerTheme &&
        other.themeDensity == themeDensity &&
        other.themeSpacing == themeSpacing &&
        other.themeShadows == themeShadows &&
        other.size == size &&
        other.strokeWidth == strokeWidth &&
        other.color == color;
  }

  @override
  int get hashCode => Object.hash(
    themeDensity,
    themeSpacing,
    themeShadows,
    size,
    strokeWidth,
    color,
  );
}

/// Token-derived baseline; every unset override field falls through here.
///
/// `size` and `strokeWidth` stay null on purpose: their defaults depend on
/// the ambient scaling factor and resolve at build.
const SpinnerTheme spinnerDefaults = SpinnerTheme(
  color: ThemedColor.ref(ColorRef.primary),
);

// ---------------------------------------------------------------------------
// Build-time resolution.
// ---------------------------------------------------------------------------

/// Resolved visual values for one spinner build.
class SpinnerSurface {
  /// Creates a resolved surface.
  const SpinnerSurface({
    required this.size,
    required this.strokeWidth,
    required this.color,
  });

  /// Diameter.
  final double size;

  /// Arc thickness.
  final double strokeWidth;

  /// Arc colour.
  final Color color;
}

/// Resolves the four theme legs plus the widget-leg overrides into concrete
/// build values.
SpinnerSurface resolveSpinnerSurface(
  BuildContext context, {
  SpinnerTheme? widgetTheme,
  double? size,
  double? strokeWidth,
  Color? color,
}) {
  final ShadcnThemeData theme = ShadcnTheme.of(context);
  final ShadcnColors colors = theme.colors;
  final resolved = resolveComponentStyle<SpinnerTheme, SpinnerTheme>(
    context,
    widget: widgetTheme,
    select: (t) => t,
    defaults: spinnerDefaults,
  );
  final double effectiveSize = size ?? resolved.size ?? 24 * theme.scaling;
  return SpinnerSurface(
    size: effectiveSize,
    strokeWidth: strokeWidth ?? resolved.strokeWidth ?? effectiveSize / 12,
    color: color ?? resolved.color?.resolve(colors) ?? colors.primary,
  );
}
