part of '../../color_scheme.dart';

/// ColorScheme defines a reusable type for this registry module.
class ColorScheme implements ChartColorScheme {
  /// Returns the color scheme for the given context.
  ///
  /// Parameters:
  /// - [context] (BuildContext, required): The build context.
  ///
  /// Returns the color scheme for the given context.
  static ColorScheme of(BuildContext context) {
    return Theme.of(context).colorScheme;
  }

  /// Set of recognized color key names for the color scheme.
  ///
  /// Contains all valid color property names that can be used when
  /// constructing or serializing a ColorScheme.
  static const Set<String> colorKeys = {
    'background',
    'foreground',
    'card',
    'cardForeground',
    'popover',
    'popoverForeground',
    'primary',
    'primaryForeground',
    'secondary',
    'secondaryForeground',
    'muted',
    'mutedForeground',
    'accent',
    'accentForeground',
    'destructive',
    'destructiveForeground',
    'border',
    'input',
    'ring',
    'chart1',
    'chart2',
    'chart3',
    'chart4',
    'chart5',
  };

  /// The brightness of this color scheme (light or dark).
  final Brightness brightness;

  /// The background color.
  final Color background;

  /// The foreground color (typically text).
  final Color foreground;

  /// The card background color.
  final Color card;

  /// The card foreground color.
  final Color cardForeground;

  /// The popover background color.
  final Color popover;

  /// The popover foreground color.
  final Color popoverForeground;

  /// The primary brand color.
  final Color primary;

  /// The foreground color for primary elements.
  final Color primaryForeground;

  /// The secondary color.
  final Color secondary;

  /// The foreground color for secondary elements.
  final Color secondaryForeground;

  /// The muted background color.
  final Color muted;

  /// The muted foreground color.
  final Color mutedForeground;

  /// The accent color.
  final Color accent;

  /// The foreground color for accented elements.
  final Color accentForeground;

  /// The destructive action color (typically red).
  final Color destructive;

  /// The foreground color for destructive elements.
  @Deprecated('Legacy color')
  final Color destructiveForeground;

  /// The border color.
  final Color border;

  /// The input field border color.
  final Color input;

  /// The focus ring color.
  final Color ring;

  /// The sidebar background color.
  final Color sidebar;

  /// The sidebar foreground color.
  final Color sidebarForeground;

  /// The sidebar primary color.
  final Color sidebarPrimary;

  /// The sidebar primary foreground color.
  final Color sidebarPrimaryForeground;

  /// The sidebar accent color.
  final Color sidebarAccent;

  /// The sidebar accent foreground color.
  final Color sidebarAccentForeground;

  /// The sidebar border color.
  final Color sidebarBorder;

  /// The sidebar ring color.
  final Color sidebarRing;

  @override
/// Stores `chart1` state/configuration for this implementation.
  final Color chart1;
  @override
/// Stores `chart2` state/configuration for this implementation.
  final Color chart2;
  @override
/// Stores `chart3` state/configuration for this implementation.
  final Color chart3;
  @override
/// Stores `chart4` state/configuration for this implementation.
  final Color chart4;
  @override
/// Stores `chart5` state/configuration for this implementation.
  final Color chart5;

  /// Creates a color scheme with all required colors.
  const ColorScheme({
    required this.brightness,
    required this.background,
    required this.foreground,
    required this.card,
    required this.cardForeground,
    required this.popover,
    required this.popoverForeground,
    required this.primary,
    required this.primaryForeground,
    required this.secondary,
    required this.secondaryForeground,
    required this.muted,
    required this.mutedForeground,
    required this.accent,
    required this.accentForeground,
    required this.destructive,
    this.destructiveForeground = Colors.transparent,
    required this.border,
    required this.input,
    required this.ring,
    required this.chart1,
    required this.chart2,
    required this.chart3,
    required this.chart4,
    required this.chart5,
    required this.sidebar,
    required this.sidebarForeground,
    required this.sidebarPrimary,
    required this.sidebarPrimaryForeground,
    required this.sidebarAccent,
    required this.sidebarAccentForeground,
    required this.sidebarBorder,
    required this.sidebarRing,
  });

