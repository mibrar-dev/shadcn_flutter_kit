// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../form.dart';

/// A validator wrapper that controls when validation occurs based on form lifecycle.
///
/// [ValidationMode] wraps another validator and only executes it during specific
/// validation modes. This allows fine-grained control over when validation rules
/// are applied during the form lifecycle (initial load, value changes, submission).
///
/// Example:
/// ```dart
/// ValidationMode(
///   EmailValidator(),
///   mode: {FormValidationMode.changed, FormValidationMode.submitted},
/// )
/// ```
class ValidationMode<T> extends Validator<T> {
  /// The underlying validator to execute when mode conditions are met.
  final Validator<T> validator;

  /// The set of validation modes during which this validator should run.
  final Set<FormValidationMode> mode;

  /// Creates a [ValidationMode] that conditionally validates based on lifecycle mode.
  const ValidationMode(
    this.validator, {
    this.mode = const {
      FormValidationMode.changed,
      FormValidationMode.submitted,
      FormValidationMode.initial,
    },
  });

  @override
  FutureOr<ValidationResult?> validate(
    BuildContext context,
    T? value,
    FormValidationMode lifecycle,
  ) {
    if (mode.contains(lifecycle)) {
      return validator.validate(context, value, lifecycle);
    }
    return null;
  }

  /// Compares this object with another for value equality.
  @override
  operator ==(Object other) {
    return other is ValidationMode &&
        other.validator == validator &&
        other.mode == mode;
  }

  @override
  int get hashCode => Object.hash(validator, mode);
}
