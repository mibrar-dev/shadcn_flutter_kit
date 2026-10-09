// Registry-owned theme data for the `tooltip` component: the [TooltipTheme]
// container and the token-derived `tooltipDefaults`.
//
// User-owned overrides live in `tooltip_theme.dart`; CLI updates may replace
// this file.
//
// Fixes against the old theme:
//   * `backgroundColor` was a raw `Color?`, so an override could not follow a
//     preset switch; it is a [ThemedColor] now and the default is the `primary`
//     token (shadcn's tooltip uses `bg-primary text-primary-foreground`).
//   * `surfaceOpacity` and `surfaceBlur` were only reachable through the
//     `TooltipContainer` fields, never through the app/scoped legs, and
//     `copyWith` dropped the `ComponentThemeData` slots.
//   * The old `TooltipTheme` had no `Mergeable`, so a per-field override leg
//     replaced the whole slice instead of merging.

import 'package:flutter/widgets.dart';

import '../../theme/color_tokens.dart';
import '../../theme/theme.dart';

/// Visual contract of the tooltip surface.
class TooltipTheme extends ComponentThemeData
    implements Mergeable<TooltipTheme> {
  /// Creates a tooltip theme.
  const TooltipTheme({
    super.themeDensity,
    super.themeSpacing,
    super.themeShadows,
    this.background,
    this.foreground,
    this.borderRadius,
    this.padding,
    this.textStyle,
    this.surfaceBlur,
  });

  /// Surface fill; null resolves the `primary` token.
  final ThemedColor? background;

  /// Label colour; null resolves the `primaryForeground` token.
  final ThemedColor? foreground;

  /// Corner radius; null resolves `borderRadiusSm`.
  final BorderRadiusGeometry? borderRadius;

  /// Inner padding; null resolves the density base gap at 0.75x.
  final EdgeInsetsGeometry? padding;

  /// Label style; its color is ignored (taken from [foreground]).
  final TextStyle? textStyle;

  /// Backdrop blur radius; null resolves the app theme's `surfaceBlur`.
  final double? surfaceBlur;

  /// Returns a copy with the given fields replaced.
  TooltipTheme copyWith({
    ValueGetter<ThemedColor?>? background,
    ValueGetter<ThemedColor?>? foreground,
    ValueGetter<BorderRadiusGeometry?>? borderRadius,
    ValueGetter<EdgeInsetsGeometry?>? padding,
    ValueGetter<TextStyle?>? textStyle,
    ValueGetter<double?>? surfaceBlur,
  }) {
    return TooltipTheme(
      themeDensity: themeDensity,
      themeSpacing: themeSpacing,
      themeShadows: themeShadows,
      background: background == null ? this.background : background(),
      foreground: foreground == null ? this.foreground : foreground(),
      borderRadius: borderRadius == null ? this.borderRadius : borderRadius(),
      padding: padding == null ? this.padding : padding(),
      textStyle: textStyle == null ? this.textStyle : textStyle(),
      surfaceBlur: surfaceBlur == null ? this.surfaceBlur : surfaceBlur(),
    );
  }

  /// First-non-null-wins merge; the receiver (higher-priority leg) wins.
  @override
  TooltipTheme merge(TooltipTheme? fallback) {
    if (fallback == null) {
      return this;
    }
    return TooltipTheme(
      themeDensity: themeDensity ?? fallback.themeDensity,
      themeSpacing: themeSpacing ?? fallback.themeSpacing,
      themeShadows: themeShadows ?? fallback.themeShadows,
      background: background ?? fallback.background,
      foreground: foreground ?? fallback.foreground,
      borderRadius: borderRadius ?? fallback.borderRadius,
      padding: padding ?? fallback.padding,
      // TextStyle.merge lets the argument win; merge fallback under this style
      // so the receiver's fields stay.
      textStyle: textStyle == null
          ? fallback.textStyle
          : (fallback.textStyle?.merge(textStyle) ?? textStyle),
      surfaceBlur: surfaceBlur ?? fallback.surfaceBlur,
    );
  }

  /// State scales step at t < 0.5; dimensions lerp.
  static TooltipTheme lerp(TooltipTheme a, TooltipTheme b, double t) {
    return TooltipTheme(
      themeDensity: t < 0.5 ? a.themeDensity : b.themeDensity,
      themeSpacing: t < 0.5 ? a.themeSpacing : b.themeSpacing,
      themeShadows: t < 0.5 ? a.themeShadows : b.themeShadows,
      background: t < 0.5 ? a.background : b.background,
      foreground: t < 0.5 ? a.foreground : b.foreground,
      borderRadius: BorderRadiusGeometry.lerp(
        a.borderRadius,
        b.borderRadius,
        t,
      ),
      padding: EdgeInsetsGeometry.lerp(a.padding, b.padding, t),
      textStyle: TextStyle.lerp(a.textStyle, b.textStyle, t),
      surfaceBlur: t < 0.5 ? a.surfaceBlur : b.surfaceBlur,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is TooltipTheme &&
        other.themeDensity == themeDensity &&
        other.themeSpacing == themeSpacing &&
        other.themeShadows == themeShadows &&
        other.background == background &&
        other.foreground == foreground &&
        other.borderRadius == borderRadius &&
        other.padding == padding &&
        other.textStyle == textStyle &&
        other.surfaceBlur == surfaceBlur;
  }

  @override
  int get hashCode => Object.hash(
    themeDensity,
    themeSpacing,
    themeShadows,
    background,
    foreground,
    borderRadius,
    padding,
    textStyle,
    surfaceBlur,
  );
}

/// Default label style: small, medium weight (shadcn `text-xs`).
const TextStyle tooltipDefaultTextStyle = TextStyle(
  fontSize: 12,
  fontWeight: FontWeight.w500,
);

/// Token-derived baseline; every unset override field falls through here.
const TooltipTheme tooltipDefaults = TooltipTheme(
  background: ThemedColor.ref(ColorRef.primary),
  foreground: ThemedColor.ref(ColorRef.primaryForeground),
  textStyle: tooltipDefaultTextStyle,
);
