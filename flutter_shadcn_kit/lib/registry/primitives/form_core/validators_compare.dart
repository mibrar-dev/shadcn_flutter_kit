// The password and cross-field/comparison validators.
//
// Split out of `validators.dart` so each file stays under the ~400-line
// guideline; `CompareWith` reads the other field through `FormController`
// and re-runs when that field changes.

import 'dart:async';

import 'package:flutter/widgets.dart';

import '../localizations/localizations.dart';
import 'form_controller.dart';
import 'form_core.dart';
import 'validation.dart';

/// Checks a password against the enabled character-class requirements.
class SafePasswordValidator extends Validator<String> {
  /// Creates a password-strength validator.
  const SafePasswordValidator({
    this.requireDigit = true,
    this.requireLowercase = true,
    this.requireUppercase = true,
    this.requireSpecialChar = true,
    this.message,
  });

  /// Whether a digit is required.
  final bool requireDigit;

  /// Whether a lowercase letter is required.
  final bool requireLowercase;

  /// Whether an uppercase letter is required.
  final bool requireUppercase;

  /// Whether a non-alphanumeric character is required.
  final bool requireSpecialChar;

  /// Overrides every message when set.
  final String? message;

  @override
  FutureOr<ValidationResult?> validate(
    BuildContext context,
    String? value,
    FormValidationMode lifecycle,
  ) {
    if (value == null) {
      return null;
    }
    final ShadcnLocalizations localizations = ShadcnLocalizations.of(context);
    if (requireDigit && !RegExp(r'\d').hasMatch(value)) {
      return InvalidResult(
        message ?? localizations.formPasswordDigits,
        state: lifecycle,
      );
    }
    if (requireLowercase && !RegExp(r'[a-z]').hasMatch(value)) {
      return InvalidResult(
        message ?? localizations.formPasswordLowercase,
        state: lifecycle,
      );
    }
    if (requireUppercase && !RegExp(r'[A-Z]').hasMatch(value)) {
      return InvalidResult(
        message ?? localizations.formPasswordUppercase,
        state: lifecycle,
      );
    }
    if (requireSpecialChar && !RegExp(r'[\W_]').hasMatch(value)) {
      return InvalidResult(
        message ?? localizations.formPasswordSpecial,
        state: lifecycle,
      );
    }
    return null;
  }

  @override
  bool operator ==(Object other) =>
      other is SafePasswordValidator &&
      other.requireDigit == requireDigit &&
      other.requireLowercase == requireLowercase &&
      other.requireUppercase == requireUppercase &&
      other.requireSpecialChar == requireSpecialChar &&
      other.message == message;

  @override
  int get hashCode => Object.hash(
    requireDigit,
    requireLowercase,
    requireUppercase,
    requireSpecialChar,
    message,
  );
}

/// Comparison operators used by [CompareTo] and [CompareWith].
enum CompareType {
  /// Value must be greater.
  greater,

  /// Value must be greater or equal.
  greaterOrEqual,

  /// Value must be less.
  less,

  /// Value must be less or equal.
  lessOrEqual,

  /// Values must be equal.
  equal,
}

int _compareValues<T extends Comparable<T>>(T? a, T? b) {
  if (a == null && b == null) {
    return 0;
  }
  if (a == null) {
    return -1;
  }
  if (b == null) {
    return 1;
  }
  return a.compareTo(b);
}

FutureOr<ValidationResult?> _compareResult<T extends Comparable<T>>(
  BuildContext context,
  CompareType type,
  int compare,
  T? other,
  FormValidationMode lifecycle,
  String? message,
) {
  final ShadcnLocalizations localizations = ShadcnLocalizations.of(context);
  final String described = describeValue(other);
  final String? failure = switch (type) {
    CompareType.greater when compare <= 0 =>
      message ?? localizations.formGreaterThan(described),
    CompareType.greaterOrEqual when compare < 0 =>
      message ?? localizations.formGreaterThanOrEqualTo(described),
    CompareType.less when compare >= 0 =>
      message ?? localizations.formLessThan(described),
    CompareType.lessOrEqual when compare > 0 =>
      message ?? localizations.formLessThanOrEqualTo(described),
    CompareType.equal when compare != 0 =>
      message ?? localizations.formEqualTo(described),
    _ => null,
  };
  return failure == null ? null : InvalidResult(failure, state: lifecycle);
}

/// Compares the value against a fixed value.
class CompareTo<T extends Comparable<T>> extends Validator<T> {
  /// Creates a comparison validator.
  const CompareTo(this.value, this.type, {this.message});

  /// Compares for equality.
  const CompareTo.equal(this.value, {this.message}) : type = CompareType.equal;

  /// Value must be greater.
  const CompareTo.greater(this.value, {this.message})
    : type = CompareType.greater;

  /// Value must be greater or equal.
  const CompareTo.greaterOrEqual(this.value, {this.message})
    : type = CompareType.greaterOrEqual;

  /// Value must be less.
  const CompareTo.less(this.value, {this.message}) : type = CompareType.less;

  /// Value must be less or equal.
  const CompareTo.lessOrEqual(this.value, {this.message})
    : type = CompareType.lessOrEqual;

  /// The value to compare against.
  final T? value;

  /// The comparison to perform.
  final CompareType type;

  /// Failure text.
  final String? message;

  @override
  FutureOr<ValidationResult?> validate(
    BuildContext context,
    T? value,
    FormValidationMode lifecycle,
  ) {
    return _compareResult<T>(
      context,
      type,
      _compareValues(value, this.value),
      this.value,
      lifecycle,
      message,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is CompareTo<T> &&
      other.value == value &&
      other.type == type &&
      other.message == message;

  @override
  int get hashCode => Object.hash(value, type, message);
}

/// Compares the value against another field's value.
class CompareWith<T extends Comparable<T>> extends Validator<T> {
  /// Creates a cross-field comparison validator.
  const CompareWith(this.key, this.type, {this.message});

  /// Compares for equality with another field.
  const CompareWith.equal(this.key, {this.message}) : type = CompareType.equal;

  /// Value must be greater than another field.
  const CompareWith.greater(this.key, {this.message})
    : type = CompareType.greater;

  /// Value must be greater or equal to another field.
  const CompareWith.greaterOrEqual(this.key, {this.message})
    : type = CompareType.greaterOrEqual;

  /// Value must be less than another field.
  const CompareWith.less(this.key, {this.message}) : type = CompareType.less;

  /// Value must be less or equal to another field.
  const CompareWith.lessOrEqual(this.key, {this.message})
    : type = CompareType.lessOrEqual;

  /// The other field's key.
  final FormKey<T> key;

  /// The comparison to perform.
  final CompareType type;

  /// Failure text.
  final String? message;

  @override
  FutureOr<ValidationResult?> validate(
    BuildContext context,
    T? value,
    FormValidationMode lifecycle,
  ) {
    final T? other = FormController.maybeOf(context)?.getValue<T>(key);
    return _compareResult<T>(
      context,
      type,
      _compareValues(value, other),
      other,
      lifecycle,
      message,
    );
  }

  @override
  bool shouldRevalidate(FormKey source) => source == key;

  @override
  bool operator ==(Object other) =>
      other is CompareWith<T> &&
      other.key == key &&
      other.type == type &&
      other.message == message;

  @override
  int get hashCode => Object.hash(key, type, message);
}