  /// Creates a color scheme from a map of color names to values.
  ColorScheme.fromMap(Map<String, dynamic> map)
      : background = map._col('background'),
        foreground = map._col('foreground'),
        card = map._col('card'),
        cardForeground = map._col('cardForeground'),
        popover = map._col('popover'),
        popoverForeground = map._col('popoverForeground'),
        primary = map._col('primary'),
        primaryForeground = map._col('primaryForeground'),
        secondary = map._col('secondary'),
        secondaryForeground = map._col('secondaryForeground'),
        muted = map._col('muted'),
        mutedForeground = map._col('mutedForeground'),
        accent = map._col('accent'),
        accentForeground = map._col('accentForeground'),
        destructive = map._col('destructive'),
        // ignore: deprecated_member_use_from_same_package
        destructiveForeground = map._col('destructiveForeground'),
        border = map._col('border'),
        input = map._col('input'),
        ring = map._col('ring'),
        chart1 = map._col('chart1'),
        chart2 = map._col('chart2'),
        chart3 = map._col('chart3'),
        chart4 = map._col('chart4'),
        chart5 = map._col('chart5'),
        sidebar = map._col('sidebar'),
        sidebarForeground = map._col('sidebarForeground'),
        sidebarPrimary = map._col('sidebarPrimary'),
        sidebarPrimaryForeground = map._col('sidebarPrimaryForeground'),
        sidebarAccent = map._col('sidebarAccent'),
        sidebarAccentForeground = map._col('sidebarAccentForeground'),
        sidebarBorder = map._col('sidebarBorder'),
        sidebarRing = map._col('sidebarRing'),
        brightness = Brightness.values
                .where((element) => element.name == map['brightness'])
                .firstOrNull ??
            Brightness.light;

  /// Converts the color scheme to a map of hex color strings.
  ///
  /// Returns a map where keys are color property names and values are
  /// hex-encoded color strings (e.g., "#RRGGBB").
  ///
  /// Useful for serialization or CSS generation.
  Map<String, String> toMap() {
    return {
      'background': hexFromColor(background),
      'foreground': hexFromColor(foreground),
      'card': hexFromColor(card),
      'cardForeground': hexFromColor(cardForeground),
      'popover': hexFromColor(popover),
      'popoverForeground': hexFromColor(popoverForeground),
      'primary': hexFromColor(primary),
      'primaryForeground': hexFromColor(primaryForeground),
      'secondary': hexFromColor(secondary),
      'secondaryForeground': hexFromColor(secondaryForeground),
      'muted': hexFromColor(muted),
      'mutedForeground': hexFromColor(mutedForeground),
      'accent': hexFromColor(accent),
      'accentForeground': hexFromColor(accentForeground),
      'destructive': hexFromColor(destructive),
      // ignore: deprecated_member_use_from_same_package
      'destructiveForeground': hexFromColor(destructiveForeground),
      'border': hexFromColor(border),
      'input': hexFromColor(input),
      'ring': hexFromColor(ring),
      'chart1': hexFromColor(chart1),
      'chart2': hexFromColor(chart2),
      'chart3': hexFromColor(chart3),
      'chart4': hexFromColor(chart4),
      'chart5': hexFromColor(chart5),
      'sidebar': hexFromColor(sidebar),
      'sidebarForeground': hexFromColor(sidebarForeground),
      'sidebarPrimary': hexFromColor(sidebarPrimary),
      'sidebarPrimaryForeground': hexFromColor(sidebarPrimaryForeground),
      'sidebarAccent': hexFromColor(sidebarAccent),
      'sidebarAccentForeground': hexFromColor(sidebarAccentForeground),
      'sidebarBorder': hexFromColor(sidebarBorder),
      'sidebarRing': hexFromColor(sidebarRing),
      'brightness': brightness.name,
    };
  }

