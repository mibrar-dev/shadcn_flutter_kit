import 'dart:async';

import 'package:flutter/widgets.dart';

import '../../foundation/data.dart';
import 'form_core.dart';

/// Mutable box around a form entry's value.
///
/// The indirection keeps [FormValueSupplier] free to swap the stored value
/// without ever handing out a `null` that could be confused with "no value".
class _FormEntryCachedValue {
  _FormEntryCachedValue(this.value);

  Object? value;
}

/// Adds form participation to a `State`.
///
/// Mix into the state of any widget that owns a form value. The mixin keeps the
/// value, registers with the nearest [FormFieldHandle] provided by a form, and
/// applies replacements when validation returns a [ReplaceResult].
///
/// Implementations only need [didReplaceFormValue]; read [formValue] to render
/// the current value and assign to it to push changes.
mixin FormValueSupplier<T, X extends StatefulWidget> on State<X> {
  _FormEntryCachedValue? _cachedValue;

  /// Guards against applying a stale async validation result: only the result
  /// belonging to the most recent value change is honoured.
  int _futureCounter = 0;

  FormFieldHandle? _fieldHandle;

  /// The value currently reported to the form.
  T? get formValue => _cachedValue?.value as T?;

  /// Sets the value and reports it, unless it is unchanged.
  set formValue(T? value) {
    if (_cachedValue != null && _cachedValue!.value == value) {
      return;
    }
    _cachedValue = _FormEntryCachedValue(value);
    _reportNewFormValue(value);
  }

  /// Called when validation returned a [ReplaceResult] for the current value.
  ///
  /// Runs after the current frame so the widget is safe to rebuild in.
  @protected
  void didReplaceFormValue(T value);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final handle = Data.maybeOf<FormFieldHandle>(context);
    if (handle != _fieldHandle) {
      _fieldHandle = handle;
      _reportNewFormValue(_cachedValue?.value as T?);
    }
  }

  void _reportNewFormValue(T? value) {
    final handle = _fieldHandle;
    if (handle == null) {
      return;
    }
    final currentCounter = ++_futureCounter;
    final result = handle.reportNewFormValue<T>(value);
    if (result is Future<ValidationResult?>) {
      result.then((resolved) {
        if (_futureCounter != currentCounter) {
          return;
        }
        if (resolved is ReplaceResult<T>) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            // `mounted`, not `context.mounted`: reading `context` on a defunct
            // State throws, and this callback can outlive the widget.
            if (mounted) {
              didReplaceFormValue(resolved.value);
            }
          });
        }
      });
    } else if (result is ReplaceResult<T>) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          didReplaceFormValue(result.value);
        }
      });
    }
  }
}
