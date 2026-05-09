// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../form.dart';

/// A validator that checks if a numeric value falls within a specified range.
///
/// [RangeValidator] ensures values are between minimum and maximum bounds.
/// Both bounds can be inclusive or exclusive depending on configuration.
///
/// Example:
/// ```dart
/// RangeValidator<double>(
///   0.0,
///   100.0,
///   inclusive: true,
///   message: 'Must be between 0 and 100',
/// )
/// ```
class RangeValidator<T extends num> extends Validator<T> {
  /// The minimum acceptable value.
  final T min;

  /// The maximum acceptable value.
  final T max;

  /// Whether the bounds are inclusive (true) or exclusive (false).
  final bool inclusive;

  /// Custom error message, or null to use default localized message.
  final String?
  message; // if null, use default message from ShadcnLocalizations

  /// Creates a [RangeValidator] with the specified min and max bounds.
  const RangeValidator(
    this.min,
    this.max, {
    this.inclusive = true,
    this.message,
  });

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
      if (value < min || value > max) {
        return InvalidResult(
          message ??
              Localizations.of(
                context,
                ShadcnLocalizations,
              ).formBetweenInclusively(min, max),
          state: state,
        );
      }
    } else {
      if (value <= min || value >= max) {
        return InvalidResult(
          message ??
              Localizations.of(
                context,
                ShadcnLocalizations,
              ).formBetweenExclusively(min, max),
          state: state,
        );
      }
    }
    return null;
  }

  /// Compares this object with another for value equality.
  @override
  bool operator ==(Object other) {
    return other is RangeValidator &&
        other.min == min &&
        other.max == max &&
        other.inclusive == inclusive &&
        other.message == message;
  }

  @override
  int get hashCode => Object.hash(min, max, inclusive, message);
}
