// The painted shape of a token field: [TokenSpan] and the span assembly that
// turns a token controller's text into a mixed text/widget span tree.
//
// Split from `token_editing.dart` so both stay under the file-length limit; the
// controller owns the value model, this owns the rendering.

import 'package:flutter/widgets.dart';

import 'token_editing.dart';

/// Builds the widget painted for the token [token] at [index].
///
/// [index] is the token's position in `TokenEditingController.tokens`, so a
/// builder can remove *that* token even when the list holds equal values.
typedef TokenWidgetBuilder<T> =
    Widget Function(BuildContext context, T token, int index);

/// An inline span standing for one token.
///
/// A [WidgetSpan] subclass so the token still paints as a widget while carrying
/// the value behind it; clipboard serialization reads the value instead of the
/// private-use placeholder.
class TokenSpan<T> extends WidgetSpan {
  /// Creates a token span.
  const TokenSpan({
    required this.value,
    required this.index,
    required super.child,
    super.alignment,
    super.baseline,
    super.style,
  });

  /// The token this span stands for.
  final T value;

  /// The token's position in the controller's token list.
  final int index;
}

/// Builds the span tree [TokenEditingController.buildTextSpan] returns.
///
/// [resolve] maps a token code unit to its value, or null when the unit has no
/// token (the controller strips those, so this only happens defensively).
/// Composing runs keep their underline, matching `TextEditingController`'s own
/// behaviour.
TextSpan buildTokenTextSpan<T>({
  required BuildContext context,
  required TextEditingValue value,
  required T? Function(int unit) resolve,
  required TokenWidgetBuilder<T> builder,
  required TextStyle? style,
  required bool withComposing,
  required double spacing,
  required PlaceholderAlignment alignment,
}) {
  final String text = value.text;
  final TextRange composing = withComposing && value.isComposingRangeValid
      ? value.composing
      : TextRange.empty;
  final TextStyle composingStyle = (style ?? const TextStyle()).merge(
    const TextStyle(decoration: TextDecoration.underline),
  );
  final List<InlineSpan> children = <InlineSpan>[];
  int runStart = 0;
  int index = 0;
  for (int i = 0; i < text.length; i++) {
    final int unit = text.codeUnitAt(i);
    if (!isTokenCodeUnit(unit)) {
      continue;
    }
    _addRun(children, text, runStart, i, style, composing, composingStyle);
    final T? token = resolve(unit);
    final bool previousIsToken =
        i > 0 && isTokenCodeUnit(text.codeUnitAt(i - 1));
    final bool nextIsToken =
        i < text.length - 1 && isTokenCodeUnit(text.codeUnitAt(i + 1));
    children.add(
      TokenSpan<T>(
        value: token as T,
        index: index,
        alignment: alignment,
        child: Padding(
          padding: EdgeInsets.only(
            left: previousIsToken
                ? spacing / 2
                : i == 0
                ? 0
                : spacing,
            right: nextIsToken ? spacing / 2 : spacing,
          ),
          child: builder(context, token, index),
        ),
      ),
    );
    index++;
    runStart = i + 1;
  }
  _addRun(
    children,
    text,
    runStart,
    text.length,
    style,
    composing,
    composingStyle,
  );
  return TextSpan(style: style, children: children);
}

void _addRun(
  List<InlineSpan> children,
  String text,
  int start,
  int end,
  TextStyle? style,
  TextRange composing,
  TextStyle composingStyle,
) {
  if (end <= start) {
    return;
  }
  if (composing.isValid && start < composing.end && end > composing.start) {
    final int from = start < composing.start ? composing.start : start;
    final int to = end > composing.end ? composing.end : end;
    if (from > start) {
      children.add(TextSpan(style: style, text: text.substring(start, from)));
    }
    children.add(
      TextSpan(style: composingStyle, text: text.substring(from, to)),
    );
    if (to < end) {
      children.add(TextSpan(style: style, text: text.substring(to, end)));
    }
    return;
  }
  children.add(TextSpan(style: style, text: text.substring(start, end)));
}
