// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../phone_input.dart';

/// [Validator] for validating a [PhoneNumber] input value.
///
/// Provides customizable error messages for invalid and empty phone numbers,
/// and can be used with the form validation system to ensure that user input
/// meets the required phone number format and completeness criteria.
///
/// Extends the form component's `Validator` (imported as `form`), so the
/// result types come from the form library. When no custom message is
/// provided, the message is resolved from [ShadcnLocalizations]
/// (`formPhoneNumberEmpty` / `formPhoneNumberInvalid`, English fallback
/// built in); pass [emptyMessage]/[invalidMessage] for custom text.
class PhoneNumberValid extends form.Validator<PhoneNumber> {
  /// Custom error message for invalid phone numbers.
  final String? invalidMessage;

  /// Custom error message for empty phone number input.
  final String? emptyMessage;

  /// Creates a [PhoneNumberValid] validator with optional custom error messages.
  const PhoneNumberValid({this.invalidMessage, this.emptyMessage});

  @override
  FutureOr<form.ValidationResult?> validate(
    BuildContext context,
    PhoneNumber? value,
    form.FormValidationMode lifecycle,
  ) {
    final localizations = ShadcnLocalizations.of(context);
    if (value == null) {
      return form.InvalidResult(
        emptyMessage ?? localizations.formPhoneNumberEmpty,
        state: lifecycle,
      );
    }
    if (value.country == null || value.number.isEmpty) {
      return form.InvalidResult(
        invalidMessage ?? localizations.formPhoneNumberInvalid,
        state: lifecycle,
      );
    }
    return null;
  }

  @override
  bool operator ==(Object other) {
    return other is PhoneNumberValid &&
        other.emptyMessage == emptyMessage &&
        other.invalidMessage == invalidMessage;
  }

  @override
  int get hashCode => Object.hash(emptyMessage, invalidMessage);
}
