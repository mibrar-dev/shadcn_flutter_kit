// The `formatter` component: the shared `TextInputFormatter` factory set.
//
// Widgets-only. `TimeFormatter` is public because time_picker (B13) uses it;
// the old `_TimeFormatter` was private and its time_picker copy had drifted
// (hard-coded length 2) — this version follows the formatter copy, which
// takes an explicit [length].

import 'dart:math' as math;

import 'package:expressions/expressions.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

/// Constrains the text selection to fit within the new text length.
TextSelection constraintToNewText(TextEditingValue newValue, String newText) {
  return TextSelection(
    baseOffset: newValue.selection.baseOffset.clamp(0, newText.length),
    extentOffset: newValue.selection.extentOffset.clamp(0, newText.length),
  );
}

/// Pads/trims typed time text to a fixed [length] with leading zeros.
///
/// This is the reconciled owner of both old copies: the formatter copy wins.
class TimeFormatter extends TextInputFormatter {
  /// Fixed output length (e.g. 2 for `HH`/`mm` fields, 4 for `HHmm`).
  const TimeFormatter({required this.length});

  /// Fixed output length.
  final int length;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    var newText = newValue.text;
    if (newText.length > length) {
      newText = newText.substring(newText.length - length);
    }
    final padLength = length - newText.length;
    var baseOffset = newValue.selection.baseOffset;
    var extentOffset = newValue.selection.extentOffset;
    if (padLength > 0) {
      newText = newText.padLeft(length, '0');
      baseOffset += padLength;
      extentOffset += padLength;
    }
    return newValue.copyWith(
      text: newText,
      composing: newValue.composing.isValid
          ? TextRange(
              start: newValue.composing.start.clamp(0, length),
              end: newValue.composing.end.clamp(0, length),
            )
          : newValue.composing,
      selection: TextSelection(
        baseOffset: baseOffset.clamp(0, math.min(length, newText.length)),
        extentOffset: extentOffset.clamp(0, math.min(length, newText.length)),
      ),
    );
  }
}

/// Uppercases all input text.
class ToUpperCaseTextFormatter extends TextInputFormatter {
  /// Creates the formatter.
  const ToUpperCaseTextFormatter();

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}

/// Lowercases all input text.
class ToLowerCaseTextFormatter extends TextInputFormatter {
  /// Creates the formatter.
  const ToLowerCaseTextFormatter();

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return TextEditingValue(
      text: newValue.text.toLowerCase(),
      selection: newValue.selection,
    );
  }
}

/// Parses a numeric expression on each edit and replaces the text with its
/// evaluated result (empty string when unparsable or non-numeric).
class MathExpressionFormatter extends TextInputFormatter {
  /// Creates the formatter with optional [context] variables.
  const MathExpressionFormatter({this.context});

  /// Variables available to the expression evaluator.
  final Map<String, dynamic>? context;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String newText = newValue.text;
    Object? result;
    try {
      final expression = Expression.parse(newText);
      final evaluator = const ExpressionEvaluator();
      result = evaluator.eval(expression, context ?? <String, dynamic>{});
      if (result is! num) {
        result = '';
      }
    } catch (_) {
      result = '';
    }
    var resultText = result.toString();
    if (resultText.contains('.')) {
      while (resultText.endsWith('0')) {
        resultText = resultText.substring(0, resultText.length - 1);
      }
      if (resultText.endsWith('.')) {
        resultText = resultText.substring(0, resultText.length - 1);
      }
    }
    return TextEditingValue(
      text: resultText,
      selection: constraintToNewText(newValue, resultText),
    );
  }
}

/// Allows `[0-9a-fA-F]` only, optionally with a leading `#`.
class HexTextFormatter extends TextInputFormatter {
  /// Creates the formatter; [hashPrefix] forces a `#` prefix.
  const HexTextFormatter({this.hashPrefix = false});

  /// Whether the text is kept with a `#` prefix.
  final bool hashPrefix;

  static final RegExp _withPrefix = RegExp(r'^#?[0-9a-fA-F]*$');
  static final RegExp _withoutPrefix = RegExp(r'^[0-9a-fA-F]*$');

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    var newText = newValue.text;
    if (hashPrefix) {
      if (!newText.startsWith('#')) {
        newText = '#$newText';
      }
    } else {
      if (newText.startsWith('#')) {
        newText = newText.substring(1);
      }
    }
    if (!(hashPrefix ? _withPrefix : _withoutPrefix).hasMatch(newText)) {
      return oldValue;
    }
    var selection = constraintToNewText(newValue, newText);
    if (hashPrefix) {
      if (selection.baseOffset == 0) {
        selection = selection.copyWith(baseOffset: 1);
      }
      if (selection.extentOffset == 0) {
        selection = selection.copyWith(extentOffset: 1);
      }
    }
    return TextEditingValue(text: newText, selection: selection);
  }
}

