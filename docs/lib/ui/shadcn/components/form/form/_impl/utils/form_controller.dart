// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../form.dart';

/// Controller for managing form state, validation, and submission.
///
/// The FormController coordinates all form field interactions, maintaining
/// a centralized registry of field values and validation states. It provides
/// programmatic access to form data collection, validation triggering, and
/// submission handling.
///
/// The controller automatically manages the lifecycle of form fields as they
/// register and unregister, tracking their values and validation results.
/// It supports both synchronous and asynchronous validation, cross-field
/// validation dependencies, and comprehensive error state management.
///
/// Example:
/// ```dart
/// final controller = FormController();
///
/// // Listen to form state changes
/// controller.addListener(() {
///   print('Form validity: ${controller.isValid}');
///   print('Form values: ${controller.values}');
/// });
///
/// // Submit the form
/// await controller.submit();
///
/// // Access specific field values
/// final emailValue = controller.getValue(emailKey);
/// ```
class FormController extends ChangeNotifier {
  /// Field storing `_attachedInputs` for this form implementation.
  final Map<FormKey, FormValueState> _attachedInputs = {};

  /// Field storing `_validity` for this form implementation.
  final Map<FormKey, _ValidatorResultStash> _validity = {};

  /// Field storing `_disposed` for this form implementation.
  bool _disposed = false;

  /// A map of all current form field values keyed by their [FormKey].
  ///
  /// This getter provides access to the current state of all registered form
  /// fields. The map is rebuilt on each access to reflect the latest values
  /// from all active form fields.
  ///
  /// Returns a `Map<FormKey, Object?>` where each key corresponds to a form field
  /// and each value is the current value of that field.
  Map<FormKey, Object?> get values {
    return {
      for (var entry in _attachedInputs.entries) entry.key: entry.value.value,
    };
  }

  /// Releases resources owned by this state object.
  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  /// A map of all current validation results keyed by their [FormKey].
  ///
  /// This getter provides access to the validation state of all registered
  /// form fields. Values can be either synchronous ValidationResult objects
  /// or `Future<ValidationResult?>` for asynchronous validation.
  ///
  /// Returns a `Map<FormKey, FutureOr<ValidationResult?>>` representing the
  /// current validation state of all form fields.
  Map<FormKey, FutureOr<ValidationResult?>> get validities {
    return {for (var entry in _validity.entries) entry.key: entry.value.result};
  }

  /// A map of all current validation errors keyed by their [FormKey].
  ///
  /// This getter filters the validation results to only include fields with
  /// validation errors. For asynchronous validations that are still pending,
  /// a [WaitingResult] is included to indicate the validation is in progress.
  ///
  /// Returns a `Map<FormKey, ValidationResult>` containing only fields with errors.
  Map<FormKey, ValidationResult> get errors {
    final errors = <FormKey, ValidationResult>{};
    for (var entry in _validity.entries) {
      var result = entry.value.result;
      if (result is Future<ValidationResult?>) {
        errors[entry.key] = WaitingResult.attached(
          state: entry.value.state,
          key: entry.key,
        );
      } else if (result != null) {
        errors[entry.key] = result;
      }
    }
    return errors;
  }

  /// Retrieves the validation result for a specific form field.
  ///
  /// This method returns the current validation state for the specified form key,
  /// which can be either a synchronous ValidationResult or a Future for asynchronous
  /// validation. Returns null if no validation result exists for the key.
  ///
  /// Parameters:
  /// - [key] (FormKey): The form key to get validation result for
  ///
  /// Returns the validation result or null if none exists.
  FutureOr<ValidationResult?>? getError(FormKey key) {
    return _validity[key]?.result;
  }

  /// Retrieves the synchronous validation result for a specific form field.
  ///
  /// This method returns the current validation state for the specified form key,
  /// converting asynchronous validations to [WaitingResult] objects. This provides
  /// a synchronous interface for accessing validation states.
  ///
  /// Parameters:
  /// - [key] (FormKey): The form key to get validation result for
  ///
  /// Returns the synchronous validation result or null if valid.
  ValidationResult? getSyncError(FormKey key) {
    var entry = _validity[key];
    var result = entry?.result;
    if (result is Future<ValidationResult?>) {
      return WaitingResult.attached(state: entry!.state, key: key);
    }
    return result;
  }

  /// Retrieves the current value for a specific form field.
  ///
  /// Parameters:
  /// - [key] (`FormKey<T>`, required): The form key to look up.
  ///
  /// Returns: `T?` — the field value if exists, null otherwise.
  T? getValue<T>(FormKey<T> key) {
    return _attachedInputs[key]?.value as T?;
  }

  /// Checks if a form field has a non-null value.
  ///
  /// Parameters:
  /// - [key] (`FormKey`, required): The form key to check.
  ///
  /// Returns: `bool` — true if field has a value, false otherwise.
  bool hasValue(FormKey key) {
    return _attachedInputs[key]?.value != null;
  }

