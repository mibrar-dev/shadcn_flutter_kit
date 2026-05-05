part of '../../theme.dart';

/// Spacing scale for consistent padding/margins.
class SpacingScale {
  /// Base spacing unit.
  final double base;

  const SpacingScale(this.base);

/// Stores `xs` state/configuration for this implementation.
  double get xs => base;
/// Stores `sm` state/configuration for this implementation.
  double get sm => base * 2;
/// Stores `md` state/configuration for this implementation.
  double get md => base * 3;
/// Stores `lg` state/configuration for this implementation.
  double get lg => base * 4;
/// Stores `xl` state/configuration for this implementation.
  double get xl => base * 6;
/// Stores `xxl` state/configuration for this implementation.
  double get xxl => base * 8;

/// Executes `copyWith` behavior for this component/composite.
  SpacingScale copyWith({double? base}) => SpacingScale(base ?? this.base);

/// Executes `lerp` behavior for this component/composite.
  static SpacingScale lerp(SpacingScale a, SpacingScale b, double t) {
    return SpacingScale(lerpDouble(a.base, b.base, t)!);
  }

  @override
/// Executes `operator ==` behavior for this component/composite.
  bool operator ==(Object other) =>
      identical(this, other) || other is SpacingScale && other.base == base;

  @override
/// Stores `hashCode` state/configuration for this implementation.
  int get hashCode => base.hashCode;
}

/// Letter-spacing scale for typography tracking.
class TrackingScale {
/// Stores `normal` state/configuration for this implementation.
  final double normal;

  const TrackingScale({this.normal = 0});

/// Executes `copyWith` behavior for this component/composite.
  TrackingScale copyWith({double? normal}) =>
      TrackingScale(normal: normal ?? this.normal);

/// Executes `lerp` behavior for this component/composite.
  static TrackingScale lerp(TrackingScale a, TrackingScale b, double t) {
    return TrackingScale(normal: lerpDouble(a.normal, b.normal, t)!);
  }

  @override
/// Executes `operator ==` behavior for this component/composite.
  bool operator ==(Object other) =>
/// Creates a `identical` instance.
      identical(this, other) ||
      other is TrackingScale && other.normal == normal;

  @override
/// Stores `hashCode` state/configuration for this implementation.
  int get hashCode => normal.hashCode;
}

/// Shadow scale tokens for elevation styling.
class ShadowScale {
/// Stores `shadow2xs` state/configuration for this implementation.
  final List<BoxShadow> shadow2xs;
/// Stores `shadowXs` state/configuration for this implementation.
  final List<BoxShadow> shadowXs;
/// Stores `shadowSm` state/configuration for this implementation.
  final List<BoxShadow> shadowSm;
/// Stores `shadow` state/configuration for this implementation.
  final List<BoxShadow> shadow;
/// Stores `shadowMd` state/configuration for this implementation.
  final List<BoxShadow> shadowMd;
/// Stores `shadowLg` state/configuration for this implementation.
  final List<BoxShadow> shadowLg;
/// Stores `shadowXl` state/configuration for this implementation.
  final List<BoxShadow> shadowXl;
/// Stores `shadow2xl` state/configuration for this implementation.
  final List<BoxShadow> shadow2xl;

/// Creates a `ShadowScale` instance.
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

/// Creates a `ShadowScale` instance.
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

/// Executes `lerp` behavior for this component/composite.
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
/// Executes `operator ==` behavior for this component/composite.
  bool operator ==(Object other) =>
/// Creates a `identical` instance.
      identical(this, other) ||
      other is ShadowScale &&
/// Creates a `listEquals` instance.
          listEquals(other.shadow2xs, shadow2xs) &&
/// Creates a `listEquals` instance.
          listEquals(other.shadowXs, shadowXs) &&
/// Creates a `listEquals` instance.
          listEquals(other.shadowSm, shadowSm) &&
/// Creates a `listEquals` instance.
          listEquals(other.shadow, shadow) &&
/// Creates a `listEquals` instance.
          listEquals(other.shadowMd, shadowMd) &&
/// Creates a `listEquals` instance.
          listEquals(other.shadowLg, shadowLg) &&
/// Creates a `listEquals` instance.
          listEquals(other.shadowXl, shadowXl) &&
          listEquals(other.shadow2xl, shadow2xl);

  @override
  int get hashCode => Object.hash(
/// Creates a `Object.hashAll` instance.
    Object.hashAll(shadow2xs),
/// Creates a `Object.hashAll` instance.
    Object.hashAll(shadowXs),
/// Creates a `Object.hashAll` instance.
    Object.hashAll(shadowSm),
/// Creates a `Object.hashAll` instance.
    Object.hashAll(shadow),
/// Creates a `Object.hashAll` instance.
    Object.hashAll(shadowMd),
/// Creates a `Object.hashAll` instance.
    Object.hashAll(shadowLg),
/// Creates a `Object.hashAll` instance.
    Object.hashAll(shadowXl),
/// Creates a `Object.hashAll` instance.
    Object.hashAll(shadow2xl),
  );
}
