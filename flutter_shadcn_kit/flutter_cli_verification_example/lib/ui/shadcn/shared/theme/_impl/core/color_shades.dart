part of '../../color_scheme.dart';

/// ColorShades defines a reusable type for this registry module.
class ColorShades implements Color, ColorSwatch {
/// Stores `_step` state/configuration for this implementation.
  static const int _step = 100;

  /// Standard shade values used in color palettes.
  ///
  /// Contains the standard Material Design shade values from lightest (50)
  /// to darkest (950): [50, 100, 200, 300, 400, 500, 600, 700, 800, 900, 950].
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
    950
  ];
/// Stores `_colors` state/configuration for this implementation.
  final Map<int, Color> _colors;

  ColorShades._() : _colors = {};

  /// Creates color shades from a raw map.
  @protected
  const ColorShades.raw(this._colors);

  /// Creates color shades from a sorted list of colors.
  ///
  /// The list must contain exactly 11 colors corresponding to shades
  /// 50, 100, 200, 300, 400, 500, 600, 700, 800, 900, and 950.
  factory ColorShades.sorted(List<Color> colors) {
/// Creates a `assert` instance.
    assert(colors.length == shadeValues.length,
        'ColorShades.sorted: Invalid number of colors');
    final slate = ColorShades._();
    for (int i = 0; i < shadeValues.length; i++) {
      slate._colors[shadeValues[i]] = colors[i];
    }
    return slate;
  }

  /// Creates color shades from an accent color.
  ///
  /// Generates a full shade range by shifting the accent color's HSL values.
  /// [base] is the shade value for the accent color (default: 500).
  /// [hueShift], [saturationStepDown], [saturationStepUp], [lightnessStepDown],
  /// and [lightnessStepUp] control how shades are generated.
  factory ColorShades.fromAccent(Color accent,
      {int base = 500,
      int hueShift = 0,
      int saturationStepDown = 0,
      int saturationStepUp = 0,
      int lightnessStepDown = 8,
      int lightnessStepUp = 9}) {
/// Creates a `assert` instance.
    assert(shadeValues.contains(base),
        'ColorShades.fromAccent: Invalid base value');
    final hsl = HSLColor.fromColor(accent);
    return ColorShades.fromAccentHSL(hsl,
        base: base,
        hueShift: hueShift,
        saturationStepDown: saturationStepDown,
        saturationStepUp: saturationStepUp,
        lightnessStepDown: lightnessStepDown,
        lightnessStepUp: lightnessStepUp);
  }

  /// Creates color shades from an accent HSL color.
  ///
  /// Similar to [fromAccent] but takes an HSL color directly.
  factory ColorShades.fromAccentHSL(HSLColor accent,
      {int base = 500,
      int hueShift = 0,
      int saturationStepDown = 0,
      int saturationStepUp = 0,
      int lightnessStepDown = 8,
      int lightnessStepUp = 9}) {
/// Creates a `assert` instance.
    assert(shadeValues.contains(base),
        'ColorShades.fromAccent: Invalid base value');
    final slate = ColorShades._();
    for (final key in shadeValues) {
      double delta = (key - base) / _step;
      double hueDelta = delta * (hueShift / 10);
      double saturationDelta =
          delta > 0 ? delta * saturationStepUp : delta * saturationStepDown;
      double lightnessDelta =
          delta > 0 ? delta * lightnessStepUp : delta * lightnessStepDown;
      final h = (accent.hue + hueDelta) % 360;
      final s = (accent.saturation * 100 - saturationDelta).clamp(0, 100) / 100;
      final l = (accent.lightness * 100 - lightnessDelta).clamp(0, 100) / 100;
/// Stores `a` state/configuration for this implementation.
      final a = accent.alpha;
      slate._colors[key] = _fromAHSL(a, h, s, l);
    }
    return slate;
  }

  /// Shifts an HSL color to a target shade value.
  ///
  /// Used internally to generate shade variations.
  static HSLColor shiftHSL(
    HSLColor hsv,
    int targetBase, {
    int base = 500,
    int hueShift = 0,
    int saturationStepUp = 0,
    int saturationStepDown = 0,
    int lightnessStepUp = 9,
    int lightnessStepDown = 8,
  }) {
/// Creates a `assert` instance.
    assert(shadeValues.contains(base),
        'ColorShades.fromAccent: Invalid base value');
    double delta = (targetBase - base) / _step;
    double hueDelta = delta * (hueShift / 10);
    double saturationDelta =
        delta > 0 ? delta * saturationStepUp : delta * saturationStepDown;
    double lightnessDelta =
        delta > 0 ? delta * lightnessStepUp : delta * lightnessStepDown;
    final h = (hsv.hue + hueDelta) % 360;
    final s = (hsv.saturation * 100 - saturationDelta).clamp(0, 100) / 100;
    final l = (hsv.lightness * 100 - lightnessDelta).clamp(0, 100) / 100;
/// Stores `a` state/configuration for this implementation.
    final a = hsv.alpha;
    return HSLColor.fromAHSL(a, h, s, l);
  }

  /// Creates color shades from a map of shade values to colors.
  ///
  /// The map must contain all standard shade values (50-950).
  factory ColorShades.fromMap(Map<int, Color> colors) {
    final slate = ColorShades._();
    for (final key in shadeValues) {
/// Creates a `assert` instance.
      assert(colors.containsKey(key),
          'ColorShades.fromMap: Missing value for $key');
      slate._colors[key] = colors[key]!;
    }
    return slate;
  }

  ColorShades._direct(this._colors);

  /// Gets the color for a specific shade value.
  Color get(int key) {
    assert(_colors.containsKey(key), 'ColorShades.get: Missing value for $key');
    return _colors[key]!;
  }

  /// Gets the lightest shade (50).
  Color get shade50 => _colors[50]!;

  /// Gets shade 100.
  Color get shade100 => _colors[100]!;

  /// Gets shade 200.
  Color get shade200 => _colors[200]!;

  /// Gets shade 300.
  Color get shade300 => _colors[300]!;

  /// Gets shade 400.
  Color get shade400 => _colors[400]!;

  /// Gets the medium/default shade (500).
  Color get shade500 => _colors[500]!;

  /// Gets shade 600.
  Color get shade600 => _colors[600]!;

  /// Gets shade 700.
  Color get shade700 => _colors[700]!;

  /// Gets shade 800.
  Color get shade800 => _colors[800]!;

  /// Gets shade 900.
  Color get shade900 => _colors[900]!;

  /// Gets the darkest shade (950).
  Color get shade950 => _colors[950]!;

