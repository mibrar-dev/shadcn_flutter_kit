import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// Spacing scale derived from one base unit (preset `spacing.base`).
class SpacingScale {
  const SpacingScale(this.base);

  /// Base spacing unit.
  final double base;

  double get xs => base;
  double get sm => base * 2;
  double get md => base * 3;
  double get lg => base * 4;
  double get xl => base * 6;
  double get xxl => base * 8;

  SpacingScale copyWith({double? base}) => SpacingScale(base ?? this.base);

  static SpacingScale lerp(SpacingScale a, SpacingScale b, double t) {
    return SpacingScale(lerpDouble(a.base, b.base, t)!);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is SpacingScale && other.base == base;
  @override
  int get hashCode => base.hashCode;
}

/// Letter-spacing scale (preset `tracking.*`).
class TrackingScale {
  const TrackingScale({this.normal = 0, this.tight, this.wide});

  /// Default letter spacing.
  final double normal;

  /// Optional tighter variant.
  final double? tight;

  /// Optional wider variant.
  final double? wide;

  TrackingScale copyWith({
    double? normal,
    double? Function()? tight,
    double? Function()? wide,
  }) {
    return TrackingScale(
      normal: normal ?? this.normal,
      tight: tight == null ? this.tight : tight(),
      wide: wide == null ? this.wide : wide(),
    );
  }

