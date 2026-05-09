// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../hsv_color_slider.dart';

/// Defines available slider types for HSV color pickers.
///
/// Each slider type controls different aspects of the HSV color model,
/// allowing fine-tuned control over hue, saturation, value, and alpha channels.
enum HSVColorSliderType {
  /// Hue slider only.
  hue,

  /// Combined hue and saturation slider.
  hueSat,

  /// Combined hue and value slider.
  hueVal,

  /// Combined hue and alpha slider.
  hueAlpha,

  /// Saturation slider only.
  sat,

  /// Combined saturation and value slider.
  satVal,

  /// Combined saturation and alpha slider.
  satAlpha,

  /// Value (brightness) slider only.
  val,

  /// Combined value and alpha slider.
  valAlpha,

  /// Alpha (opacity) slider only.
  alpha,
}
