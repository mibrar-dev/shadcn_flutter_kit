// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../country_flag.dart';

/// Displays the flag of a country.
///
/// The artwork comes from [CountryFlagTheme.builder]. With no theme in scope,
/// flags are drawn as Unicode regional-indicator emoji — no assets, no extra
/// dependency, and no fixed resolution. See [CountryFlagTheme] for swapping in
/// real flag images.
///
/// Example:
/// ```dart
/// CountryFlag.fromCountryCode(
///   'US',
///   height: 18,
///   width: 24,
///   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
/// );
/// ```
class CountryFlag extends StatelessWidget {
  /// Draws a flag as a regional-indicator emoji pair, scaled to fit.
  ///
  /// This is what [CountryFlag] falls back to when [CountryFlagTheme.builder]
  /// is null. It is public so a custom builder can defer to it for countries
  /// its own artwork does not cover.
  static Widget emojiBuilder(BuildContext context, CountryFlagDetails details) {
    return _EmojiCountryFlag(details: details);
  }

  /// The country to draw, or null if the lookup found nothing.
  ///
  /// A null country renders as an empty box of the requested size, so a bad
  /// country code leaves the surrounding layout intact instead of throwing.
  final Country? country;

  /// Width of the flag; falls back to [CountryFlagTheme.width], then to 24
  /// scaled by the theme.
  final double? width;

  /// Height of the flag; falls back to [CountryFlagTheme.height], then to 18
  /// scaled by the theme.
  final double? height;

  /// Shape the flag is clipped to.
  ///
  /// Falls back to [CountryFlagTheme.shape], then to no clipping.
  final ShapeBorder? shape;

  /// Creates a flag for [country].
  const CountryFlag(
    this.country, {
    super.key,
    this.width,
    this.height,
    this.shape,
  });

  /// Creates a flag from an ISO 3166-1 alpha-2 country code, e.g. `US`.
  ///
  /// Unknown codes render as an empty box.
  CountryFlag.fromCountryCode(
    String countryCode, {
    super.key,
    this.width,
    this.height,
    this.shape,
  }) : country = _findByCode(countryCode);

  /// Creates a flag from an ISO 4217 currency code, e.g. `USD`.
  ///
  /// Several countries can share a currency; the first match in
  /// [Country.values] wins. Unknown codes render as an empty box.
  CountryFlag.fromCurrencyCode(
    String currencyCode, {
    super.key,
    this.width,
    this.height,
    this.shape,
  }) : country = _findByCurrency(currencyCode);

  /// Creates a flag from an international dial code, e.g. `+1`.
  ///
  /// Several countries can share a dial code; the first match in
  /// [Country.values] wins. Unknown prefixes render as an empty box.
  CountryFlag.fromPhonePrefix(
    String prefix, {
    super.key,
    this.width,
    this.height,
    this.shape,
  }) : country = _findByDialCode(prefix);

  static Country? _findByCode(String countryCode) {
    final normalized = countryCode.toUpperCase();
    for (final country in Country.values) {
      if (country.code == normalized) return country;
    }
    return null;
  }

  static Country? _findByCurrency(String currencyCode) {
    final normalized = currencyCode.toUpperCase();
    for (final country in Country.values) {
      if (country.currency.code == normalized) return country;
    }
    return null;
  }

  static Country? _findByDialCode(String prefix) {
    final normalized = prefix.startsWith('+') ? prefix : '+$prefix';
    for (final country in Country.values) {
      if (country.dialCode == normalized) return country;
    }
    return null;
  }

  /// Builds the widget tree for country flag.
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final compTheme = ComponentTheme.maybeOf<CountryFlagTheme>(context);
    final widthValue = styleValue(
      widgetValue: width,
      themeValue: compTheme?.width,
      defaultValue: theme.scaling * 24,
    );
    final heightValue = styleValue(
      widgetValue: height,
      themeValue: compTheme?.height,
      defaultValue: theme.scaling * 18,
    );
    final country = this.country;
    if (country == null) {
      return SizedBox(width: widthValue, height: heightValue);
    }
    final details = CountryFlagDetails(
      country: country,
      width: widthValue,
      height: heightValue,
      shape: shape ?? compTheme?.shape,
    );
    return (compTheme?.builder ?? emojiBuilder)(context, details);
  }
}

/// The built-in flag renderer: a regional-indicator emoji, scaled to fit.
class _EmojiCountryFlag extends StatelessWidget {
  final CountryFlagDetails details;

  const _EmojiCountryFlag({required this.details});

  @override
  Widget build(BuildContext context) {
    Widget result = SizedBox(
      width: details.width,
      height: details.height,
      child: FittedBox(
        fit: BoxFit.contain,
        child: Text(
          details.country.flag,
          textAlign: TextAlign.center,
          // Flag emoji pick up italics and weight badly across platforms, and
          // a line height above 1 leaves the glyph floating inside the box.
          style: const TextStyle(
            height: 1,
            fontStyle: FontStyle.normal,
            fontWeight: FontWeight.normal,
          ),
        ),
      ),
    );
    final shape = details.shape;
    if (shape != null) {
      result = ClipPath(
        clipper: ShapeBorderClipper(shape: shape),
        child: result,
      );
    }
    return result;
  }
}
