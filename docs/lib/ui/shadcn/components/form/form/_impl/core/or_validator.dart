// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../form.dart';

/// A validator that combines multiple validators with OR logic.
///
/// [OrValidator] passes if at least one of the wrapped validators passes.
/// Only fails if all validators fail. Useful for accepting multiple valid formats.
///
/// Example:
/// ```dart
/// OrValidator([
///   EmailValidator(),
///   PhoneValidator(),
/// ])
/// ```
class OrValidator<T> extends Validator<T> {
  /// The list of validators to combine with OR logic.
  final List<Validator<T>> validators;

  /// Creates an [OrValidator] from a list of validators.
  const OrValidator(this.validators);

  @override
  FutureOr<ValidationResult?> validate(
    BuildContext context,
    T? value,
    FormValidationMode state,
  ) {
    return _chainedValidation(context, value, state, 0);
  }

  FutureOr<ValidationResult?> _chainedValidation(
    BuildContext context,
    T? value,
    FormValidationMode state,
    int index,
  ) {
    if (index >= validators.length) {
      return null;
    }

    var validator = validators[index];
    var result = validator.validate(context, value, state);
    if (result is Future<ValidationResult?>) {
      return result.then((nextValue) {
        if (nextValue == null) {
          // means one of the validators passed and we don't need to check the rest
          return null;
        }
        if (!context.mounted) {
          return null;
        }
        return _chainedValidation(context, value, state, index + 1);
      });
    } else if (result == null) {
      // means one of the validators passed and we don't need to check the rest
      return null;
    }
    return _chainedValidation(context, value, state, index + 1);
  }

  /// Performs `operator |` logic for this form component.
  @override
  Validator<T> operator |(Validator<T> other) {
    return OrValidator([...validators, other]);
  }

  /// Performs `shouldRevalidate` logic for this form component.
  @override
  bool shouldRevalidate(FormKey<dynamic> source) {
    for (var validator in validators) {
      if (validator.shouldRevalidate(source)) {
        return true;
      }
    }
    return false;
  }

  /// Compares this object with another for value equality.
  @override
  operator ==(Object other) {
    return other is OrValidator && listEquals(other.validators, validators);
  }

  /// Flag indicating whether `hashCode` is enabled/active.
  @override
  int get hashCode => validators.hashCode;
}
