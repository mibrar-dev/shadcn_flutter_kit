// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../form.dart';

/// A validator that compares a field's value with another form field's value.
///
/// [CompareWith] validates by comparing the current field's value against
/// another field identified by a [FormKey]. Supports various comparison types
/// including equality, greater than, less than, etc.
///
/// Example:
/// ```dart
/// CompareWith.greaterOrEqual(
///   FormKey<int>('minAge'),
///   message: 'Must be at least the minimum age',
/// )
/// ```
class CompareWith<T extends Comparable<T>> extends Validator<T> {
  /// The form field key to compare against.
  final FormKey<T> key;

  /// The type of comparison to perform.
  final CompareType type;

  /// Custom error message, or null to use default localized message.
  final String?
  message; // if null, use default message from ShadcnLocalizations

  /// Creates a [CompareWith] validator with the specified comparison type.
  const CompareWith(this.key, this.type, {this.message});

  /// Creates a validator that checks for equality with another field.
  const CompareWith.equal(this.key, {this.message}) : type = CompareType.equal;

  /// Creates a validator that checks if value is greater than another field.
  const CompareWith.greater(this.key, {this.message})
    : type = CompareType.greater;

  /// Creates a validator that checks if value is greater than or equal to another field.
  const CompareWith.greaterOrEqual(this.key, {this.message})
    : type = CompareType.greaterOrEqual;

  /// Creates a validator that checks if value is less than another field.
  const CompareWith.less(this.key, {this.message}) : type = CompareType.less;

  /// Creates a validator that checks if value is less than or equal to another field.
  const CompareWith.lessOrEqual(this.key, {this.message})
    : type = CompareType.lessOrEqual;

  /// Performs `_compare` logic for this form component.
  int _compare(T? a, T? b) {
    if (a == null && b == null) {
      return 0;
    }
    if (a == null) {
      return -1;
    }
    if (b == null) {
      return 1;
    }
    return a.compareTo(b);
  }

  @override
  FutureOr<ValidationResult?> validate(
    BuildContext context,
    T? value,
    FormValidationMode state,
  ) {
    var localizations = Localizations.of(context, ShadcnLocalizations);
    var otherValue = context.getFormValue(key);
    if (otherValue == null) {
      return InvalidResult(message ?? localizations.invalidValue, state: state);
    }
    var compare = _compare(value, otherValue);
    switch (type) {
      case CompareType.greater:
        if (compare <= 0) {
          return InvalidResult(
            message ?? localizations.formGreaterThan(otherValue),
            state: state,
          );
        }
        break;
      case CompareType.greaterOrEqual:
        if (compare < 0) {
          return InvalidResult(
            message ?? localizations.formGreaterThanOrEqualTo(otherValue),
            state: state,
          );
        }
        break;
      case CompareType.less:
        if (compare >= 0) {
          return InvalidResult(
            message ?? localizations.formLessThan(otherValue),
            state: state,
          );
        }
        break;
      case CompareType.lessOrEqual:
        if (compare > 0) {
          return InvalidResult(
            message ?? localizations.formLessThanOrEqualTo(otherValue),
            state: state,
          );
        }
        break;
      case CompareType.equal:
        if (compare != 0) {
          return InvalidResult(
            message ?? localizations.formEqualTo(otherValue),
            state: state,
          );
        }
        break;
    }
    return null;
  }

  /// Performs `shouldRevalidate` logic for this form component.
  @override
  bool shouldRevalidate(FormKey<dynamic> source) {
    return source == key;
  }

  /// Compares this object with another for value equality.
  @override
  bool operator ==(Object other) {
    return other is CompareWith &&
        other.key == key &&
        other.type == type &&
        other.message == message;
  }

  @override
  int get hashCode => Object.hash(key, type, message);
}
