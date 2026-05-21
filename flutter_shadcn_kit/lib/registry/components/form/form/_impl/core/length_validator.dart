// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../form.dart';

/// A validator that checks if a string's length is within specified bounds.
///
/// [LengthValidator] validates that a string's length falls within the minimum
/// and/or maximum bounds. Either bound can be null to check only one direction.
///
/// Example:
/// ```dart
/// LengthValidator(
///   min: 3,
///   max: 20,
///   message: 'Must be between 3 and 20 characters',
/// )
/// ```
class LengthValidator extends Validator<String> {
  /// Minimum length requirement (inclusive), or null for no minimum.
  final int? min;

  /// Maximum length requirement (inclusive), or null for no maximum.
  final int? max;

  /// Custom error message, or null to use default localized message.
  final String?
  message; // if null, use default message from ShadcnLocalizations

  /// Creates a [LengthValidator] with optional min/max bounds.
  const LengthValidator({this.min, this.max, this.message});

  @override
  FutureOr<ValidationResult?> validate(
    BuildContext context,
    String? value,
    FormValidationMode state,
  ) {
    if (value == null) {
      if (min != null) {
        return InvalidResult(
          message ??
              Localizations.of(
                context,
                ShadcnLocalizations,
              ).formLengthGreaterThan(min!),
          state: state,
        );
      }
      return null;
    }
    ShadcnLocalizations localizations = Localizations.of(
      context,
      ShadcnLocalizations,
    );
    if (min != null && value.length < min!) {
      return InvalidResult(
        message ?? localizations.formLengthGreaterThan(min!),
        state: state,
      );
    }
    if (max != null && value.length > max!) {
      return InvalidResult(
        message ?? localizations.formLengthLessThan(max!),
        state: state,
      );
    }
    return null;
  }

  /// Compares this object with another for value equality.
  @override
  bool operator ==(Object other) {
    return other is LengthValidator &&
        other.min == min &&
        other.max == max &&
        other.message == message;
  }

  @override
  int get hashCode => Object.hash(min, max, message);
}
