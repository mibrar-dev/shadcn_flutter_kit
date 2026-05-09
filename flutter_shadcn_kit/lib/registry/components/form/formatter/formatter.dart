// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'dart:math';

import 'package:expressions/expressions.dart';
import 'package:flutter/services.dart';

part '_impl/utils/_double_only_formatter.dart';
part '_impl/utils/_hex_text_formatter.dart';
part '_impl/utils/_integer_only_formatter.dart';
part '_impl/utils/_math_expression_formatter.dart';
part '_impl/utils/_time_formatter.dart';
part '_impl/utils/_to_lower_case_text_formatter.dart';
part '_impl/utils/_to_upper_case_text_formatter.dart';

/// Constrains the text selection to fit within the new text length.
///
/// Helper function that ensures selection offsets don't exceed the bounds
/// of the updated text.
TextSelection contraintToNewText(TextEditingValue newValue, String newText) {
  return TextSelection(
    baseOffset: newValue.selection.baseOffset.clamp(0, newText.length),
    extentOffset: newValue.selection.extentOffset.clamp(0, newText.length),
  );
}

/// Provides factory methods for common text input formatters.
///
/// [TextInputFormatters] is a utility class that creates various pre-configured
/// [TextInputFormatter] instances for common formatting needs like uppercase/lowercase
/// conversion, numeric input, time formatting, and more.
///
/// Example:
/// ```dart
/// TextField(
///   inputFormatters: [
///     TextInputFormatters.toUpperCase,
///     TextInputFormatters.integerOnly(min: 0, max: 100),
///   ],
/// )
/// ```
class TextInputFormatters {
  /// Converts all input text to uppercase.
  static const TextInputFormatter toUpperCase = _ToUpperCaseTextFormatter();

  /// Converts all input text to lowercase.
  static const TextInputFormatter toLowerCase = _ToLowerCaseTextFormatter();

  /// Creates a formatter for time input with leading zeros.
  ///
  /// Parameters:
  /// - [length]: The fixed length of the time string.
  static TextInputFormatter time({required int length}) {
    return _TimeFormatter(length: length);
  }

  /// Creates a formatter that only allows integer input with optional min/max bounds.
  ///
  /// Parameters:
  /// - [min]: Optional minimum value.
  /// - [max]: Optional maximum value.
  static TextInputFormatter integerOnly({int? min, int? max}) {
    return _IntegerOnlyFormatter(min: min, max: max);
  }

  /// Creates a formatter that only allows decimal numeric input.
  ///
  /// Parameters:
  /// - [min]: Optional minimum value.
  /// - [max]: Optional maximum value.
  /// - [decimalDigits]: Optional fixed number of decimal places.
  static TextInputFormatter digitsOnly({
    double? min,
    double? max,
    int? decimalDigits,
  }) {
    return _DoubleOnlyFormatter(
      min: min,
      max: max,
      decimalDigits: decimalDigits,
    );
  }

  /// Creates a formatter that evaluates mathematical expressions.
  ///
  /// Parameters:
  /// - [context]: Optional context variables for expression evaluation.
  static TextInputFormatter mathExpression({Map<String, dynamic>? context}) {
    return _MathExpressionFormatter(context: context);
  }

  /// Creates a formatter for hexadecimal input.
  ///
  /// Parameters:
  /// - [hashPrefix]: Whether to require/add a '#' prefix.
  static TextInputFormatter hex({bool hashPrefix = false}) {
    return _HexTextFormatter(hashPrefix: hashPrefix);
  }

  const TextInputFormatters._();
}
