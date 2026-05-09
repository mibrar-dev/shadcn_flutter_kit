// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../text_field.dart';

/// Intent to set the entire text field content to a specific value.
///
/// Replaces all existing text with the provided text.
/// Used with Flutter's Actions/Shortcuts system.
class TextFieldSetTextIntent extends Intent {
  /// Creates a [TextFieldSetTextIntent] with the new text.
  const TextFieldSetTextIntent({required this.text});

  /// The text to set as the field's content.
  final String text;
}
