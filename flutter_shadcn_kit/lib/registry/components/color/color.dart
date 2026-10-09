// The `color` component: the colour model shared by every colour control.
//
// Widgets-only. `ColorDerivative` preserves whichever space (HSV or HSL) the
// value was created in across edits; `transform` converts the representation
// without changing the rendered colour. Conversion helpers live in
// `theme/color_utils.dart` (hex formatting) and `primitives/color_math.dart`
// (hex parsing, contrast).
//
// The old tree's gradient model family (`ColorGradient`, `LinearColorGradient`,
// `RadialColorGradient`, `SweepColorGradient`, `ColorStop`, gradient angles)
// had zero consumers outside the `color` folder and is deleted.

import 'package:flutter/widgets.dart';

import '../../primitives/color_math.dart';

/// Equality for derivatives: identical at 8-bit-per-channel resolution.
///
/// Rounding through [Color.toARGB32] keeps [_derivativeEqual]'s promise — two
/// derivatives that differ only by float noise in their RGB round trip get
/// the same equality verdict, also for achromatic hues where hue diverges.
bool _derivativeEqual(HSVColor a, HSVColor b) =>
    a.toColor().toARGB32() == b.toColor().toARGB32();

/// An abstract base class representing a color that can be transformed between
/// different color spaces.
///
/// ```dart
/// final derivative = ColorDerivative.fromColor(const Color(0xFF0080FF));
/// final muted = derivative.changeToHSVSaturation(0.5);
/// return muted.toColor();
/// ```
abstract base class ColorDerivative {
  /// Creates a [ColorDerivative] from a Flutter [Color] using HSV internally.
  static ColorDerivative fromColor(Color color) {
    return _HSVColor(HSVColor.fromColor(color));
  }

  /// Creates a [ColorDerivative] from an [HSVColor].
  const factory ColorDerivative.fromHSV(HSVColor color) = _HSVColor;

  /// Creates a [ColorDerivative] from an [HSLColor].
  const factory ColorDerivative.fromHSL(HSLColor color) = _HSLColor;

  /// Parses a hex string (`#RGB`, `#RRGGBB`, `#AARRGGBB`) into a
  /// [ColorDerivative], or null when [text] is not a valid hex colour.
  static ColorDerivative? fromHex(String text) {
    final color = colorFromHex(text);
    return color == null ? null : ColorDerivative.fromColor(color);
  }

  /// Creates a const [ColorDerivative].
  const ColorDerivative();

  /// Converts this color derivative to a Flutter [Color].
  Color toColor();

  /// Converts this color derivative to an [HSVColor].
  HSVColor toHSVColor();

  /// Converts this color derivative to an [HSLColor].
  HSLColor toHSLColor();

  /// The opacity (alpha) value, 0.0–1.0.
  double get opacity;

  /// Hue in HSL space, 0.0–360.0.
  double get hslHue;

  /// Saturation in HSL space, 0.0–1.0.
  double get hslSat;

  /// Lightness in HSL space, 0.0–1.0.
  double get hslVal;

  /// Hue in HSV space, 0.0–360.0.
  double get hsvHue;

  /// Saturation in HSV space, 0.0–1.0.
  double get hsvSat;

  /// Value (brightness) in HSV space, 0.0–1.0.
  double get hsvVal;

  /// Red channel, 0–255.
  int get red;

  /// Green channel, 0–255.
  int get green;

  /// Blue channel, 0–255.
  int get blue;

  /// Re-expresses this colour using [other]'s internal colour space.
  ColorDerivative transform(ColorDerivative old);

  /// Returns a copy with the opacity replaced by [alpha].
  ColorDerivative changeToOpacity(double alpha);

  /// Returns a copy of [color] expressed in this colour's space.
  ColorDerivative changeToColor(Color color) {
    return ColorDerivative.fromColor(color).transform(this);
  }

  /// Returns a copy of [color] expressed in this colour's space.
  ColorDerivative changeToHSV(HSVColor color) {
    return ColorDerivative.fromHSV(color).transform(this);
  }

  /// Returns a copy of [color] expressed in this colour's space.
  ColorDerivative changeToHSL(HSLColor color) {
    return ColorDerivative.fromHSL(color).transform(this);
  }

  /// Replaces the red channel (0–255).
  ColorDerivative changeToColorRed(double red) {
    return changeToColor(toColor().withRed(red.round().clamp(0, 255)));
  }

  /// Replaces the green channel (0–255).
  ColorDerivative changeToColorGreen(double green) {
    return changeToColor(toColor().withGreen(green.round().clamp(0, 255)));
  }

  /// Replaces the blue channel (0–255).
  ColorDerivative changeToColorBlue(double blue) {
    return changeToColor(toColor().withBlue(blue.round().clamp(0, 255)));
  }

  /// Replaces the HSV hue (0–360).
  ColorDerivative changeToHSVHue(double hue) {
    return changeToHSV(toHSVColor().withHue(hue));
  }

  /// Replaces the HSV saturation (0–1).
  ColorDerivative changeToHSVSaturation(double saturation) {
    return changeToHSV(toHSVColor().withSaturation(saturation));
  }

  /// Replaces the HSV value (0–1).
  ColorDerivative changeToHSVValue(double value) {
    return changeToHSV(toHSVColor().withValue(value));
  }

  /// Replaces the alpha channel (0–1) in HSV space.
  ColorDerivative changeToHSVAlpha(double alpha) {
    return changeToHSV(toHSVColor().withAlpha(alpha));
  }

  /// Replaces the HSL hue (0–360).
  ColorDerivative changeToHSLHue(double hue) {
    return changeToHSL(toHSLColor().withHue(hue));
  }

  /// Replaces the HSL saturation (0–1).
  ColorDerivative changeToHSLSaturation(double saturation) {
    return changeToHSL(toHSLColor().withSaturation(saturation));
  }

  /// Replaces the HSL lightness (0–1).
  ColorDerivative changeToHSLLightness(double lightness) {
    return changeToHSL(toHSLColor().withLightness(lightness));
  }
}

