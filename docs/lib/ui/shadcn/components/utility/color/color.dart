// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';

part '_impl/core/color_derivative.dart';
part '_impl/core/color_gradient.dart';
part '_impl/core/hsl_color_derivative.dart';
part '_impl/core/hsv_color_derivative.dart';
part '_impl/core/linear_color_gradient.dart';
part '_impl/core/radial_color_gradient.dart';
part '_impl/core/sweep_color_gradient.dart';
part '_impl/utils/color_stop.dart';
part '_impl/utils/directional_gradient_angle.dart';
part '_impl/utils/gradient_angle.dart';
part '_impl/utils/gradient_angle_geometry.dart';

/// Converts a [Color] to its hexadecimal string representation.
///
/// This function transforms a Flutter [Color] object into a hex string format
/// commonly used in CSS and design tools. The output can optionally include
/// the alpha (transparency) channel and a hash (#) prefix.
///
/// Parameters:
/// - [color]: The color to convert to hexadecimal format.
/// - [showAlpha]: Whether to include the alpha channel in the output. Defaults to `false`.
///   When `true`, the alpha value is prepended to the RGB values (ARGB format).
/// - [hashPrefix]: Whether to prefix the output with '#'. Defaults to `true`.
///
/// Returns:
/// A hexadecimal string representation of the color. Format varies based on parameters:
/// - With alpha and hash: `#AARRGGBB` (e.g., `#FF0080FF`)
/// - Without alpha, with hash: `#RRGGBB` (e.g., `#0080FF`)
/// - With alpha, no hash: `AARRGGBB`
/// - Without alpha, no hash: `RRGGBB`
///
/// Example:
/// ```dart
/// final color = Color.fromARGB(255, 0, 128, 255);
/// print(colorToHex(color)); // Output: #0080FF
/// print(colorToHex(color, true)); // Output: #FF0080FF
/// print(colorToHex(color, false, false)); // Output: 0080FF
/// ```
String colorToHex(
  Color color, [
  bool showAlpha = false,
  bool hashPrefix = true,
]) {
  String r = ((color.r * 255).round() & 0xFF).toRadixString(16).padLeft(2, '0');
  String g = ((color.g * 255).round() & 0xFF).toRadixString(16).padLeft(2, '0');
  String b = ((color.b * 255).round() & 0xFF).toRadixString(16).padLeft(2, '0');
  if (showAlpha) {
    String a = ((color.a * 255).round() & 0xFF)
        .toRadixString(16)
        .padLeft(2, '0');
    return hashPrefix ? '#$a$r$g$b' : '$a$r$g$b';
  } else {
    return hashPrefix ? '#$r$g$b' : '$r$g$b';
  }
}
