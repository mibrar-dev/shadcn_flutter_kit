// Registry-owned theme data for the `avatar` component: the [AvatarTheme]
// container and the token-derived `avatarDefaults`.
//
// User-owned overrides live in `avatar_theme.dart`; CLI updates may replace
// this file. The widget reads the resolved theme through
// `resolveComponentStyle<AvatarTheme, AvatarTheme>` from `theme/theme.dart`.

import 'dart:ui' show lerpDouble;

import 'package:flutter/widgets.dart';

import '../../theme/color_tokens.dart';
import '../../theme/theme.dart';

/// One avatar's visual contract.
///
/// Every field is nullable: an override leg sets only what it changes and
/// [merge] keeps the lower leg's remaining fields. `size`, `borderRadius` and
/// `badgeSize` resolve at build because their real defaults follow the
/// ambient scaling factor (`32 * scaling`, a full circle, `10 * scaling`).
class AvatarTheme extends ComponentThemeData implements Mergeable<AvatarTheme> {
  /// Creates an avatar theme.
  const AvatarTheme({
    super.themeDensity,
    super.themeSpacing,
    super.themeShadows,
    this.size,
    this.borderRadius,
    this.backgroundColor,
    this.foregroundColor,
    this.textStyle,
    this.badgeSize,
    this.badgeBorderRadius,
    this.badgeColor,
    this.badgeForeground,
    this.badgeAlignment,
    this.badgeGap,
  });

  /// Diameter in logical pixels; null resolves `32 * scaling`.
  final double? size;

  /// Corner radius of the tile; null resolves a full circle.
  final BorderRadiusGeometry? borderRadius;

  /// Fill behind the initials (and behind a transparent image).
  final ThemedColor? backgroundColor;

  /// Initials colour.
  final ThemedColor? foregroundColor;

  /// Initials text style; its colour is overridden by [foregroundColor].
  final TextStyle? textStyle;

  /// Badge diameter; null resolves `10 * scaling`.
  final double? badgeSize;

  /// Badge corner radius; null resolves a full circle.
  final BorderRadiusGeometry? badgeBorderRadius;

  /// Badge fill; null resolves the `primary` token.
  final ThemedColor? badgeColor;

  /// Colour applied to the badge's child (text/icon).
  final ThemedColor? badgeForeground;

  /// Where the badge sits inside the tile.
  final AlignmentGeometry? badgeAlignment;

  /// Inset of the badge from the tile edge.
  final double? badgeGap;

  /// Returns a copy with the given fields replaced.
  AvatarTheme copyWith({
    ValueGetter<double?>? size,
    ValueGetter<BorderRadiusGeometry?>? borderRadius,
    ValueGetter<ThemedColor?>? backgroundColor,
    ValueGetter<ThemedColor?>? foregroundColor,
    ValueGetter<TextStyle?>? textStyle,
    ValueGetter<double?>? badgeSize,
    ValueGetter<BorderRadiusGeometry?>? badgeBorderRadius,
    ValueGetter<ThemedColor?>? badgeColor,
    ValueGetter<ThemedColor?>? badgeForeground,
    ValueGetter<AlignmentGeometry?>? badgeAlignment,
    ValueGetter<double?>? badgeGap,
  }) {
    return AvatarTheme(
      themeDensity: themeDensity,
      themeSpacing: themeSpacing,
      themeShadows: themeShadows,
      size: size == null ? this.size : size(),
      borderRadius: borderRadius == null ? this.borderRadius : borderRadius(),
      backgroundColor: backgroundColor == null
          ? this.backgroundColor
          : backgroundColor(),
      foregroundColor: foregroundColor == null
          ? this.foregroundColor
          : foregroundColor(),
      textStyle: textStyle == null ? this.textStyle : textStyle(),
      badgeSize: badgeSize == null ? this.badgeSize : badgeSize(),
      badgeBorderRadius: badgeBorderRadius == null
          ? this.badgeBorderRadius
          : badgeBorderRadius(),
      badgeColor: badgeColor == null ? this.badgeColor : badgeColor(),
      badgeForeground: badgeForeground == null
          ? this.badgeForeground
          : badgeForeground(),
      badgeAlignment: badgeAlignment == null
          ? this.badgeAlignment
          : badgeAlignment(),
      badgeGap: badgeGap == null ? this.badgeGap : badgeGap(),
    );
  }