  /// Revalidates all form fields with validators.
  ///
  /// Runs validation on all registered fields and updates their validation states.
  /// Supports both synchronous and asynchronous validators.
  ///
  /// Parameters:
  /// - [context] (`BuildContext`, required): The build context.
  /// - [state] (`FormValidationMode`, required): Validation mode to use.
  void revalidate(BuildContext context, FormValidationMode state) {
    bool changed = false;
    for (var entry in _attachedInputs.entries) {
      var key = entry.key;
      var value = entry.value;
      if (value.validator != null) {
        var future = value.validator!.validate(context, value.value, state);
        if (_validity[key]?.result != future) {
          if (future is Future<ValidationResult?>) {
            _validity[key] = _ValidatorResultStash(future, state);
            future.then((value) {
              if (_validity[key]?.result == future) {
                _validity[key] = _ValidatorResultStash(
                  value?.attach(key),
                  state,
                );
                WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                  if (_disposed) {
                    return;
                  }
                  notifyListeners();
                });
              }
            });
          } else {
            _validity[key] = _ValidatorResultStash(future, state);
          }
          changed = true;
        }
      }
    }
    if (changed) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        if (_disposed) {
          return;
        }
        notifyListeners();
      });
    }
  }

  /// Attaches a form field to this controller.
  ///
  /// Registers the field and runs initial validation if a validator is provided.
  /// Manages field lifecycle transitions (initial → changed) and coordinates
  /// revalidation of dependent fields.
  ///
  /// Parameters:
  /// - [context] (`BuildContext`, required): The build context.
  /// - [handle] (`FormFieldHandle`, required): The field handle to attach.
  /// - [value] (`Object?`, required): Current field value.
  /// - [validator] (`Validator?`, optional): Validation function.
  /// - [forceRevalidate] (`bool`, default: `false`): Force revalidation even if unchanged.
  ///
  /// Returns: `FutureOr<ValidationResult?>` — validation result if applicable.
  FutureOr<ValidationResult?> attach(
    BuildContext context,
    FormFieldHandle handle,
    Object? value,
    Validator? validator, [
    bool forceRevalidate = false,
  ]) {
    final key = handle.formKey;

    final oldState = _attachedInputs[key];
    var state = FormValueState(value: value, validator: validator);
    if (oldState == state && !forceRevalidate) {
      return _validity[key]?.result;
    }
    var lifecycle = oldState == null
        ? FormValidationMode.initial
        : FormValidationMode.changed;
    _attachedInputs[key] = state;
    // validate
    var future = validator?.validate(context, value, lifecycle);
    if (future is Future<ValidationResult?>) {
      _validity[key] = _ValidatorResultStash(future, lifecycle);
      future.then((value) {
        // resolve the future and store synchronous value
        if (_validity[key]?.result == future) {
          _validity[key] = _ValidatorResultStash(value?.attach(key), lifecycle);
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            if (_disposed) {
              return;
            }
            notifyListeners();
          });
        }
      });
    } else {
      _validity[key] = _ValidatorResultStash(future, lifecycle);
    }
    // check for revalidation
    Map<FormKey, FutureOr<ValidationResult?>> revalidate = {};
    for (var entry in _attachedInputs.entries) {
      var k = entry.key;

      var value = entry.value;
      if (key == k) {
        continue;
      }
      if (value.validator != null && value.validator!.shouldRevalidate(key)) {
        var revalidateResult = value.validator!.validate(
          context,
          value.value,
          lifecycle,
        );
        revalidate[k] = revalidateResult;
      }
    }
    for (var entry in revalidate.entries) {
      var k = entry.key;

      var future = entry.value;

      var attachedInput = _attachedInputs[k]!;
      attachedInput = FormValueState(
        value: attachedInput.value,
        validator: attachedInput.validator,
      );
      _attachedInputs[k] = attachedInput;
      if (future is Future<ValidationResult?>) {
        _validity[k] = _ValidatorResultStash(future, lifecycle);
        future.then((value) {
          if (_validity[k]?.result == future) {
            _validity[k] = _ValidatorResultStash(value?.attach(k), lifecycle);
            WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
              if (_disposed) {
                return;
              }
              notifyListeners();
            });
          }
        });
      } else {
        _validity[k] = _ValidatorResultStash(future, lifecycle);
      }
    }
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (_disposed) {
        return;
      }
      notifyListeners();
    });
    return _validity[key]?.result;
  }

  // void detach(FormFieldHandle key) {
  //   if (_attachedInputs.containsKey(key)) {
  //     final oldValue = _attachedInputs.remove(key);
  //     _validity.remove(key);
  //     WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
  //       if (_disposed) {
  //         return;
  //       }
  //       notifyListeners();
  //     });
  //   }
  // }
}
