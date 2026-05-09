// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../form.dart';

/// A validator that ensures a string is not null or empty.
///
/// [NotEmptyValidator] extends [NonNullValidator] to also check for empty strings.
/// Commonly used for text field validation.
///
/// Example:
/// ```dart
/// NotEmptyValidator(
///   message: 'Please enter a value',
/// )
/// ```
class NotEmptyValidator extends NonNullValidator<String> {
  /// Creates a [NotEmptyValidator] with an optional custom message.
  const NotEmptyValidator({super.message});

  @override
  FutureOr<ValidationResult?> validate(
    BuildContext context,
    String? value,
    FormValidationMode state,
  ) {
    if (value == null || value.isEmpty) {
      var localizations = Localizations.of(context, ShadcnLocalizations);
      return InvalidResult(message ?? localizations.formNotEmpty, state: state);
    }
    return null;
  }

  /// Compares this object with another for value equality.
  @override
  bool operator ==(Object other) {
    return other is NotEmptyValidator && other.message == message;
  }

  /// Flag indicating whether `hashCode` is enabled/active.
  @override
  int get hashCode => message.hashCode;
}
