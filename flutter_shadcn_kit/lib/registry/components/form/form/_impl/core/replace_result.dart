// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../form.dart';

/// A validation result that indicates a value should be replaced.
///
/// [ReplaceResult] is used when validation determines that the submitted
/// value should be transformed or replaced with a different value. For example,
/// trimming whitespace or formatting input.
class ReplaceResult<T> extends ValidationResult {
  /// The replacement value to use.
  final T value;

  /// Field storing `_key` for this form implementation.
  final FormKey? _key;

  /// Creates a [ReplaceResult] with the specified replacement value.
  const ReplaceResult(this.value, {required super.state}) : _key = null;

  /// Creates a [ReplaceResult] already attached to a form field key.
  const ReplaceResult.attached(
    this.value, {
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
  ReplaceResult<T> attach(FormKey key) {
    return ReplaceResult.attached(value, key: key, state: state);
  }
}
