// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../hsl_color_slider.dart';

/// Defines available slider types for HSL color pickers.
///
/// Each slider type controls different aspects of the HSL color model,
/// allowing fine-tuned control over hue, saturation, luminance, and alpha channels.
enum HSLColorSliderType {
  /// Hue slider only.
  hue,

  /// Combined hue and saturation slider.
  hueSat,

  /// Combined hue and luminance slider.
  hueLum,

  /// Combined hue and alpha slider.
  hueAlpha,

  /// Saturation slider only.
  sat,

  /// Combined saturation and luminance slider.
  satLum,

  /// Combined saturation and alpha slider.
  satAlpha,

  /// Luminance (lightness) slider only.
  lum,

  /// Combined luminance and alpha slider.
  lumAlpha,

  /// Alpha (opacity) slider only.
  alpha,
}
