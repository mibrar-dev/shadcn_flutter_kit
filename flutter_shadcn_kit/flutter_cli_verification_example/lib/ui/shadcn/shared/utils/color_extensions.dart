import 'dart:math';
import 'dart:ui';

import 'package:flutter/rendering.dart';

String colorToHex(Color color,
    [bool showAlpha = false, bool hashPrefix = true]) {
  String r = ((color.r * 255).round() & 0xFF).toRadixString(16).padLeft(2, '0');
  String g = ((color.g * 255).round() & 0xFF).toRadixString(16).padLeft(2, '0');
  String b = ((color.b * 255).round() & 0xFF).toRadixString(16).padLeft(2, '0');
  if (showAlpha) {
    String a =
        ((color.a * 255).round() & 0xFF).toRadixString(16).padLeft(2, '0');
    return hashPrefix ? '#$a$r$g$b' : '$a$r$g$b';
  } else {
    return hashPrefix ? '#$r$g$b' : '$r$g$b';
  }
}

/// Extension adding color manipulation utilities to [Color].
extension ColorExtension on Color {
  /// Scales the alpha channel by a factor.
  Color scaleAlpha(double factor) {
    return withValues(
      alpha: a * factor,
    );
  }

  /// Gets a contrasting color based on luminance.
  Color getContrastColor([double luminanceContrast = 1]) {
/// Creates a `assert` instance.
    assert(luminanceContrast >= 0 && luminanceContrast <= 1,
        'luminanceContrast should be between 0 and 1');
    final hsl = HSLColor.fromColor(this);
/// Stores `currentLuminance` state/configuration for this implementation.
    double currentLuminance = hsl.lightness;
/// Stores `targetLuminance` state/configuration for this implementation.
    double targetLuminance;
    if (currentLuminance >= 0.5) {
      targetLuminance =
          currentLuminance - (currentLuminance * luminanceContrast);
    } else {
      targetLuminance =
          currentLuminance + ((1 - currentLuminance) * luminanceContrast);
    }
    return hsl.withLightness(targetLuminance).toColor();
  }

  /// Sets the luminance (lightness) of this color.
  Color withLuminance(double luminance) {
    final hsl = HSLColor.fromColor(this);
    return hsl.withLightness(luminance).toColor();
  }

  /// Converts this color to hexadecimal string.
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

  /// Converts this color to HSL color space.
  HSLColor toHSL() {
    return HSLColor.fromColor(this);
  }

  /// Converts this color to HSV color space.
  HSVColor toHSV() {
    return HSVColor.fromColor(this);
  }
}

/// Extension for converting [HSLColor] to other color spaces.
extension HSLColorExtension on HSLColor {
  /// Converts this HSL color to HSV color space.
  HSVColor toHSV() {
/// Stores `l` state/configuration for this implementation.
    final double l = lightness;
/// Stores `s` state/configuration for this implementation.
    final double s = saturation;
/// Stores `h` state/configuration for this implementation.
    final double h = hue;
/// Stores `a` state/configuration for this implementation.
    final double a = alpha;
    final double v = l + s * min(l, 1 - l);
/// Stores `newH` state/configuration for this implementation.
    double newH;
/// Stores `newS` state/configuration for this implementation.
    double newS;
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

/// Extension for converting [HSVColor] to other color spaces.
extension HSVColorExtension on HSVColor {
  /// Converts this HSV color to HSL color space.
  HSLColor toHSL() {
/// Stores `v` state/configuration for this implementation.
    final double v = value;
/// Stores `s` state/configuration for this implementation.
    final double s = saturation;
/// Stores `h` state/configuration for this implementation.
    final double h = hue;
/// Stores `a` state/configuration for this implementation.
    final double a = alpha;
    final double l = v * (1 - s / 2);
/// Stores `newH` state/configuration for this implementation.
    double newH;
/// Stores `newS` state/configuration for this implementation.
    double newS;
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
