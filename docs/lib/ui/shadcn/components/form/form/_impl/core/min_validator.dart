// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../form.dart';

/// A validator that checks if a numeric value meets a minimum threshold.
///
/// [MinValidator] ensures that numeric values are greater than (or equal to)
/// a specified minimum value. Useful for enforcing minimum quantities, ages, etc.
///
/// Example:
/// ```dart
/// MinValidator<int>(
///   18,
///   inclusive: true,
///   message: 'Must be at least 18 years old',
/// )
/// ```
class MinValidator<T extends num> extends Validator<T> {
  /// The minimum acceptable value.
  final T min;

  /// Whether the minimum value itself is acceptable (true) or must be exceeded (false).
  final bool inclusive;

  /// Custom error message, or null to use default localized message.
  final String?
  message; // if null, use default message from ShadcnLocalizations

  /// Creates a [MinValidator] with the specified minimum value.
  const MinValidator(this.min, {this.inclusive = true, this.message});

  @override
  FutureOr<ValidationResult?> validate(
    BuildContext context,
    T? value,
    FormValidationMode state,
  ) {
    if (value == null) {
      return null;
    }
    if (inclusive) {
      if (value < min) {
        return InvalidResult(
          message ??
              Localizations.of(
                context,
                ShadcnLocalizations,
              ).formGreaterThanOrEqualTo(min),
          state: state,
        );
      }
    } else {
      if (value <= min) {
        return InvalidResult(
          message ??
              Localizations.of(
                context,
                ShadcnLocalizations,
              ).formGreaterThan(min),
          state: state,
        );
      }
    }
    return null;
  }

  /// Compares this object with another for value equality.
  @override
  bool operator ==(Object other) {
    return other is MinValidator &&
        other.min == min &&
        other.inclusive == inclusive &&
        other.message == message;
  }

  @override
  int get hashCode => Object.hash(min, inclusive, message);
}
