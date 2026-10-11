// Machinery for a text field whose content is partly made of *tokens*: chips,
// tags, mentions. A token is stored in the controller text as one code unit
// from the Unicode Private Use Area, so the caret, the selection and every
// keyboard editing command keep working across it, and the token is painted by
// overriding [TextEditingController.buildTextSpan].
//
// The component above owns the widgets; this owns the value model. It is the
// sibling of `segmented_editing.dart` (a field made of editable segments) and
// knows nothing about any component theme.
//
// Ported from `components/form/chip_input/_impl/utils/chip_editing_controller.dart`
// (545 lines); the fixed defects are listed in the component README.

import 'package:flutter/widgets.dart';

import 'token_clipboard.dart';
import 'token_span.dart';
import 'token_units.dart';

export 'token_clipboard.dart';
export 'token_span.dart';
export 'token_units.dart';

/// A [TextEditingController] whose text can hold tokens.
///
/// A token occupies exactly one code unit from U+E000 to U+F8FF, which is why
/// plain caret movement, selection, undo and every `EditableText` keyboard
/// command keep working. [tokenBuilder] paints each one.
///
/// ```dart
/// final controller = TokenEditingController<String>(
///   initialTokens: const <String>['flutter'],
///   tokenBuilder: (context, token, index) => Chip(child: Text(token)),
/// );
/// ```
class TokenEditingController<T> extends TextEditingController {
  /// Creates a token controller.
  TokenEditingController({
    super.text,
    List<T>? initialTokens,
    required this.tokenBuilder,
    this.spacing = 4,
    this.alignment = PlaceholderAlignment.middle,
  }) {
    if (initialTokens != null && initialTokens.isNotEmpty) {
      insertTokens(initialTokens);
    }
  }

  final Map<int, T> _tokens = <int, T>{};
  int _nextIndex = 0;

  /// Guards the re-entrant write made while cleaning unregistered code units.
  bool _syncing = false;

  /// Builds the widget painted for each token.
  ///
  /// Public and mutable: the field assigns it on every build, so a token always
  /// paints with the current theme. It must stay pure — it runs while
  /// `EditableText` paints, not during `build`.
  TokenWidgetBuilder<T> tokenBuilder;

  /// Horizontal space reserved between two adjacent tokens, in logical pixels.
  double spacing;

  /// How the painted token sits on the text baseline.
  PlaceholderAlignment alignment;

  /// Every token, in text order.
  List<T> get tokens => <T>[
    for (final int unit in tokenUnitsOf(value.text))
      if (_tokens[unit - tokenCodeUnitStart] case final T token) token,
  ];

  /// Number of tokens in the text.
  int get tokenCount => tokenUnitsOf(value.text).length;

  /// The text with every token code unit removed.
  String get plainText {
    final StringBuffer buffer = StringBuffer();
    for (final int unit in value.text.codeUnits) {
      if (!isTokenCodeUnit(unit)) {
        buffer.writeCharCode(unit);
      }
    }
    return buffer.toString();
  }

  /// The run of plain text around the caret, trimmed.
  ///
  /// Empty when the caret touches a token or the field is empty.
  String get textAtCursor {
    final (int start, int end) = _plainRunAt(_caret());
    return value.text.substring(start, end).trim();
  }

  /// Whether a token sits immediately before the caret.
  bool get hasTokenBeforeCaret {
    final int caret = _caret();
    return caret > 0 && isTokenCodeUnit(value.text.codeUnitAt(caret - 1));
  }

  /// Replaces every token with [next], keeping the surrounding text.
  ///
  /// The run keeps its place: it stays between the text before the first token
  /// and the text after the last one. With no token yet, the run is inserted at
  /// the caret. This is what makes reordering the list actually reorder the
  /// rendered tokens.
  set tokens(List<T> next) {
    final String text = value.text;
    final List<int> units = tokenUnitsOf(text);
    final int first = units.isEmpty
        ? _caret()
        : text.indexOf(String.fromCharCode(units.first));
    final String head = text.substring(0, first);
    final StringBuffer run = StringBuffer();
    for (final T token in next) {
      run.writeCharCode(tokenCodeUnitStart + _allocate(token));
    }
    final int last = units.isEmpty
        ? text.length
        : text.lastIndexOf(String.fromCharCode(units.last)) + 1;
    final String tail = text.substring(last);
    _write(head + run.toString() + tail, first + next.length);
  }

