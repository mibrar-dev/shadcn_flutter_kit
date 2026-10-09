// Registry-owned theme data for the `country_flag` component.
//
// User-owned overrides live in `country_flag_theme.dart`; CLI updates may
// replace this file.

import 'package:flutter/widgets.dart';

import '../../primitives/phone_number.dart';
import '../../theme/color_tokens.dart';
import '../../theme/theme.dart';

/// Renders flag artwork for [CountryFlagDetails].
typedef CountryFlagBuilder =
    Widget Function(BuildContext context, CountryFlagDetails details);

/// Request a [CountryFlagBuilder] answers: the country plus the box the
/// flag should fill.
class CountryFlagDetails {
  /// Creates flag details.
  const CountryFlagDetails({
    required this.country,
    required this.width,
    required this.height,
    this.shape,
  });

  /// Country to draw.
  final Country country;

  /// Width the flag should occupy.
  final double width;

  /// Height the flag should occupy.
  final double height;

  /// Shape to clip to; null draws unclipped.
  final ShapeBorder? shape;

  /// ISO 3166-1 alpha-2 code of [country].
  String get countryCode => country.code;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CountryFlagDetails &&
        other.country == country &&
        other.width == width &&
        other.height == height &&
        other.shape == shape;
  }

  @override
  int get hashCode => Object.hash(country, width, height, shape);
}

/// Theme of the country flag tile.
///
/// Every field is nullable: `null` means "inherit", and the resolver fills
/// the gap from the next leg (defaults < app < scoped < widget).
class CountryFlagTheme extends ComponentThemeData
    implements Mergeable<CountryFlagTheme> {
  /// Creates a country flag theme.
  const CountryFlagTheme({
    super.themeDensity,
    super.themeSpacing,
    super.themeShadows,
    this.builder,
    this.width,
    this.height,
    this.shape,
  });

  /// Artwork provider; null uses the built-in emoji fallback.
  final CountryFlagBuilder? builder;

  /// Default flag width. Default: 24 (scaled).
  final double? width;

  /// Default flag height. Default: 18 (scaled).
  final double? height;

  /// Default clip shape; null draws unclipped.
  final ShapeBorder? shape;

  /// Returns a copy with the given fields replaced.
  CountryFlagTheme copyWith({
    ValueGetter<CountryFlagBuilder?>? builder,
    ValueGetter<double?>? width,
    ValueGetter<double?>? height,
    ValueGetter<ShapeBorder?>? shape,
  }) {
    return CountryFlagTheme(
      builder: builder == null ? this.builder : builder(),
      width: width == null ? this.width : width(),
      height: height == null ? this.height : height(),
      shape: shape == null ? this.shape : shape(),
    );
  }

  /// Receiver wins per field; [fallback] only fills null cells.
  @override
  CountryFlagTheme merge(CountryFlagTheme? fallback) {
    if (fallback == null) return this;
    return CountryFlagTheme(
      themeDensity: themeDensity ?? fallback.themeDensity,
      themeSpacing: themeSpacing ?? fallback.themeSpacing,
      themeShadows: themeShadows ?? fallback.themeShadows,
      builder: builder ?? fallback.builder,
      width: width ?? fallback.width,
      height: height ?? fallback.height,
      shape: shape ?? fallback.shape,
    );
  }

  /// Geometry interpolates; the rest steps at `t = 0.5`.
  static CountryFlagTheme lerp(
    CountryFlagTheme a,
    CountryFlagTheme b,
    double t,
  ) {
    double? scale(double? x, double? y) {
      if (x == null) return y;
      if (y == null) return x;
      return x + (y - x) * t;
    }

    return CountryFlagTheme(
      themeDensity: t < 0.5 ? a.themeDensity : b.themeDensity,
      themeSpacing: t < 0.5 ? a.themeSpacing : b.themeSpacing,
      themeShadows: t < 0.5 ? a.themeShadows : b.themeShadows,
      builder: t < 0.5 ? a.builder : b.builder,
      width: scale(a.width, b.width),
      height: scale(a.height, b.height),
      shape: t < 0.5 ? a.shape : b.shape,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CountryFlagTheme &&
        other.themeDensity == themeDensity &&
        other.themeSpacing == themeSpacing &&
        other.themeShadows == themeShadows &&
        other.builder == builder &&
        other.width == width &&
        other.height == height &&
        other.shape == shape;
  }

  @override
  int get hashCode => Object.hash(
    themeDensity,
    themeSpacing,
    themeShadows,
    builder,
    width,
    height,
    shape,
  );
}

/// Built-in country flag defaults.
const CountryFlagTheme countryFlagDefaults = CountryFlagTheme(
  width: 24,
  height: 18,
);
