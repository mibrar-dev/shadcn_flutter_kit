// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../phone_input.dart';

/// Ensures the phone number field always starts with a `+` prefix.
///
/// Applied after any digit filtering so the dial-code prefix state machine
/// in [_PhoneInputState] can always detect the country from the text.
class _AlwaysPrefixedPlus extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String text = newValue.text;
    if (text.startsWith('+')) {
      return newValue;
    } else {
      return TextEditingValue(
        text: '+$text',
        selection: newValue.selection.copyWith(
          baseOffset: newValue.selection.baseOffset + 1,
          extentOffset: newValue.selection.extentOffset + 1,
        ),
      );
    }
  }
}