  /// Inserts [token] at the caret and returns its index.
  int insertToken(T token) {
    final int caret = _caret();
    final int index = _allocate(token);
    final String text = value.text.replaceRange(
      caret,
      caret,
      String.fromCharCode(tokenCodeUnitStart + index),
    );
    _write(text, caret + 1);
    return index;
  }

  /// Inserts every token of [values] at the caret, in order.
  void insertTokens(List<T> values) {
    if (values.isEmpty) {
      return;
    }
    final int caret = _caret();
    final StringBuffer run = StringBuffer();
    for (final T value in values) {
      run.writeCharCode(tokenCodeUnitStart + _allocate(value));
    }
    final String text = value.text.replaceRange(caret, caret, run.toString());
    _write(text, caret + values.length);
  }

  /// Removes the token at [index] in [tokens] order; false when out of range.
  bool removeTokenAt(int index) {
    final List<int> units = tokenUnitsOf(value.text);
    if (index < 0 || index >= units.length) {
      return false;
    }
    final int unit = units[index];
    final int at = value.text.indexOf(String.fromCharCode(unit));
    return _removeCodeUnit(unit, at);
  }

  /// Removes the last token; false when there is none.
  bool removeLastToken() {
    final List<int> units = tokenUnitsOf(value.text);
    if (units.isEmpty) {
      return false;
    }
    final int unit = units.last;
    return _removeCodeUnit(
      unit,
      value.text.lastIndexOf(String.fromCharCode(unit)),
    );
  }

  /// Converts the plain run around the caret into a token.
  ///
  /// [convert] receives the trimmed run and returns the token to insert, or
  /// null to reject it and leave the text untouched. Returns the inserted
  /// token, or null when there was nothing to convert.
  T? submitTokenAtCursor(T? Function(String text) convert) {
    final (int start, int end) = _plainRunAt(_caret());
    if (start == end) {
      return null;
    }
    final String word = value.text.substring(start, end).trim();
    if (word.isEmpty) {
      return null;
    }
    final T? token = convert(word);
    if (token == null) {
      return null;
    }
    final int lead =
        start + leadingSpaceCount(value.text.substring(start, end));
    final int trail =
        end - trailingSpaceCount(value.text.substring(start, end));
    final int index = _allocate(token);
    final String text = value.text.replaceRange(
      lead,
      trail,
      String.fromCharCode(tokenCodeUnitStart + index),
    );
    _write(text, lead + 1);
    return token;
  }

  /// The fragments [selection] covers, in text order.
  List<TokenFragment<T>> fragmentsIn(TextSelection selection) {
    final String text = value.text;
    if (!selection.isValid) {
      return const <Never>[];
    }
    final int start = selection.start.clamp(0, text.length);
    final int end = selection.end.clamp(0, text.length);
    final List<TokenFragment<T>> out = <TokenFragment<T>>[];
    final StringBuffer buffer = StringBuffer();
    for (int i = start; i < end; i++) {
      final int unit = text.codeUnitAt(i);
      if (isTokenCodeUnit(unit)) {
        _flush(out, buffer);
        final T? token = _tokens[unit - tokenCodeUnitStart];
        if (token != null) {
          out.add(TokenValueFragment<T>(token));
        }
        continue;
      }
      buffer.writeCharCode(unit);
    }
    _flush(out, buffer);
    return out;
  }

