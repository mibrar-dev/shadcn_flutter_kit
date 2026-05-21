// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../form.dart';

/// A validator that combines multiple validators with AND logic.
///
/// [CompositeValidator] runs multiple validators sequentially and only passes
/// if all validators pass. If any validator fails, validation stops and returns
/// that error. Created automatically when using the `&` operator between validators.
///
/// Example:
/// ```dart
/// CompositeValidator([
///   NonNullValidator(),
///   MinLengthValidator(3),
///   EmailValidator(),
/// ])
/// ```
class CompositeValidator<T> extends Validator<T> {
  /// The list of validators to run sequentially.
  final List<Validator<T>> validators;

  /// Creates a [CompositeValidator] from a list of validators.
  const CompositeValidator(this.validators);

  @override
  FutureOr<ValidationResult?> validate(
    BuildContext context,
    T? value,
    FormValidationMode state,
  ) {
    return _chainValidation(context, value, state, 0);
  }

  FutureOr<ValidationResult?> _chainValidation(
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
        if (nextValue != null) {
          return nextValue;
        }
        if (!context.mounted) {
          return null;
        }
        return _chainValidation(context, value, state, index + 1);
      });
    }
    if (result != null) {
      return result;
    }
    return _chainValidation(context, value, state, index + 1);
  }

  /// Performs `combine` logic for this form component.
  @override
  Validator<T> combine(Validator<T> other) {
    return CompositeValidator([...validators, other]);
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
  bool operator ==(Object other) {
    return other is CompositeValidator &&
        listEquals(other.validators, validators);
  }

  /// Flag indicating whether `hashCode` is enabled/active.
  @override
  int get hashCode => validators.hashCode;
}
