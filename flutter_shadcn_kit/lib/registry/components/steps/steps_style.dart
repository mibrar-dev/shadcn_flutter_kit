// Registry-owned theme data for the `steps` component: the [StepsTheme]
// container and the token-derived `stepsDefaults`.
//
// User-owned overrides live in `steps_theme.dart`; CLI updates may replace
// this file. The widget reads the resolved theme through
// `resolveComponentStyle<StepsTheme, StepsTheme>`.

import 'dart:ui' show lerpDouble;

import 'package:flutter/widgets.dart';

import '../../theme/color_tokens.dart';
import '../../theme/theme.dart';

/// Visual contract of a vertical step list.
///
/// Every field is nullable: an override leg sets only what it changes and
/// [merge] keeps the lower leg's remaining fields.
class StepsTheme extends ComponentThemeData implements Mergeable<StepsTheme> {
  /// Creates a steps theme.
  const StepsTheme({
    super.themeDensity,
    super.themeSpacing,
    super.themeShadows,
    this.indicatorSize,
    this.spacing,
    this.indicatorColor,
    this.indicatorForeground,
    this.connectorColor,
    this.connectorThickness,
  });

  /// Diameter of the numbered circle. Default: `28` (× scaling).
  final double? indicatorSize;

  /// Gap between the indicator column and the step content. Default: `18`
  /// (× scaling).
  final double? spacing;

  /// Fill of the numbered circle. Default: the `muted` token.
  final ThemedColor? indicatorColor;

  /// Colour of the step number. Default: the `foreground` token.
  final ThemedColor? indicatorForeground;

  /// Colour of the connector line. Default: the `muted` token.
  final ThemedColor? connectorColor;

  /// Thickness of the connector line. Default: `1` (× scaling).
  final double? connectorThickness;

  /// Returns a copy with the given fields replaced.
  StepsTheme copyWith({
    ValueGetter<double?>? indicatorSize,
    ValueGetter<double?>? spacing,
    ValueGetter<ThemedColor?>? indicatorColor,
    ValueGetter<ThemedColor?>? indicatorForeground,
    ValueGetter<ThemedColor?>? connectorColor,
    ValueGetter<double?>? connectorThickness,
  }) {
    return StepsTheme(
      themeDensity: themeDensity,
      themeSpacing: themeSpacing,
      themeShadows: themeShadows,
      indicatorSize: indicatorSize == null
          ? this.indicatorSize
          : indicatorSize(),
      spacing: spacing == null ? this.spacing : spacing(),
      indicatorColor: indicatorColor == null
          ? this.indicatorColor
          : indicatorColor(),
      indicatorForeground: indicatorForeground == null
          ? this.indicatorForeground
          : indicatorForeground(),
      connectorColor: connectorColor == null
          ? this.connectorColor
          : connectorColor(),
      connectorThickness: connectorThickness == null
          ? this.connectorThickness
          : connectorThickness(),
    );
  }

  /// First-non-null-wins merge; the receiver (higher-priority leg) wins.
  @override
  StepsTheme merge(StepsTheme? fallback) {
    if (fallback == null) {
      return this;
    }
    return StepsTheme(
      themeDensity: themeDensity ?? fallback.themeDensity,
      themeSpacing: themeSpacing ?? fallback.themeSpacing,
      themeShadows: themeShadows ?? fallback.themeShadows,
      indicatorSize: indicatorSize ?? fallback.indicatorSize,
      spacing: spacing ?? fallback.spacing,
      indicatorColor: indicatorColor ?? fallback.indicatorColor,
      indicatorForeground: indicatorForeground ?? fallback.indicatorForeground,
      connectorColor: connectorColor ?? fallback.connectorColor,
      connectorThickness: connectorThickness ?? fallback.connectorThickness,
    );
  }

  /// Colours and widgets step at `t < 0.5`; dimensions are lerped.
  static StepsTheme lerp(StepsTheme a, StepsTheme b, double t) {
    return StepsTheme(
      themeDensity: t < 0.5 ? a.themeDensity : b.themeDensity,
      themeSpacing: t < 0.5 ? a.themeSpacing : b.themeSpacing,
      themeShadows: t < 0.5 ? a.themeShadows : b.themeShadows,
      indicatorSize: lerpDouble(a.indicatorSize, b.indicatorSize, t),
      spacing: lerpDouble(a.spacing, b.spacing, t),
      indicatorColor: t < 0.5 ? a.indicatorColor : b.indicatorColor,
      indicatorForeground: t < 0.5
          ? a.indicatorForeground
          : b.indicatorForeground,
      connectorColor: t < 0.5 ? a.connectorColor : b.connectorColor,
      connectorThickness: lerpDouble(
        a.connectorThickness,
        b.connectorThickness,
        t,
      ),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is StepsTheme &&
        other.themeDensity == themeDensity &&
        other.themeSpacing == themeSpacing &&
        other.themeShadows == themeShadows &&
        other.indicatorSize == indicatorSize &&
        other.spacing == spacing &&
        other.indicatorColor == indicatorColor &&
        other.indicatorForeground == indicatorForeground &&
        other.connectorColor == connectorColor &&
        other.connectorThickness == connectorThickness;
  }

  @override
  int get hashCode => Object.hash(
    themeDensity,
    themeSpacing,
    themeShadows,
    indicatorSize,
    spacing,
    indicatorColor,
    indicatorForeground,
    connectorColor,
    connectorThickness,
  );
}

/// Token-derived baseline; every unset override field falls through here.
const StepsTheme stepsDefaults = StepsTheme(
  indicatorSize: 28,
  spacing: 18,
  indicatorColor: ThemedColor.ref(ColorRef.muted),
  indicatorForeground: ThemedColor.ref(ColorRef.foreground),
  connectorColor: ThemedColor.ref(ColorRef.muted),
  connectorThickness: 1,
);
