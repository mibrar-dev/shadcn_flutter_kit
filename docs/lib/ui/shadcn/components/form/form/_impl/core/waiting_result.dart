// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../form.dart';

/// Validation result indicating a validation is in progress.
///
/// Used when asynchronous validation is being performed and the result
/// is not yet available.
class WaitingResult extends ValidationResult {
  /// Field storing `_key` for this form implementation.
  final FormKey? _key;

  /// Creates a waiting result attached to a form key.
  const WaitingResult.attached({required FormKey key, required super.state})
    : _key = key;

  @override
  FormKey get key {
    assert(_key != null, 'The result has not been attached to a key');
    return _key!;
  }

  /// Performs `attach` logic for this form component.
  @override
  WaitingResult attach(FormKey key) {
    return WaitingResult.attached(key: key, state: state);
  }
}
