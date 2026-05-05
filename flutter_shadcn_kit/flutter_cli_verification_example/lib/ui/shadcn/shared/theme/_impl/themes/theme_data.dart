part of '../../theme.dart';

/// ThemeData defines a reusable type for this registry module.
class ThemeData {
  /// The color scheme for this theme.
  final ColorScheme colorScheme;

  /// The typography settings for this theme.
  final Typography typography;

  /// Base radius multiplier for border radius calculations.
  final double radius;

  /// Scale factor for sizes and spacing.
  final double scaling;

  /// Density tokens for container/content padding and inter-item gaps.
  final Density density;

  /// Spacing scale tokens for padding/margins.
  final SpacingScale spacing;

  /// Letter-spacing scale for typography tracking.
  final TrackingScale tracking;

  /// Shadow scale tokens for elevation styling.
  final ShadowScale shadows;

/// Stores `_platform` state/configuration for this implementation.
  final TargetPlatform? _platform;

  /// Icon theme properties defining icon sizes across different scales.
  final IconThemeProperties iconTheme;

  /// Default opacity for surface overlays (0.0 to 1.0).
  final double? surfaceOpacity;

  /// Default blur radius for surface effects.
  final double? surfaceBlur;

  /// Default haptic/sound feedback toggle for interactive controls.
  final bool? enableFeedback;

  /// Creates a [ThemeData] with light color scheme.
  ///
  /// Parameters:
  /// - [colorScheme] (`ColorScheme`, default: light colors): Color palette.
  /// - [radius] (`double`, default: 0.5): Base radius multiplier.
  /// - [scaling] (`double`, default: 1): Size scaling factor.
  /// - [typography] (`Typography`, default: Geist): Typography settings.
  /// - [iconTheme] (`IconThemeProperties`, default: standard sizes): Icon theme.
  /// - [platform] (`TargetPlatform?`, optional): Target platform override.
  /// - [surfaceOpacity] (`double?`, optional): Surface overlay opacity.
  /// - [surfaceBlur] (`double?`, optional): Surface blur radius.
  const ThemeData({
    this.colorScheme = ColorSchemes.lightDefaultColor,
    this.radius = 0.5,
    this.scaling = 1,
    this.density = Density.defaultDensity,
    this.spacing = const SpacingScale(4.0),
    this.tracking = const TrackingScale(normal: 0),
    this.shadows = const ShadowScale(
      shadow2xs: [
/// Creates a `BoxShadow` instance.
        BoxShadow(
          offset: Offset(20.5, 16.5),
          blurRadius: 25.5,
          spreadRadius: -30,
          color: Color(0x12000000),
        ),
      ],
      shadowXs: [
/// Creates a `BoxShadow` instance.
        BoxShadow(
          offset: Offset(20.5, 16.5),
          blurRadius: 25.5,
          spreadRadius: -30,
          color: Color(0x12000000),
        ),
      ],
      shadowSm: [
/// Creates a `BoxShadow` instance.
        BoxShadow(
          offset: Offset(20.5, 16.5),
          blurRadius: 25.5,
          spreadRadius: -30,
          color: Color(0x26000000),
        ),
/// Creates a `BoxShadow` instance.
        BoxShadow(
          offset: Offset(20.5, 1),
          blurRadius: 2,
          spreadRadius: -31,
          color: Color(0x26000000),
        ),
      ],
      shadow: [
/// Creates a `BoxShadow` instance.
        BoxShadow(
          offset: Offset(20.5, 16.5),
          blurRadius: 25.5,
          spreadRadius: -30,
          color: Color(0x26000000),
        ),
/// Creates a `BoxShadow` instance.
        BoxShadow(
          offset: Offset(20.5, 1),
          blurRadius: 2,
          spreadRadius: -31,
          color: Color(0x26000000),
        ),
      ],
      shadowMd: [
/// Creates a `BoxShadow` instance.
        BoxShadow(
          offset: Offset(20.5, 16.5),
          blurRadius: 25.5,
          spreadRadius: -30,
          color: Color(0x26000000),
        ),
/// Creates a `BoxShadow` instance.
        BoxShadow(
          offset: Offset(20.5, 2),
          blurRadius: 4,
          spreadRadius: -31,
          color: Color(0x26000000),
        ),
      ],
      shadowLg: [
/// Creates a `BoxShadow` instance.
        BoxShadow(
          offset: Offset(20.5, 16.5),
          blurRadius: 25.5,
          spreadRadius: -30,
          color: Color(0x26000000),
        ),
/// Creates a `BoxShadow` instance.
        BoxShadow(
          offset: Offset(20.5, 4),
          blurRadius: 6,
          spreadRadius: -31,
          color: Color(0x26000000),
        ),
      ],
      shadowXl: [
/// Creates a `BoxShadow` instance.
        BoxShadow(
          offset: Offset(20.5, 16.5),
          blurRadius: 25.5,
          spreadRadius: -30,
          color: Color(0x26000000),
        ),
/// Creates a `BoxShadow` instance.
        BoxShadow(
          offset: Offset(20.5, 8),
          blurRadius: 10,
          spreadRadius: -31,
          color: Color(0x26000000),
        ),
      ],
      shadow2xl: [
/// Creates a `BoxShadow` instance.
        BoxShadow(
          offset: Offset(20.5, 16.5),
          blurRadius: 25.5,
          spreadRadius: -30,
          color: Color(0x61000000),
        ),
      ],
    ),
    this.typography = const Typography.geist(),
    this.iconTheme = const IconThemeProperties(),
    TargetPlatform? platform,
    this.surfaceOpacity,
    this.surfaceBlur,
    this.enableFeedback,
  }) : _platform = platform;

