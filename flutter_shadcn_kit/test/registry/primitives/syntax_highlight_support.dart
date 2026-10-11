// Shared helpers for the syntax-highlight goldens.
//
// The goldens pin the exact token-kind sequence a snippet tokenizes into, not
// just the kinds at a few offsets: a rule change in `syntax_scanners*.dart`
// then fails loudly instead of quietly recoloring code. Every golden also
// re-asserts the span round-trip contract, so a golden can never be added that
// breaks selection/copy.

import 'package:flutter/widgets.dart';

import 'package:flutter_shadcn_kit/registry/primitives/syntax_highlight/syntax_highlight.dart';
import 'package:flutter_shadcn_kit/registry/theme/syntax_colors.dart';
import 'package:flutter_test/flutter_test.dart';

/// Parses a whitespace-separated kind list ('comment keyword type') into the
/// kinds a golden expects; newlines are just whitespace.
///
/// An unknown name throws, so a typo fails the test instead of silently
/// widening it.
List<SyntaxTokenKind> kinds(String spec) => <SyntaxTokenKind>[
  for (final name in spec.split(RegExp(r'\s+')))
    if (name.isNotEmpty) SyntaxTokenKind.values.byName(name),
];

/// The token kinds [code] tokenizes into, in order. Gaps between tokens are
/// plain text, so this is the complete recognized-token sequence.
List<SyntaxTokenKind> kindSequence(String code, SyntaxLanguage language) =>
    <SyntaxTokenKind>[for (final token in tokenize(code, language)) token.kind];

/// Asserts the exact kind sequence of [code].
void expectKinds(
  String code,
  SyntaxLanguage language,
  List<SyntaxTokenKind> expected,
) {
  expect(kindSequence(code, language), expected);
}

/// Asserts the span round trip: tokens are sorted, non-overlapping and in
/// bounds, and the spans built from them concatenate back to [code] — the
/// contract that keeps selection and copy plain.
void expectRoundTrip(String code, SyntaxLanguage language) {
  final tokens = tokenize(code, language);
  var lastEnd = 0;
  for (final token in tokens) {
    expect(token.start, greaterThanOrEqualTo(lastEnd), reason: 'overlap');
    expect(token.end, lessThanOrEqualTo(code.length), reason: 'out of bounds');
    expect(token.end, greaterThan(token.start), reason: 'empty token');
    lastEnd = token.end;
  }
  final spans = buildSyntaxSpans(
    code: code,
    language: language,
    base: const TextStyle(),
    colors: SyntaxColors.light,
  );
  final buffer = StringBuffer();
  for (final span in spans) {
    buffer.write(span.text);
  }
  expect(buffer.toString(), code);
}

/// One golden: [code] tokenizes to exactly [expected] and its spans round-trip.
void expectGolden(
  String code,
  SyntaxLanguage language,
  List<SyntaxTokenKind> expected,
) {
  expectRoundTrip(code, language);
  expectKinds(code, language, expected);
}
