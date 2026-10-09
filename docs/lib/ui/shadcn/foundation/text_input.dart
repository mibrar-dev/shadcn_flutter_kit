import 'package:flutter/services.dart';

/// The caret index and the new text produced by [replaceWordAtCaret].
typedef ReplacementInfo = (int start, String newText);

/// Replaces the word around [caret] in [text] with [replacement].
///
/// A word boundary is any character accepted by [isSeparator]. Throws a
/// [RangeError] when [caret] is out of bounds.
ReplacementInfo replaceWordAtCaret(
  String text,
  int caret,
  String replacement,
  bool Function(String char) isSeparator,
) {
  if (caret < 0 || caret > text.length) {
    throw RangeError('Caret position is out of bounds.');
  }

  int start = caret;
  while (start > 0 && !isSeparator(text[start - 1])) {
    start--;
  }

  int end = caret;
  while (end < text.length && !isSeparator(text[end])) {
    end++;
  }

  String newText = text.replaceRange(start, end, replacement);
  return (start, newText);
}

/// Text editing helpers used by formatted inputs.
extension TextEditingValueExtension on TextEditingValue {
  /// Replaces the text while keeping the selection within bounds.
  TextEditingValue replaceText(String newText) {
    var selection = this.selection;
    selection = selection.copyWith(
      baseOffset: selection.baseOffset.clamp(0, newText.length),
      extentOffset: selection.extentOffset.clamp(0, newText.length),
    );
    return TextEditingValue(text: newText, selection: selection);
  }
}
