// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../formatter.dart';

/// _TimeFormatter represents a form-related type in the registry.
class _TimeFormatter extends TextInputFormatter {
  /// Field storing `length` for this form implementation.
  final int length;
  const _TimeFormatter({required this.length});
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // make sure new value has leading zero
    var newText = newValue.text;

    int substringCount = 0;
    if (newText.length > length) {
      substringCount = newText.length - length;
      newText = newText.substring(substringCount);
    }

    int padLength = length - newText.length;

    var baseOffset2 = newValue.selection.baseOffset;

    var extentOffset2 = newValue.selection.extentOffset;
    if (padLength > 0) {
      newText = newText.padLeft(length, '0');
      baseOffset2 = baseOffset2 + padLength;
      extentOffset2 = extentOffset2 + padLength;
    }
    return newValue.copyWith(
      text: newText,
      composing: newValue.composing.isValid
          ? TextRange(
              start: newValue.composing.start.clamp(
                0,
                min(length, newValue.text.length),
              ),
              end: newValue.composing.end.clamp(
                0,
                min(length, newValue.text.length),
              ),
            )
          : newValue.composing,
      selection: TextSelection(
        baseOffset: baseOffset2.clamp(0, min(length, newText.length)),
        extentOffset: extentOffset2.clamp(0, min(length, newText.length)),
      ),
    );
  }
}
