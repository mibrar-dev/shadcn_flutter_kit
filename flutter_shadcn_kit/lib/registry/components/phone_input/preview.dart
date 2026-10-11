// Named examples for the `phone_input` component (P6-F3 preview contract).
//
// One focused demo per example; the first entry is the default. Spacing comes
// from the ambient theme, so the examples follow the selected preset and the
// site light/dark toggle. Each example narrows the country selector and the
// number field through the widget-leg theme so the row also fits a 375-wide
// phone (the defaults total ~388 logical pixels).
//
// Note: `PhoneInput` exposes no leading-icon slot (verified in
// `phone_input.dart`: a country `Select` plus a number `Input`), so the
// audit's "With leading icon" example is replaced by "Custom countries",
// which covers the `countries` API instead.

import 'package:flutter/widgets.dart';

import '../../foundation/component_preview.dart';
import '../../primitives/countries.dart';
import '../form/form.dart';
import 'phone_input.dart';

/// Widths that fit both the 720-wide stage and a 375-wide phone. The country
/// selector needs 136 logical pixels for its flag, dial code and chevron.
const PhoneInputTheme _compact = PhoneInputTheme(
  selectWidth: 136,
  maxWidth: 160,
);

/// A phone field with a default country and value.
class _DefaultPhone extends StatefulWidget {
  const _DefaultPhone();

  @override
  State<_DefaultPhone> createState() => _DefaultPhoneState();
}

class _DefaultPhoneState extends State<_DefaultPhone> {
  PhoneNumber? _value = const PhoneNumber(
    Country(dialCode: '+62', code: 'ID'),
    '812345678',
  );

  @override
  Widget build(BuildContext context) {
    return PhoneInput(
      initialValue: _value,
      onChanged: (PhoneNumber? value) => setState(() => _value = value),
      theme: _compact,
    );
  }
}

/// A phone field offering a custom country list.
class _CustomCountriesPhone extends StatefulWidget {
  const _CustomCountriesPhone();

  @override
  State<_CustomCountriesPhone> createState() => _CustomCountriesPhoneState();
}

class _CustomCountriesPhoneState extends State<_CustomCountriesPhone> {
  PhoneNumber? _value;

  @override
  Widget build(BuildContext context) {
    return PhoneInput(
      initialCountry: const Country(dialCode: '+44', code: 'GB'),
      initialValue: _value,
      countries: const <CountryInfo>[
        CountryInfo('GB', '+44', 'GBP', 'United Kingdom'),
        CountryInfo('IE', '+353', 'EUR', 'Ireland'),
        CountryInfo('FR', '+33', 'EUR', 'France'),
      ],
      onChanged: (PhoneNumber? value) => setState(() => _value = value),
      theme: _compact,
    );
  }
}

/// A phone field showing the validator error for a short number.
class _InvalidPhone extends StatefulWidget {
  const _InvalidPhone();

  @override
  State<_InvalidPhone> createState() => _InvalidPhoneState();
}

class _InvalidPhoneState extends State<_InvalidPhone> {
  PhoneNumber? _value = const PhoneNumber(
    Country(dialCode: '+1', code: 'US'),
    '1',
  );

  @override
  Widget build(BuildContext context) {
    return ShadcnForm(
      child: ShadcnFormField<PhoneNumber>(
        key: const FormKey<PhoneNumber>('preview-phone-invalid'),
        label: const Text('Phone'),
        validator: const PhoneNumberValidator(),
        child: PhoneInput(
          initialValue: _value,
          onChanged: (PhoneNumber? value) => setState(() => _value = value),
          theme: _compact,
        ),
      ),
    );
  }
}

Widget _default(BuildContext context) => const _DefaultPhone();

Widget _customCountries(BuildContext context) => const _CustomCountriesPhone();

Widget _invalid(BuildContext context) => const _InvalidPhone();

/// Named docs examples for `phone_input`; the first entry is the default.
const List<ComponentPreview> phoneInputPreviews = <ComponentPreview>[
  ComponentPreview('Default', _default),
  ComponentPreview('Custom countries', _customCountries),
  ComponentPreview('Invalid', _invalid),
];
