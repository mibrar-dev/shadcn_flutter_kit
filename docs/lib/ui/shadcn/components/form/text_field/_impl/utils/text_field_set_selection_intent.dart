// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../text_field.dart';

/// Intent to set the text selection in the text field.
///
/// Used with Flutter's Actions/Shortcuts system to programmatically
/// control cursor position and text selection.
class TextFieldSetSelectionIntent extends Intent {
  /// The text selection to apply.
  final TextSelection selection;

  /// Creates a [TextFieldSetSelectionIntent] with the selection.
  const TextFieldSetSelectionIntent({required this.selection});
}
