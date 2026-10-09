// Registry-owned theme data for the `hsl` component: the [HSLSliderTheme]
// container and its token-derived `hslSliderDefaults`.
//
// The gradient itself is data-driven (the current colour), so only the
// cursor ring is themed. User-owned overrides live in `hsl_theme.dart`.

import 'package:flutter/widgets.dart';

import '../../theme/color_tokens.dart';
import '../../theme/theme.dart';

/// Cursor styling of the HSL colour slider.
///
/// Every field is nullable: an override leg sets only what it changes and
/// [merge] keeps the lower leg's remaining fields.
class HSLSliderStyle implements Mergeable<HSLSliderStyle> {
  /// Creates an HSL slider style slice.
  const HSLSliderStyle({this.cursorColor, this.cursorSize, this.cursorWidth});

  /// Ring colour of the drag cursor. Default: white.
  final ThemedColor? cursorColor;

  /// Diameter of the 2D cursor circle / bar thickness. Default: `16`.
  final double? cursorSize;

  /// Width of the cursor ring. Default: `2`.
  final double? cursorWidth;

  /// First-non-null-wins merge; the receiver (higher-priority leg) wins.
  @override
  HSLSliderStyle merge(HSLSliderStyle? fallback) {
    if (fallback == null) {
      return this;
    }
    return HSLSliderStyle(
      cursorColor: cursorColor ?? fallback.cursorColor,
      cursorSize: cursorSize ?? fallback.cursorSize,
      cursorWidth: cursorWidth ?? fallback.cursorWidth,
    );
  }
}

/// Per-component theme data for the `hsl` slider.
class HSLSliderTheme extends ComponentThemeData
    implements Mergeable<HSLSliderTheme> {
  /// Creates the theme data.
  const HSLSliderTheme({
    super.themeDensity,
    super.themeSpacing,
    super.themeShadows,
    this.slider,
  });

  /// Widget-wide slider slice.
  final HSLSliderStyle? slider;

  @override
  HSLSliderTheme merge(HSLSliderTheme? fallback) {
    if (fallback == null) {
      return this;
    }
    return HSLSliderTheme(
      themeDensity: themeDensity ?? fallback.themeDensity,
      themeSpacing: themeSpacing ?? fallback.themeSpacing,
      themeShadows: themeShadows ?? fallback.themeShadows,
      slider: slider?.merge(fallback.slider) ?? fallback.slider,
    );
  }

  /// Colours step at `t = 0.5`; geometry is lerped.
  static HSLSliderTheme lerp(HSLSliderTheme a, HSLSliderTheme b, double t) {
    return HSLSliderTheme(
      themeDensity: t < 0.5 ? a.themeDensity : b.themeDensity,
      themeSpacing: t < 0.5 ? a.themeSpacing : b.themeSpacing,
      themeShadows: t < 0.5 ? a.themeShadows : b.themeShadows,
      slider: t < 0.5 ? a.slider : b.slider,
    );
  }
}

/// Token-derived defaults (the shadcn look).
const HSLSliderTheme hslSliderDefaults = HSLSliderTheme(
  slider: HSLSliderStyle(
    cursorColor: ThemedColor.value(Color(0xFFFFFFFF)),
    cursorSize: 16,
    cursorWidth: 2,
  ),
);
