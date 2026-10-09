// Color-space helpers shared across the registry. Needs nothing from
// `theme/`, so it lives in the zero-dependency layer (P2-E1 decision).
//
// The top-level `colorToHex` helper from the old
// `shared/utils/color_extensions.dart` is NOT duplicated here: it already
// lives in `theme/color_utils.dart` (`colorToHex` / `hexFromColor`), the home
// OWNERSHIP.md assigns it to.

import 'dart:math';
import 'dart:ui';

import 'package:flutter/rendering.dart';

/// Color manipulation utilities.
extension ColorExtension on Color {
  /// Multiplies the alpha channel by [factor].
  Color scaleAlpha(double factor) {
    return withValues(alpha: a * factor);
  }

  /// Returns a color whose HSL lightness moves [luminanceContrast] toward the
  /// opposite end of the scale.
  Color getContrastColor([double luminanceContrast = 1]) {
    assert(
      luminanceContrast >= 0 && luminanceContrast <= 1,
      'luminanceContrast should be between 0 and 1',
    );
    final hsl = HSLColor.fromColor(this);
    final currentLuminance = hsl.lightness;
    final double targetLuminance;
    if (currentLuminance >= 0.5) {
      targetLuminance =
          currentLuminance - (currentLuminance * luminanceContrast);
    } else {
      targetLuminance =
          currentLuminance + ((1 - currentLuminance) * luminanceContrast);
    }
    return hsl.withLightness(targetLuminance).toColor();
  }

  /// Sets the HSL lightness of this color.
  Color withLuminance(double luminance) {
    final hsl = HSLColor.fromColor(this);
    return hsl.withLightness(luminance).toColor();
  }

  /// ARGB hex string (`AARRGGBB`), optionally without alpha / hash sign.
  String toHex({bool includeHashSign = false, bool includeAlpha = true}) {
    String hex = toARGB32().toRadixString(16).padLeft(8, '0');
    if (!includeAlpha) {
      hex = hex.substring(2);
    }
    if (includeHashSign) {
      hex = '#$hex';
    }
    return hex;
  }

  /// Converts this color to [HSLColor].
  HSLColor toHSL() => HSLColor.fromColor(this);

  /// Converts this color to [HSVColor].
  HSVColor toHSV() => HSVColor.fromColor(this);
}

/// HSL to HSV conversion.
extension HSLColorExtension on HSLColor {
  /// Converts this HSL color to [HSVColor].
  HSVColor toHSV() {
    final double l = lightness;
    final double s = saturation;
    final double h = hue;
    final double a = alpha;
    final double v = l + s * min(l, 1 - l);
    final double newH;
    final double newS;
    if (v == 0) {
      newH = 0;
      newS = 0;
    } else {
      newS = 2 * (1 - l / v);
      newH = h;
    }
    return HSVColor.fromAHSV(a, newH, newS, v);
  }
}

/// HSV to HSL conversion.
extension HSVColorExtension on HSVColor {
  /// Converts this HSV color to [HSLColor].
  HSLColor toHSL() {
    final double v = value;
    final double s = saturation;
    final double h = hue;
    final double a = alpha;
    final double l = v * (1 - s / 2);
    final double newH;
    final double newS;
    if (l == 0 || l == 1) {
      newH = 0;
      newS = 0;
    } else {
      newS = (v - l) / min(l, 1 - l);
      newH = h;
    }
    return HSLColor.fromAHSL(a, newH, newS, l);
  }
}
