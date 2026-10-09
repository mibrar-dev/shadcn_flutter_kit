// Registry-owned theme data for the `star_rating` component: the shape/colour
// [StarRatingStyle] slice, the [StarRatingTheme] container and the token-
// derived `starRatingDefaults`.
//
// User-owned overrides live in `star_rating_theme.dart`; CLI updates may
// replace this file.

import 'dart:ui' show lerpDouble;

import 'package:flutter/widgets.dart';

import '../../theme/color_tokens.dart';
import '../../theme/theme.dart';

/// Appearance of the star row: colours, size, spacing and star geometry.
///
/// Every field is nullable: an override leg sets only what it changes and
/// [merge] keeps the lower leg's remaining fields.
class StarRatingStyle implements Mergeable<StarRatingStyle> {
  /// Creates a star rating style slice.
  const StarRatingStyle({
    this.activeColor,
    this.inactiveColor,
    this.size,
    this.spacing,
    this.points,
    this.pointRounding,
    this.valleyRounding,
    this.squash,
    this.innerRadiusRatio,
    this.rotation,
  });

  /// Fill colour of the filled part of a star.
  final ThemedColor? activeColor;

  /// Colour of the unfilled part of a star.
  final ThemedColor? inactiveColor;

  /// Side length of one star.
  final double? size;

  /// Gap between two stars.
  final double? spacing;

  /// Number of star points.
  final double? points;

  /// Point rounding as a fraction of the star's size (0..1).
  final double? pointRounding;

  /// Valley rounding as a fraction of the star's size (0..1).
  final double? valleyRounding;

  /// Vertical compression (0 = natural, 1 = fully squashed).
  final double? squash;

  /// Inner-to-outer radius ratio (smaller = deeper valleys).
  final double? innerRadiusRatio;

  /// Rotation in *degrees* (the old field documented radians but handed the
  /// value to `StarBorder.rotation`, which is degrees).
  final double? rotation;

  /// First-non-null-wins merge; the receiver (higher-priority leg) wins.
  @override
  StarRatingStyle merge(StarRatingStyle? fallback) {
    if (fallback == null) {
      return this;
    }
    return StarRatingStyle(
      activeColor: activeColor ?? fallback.activeColor,
      inactiveColor: inactiveColor ?? fallback.inactiveColor,
      size: size ?? fallback.size,
      spacing: spacing ?? fallback.spacing,
      points: points ?? fallback.points,
      pointRounding: pointRounding ?? fallback.pointRounding,
      valleyRounding: valleyRounding ?? fallback.valleyRounding,
      squash: squash ?? fallback.squash,
      innerRadiusRatio: innerRadiusRatio ?? fallback.innerRadiusRatio,
      rotation: rotation ?? fallback.rotation,
    );
  }

  /// Lerps scalar fields; colour references step at t < 0.5.
  static StarRatingStyle lerp(StarRatingStyle a, StarRatingStyle b, double t) {
    return StarRatingStyle(
      activeColor: t < 0.5 ? a.activeColor : b.activeColor,
      inactiveColor: t < 0.5 ? a.inactiveColor : b.inactiveColor,
      size: lerpDouble(a.size, b.size, t),
      spacing: lerpDouble(a.spacing, b.spacing, t),
      points: lerpDouble(a.points, b.points, t),
      pointRounding: lerpDouble(a.pointRounding, b.pointRounding, t),
      valleyRounding: lerpDouble(a.valleyRounding, b.valleyRounding, t),
      squash: lerpDouble(a.squash, b.squash, t),
      innerRadiusRatio: lerpDouble(a.innerRadiusRatio, b.innerRadiusRatio, t),
      rotation: lerpDouble(a.rotation, b.rotation, t),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is StarRatingStyle &&
        other.activeColor == activeColor &&
        other.inactiveColor == inactiveColor &&
        other.size == size &&
        other.spacing == spacing &&
        other.points == points &&
        other.pointRounding == pointRounding &&
        other.valleyRounding == valleyRounding &&
        other.squash == squash &&
        other.innerRadiusRatio == innerRadiusRatio &&
        other.rotation == rotation;
  }

  @override
  int get hashCode => Object.hash(
    activeColor,
    inactiveColor,
    size,
    spacing,
    points,
    pointRounding,
    valleyRounding,
    squash,
    innerRadiusRatio,
    rotation,
  );
}

/// Theme container for the star rating component.
class StarRatingTheme extends ComponentThemeData
    implements Mergeable<StarRatingTheme> {
  /// Creates a star rating theme.
  const StarRatingTheme({
    super.themeDensity,
    super.themeSpacing,
    super.themeShadows,
    this.style,
  });

  /// The star appearance slice; null in a leg that does not restyle stars.
  final StarRatingStyle? style;

  /// Returns a copy with the given field replaced.
  StarRatingTheme copyWith({ValueGetter<StarRatingStyle?>? style}) {
    return StarRatingTheme(
      themeDensity: themeDensity,
      themeSpacing: themeSpacing,
      themeShadows: themeShadows,
      style: style == null ? this.style : style(),
    );
  }

  /// First-non-null-wins merge; the receiver (higher-priority leg) wins.
  @override
  StarRatingTheme merge(StarRatingTheme? fallback) {
    if (fallback == null) {
      return this;
    }
    return StarRatingTheme(
      themeDensity: themeDensity ?? fallback.themeDensity,
      themeSpacing: themeSpacing ?? fallback.themeSpacing,
      themeShadows: themeShadows ?? fallback.themeShadows,
      style: style?.merge(fallback.style) ?? fallback.style,
    );
  }

  /// Lerps each field; the colour reference steps at t < 0.5.
  static StarRatingTheme lerp(StarRatingTheme a, StarRatingTheme b, double t) {
    return StarRatingTheme(
      themeDensity: t < 0.5 ? a.themeDensity : b.themeDensity,
      themeSpacing: t < 0.5 ? a.themeSpacing : b.themeSpacing,
      themeShadows: t < 0.5 ? a.themeShadows : b.themeShadows,
      style: a.style == null
          ? b.style
          : (b.style == null
                ? a.style
                : StarRatingStyle.lerp(a.style!, b.style!, t)),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is StarRatingTheme &&
        other.themeDensity == themeDensity &&
        other.themeSpacing == themeSpacing &&
        other.themeShadows == themeShadows &&
        other.style == style;
  }

  @override
  int get hashCode =>
      Object.hash(themeDensity, themeSpacing, themeShadows, style);
}

/// Token-derived baseline for the star row.
const StarRatingTheme starRatingDefaults = StarRatingTheme(
  style: StarRatingStyle(
    activeColor: ThemedColor.ref(ColorRef.primary),
    inactiveColor: ThemedColor.ref(ColorRef.muted),
    size: 24,
    spacing: 5,
    points: 5,
    pointRounding: 0,
    valleyRounding: 0,
    squash: 0,
    innerRadiusRatio: 0.4,
    rotation: 0,
  ),
);
