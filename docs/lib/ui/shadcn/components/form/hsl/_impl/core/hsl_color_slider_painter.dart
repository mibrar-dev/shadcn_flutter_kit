// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../hsl_color_slider.dart';

/// Axis mapping for HSL slider types.
///
/// For the two-channel types the first channel in the name runs down the
/// field and the second runs across it;
/// [HSLColorSliderPainter.reverse] swaps them. Single-channel types run
/// down the field unless reversed. Channels that do not appear in the type
/// are held constant.
class _HSLAxes {
  /// Axis the hue component varies along.
  final ColorFieldAxis hue;

  /// Axis the saturation component varies along.
  final ColorFieldAxis saturation;

  /// Axis the lightness component varies along.
  final ColorFieldAxis lightness;

  /// Axis the alpha component varies along.
  final ColorFieldAxis alpha;

  /// Creates an axis mapping.
  const _HSLAxes({
    this.hue = ColorFieldAxis.none,
    this.saturation = ColorFieldAxis.none,
    this.lightness = ColorFieldAxis.none,
    this.alpha = ColorFieldAxis.none,
  });

  /// Resolves the axes for [type], swapping first/second when [reverse].
  factory _HSLAxes.of(HSLColorSliderType type, bool reverse) {
    final first = reverse ? ColorFieldAxis.horizontal : ColorFieldAxis.vertical;
    final second = reverse
        ? ColorFieldAxis.vertical
        : ColorFieldAxis.horizontal;
    switch (type) {
      case HSLColorSliderType.hueSat:
        return _HSLAxes(hue: first, saturation: second);
      case HSLColorSliderType.hueLum:
        return _HSLAxes(hue: first, lightness: second);
      case HSLColorSliderType.hueAlpha:
        return _HSLAxes(hue: first, alpha: second);
      case HSLColorSliderType.satLum:
        return _HSLAxes(saturation: first, lightness: second);
      case HSLColorSliderType.satAlpha:
        return _HSLAxes(saturation: first, alpha: second);
      case HSLColorSliderType.lumAlpha:
        return _HSLAxes(lightness: first, alpha: second);
      case HSLColorSliderType.hue:
        return _HSLAxes(hue: first);
      case HSLColorSliderType.sat:
        return _HSLAxes(saturation: first);
      case HSLColorSliderType.lum:
        return _HSLAxes(lightness: first);
      case HSLColorSliderType.alpha:
        return _HSLAxes(alpha: first);
    }
  }
}

/// A custom painter for rendering HSL color slider gradients.
///
/// Delegates to the shared upstream-parity gradient engine
/// ([paintHSLColorField] in `form/color_field`) instead of per-cell
/// software loops, matching upstream rendering and performance.
///
/// [HSLColorSliderPainter] draws the gradient background for HSL color sliders,
/// showing the range of possible colors for the selected slider type. The
/// gradient updates based on the current color and slider configuration.
class HSLColorSliderPainter extends CustomPainter {
  /// The type of slider being painted.
  final HSLColorSliderType sliderType;

  /// The current HSL color.
  final HSLColor color;

  /// Whether the gradient direction is reversed.
  final bool reverse;

  /// Creates an [HSLColorSliderPainter].
  HSLColorSliderPainter({
    required this.sliderType,
    required this.color,
    this.reverse = false,
  });

  /// Performs `paint` logic for this form component.
  @override
  void paint(Canvas canvas, Size size) {
    final axes = _HSLAxes.of(sliderType, reverse);
    paintHSLColorField(
      canvas,
      size,
      // Sliders that do not carry the alpha channel show the color at full
      // opacity, so the transparency of [color] does not wash them out.
      color: axes.alpha == ColorFieldAxis.none
          ? HSLColor.fromAHSL(1, color.hue, color.saturation, color.lightness)
          : color,
      hueAxis: axes.hue,
      saturationAxis: axes.saturation,
      lightnessAxis: axes.lightness,
      alphaAxis: axes.alpha,
    );
  }

  /// Performs `shouldRepaint` logic for this form component.
  @override
  bool shouldRepaint(covariant HSLColorSliderPainter oldDelegate) {
    if (oldDelegate.reverse != reverse ||
        oldDelegate.sliderType != sliderType) {
      return true;
    }
    if (sliderType == HSLColorSliderType.hueSat) {
      return oldDelegate.color.lightness != color.lightness;
    } else if (sliderType == HSLColorSliderType.hueLum) {
      return oldDelegate.color.saturation != color.saturation;
    } else if (sliderType == HSLColorSliderType.satLum) {
      return oldDelegate.color.hue != color.hue;
    } else if (sliderType == HSLColorSliderType.alpha) {
      return oldDelegate.color.lightness != color.lightness ||
          oldDelegate.color.saturation != color.saturation ||
          oldDelegate.color.hue != color.hue;
    } else if (sliderType == HSLColorSliderType.hue) {
      return oldDelegate.color.lightness != color.lightness ||
          oldDelegate.color.saturation != color.saturation;
    } else if (sliderType == HSLColorSliderType.sat) {
      return oldDelegate.color.hue != color.hue ||
          oldDelegate.color.lightness != color.lightness;
    } else if (sliderType == HSLColorSliderType.lum) {
      return oldDelegate.color.hue != color.hue ||
          oldDelegate.color.saturation != color.saturation;
    } else if (sliderType == HSLColorSliderType.hueAlpha) {
      return oldDelegate.color.lightness != color.lightness;
    } else if (sliderType == HSLColorSliderType.satAlpha) {
      return oldDelegate.color.hue != color.hue;
    } else if (sliderType == HSLColorSliderType.lumAlpha) {
      return oldDelegate.color.hue != color.hue;
    }
    return false;
  }
}