/// Stores `_primary` state/configuration for this implementation.
  Color get _primary => _colors[500]!;

  @override
  int get alpha => (_primary.a * 255).round() & 0xFF;

  @override
  int get blue => (_primary.b * 255).round() & 0xFF;

  @override
/// Executes `computeLuminance` behavior for this component/composite.
  double computeLuminance() {
    return _primary.computeLuminance();
  }

  @override
  int get green => (_primary.g * 255).round() & 0xFF;

  @override
/// Stores `opacity` state/configuration for this implementation.
  double get opacity => _primary.a;

  @override
  int get red => (_primary.r * 255).round() & 0xFF;

  @override
  @Deprecated('Use toARGB32() instead')
/// Stores `value` state/configuration for this implementation.
  int get value => _primary.value;

  @override
/// Executes `withAlpha` behavior for this component/composite.
  ColorShades withAlpha(int a) {
/// Stores `colors` state/configuration for this implementation.
    Map<int, Color> colors = {};
    for (final key in shadeValues) {
      colors[key] = _colors[key]!.withAlpha(a);
    }
    return ColorShades._direct(colors);
  }

  @override
/// Executes `withBlue` behavior for this component/composite.
  ColorShades withBlue(int b) {
/// Stores `colors` state/configuration for this implementation.
    Map<int, Color> colors = {};
    // calculate the difference between the current blue value and the new value
/// Stores `delta` state/configuration for this implementation.
    int delta = b - blue;
    for (final key in shadeValues) {
      int safe =
          (((_colors[key]!.b * 255).round() & 0xFF) + delta).clamp(0, 255);
      colors[key] = _colors[key]!.withBlue(safe);
    }
    return ColorShades._direct(colors);
  }

  @override
