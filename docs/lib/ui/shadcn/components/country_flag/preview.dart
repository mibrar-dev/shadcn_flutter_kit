// Named examples for the `country_flag` component (P6-F3 preview contract).
//
// One focused demo per example; the first entry is the default. Spacing comes
// from the ambient theme, so the examples follow the selected preset and the
// site light/dark toggle.

import 'package:flutter/widgets.dart';

import '../../foundation/component_preview.dart';
import '../../theme/theme.dart';
import 'country_flag.dart';

/// A row of flags looked up from different keys.
Widget _countryFlagDefault(BuildContext context) {
  final spacing = ShadcnTheme.of(context).spacing;
  return Wrap(
    spacing: spacing.md,
    runSpacing: spacing.sm,
    crossAxisAlignment: WrapCrossAlignment.center,
    children: <Widget>[
      CountryFlag.fromCountryCode('US'),
      CountryFlag.fromCountryCode('JP'),
      CountryFlag.fromCountryCode('DE'),
      CountryFlag.fromCountryCode('BR'),
      CountryFlag.fromCountryCode('XX'),
      CountryFlag.fromCurrencyCode('JPY'),
      CountryFlag.fromPhonePrefix('+49'),
    ],
  );
}

/// The size scale and the rounded shape.
Widget _countryFlagSizes(BuildContext context) {
  final spacing = ShadcnTheme.of(context).spacing;
  return Wrap(
    spacing: spacing.md,
    runSpacing: spacing.sm,
    crossAxisAlignment: WrapCrossAlignment.center,
    children: <Widget>[
      CountryFlag.fromCountryCode('FR'),
      CountryFlag.fromCountryCode('FR', width: 36, height: 27),
      CountryFlag.fromCountryCode('IT', width: 48, height: 36),
      CountryFlag.fromCountryCode(
        'ES',
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      ),
    ],
  );
}

/// Named docs examples for `country_flag`; the first entry is the default.
const List<ComponentPreview> countryFlagPreviews = <ComponentPreview>[
  ComponentPreview('Default', _countryFlagDefault),
  ComponentPreview('Sizes', _countryFlagSizes),
];