  /// Creates a [ThemeData] with dark color scheme.
  ///
  /// Parameters:
  /// - [colorScheme] (`ColorScheme`, default: dark colors): Color palette.
  /// - [radius] (`double`, default: 0.5): Base radius multiplier.
  /// - [scaling] (`double`, default: 1): Size scaling factor.
  /// - [typography] (`Typography`, default: Geist): Typography settings.
  /// - [iconTheme] (`IconThemeProperties`, default: standard sizes): Icon theme.
  /// - [platform] (`TargetPlatform?`, optional): Target platform override.
  /// - [surfaceOpacity] (`double?`, optional): Surface overlay opacity.
  /// - [surfaceBlur] (`double?`, optional): Surface blur radius.
  const ThemeData.dark({
    this.colorScheme = ColorSchemes.darkDefaultColor,
    this.radius = 0.5,
    this.scaling = 1,
    this.density = Density.defaultDensity,
    this.spacing = const SpacingScale(4.0),
    this.tracking = const TrackingScale(normal: 0),
    this.shadows = const ShadowScale(
      shadow2xs: [
/// Creates a `BoxShadow` instance.
        BoxShadow(
          offset: Offset(20.5, 16.5),
          blurRadius: 25.5,
          spreadRadius: -30,
          color: Color(0x12000000),
        ),
      ],
      shadowXs: [
/// Creates a `BoxShadow` instance.
        BoxShadow(
          offset: Offset(20.5, 16.5),
          blurRadius: 25.5,
          spreadRadius: -30,
          color: Color(0x12000000),
        ),
      ],
      shadowSm: [
/// Creates a `BoxShadow` instance.
        BoxShadow(
          offset: Offset(20.5, 16.5),
          blurRadius: 25.5,
          spreadRadius: -30,
          color: Color(0x26000000),
        ),
/// Creates a `BoxShadow` instance.
        BoxShadow(
          offset: Offset(20.5, 1),
          blurRadius: 2,
          spreadRadius: -31,
          color: Color(0x26000000),
        ),
      ],
      shadow: [
/// Creates a `BoxShadow` instance.
        BoxShadow(
          offset: Offset(20.5, 16.5),
          blurRadius: 25.5,
          spreadRadius: -30,
          color: Color(0x26000000),
        ),
/// Creates a `BoxShadow` instance.
        BoxShadow(
          offset: Offset(20.5, 1),
          blurRadius: 2,
          spreadRadius: -31,
          color: Color(0x26000000),
        ),
      ],
      shadowMd: [
/// Creates a `BoxShadow` instance.
        BoxShadow(
          offset: Offset(20.5, 16.5),
          blurRadius: 25.5,
          spreadRadius: -30,
          color: Color(0x26000000),
        ),
/// Creates a `BoxShadow` instance.
        BoxShadow(
          offset: Offset(20.5, 2),
          blurRadius: 4,
          spreadRadius: -31,
          color: Color(0x26000000),
        ),
      ],
      shadowLg: [
/// Creates a `BoxShadow` instance.
        BoxShadow(
          offset: Offset(20.5, 16.5),
          blurRadius: 25.5,
          spreadRadius: -30,
          color: Color(0x26000000),
        ),
/// Creates a `BoxShadow` instance.
        BoxShadow(
          offset: Offset(20.5, 4),
          blurRadius: 6,
          spreadRadius: -31,
          color: Color(0x26000000),
        ),
      ],
      shadowXl: [
/// Creates a `BoxShadow` instance.
        BoxShadow(
          offset: Offset(20.5, 16.5),
          blurRadius: 25.5,
          spreadRadius: -30,
          color: Color(0x26000000),
        ),
/// Creates a `BoxShadow` instance.
        BoxShadow(
          offset: Offset(20.5, 8),
          blurRadius: 10,
          spreadRadius: -31,
          color: Color(0x26000000),
        ),
      ],
      shadow2xl: [
/// Creates a `BoxShadow` instance.
        BoxShadow(
          offset: Offset(20.5, 16.5),
          blurRadius: 25.5,
          spreadRadius: -30,
          color: Color(0x61000000),
        ),
      ],
    ),
    this.typography = const Typography.geist(),
    this.iconTheme = const IconThemeProperties(),
    TargetPlatform? platform,
    this.surfaceOpacity,
    this.surfaceBlur,
    this.enableFeedback,
  }) : _platform = platform;

