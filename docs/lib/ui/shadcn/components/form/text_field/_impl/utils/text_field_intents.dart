// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../text_field.dart';

/// Intent to append text to the current text field content.
///
/// Used with Flutter's Actions/Shortcuts system to programmatically
/// append text to a text field.
class TextFieldAppendTextIntent extends Intent {
  /// Creates a [TextFieldAppendTextIntent] with the text to append.
  const TextFieldAppendTextIntent({required this.text});

  /// The text to append to the current content.
  final String text;
}
