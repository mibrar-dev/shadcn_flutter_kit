// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../../country_flag.dart';

/// Theme configuration for [CountryFlag].
///
/// Besides the usual sizing and shape defaults, this theme carries [builder] —
/// the flag artwork provider for the subtree. By default flags are drawn as
/// Unicode regional-indicator emoji, which needs no assets and no extra
/// dependency. Platforms differ in how well they render those — Windows in
/// particular ships no flag glyphs at all and falls back to the country's two
/// letters — so apps that want real artwork provide their own builder.
///
/// Example, backing flags with `package:country_flags`:
/// ```dart
/// ComponentTheme(
///   data: CountryFlagTheme(
///     builder: (context, details) => country_flags.CountryFlag.fromCountryCode(
///       details.countryCode,
///       theme: country_flags.ImageTheme(
///         width: details.width,
///         height: details.height,
///       ),
///     ),
///   ),
///   child: const MyApp(),
/// );
/// ```
class CountryFlagTheme extends ComponentThemeData {
  /// Renders the flag artwork.
  ///
  /// Null means [CountryFlag.emojiBuilder], the emoji fallback that ships with
  /// this component.
  final CountryFlagBuilder? builder;

  /// Default width of a flag, in logical pixels.
  final double? width;

  /// Default height of a flag, in logical pixels.
  final double? height;

  /// Default shape flags are clipped to.
  final ShapeBorder? shape;

  /// Creates a [CountryFlagTheme].
  const CountryFlagTheme({
    super.themeDensity,
    super.themeSpacing,
    super.themeShadows,
    this.builder,
    this.width,
    this.height,
    this.shape,
  });

  /// Creates a copy of this theme with the given values replaced.
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

  /// Compares two country flag values for structural equality.
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CountryFlagTheme &&
        other.builder == builder &&
        other.width == width &&
        other.height == height &&
        other.shape == shape;
  }

  @override
  int get hashCode => Object.hash(builder, width, height, shape);

  /// Returns a debug string for this country flag value.
  @override
  String toString() =>
      'CountryFlagTheme(builder: $builder, width: $width, height: $height, shape: $shape)';
}
