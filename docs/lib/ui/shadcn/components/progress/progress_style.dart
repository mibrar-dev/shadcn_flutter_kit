// Registry-owned theme data for the `progress` component: the [ProgressTheme]
// container and the token-derived `progressDefaults`.
//
// User-owned overrides live in `progress_theme.dart`; CLI updates may replace
// this file. The widget reads the resolved theme through
// `resolveComponentStyle<ProgressTheme, ProgressTheme>` from `theme/theme.dart`.

import 'dart:ui' show lerpDouble;

import 'package:flutter/widgets.dart';

import '../../theme/color_tokens.dart';
import '../../theme/theme.dart';

/// One progress bar's visual contract.
///
/// Every field is nullable: an override leg sets only what it changes and
/// [merge] keeps the lower leg's remaining fields. `borderRadius` resolves at
/// build because its default follows the bar height (a pill).
class ProgressTheme extends ComponentThemeData
    implements Mergeable<ProgressTheme> {
  /// Creates a progress theme.
  const ProgressTheme({
    super.themeDensity,
    super.themeSpacing,
    super.themeShadows,
    this.color,
    this.backgroundColor,
    this.height,
    this.borderRadius,
    this.showSparks,
    this.disableAnimation,
  });

  /// Fill colour; null resolves the `primary` token.
  final ThemedColor? color;

  /// Track colour; null resolves [color] at 20% alpha.
  final ThemedColor? backgroundColor;

  /// Bar height in logical pixels; null resolves `8 * scaling`.
  final double? height;

  /// Corner radius; null resolves a pill at half the height.
  final BorderRadiusGeometry? borderRadius;

  /// Whether to paint a glow at the leading edge of the fill.
  final bool? showSparks;

  /// Whether value changes jump instead of animating.
  final bool? disableAnimation;

  /// Returns a copy with the given fields replaced.
  ProgressTheme copyWith({
    ValueGetter<ThemedColor?>? color,
    ValueGetter<ThemedColor?>? backgroundColor,
    ValueGetter<double?>? height,
    ValueGetter<BorderRadiusGeometry?>? borderRadius,
    ValueGetter<bool?>? showSparks,
    ValueGetter<bool?>? disableAnimation,
  }) {
    return ProgressTheme(
      themeDensity: themeDensity,
      themeSpacing: themeSpacing,
      themeShadows: themeShadows,
      color: color == null ? this.color : color(),
      backgroundColor: backgroundColor == null
          ? this.backgroundColor
          : backgroundColor(),
      height: height == null ? this.height : height(),
      borderRadius: borderRadius == null ? this.borderRadius : borderRadius(),
      showSparks: showSparks == null ? this.showSparks : showSparks(),
      disableAnimation: disableAnimation == null
          ? this.disableAnimation
          : disableAnimation(),
    );
  }

  /// First-non-null-wins merge; the receiver (higher-priority leg) wins.
  @override
  ProgressTheme merge(ProgressTheme? fallback) {
    if (fallback == null) {
      return this;
    }
    return ProgressTheme(
      themeDensity: themeDensity ?? fallback.themeDensity,
      themeSpacing: themeSpacing ?? fallback.themeSpacing,
      themeShadows: themeShadows ?? fallback.themeShadows,
      color: color ?? fallback.color,
      backgroundColor: backgroundColor ?? fallback.backgroundColor,
      height: height ?? fallback.height,
      borderRadius: borderRadius ?? fallback.borderRadius,
      showSparks: showSparks ?? fallback.showSparks,
      disableAnimation: disableAnimation ?? fallback.disableAnimation,
    );
  }

  /// Colours and flags step at t < 0.5; dimensions are lerped.
  static ProgressTheme lerp(ProgressTheme a, ProgressTheme b, double t) {
    return ProgressTheme(
      themeDensity: t < 0.5 ? a.themeDensity : b.themeDensity,
      themeSpacing: t < 0.5 ? a.themeSpacing : b.themeSpacing,
      themeShadows: t < 0.5 ? a.themeShadows : b.themeShadows,
      color: t < 0.5 ? a.color : b.color,
      backgroundColor: t < 0.5 ? a.backgroundColor : b.backgroundColor,
      height: lerpDouble(a.height, b.height, t),
      borderRadius: BorderRadiusGeometry.lerp(
        a.borderRadius,
        b.borderRadius,
        t,
      ),
      showSparks: t < 0.5 ? a.showSparks : b.showSparks,
      disableAnimation: t < 0.5 ? a.disableAnimation : b.disableAnimation,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is ProgressTheme &&
        other.themeDensity == themeDensity &&
        other.themeSpacing == themeSpacing &&
        other.themeShadows == themeShadows &&
        other.color == color &&
        other.backgroundColor == backgroundColor &&
        other.height == height &&
        other.borderRadius == borderRadius &&
        other.showSparks == showSparks &&
        other.disableAnimation == disableAnimation;
  }

  @override
  int get hashCode => Object.hash(
    themeDensity,
    themeSpacing,
    themeShadows,
    color,
    backgroundColor,
    height,
    borderRadius,
    showSparks,
    disableAnimation,
  );
}

/// Token-derived baseline; every unset override field falls through here.
///
/// `backgroundColor` is the fill token at 20% alpha (alpha multiplies the
/// token's own alpha), matching the old derived track colour.
const ProgressTheme progressDefaults = ProgressTheme(
  color: ThemedColor.ref(ColorRef.primary),
  backgroundColor: ThemedColor.ref(ColorRef.primary, alpha: 0.2),
  height: 8,
  showSparks: false,
  disableAnimation: false,
);

// ---------------------------------------------------------------------------
// Build-time resolution.
// ---------------------------------------------------------------------------

/// Resolved visual values for one progress build.
class ProgressSurface {
  /// Creates a resolved surface.
  const ProgressSurface({
    required this.color,
    required this.backgroundColor,
    required this.height,
    required this.borderRadius,
    required this.showSparks,
    required this.animate,
  });

  /// Fill colour.
  final Color color;

  /// Track colour.
  final Color backgroundColor;

  /// Bar height.
  final double height;

  /// Corner radius.
  final BorderRadiusGeometry borderRadius;

  /// Whether the leading-edge glow is painted.
  final bool showSparks;

  /// Whether value changes animate.
  final bool animate;
}

/// Resolves the four theme legs plus the widget-leg overrides into concrete
/// build values.
ProgressSurface resolveProgressSurface(
  BuildContext context, {
  ProgressTheme? widgetTheme,
  double? height,
  BorderRadiusGeometry? borderRadius,
  Color? color,
  Color? backgroundColor,
  bool? showSparks,
  bool? disableAnimation,
}) {
  final ShadcnThemeData theme = ShadcnTheme.of(context);
  final ShadcnColors colors = theme.colors;
  final resolved = resolveComponentStyle<ProgressTheme, ProgressTheme>(
    context,
    widget: widgetTheme,
    select: (t) => t,
    defaults: progressDefaults,
  );
  final double effectiveHeight = height ?? resolved.height ?? 8 * theme.scaling;
  final Color fill = color ?? resolved.color?.resolve(colors) ?? colors.primary;
  final Color track =
      backgroundColor ??
      resolved.backgroundColor?.resolve(colors) ??
      fill.withValues(alpha: fill.a * 0.2);
  return ProgressSurface(
    color: fill,
    backgroundColor: track,
    height: effectiveHeight,
    borderRadius:
        borderRadius ??
        resolved.borderRadius ??
        BorderRadius.circular(effectiveHeight / 2),
    showSparks: showSparks ?? resolved.showSparks ?? false,
    animate: !(disableAnimation ?? resolved.disableAnimation ?? false),
  );
}
