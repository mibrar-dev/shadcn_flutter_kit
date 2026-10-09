// @dart=3.13
import 'dart:async';

import 'package:flutter/foundation.dart' show ValueListenable;
import 'package:flutter/widgets.dart';

/// When a form field runs its validation.
enum FormValidationMode {
  /// Validation runs when the field is created or initialized.
  ///
  /// Useful for fields with defaults that should be checked immediately.
  initial,

  /// Validation runs after every value change.
  ///
  /// The common choice: immediate feedback while the user types.
  changed,

  /// Validation is deferred until the form is submitted.
  ///
  /// Reduces interruption for expensive checks.
  submitted,
}

/// Identifies one form field and the type of its value.
///
/// The key doubles as a [LocalKey], so it can be handed to widgets, and carries
/// its type parameter for type-safe value lookup:
///
/// ```dart
/// const emailKey = FormKey<String>('email');
/// const agreedKey = FormKey<bool>('agreed');
/// ```
class FormKey<T> extends LocalKey {
  /// Creates a [FormKey] wrapping [key].
  const FormKey(this.key);

  /// The underlying identity of this key.
  final Object key;

  /// The value type this key addresses.
  Type get type => T;

  /// Whether [value] is of this key's type.
  bool isInstanceOf(dynamic value) => value is T;

  /// Reads this key's value out of [values].
  T? getValue(FormMapValues values) => values.getValue(this);

  /// Shorthand for [getValue].
  T? operator [](FormMapValues values) => values.getValue(this);

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is FormKey && other.key == key);

  @override
  int get hashCode => key.hashCode;

  @override
  String toString() => 'FormKey($key)';
}

/// A map of form field keys to their current values.
typedef FormMapValues = Map<FormKey, dynamic>;

/// Typed reads over [FormMapValues].
extension FormMapValuesExtension on FormMapValues {
  /// Returns the value stored under [key], or null when absent.
  ///
  /// In debug builds a stored value of the wrong type trips an assertion.
  T? getValue<T>(FormKey<T> key) {
    final value = this[key];
    if (value == null) {
      return null;
    }
    assert(
      key.isInstanceOf(value),
      'The value for key $key is not of type ${key.type}',
    );
    return value as T?;
  }
}

/// The outcome of validating one form field.
///
/// The [state] records which [FormValidationMode] triggered the run, so
/// consumers can tell an on-submit failure from a live keystroke failure.
/// Subclasses such as `ReplaceResult` carry the payload.
abstract class ValidationResult {
  /// Creates a result produced during [state].
  const ValidationResult({required this.state});

  /// The validation mode that produced this result.
  final FormValidationMode state;

  /// The field this result belongs to.
  FormKey get key;

  /// Returns a copy of this result bound to [key].
  ValidationResult attach(FormKey key);
}

/// A validation result that asks the field to replace its value.
///
/// Validators use it to normalise input (trimming, formatting, upper-casing)
/// while still reporting through the normal validation channel.
class ReplaceResult<T> extends ValidationResult {
  /// Creates an unattached replacement of [value].
  const ReplaceResult(this.value, {required super.state}) : _key = null;

  /// Creates a replacement of [value] already bound to [_key].
  const ReplaceResult.attached(
    this.value, {
    required FormKey this._key,
    required super.state,
  });

  /// The replacement value.
  final T value;

  final FormKey? _key;

  @override
  FormKey get key {
    assert(_key != null, 'The result has not been attached to a key');
    return _key!;
  }

  @override
  ReplaceResult<T> attach(FormKey key) =>
      ReplaceResult.attached(value, key: key, state: state);
}

/// The form-facing side of one field's state.
///
/// Mixed into the `State` of every widget that participates in a form, so the
/// field can report values, be revalidated and expose its validity to the
/// nearest form.
mixin FormFieldHandle {
  /// Whether the field is still mounted.
  bool get mounted;

  /// The key identifying this field within its form.
  FormKey get formKey;

  /// Reports [value] to the form and triggers validation.
  ///
  /// Returns the validation result, or a future of it when validation is
  /// asynchronous.
  FutureOr<ValidationResult?> reportNewFormValue<T>(T? value);

  /// Re-runs validation against the current value.
  FutureOr<ValidationResult?> revalidate();

  /// Listenable for the current validation state; null until validation ran.
  ValueListenable<ValidationResult?>? get validity;
}

/// Builds a widget showing the validations still in flight.
///
/// [pending] maps a field key to the future its validation will complete with;
/// an empty map means nothing is pending.
typedef FormPendingWidgetBuilder = Widget Function(
  BuildContext context,
  Map<FormKey, Future<ValidationResult?>> pending,
  Widget? child,
);

/// Renders [builder] with the form validations that are still in flight.
///
/// This primitive has no knowledge of any form controller: it always reports an
/// empty pending map. A `ShadcnForm` that knows its own controller should drive
/// pending feedback from that controller directly.
class FormPendingBuilder extends StatelessWidget {
  /// Creates a pending builder that invokes [builder] with the pending map.
  const FormPendingBuilder({super.key, required this.builder, this.child});

  /// Widget handed to [builder] untouched.
  final Widget? child;

  /// Builds the pending display.
  final FormPendingWidgetBuilder builder;

  @override
  Widget build(BuildContext context) => builder(context, const {}, child);
}
