part of '../../form_value_supplier.dart';

/// ReplaceResult defines a reusable type for this registry module.
class ReplaceResult<T> extends ValidationResult {
  /// The replacement value to use.
  final T value;

/// Stores `_key` state/configuration for this implementation.
  final FormKey? _key;

  /// Creates a [ReplaceResult] with the specified replacement value.
  const ReplaceResult(this.value, {required super.state}) : _key = null;

  /// Creates a [ReplaceResult] already attached to a form field key.
  const ReplaceResult.attached(this.value,
      {required FormKey key, required super.state})
      : _key = key;

  @override
  FormKey get key {
    assert(_key != null, 'The result has not been attached to a key');
    return _key!;
  }

  @override
/// Executes `attach` behavior for this component/composite.
  ReplaceResult<T> attach(FormKey key) {
    return ReplaceResult.attached(value, key: key, state: state);
  }
}

/// Interface for form field state management.
mixin FormFieldHandle {
  /// Whether the widget is currently mounted in the widget tree.
  bool get mounted;

  /// The unique key identifying this field within its form.
  FormKey get formKey;

  /// Reports a new value to the form and triggers validation.
  FutureOr<ValidationResult?> reportNewFormValue<T>(T? value);

  /// Re-runs validation on the current value.
  FutureOr<ValidationResult?> revalidate();

  /// A listenable for the current validation state.
  ValueListenable<ValidationResult?>? get validity;
}
