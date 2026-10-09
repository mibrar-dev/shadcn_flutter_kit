// The form state machine: field registration, validation, cross-field
// revalidation, submission and the aggregated error/pending views.
//
// Ported from the old `form` component's `FormController` +
// `_ValidatorResultStash` + `SubmissionResult`, moved into `form_core` because
// the component folder is capped at two code files. Old defects fixed here:
// fields are detached when they unmount (the old `detach` was commented out, so
// values and validities leaked), revalidation runs with
// `FormValidationMode.submitted` (the old `forceRevalidate` path silently kept
// the `changed` mode), and the submission loop awaits every pending future.

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../../foundation/data.dart';
import 'form_core.dart';
import 'validation.dart';

/// Receives the values of a successfully submitted form.
typedef FormSubmitCallback = FutureOr<void> Function(FormMapValues values);

/// Outcome of [FormController.submit].
class SubmissionResult {
  /// Creates a submission result.
  const SubmissionResult({required this.values, required this.errors});

  /// The values of every attached field at submit time.
  final FormMapValues values;

  /// The validation failures at submit time.
  final Map<FormKey, ValidationResult> errors;

  /// Whether the form passed validation.
  bool get isValid => errors.isEmpty;

  @override
  String toString() => 'SubmissionResult($values, $errors)';

  @override
  bool operator ==(Object other) =>
      other is SubmissionResult &&
      mapEquals(other.values, values) &&
      mapEquals(other.errors, errors);

  @override
  int get hashCode => Object.hash(
    Object.hashAll(values.entries),
    Object.hashAll(errors.entries),
  );
}

/// Per-field registration snapshot.
class _FieldRegistration {
  _FieldRegistration({required this.value, required this.validator});

  Object? value;
  final Validator<Object?>? validator;
}

/// One field's latest validation result (synchronous or pending).
class _ResultStash {
  _ResultStash(this.result, this.mode);

  final FutureOr<ValidationResult?> result;
  final FormValidationMode mode;
}

/// Coordinates every field inside a `ShadcnForm`.
///
/// Fields attach when they mount (through `FormEntry`), report values, run
/// their validators and detach when they unmount. The controller never touches
/// widgets: it stores values, results and pending futures, and notifies
/// listeners after the current frame so validation started inside `build` is
/// safe.
class FormController extends ChangeNotifier {
  final Map<FormKey, _FieldRegistration> _fields =
      <FormKey, _FieldRegistration>{};
  final Map<FormKey, _ResultStash> _results = <FormKey, _ResultStash>{};
  bool _disposed = false;

  /// Called by [submit] after a successful validation.
  ///
  /// The `ShadcnForm` widget installs its `onSubmit` callback here while attached.
  FormSubmitCallback? onSubmit;

  /// The nearest controller, or null outside a form.
  static FormController? maybeOf(BuildContext context) =>
      Data.maybeOf<FormController>(context);

  /// The nearest controller; asserts outside a form.
  static FormController of(BuildContext context) =>
      Data.of<FormController>(context);

  /// Current values of every attached field.
  FormMapValues get values => <FormKey, Object?>{
    for (final MapEntry<FormKey, _FieldRegistration> entry in _fields.entries)
      entry.key: entry.value.value,
  };

  /// The latest validation result per field (may be a pending future).
  Map<FormKey, FutureOr<ValidationResult?>> get validities =>
      <FormKey, FutureOr<ValidationResult?>>{
        for (final MapEntry<FormKey, _ResultStash> entry in _results.entries)
          entry.key: entry.value.result,
      };

  /// Failures keyed by field; pending validations read as a [WaitingResult].
  Map<FormKey, ValidationResult> get errors {
    final Map<FormKey, ValidationResult> out = <FormKey, ValidationResult>{};
    for (final MapEntry<FormKey, _ResultStash> entry in _results.entries) {
      final FutureOr<ValidationResult?> result = entry.value.result;
      if (result is Future<ValidationResult?>) {
        out[entry.key] = WaitingResult.attached(
          key: entry.key,
          state: entry.value.mode,
        );
      } else if (result is ValidationResult) {
        out[entry.key] = result;
      }
    }
    return out;
  }

  /// Validations still in flight, keyed by field.
  Map<FormKey, Future<ValidationResult?>> get pending {
    final Map<FormKey, Future<ValidationResult?>> out =
        <FormKey, Future<ValidationResult?>>{};
    for (final MapEntry<FormKey, _ResultStash> entry in _results.entries) {
      final FutureOr<ValidationResult?> result = entry.value.result;
      if (result is Future<ValidationResult?>) {
        out[entry.key] = result;
      }
    }
    return out;
  }