  /// Converts the color scheme to a map of Color objects.
  ///
  /// Returns a map where keys are color property names and values are
  /// Flutter Color objects.
  ///
  /// Useful for programmatic color access.
  Map<String, Color> toColorMap() {
    return {
      'background': background,
      'foreground': foreground,
      'card': card,
      'cardForeground': cardForeground,
      'popover': popover,
      'popoverForeground': popoverForeground,
      'primary': primary,
      'primaryForeground': primaryForeground,
      'secondary': secondary,
      'secondaryForeground': secondaryForeground,
      'muted': muted,
      'mutedForeground': mutedForeground,
      'accent': accent,
      'accentForeground': accentForeground,
      'destructive': destructive,
      // ignore: deprecated_member_use_from_same_package
      'destructiveForeground': destructiveForeground,
      'border': border,
      'input': input,
      'ring': ring,
      'chart1': chart1,
      'chart2': chart2,
      'chart3': chart3,
      'chart4': chart4,
      'chart5': chart5,
      'sidebar': sidebar,
      'sidebarForeground': sidebarForeground,
      'sidebarPrimary': sidebarPrimary,
      'sidebarPrimaryForeground': sidebarPrimaryForeground,
      'sidebarAccent': sidebarAccent,
      'sidebarAccentForeground': sidebarAccentForeground,
      'sidebarBorder': sidebarBorder,
      'sidebarRing': sidebarRing,
    };
  }

  /// Creates a ColorScheme from a map of colors.
  ///
  /// Constructs a ColorScheme by looking up color values from a map.
  ///
  /// Parameters:
  /// - [colors] (`Map<String, Color>`, required): Map of color name to Color
  /// - [brightness] (Brightness, required): Theme brightness (light or dark)
  ///
  /// Example:
  /// ```dart
  /// ColorScheme.fromColors(
  ///   colors: {'background': Colors.white, 'foreground': Colors.black, ...},
  ///   brightness: Brightness.light,
  /// )
  /// ```
  ColorScheme.fromColors({
    required Map<String, Color> colors,
    required Brightness brightness,
  }) : this(
          brightness: brightness,
          background: colors._col('background'),
          foreground: colors._col('foreground'),
          card: colors._col('card'),
          cardForeground: colors._col('cardForeground'),
          popover: colors._col('popover'),
          popoverForeground: colors._col('popoverForeground'),
          primary: colors._col('primary'),
          primaryForeground: colors._col('primaryForeground'),
          secondary: colors._col('secondary'),
          secondaryForeground: colors._col('secondaryForeground'),
          muted: colors._col('muted'),
          mutedForeground: colors._col('mutedForeground'),
          accent: colors._col('accent'),
          accentForeground: colors._col('accentForeground'),
          destructive: colors._col('destructive'),
          destructiveForeground: colors._col('destructiveForeground'),
          border: colors._col('border'),
          input: colors._col('input'),
          ring: colors._col('ring'),
          chart1: colors._col('chart1'),
          chart2: colors._col('chart2'),
          chart3: colors._col('chart3'),
          chart4: colors._col('chart4'),
          chart5: colors._col('chart5'),
          sidebar: colors._col('sidebar'),
          sidebarForeground: colors._col('sidebarForeground'),
          sidebarPrimary: colors._col('sidebarPrimary'),
          sidebarPrimaryForeground: colors._col('sidebarPrimaryForeground'),
          sidebarAccent: colors._col('sidebarAccent'),
          sidebarAccentForeground: colors._col('sidebarAccentForeground'),
          sidebarBorder: colors._col('sidebarBorder'),
          sidebarRing: colors._col('sidebarRing'),
        );

