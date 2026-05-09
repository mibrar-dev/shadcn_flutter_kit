// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../formatter.dart';

/// _DoubleOnlyFormatter represents a form-related type in the registry.
class _DoubleOnlyFormatter extends TextInputFormatter {
  /// Field storing `min` for this form implementation.
  final double? min;

  /// Field storing `max` for this form implementation.
  final double? max;

  /// Field storing `decimalDigits` for this form implementation.
  final int? decimalDigits;

  _DoubleOnlyFormatter({this.min, this.max, this.decimalDigits});

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String newText = newValue.text;
    if (newText.isEmpty) {
      return newValue;
    }
    bool negate = newText.startsWith('-');
    if (negate) {
      newText = newText.substring(1);
    }
    bool endsWithDot = newText.endsWith('.');
    if (endsWithDot) {
      newText = newText.substring(0, newText.length - 1);
    }
    double? value = double.tryParse(newText);
    if (value == null) {
      if (negate) {
        return const TextEditingValue(
          text: '-',
          selection: TextSelection.collapsed(offset: 1),
        );
      }
      return oldValue;
    }
    if (min != null && value <= min!) {
      value = min!;
      endsWithDot = false;
    }
    if (max != null && value >= max!) {
      value = max!;
      endsWithDot = false;
    }
    // var newText = value.toString();
    if (decimalDigits != null) {
      newText = value.toStringAsFixed(decimalDigits!);
    } else {
      newText = value.toString();
    }
    if (newText.contains('.')) {
      while (newText.endsWith('0')) {
        newText = newText.substring(0, newText.length - 1);
      }
      if (newText.endsWith('.')) {
        newText = newText.substring(0, newText.length - 1);
      }
    }
    if (endsWithDot) {
      newText += '.';
    }
    if (negate) {
      newText = '-$newText';
    }
    return TextEditingValue(
      text: newText,
      selection: contraintToNewText(newValue, newText),
    );
  }
}
