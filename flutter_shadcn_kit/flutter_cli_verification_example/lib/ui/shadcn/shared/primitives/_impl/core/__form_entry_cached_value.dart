part of '../../form_value_supplier.dart';


/// _FormEntryCachedValue defines a reusable type for this registry module.
class _FormEntryCachedValue {
/// Stores `value` state/configuration for this implementation.
  Object? value;

  _FormEntryCachedValue(this.value);
}

/// Mixin that provides form value management for stateful widgets.
mixin FormValueSupplier<T, X extends StatefulWidget> on State<X> {
/// Stores `_cachedValue` state/configuration for this implementation.
  _FormEntryCachedValue? _cachedValue;
/// Stores `_futureCounter` state/configuration for this implementation.
  int _futureCounter = 0;
/// Stores `_entryState` state/configuration for this implementation.
  FormFieldHandle? _entryState;

  /// Gets the current form value.
  T? get formValue => _cachedValue?.value as T?;

  /// Sets a new form value and triggers validation.
  set formValue(T? value) {
    if (_cachedValue != null && _cachedValue!.value == value) {
      return;
    }
    _cachedValue = _FormEntryCachedValue(value);
    _reportNewFormValue(value);
  }

  @override
/// Executes `didChangeDependencies` behavior for this component/composite.
  void didChangeDependencies() {
    super.didChangeDependencies();
    var newState = Data.maybeOf<FormFieldHandle>(context);
    if (newState != _entryState) {
      _entryState = newState;
      _reportNewFormValue(_cachedValue?.value as T?);
    }
  }

  /// Called when a form value is replaced by validation logic.
  @protected
  void didReplaceFormValue(T value);

/// Executes `_reportNewFormValue` behavior for this component/composite.
  void _reportNewFormValue(T? value) {
/// Stores `state` state/configuration for this implementation.
    var state = _entryState;
    if (state == null) {
      return;
    }
/// Stores `currentCounter` state/configuration for this implementation.
    final currentCounter = ++_futureCounter;
    var validationResult = state.reportNewFormValue<T>(value);
    if (validationResult is Future<ValidationResult?>) {
/// Creates a `validationResult.then` instance.
      validationResult.then((value) {
        if (_futureCounter == currentCounter) {
          if (value is ReplaceResult<T>) {
            WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
              if (context.mounted) {
                didReplaceFormValue(value.value);
              }
            });
          }
        }
      });
    } else if (validationResult is ReplaceResult<T>) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        if (context.mounted) {
          didReplaceFormValue(validationResult.value);
        }
      });
    }
  }
}