  /// Creates a copy of this ColorScheme with specified properties replaced.
  ///
  /// Returns a new ColorScheme with any provided properties replaced.
  /// Uses ValueGetter for each property to allow lazy evaluation.
  ///
  /// Parameters are ValueGetters for all color scheme properties. Only
  /// provided parameters will be replaced in the copy.
  ///
  /// Example:
  /// ```dart
  /// scheme.copyWith(
  ///   background: () => Colors.white,
  ///   foreground: () => Colors.black,
  /// )
  /// ```
  ColorScheme copyWith({
    ValueGetter<Brightness>? brightness,
    ValueGetter<Color>? background,
    ValueGetter<Color>? foreground,
    ValueGetter<Color>? card,
    ValueGetter<Color>? cardForeground,
    ValueGetter<Color>? popover,
    ValueGetter<Color>? popoverForeground,
    ValueGetter<Color>? primary,
    ValueGetter<Color>? primaryForeground,
    ValueGetter<Color>? secondary,
    ValueGetter<Color>? secondaryForeground,
    ValueGetter<Color>? muted,
    ValueGetter<Color>? mutedForeground,
    ValueGetter<Color>? accent,
    ValueGetter<Color>? accentForeground,
    ValueGetter<Color>? destructive,
    ValueGetter<Color>? destructiveForeground,
    ValueGetter<Color>? border,
    ValueGetter<Color>? input,
    ValueGetter<Color>? ring,
    ValueGetter<Color>? chart1,
    ValueGetter<Color>? chart2,
    ValueGetter<Color>? chart3,
    ValueGetter<Color>? chart4,
    ValueGetter<Color>? chart5,
    ValueGetter<Color>? sidebar,
    ValueGetter<Color>? sidebarForeground,
    ValueGetter<Color>? sidebarPrimary,
    ValueGetter<Color>? sidebarPrimaryForeground,
    ValueGetter<Color>? sidebarAccent,
    ValueGetter<Color>? sidebarAccentForeground,
    ValueGetter<Color>? sidebarBorder,
    ValueGetter<Color>? sidebarRing,
  }) {
    return ColorScheme(
      brightness: brightness == null ? this.brightness : brightness(),
      background: background == null ? this.background : background(),
      foreground: foreground == null ? this.foreground : foreground(),
      card: card == null ? this.card : card(),
      cardForeground:
          cardForeground == null ? this.cardForeground : cardForeground(),
      popover: popover == null ? this.popover : popover(),
      popoverForeground: popoverForeground == null
          ? this.popoverForeground
          : popoverForeground(),
      primary: primary == null ? this.primary : primary(),
      primaryForeground: primaryForeground == null
          ? this.primaryForeground
          : primaryForeground(),
      secondary: secondary == null ? this.secondary : secondary(),
      secondaryForeground: secondaryForeground == null
          ? this.secondaryForeground
          : secondaryForeground(),
      muted: muted == null ? this.muted : muted(),
      mutedForeground:
          mutedForeground == null ? this.mutedForeground : mutedForeground(),
      accent: accent == null ? this.accent : accent(),
      accentForeground:
          accentForeground == null ? this.accentForeground : accentForeground(),
      destructive: destructive == null ? this.destructive : destructive(),
      destructiveForeground: destructiveForeground == null
          // ignore: deprecated_member_use_from_same_package
          ? this.destructiveForeground
          : destructiveForeground(),
      border: border == null ? this.border : border(),
      input: input == null ? this.input : input(),
      ring: ring == null ? this.ring : ring(),
      chart1: chart1 == null ? this.chart1 : chart1(),
      chart2: chart2 == null ? this.chart2 : chart2(),
      chart3: chart3 == null ? this.chart3 : chart3(),
      chart4: chart4 == null ? this.chart4 : chart4(),
      chart5: chart5 == null ? this.chart5 : chart5(),
      sidebar: sidebar == null ? this.sidebar : sidebar(),
      sidebarForeground: sidebarForeground == null
          ? this.sidebarForeground
          : sidebarForeground(),
      sidebarPrimary:
          sidebarPrimary == null ? this.sidebarPrimary : sidebarPrimary(),
      sidebarPrimaryForeground: sidebarPrimaryForeground == null
          ? this.sidebarPrimaryForeground
          : sidebarPrimaryForeground(),
      sidebarAccent:
          sidebarAccent == null ? this.sidebarAccent : sidebarAccent(),
      sidebarAccentForeground: sidebarAccentForeground == null
          ? this.sidebarAccentForeground
          : sidebarAccentForeground(),
      sidebarBorder:
          sidebarBorder == null ? this.sidebarBorder : sidebarBorder(),
      sidebarRing: sidebarRing == null ? this.sidebarRing : sidebarRing(),
    );
  }