  /// Replaces the selection with [fragments].
  void replaceSelectionWith(List<TokenFragment<T>> fragments) {
    final TextEditingValue current = value;
    final String text = current.text;
    final int start = current.selection.isValid
        ? current.selection.start.clamp(0, text.length)
        : text.length;
    final int end = current.selection.isValid
        ? current.selection.end.clamp(0, text.length)
        : text.length;
    final StringBuffer buffer = StringBuffer(text.substring(0, start));
    for (final TokenFragment<T> fragment in fragments) {
      switch (fragment) {
        case TokenTextFragment<T>(:final String text):
          buffer.write(text);
        case TokenValueFragment<T>(:final T value):
          buffer.writeCharCode(tokenCodeUnitStart + _allocate(value));
      }
    }
    buffer.write(text.substring(end));
    _write(buffer.toString(), buffer.length);
  }

  @override
  set value(TextEditingValue newValue) {
    super.value = newValue;
    if (_syncing) {
      return;
    }
    final TokenScrub scrub = scrubTokenCodeUnits(newValue.text, _isRegistered);
    if (scrub.changed) {
      _syncing = true;
      try {
        super.value = newValue.copyWith(
          text: scrub.text,
          selection: shiftSelectionPastScrub(
            newValue.selection,
            newValue.text,
            scrub.text,
            _isRegistered,
          ),
        );
      } finally {
        _syncing = false;
      }
    }
    _prune(scrub.text);
  }

  /// Whether the registry knows [unit]; the predicate every scrub takes.
  bool _isRegistered(int unit) =>
      _tokens.containsKey(unit - tokenCodeUnitStart);

  @override
  TextSpan buildTextSpan({
    required BuildContext context,
    TextStyle? style,
    required bool withComposing,
  }) => buildTokenTextSpan<T>(
    context: context,
    value: value,
    resolve: (int unit) => _tokens[unit - tokenCodeUnitStart],
    builder: tokenBuilder,
    style: style,
    withComposing: withComposing,
    spacing: spacing,
    alignment: alignment,
  );

  int _allocate(T token) {
    assert(
      _tokens.length < tokenCapacity,
      'TokenEditingController is full: at most $tokenCapacity tokens.',
    );
    while (_tokens.containsKey(_nextIndex)) {
      _nextIndex = (_nextIndex + 1) % tokenCapacity;
    }
    final int index = _nextIndex;
    _tokens[index] = token;
    return index;
  }

  bool _removeCodeUnit(int unit, int at) {
    final int caret = _caret();
    final String text = value.text.replaceRange(at, at + 1, '');
    _tokens.remove(unit - tokenCodeUnitStart);
    // The caret only moves when the removed unit sat *before* it.
    _write(text, caret > at ? caret - 1 : caret);
    return true;
  }

  /// The caret, clamped into the text. A controller that was never focused has
  /// an invalid selection (offset -1); reading it raw would throw.
  int _caret() {
    final TextSelection selection = value.selection;
    if (!selection.isValid) {
      return value.text.length;
    }
    return selection.baseOffset.clamp(0, value.text.length);
  }

  /// The plain (token-free) run of [text] surrounding [offset].
  (int, int) _plainRunAt(int offset) {
    final String text = value.text;
    int start = offset;
    int end = offset;
    while (start > 0 && !isTokenCodeUnit(text.codeUnitAt(start - 1))) {
      start--;
    }
    while (end < text.length && !isTokenCodeUnit(text.codeUnitAt(end))) {
      end++;
    }
    return (start, end);
  }

  void _write(String text, int caret) {
    super.value = TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: caret.clamp(0, text.length)),
    );
    _prune(text);
  }

  void _prune(String text) {
    final List<int> used = tokenUnitsOf(text);
    final Set<int> keep = <int>{
      for (final int unit in used) unit - tokenCodeUnitStart,
    };
    _tokens.removeWhere((int index, _) => !keep.contains(index));
  }
}

void _flush<T>(List<TokenFragment<T>> out, StringBuffer buffer) {
  if (buffer.isNotEmpty) {
    out.add(TokenTextFragment<T>(buffer.toString()));
    buffer.clear();
  }
}
