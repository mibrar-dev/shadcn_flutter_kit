// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../hsv_color_slider.dart';

/// Axis mapping for HSV slider types.
///
/// For the two-channel types the first channel in the name runs down the
/// field and the second runs across it;
/// [HSVColorSliderPainter.reverse] swaps them. Single-channel types run
/// down the field unless reversed. Channels that do not appear in the type
/// are held constant.
class _HSVAxes {
  /// Axis the hue component varies along.
  final ColorFieldAxis hue;

  /// Axis the saturation component varies along.
  final ColorFieldAxis saturation;

  /// Axis the value component varies along.
  final ColorFieldAxis value;

  /// Axis the alpha component varies along.
  final ColorFieldAxis alpha;

  /// Creates an axis mapping.
  const _HSVAxes({
    this.hue = ColorFieldAxis.none,
    this.saturation = ColorFieldAxis.none,
    this.value = ColorFieldAxis.none,
    this.alpha = ColorFieldAxis.none,
  });

  /// Resolves the axes for [type], swapping first/second when [reverse].
  factory _HSVAxes.of(HSVColorSliderType type, bool reverse) {
    final first = reverse ? ColorFieldAxis.horizontal : ColorFieldAxis.vertical;
    final second = reverse
        ? ColorFieldAxis.vertical
        : ColorFieldAxis.horizontal;
    switch (type) {
      case HSVColorSliderType.hueSat:
        return _HSVAxes(hue: first, saturation: second);
      case HSVColorSliderType.hueVal:
        return _HSVAxes(hue: first, value: second);
      case HSVColorSliderType.hueAlpha:
        return _HSVAxes(hue: first, alpha: second);
      case HSVColorSliderType.satVal:
        return _HSVAxes(saturation: first, value: second);
      case HSVColorSliderType.satAlpha:
        return _HSVAxes(saturation: first, alpha: second);
      case HSVColorSliderType.valAlpha:
        return _HSVAxes(value: first, alpha: second);
      case HSVColorSliderType.hue:
        return _HSVAxes(hue: first);
      case HSVColorSliderType.sat:
        return _HSVAxes(saturation: first);
      case HSVColorSliderType.val:
        return _HSVAxes(value: first);
      case HSVColorSliderType.alpha:
        return _HSVAxes(alpha: first);
    }
  }
}

/// A custom painter for rendering HSV color slider gradients.
///
/// Delegates to the shared upstream-parity gradient engine
/// ([paintHSVColorField] in `form/color_field`) instead of per-cell
/// software loops, matching upstream rendering and performance.
///
/// [HSVColorSliderPainter] draws the gradient background for HSV color sliders,
/// showing the range of possible colors for the selected slider type. The
/// gradient updates based on the current color and slider configuration.
class HSVColorSliderPainter extends CustomPainter {
  /// The type of slider being painted.
  final HSVColorSliderType sliderType;

  /// The current HSV color.
  final HSVColor color;

  /// Whether the gradient direction is reversed.
  final bool reverse;

  /// Creates an [HSVColorSliderPainter].
  HSVColorSliderPainter({
    required this.sliderType,
    required this.color,
    this.reverse = false,
  });

  /// Performs `paint` logic for this form component.
  @override
  void paint(Canvas canvas, Size size) {
    final axes = _HSVAxes.of(sliderType, reverse);
    paintHSVColorField(
      canvas,
      size,
      // Sliders that do not carry the alpha channel show the color at full
      // opacity, so the transparency of [color] does not wash them out.
      color: axes.alpha == ColorFieldAxis.none
          ? HSVColor.fromAHSV(1, color.hue, color.saturation, color.value)
          : color,
      hueAxis: axes.hue,
      saturationAxis: axes.saturation,
      valueAxis: axes.value,
      alphaAxis: axes.alpha,
    );
  }

  /// Performs `shouldRepaint` logic for this form component.
  @override
  bool shouldRepaint(covariant HSVColorSliderPainter oldDelegate) {
    if (oldDelegate.reverse != reverse ||
        oldDelegate.sliderType != sliderType) {
      return true;
    }
    if (sliderType == HSVColorSliderType.hueSat) {
      return oldDelegate.color.value != color.value;
    } else if (sliderType == HSVColorSliderType.hueVal) {
      return oldDelegate.color.saturation != color.saturation;
    } else if (sliderType == HSVColorSliderType.satVal) {
      return oldDelegate.color.hue != color.hue;
    } else if (sliderType == HSVColorSliderType.alpha) {
      return oldDelegate.color.value != color.value ||
          oldDelegate.color.saturation != color.saturation ||
          oldDelegate.color.hue != color.hue;
    } else if (sliderType == HSVColorSliderType.hue) {
      return oldDelegate.color.saturation != color.saturation ||
          oldDelegate.color.value != color.value;
    } else if (sliderType == HSVColorSliderType.sat) {
      return oldDelegate.color.hue != color.hue ||
          oldDelegate.color.value != color.value;
    } else if (sliderType == HSVColorSliderType.val) {
      return oldDelegate.color.hue != color.hue ||
          oldDelegate.color.saturation != color.saturation;
    } else if (sliderType == HSVColorSliderType.hueAlpha) {
      return oldDelegate.color.value != color.value;
    } else if (sliderType == HSVColorSliderType.satAlpha) {
      return oldDelegate.color.hue != color.hue;
    } else if (sliderType == HSVColorSliderType.valAlpha) {
      return oldDelegate.color.hue != color.hue;
    }
    return false;
  }
}