final class _HSVColor extends ColorDerivative {
  final HSVColor color;
  const _HSVColor(this.color);

  @override
  String toString() => color.toString();

  @override
  Color toColor() => color.toColor();

  @override
  HSVColor toHSVColor() => color;

  @override
  HSLColor toHSLColor() => HSLColor.fromColor(color.toColor());

  @override
  double get opacity => color.alpha;

  @override
  ColorDerivative changeToOpacity(double alpha) =>
      _HSVColor(color.withAlpha(alpha));

  @override
  ColorDerivative changeToHSVHue(double hue) => _HSVColor(color.withHue(hue));

  @override
  ColorDerivative changeToHSVSaturation(double saturation) =>
      _HSVColor(color.withSaturation(saturation));

  @override
  ColorDerivative changeToHSVValue(double value) =>
      _HSVColor(color.withValue(value));

  @override
  ColorDerivative transform(ColorDerivative old) {
    if (old is _HSVColor) {
      return _HSVColor(color);
    }
    if (old is _HSLColor) {
      return _HSLColor(HSLColor.fromColor(color.toColor()));
    }
    throw StateError('Unknown ColorDerivative implementation');
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is ColorDerivative) {
      // Compare through HSV: [HSLColor] and [HSVColor] equality is not
      // comparable across types (old code compared them directly and an
      // `_HSLColor` never equalled its `_HSVColor` twin). A small epsilon
      // absorbs the float noise of the RGB round trip.
      return _derivativeEqual(toHSVColor(), other.toHSVColor());
    }
    return false;
  }

  @override
  int get hashCode => toColor().toARGB32();

  @override
  double get hslHue => HSLColor.fromColor(color.toColor()).hue;

  @override
  double get hslSat => HSLColor.fromColor(color.toColor()).saturation;

  @override
  double get hslVal => HSLColor.fromColor(color.toColor()).lightness;

  @override
  double get hsvHue => color.hue;

  @override
  double get hsvSat => color.saturation;

  @override
  double get hsvVal => color.value;

  @override
  int get red => (color.toColor().r * 255).round().clamp(0, 255);

  @override
  int get green => (color.toColor().g * 255).round().clamp(0, 255);

  @override
  int get blue => (color.toColor().b * 255).round().clamp(0, 255);
}

final class _HSLColor extends ColorDerivative {
  final HSLColor color;
  const _HSLColor(this.color);

  @override
  String toString() => color.toString();

  @override
  Color toColor() => color.toColor();

  @override
  HSVColor toHSVColor() => HSVColor.fromColor(color.toColor());

  @override
  HSLColor toHSLColor() => color;

  @override
  double get opacity => color.alpha;

  @override
  ColorDerivative changeToOpacity(double alpha) =>
      _HSLColor(color.withAlpha(alpha));

  @override
  ColorDerivative transform(ColorDerivative old) {
    if (old is _HSLColor) {
      return _HSLColor(color);
    }
    if (old is _HSVColor) {
      return _HSVColor(HSVColor.fromColor(color.toColor()));
    }
    throw StateError('Unknown ColorDerivative implementation');
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is ColorDerivative) {
      return _derivativeEqual(toHSVColor(), other.toHSVColor());
    }
    return false;
  }

  @override
  int get hashCode => toColor().toARGB32();

  @override
  double get hslHue => color.hue;

  @override
  double get hslSat => color.saturation;

  @override
  double get hslVal => color.lightness;

  @override
  double get hsvHue => HSVColor.fromColor(color.toColor()).hue;

  @override
  double get hsvSat => HSVColor.fromColor(color.toColor()).saturation;

  @override
  double get hsvVal => HSVColor.fromColor(color.toColor()).value;

  @override
  int get red => (color.toColor().r * 255).round().clamp(0, 255);

  @override
  int get green => (color.toColor().g * 255).round().clamp(0, 255);

  @override
  int get blue => (color.toColor().b * 255).round().clamp(0, 255);
}
