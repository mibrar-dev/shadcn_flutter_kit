part of '../../form_value_supplier.dart';

/// ValidationResult defines a reusable type for this registry module.
abstract class ValidationResult {
  /// The form validation mode that triggered this result.
  final FormValidationMode state;

  /// Creates a [ValidationResult] with the specified validation state.
  const ValidationResult({required this.state});

  /// The form field key associated with this validation result.
  FormKey get key;

  /// Attaches a form field key to this validation result.
  ValidationResult attach(FormKey key);
}

/// A validation result that indicates a value should be replaced.
