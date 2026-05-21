// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../form.dart';

/// A validator that checks if a string is a valid email address.
///
/// [EmailValidator] uses the email_validator package to validate email
/// addresses according to standard email format rules.
///
/// Example:
/// ```dart
/// EmailValidator(
///   message: 'Please enter a valid email address',
/// )
/// ```
class EmailValidator extends Validator<String> {
  /// Custom error message, or null to use default localized message.
  final String?
  message; // if null, use default message from ShadcnLocalizations

  /// Creates an [EmailValidator] with an optional custom message.
  const EmailValidator({this.message});

  @override
  FutureOr<ValidationResult?> validate(
    BuildContext context,
    String? value,
    FormValidationMode state,
  ) {
    if (value == null) {
      return null;
    }
    if (!email_validator.EmailValidator.validate(value)) {
      return InvalidResult(
        message ?? Localizations.of(context, ShadcnLocalizations).invalidEmail,
        state: state,
      );
    }
    return null;
  }

  /// Compares this object with another for value equality.
  @override
  bool operator ==(Object other) {
    return other is EmailValidator && other.message == message;
  }

  /// Flag indicating whether `hashCode` is enabled/active.
  @override
  int get hashCode => message.hashCode;
}
