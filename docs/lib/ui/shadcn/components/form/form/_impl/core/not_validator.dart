// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../form.dart';

/// A validator that negates the result of another validator.
///
/// [NotValidator] inverts the validation logic - it passes when the wrapped
/// validator fails and fails when the wrapped validator passes. Useful for
/// creating exclusion rules.
///
/// Example:
/// ```dart
/// NotValidator(
///   EmailValidator(),
///   message: 'Must not be an email address',
/// )
/// ```
class NotValidator<T> extends Validator<T> {
  /// The validator whose result will be negated.
  final Validator<T> validator;

  /// Custom error message, or null to use default localized message.
  final String?
  message; // if null, use default message from ShadcnLocalizations

  /// Creates a [NotValidator] that negates the result of another validator.
  const NotValidator(this.validator, {this.message});

  @override
  FutureOr<ValidationResult?> validate(
    BuildContext context,
    T? value,
    FormValidationMode state,
  ) {
    var localizations = Localizations.of(context, ShadcnLocalizations);
    var result = validator.validate(context, value, state);
    if (result is Future<ValidationResult?>) {
      return result.then((value) {
        if (value == null) {
          return InvalidResult(
            message ?? localizations.invalidValue,
            state: state,
          );
        }
        return null;
      });
    } else if (result == null) {
      return InvalidResult(message ?? localizations.invalidValue, state: state);
    }
    return null;
  }

  /// Compares this object with another for value equality.
  @override
  operator ==(Object other) {
    return other is NotValidator &&
        other.validator == validator &&
        other.message == message;
  }

  @override
  int get hashCode => Object.hash(validator, message);
}
