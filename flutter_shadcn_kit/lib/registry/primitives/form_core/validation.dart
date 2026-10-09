// Form validation primitives: the `Validator` contract, its result types and
// the combinators that let validators be composed per field.
//
// Ported from the old `form` component's `_impl/core` validator/result files
// (validator, invalid_result, waiting_result, composite/or/not,
// validation_mode, validator_builder). They live in `form_core` because the
// component folder is capped at two code files and every validator is form
// machinery, not UI.

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'form_core.dart';
import '../localizations/localizations.dart';

/// Renders a value for a validation message.
///
/// Integral numbers read without a trailing `.0` (`5` rather than `5.0`) and
/// the integer part is grouped with `,` separators (`1234.5` reads
/// `1,234.5`); anything else falls back to `toString`.
String formatDecimal(num value) {
  final bool isIntegral = value is int || value == value.truncateToDouble();
  final String text = isIntegral ? value.truncate().toString() : '$value';
  final int dot = text.indexOf('.');
  final String intPart = dot < 0 ? text : text.substring(0, dot);
  final String fracPart = dot < 0 ? '' : text.substring(dot);
  final bool negative = intPart.startsWith('-');
  final String digits = negative ? intPart.substring(1) : intPart;
  final StringBuffer grouped = StringBuffer();
  for (int i = 0; i < digits.length; i += 1) {
    if (i > 0 && (digits.length - i) % 3 == 0) {
      grouped.write(',');
    }
    grouped.write(digits[i]);
  }
  return '${negative ? '-' : ''}$grouped$fracPart';
}

/// Renders a value for a localized validation message.
String describeValue(Object? value) =>
    value is num ? formatDecimal(value) : '$value';

/// A validation result indicating the value is invalid.
class InvalidResult extends ValidationResult {
  /// Creates an unattached failure with [message].
  const InvalidResult(this.message, {required super.state}) : _key = null;

  /// Creates a failure already bound to [_key].
  const InvalidResult.attached(
    this.message, {
    required FormKey this._key,
    required super.state,
  });

  /// The error message shown to the user.
  final String message;

  final FormKey? _key;

  @override
  FormKey get key {
    assert(_key != null, 'The result has not been attached to a key');
    return _key!;
  }

  @override
  InvalidResult attach(FormKey key) =>
      InvalidResult.attached(message, key: key, state: state);
}

/// A validation result indicating the check is still running.
class WaitingResult extends ValidationResult {
  /// Creates a waiting result bound to [_key].
  const WaitingResult.attached({required this._key, required super.state});

  final FormKey _key;

  @override
  FormKey get key => _key;

  @override
  WaitingResult attach(FormKey key) =>
      WaitingResult.attached(key: key, state: state);
}

/// Builds a custom validator from a function.
///
/// ```dart
/// ValidatorBuilder<String>(
///   (value) => (value?.contains('@') ?? false)
///       ? null
///       : const InvalidResult('Must contain @', state: FormValidationMode.changed),
/// );
/// ```
class ValidatorBuilder<T> extends Validator<T> {
  /// Creates a validator around [builder].
  const ValidatorBuilder(this.builder, {this.dependencies = const <FormKey>[]});

  /// The function performing the check.
  final ValidatorBuilderFunction<T> builder;

  /// Keys this validator re-runs for when their value changes.
  final List<FormKey> dependencies;

  @override
  FutureOr<ValidationResult?> validate(
    BuildContext context,
    T? value,
    FormValidationMode lifecycle,
  ) {
    return builder(value);
  }

  @override
  bool shouldRevalidate(FormKey source) => dependencies.contains(source);

  @override
  bool operator ==(Object other) =>
      other is ValidatorBuilder<T> && other.builder == builder;

  @override
  int get hashCode => builder.hashCode;
}

/// Function shape accepted by [ValidatorBuilder].
typedef ValidatorBuilderFunction<T> =
    FutureOr<ValidationResult?> Function(T? value);

/// Base class of every field validator.
///
/// `&`/`+` compose with AND, `|` with OR, `~`/`-` negate. Validators that
/// depend on other fields override [shouldRevalidate].
abstract class Validator<T> {
  /// Creates a validator.
  const Validator();

  /// Runs the check; null means valid.
  FutureOr<ValidationResult?> validate(
    BuildContext context,
    T? value,
    FormValidationMode lifecycle,
  );

  /// Whether this validator must re-run when [source] changes value.
  bool shouldRevalidate(FormKey source) => false;

  /// AND-combines this validator with [other].
  Validator<T> combine(Validator<T> other) {
    return CompositeValidator<T>(<Validator<T>>[this, other]);
  }

  /// AND-combines this validator with [other].
  Validator<T> operator &(Validator<T> other) => combine(other);

  /// AND-combines this validator with [other].
  Validator<T> operator +(Validator<T> other) => combine(other);

  /// OR-combines this validator with [other].
  Validator<T> operator |(Validator<T> other) {
    return OrValidator<T>(<Validator<T>>[this, other]);
  }

  /// Negates this validator.
  Validator<T> operator ~() => NotValidator<T>(this);

  /// Negates this validator.
  Validator<T> operator -() => NotValidator<T>(this);
}