  @override
/// Stores `chartColors` state/configuration for this implementation.
  List<Color> get chartColors => [chart1, chart2, chart3, chart4, chart5];

  /// Linearly interpolates between two ColorSchemes.
  ///
  /// Creates a new ColorScheme that represents a transition between [a] and [b]
  /// at position [t]. When t=0, returns [a]; when t=1, returns [b].
  ///
  /// Parameters:
  /// - [a] (ColorScheme, required): Start color scheme
  /// - [b] (ColorScheme, required): End color scheme
  /// - [t] (double, required): Interpolation position (0.0 to 1.0)
  ///
  /// Returns interpolated ColorScheme.
  static ColorScheme lerp(ColorScheme a, ColorScheme b, double t) {
    return ColorScheme(
      brightness: t < 0.5 ? a.brightness : b.brightness,
      background: Color.lerp(a.background, b.background, t)!,
      foreground: Color.lerp(a.foreground, b.foreground, t)!,
      card: Color.lerp(a.card, b.card, t)!,
      cardForeground: Color.lerp(a.cardForeground, b.cardForeground, t)!,
      popover: Color.lerp(a.popover, b.popover, t)!,
      popoverForeground:
/// Creates a `Color.lerp` instance.
          Color.lerp(a.popoverForeground, b.popoverForeground, t)!,
      primary: Color.lerp(a.primary, b.primary, t)!,
      primaryForeground:
/// Creates a `Color.lerp` instance.
          Color.lerp(a.primaryForeground, b.primaryForeground, t)!,
      secondary: Color.lerp(a.secondary, b.secondary, t)!,
      secondaryForeground:
/// Creates a `Color.lerp` instance.
          Color.lerp(a.secondaryForeground, b.secondaryForeground, t)!,
      muted: Color.lerp(a.muted, b.muted, t)!,
      mutedForeground: Color.lerp(a.mutedForeground, b.mutedForeground, t)!,
      accent: Color.lerp(a.accent, b.accent, t)!,
      accentForeground: Color.lerp(a.accentForeground, b.accentForeground, t)!,
      destructive: Color.lerp(a.destructive, b.destructive, t)!,
      border: Color.lerp(a.border, b.border, t)!,
      input: Color.lerp(a.input, b.input, t)!,
      ring: Color.lerp(a.ring, b.ring, t)!,
      chart1: Color.lerp(a.chart1, b.chart1, t)!,
      chart2: Color.lerp(a.chart2, b.chart2, t)!,
      chart3: Color.lerp(a.chart3, b.chart3, t)!,
      chart4: Color.lerp(a.chart4, b.chart4, t)!,
      chart5: Color.lerp(a.chart5, b.chart5, t)!,
      sidebar: Color.lerp(a.sidebar, b.sidebar, t)!,
      sidebarForeground:
/// Creates a `Color.lerp` instance.
          Color.lerp(a.sidebarForeground, b.sidebarForeground, t)!,
      sidebarPrimary: Color.lerp(a.sidebarPrimary, b.sidebarPrimary, t)!,
      sidebarPrimaryForeground: Color.lerp(
          a.sidebarPrimaryForeground, b.sidebarPrimaryForeground, t)!,
      sidebarAccent: Color.lerp(a.sidebarAccent, b.sidebarAccent, t)!,
      sidebarAccentForeground:
/// Creates a `Color.lerp` instance.
          Color.lerp(a.sidebarAccentForeground, b.sidebarAccentForeground, t)!,
      sidebarBorder: Color.lerp(a.sidebarBorder, b.sidebarBorder, t)!,
      sidebarRing: Color.lerp(a.sidebarRing, b.sidebarRing, t)!,
    );
  }

