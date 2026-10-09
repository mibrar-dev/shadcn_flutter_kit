// Language-aware syntax highlighting: a small, dependency-free regex/state
// tokenizer that turns source text into colored [TextSpan]s.
//
// Public API:
//  * [syntaxLanguageFromId] / [syntaxLanguageGuess] — language from an
//    explicit id, a fence tag, or (conservatively) the code text.
//  * [tokenize] — source text to non-overlapping [SyntaxToken]s.
//  * [buildSyntaxSpans] / [syntaxTextSpan] — tokens to colored spans using
//    the theme's `syntax` token group (`SyntaxColors`).
//
// Correctness rules: multi-line strings/comments, string interpolation
// (Dart `$x`/`${}`, JS template literals), raw strings and escapes are
// handled; the tokenizer never throws (any failure degrades to plain text)
// and its spans always concatenate back to the source, so selection and
// copy keep yielding the plain text.

import 'package:flutter/widgets.dart';

import '../../theme/syntax_colors.dart';
import 'syntax_language.dart';
import 'syntax_scanners.dart';
import 'syntax_token.dart';

export 'syntax_language.dart';
export 'syntax_token.dart';

const int _backslash = 0x5C; // \
const int _dollar = 0x24; // $
const int _openBrace = 0x7B; // {
const int _closeBrace = 0x7D; // }

/// Tokenizes [code] for [language]. Returns plain (empty) on any failure —
/// callers can never be broken by malformed input.
List<SyntaxToken> tokenize(String code, SyntaxLanguage language) {
  try {
    final tokens = scanLanguage(code, language);
    return switch (language) {
      // Dart strings interpolate $x and ${expr}.
      SyntaxLanguage.dart => _splitInterpolations(
        code,
        tokens,
        simpleDollar: true,
        inner: SyntaxLanguage.dart,
      ),
      // JS/TS template literals interpolate ${expr}.
      SyntaxLanguage.javascript ||
      SyntaxLanguage.typescript ||
      SyntaxLanguage.jsx ||
      SyntaxLanguage.tsx => _splitInterpolations(
        code,
        tokens,
        simpleDollar: false,
        inner: language,
      ),
      _ => tokens,
    };
  } catch (_) {
    return const <SyntaxToken>[];
  }
}

/// Splits string tokens around interpolations: `${expr}` (all languages with
/// strings) and `$identifier` (Dart only, [simpleDollar]). The interpolation
/// body is tokenized recursively; `$`, braces and the identifier are
/// operator/variable tokens.
List<SyntaxToken> _splitInterpolations(
  String code,
  List<SyntaxToken> tokens, {
  required bool simpleDollar,
  required SyntaxLanguage inner,
}) {
  final out = <SyntaxToken>[];
  for (final token in tokens) {
    if (token.kind != SyntaxTokenKind.string) {
      out.add(token);
      continue;
    }
    out.addAll(
      _splitString(
        code,
        token.start,
        token.end,
        simpleDollar: simpleDollar,
        inner: inner,
      ),
    );
  }
  out.sort((a, b) => a.start.compareTo(b.start));
  return out;
}

List<SyntaxToken> _splitString(
  String code,
  int start,
  int end, {
  required bool simpleDollar,
  required SyntaxLanguage inner,
}) {
  final parts = <SyntaxToken>[];
  var i = start;
  var chunk = start;
  void flush(int textEnd) {
    if (textEnd > chunk) {
      parts.add(SyntaxToken(SyntaxTokenKind.string, chunk, textEnd));
    }
  }

  while (i < end) {
    final c = code.codeUnitAt(i);
    if (c == _backslash) {
      i += 2; // escaped char (incl. \$ and \\): never an interpolation
      continue;
    }
    if (c != _dollar) {
      i++;
      continue;
    }
    final next = i + 1 < end ? code.codeUnitAt(i + 1) : -1;
    if (next == _openBrace) {
      final close = _findBraceEnd(code, i + 2, end);
      flush(i);
      parts.add(SyntaxToken(SyntaxTokenKind.operator, i, i + 2)); // ${
      for (final t in tokenize(code.substring(i + 2, close), inner)) {
        parts.add(SyntaxToken(t.kind, t.start + i + 2, t.end + i + 2));
      }
      if (close < end) {
        parts.add(SyntaxToken(SyntaxTokenKind.operator, close, close + 1)); // }
      }
      i = close + 1;
      chunk = i;
    } else if (simpleDollar && next >= 0 && _isIdentStart(next)) {
      var j = i + 1;
      while (j < end && _isIdentPart(code.codeUnitAt(j))) {
        j++;
      }
      flush(i);
      parts.add(SyntaxToken(SyntaxTokenKind.operator, i, i + 1)); // $
      parts.add(SyntaxToken(SyntaxTokenKind.variable, i + 1, j)); // name
      i = j;
      chunk = i;
    } else {
      i++;
    }
  }
  flush(end);
  return parts;
}

/// Index of the `}` closing the `{` opened before [start], or [end] when
/// unbalanced. Plain brace counting — good enough for interpolation bodies.
int _findBraceEnd(String code, int start, int end) {
  var depth = 1;
  var i = start;
  while (i < end && depth > 0) {
    final c = code.codeUnitAt(i);
    if (c == _openBrace) {
      depth++;
    } else if (c == _closeBrace) {
      depth--;
      if (depth == 0) return i;
    }
    i++;
  }
  return i < end ? i : end;
}

bool _isIdentStart(int c) =>
    (c >= 0x41 && c <= 0x5A) || (c >= 0x61 && c <= 0x7A) || c == 0x5F;

bool _isIdentPart(int c) => _isIdentStart(c) || (c >= 0x30 && c <= 0x39);

/// Builds colored [TextSpan]s for [code] in [language].
///
/// [base] supplies font/size (usually the ambient mono style); each token
/// kind overrides the color via [colors]. A null [language] (or unknown)
/// yields a single plain span. Never throws.
List<TextSpan> buildSyntaxSpans({
  required String code,
  SyntaxLanguage? language,
  required TextStyle base,
  required SyntaxColors colors,
}) {
  if (language == null || code.isEmpty) {
    return <TextSpan>[TextSpan(text: code, style: base)];
  }
  try {
    final tokens = tokenize(code, language);
    final spans = <TextSpan>[];
    var pos = 0;
    for (final token in tokens) {
      if (token.start > pos) {
        spans.add(
          TextSpan(text: code.substring(pos, token.start), style: base),
        );
      }
      spans.add(
        TextSpan(
          text: code.substring(token.start, token.end),
          style: base.copyWith(color: colors.colorFor(token.kind)),
        ),
      );
      pos = token.end;
    }
    if (pos < code.length) {
      spans.add(TextSpan(text: code.substring(pos), style: base));
    }
    return spans;
  } catch (_) {
    return <TextSpan>[TextSpan(text: code, style: base)];
  }
}

/// Same as [buildSyntaxSpans] under one parent span (for `Text.rich`).
TextSpan syntaxTextSpan({
  required String code,
  SyntaxLanguage? language,
  required TextStyle base,
  required SyntaxColors colors,
}) {
  return TextSpan(
    style: base,
    children: buildSyntaxSpans(
      code: code,
      language: language,
      base: base,
      colors: colors,
    ),
  );
}
