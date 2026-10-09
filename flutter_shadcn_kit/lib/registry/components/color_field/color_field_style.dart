// Registry-owned theme data for the `color_field` component: the
// [ColorFieldTheme] container and its token-derived `colorFieldDefaults`.
//
// The gradient engine itself lives in `primitives/color_field_paint.dart`
// (owned there since P4-B04); this theme only styles the field surface around
// it. User-owned overrides live in `color_field_theme.dart`.

import 'dart:ui' show lerpDouble;

import 'package:flutter/widgets.dart';

import '../../theme/color_tokens.dart';
import '../../theme/theme.dart';

/// Surface styling for a [ColorField]-style gradient area.
///
/// Every field is nullable: an override leg sets only what it changes and
/// [merge] keeps the lower leg's remaining fields.
class ColorFieldTheme extends ComponentThemeData
    implements Mergeable<ColorFieldTheme> {
  /// Creates a colour-field theme.
  const ColorFieldTheme({
    super.themeDensity,
    super.themeSpacing,
    super.themeShadows,
    this.borderColor,
    this.borderWidth,
    this.borderRadius,
    this.checkerboard,
  });

  /// Border colour. Default: the `border` token.
  final ThemedColor? borderColor;

  /// Border width. Default: 1. `0` hides the border.
  final double? borderWidth;

  /// Corner radius; null resolves the ambient `radiusMd`.
  final BorderRadiusGeometry? borderRadius;

  /// Whether a checkerboard is painted behind translucent colours (alpha ramp
  /// or a colour with alpha < 1). Default: true.
  final bool? checkerboard;

  /// Returns a copy with the given fields replaced.
  ColorFieldTheme copyWith({
    ValueGetter<ThemedColor?>? borderColor,
    ValueGetter<double?>? borderWidth,
    ValueGetter<BorderRadiusGeometry?>? borderRadius,
    ValueGetter<bool?>? checkerboard,
  }) {
    return ColorFieldTheme(
      themeDensity: themeDensity,
      themeSpacing: themeSpacing,
      themeShadows: themeShadows,
      borderColor: borderColor == null ? this.borderColor : borderColor(),
      borderWidth: borderWidth == null ? this.borderWidth : borderWidth(),
      borderRadius: borderRadius == null ? this.borderRadius : borderRadius(),
      checkerboard: checkerboard == null ? this.checkerboard : checkerboard(),
    );
  }

  /// First-non-null-wins merge; the receiver (higher-priority leg) wins.
  @override
  ColorFieldTheme merge(ColorFieldTheme? fallback) {
    if (fallback == null) {
      return this;
    }
    return ColorFieldTheme(
      themeDensity: themeDensity ?? fallback.themeDensity,
      themeSpacing: themeSpacing ?? fallback.themeSpacing,
      themeShadows: themeShadows ?? fallback.themeShadows,
      borderColor: borderColor ?? fallback.borderColor,
      borderWidth: borderWidth ?? fallback.borderWidth,
      borderRadius: borderRadius ?? fallback.borderRadius,
      checkerboard: checkerboard ?? fallback.checkerboard,
    );
  }

  /// Colours and flags step at `t = 0.5`; dimensions are lerped.
  static ColorFieldTheme lerp(ColorFieldTheme a, ColorFieldTheme b, double t) {
    return ColorFieldTheme(
      themeDensity: t < 0.5 ? a.themeDensity : b.themeDensity,
      themeSpacing: t < 0.5 ? a.themeSpacing : b.themeSpacing,
      themeShadows: t < 0.5 ? a.themeShadows : b.themeShadows,
      borderColor: t < 0.5 ? a.borderColor : b.borderColor,
      borderWidth: lerpDouble(a.borderWidth, b.borderWidth, t),
      borderRadius: BorderRadiusGeometry.lerp(
        a.borderRadius,
        b.borderRadius,
        t,
      ),
      checkerboard: t < 0.5 ? a.checkerboard : b.checkerboard,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is ColorFieldTheme &&
        other.themeDensity == themeDensity &&
        other.themeSpacing == themeSpacing &&
        other.themeShadows == themeShadows &&
        other.borderColor == borderColor &&
        other.borderWidth == borderWidth &&
        other.borderRadius == borderRadius &&
        other.checkerboard == checkerboard;
  }

  @override
  int get hashCode => Object.hash(
    themeDensity,
    themeSpacing,
    themeShadows,
    borderColor,
    borderWidth,
    borderRadius,
    checkerboard,
  );
}

/// Token-derived baseline values; unset override fields fall through here.
///
/// shadcn-swapper styling: a 1px `border` ring and `rounded-md` around the
/// gradient area, with the transparency checkerboard enabled.
const ColorFieldTheme colorFieldDefaults = ColorFieldTheme(
  borderColor: ThemedColor.ref(ColorRef.border),
  borderWidth: 1,
  checkerboard: true,
);
