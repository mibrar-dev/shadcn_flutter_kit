// Registry-owned theme data for the `hsv` component: the [HSVSliderTheme]
// container and its token-derived `hsvSliderDefaults`.
//
// The gradient itself is data-driven (the current colour), so only the
// cursor ring is themed. User-owned overrides live in `hsv_theme.dart`.

import 'dart:ui' show lerpDouble;

import 'package:flutter/widgets.dart';

import '../../theme/color_tokens.dart';
import '../../theme/theme.dart';

/// Cursor styling of the HSV colour slider.
///
/// Every field is nullable: an override leg sets only what it changes and
/// [merge] keeps the lower leg's remaining fields.
class HSVSliderStyle implements Mergeable<HSVSliderStyle> {
  /// Creates an HSV slider style slice.
  const HSVSliderStyle({this.cursorColor, this.cursorSize, this.cursorWidth});

  /// Ring colour of the drag cursor. Default: white.
  final ThemedColor? cursorColor;

  /// Diameter of the 2D cursor circle / bar thickness. Default: `16`.
  final double? cursorSize;

  /// Width of the cursor ring. Default: `2`.
  final double? cursorWidth;

  /// First-non-null-wins merge; the receiver (higher-priority leg) wins.
  @override
  HSVSliderStyle merge(HSVSliderStyle? fallback) {
    if (fallback == null) {
      return this;
    }
    return HSVSliderStyle(
      cursorColor: cursorColor ?? fallback.cursorColor,
      cursorSize: cursorSize ?? fallback.cursorSize,
      cursorWidth: cursorWidth ?? fallback.cursorWidth,
    );
  }
}

/// Per-component theme data for the `hsv` slider.
class HSVSliderTheme extends ComponentThemeData
    implements Mergeable<HSVSliderTheme> {
  /// Creates the theme data.
  const HSVSliderTheme({
    super.themeDensity,
    super.themeSpacing,
    super.themeShadows,
    this.slider,
  });

  /// Widget-wide slider slice.
  final HSVSliderStyle? slider;

  @override
  HSVSliderTheme merge(HSVSliderTheme? fallback) {
    if (fallback == null) {
      return this;
    }
    return HSVSliderTheme(
      themeDensity: themeDensity ?? fallback.themeDensity,
      themeSpacing: themeSpacing ?? fallback.themeSpacing,
      themeShadows: themeShadows ?? fallback.themeShadows,
      slider: slider?.merge(fallback.slider) ?? fallback.slider,
    );
  }

  /// Colours step at `t = 0.5`; geometry is lerped.
  static HSVSliderTheme lerp(HSVSliderTheme a, HSVSliderTheme b, double t) {
    return HSVSliderTheme(
      themeDensity: t < 0.5 ? a.themeDensity : b.themeDensity,
      themeSpacing: t < 0.5 ? a.themeSpacing : b.themeSpacing,
      themeShadows: t < 0.5 ? a.themeShadows : b.themeShadows,
      slider: t < 0.5 ? a.slider : b.slider,
    );
  }
}

/// Token-derived defaults (the shadcn look).
const HSVSliderTheme hsvSliderDefaults = HSVSliderTheme(
  slider: HSVSliderStyle(
    cursorColor: ThemedColor.value(const Color(0xFFFFFFFF)),
    cursorSize: 16,
    cursorWidth: 2,
  ),
);
