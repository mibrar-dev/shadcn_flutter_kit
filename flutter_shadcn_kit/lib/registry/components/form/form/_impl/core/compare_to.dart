// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../form.dart';

/// A validator that compares a value against a static comparison value.
///
/// [CompareTo] validates by comparing the field value against a fixed value
/// (unlike [CompareWith] which compares against another field). Supports
/// various comparison types.
///
/// Example:
/// ```dart
/// CompareTo.greaterOrEqual(
///   18,
///   message: 'Must be at least 18',
/// )
/// ```
class CompareTo<T extends Comparable<T>> extends Validator<T> {
  /// The value to compare against.
  final T? value;

  /// The type of comparison to perform.
  final CompareType type;

  /// Custom error message, or null to use default localized message.
  final String?
  message; // if null, use default message from ShadcnLocalizations

  /// Creates a [CompareTo] validator with the specified comparison type.
  const CompareTo(this.value, this.type, {this.message});

  /// Creates a validator that checks for equality with a value.
  const CompareTo.equal(this.value, {this.message}) : type = CompareType.equal;

  /// Creates a validator that checks if field value is greater than the specified value.
  const CompareTo.greater(this.value, {this.message})
    : type = CompareType.greater;

  /// Creates a validator that checks if field value is greater than or equal to the specified value.
  const CompareTo.greaterOrEqual(this.value, {this.message})
    : type = CompareType.greaterOrEqual;

  /// Creates a validator that checks if field value is less than the specified value.
  const CompareTo.less(this.value, {this.message}) : type = CompareType.less;

  /// Creates a validator that checks if field value is less than or equal to the specified value.
  const CompareTo.lessOrEqual(this.value, {this.message})
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
    var compare = _compare(value, this.value);
    switch (type) {
      case CompareType.greater:
        if (compare <= 0) {
          return InvalidResult(
            message ?? localizations.formGreaterThan(this.value),
            state: state,
          );
        }
        break;
      case CompareType.greaterOrEqual:
        if (compare < 0) {
          return InvalidResult(
            message ?? localizations.formGreaterThanOrEqualTo(this.value),
            state: state,
          );
        }
        break;
      case CompareType.less:
        if (compare >= 0) {
          return InvalidResult(
            message ?? localizations.formLessThan(this.value),
            state: state,
          );
        }
        break;
      case CompareType.lessOrEqual:
        if (compare > 0) {
          return InvalidResult(
            message ?? localizations.formLessThanOrEqualTo(this.value),
            state: state,
          );
        }
        break;
      case CompareType.equal:
        if (compare != 0) {
          return InvalidResult(
            message ?? localizations.formEqualTo(this.value),
            state: state,
          );
        }
        break;
    }
    return null;
  }

  /// Compares this object with another for value equality.
  @override
  bool operator ==(Object other) {
    return other is CompareTo &&
        other.value == value &&
        other.type == type &&
        other.message == message;
  }

  @override
  int get hashCode => Object.hash(value, type, message);
}
