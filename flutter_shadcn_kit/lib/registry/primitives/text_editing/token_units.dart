// The token code-unit representation: the Private Use Area slots a token
// occupies, the helpers that read them back, and the two scrubbers that keep a
// field's text and selection consistent with its token registry.
//
// Split out of `token_editing.dart` to keep both under the file-length limit.
// Nothing here knows about chips, components or themes — only about code units,
// so it is reusable by any field whose value holds placeholders.

import 'package:flutter/widgets.dart';

/// Lowest Private Use Area code unit reserved for tokens.
const int tokenCodeUnitStart = 0xE000;

/// Highest Private Use Area code unit reserved for tokens.
const int tokenCodeUnitEnd = 0xF8FF;

/// Number of tokens one field can hold.
const int tokenCapacity = tokenCodeUnitEnd - tokenCodeUnitStart + 1;

/// Whether [unit] is a code unit reserved for a token.
bool isTokenCodeUnit(int unit) =>
    unit >= tokenCodeUnitStart && unit <= tokenCodeUnitEnd;

/// Every token code unit of [text], in text order.
List<int> tokenUnitsOf(String text) => <int>[
  for (final int unit in text.codeUnits)
    if (isTokenCodeUnit(unit)) unit,
];

/// How many leading single spaces [text] has.
int leadingSpaceCount(String text) {
  int i = 0;
  while (i < text.length && text[i] == ' ') {
    i++;
  }
  return i;
}

/// How many trailing single spaces [text] has.
int trailingSpaceCount(String text) {
  int i = text.length;
  while (i > 0 && text[i - 1] == ' ') {
    i--;
  }
  return text.length - i;
}

/// The result of scrubbing: the cleaned text, and whether anything was removed.
typedef TokenScrub = ({String text, bool changed});

/// Drops every token code unit [isRegistered] does not recognise.
///
/// A field can end up holding a placeholder it never allocated — a paste, an
/// IME rewrite, a text set from outside. Leaving one in the value would paint
/// an invisible character nobody could delete, so it goes.
TokenScrub scrubTokenCodeUnits(
  String text,
  bool Function(int unit) isRegistered,
) {
  final StringBuffer buffer = StringBuffer();
  bool changed = false;
  for (final int unit in text.codeUnits) {
    if (isTokenCodeUnit(unit) && !isRegistered(unit)) {
      changed = true;
      continue;
    }
    buffer.writeCharCode(unit);
  }
  return (text: changed ? buffer.toString() : text, changed: changed);
}

/// Moves [selection] across the code units [scrubTokenCodeUnits] removed.
///
/// Both endpoints count into `from`, so an offset that sat past a removed unit
/// moves left by exactly as many units as disappeared in front of it. Invalid
/// selections (an unfocused field) pass through untouched.
TextSelection shiftSelectionPastScrub(
  TextSelection selection,
  String from,
  String to,
  bool Function(int unit) isRegistered,
) {
  if (!selection.isValid) {
    return selection;
  }

  int shift(int offset) {
    if (offset <= 0) {
      return 0;
    }
    int removed = 0;
    for (int i = 0; i < from.length && i < offset; i++) {
      final int unit = from.codeUnitAt(i);
      if (isTokenCodeUnit(unit) && !isRegistered(unit)) {
        removed++;
      }
    }
    return (offset - removed).clamp(0, to.length);
  }

  return TextSelection(
    baseOffset: shift(selection.baseOffset),
    extentOffset: shift(selection.extentOffset),
  );
}
