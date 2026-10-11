import 'package:flutter/widgets.dart';

/// The 32 shadcn color tokens for one brightness.
///
/// Field names match the preset JSON keys exactly (camelCase of the shadcn
/// CSS variables, PLAN §6.1). Colors may carry alpha (8-digit ARGB); never
/// assume opaque. `destructiveForeground` is a normal field (un-deprecated
/// per QA decision A5); contrast derivation only applies at import time.
class ShadcnColors {
  const ShadcnColors({
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
    required this.destructiveForeground,
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

  final Brightness brightness;
  final Color background;
  final Color foreground;
  final Color card;
  final Color cardForeground;
  final Color popover;
  final Color popoverForeground;
  final Color primary;
  final Color primaryForeground;
  final Color secondary;
  final Color secondaryForeground;
  final Color muted;
  final Color mutedForeground;
  final Color accent;
  final Color accentForeground;
  final Color destructive;
  final Color destructiveForeground;
  final Color border;
  final Color input;
  final Color ring;
  final Color chart1;
  final Color chart2;
  final Color chart3;
  final Color chart4;
  final Color chart5;
  final Color sidebar;
  final Color sidebarForeground;
  final Color sidebarPrimary;
  final Color sidebarPrimaryForeground;
  final Color sidebarAccent;
  final Color sidebarAccentForeground;
  final Color sidebarBorder;
  final Color sidebarRing;

  /// Chart series colors in order.
  List<Color> get chartColors => [chart1, chart2, chart3, chart4, chart5];

  /// All tokens are non-nullable, so copyWith takes plain optional values.
  ShadcnColors copyWith({
    Brightness? brightness,
    Color? background,
    Color? foreground,
    Color? card,
    Color? cardForeground,
    Color? popover,
    Color? popoverForeground,
    Color? primary,
    Color? primaryForeground,
    Color? secondary,
    Color? secondaryForeground,
    Color? muted,
    Color? mutedForeground,
    Color? accent,
    Color? accentForeground,
    Color? destructive,
    Color? destructiveForeground,
    Color? border,
    Color? input,
    Color? ring,
    Color? chart1,
    Color? chart2,
    Color? chart3,
    Color? chart4,
    Color? chart5,
    Color? sidebar,
    Color? sidebarForeground,
    Color? sidebarPrimary,
    Color? sidebarPrimaryForeground,
    Color? sidebarAccent,
    Color? sidebarAccentForeground,
    Color? sidebarBorder,
    Color? sidebarRing,
  }) {
    return ShadcnColors(
      brightness: brightness ?? this.brightness,
      background: background ?? this.background,
      foreground: foreground ?? this.foreground,
      card: card ?? this.card,
      cardForeground: cardForeground ?? this.cardForeground,
      popover: popover ?? this.popover,
      popoverForeground: popoverForeground ?? this.popoverForeground,
      primary: primary ?? this.primary,
      primaryForeground: primaryForeground ?? this.primaryForeground,
      secondary: secondary ?? this.secondary,
      secondaryForeground: secondaryForeground ?? this.secondaryForeground,
      muted: muted ?? this.muted,
      mutedForeground: mutedForeground ?? this.mutedForeground,
      accent: accent ?? this.accent,
      accentForeground: accentForeground ?? this.accentForeground,
      destructive: destructive ?? this.destructive,
      destructiveForeground:
          destructiveForeground ?? this.destructiveForeground,
      border: border ?? this.border,
      input: input ?? this.input,
      ring: ring ?? this.ring,
      chart1: chart1 ?? this.chart1,
      chart2: chart2 ?? this.chart2,
      chart3: chart3 ?? this.chart3,
      chart4: chart4 ?? this.chart4,
      chart5: chart5 ?? this.chart5,
      sidebar: sidebar ?? this.sidebar,
      sidebarForeground: sidebarForeground ?? this.sidebarForeground,
      sidebarPrimary: sidebarPrimary ?? this.sidebarPrimary,
      sidebarPrimaryForeground:
          sidebarPrimaryForeground ?? this.sidebarPrimaryForeground,
      sidebarAccent: sidebarAccent ?? this.sidebarAccent,
      sidebarAccentForeground:
          sidebarAccentForeground ?? this.sidebarAccentForeground,
      sidebarBorder: sidebarBorder ?? this.sidebarBorder,
      sidebarRing: sidebarRing ?? this.sidebarRing,
    );
  }

  /// Field-wise lerp. Brightness steps at t = 0.5.
  static ShadcnColors lerp(ShadcnColors a, ShadcnColors b, double t) {
    Color mix(Color x, Color y) => Color.lerp(x, y, t)!;
    return ShadcnColors(
      brightness: t < 0.5 ? a.brightness : b.brightness,
      background: mix(a.background, b.background),
      foreground: mix(a.foreground, b.foreground),
      card: mix(a.card, b.card),
      cardForeground: mix(a.cardForeground, b.cardForeground),
      popover: mix(a.popover, b.popover),
      popoverForeground: mix(a.popoverForeground, b.popoverForeground),
      primary: mix(a.primary, b.primary),
      primaryForeground: mix(a.primaryForeground, b.primaryForeground),
      secondary: mix(a.secondary, b.secondary),
      secondaryForeground: mix(a.secondaryForeground, b.secondaryForeground),
      muted: mix(a.muted, b.muted),
      mutedForeground: mix(a.mutedForeground, b.mutedForeground),
      accent: mix(a.accent, b.accent),
      accentForeground: mix(a.accentForeground, b.accentForeground),
      destructive: mix(a.destructive, b.destructive),
      destructiveForeground: mix(
        a.destructiveForeground,
        b.destructiveForeground,
      ),
      border: mix(a.border, b.border),
      input: mix(a.input, b.input),
      ring: mix(a.ring, b.ring),
      chart1: mix(a.chart1, b.chart1),
      chart2: mix(a.chart2, b.chart2),
      chart3: mix(a.chart3, b.chart3),
      chart4: mix(a.chart4, b.chart4),
      chart5: mix(a.chart5, b.chart5),
      sidebar: mix(a.sidebar, b.sidebar),
      sidebarForeground: mix(a.sidebarForeground, b.sidebarForeground),
      sidebarPrimary: mix(a.sidebarPrimary, b.sidebarPrimary),
      sidebarPrimaryForeground: mix(
        a.sidebarPrimaryForeground,
        b.sidebarPrimaryForeground,
      ),
      sidebarAccent: mix(a.sidebarAccent, b.sidebarAccent),
      sidebarAccentForeground: mix(
        a.sidebarAccentForeground,
        b.sidebarAccentForeground,
      ),
      sidebarBorder: mix(a.sidebarBorder, b.sidebarBorder),
      sidebarRing: mix(a.sidebarRing, b.sidebarRing),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ShadcnColors &&
        other.brightness == brightness &&
        other.background == background &&
        other.foreground == foreground &&
        other.card == card &&
        other.cardForeground == cardForeground &&
        other.popover == popover &&
        other.popoverForeground == popoverForeground &&
        other.primary == primary &&
        other.primaryForeground == primaryForeground &&
        other.secondary == secondary &&
        other.secondaryForeground == secondaryForeground &&
        other.muted == muted &&
        other.mutedForeground == mutedForeground &&
        other.accent == accent &&
        other.accentForeground == accentForeground &&
        other.destructive == destructive &&
        other.destructiveForeground == destructiveForeground &&
        other.border == border &&
        other.input == input &&
        other.ring == ring &&
        other.chart1 == chart1 &&
        other.chart2 == chart2 &&
        other.chart3 == chart3 &&
        other.chart4 == chart4 &&
        other.chart5 == chart5 &&
        other.sidebar == sidebar &&
        other.sidebarForeground == sidebarForeground &&
        other.sidebarPrimary == sidebarPrimary &&
        other.sidebarPrimaryForeground == sidebarPrimaryForeground &&
        other.sidebarAccent == sidebarAccent &&
        other.sidebarAccentForeground == sidebarAccentForeground &&
        other.sidebarBorder == sidebarBorder &&
        other.sidebarRing == sidebarRing;
  }

  @override
  int get hashCode => Object.hashAll([
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
    destructiveForeground,
    border,
    input,
    ring,
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
    sidebarRing,
  ]);

  /// Transcribed from the old `ColorSchemes.lightDefaultColor`. Test and
  /// fallback baseline only; real apps use generated preset values.
  static const ShadcnColors lightFallback = ShadcnColors(
    brightness: Brightness.light,
    background: Color(0xFFFFFFFF),
    foreground: Color(0xFF0A0A0A),
    card: Color(0xFFFFFFFF),
    cardForeground: Color(0xFF0A0A0A),
    popover: Color(0xFFFFFFFF),
    popoverForeground: Color(0xFF0A0A0A),
    primary: Color(0xFF171717),
    primaryForeground: Color(0xFFFAFAFA),
    secondary: Color(0xFFF5F5F5),
    secondaryForeground: Color(0xFF171717),
    muted: Color(0xFFF5F5F5),
    mutedForeground: Color(0xFF737373),
    accent: Color(0xFFF5F5F5),
    accentForeground: Color(0xFF171717),
    destructive: Color(0xFFE7000B),
    destructiveForeground: Color(0xFFFFFFFF),
    border: Color(0xFFE5E5E5),
    input: Color(0xFFE5E5E5),
    ring: Color(0xFFA1A1A1),
    chart1: Color(0xFFF54900),
    chart2: Color(0xFF009689),
    chart3: Color(0xFF104E64),
    chart4: Color(0xFFFFB900),
    chart5: Color(0xFFFE9A00),
    sidebar: Color(0xFFFAFAFA),
    sidebarForeground: Color(0xFF0A0A0A),
    sidebarPrimary: Color(0xFF171717),
    sidebarPrimaryForeground: Color(0xFFFAFAFA),
    sidebarAccent: Color(0xFFF5F5F5),
    sidebarAccentForeground: Color(0xFF171717),
    sidebarBorder: Color(0xFFE5E5E5),
    sidebarRing: Color(0xFFA1A1A1),
  );

  /// Transcribed from the old `ColorSchemes.darkDefaultColor`. Also the
  /// readability fallback source for dark normalisation.
  static const ShadcnColors darkFallback = ShadcnColors(
    brightness: Brightness.dark,
    background: Color(0xFF0A0A0A),
    foreground: Color(0xFFFAFAFA),
    card: Color(0xFF171717),
    cardForeground: Color(0xFFFAFAFA),
    popover: Color(0xFF171717),
    popoverForeground: Color(0xFFFAFAFA),
    primary: Color(0xFFE5E5E5),
    primaryForeground: Color(0xFF171717),
    secondary: Color(0xFF262626),
    secondaryForeground: Color(0xFFFAFAFA),
    muted: Color(0xFF262626),
    mutedForeground: Color(0xFFA1A1A1),
    accent: Color(0xFF262626),
    accentForeground: Color(0xFFFAFAFA),
    destructive: Color(0xFFFF6467),
    destructiveForeground: Color(0xFFFFFFFF),
    border: Color(0x1AFFFFFF),
    input: Color(0x26FFFFFF),
    ring: Color(0xFF737373),
    chart1: Color(0xFF1447E6),
    chart2: Color(0xFF00BC7D),
    chart3: Color(0xFFFE9A00),
    chart4: Color(0xFFAD46FF),
    chart5: Color(0xFFFF2056),
    sidebar: Color(0xFF171717),
    sidebarForeground: Color(0xFFFAFAFA),
    sidebarPrimary: Color(0xFF1447E6),
    sidebarPrimaryForeground: Color(0xFFFAFAFA),
    sidebarAccent: Color(0xFF262626),
    sidebarAccentForeground: Color(0xFFFAFAFA),
    sidebarBorder: Color(0x1AFFFFFF),
    sidebarRing: Color(0xFF737373),
  );
}

/// Reference to a global color token. Stored in user-owned theme files so a
/// customised component still follows preset switches; resolved at build.
enum ColorRef {
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
  destructiveForeground,
  border,
  input,
  ring,
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
  sidebarRing;

  /// Resolves this reference against [colors].
  Color resolve(ShadcnColors colors) {
    switch (this) {
      case ColorRef.background:
        return colors.background;
      case ColorRef.foreground:
        return colors.foreground;
      case ColorRef.card:
        return colors.card;
      case ColorRef.cardForeground:
        return colors.cardForeground;
      case ColorRef.popover:
        return colors.popover;
      case ColorRef.popoverForeground:
        return colors.popoverForeground;
      case ColorRef.primary:
        return colors.primary;
      case ColorRef.primaryForeground:
        return colors.primaryForeground;
      case ColorRef.secondary:
        return colors.secondary;
      case ColorRef.secondaryForeground:
        return colors.secondaryForeground;
      case ColorRef.muted:
        return colors.muted;
      case ColorRef.mutedForeground:
        return colors.mutedForeground;
      case ColorRef.accent:
        return colors.accent;
      case ColorRef.accentForeground:
        return colors.accentForeground;
      case ColorRef.destructive:
        return colors.destructive;
      case ColorRef.destructiveForeground:
        return colors.destructiveForeground;
      case ColorRef.border:
        return colors.border;
      case ColorRef.input:
        return colors.input;
      case ColorRef.ring:
        return colors.ring;
      case ColorRef.chart1:
        return colors.chart1;
      case ColorRef.chart2:
        return colors.chart2;
      case ColorRef.chart3:
        return colors.chart3;
      case ColorRef.chart4:
        return colors.chart4;
      case ColorRef.chart5:
        return colors.chart5;
      case ColorRef.sidebar:
        return colors.sidebar;
      case ColorRef.sidebarForeground:
        return colors.sidebarForeground;
      case ColorRef.sidebarPrimary:
        return colors.sidebarPrimary;
      case ColorRef.sidebarPrimaryForeground:
        return colors.sidebarPrimaryForeground;
      case ColorRef.sidebarAccent:
        return colors.sidebarAccent;
      case ColorRef.sidebarAccentForeground:
        return colors.sidebarAccentForeground;
      case ColorRef.sidebarBorder:
        return colors.sidebarBorder;
      case ColorRef.sidebarRing:
        return colors.sidebarRing;
    }
  }
}

/// A color that is either a literal or a token reference.
/// Const-constructible so user-owned files stay values-only and Studio can
/// rewrite them deterministically.
sealed class ThemedColor {
  const ThemedColor();
  const factory ThemedColor.value(Color color) = LiteralColor;
  const factory ThemedColor.ref(ColorRef ref, {double alpha}) = RefColor;

  /// Resolves to a concrete color against [colors].
  Color resolve(ShadcnColors colors);
}

/// A fixed color. Ignores preset switches.
final class LiteralColor extends ThemedColor {
  const LiteralColor(this.color);
  final Color color;
  @override
  Color resolve(ShadcnColors colors) => color;
  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is LiteralColor && other.color == color;
  @override
  int get hashCode => color.hashCode;
}

/// A token reference with an alpha multiplier. Alpha multiplies (never
/// replaces) the token's own alpha, so alpha-bearing tokens such as a
/// 10%-alpha dark border stay correct.
final class RefColor extends ThemedColor {
  const RefColor(this.ref, {this.alpha = 1.0});
  final ColorRef ref;
  final double alpha;
  @override
  Color resolve(ShadcnColors colors) {
    final base = ref.resolve(colors);
    if (alpha == 1.0) return base;
    return base.withValues(alpha: (base.a * alpha).clamp(0.0, 1.0));
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RefColor && other.ref == ref && other.alpha == alpha;
  @override
  int get hashCode => Object.hash(ref, alpha);
}

/// Merge contract for resolver slices. The receiver is the higher-priority
/// leg and wins; [fallback] (the lower-priority leg) fills only null cells.
/// Constraining the resolver to this interface makes override-wins
/// structural instead of a caller-supplied lambda.
abstract interface class Mergeable<S> {
  /// Merges [fallback] under this value; this value's cells win.
  S merge(S? fallback);
}

/// Const per-state value. Implements [WidgetStateProperty] so it plugs into
/// Flutter state APIs, but carries only data (nullable per state) — no
/// closures — so every layer including user files stays const-constructible.
class StateValue<T>
    implements WidgetStateProperty<T?>, Mergeable<StateValue<T>> {
  const StateValue({
    this.rest,
    this.hovered,
    this.pressed,
    this.focused,
    this.selected,
    this.disabled,
  });

  final T? rest;
  final T? hovered;
  final T? pressed;
  final T? focused;
  final T? selected;
  final T? disabled;

  /// Precedence: disabled > pressed > hovered > focused > selected > rest.
  /// Each state falls back to [rest] (never to another state).
  @override
  T? resolve(Set<WidgetState> states) {
    if (states.contains(WidgetState.disabled)) return disabled ?? rest;
    if (states.contains(WidgetState.pressed)) return pressed ?? rest;
    if (states.contains(WidgetState.hovered)) return hovered ?? rest;
    if (states.contains(WidgetState.focused)) return focused ?? rest;
    if (states.contains(WidgetState.selected)) return selected ?? rest;
    return rest;
  }

  /// First-non-null-wins per state field: keeps `this` value unless null,
  /// then takes [fallback]. Call on the higher-priority leg so overrides win.
  @override
  StateValue<T> merge(StateValue<T>? fallback) {
    if (fallback == null) return this;
    return StateValue<T>(
      rest: rest ?? fallback.rest,
      hovered: hovered ?? fallback.hovered,
      pressed: pressed ?? fallback.pressed,
      focused: focused ?? fallback.focused,
      selected: selected ?? fallback.selected,
      disabled: disabled ?? fallback.disabled,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is StateValue<T> &&
        other.rest == rest &&
        other.hovered == hovered &&
        other.pressed == pressed &&
        other.focused == focused &&
        other.selected == selected &&
        other.disabled == disabled;
  }

  @override
  int get hashCode =>
      Object.hash(rest, hovered, pressed, focused, selected, disabled);
}