/// Numeric text with optional integer/decimal clamping.
class NumberTextFormatter extends TextInputFormatter {
  /// Creates the formatter.
  ///
  /// [decimalDigits] null keeps the input's natural precision;
  /// [min]/[max] clamp the parsed value (old semantics: equality also
  /// clamps, which made the "overwrite at boundary" case identical).
  const NumberTextFormatter({this.min, this.max, this.decimalDigits});

  /// Lower clamp bound.
  final double? min;

  /// Upper clamp bound.
  final double? max;

  /// Fixed decimal places when parsing.
  final int? decimalDigits;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    var newText = newValue.text;
    if (newText.isEmpty) {
      return newValue;
    }
    var negate = newText.startsWith('-');
    if (negate) {
      newText = newText.substring(1);
    }
    var endsWithDot = newText.endsWith('.');
    if (endsWithDot) {
      newText = newText.substring(0, newText.length - 1);
    }
    final parsed = double.tryParse(newText);
    if (parsed == null) {
      if (negate) {
        return const TextEditingValue(
          text: '-',
          selection: TextSelection.collapsed(offset: 1),
        );
      }
      return oldValue;
    }
    // Clamp the *signed* value (old code clamped the magnitude and
    // re-applied '-', so '-5' with min 0 stayed '-5' — bug fixed).
    var value = negate ? -parsed : parsed;
    if (min != null && value < min!) {
      value = min!;
      endsWithDot = false;
    }
    if (max != null && value > max!) {
      value = max!;
      endsWithDot = false;
    }
    if (decimalDigits != null) {
      newText = value.toStringAsFixed(decimalDigits!);
    } else {
      newText = value.toString();
      if (newText.contains('.')) {
        // Natural-precision formatting drops trailing zeros; asFixed stays
        // exact (old code stripped the asFixed zeros too — bug fixed).
        while (newText.endsWith('0')) {
          newText = newText.substring(0, newText.length - 1);
        }
        if (newText.endsWith('.')) {
          newText = newText.substring(0, newText.length - 1);
        }
      }
    }
    if (endsWithDot) {
      newText += '.';
    }
    return TextEditingValue(
      text: newText,
      selection: constraintToNewText(newValue, newText),
    );
  }
}

/// Integer-only text with optional integer clamping.
class IntegerTextFormatter extends TextInputFormatter {
  /// Creates the formatter.
  const IntegerTextFormatter({this.min, this.max});

  /// Lower clamp bound (int).
  final int? min;

  /// Upper clamp bound (int).
  final int? max;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    var newText = newValue.text;
    if (newText.isEmpty) {
      return newValue;
    }
    var negate = newText.startsWith('-');
    if (negate) {
      newText = newText.substring(1);
    }
    final parsed = int.tryParse(newText);
    if (parsed == null) {
      if (negate) {
        return const TextEditingValue(
          text: '-',
          selection: TextSelection.collapsed(offset: 1),
        );
      }
      return oldValue;
    }
    // Clamp the *signed* value (the old code clamped the magnitude and
    // re-applied '-': same bug).
    var value = negate ? -parsed : parsed;
    if (min != null && value < min!) {
      value = min!;
    }
    if (max != null && value > max!) {
      value = max!;
    }
    newText = value.toString();
    return TextEditingValue(
      text: newText,
      selection: constraintToNewText(newValue, newText),
    );
  }
}

/// Factory methods for common text input formatters.
///
/// ```dart
/// TextField(
///   inputFormatters: [
///     TextInputFormatters.toUpperCase,
///     TextInputFormatters.integerOnly(min: 0, max: 100),
///   ],
/// )
/// ```
class TextInputFormatters {
  /// Prevents instantiation.
  const TextInputFormatters._();

  /// Converts all input text to uppercase.
  static const TextInputFormatter toUpperCase = ToUpperCaseTextFormatter();

  /// Converts all input text to lowercase.
  static const TextInputFormatter toLowerCase = ToLowerCaseTextFormatter();

  /// Creates a time formatter padded left with zeros to [length].
  static TextInputFormatter time({required int length}) {
    return TimeFormatter(length: length);
  }

  /// Creates an integer-only formatter with optional bounds.
  static TextInputFormatter integerOnly({int? min, int? max}) {
    return IntegerTextFormatter(min: min, max: max);
  }

  /// Creates a decimal formatter with optional bounds and fixed places.
  static TextInputFormatter digitsOnly({
    double? min,
    double? max,
    int? decimalDigits,
  }) {
    return NumberTextFormatter(
      min: min,
      max: max,
      decimalDigits: decimalDigits,
    );
  }

  /// Creates a math-expression evaluator formatter.
  static TextInputFormatter mathExpression({Map<String, dynamic>? context}) {
    return MathExpressionFormatter(context: context);
  }

  /// Creates a hex-only formatter.
  static TextInputFormatter hex({bool hashPrefix = false}) {
    return HexTextFormatter(hashPrefix: hashPrefix);
  }
}
