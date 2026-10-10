// Gallery preview for the `country_flag` component: code/currency/prefix
// lookups, sizes, shapes and a dark subtree. Widgets-only; the docs app
// embeds [CountryFlagPreview] directly.

import 'package:flutter/widgets.dart';

import '../../foundation/gap.dart';
import '../../theme/color_tokens.dart';
import '../../theme/theme.dart';
import 'country_flag.dart';

/// Renders the country flag gallery.
class CountryFlagPreview extends StatelessWidget {
  /// Creates the preview.
  const CountryFlagPreview({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: DefaultTextStyle(
        style: const TextStyle(fontSize: 13),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _section(
                context,
                'Codes',
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: <Widget>[
                    CountryFlag.fromCountryCode('US'),
                    CountryFlag.fromCountryCode('JP'),
                    CountryFlag.fromCountryCode('DE'),
                    CountryFlag.fromCountryCode('BR'),
                    CountryFlag.fromCountryCode('XX'),
                  ],
                ),
              ),
              Gap(ShadcnTheme.of(context).spacing.xl),
              _section(
                context,
                'Other lookups',
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: <Widget>[
                    CountryFlag.fromCurrencyCode('JPY'),
                    CountryFlag.fromPhonePrefix('+49'),
                  ],
                ),
              ),
              Gap(ShadcnTheme.of(context).spacing.xl),
              _section(
                context,
                'Sizes and shapes',
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: <Widget>[
                    CountryFlag.fromCountryCode('FR'),
                    CountryFlag.fromCountryCode('FR', width: 36, height: 27),
                    CountryFlag.fromCountryCode(
                      'IT',
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                  ],
                ),
              ),
              Gap(ShadcnTheme.of(context).spacing.xl),
              _section(
                context,
                'Dark',
                ShadcnTheme(
                  data: const ShadcnThemeData(
                    colors: ShadcnColors.darkFallback,
                  ),
                  child: Wrap(
                    spacing: 8,
                    children: <Widget>[
                      CountryFlag.fromCountryCode('US'),
                      CountryFlag.fromCountryCode('JP'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _section(BuildContext context, String title, Widget child) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          title,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        Gap(ShadcnTheme.of(context).spacing.sm),
        child,
      ],
    );
  }
}
