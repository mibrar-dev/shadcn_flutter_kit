// Registry-owned theme data for the `outlined_container` component: the flat
// [OutlinedContainerTheme] container and its `outlinedContainerDefaults`.
//
// This is the component copy of the two old `OutlinedContainerTheme` classes
// (the `shared/primitives` fork was deleted); it was already a superset and
// now resolves through the four-leg resolver. User-owned overrides live in
// `outlined_container_theme.dart`.

import 'dart:ui' show lerpDouble;

import 'package:flutter/widgets.dart';

import '../../theme/color_tokens.dart';
import '../../theme/theme.dart';

/// Theme container for the outlined container component.
///
/// Every field is nullable: an override leg sets only what it changes and
/// [merge] keeps the lower leg's remaining fields.
class OutlinedContainerTheme extends ComponentThemeData
    implements Mergeable<OutlinedContainerTheme> {
  /// Creates an outlined container theme.
  const OutlinedContainerTheme({
    super.themeDensity,
    super.themeSpacing,
    super.themeShadows,
    this.backgroundColor,
    this.borderColor,
    this.borderRadius,
    this.borderStyle,
    this.borderWidth,
    this.boxShadow,
    this.padding,
    this.surfaceOpacity,
    this.surfaceBlur,
  });

  /// Surface fill. Default: the `background` token.
  final ThemedColor? backgroundColor;

  /// Border colour. Default: the `muted` token.
  final ThemedColor? borderColor;

  /// Corner radius. Default: the ambient `borderRadiusXl`.
  final BorderRadiusGeometry? borderRadius;

  /// Border style. Default: solid.
  final BorderStyle? borderStyle;

  /// Border width. Default: 1 times the ambient scaling.
  final double? borderWidth;

  /// Elevation shadows. Default: none.
  final List<BoxShadow>? boxShadow;

  /// Inner padding. Default: zero.
  final EdgeInsetsGeometry? padding;

  /// Multiplies the surface fill alpha; null keeps the token alpha.
  final double? surfaceOpacity;

  /// Backdrop blur sigma; null or <= 0 draws no blur layer.
  final double? surfaceBlur;

  /// Returns a copy with the given fields replaced.
  OutlinedContainerTheme copyWith({
    ValueGetter<ThemedColor?>? backgroundColor,
    ValueGetter<ThemedColor?>? borderColor,
    ValueGetter<BorderRadiusGeometry?>? borderRadius,
    ValueGetter<BorderStyle?>? borderStyle,
    ValueGetter<double?>? borderWidth,
    ValueGetter<List<BoxShadow>?>? boxShadow,
    ValueGetter<EdgeInsetsGeometry?>? padding,
    ValueGetter<double?>? surfaceOpacity,
    ValueGetter<double?>? surfaceBlur,
  }) {
    return OutlinedContainerTheme(
      themeDensity: themeDensity,
      themeSpacing: themeSpacing,
      themeShadows: themeShadows,
      backgroundColor: backgroundColor == null
          ? this.backgroundColor
          : backgroundColor(),
      borderColor: borderColor == null ? this.borderColor : borderColor(),
      borderRadius: borderRadius == null ? this.borderRadius : borderRadius(),
      borderStyle: borderStyle == null ? this.borderStyle : borderStyle(),
      borderWidth: borderWidth == null ? this.borderWidth : borderWidth(),
      boxShadow: boxShadow == null ? this.boxShadow : boxShadow(),
      padding: padding == null ? this.padding : padding(),
      surfaceOpacity: surfaceOpacity == null
          ? this.surfaceOpacity
          : surfaceOpacity(),
      surfaceBlur: surfaceBlur == null ? this.surfaceBlur : surfaceBlur(),
    );
  }

  /// First-non-null-wins merge; the receiver (higher-priority leg) wins.
  @override
  OutlinedContainerTheme merge(OutlinedContainerTheme? fallback) {
    if (fallback == null) {
      return this;
    }
    return OutlinedContainerTheme(
      themeDensity: themeDensity ?? fallback.themeDensity,
      themeSpacing: themeSpacing ?? fallback.themeSpacing,
      themeShadows: themeShadows ?? fallback.themeShadows,
      backgroundColor: backgroundColor ?? fallback.backgroundColor,
      borderColor: borderColor ?? fallback.borderColor,
      borderRadius: borderRadius ?? fallback.borderRadius,
      borderStyle: borderStyle ?? fallback.borderStyle,
      borderWidth: borderWidth ?? fallback.borderWidth,
      boxShadow: boxShadow ?? fallback.boxShadow,
      padding: padding ?? fallback.padding,
      surfaceOpacity: surfaceOpacity ?? fallback.surfaceOpacity,
      surfaceBlur: surfaceBlur ?? fallback.surfaceBlur,
    );
  }

  /// Colours and enums step at `t = 0.5`; geometry is lerped.
  static OutlinedContainerTheme lerp(
    OutlinedContainerTheme a,
    OutlinedContainerTheme b,
    double t,
  ) {
    return OutlinedContainerTheme(
      themeDensity: t < 0.5 ? a.themeDensity : b.themeDensity,
      themeSpacing: t < 0.5 ? a.themeSpacing : b.themeSpacing,
      themeShadows: t < 0.5 ? a.themeShadows : b.themeShadows,
      backgroundColor: t < 0.5 ? a.backgroundColor : b.backgroundColor,
      borderColor: t < 0.5 ? a.borderColor : b.borderColor,
      borderRadius: BorderRadiusGeometry.lerp(
        a.borderRadius,
        b.borderRadius,
        t,
      ),
      borderStyle: t < 0.5 ? a.borderStyle : b.borderStyle,
      borderWidth: lerpDouble(a.borderWidth, b.borderWidth, t),
      boxShadow: BoxShadow.lerpList(a.boxShadow, b.boxShadow, t),
      padding: EdgeInsetsGeometry.lerp(a.padding, b.padding, t),
      surfaceOpacity: lerpDouble(a.surfaceOpacity, b.surfaceOpacity, t),
      surfaceBlur: lerpDouble(a.surfaceBlur, b.surfaceBlur, t),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is OutlinedContainerTheme &&
        other.themeDensity == themeDensity &&
        other.themeSpacing == themeSpacing &&
        other.themeShadows == themeShadows &&
        other.backgroundColor == backgroundColor &&
        other.borderColor == borderColor &&
        other.borderRadius == borderRadius &&
        other.borderStyle == borderStyle &&
        other.borderWidth == borderWidth &&
        other.boxShadow == boxShadow &&
        other.padding == padding &&
        other.surfaceOpacity == surfaceOpacity &&
        other.surfaceBlur == surfaceBlur;
  }

  @override
  int get hashCode => Object.hash(
    themeDensity,
    themeSpacing,
    themeShadows,
    backgroundColor,
    borderColor,
    borderRadius,
    borderStyle,
    borderWidth,
    boxShadow,
    padding,
    surfaceOpacity,
    surfaceBlur,
  );
}

/// Token-derived baseline values; unset override fields fall through here.
const OutlinedContainerTheme outlinedContainerDefaults = OutlinedContainerTheme(
  backgroundColor: ThemedColor.ref(ColorRef.background),
  borderColor: ThemedColor.ref(ColorRef.muted),
  borderStyle: BorderStyle.solid,
  boxShadow: <BoxShadow>[],
  padding: EdgeInsets.zero,
);
