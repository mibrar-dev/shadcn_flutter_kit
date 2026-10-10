// Gallery preview for the `phone_input` component: countries, dark palette
// and a form field with the phone validator. Widgets-only.

import 'package:flutter/widgets.dart';

import '../../foundation/gap.dart';
import '../../primitives/countries.dart';
import '../../theme/color_tokens.dart';
import '../../theme/theme.dart';
import '../form/form.dart';
import 'phone_input.dart';

/// Renders the phone-input gallery.
class PhoneInputPreview extends StatefulWidget {
  /// Creates the preview.
  const PhoneInputPreview({super.key});

  @override
  State<PhoneInputPreview> createState() => _PhoneInputPreviewState();
}

class _PhoneInputPreviewState extends State<PhoneInputPreview> {
  PhoneNumber? _value = const PhoneNumber(
    Country(dialCode: '+62', code: 'ID'),
    '812345678',
  );

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    return ColoredBox(
      color: theme.colors.background,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _label(theme, 'Default country and value'),
            PhoneInput(
              initialValue: _value,
              onChanged: (value) => setState(() => _value = value),
            ),
            Gap(theme.spacing.xl),
            _label(theme, 'Custom country list'),
            PhoneInput(
              initialCountry: const Country(dialCode: '+44', code: 'GB'),
              countries: const <CountryInfo>[
                CountryInfo('GB', '+44', 'GBP', 'United Kingdom'),
                CountryInfo('IE', '+353', 'EUR', 'Ireland'),
                CountryInfo('FR', '+33', 'EUR', 'France'),
              ],
              onChanged: (value) => setState(() => _value = value),
            ),
            Gap(theme.spacing.xl),
            _label(theme, 'In a form field with the phone validator'),
            ShadcnForm(
              child: ShadcnFormField<PhoneNumber>(
                key: const FormKey<PhoneNumber>('preview-phone'),
                label: const Text('Phone'),
                validator: const PhoneNumberValidator(),
                child: PhoneInput(
                  initialValue: _value,
                  onChanged: (value) => setState(() => _value = value),
                ),
              ),
            ),
            Gap(theme.spacing.xl),
            _label(theme, 'Dark palette'),
            ShadcnTheme(
              data: const ShadcnThemeData(colors: ShadcnColors.darkFallback),
              child: PhoneInput(
                initialValue: _value,
                onChanged: (value) => setState(() => _value = value),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _label(ShadcnThemeData theme, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: theme.colors.foreground,
        ),
      ),
    );
  }
}