/// Runs its validators in order and stops at the first failure.
class CompositeValidator<T> extends Validator<T> {
  /// Creates a composite of [validators].
  const CompositeValidator(this.validators);

  /// The validators, run in order.
  final List<Validator<T>> validators;

  @override
  FutureOr<ValidationResult?> validate(
    BuildContext context,
    T? value,
    FormValidationMode lifecycle,
  ) {
    return _run(context, value, lifecycle, 0);
  }

  FutureOr<ValidationResult?> _run(
    BuildContext context,
    T? value,
    FormValidationMode lifecycle,
    int index,
  ) {
    if (index >= validators.length) {
      return null;
    }
    final FutureOr<ValidationResult?> result = validators[index].validate(
      context,
      value,
      lifecycle,
    );
    if (result is Future<ValidationResult?>) {
      return result.then((resolved) {
        if (resolved != null || !context.mounted) {
          return resolved;
        }
        return _run(context, value, lifecycle, index + 1);
      });
    }
    return result ?? _run(context, value, lifecycle, index + 1);
  }

  @override
  Validator<T> combine(Validator<T> other) =>
      CompositeValidator<T>(<Validator<T>>[...validators, other]);

  @override
  bool shouldRevalidate(FormKey source) =>
      validators.any((validator) => validator.shouldRevalidate(source));

  @override
  bool operator ==(Object other) =>
      other is CompositeValidator<T> &&
      listEquals(other.validators, validators);

  @override
  int get hashCode => Object.hashAll(validators);
}

/// Passes when at least one of its validators passes.
class OrValidator<T> extends Validator<T> {
  /// Creates an OR-combination of [validators].
  const OrValidator(this.validators);

  /// The validators, tried in order.
  final List<Validator<T>> validators;

  @override
  FutureOr<ValidationResult?> validate(
    BuildContext context,
    T? value,
    FormValidationMode lifecycle,
  ) {
    return _run(context, value, lifecycle, 0);
  }

  FutureOr<ValidationResult?> _run(
    BuildContext context,
    T? value,
    FormValidationMode lifecycle,
    int index,
  ) {
    if (index >= validators.length) {
      return null;
    }
    final FutureOr<ValidationResult?> result = validators[index].validate(
      context,
      value,
      lifecycle,
    );
    if (result is Future<ValidationResult?>) {
      return result.then((resolved) {
        if (resolved == null || !context.mounted) {
          return null;
        }
        return _run(context, value, lifecycle, index + 1);
      });
    }
    return result == null ? null : _run(context, value, lifecycle, index + 1);
  }

  @override
  bool shouldRevalidate(FormKey source) =>
      validators.any((validator) => validator.shouldRevalidate(source));

  @override
  bool operator ==(Object other) =>
      other is OrValidator<T> && listEquals(other.validators, validators);

  @override
  int get hashCode => Object.hashAll(validators);
}

/// Passes when the wrapped validator fails.
class NotValidator<T> extends Validator<T> {
  /// Creates a negation of [validator].
  const NotValidator(this.validator, {this.message});

  /// The validator to negate.
  final Validator<T> validator;

  /// Failure text; null uses the localized generic message.
  final String? message;

  @override
  FutureOr<ValidationResult?> validate(
    BuildContext context,
    T? value,
    FormValidationMode lifecycle,
  ) {
    final String text = message ?? ShadcnLocalizations.of(context).invalidValue;
    final FutureOr<ValidationResult?> result = validator.validate(
      context,
      value,
      lifecycle,
    );
    if (result is Future<ValidationResult?>) {
      return result.then(
        (resolved) =>
            resolved == null ? InvalidResult(text, state: lifecycle) : null,
      );
    }
    return result == null ? InvalidResult(text, state: lifecycle) : null;
  }

  @override
  bool shouldRevalidate(FormKey source) => validator.shouldRevalidate(source);

  @override
  bool operator ==(Object other) =>
      other is NotValidator<T> &&
      other.validator == validator &&
      other.message == message;

  @override
  int get hashCode => Object.hash(validator, message);
}

/// Runs the wrapped validator only during the listed [FormValidationMode]s.
class ValidationMode<T> extends Validator<T> {
  /// Creates a mode-gated validator.
  const ValidationMode(
    this.validator, {
    this.mode = const <FormValidationMode>{
      FormValidationMode.initial,
      FormValidationMode.changed,
      FormValidationMode.submitted,
    },
  });

  /// The wrapped validator.
  final Validator<T> validator;

  /// Modes during which [validator] runs.
  final Set<FormValidationMode> mode;

  @override
  FutureOr<ValidationResult?> validate(
    BuildContext context,
    T? value,
    FormValidationMode lifecycle,
  ) {
    if (!mode.contains(lifecycle)) {
      return null;
    }
    return validator.validate(context, value, lifecycle);
  }

  @override
  bool shouldRevalidate(FormKey source) => validator.shouldRevalidate(source);

  @override
  bool operator ==(Object other) =>
      other is ValidationMode<T> &&
      other.validator == validator &&
      other.mode == mode;

  @override
  int get hashCode => Object.hash(validator, mode);
}
