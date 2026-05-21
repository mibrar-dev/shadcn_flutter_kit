// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../input_otp.dart';

/// A character-based OTP input field with validation and transformation.
///
/// Supports filtering input based on codepoint predicates and transforming
/// input characters (e.g., converting to uppercase). Commonly used for
/// creating numeric or alphanumeric OTP fields.
///
/// Example:
/// ```dart
/// CharacterInputOTPChild(
///   predicate: CharacterInputOTPChild.isDigit,
///   keyboardType: TextInputType.number,
/// )
/// ```
class CharacterInputOTPChild extends InputOTPChild {
  static const int _startAlphabetLower = 97; // 'a'
  static const int _endAlphabetLower = 122; // 'z'
  static const int _startAlphabetUpper = 65; // 'A'
  static const int _endAlphabetUpper = 90; // 'Z'
  static const int _startDigit = 48; // '0'
  static const int _endDigit = 57; // '9'

  /// Tests if the codepoint is a lowercase letter (a-z).
  ///
  /// Parameters:
  /// - [codepoint] (`int`, required): The codepoint to test.
  ///
  /// Returns: `true` if the codepoint is a lowercase letter.
  static bool isAlphabetLower(int codepoint) =>
      codepoint >= _startAlphabetLower && codepoint <= _endAlphabetLower;

  /// Tests if the codepoint is an uppercase letter (A-Z).
  ///
  /// Parameters:
  /// - [codepoint] (`int`, required): The codepoint to test.
  ///
  /// Returns: `true` if the codepoint is an uppercase letter.
  static bool isAlphabetUpper(int codepoint) =>
      codepoint >= _startAlphabetUpper && codepoint <= _endAlphabetUpper;

  /// Converts a lowercase letter to uppercase.
  ///
  /// Parameters:
  /// - [codepoint] (`int`, required): The codepoint to convert.
  ///
  /// Returns: The uppercase codepoint if lowercase, otherwise unchanged.
  static int lowerToUpper(int codepoint) =>
      isAlphabetLower(codepoint) ? codepoint - 32 : codepoint;

  /// Converts an uppercase letter to lowercase.
  ///
  /// Parameters:
  /// - [codepoint] (`int`, required): The codepoint to convert.
  ///
  /// Returns: The lowercase codepoint if uppercase, otherwise unchanged.
  static int upperToLower(int codepoint) =>
      isAlphabetUpper(codepoint) ? codepoint + 32 : codepoint;

  /// Tests if the codepoint is a digit (0-9).
  ///
  /// Parameters:
  /// - [codepoint] (`int`, required): The codepoint to test.
  ///
  /// Returns: `true` if the codepoint is a digit.
  static bool isDigit(int codepoint) =>
      codepoint >= _startDigit && codepoint <= _endDigit;

  /// Predicate to validate allowed codepoints.
  final CodepointPredicate? predicate;

  /// Function to transform codepoints before storing.
  final CodepointUnaryOperator? transform;

  /// Whether to obscure the input character.
  final bool obscured;

  /// Whether the input is read-only.
  final bool readOnly;

  /// The keyboard type to use for input.
  final TextInputType? keyboardType;

  /// Creates a [CharacterInputOTPChild].
  ///
  /// Parameters:
  /// - [predicate] (`CodepointPredicate?`, optional): Validates input codepoints.
  /// - [transform] (`CodepointUnaryOperator?`, optional): Transforms codepoints.
  /// - [obscured] (`bool`, default: `false`): Whether to obscure the character.
  /// - [readOnly] (`bool`, default: `false`): Whether the field is read-only.
  /// - [keyboardType] (`TextInputType?`, optional): Keyboard type for input.
  const CharacterInputOTPChild({
    this.predicate,
    this.transform,
    this.obscured = false,
    this.readOnly = false,
    this.keyboardType,
  });

  @override
  bool get hasValue {
    return true;
  }

  /// Builds the widget tree for this component state.
  @override
  Widget build(BuildContext context, InputOTPChildData data) {
    return _OTPCharacterInput(
      key: data._key,
      data: data,
      predicate: predicate,
      transform: transform,
      obscured: obscured,
      readOnly: readOnly,
      keyboardType: keyboardType,
    );
  }
}