  /// Whether no field currently reports a failure or a pending check.
  bool get isValid => errors.isEmpty;

  /// The value stored for [key], or null when absent.
  T? getValue<T>(FormKey<T> key) => _fields[key]?.value as T?;

  /// Whether [key] has a non-null value.
  bool hasValue(FormKey key) => _fields[key]?.value != null;

  /// The latest result for [key], pending future included.
  FutureOr<ValidationResult?>? getError(FormKey key) => _results[key]?.result;

  /// The synchronous result for [key]; a pending check reads as waiting.
  ValidationResult? getSyncError(FormKey key) {
    final _ResultStash? stash = _results[key];
    if (stash?.result is Future<ValidationResult?>) {
      return WaitingResult.attached(key: key, state: stash!.mode);
    }
    final FutureOr<ValidationResult?>? result = stash?.result;
    return result is ValidationResult ? result : null;
  }

  /// Registers [handle] with [value] and runs [validator].
  ///
  /// The first attach uses [FormValidationMode.initial], later value reports
  /// use `changed`, and [mode] overrides both (revalidation uses `submitted`).
  /// Fields whose validators declare a dependency on this key re-run too.
  FutureOr<ValidationResult?> attach(
    BuildContext context,
    FormFieldHandle handle,
    Object? value,
    Validator<Object?>? validator, {
    FormValidationMode? mode,
  }) {
    final FormKey key = handle.formKey;
    final _FieldRegistration? previous = _fields[key];
    _fields[key] = _FieldRegistration(value: value, validator: validator);
    final FormValidationMode lifecycle =
        mode ??
        (previous == null
            ? FormValidationMode.initial
            : FormValidationMode.changed);
    final FutureOr<ValidationResult?> result = _run(
      context,
      key,
      value,
      validator,
      lifecycle,
    );
    for (final MapEntry<FormKey, _FieldRegistration> entry in _fields.entries) {
      if (entry.key == key) {
        continue;
      }
      final Validator<Object?>? dependent = entry.value.validator;
      if (dependent != null && dependent.shouldRevalidate(key)) {
        _run(context, entry.key, entry.value.value, dependent, lifecycle);
      }
    }
    _notifySoon();
    return result;
  }

  /// Removes [handle] and its validation state.
  void detach(FormFieldHandle handle) {
    if (_fields.remove(handle.formKey) == null) {
      return;
    }
    _results.remove(handle.formKey);
    _notifySoon();
  }

  /// Re-runs every attached validator.
  void revalidateAll(
    BuildContext context, {
    FormValidationMode mode = FormValidationMode.submitted,
  }) {
    for (final MapEntry<FormKey, _FieldRegistration> entry in _fields.entries) {
      final Validator<Object?>? validator = entry.value.validator;
      if (validator != null) {
        _run(context, entry.key, entry.value.value, validator, mode);
      }
    }
    _notifySoon();
  }

  /// Revalidates everything, awaits pending checks and reports the outcome.
  ///
  /// Calls [onSubmit] with the values when the form is valid.
  Future<SubmissionResult> submit(BuildContext context) async {
    revalidateAll(context);
    await _drainPending();
    final SubmissionResult result = SubmissionResult(
      values: values,
      errors: errors,
    );
    if (result.isValid) {
      await onSubmit?.call(values);
    }
    return result;
  }

  Future<void> _drainPending() async {
    while (true) {
      final List<Future<ValidationResult?>> futures = pending.values.toList();
      if (futures.isEmpty) {
        return;
      }
      await Future.wait(futures);
    }
  }

  FutureOr<ValidationResult?> _run(
    BuildContext context,
    FormKey key,
    Object? value,
    Validator<Object?>? validator,
    FormValidationMode mode,
  ) {
    if (validator == null) {
      _results.remove(key);
      return null;
    }
    final FutureOr<ValidationResult?> result = validator.validate(
      context,
      value,
      mode,
    );
    _results[key] = _ResultStash(result, mode);
    if (result is Future<ValidationResult?>) {
      result.then((resolved) {
        if (_disposed || _results[key]?.result != result) {
          return;
        }
        _results[key] = _ResultStash(resolved?.attach(key), mode);
        _notifySoon();
      });
    } else if (result is ValidationResult) {
      _results[key] = _ResultStash(result.attach(key), mode);
    }
    return result;
  }

  void _notifySoon() {
    if (_disposed) {
      return;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_disposed) {
        notifyListeners();
      }
    });
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