  static TrackingScale lerp(TrackingScale a, TrackingScale b, double t) {
    return TrackingScale(
      normal: lerpDouble(a.normal, b.normal, t)!,
      tight: _lerpOpt(a.tight, b.tight, t),
      wide: _lerpOpt(a.wide, b.wide, t),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TrackingScale &&
          other.normal == normal &&
          other.tight == tight &&
          other.wide == wide;
  @override
  int get hashCode => Object.hash(normal, tight, wide);
}

double? _lerpOpt(double? a, double? b, double t) {
  if (a == null) return b;
  if (b == null) return a;
  return lerpDouble(a, b, t);
}

/// Shadow scale: 8 elevation sizes, each a list of box shadows.
class ShadowScale {
  const ShadowScale({
    required this.shadow2xs,
    required this.shadowXs,
    required this.shadowSm,
    required this.shadow,
    required this.shadowMd,
    required this.shadowLg,
    required this.shadowXl,
    required this.shadow2xl,
  });

  final List<BoxShadow> shadow2xs;
  final List<BoxShadow> shadowXs;
  final List<BoxShadow> shadowSm;
  final List<BoxShadow> shadow;
  final List<BoxShadow> shadowMd;
  final List<BoxShadow> shadowLg;
  final List<BoxShadow> shadowXl;
  final List<BoxShadow> shadow2xl;

  /// Builds the 8 sizes from base atoms using the tweakcn formula: one
  /// ambient layer per size (from [offsetX], [offsetY], [blur], [spread])
  /// plus, for sm..xl, one detail layer with ABSOLUTE geometry
  /// (`Offset(offsetX, y)`, blur `b`, `spread - 1`), so small atoms such as
  /// a shadcn default base (offsetY 1, blur 3) can never go negative.
  /// Alpha ratios follow tweakcn: 0.5 for 2xs/xs, 1.0 for sm..xl (ambient
  /// and detail alike), 2.5 for 2xl, all relative to [opacity]; rgb channels
  /// come from [color] unchanged. Geometry reproduces [defaultShadowScale]
  /// exactly with default atoms; alphas land within 1/255 of the old
  /// 8-bit literals (byte rounding: 38/2 -> 19 vs 0x12, 38*2.5 -> 96
  /// vs 0x61 — halving/doubling an even byte cannot hit odd remainders).
  factory ShadowScale.derive({
    Color color = const Color(0xFF000000),
    double opacity = 0.15,
    double blur = 25.5,
    double spread = -30.0,
    double offsetX = 20.5,
    double offsetY = 16.5,
  }) {
    BoxShadow ambient(double multiplier) => BoxShadow(
      offset: Offset(offsetX, offsetY),
      blurRadius: blur,
      spreadRadius: spread,
      color: _scaledAlpha(color, opacity, multiplier),
    );
    BoxShadow detail(double y, double b) => BoxShadow(
      offset: Offset(offsetX, y),
      blurRadius: b,
      spreadRadius: spread - 1.0,
      color: _scaledAlpha(color, opacity, 1.0),
    );
    return ShadowScale(
      shadow2xs: [ambient(0.5)],
      shadowXs: [ambient(0.5)],
      shadowSm: [ambient(1.0), detail(1, 2)],
      shadow: [ambient(1.0), detail(1, 2)],
      shadowMd: [ambient(1.0), detail(2, 4)],
      shadowLg: [ambient(1.0), detail(4, 6)],
      shadowXl: [ambient(1.0), detail(8, 10)],
      shadow2xl: [ambient(2.5)],
    );
  }

  ShadowScale copyWith({
    List<BoxShadow>? shadow2xs,
    List<BoxShadow>? shadowXs,
    List<BoxShadow>? shadowSm,
    List<BoxShadow>? shadow,
    List<BoxShadow>? shadowMd,
    List<BoxShadow>? shadowLg,
    List<BoxShadow>? shadowXl,
    List<BoxShadow>? shadow2xl,
  }) {
    return ShadowScale(
      shadow2xs: shadow2xs ?? this.shadow2xs,
      shadowXs: shadowXs ?? this.shadowXs,
      shadowSm: shadowSm ?? this.shadowSm,
      shadow: shadow ?? this.shadow,
      shadowMd: shadowMd ?? this.shadowMd,
      shadowLg: shadowLg ?? this.shadowLg,
      shadowXl: shadowXl ?? this.shadowXl,
      shadow2xl: shadow2xl ?? this.shadow2xl,
    );
  }

  static ShadowScale lerp(ShadowScale a, ShadowScale b, double t) {
    return ShadowScale(
      shadow2xs: BoxShadow.lerpList(a.shadow2xs, b.shadow2xs, t) ?? const [],
      shadowXs: BoxShadow.lerpList(a.shadowXs, b.shadowXs, t) ?? const [],
      shadowSm: BoxShadow.lerpList(a.shadowSm, b.shadowSm, t) ?? const [],
      shadow: BoxShadow.lerpList(a.shadow, b.shadow, t) ?? const [],
      shadowMd: BoxShadow.lerpList(a.shadowMd, b.shadowMd, t) ?? const [],
      shadowLg: BoxShadow.lerpList(a.shadowLg, b.shadowLg, t) ?? const [],
      shadowXl: BoxShadow.lerpList(a.shadowXl, b.shadowXl, t) ?? const [],
      shadow2xl: BoxShadow.lerpList(a.shadow2xl, b.shadow2xl, t) ?? const [],
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ShadowScale &&
        listEquals(other.shadow2xs, shadow2xs) &&
        listEquals(other.shadowXs, shadowXs) &&
        listEquals(other.shadowSm, shadowSm) &&
        listEquals(other.shadow, shadow) &&
        listEquals(other.shadowMd, shadowMd) &&
        listEquals(other.shadowLg, shadowLg) &&
        listEquals(other.shadowXl, shadowXl) &&
        listEquals(other.shadow2xl, shadow2xl);
  }

  @override
  int get hashCode => Object.hash(
    Object.hashAll(shadow2xs),
    Object.hashAll(shadowXs),
    Object.hashAll(shadowSm),
    Object.hashAll(shadow),
    Object.hashAll(shadowMd),
    Object.hashAll(shadowLg),
    Object.hashAll(shadowXl),
    Object.hashAll(shadow2xl),
  );
}

/// Scales [color]'s alpha by `opacity * multiplier`, rounding to the nearest
/// alpha byte (old 8-bit literals land within 1/255 — see [ShadowScale.derive]).
Color _scaledAlpha(Color color, double opacity, double multiplier) {
  final byte = (color.a * opacity * 255 * multiplier).round().clamp(0, 255);
  return Color.fromARGB(
    byte,
    (color.r * 255).round().clamp(0, 255),
    (color.g * 255).round().clamp(0, 255),
    (color.b * 255).round().clamp(0, 255),
  );
}

/// Today's hardcoded `ThemeData` default shadows, transcribed verbatim.
/// Reference for [ShadowScale.derive]: default atoms reproduce its geometry
/// exactly and its alphas within 1/255.
const ShadowScale defaultShadowScale = ShadowScale(
  shadow2xs: [
    BoxShadow(
      offset: Offset(20.5, 16.5),
      blurRadius: 25.5,
      spreadRadius: -30,
      color: Color(0x12000000),
    ),
  ],
  shadowXs: [
    BoxShadow(
      offset: Offset(20.5, 16.5),
      blurRadius: 25.5,
      spreadRadius: -30,
      color: Color(0x12000000),
    ),
  ],
  shadowSm: [
    BoxShadow(
      offset: Offset(20.5, 16.5),
      blurRadius: 25.5,
      spreadRadius: -30,
      color: Color(0x26000000),
    ),
    BoxShadow(
      offset: Offset(20.5, 1),
      blurRadius: 2,
      spreadRadius: -31,
      color: Color(0x26000000),
    ),
  ],
  shadow: [
    BoxShadow(
      offset: Offset(20.5, 16.5),
      blurRadius: 25.5,
      spreadRadius: -30,
      color: Color(0x26000000),
    ),
    BoxShadow(
      offset: Offset(20.5, 1),
      blurRadius: 2,
      spreadRadius: -31,
      color: Color(0x26000000),
    ),
  ],
  shadowMd: [
    BoxShadow(
      offset: Offset(20.5, 16.5),
      blurRadius: 25.5,
      spreadRadius: -30,
      color: Color(0x26000000),
    ),
    BoxShadow(
      offset: Offset(20.5, 2),
      blurRadius: 4,
      spreadRadius: -31,
      color: Color(0x26000000),
    ),
  ],
  shadowLg: [
    BoxShadow(
      offset: Offset(20.5, 16.5),
      blurRadius: 25.5,
      spreadRadius: -30,
      color: Color(0x26000000),
    ),
    BoxShadow(
      offset: Offset(20.5, 4),
      blurRadius: 6,
      spreadRadius: -31,
      color: Color(0x26000000),
    ),
  ],
  shadowXl: [
    BoxShadow(
      offset: Offset(20.5, 16.5),
      blurRadius: 25.5,
      spreadRadius: -30,
      color: Color(0x26000000),
    ),
    BoxShadow(
      offset: Offset(20.5, 8),
      blurRadius: 10,
      spreadRadius: -31,
      color: Color(0x26000000),
    ),
  ],
  shadow2xl: [
    BoxShadow(
      offset: Offset(20.5, 16.5),
      blurRadius: 25.5,
      spreadRadius: -30,
      color: Color(0x61000000),
    ),
  ],
);

/// Mode-independent font families (preset `fontSans/Serif/Mono`, top-level
/// per QA P1-D; no per-brightness fonts). Nullable; null falls back to the
/// bundled default at build. `fontSerif` is stored but currently unwired
/// (no serif slot in [Typography]; open question in P2B_THEME.md).
class ShadcnFonts {
  const ShadcnFonts({this.fontSans, this.fontSerif, this.fontMono});
  static const ShadcnFonts empty = ShadcnFonts();

  /// Body/UI family list, e.g. `"Inter, sans-serif"`.
  final String? fontSans;

  /// Serif option family list.
  final String? fontSerif;

  /// Code family list.
  final String? fontMono;

  ShadcnFonts copyWith({
    String? Function()? fontSans,
    String? Function()? fontSerif,
    String? Function()? fontMono,
  }) {
    return ShadcnFonts(
      fontSans: fontSans == null ? this.fontSans : fontSans(),
      fontSerif: fontSerif == null ? this.fontSerif : fontSerif(),
      fontMono: fontMono == null ? this.fontMono : fontMono(),
    );
  }

  /// Fonts are strings: lerp steps at t = 0.5.
  static ShadcnFonts lerp(ShadcnFonts a, ShadcnFonts b, double t) =>
      t < 0.5 ? a : b;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ShadcnFonts &&
          other.fontSans == fontSans &&
          other.fontSerif == fontSerif &&
          other.fontMono == fontMono;
  @override
  int get hashCode => Object.hash(fontSans, fontSerif, fontMono);
}

/// Non-color tokens for one brightness.
class ShadcnTokens {
  const ShadcnTokens({
    this.radius = 0.5,
    this.spacingBase = 4.0,
    this.trackingNormal = 0,
    this.trackingTight,
    this.trackingWide,
    this.shadows = defaultShadowScale,
  });

  /// Unitless radius factor: the preset `radius` rem number (e.g. 0.625).
  /// `radiusLg` is its px value (`radius * 16`); `sm`/`md` step down
  /// 4/2 px and `xl` steps up 4 px from `lg` (shadcn v4), clamped at 0.
  final double radius;

  /// Base spacing unit (preset `spacing.base`).
  final double spacingBase;

  /// Default letter spacing (preset `tracking.normal`).
  final double trackingNormal;

  /// Optional tighter tracking.
  final double? trackingTight;

  /// Optional wider tracking.
  final double? trackingWide;

  /// Elevation scale.
  final ShadowScale shadows;

  SpacingScale get spacing => SpacingScale(spacingBase);
  TrackingScale get tracking => TrackingScale(
    normal: trackingNormal,
    tight: trackingTight,
    wide: trackingWide,
  );

  ShadcnTokens copyWith({
    double? radius,
    double? spacingBase,
    double? trackingNormal,
    double? Function()? trackingTight,
    double? Function()? trackingWide,
    ShadowScale? shadows,
  }) {
    return ShadcnTokens(
      radius: radius ?? this.radius,
      spacingBase: spacingBase ?? this.spacingBase,
      trackingNormal: trackingNormal ?? this.trackingNormal,
      trackingTight: trackingTight == null
          ? this.trackingTight
          : trackingTight(),
      trackingWide: trackingWide == null ? this.trackingWide : trackingWide(),
      shadows: shadows ?? this.shadows,
    );
  }

  static ShadcnTokens lerp(ShadcnTokens a, ShadcnTokens b, double t) {
    return ShadcnTokens(
      radius: lerpDouble(a.radius, b.radius, t)!,
      spacingBase: lerpDouble(a.spacingBase, b.spacingBase, t)!,
      trackingNormal: lerpDouble(a.trackingNormal, b.trackingNormal, t)!,
      trackingTight: _lerpOpt(a.trackingTight, b.trackingTight, t),
      trackingWide: _lerpOpt(a.trackingWide, b.trackingWide, t),
      shadows: ShadowScale.lerp(a.shadows, b.shadows, t),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ShadcnTokens &&
          other.radius == radius &&
          other.spacingBase == spacingBase &&
          other.trackingNormal == trackingNormal &&
          other.trackingTight == trackingTight &&
          other.trackingWide == trackingWide &&
          other.shadows == shadows;
  @override
  int get hashCode => Object.hash(
    radius,
    spacingBase,
    trackingNormal,
    trackingTight,
    trackingWide,
    shadows,
  );
}
