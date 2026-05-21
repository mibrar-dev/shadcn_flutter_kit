// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../form.dart';

/// A validator for ensuring password strength and security requirements.
///
/// [SafePasswordValidator] checks passwords against common security criteria:
/// digits, lowercase letters, uppercase letters, and special characters.
/// Each requirement can be individually enabled or disabled.
///
/// Example:
/// ```dart
/// SafePasswordValidator(
///   requireDigit: true,
///   requireLowercase: true,
///   requireUppercase: true,
///   requireSpecialChar: true,
///   message: 'Password must meet security requirements',
/// )
/// ```
class SafePasswordValidator extends Validator<String> {
  /// Custom error message, or null to use default localized messages.
  final String?
  message; // if null, use default message from ShadcnLocalizations

  /// Whether password must contain at least one digit.
  final bool requireDigit;

  /// Whether password must contain at least one lowercase letter.
  final bool requireLowercase;

  /// Whether password must contain at least one uppercase letter.
  final bool requireUppercase;

  /// Whether password must contain at least one special character.
  final bool requireSpecialChar;

  /// Creates a [SafePasswordValidator] with configurable requirements.
  const SafePasswordValidator({
    this.requireDigit = true,
    this.requireLowercase = true,
    this.requireUppercase = true,
    this.requireSpecialChar = true,
    this.message,
  });

  @override
  FutureOr<ValidationResult?> validate(
    BuildContext context,
    String? value,
    FormValidationMode state,
  ) {
    if (value == null) {
      return null;
    }
    if (requireDigit && !RegExp(r'\d').hasMatch(value)) {
      return InvalidResult(
        message ??
            Localizations.of(context, ShadcnLocalizations).formPasswordDigits,
        state: state,
      );
    }
    if (requireLowercase && !RegExp(r'[a-z]').hasMatch(value)) {
      return InvalidResult(
        message ??
            Localizations.of(
              context,
              ShadcnLocalizations,
            ).formPasswordLowercase,
        state: state,
      );
    }
    if (requireUppercase && !RegExp(r'[A-Z]').hasMatch(value)) {
      return InvalidResult(
        message ??
            Localizations.of(
              context,
              ShadcnLocalizations,
            ).formPasswordUppercase,
        state: state,
      );
    }
    if (requireSpecialChar && !RegExp(r'[\W_]').hasMatch(value)) {
      return InvalidResult(
        message ??
            Localizations.of(context, ShadcnLocalizations).formPasswordSpecial,
        state: state,
      );
    }
    return null;
  }

  /// Compares this object with another for value equality.
  @override
  bool operator ==(Object other) {
    return other is SafePasswordValidator &&
        other.requireDigit == requireDigit &&
        other.requireLowercase == requireLowercase &&
        other.requireUppercase == requireUppercase &&
        other.requireSpecialChar == requireSpecialChar &&
        other.message == message;
  }

  @override
  int get hashCode => Object.hash(
    requireDigit,
    requireLowercase,
    requireUppercase,
    requireSpecialChar,
    message,
  );
}
