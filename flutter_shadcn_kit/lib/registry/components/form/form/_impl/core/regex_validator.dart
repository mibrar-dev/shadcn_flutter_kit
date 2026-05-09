// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../form.dart';

/// A validator that checks if a string matches a regular expression pattern.
///
/// [RegexValidator] provides flexible pattern-based validation using regular
/// expressions. Useful for validating formats like phone numbers, postal codes, etc.
///
/// Example:
/// ```dart
/// RegexValidator(
///   RegExp(r'^\d{3}-\d{3}-\d{4}$'),
///   message: 'Must be in format: XXX-XXX-XXXX',
/// )
/// ```
class RegexValidator extends Validator<String> {
  /// The regular expression pattern to match against.
  final RegExp pattern;

  /// Custom error message, or null to use default localized message.
  final String?
  message; // if null, use default message from ShadcnLocalizations

  /// Creates a [RegexValidator] with the specified pattern.
  const RegexValidator(this.pattern, {this.message});

  @override
  FutureOr<ValidationResult?> validate(
    BuildContext context,
    String? value,
    FormValidationMode state,
  ) {
    if (value == null) {
      return null;
    }
    if (!pattern.hasMatch(value)) {
      return InvalidResult(
        message ?? Localizations.of(context, ShadcnLocalizations).invalidValue,
        state: state,
      );
    }
    return null;
  }

  /// Compares this object with another for value equality.
  @override
  bool operator ==(Object other) {
    return other is RegexValidator &&
        other.pattern == pattern &&
        other.message == message;
  }

  @override
  int get hashCode => Object.hash(pattern, message);
}
