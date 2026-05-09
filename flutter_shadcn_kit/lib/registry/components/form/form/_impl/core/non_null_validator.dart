// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../form.dart';

/// A validator that ensures a value is not null.
///
/// [NonNullValidator] is a simple validator that fails if the value is null.
/// Commonly used to mark fields as required.
///
/// Example:
/// ```dart
/// NonNullValidator<String>(
///   message: 'This field is required',
/// )
/// ```
class NonNullValidator<T> extends Validator<T> {
  /// Custom error message, or null to use default localized message.
  final String?
  message; // if null, use default message from ShadcnLocalizations

  /// Creates a [NonNullValidator] with an optional custom message.
  const NonNullValidator({this.message});

  @override
  FutureOr<ValidationResult?> validate(
    BuildContext context,
    T? value,
    FormValidationMode state,
  ) {
    if (value == null) {
      var localizations = Localizations.of(context, ShadcnLocalizations);
      return InvalidResult(message ?? localizations.formNotEmpty, state: state);
    }
    return null;
  }

  /// Compares this object with another for value equality.
  @override
  bool operator ==(Object other) {
    return other is NonNullValidator && other.message == message;
  }

  /// Flag indicating whether `hashCode` is enabled/active.
  @override
  int get hashCode => message.hashCode;
}
