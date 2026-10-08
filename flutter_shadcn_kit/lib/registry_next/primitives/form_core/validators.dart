// The built-in field validators.
//
// Ported from the old `form` component's `_impl/core` validator files. The
// messages come from `ShadcnLocalizations` (the keys already existed in the
// primitives layer). Two checks are local implementations instead of third-
// party packages:
//
// * `EmailValidator` uses a pragmatic `local@domain.tld` pattern (the old
//   `email_validator` package would add a pub dependency to every install);
// * `URLValidator` requires a scheme and a host, because `Uri.parse` accepts
//   almost any string and the old check therefore never failed.

import 'dart:async';

import 'package:flutter/widgets.dart';

import '../localizations/localizations.dart';
import 'form_controller.dart';
import 'form_core.dart';
import 'validation.dart';

/// Pragmatic e-mail shape: `local@domain.tld`, no spaces.
final RegExp _emailPattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

/// Fails when the value is null.
class NonNullValidator<T> extends Validator<T> {
  /// Creates a non-null validator.
  const NonNullValidator({this.message});

  /// Failure text; null uses `formNotEmpty`.
  final String? message;

  @override
  FutureOr<ValidationResult?> validate(
    BuildContext context,
    T? value,
    FormValidationMode lifecycle,
  ) {
    if (value == null) {
      return InvalidResult(
        message ?? ShadcnLocalizations.of(context).formNotEmpty,
        state: lifecycle,
      );
    }
    return null;
  }

  @override
  bool operator ==(Object other) =>
      other is NonNullValidator<T> && other.message == message;

  @override
  int get hashCode => message.hashCode;
}

/// Fails when a string is null or empty.
class NotEmptyValidator extends NonNullValidator<String> {
  /// Creates a non-empty validator.
  const NotEmptyValidator({super.message});

  @override
  FutureOr<ValidationResult?> validate(
    BuildContext context,
    String? value,
    FormValidationMode lifecycle,
  ) {
    if (value == null || value.isEmpty) {
      return InvalidResult(
        message ?? ShadcnLocalizations.of(context).formNotEmpty,
        state: lifecycle,
      );
    }
    return null;
  }

  @override
  bool operator ==(Object other) =>
      other is NotEmptyValidator && other.message == message;

  @override
  int get hashCode => message.hashCode;
}

/// Bounds a string's length.
class LengthValidator extends Validator<String> {
  /// Creates a length validator; null bounds are not checked.
  const LengthValidator({this.min, this.max, this.message});

  /// Minimum length (inclusive).
  final int? min;

  /// Maximum length (inclusive).
  final int? max;

  /// Failure text; null uses the localized bound messages.
  final String? message;

  @override
  FutureOr<ValidationResult?> validate(
    BuildContext context,
    String? value,
    FormValidationMode lifecycle,
  ) {
    final ShadcnLocalizations localizations = ShadcnLocalizations.of(context);
    final int? minimum = min;
    if (value == null) {
      return minimum == null
          ? null
          : InvalidResult(
              message ?? localizations.formLengthLessThan(minimum),
              state: lifecycle,
            );
    }
    if (minimum != null && value.length < minimum) {
      return InvalidResult(
        message ?? localizations.formLengthLessThan(minimum),
        state: lifecycle,
      );
    }
    final int? maximum = max;
    if (maximum != null && value.length > maximum) {
      return InvalidResult(
        message ?? localizations.formLengthGreaterThan(maximum),
        state: lifecycle,
      );
    }
    return null;
  }

  @override
  bool operator ==(Object other) =>
      other is LengthValidator &&
      other.min == min &&
      other.max == max &&
      other.message == message;

  @override
  int get hashCode => Object.hash(min, max, message);
}

/// Bounds a numeric value, inclusively or exclusively.
class RangeValidator<T extends num> extends Validator<T> {
  /// Creates a range validator.
  const RangeValidator(
    this.min,
    this.max, {
    this.inclusive = true,
    this.message,
  });

  /// Lower bound.
  final T min;

  /// Upper bound.
  final T max;

  /// Whether the bounds themselves are accepted.
  final bool inclusive;

  /// Failure text; null uses the localized range messages.
  final String? message;

  @override
  FutureOr<ValidationResult?> validate(
    BuildContext context,
    T? value,
    FormValidationMode lifecycle,
  ) {
    if (value == null) {
      return null;
    }
    final bool outside = inclusive
        ? value < min || value > max
        : value <= min || value >= max;
    if (!outside) {
      return null;
    }
    final ShadcnLocalizations localizations = ShadcnLocalizations.of(context);
    final String fallback = inclusive
        ? localizations.formBetweenInclusively(
            describeValue(min),
            describeValue(max),
          )
        : localizations.formBetweenExclusively(
            describeValue(min),
            describeValue(max),
          );
    return InvalidResult(message ?? fallback, state: lifecycle);
  }

