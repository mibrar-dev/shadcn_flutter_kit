import 'dart:ui';

import 'package:flutter/widgets.dart';

/// Builds a color from alpha + HSL channels.
Color fromAHSL(double alpha, double hue, double saturation, double lightness) {
  return HSLColor.fromAHSL(alpha, hue, saturation, lightness).toColor();
}

/// Hex string for [color] (`#RRGGBB`, or `#AARRGGBB` when [showAlpha]).
String hexFromColor(Color color, [bool showAlpha = false]) {
  return colorToHex(color, showAlpha, true);
}

/// Hex string for [color]. Rounds channels to bytes (same as before).
String colorToHex(
  Color color, [
  bool showAlpha = false,
  bool hashPrefix = true,
]) {
  String byte(double channel) =>
      ((channel * 255).round() & 0xFF).toRadixString(16).padLeft(2, '0');
  final rgb = '${byte(color.r)}${byte(color.g)}${byte(color.b)}';
  final hex = showAlpha ? '${byte(color.a)}$rgb' : rgb;
  return hashPrefix ? '#$hex' : hex;
}

/// Minimal palette. Only what registry components really use survived the
/// prune (see P2B_THEME.md): `white` (destructive text), `black` and
/// `transparent`. All 22 shade ramps and `primaries` were unused by
/// components (only dead imports in fade_scroll/number_ticker) and are cut;
/// charts use token chart1..5, ramps regenerate via [ColorShades.fromAccent].
class Colors {
  /// Pure black.
  static const Color black = Color(0xFF000000);

  /// Pure white.
  static const Color white = Color(0xFFFFFFFF);

  /// Fully transparent.
  static const Color transparent = Color(0x00000000);
}

/// Eleven-step shade ramp (50–950) around an accent color.
class ColorShades implements Color, ColorSwatch {
  static const int _step = 100;

  /// Shade keys, lightest (50) to darkest (950).
  static const List<int> shadeValues = [
    50,
    100,
    200,
    300,
    400,
    500,
    600,
    700,
    800,
    900,
    950,
  ];

  final Map<int, Color> _colors;

  const ColorShades.raw(this._colors);
  ColorShades._direct(this._colors);
  ColorShades._() : _colors = {};

  /// Builds from exactly 11 colors in [shadeValues] order.
  factory ColorShades.sorted(List<Color> colors) {
    assert(
      colors.length == shadeValues.length,
      'ColorShades.sorted: Invalid number of colors',
    );
    final shades = ColorShades._();
    for (int i = 0; i < shadeValues.length; i++) {
      shades._colors[shadeValues[i]] = colors[i];
    }
    return shades;
  }

  /// Generates the ramp by shifting [accent]'s HSL values.
  factory ColorShades.fromAccent(
    Color accent, {
    int base = 500,
    int hueShift = 0,
    int saturationStepDown = 0,
    int saturationStepUp = 0,
    int lightnessStepDown = 8,
    int lightnessStepUp = 9,
  }) {
    assert(
      shadeValues.contains(base),
      'ColorShades.fromAccent: Invalid base value',
    );
    return ColorShades.fromAccentHSL(
      HSLColor.fromColor(accent),
      base: base,
      hueShift: hueShift,
      saturationStepDown: saturationStepDown,
      saturationStepUp: saturationStepUp,
      lightnessStepDown: lightnessStepDown,
      lightnessStepUp: lightnessStepUp,
    );
  }

  /// Generates the ramp from an accent HSL color.
  factory ColorShades.fromAccentHSL(
    HSLColor accent, {
    int base = 500,
    int hueShift = 0,
    int saturationStepDown = 0,
    int saturationStepUp = 0,
    int lightnessStepDown = 8,
    int lightnessStepUp = 9,
  }) {
    assert(
      shadeValues.contains(base),
      'ColorShades.fromAccent: Invalid base value',
    );
    final shades = ColorShades._();
    for (final key in shadeValues) {
      shades._colors[key] = shiftHSL(
        accent,
        key,
        base: base,
        hueShift: hueShift,
        saturationStepUp: saturationStepUp,
        saturationStepDown: saturationStepDown,
        lightnessStepUp: lightnessStepUp,
        lightnessStepDown: lightnessStepDown,
      ).toColor();
    }
    return shades;
  }

