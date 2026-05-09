// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../form.dart';

/// A validation result indicating that validation failed.
///
/// [InvalidResult] contains an error message describing why validation failed.
/// This is the most common validation result type returned by validators when
/// a value doesn't meet the validation criteria.
class InvalidResult extends ValidationResult {
  /// The error message describing the validation failure.
  final String message;

  /// Field storing `_key` for this form implementation.
  final FormKey? _key;

  /// Creates an [InvalidResult] with the specified error message.
  const InvalidResult(this.message, {required super.state}) : _key = null;

  /// Creates an [InvalidResult] already attached to a form field key.
  const InvalidResult.attached(
    this.message, {
    required FormKey key,
    required super.state,
  }) : _key = key;

  @override
  FormKey get key {
    assert(_key != null, 'The result has not been attached to a key');
    return _key!;
  }

  /// Performs `attach` logic for this form component.
  @override
  InvalidResult attach(FormKey key) {
    return InvalidResult.attached(message, key: key, state: state);
  }
}