  /// The current platform.
  TargetPlatform get platform => _platform ?? defaultTargetPlatform;

  /// The specified platform, or null if not overridden.
  TargetPlatform? get specifiedPlatform => _platform;

  /// At normal radius, the scaled radius is 24
  double get radiusXxl => radius * 24;

  /// At normal radius, the scaled radius is 20
  double get radiusXl => radius * 20;

  /// At normal radius, the scaled radius is 16
  double get radiusLg => radius * 16;

  /// At normal radius, the scaled radius is 12
  double get radiusMd => radius * 12;

  /// At normal radius, the scaled radius is 8
  double get radiusSm => radius * 8;

  /// At normal radius, the scaled radius is 4
  double get radiusXs => radius * 4;

  /// Creates a circular border radius using [radiusXxl].
  BorderRadius get borderRadiusXxl => BorderRadius.circular(radiusXxl);

  /// Creates a circular border radius using [radiusXl].
  BorderRadius get borderRadiusXl => BorderRadius.circular(radiusXl);

  /// Creates a circular border radius using [radiusLg].
  BorderRadius get borderRadiusLg => BorderRadius.circular(radiusLg);

  /// Creates a circular border radius using [radiusMd].
  BorderRadius get borderRadiusMd => BorderRadius.circular(radiusMd);

  /// Creates a circular border radius using [radiusSm].
  BorderRadius get borderRadiusSm => BorderRadius.circular(radiusSm);

  /// Creates a circular border radius using [radiusXs].
  BorderRadius get borderRadiusXs => BorderRadius.circular(radiusXs);

  /// Creates a circular radius using [radiusXxl].
  Radius get radiusXxlRadius => Radius.circular(radiusXxl);

  /// Creates a circular radius using [radiusXl].
  Radius get radiusXlRadius => Radius.circular(radiusXl);

  /// Creates a circular radius using [radiusLg].
  Radius get radiusLgRadius => Radius.circular(radiusLg);

  /// Creates a circular radius using [radiusMd].
  Radius get radiusMdRadius => Radius.circular(radiusMd);

  /// Creates a circular radius using [radiusSm].
  Radius get radiusSmRadius => Radius.circular(radiusSm);

  /// Creates a circular radius using [radiusXs].
  Radius get radiusXsRadius => Radius.circular(radiusXs);

  /// Gets the brightness (light or dark) from the color scheme.
  Brightness get brightness => colorScheme.brightness;