  /// Shifts [hsl] toward [targetBase] shade value.
  static HSLColor shiftHSL(
    HSLColor hsl,
    int targetBase, {
    int base = 500,
    int hueShift = 0,
    int saturationStepUp = 0,
    int saturationStepDown = 0,
    int lightnessStepUp = 9,
    int lightnessStepDown = 8,
  }) {
    assert(
      shadeValues.contains(base),
      'ColorShades.fromAccent: Invalid base value',
    );
    final delta = (targetBase - base) / _step;
    final hueDelta = delta * (hueShift / 10);
    final saturationDelta = delta > 0
        ? delta * saturationStepUp
        : delta * saturationStepDown;
    final lightnessDelta = delta > 0
        ? delta * lightnessStepUp
        : delta * lightnessStepDown;
    return HSLColor.fromAHSL(
      hsl.alpha,
      (hsl.hue + hueDelta) % 360,
      (hsl.saturation * 100 - saturationDelta).clamp(0, 100) / 100,
      (hsl.lightness * 100 - lightnessDelta).clamp(0, 100) / 100,
    );
  }

  /// Builds from a map holding every shade in [shadeValues].
  factory ColorShades.fromMap(Map<int, Color> colors) {
    final shades = ColorShades._();
    for (final key in shadeValues) {
      assert(
        colors.containsKey(key),
        'ColorShades.fromMap: Missing value for $key',
      );
      shades._colors[key] = colors[key]!;
    }
    return shades;
  }

  /// Shade value for [key] (one of [shadeValues]).
  Color get(int key) {
    assert(_colors.containsKey(key), 'ColorShades.get: Missing value for $key');
    return _colors[key]!;
  }

  Color get shade50 => _colors[50]!;
  Color get shade100 => _colors[100]!;
  Color get shade200 => _colors[200]!;
  Color get shade300 => _colors[300]!;
  Color get shade400 => _colors[400]!;
  Color get shade500 => _colors[500]!;
  Color get shade600 => _colors[600]!;
  Color get shade700 => _colors[700]!;
  Color get shade800 => _colors[800]!;
  Color get shade900 => _colors[900]!;
  Color get shade950 => _colors[950]!;

  Color get _primary => _colors[500]!;

  @override
  int get alpha => (_primary.a * 255).round() & 0xFF;
  @override
  int get red => (_primary.r * 255).round() & 0xFF;
  @override
  int get green => (_primary.g * 255).round() & 0xFF;
  @override
  int get blue => (_primary.b * 255).round() & 0xFF;
  @override
  double get opacity => _primary.a;
  @override
  double get a => _primary.a;
  @override
  double get r => _primary.r;
  @override
  double get g => _primary.g;
  @override
  double get b => _primary.b;
  @override
  ColorSpace get colorSpace => _primary.colorSpace;
  @override
  double computeLuminance() => _primary.computeLuminance();
  @override
  int toARGB32() => _primary.toARGB32();

  /// Deprecated on [Color]; kept so this subclass stays substitutable.
  @override
  int get value => _primary.toARGB32();
  @override
  Color operator [](dynamic index) {
    final color = _colors[index];
    assert(color != null, 'ColorShades: Missing color for $index');
    return color!;
  }

  @override
  Iterable get keys => _colors.keys;

  Map<int, Color> _mapped(Color Function(Color) map) => {
    for (final key in shadeValues) key: map(_colors[key]!),
  };

  @override
  ColorShades withAlpha(int a) =>
      ColorShades._direct(_mapped((c) => c.withAlpha(a)));
  @override
  ColorShades withRed(int r) {
    final delta = r - red;
    return ColorShades._direct(
      _mapped(
        (c) => c.withRed((((c.r * 255).round() & 0xFF) + delta).clamp(0, 255)),
      ),
    );
  }

  @override
  ColorShades withGreen(int g) {
    final delta = g - green;
    return ColorShades._direct(
      _mapped(
        (c) =>
            c.withGreen((((c.g * 255).round() & 0xFF) + delta).clamp(0, 255)),
      ),
    );
  }

  @override
  ColorShades withBlue(int b) {
    final delta = b - blue;
    return ColorShades._direct(
      _mapped(
        (c) => c.withBlue((((c.b * 255).round() & 0xFF) + delta).clamp(0, 255)),
      ),
    );
  }

  @override
  Color withOpacity(double opacity) => ColorShades._direct(
    _mapped((c) => c.withValues(alpha: (c.a * opacity).clamp(0.0, 1.0))),
  );

  @override
  Color withValues({
    double? alpha,
    double? red,
    double? green,
    double? blue,
    ColorSpace? colorSpace,
  }) => ColorShades._direct(
    _mapped(
      (c) => c.withValues(
        alpha: alpha,
        red: red,
        green: green,
        blue: blue,
        colorSpace: colorSpace,
      ),
    ),
  );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! ColorShades || other._colors.length != _colors.length) {
      return false;
    }
    for (final key in shadeValues) {
      if (other._colors[key] != _colors[key]) return false;
    }
    return true;
  }

  @override
  int get hashCode => _primary.hashCode;
}
