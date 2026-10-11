// The 4-class highlight → `TextSpan` builder for generated code maps.
//
// The README snippets carry their own `DocsSnippet.spans`; block files are
// plain `code` + `tokenClasses` pairs (one `p`/`c`/`k`/`s` class per
// character), so the Blocks code view builds its spans here instead of
// duplicating the generator.

import 'package:flutter/widgets.dart';

/// Splits [code] into [TextSpan]s by its highlight classes.
///
/// [tokenClasses] must have exactly one character per character of [code];
/// unexpected classes fall back to [plain].
List<TextSpan> codeSpans({
  required String code,
  required String tokenClasses,
  required TextStyle plain,
  TextStyle? comment,
  TextStyle? keyword,
  TextStyle? string,
}) {
  if (code.isEmpty) {
    return const <TextSpan>[];
  }
  final Map<String, TextStyle> styles = <String, TextStyle>{
    'c': comment ?? plain,
    'k': keyword ?? plain,
    's': string ?? plain,
    'p': plain,
  };
  final List<TextSpan> spans = <TextSpan>[];
  int start = 0;
  String current = _classAt(tokenClasses, 0);
  for (int i = 1; i < code.length; i++) {
    final String next = _classAt(tokenClasses, i);
    if (next != current) {
      spans.add(
        TextSpan(
          text: code.substring(start, i),
          style: styles[current] ?? plain,
        ),
      );
      start = i;
      current = next;
    }
  }
  spans.add(
    TextSpan(text: code.substring(start), style: styles[current] ?? plain),
  );
  return spans;
}

String _classAt(String tokenClasses, int index) =>
    index < tokenClasses.length ? tokenClasses[index] : 'p';
