// Colour-space math shared by the colour components (color, color_field,
// color_picker, hsl, hsv, eye_dropper, color_input).
//
// `theme/color_utils.dart` owns hex formatting (`colorToHex` /
// `hexFromColor`) and `foundation/color_extensions.dart` owns the HSL/HSV
// channel conversions, so this file adds only what both left out: hex parsing
// and the contrast pick used to derive `destructiveForeground` when a theme
// omits it.

import 'dart:math' as math;
import 'dart:ui';

/// Parses a hex colour into a [Color].
///
/// Accepts `#RGB`, `#RRGGBB` and the 8-digit `#AARRGGBB` form produced by
/// `colorToHex(…, showAlpha: true)`; the leading `#` and a `0x` prefix are
/// both optional. Returns null for anything else (wrong length, 4-digit
/// shorthand, non-hex characters).
Color? colorFromHex(String text) {
  var hex = text.trim();
  if (hex.startsWith('#')) {
    hex = hex.substring(1);
  } else if (hex.startsWith('0x') || hex.startsWith('0X')) {
    hex = hex.substring(2);
  }
  if (!_hexDigits.hasMatch(hex)) return null;
  final value = int.tryParse(hex, radix: 16);
  if (value == null) return null;
  return switch (hex.length) {
    3 => _fromShortRgb(value),
    6 => Color.fromARGB(
      255,
      (value >> 16) & 0xFF,
      (value >> 8) & 0xFF,
      value & 0xFF,
    ),
    8 => Color.fromARGB(
      (value >> 24) & 0xFF,
      (value >> 16) & 0xFF,
      (value >> 8) & 0xFF,
      value & 0xFF,
    ),
    _ => null,
  };
}

/// Matches a non-empty run of hex digits; `int.tryParse` alone would also
/// accept a leading sign on radix 16.
final RegExp _hexDigits = RegExp(r'^[0-9a-fA-F]+$');

/// Expands a 3-digit `#RGB` value by repeating each nibble.
Color _fromShortRgb(int value) {
  final r = (value >> 8) & 0xF;
  final g = (value >> 4) & 0xF;
  final b = value & 0xF;
  return Color.fromARGB(255, r * 17, g * 17, b * 17);
}

/// WCAG 2.1 contrast ratio between [a] and [b]: 1.0 for equal colours, 21.0
/// for black against white. Alpha is ignored; both colours count as opaque.
double contrastRatio(Color a, Color b) {
  final la = a.computeLuminance();
  final lb = b.computeLuminance();
  final lighter = math.max(la, lb);
  final darker = math.min(la, lb);
  return (lighter + 0.05) / (darker + 0.05);
}

/// Picks whichever of [light] and [dark] contrasts more with [background].
///
/// This is the rule used to derive `destructiveForeground` when a theme does
/// not define it: a dark `destructive` gets [light], a light one gets [dark].
/// Ties prefer [light].
Color pickContrastingColor(
  Color background, {
  Color light = const Color(0xFFFFFFFF),
  Color dark = const Color(0xFF000000),
}) {
  return contrastRatio(background, light) >= contrastRatio(background, dark)
      ? light
      : dark;
}

/// Whether [color] is light enough that dark content is the readable choice
/// by default (relative luminance at or above [threshold]).
bool isLightColor(Color color, {double threshold = 0.5}) {
  return color.computeLuminance() >= threshold;
}
