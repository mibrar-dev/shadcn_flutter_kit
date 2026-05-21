// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../formatter.dart';

/// _IntegerOnlyFormatter represents a form-related type in the registry.
class _IntegerOnlyFormatter extends TextInputFormatter {
  /// Field storing `min` for this form implementation.
  final int? min;

  /// Field storing `max` for this form implementation.
  final int? max;

  _IntegerOnlyFormatter({this.min, this.max});

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
    int? value = int.tryParse(newText);
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
    }
    if (max != null && value >= max!) {
      value = max!;
    }
    newText = value.toString();
    if (negate) {
      newText = '-$newText';
    }
    return TextEditingValue(
      text: newText,
      selection: contraintToNewText(newValue, newText),
    );
  }
}
