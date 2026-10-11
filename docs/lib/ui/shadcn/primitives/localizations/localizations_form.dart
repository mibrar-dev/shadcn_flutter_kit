// Form, validation and input strings for [ShadcnLocalizations].

/// Form, validation and input text for [ShadcnLocalizations].
///
/// Applied by `ShadcnLocalizations`; every getter has an English default and
/// translated locale tables may override it.
mixin ShadcnLocalizationsForm {
  /// Accessible label of a token chip's remove button.
  ///
  /// Copied from Flutter's `deleteButtonTooltip`, documented there as "the
  /// tooltip for the delete button of chips".
  String get chipInputRemoveChip => 'Delete';

  String get formNotEmpty => 'This field cannot be empty.';

  String formLessThan(Object? value) => 'Must be less than $value.';

  String formGreaterThan(Object? value) => 'Must be greater than $value.';

  String formLessThanOrEqualTo(Object? value) =>
      'Must be less than or equal to $value.';

  String formGreaterThanOrEqualTo(Object? value) =>
      'Must be greater than or equal to $value.';

  String formEqualTo(Object? value) => 'Must be equal to $value.';

  String formBetweenInclusively(Object? min, Object? max) =>
      'Must be between $min and $max (inclusive).';

  String formBetweenExclusively(Object? min, Object? max) =>
      'Must be between $min and $max (exclusive).';

  String formLengthLessThan(int limit) => 'Must be at least $limit characters.';

  String formLengthGreaterThan(int limit) =>
      'Must be at most $limit characters.';

  String get formPasswordDigits => 'Must include at least one digit.';

  String get formPasswordLowercase =>
      'Must include at least one lowercase letter.';

  String get formPasswordUppercase =>
      'Must include at least one uppercase letter.';

  String get formPasswordSpecial =>
      'Must include at least one special character.';

  String get formPhoneNumberInvalid => 'Phone number is invalid.';

  String get formPhoneNumberEmpty => 'Phone number is required.';

  String get invalidValue => 'Invalid value provided.';

  String get invalidEmail => 'Invalid email address.';

  String get invalidURL => 'Invalid URL.';
}
