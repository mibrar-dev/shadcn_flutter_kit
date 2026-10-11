// The `country_flag` component: [CountryFlag] (flag tile with an emoji
// fallback and a swappable artwork builder).
//
// Ported from `components/display/country_flag`. Fixes: the `phonecodes`
// package is gone — lookups run against the `countries` primitive table, and
// the fallback emoji derives from the ISO code mathematically (no per-flag
// data needed).

import 'package:flutter/widgets.dart';

import '../../primitives/countries.dart';
import '../../primitives/phone_number.dart';
import '../../theme/theme.dart';
import 'country_flag_style.dart';

export 'country_flag_style.dart';

/// Flag tile for a country.
///
/// Unknown codes render as an empty box of the requested size, keeping the
/// surrounding layout intact. With no theme builder, flags draw as Unicode
/// regional-indicator emoji (no assets, no extra dependency); provide
/// [CountryFlagTheme.builder] for real artwork.
class CountryFlag extends StatelessWidget {
  /// Creates a flag for [country] (null renders an empty box).
  const CountryFlag(
    this.country, {
    super.key,
    this.width,
    this.height,
    this.shape,
    this.theme,
  });

  /// Creates a flag from an ISO 3166-1 alpha-2 code (e.g. `US`).
  CountryFlag.fromCountryCode(
    String countryCode, {
    super.key,
    this.width,
    this.height,
    this.shape,
    this.theme,
  }) : country = countryInfoForCode(countryCode)?.country;

  /// Creates a flag from an ISO 4217 currency code (e.g. `USD`); the first
  /// table match wins when countries share a currency.
  CountryFlag.fromCurrencyCode(
    String currencyCode, {
    super.key,
    this.width,
    this.height,
    this.shape,
    this.theme,
  }) : country = countryInfoForCurrency(currencyCode)?.country;

  /// Creates a flag from an international dial code (e.g. `+81`); the first
  /// table match wins when countries share a prefix.
  CountryFlag.fromPhonePrefix(
    String prefix, {
    super.key,
    this.width,
    this.height,
    this.shape,
    this.theme,
  }) : country = countryInfoForDialCode(prefix)?.country;

  /// Draws [details] as a regional-indicator emoji pair, scaled to fit.
  ///
  /// This is the default artwork and stays public so custom builders can
  /// defer to it for uncovered countries.
  static Widget emojiBuilder(BuildContext context, CountryFlagDetails details) {
    return _EmojiFlag(details: details);
  }

  /// Country to draw, or null for an empty box.
  final Country? country;

  /// Flag width override; null falls back to the theme (24, scaled).
  final double? width;

  /// Flag height override; null falls back to the theme (18, scaled).
  final double? height;

  /// Clip shape override; null falls back to the theme (unclipped).
  final ShapeBorder? shape;

  /// Widget-leg theme override, merged over the other legs.
  final CountryFlagTheme? theme;

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData ambient = ShadcnTheme.of(context);
    final CountryFlagTheme style =
        resolveComponentStyle<CountryFlagTheme, CountryFlagTheme>(
          context,
          widget: theme,
          select: (t) => t,
          defaults: countryFlagDefaults,
        );
    final double scale = ambient.scaling;
    final double tileWidth = (width ?? style.width ?? 24) * scale;
    final double tileHeight = (height ?? style.height ?? 18) * scale;
    final Country? country = this.country;
    if (country == null) {
      return SizedBox(width: tileWidth, height: tileHeight);
    }
    final CountryFlagDetails details = CountryFlagDetails(
      country: country,
      width: tileWidth,
      height: tileHeight,
      shape: shape ?? style.shape,
    );
    return (style.builder ?? CountryFlag.emojiBuilder)(context, details);
  }
}

/// Built-in flag renderer: regional-indicator emoji, scaled to fit.
class _EmojiFlag extends StatelessWidget {
  const _EmojiFlag({required this.details});

  final CountryFlagDetails details;

  @override
  Widget build(BuildContext context) {
    // The emoji glyph carries no accessible name; expose the resolved
    // country name (or the raw code when the table has no row for it). The
    // glyph itself is excluded: readers announce the name, not the raw
    // regional-indicator characters.
    final String label =
        countryInfoForCode(details.countryCode)?.name ?? details.countryCode;
    Widget result = Semantics(
      label: label,
      child: ExcludeSemantics(
        child: SizedBox(
          width: details.width,
          height: details.height,
          child: FittedBox(
            fit: BoxFit.contain,
            child: Text(
              flagEmojiForCode(details.countryCode),
              textAlign: TextAlign.center,
              style: const TextStyle(
                height: 1,
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
        ),
      ),
    );
    final ShapeBorder? shape = details.shape;
    if (shape != null) {
      result = ClipPath(
        clipper: ShapeBorderClipper(shape: shape),
        child: result,
      );
    }
    return result;
  }
}