  /// First-non-null-wins merge; the receiver (higher-priority leg) wins.
  @override
  AvatarTheme merge(AvatarTheme? fallback) {
    if (fallback == null) {
      return this;
    }
    return AvatarTheme(
      themeDensity: themeDensity ?? fallback.themeDensity,
      themeSpacing: themeSpacing ?? fallback.themeSpacing,
      themeShadows: themeShadows ?? fallback.themeShadows,
      size: size ?? fallback.size,
      borderRadius: borderRadius ?? fallback.borderRadius,
      backgroundColor: backgroundColor ?? fallback.backgroundColor,
      foregroundColor: foregroundColor ?? fallback.foregroundColor,
      textStyle: textStyle == null
          ? fallback.textStyle
          : (fallback.textStyle?.merge(textStyle) ?? textStyle),
      badgeSize: badgeSize ?? fallback.badgeSize,
      badgeBorderRadius: badgeBorderRadius ?? fallback.badgeBorderRadius,
      badgeColor: badgeColor ?? fallback.badgeColor,
      badgeForeground: badgeForeground ?? fallback.badgeForeground,
      badgeAlignment: badgeAlignment ?? fallback.badgeAlignment,
      badgeGap: badgeGap ?? fallback.badgeGap,
    );
  }

  /// Colours and styles step at t < 0.5; dimensions are lerped.
  static AvatarTheme lerp(AvatarTheme a, AvatarTheme b, double t) {
    return AvatarTheme(
      themeDensity: t < 0.5 ? a.themeDensity : b.themeDensity,
      themeSpacing: t < 0.5 ? a.themeSpacing : b.themeSpacing,
      themeShadows: t < 0.5 ? a.themeShadows : b.themeShadows,
      size: lerpDouble(a.size, b.size, t),
      borderRadius: BorderRadiusGeometry.lerp(
        a.borderRadius,
        b.borderRadius,
        t,
      ),
      backgroundColor: t < 0.5 ? a.backgroundColor : b.backgroundColor,
      foregroundColor: t < 0.5 ? a.foregroundColor : b.foregroundColor,
      textStyle: TextStyle.lerp(a.textStyle, b.textStyle, t),
      badgeSize: lerpDouble(a.badgeSize, b.badgeSize, t),
      badgeBorderRadius: BorderRadiusGeometry.lerp(
        a.badgeBorderRadius,
        b.badgeBorderRadius,
        t,
      ),
      badgeColor: t < 0.5 ? a.badgeColor : b.badgeColor,
      badgeForeground: t < 0.5 ? a.badgeForeground : b.badgeForeground,
      badgeAlignment: t < 0.5 ? a.badgeAlignment : b.badgeAlignment,
      badgeGap: lerpDouble(a.badgeGap, b.badgeGap, t),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is AvatarTheme &&
        other.themeDensity == themeDensity &&
        other.themeSpacing == themeSpacing &&
        other.themeShadows == themeShadows &&
        other.size == size &&
        other.borderRadius == borderRadius &&
        other.backgroundColor == backgroundColor &&
        other.foregroundColor == foregroundColor &&
        other.textStyle == textStyle &&
        other.badgeSize == badgeSize &&
        other.badgeBorderRadius == badgeBorderRadius &&
        other.badgeColor == badgeColor &&
        other.badgeForeground == badgeForeground &&
        other.badgeAlignment == badgeAlignment &&
        other.badgeGap == badgeGap;
  }

  @override
  int get hashCode => Object.hash(
    themeDensity,
    themeSpacing,
    themeShadows,
    size,
    borderRadius,
    backgroundColor,
    foregroundColor,
    textStyle,
    badgeSize,
    badgeBorderRadius,
    badgeColor,
    badgeForeground,
    badgeAlignment,
    badgeGap,
  );
}

/// Token-derived baseline; every unset override field falls through here.
///
/// `size`, `borderRadius`, `badgeSize` and `badgeBorderRadius` stay null on
/// purpose: their defaults depend on the ambient scaling factor and resolve
/// at build (same pattern as `dialogDefaults`).
const AvatarTheme avatarDefaults = AvatarTheme(
  backgroundColor: ThemedColor.ref(ColorRef.muted),
  foregroundColor: ThemedColor.ref(ColorRef.foreground),
  textStyle: TextStyle(fontWeight: FontWeight.w600),
  badgeColor: ThemedColor.ref(ColorRef.primary),
  badgeForeground: ThemedColor.ref(ColorRef.primaryForeground),
  badgeAlignment: AlignmentDirectional.bottomEnd,
);
