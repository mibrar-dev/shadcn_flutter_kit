// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../country_flag.dart';

/// Builder function type for rendering a country flag.
///
/// Receives the resolved [CountryFlagDetails] — the country to draw plus the
/// size and shape it should be drawn at — and returns the widget that paints
/// it. Set one on [CountryFlagTheme.builder] to swap the built-in
/// emoji flags for artwork of your own.
typedef CountryFlagBuilder = Widget Function(
  BuildContext context,
  CountryFlagDetails details,
);

/// The request a [CountryFlagBuilder] answers.
///
/// Carries the country and the box the flag is expected to fill. A builder is
/// free to ignore [width] and [height] — [CountryFlag] does not clip or
/// constrain the widget it gets back — but honouring them keeps flags aligned
/// with the rest of the layout.
class CountryFlagDetails {
  /// The country whose flag should be drawn.
  final Country country;

  /// Width the flag should occupy, in logical pixels.
  final double width;

  /// Height the flag should occupy, in logical pixels.
  final double height;

  /// Shape the flag should be clipped to.
  ///
  /// Any [ShapeBorder] works: [RoundedRectangleBorder] for rounded corners,
  /// [CircleBorder] for a circular badge. Null means no clipping.
  final ShapeBorder? shape;

  /// Creates the details handed to a [CountryFlagBuilder].
  const CountryFlagDetails({
    required this.country,
    required this.width,
    required this.height,
    this.shape,
  });

  /// The ISO 3166-1 alpha-2 code of [country], e.g. `US`.
  String get countryCode => country.code;

  /// Compares two country flag details values for structural equality.
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

  /// Returns a debug string for this country flag details value.
  @override
  String toString() =>
      'CountryFlagDetails(country: $country, width: $width, height: $height, shape: $shape)';
}