  @override
  bool operator ==(Object other) =>
      other is RangeValidator<T> &&
      other.min == min &&
      other.max == max &&
      other.inclusive == inclusive &&
      other.message == message;

  @override
  int get hashCode => Object.hash(min, max, inclusive, message);
}

/// Requires a string to match [pattern].
class RegexValidator extends Validator<String> {
  /// Creates a regex validator.
  const RegexValidator(this.pattern, {this.message});

  /// Pattern the value must match.
  final RegExp pattern;

  /// Failure text; null uses `invalidValue`.
  final String? message;

  @override
  FutureOr<ValidationResult?> validate(
    BuildContext context,
    String? value,
    FormValidationMode lifecycle,
  ) {
    if (value == null || pattern.hasMatch(value)) {
      return null;
    }
    return InvalidResult(
      message ?? ShadcnLocalizations.of(context).invalidValue,
      state: lifecycle,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is RegexValidator &&
      other.pattern == pattern &&
      other.message == message;

  @override
  int get hashCode => Object.hash(pattern, message);
}

/// Requires a string to look like an e-mail address (`local@domain.tld`).
class EmailValidator extends Validator<String> {
  /// Creates an e-mail validator.
  const EmailValidator({this.message});

  /// Failure text; null uses `invalidEmail`.
  final String? message;

  @override
  FutureOr<ValidationResult?> validate(
    BuildContext context,
    String? value,
    FormValidationMode lifecycle,
  ) {
    if (value == null || _emailPattern.hasMatch(value)) {
      return null;
    }
    return InvalidResult(
      message ?? ShadcnLocalizations.of(context).invalidEmail,
      state: lifecycle,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is EmailValidator && other.message == message;

  @override
  int get hashCode => message.hashCode;
}

/// Requires a string with a scheme and a host.
class URLValidator extends Validator<String> {
  /// Creates a URL validator.
  const URLValidator({this.message});

  /// Failure text; null uses `invalidURL`.
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
    final Uri? uri = Uri.tryParse(value);
    if (uri != null && uri.hasScheme && uri.host.isNotEmpty) {
      return null;
    }
    return InvalidResult(
      message ?? ShadcnLocalizations.of(context).invalidURL,
      state: lifecycle,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is URLValidator && other.message == message;

  @override
  int get hashCode => message.hashCode;
}

/// Bounds a numeric value from below.
class MinValidator<T extends num> extends Validator<T> {
  /// Creates a minimum validator.
  const MinValidator(this.min, {this.inclusive = true, this.message});

  /// Lower bound.
  final T min;

  /// Whether the bound itself is accepted.
  final bool inclusive;

  /// Failure text; null uses the localized bound messages.
  final String? message;

  @override
  FutureOr<ValidationResult?> validate(
    BuildContext context,
    T? value,
    FormValidationMode lifecycle,
  ) {
    if (value == null || (inclusive ? value >= min : value > min)) {
      return null;
    }
    final ShadcnLocalizations localizations = ShadcnLocalizations.of(context);
    return InvalidResult(
      message ??
          (inclusive
              ? localizations.formGreaterThanOrEqualTo(describeValue(min))
              : localizations.formGreaterThan(describeValue(min))),
      state: lifecycle,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is MinValidator<T> &&
      other.min == min &&
      other.inclusive == inclusive &&
      other.message == message;

  @override
  int get hashCode => Object.hash(min, inclusive, message);
}

/// Bounds a numeric value from above.
class MaxValidator<T extends num> extends Validator<T> {
  /// Creates a maximum validator.
  const MaxValidator(this.max, {this.inclusive = true, this.message});

  /// Upper bound.
  final T max;

  /// Whether the bound itself is accepted.
  final bool inclusive;

  /// Failure text; null uses the localized bound messages.
  final String? message;

  @override
  FutureOr<ValidationResult?> validate(
    BuildContext context,
    T? value,
    FormValidationMode lifecycle,
  ) {
    if (value == null || (inclusive ? value <= max : value < max)) {
      return null;
    }
    final ShadcnLocalizations localizations = ShadcnLocalizations.of(context);
    return InvalidResult(
      message ??
          (inclusive
              ? localizations.formLessThanOrEqualTo(describeValue(max))
              : localizations.formLessThan(describeValue(max))),
      state: lifecycle,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is MaxValidator<T> &&
      other.max == max &&
      other.inclusive == inclusive &&
      other.message == message;

  @override
  int get hashCode => Object.hash(max, inclusive, message);
}