  @override
/// Executes `operator ==` behavior for this component/composite.
  bool operator ==(Object other) =>
/// Creates a `identical` instance.
      identical(this, other) ||
      other is ColorScheme &&
          runtimeType == other.runtimeType &&
          brightness == other.brightness &&
          background == other.background &&
          foreground == other.foreground &&
          card == other.card &&
          cardForeground == other.cardForeground &&
          popover == other.popover &&
          popoverForeground == other.popoverForeground &&
          primary == other.primary &&
          primaryForeground == other.primaryForeground &&
          secondary == other.secondary &&
          secondaryForeground == other.secondaryForeground &&
          muted == other.muted &&
          mutedForeground == other.mutedForeground &&
          accent == other.accent &&
          accentForeground == other.accentForeground &&
          destructive == other.destructive &&
          border == other.border &&
          input == other.input &&
          ring == other.ring &&
          chart1 == other.chart1 &&
          chart2 == other.chart2 &&
          chart3 == other.chart3 &&
          chart4 == other.chart4 &&
          chart5 == other.chart5 &&
          sidebar == other.sidebar &&
          sidebarForeground == other.sidebarForeground &&
          sidebarPrimary == other.sidebarPrimary &&
          sidebarPrimaryForeground == other.sidebarPrimaryForeground &&
          sidebarAccent == other.sidebarAccent &&
          sidebarAccentForeground == other.sidebarAccentForeground &&
          sidebarBorder == other.sidebarBorder &&
          sidebarRing == other.sidebarRing;

  @override
  int get hashCode => Object.hash(
/// Creates a `Object.hash` instance.
        Object.hash(
          brightness,
          background,
          foreground,
          card,
          cardForeground,
          popover,
          popoverForeground,
          primary,
          primaryForeground,
          secondary,
          secondaryForeground,
          muted,
          mutedForeground,
          accent,
          accentForeground,
          destructive,
          // ignore: deprecated_member_use_from_same_package
          destructiveForeground,
          border,
          input,
          ring,
        ),
/// Creates a `Object.hash` instance.
        Object.hash(
            chart1,
            chart2,
            chart3,
            chart4,
            chart5,
            sidebar,
            sidebarForeground,
            sidebarPrimary,
            sidebarPrimaryForeground,
            sidebarAccent,
            sidebarAccentForeground,
            sidebarBorder,
            sidebarRing),
      );

  @override
/// Executes `toString` behavior for this component/composite.
  String toString() {
    // ignore: deprecated_member_use_from_same_package
    return 'ColorScheme{brightness: $brightness, background: $background, foreground: $foreground, card: $card, cardForeground: $cardForeground, popover: $popover, popoverForeground: $popoverForeground, primary: $primary, primaryForeground: $primaryForeground, secondary: $secondary, secondaryForeground: $secondaryForeground, muted: $muted, mutedForeground: $mutedForeground, accent: $accent, accentForeground: $accentForeground, destructive: $destructive, destructiveForeground: $destructiveForeground, border: $border, input: $input, ring: $ring, chart1: $chart1, chart2: $chart2, chart3: $chart3, chart4: $chart4, chart5: $chart5, sidebar: $sidebar, sidebarForeground: $sidebarForeground, sidebarPrimary: $sidebarPrimary, sidebarPrimaryForeground: $sidebarPrimaryForeground, sidebarAccent: $sidebarAccent, sidebarAccentForeground: $sidebarAccentForeground, sidebarBorder: $sidebarBorder, sidebarRing: $sidebarRing}';
  }
}

/// Extension helpers used by this registry module.
extension _MapColorGetter on Map<String, Color> {
/// Executes `_col` behavior for this component/composite.
  Color _col(String name) {
/// Stores `color` state/configuration for this implementation.
    Color? color = this[name];
    assert(color != null, 'ColorScheme: Missing color for $name');
    return color!;
  }
}

/// Extension helpers used by this registry module.
extension _DynamicMapColorGetter on Map<String, dynamic> {
/// Executes `_col` behavior for this component/composite.
  Color _col(String name) {
/// Stores `value` state/configuration for this implementation.
    String? value = this[name];
    assert(value != null, 'ColorScheme: Missing color for $name');
    if (value!.startsWith('#')) {
      value = value.substring(1);
    }
    if (value.length == 6) {
      value = 'FF$value';
    }
    var parse = int.tryParse(value, radix: 16);
    assert(parse != null, 'ColorScheme: Invalid hex color value $value');
    return Color(parse!);
  }
}
