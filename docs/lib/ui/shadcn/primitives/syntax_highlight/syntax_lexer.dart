// The rule type and the matching engine behind the syntax scanners.
//
// Every language is a priority-ordered list of [SyntaxScanRule]s: comments and
// strings first so keywords inside them lose, then literals, then keywords,
// then names. The engine resolves overlaps by rule order, so a later rule never
// recolors an earlier rule's span.
//
// The rule lists themselves live in one file per language family
// (`syntax_scanners_c_like.dart`, `syntax_scanners_script.dart`,
// `syntax_scanners_markup.dart`); `syntax_scanners.dart` dispatches by language
// and is the entry point consumers use.

import '../../theme/syntax_colors.dart';
import 'syntax_token.dart';

class SyntaxScanRule {
  const SyntaxScanRule(this.pattern, this.kind);

  /// The pattern to match.
  final RegExp pattern;

  /// The kind assigned to every match.
  final SyntaxTokenKind kind;
}

class _Entry {
  _Entry(this.rule, this.token);
  final int rule;
  final SyntaxToken token;
}

/// Runs [rules] over [code] and returns non-overlapping tokens sorted by
/// position. Earlier rules win overlaps; leading whitespace is trimmed from
/// every token (it is plain anyway).
List<SyntaxToken> lexScanRules(String code, List<SyntaxScanRule> rules) {
  final entries = <_Entry>[];
  for (var r = 0; r < rules.length; r++) {
    for (final match in rules[r].pattern.allMatches(code)) {
      var start = match.start;
      final int end = match.end;
      while (start < end && (code[start] == ' ' || code[start] == '\t')) {
        start++;
      }
      if (start < end) {
        entries.add(_Entry(r, SyntaxToken(rules[r].kind, start, end)));
      }
    }
  }
  entries.sort((a, b) {
    final byStart = a.token.start.compareTo(b.token.start);
    if (byStart != 0) return byStart;
    final byRule = a.rule.compareTo(b.rule);
    if (byRule != 0) return byRule;
    return b.token.end.compareTo(a.token.end);
  });
  final out = <SyntaxToken>[];
  var lastEnd = 0;
  for (final entry in entries) {
    if (entry.token.start < lastEnd) continue; // overlapped: lower priority
    out.add(entry.token);
    lastEnd = entry.token.end;
  }
  return out;
}