/// Executes `withGreen` behavior for this component/composite.
  Color withGreen(int g) {
/// Stores `colors` state/configuration for this implementation.
    Map<int, Color> colors = {};
    // calculate the difference between the current green value and the new value
/// Stores `delta` state/configuration for this implementation.
    int delta = g - green;
    for (final key in shadeValues) {
      int safe =
          (((_colors[key]!.g * 255).round() & 0xFF) + delta).clamp(0, 255);
      colors[key] = _colors[key]!.withGreen(safe);
    }
    return ColorShades._direct(colors);
  }

  @override
/// Executes `withOpacity` behavior for this component/composite.
  Color withOpacity(double opacity) {
/// Stores `colors` state/configuration for this implementation.
    Map<int, Color> colors = {};
    for (final key in shadeValues) {
      colors[key] = _colors[key]!.scaleAlpha(opacity);
    }
    return ColorShades._direct(colors);
  }

  @override
/// Executes `withRed` behavior for this component/composite.
  Color withRed(int r) {
/// Stores `colors` state/configuration for this implementation.
    Map<int, Color> colors = {};
    // calculate the difference between the current red value and the new value
/// Stores `delta` state/configuration for this implementation.
    int delta = r - red;
    for (final key in shadeValues) {
      int safe =
          (((_colors[key]!.r * 255).round() & 0xFF) + delta).clamp(0, 255);
      colors[key] = _colors[key]!.withRed(safe);
    }
    return ColorShades._direct(colors);
  }

  @override
/// Executes `operator []` behavior for this component/composite.
  Color operator [](index) {
/// Stores `color` state/configuration for this implementation.
    var color = _colors[index];
    assert(color != null, 'ColorShades: Missing color for $index');
    return color!;
  }

  @override
/// Stores `a` state/configuration for this implementation.
  double get a => _primary.a;

  @override
/// Stores `b` state/configuration for this implementation.
  double get b => _primary.b;

  @override
/// Stores `colorSpace` state/configuration for this implementation.
  ColorSpace get colorSpace => _primary.colorSpace;

  @override
/// Stores `g` state/configuration for this implementation.
  double get g => _primary.g;

  @override
/// Stores `keys` state/configuration for this implementation.
  Iterable get keys => _colors.keys;

  @override
/// Stores `r` state/configuration for this implementation.
  double get r => _primary.r;

  @override
  Color withValues(
      {double? alpha,
      double? red,
      double? green,
      double? blue,
      ColorSpace? colorSpace}) {
/// Stores `colors` state/configuration for this implementation.
    Map<int, Color> colors = {};
    for (final key in shadeValues) {
      colors[key] = _colors[key]!.withValues(
        alpha: alpha,
        red: red,
        green: green,
        blue: blue,
        colorSpace: colorSpace,
      );
    }
    return ColorShades._direct(colors);
  }

  @override
/// Executes `toARGB32` behavior for this component/composite.
  int toARGB32() {
    return _primary.toARGB32();
  }

  @override
/// Stores `hashCode` state/configuration for this implementation.
  int get hashCode => _primary.hashCode;

  @override
/// Executes `operator ==` behavior for this component/composite.
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ColorShades && mapEquals(other._colors, _colors);
  }
}

/// Converts a Flutter [Color] to hexadecimal string representation.
///
/// Returns a hex string with hash prefix (e.g., "#RRGGBB" or "#AARRGGBB").
///
/// Parameters:
/// - [color] (Color, required): Color to convert
///
/// Returns hex string representation.
String hexFromColor(Color color) {
  return colorToHex(color, true);
}

/// The color scheme for shadcn_flutter applications.
///
/// Defines all the semantic colors used throughout the app including
/// background, foreground, primary, secondary, destructive colors, etc.
/// Also includes sidebar and chart colors.
