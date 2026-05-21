// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../form.dart';

/// A validator that checks if a string is a valid URL.
///
/// [URLValidator] validates URLs using Dart's Uri parsing capabilities
/// to ensure the string represents a valid web address.
///
/// Example:
/// ```dart
/// URLValidator(
///   message: 'Please enter a valid URL',
/// )
/// ```
class URLValidator extends Validator<String> {
  /// Custom error message, or null to use default localized message.
  final String?
  message; // if null, use default message from ShadcnLocalizations

  /// Creates a [URLValidator] with an optional custom message.
  const URLValidator({this.message});

  @override
  FutureOr<ValidationResult?> validate(
    BuildContext context,
    String? value,
    FormValidationMode state,
  ) {
    if (value == null) {
      return null;
    }
    try {
      Uri.parse(value);
    } on FormatException {
      return InvalidResult(
        message ?? Localizations.of(context, ShadcnLocalizations).invalidURL,
        state: state,
      );
    }
    return null;
  }

  /// Compares this object with another for value equality.
  @override
  bool operator ==(Object other) {
    return other is URLValidator && other.message == message;
  }

  /// Flag indicating whether `hashCode` is enabled/active.
  @override
  int get hashCode => message.hashCode;
}
