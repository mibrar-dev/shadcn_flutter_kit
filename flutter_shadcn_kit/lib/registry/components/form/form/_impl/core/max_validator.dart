// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../form.dart';

/// A validator that checks if a numeric value does not exceed a maximum threshold.
///
/// [MaxValidator] ensures that numeric values are less than (or equal to)
/// a specified maximum value. Useful for enforcing maximum quantities, limits, etc.
///
/// Example:
/// ```dart
/// MaxValidator<int>(
///   100,
///   inclusive: true,
///   message: 'Must not exceed 100',
/// )
/// ```
class MaxValidator<T extends num> extends Validator<T> {
  /// The maximum acceptable value.
  final T max;

  /// Whether the maximum value itself is acceptable (true) or must not be reached (false).
  final bool inclusive;

  /// Custom error message, or null to use default localized message.
  final String?
  message; // if null, use default message from ShadcnLocalizations

  /// Creates a [MaxValidator] with the specified maximum value.
  const MaxValidator(this.max, {this.inclusive = true, this.message});

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
      if (value > max) {
        return InvalidResult(
          message ??
              Localizations.of(
                context,
                ShadcnLocalizations,
              ).formLessThanOrEqualTo(max),
          state: state,
        );
      }
    } else {
      if (value >= max) {
        return InvalidResult(
          message ??
              Localizations.of(context, ShadcnLocalizations).formLessThan(max),
          state: state,
        );
      }
    }
    return null;
  }

  /// Compares this object with another for value equality.
  @override
  bool operator ==(Object other) {
    return other is MaxValidator &&
        other.max == max &&
        other.inclusive == inclusive &&
        other.message == message;
  }

  @override
  int get hashCode => Object.hash(max, inclusive, message);
}
