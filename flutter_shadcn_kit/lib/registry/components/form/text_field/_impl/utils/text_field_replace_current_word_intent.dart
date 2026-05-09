// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../text_field.dart';

/// Intent to replace the current word in the text field.
///
/// Replaces the word at the current cursor position with new text.
/// Used with Flutter's Actions/Shortcuts system.
class TextFieldReplaceCurrentWordIntent extends Intent {
  /// Creates a [TextFieldReplaceCurrentWordIntent] with replacement text.
  const TextFieldReplaceCurrentWordIntent({required this.text});

  /// The text to replace the current word with.
  final String text;
}