  /// Creates a copy of this theme with specified properties overridden.
  ///
  /// All parameters are optional getters that provide new values when present.
  ///
  /// Returns: `ThemeData` — a new theme with updated values.
  ThemeData copyWith({
    ValueGetter<ColorScheme>? colorScheme,
    ValueGetter<double>? radius,
    ValueGetter<Typography>? typography,
    ValueGetter<TargetPlatform>? platform,
    ValueGetter<double>? scaling,
    ValueGetter<Density>? density,
    ValueGetter<SpacingScale>? spacing,
    ValueGetter<TrackingScale>? tracking,
    ValueGetter<ShadowScale>? shadows,
    ValueGetter<IconThemeProperties>? iconTheme,
    ValueGetter<double>? surfaceOpacity,
    ValueGetter<double>? surfaceBlur,
    ValueGetter<bool>? enableFeedback,
  }) {
    final nextDensity = density == null ? this.density : density();
    final nextSpacing = spacing == null
        ? (density == null ? this.spacing : nextDensity.toSpacingScale())
        : spacing();
    return ThemeData(
      colorScheme: colorScheme == null ? this.colorScheme : colorScheme(),
      radius: radius == null ? this.radius : radius(),
      typography: typography == null ? this.typography : typography(),
      platform: platform == null ? _platform : platform(),
      scaling: scaling == null ? this.scaling : scaling(),
      density: nextDensity,
      spacing: nextSpacing,
      tracking: tracking == null ? this.tracking : tracking(),
      shadows: shadows == null ? this.shadows : shadows(),
      iconTheme: iconTheme == null ? this.iconTheme : iconTheme(),
      surfaceOpacity: surfaceOpacity == null
          ? this.surfaceOpacity
          : surfaceOpacity(),
      surfaceBlur: surfaceBlur == null ? this.surfaceBlur : surfaceBlur(),
      enableFeedback: enableFeedback == null
          ? this.enableFeedback
          : enableFeedback(),
    );
  }

  /// Linearly interpolates between two theme datas.
  ///
  /// Parameters:
  /// - [a] (`ThemeData`, required): Start theme.
  /// - [b] (`ThemeData`, required): End theme.
  /// - [t] (`double`, required): Interpolation position (0.0 to 1.0).
  ///
  /// Returns: `ThemeData` — interpolated theme.
  static ThemeData lerp(ThemeData a, ThemeData b, double t) {
    return ThemeData(
      colorScheme: ColorScheme.lerp(a.colorScheme, b.colorScheme, t),
      radius: lerpDouble(a.radius, b.radius, t)!,
      typography: Typography.lerp(a.typography, b.typography, t),
      platform: t < 0.5 ? a.platform : b.platform,
      scaling: lerpDouble(a.scaling, b.scaling, t)!,
      density: Density.lerp(a.density, b.density, t),
      spacing: SpacingScale.lerp(a.spacing, b.spacing, t),
      tracking: TrackingScale.lerp(a.tracking, b.tracking, t),
      shadows: ShadowScale.lerp(a.shadows, b.shadows, t),
      iconTheme: IconThemeProperties.lerp(a.iconTheme, b.iconTheme, t),
      surfaceOpacity: lerpDouble(a.surfaceOpacity, b.surfaceOpacity, t),
      surfaceBlur: lerpDouble(a.surfaceBlur, b.surfaceBlur, t),
      enableFeedback: t < 0.5 ? a.enableFeedback : b.enableFeedback,
    );
  }

  @override
/// Executes `operator ==` behavior for this component/composite.
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ThemeData &&
        other.colorScheme == colorScheme &&
        other.typography == typography &&
        other.radius == radius &&
        other.scaling == scaling &&
        other.density == density &&
        other.spacing == spacing &&
        other.tracking == tracking &&
        other.shadows == shadows &&
        other.iconTheme == iconTheme &&
        other.surfaceOpacity == surfaceOpacity &&
        other.surfaceBlur == surfaceBlur &&
        other.enableFeedback == enableFeedback;
  }

  @override
  int get hashCode {
    return Object.hash(
      colorScheme,
      typography,
      radius,
      scaling,
      density,
      spacing,
      tracking,
      shadows,
      iconTheme,
      surfaceOpacity,
      surfaceBlur,
      enableFeedback,
    );
  }

  @override
/// Executes `toString` behavior for this component/composite.
  String toString() {
    return 'ThemeData(colorScheme: $colorScheme, typography: $typography, radius: $radius, scaling: $scaling, spacing: $spacing, tracking: $tracking, shadows: $shadows, iconTheme: $iconTheme, surfaceOpacity: $surfaceOpacity, surfaceBlur: $surfaceBlur, enableFeedback: $enableFeedback)';
  }
}

/// An inherited widget that provides theme data to its descendants.
