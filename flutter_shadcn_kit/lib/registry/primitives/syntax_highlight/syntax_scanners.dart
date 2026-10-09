// Per-language lexer rule lists for the syntax highlighter, plus the rule
// engine that runs them. Every language is a priority-ordered list of
// [RegExp] rules: comments and strings first so keywords inside them lose,
// then literals, then keywords, then names. The engine resolves overlaps by
// rule order, so a later rule never recolors an earlier rule's span.

import '../../theme/syntax_colors.dart';
import 'syntax_language.dart';
import 'syntax_token.dart';

/// One lexer rule: [pattern] matched anywhere in the source, every match
/// becomes a [SyntaxToken] of [kind].
class _Rule {
  const _Rule(this.pattern, this.kind);

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
List<SyntaxToken> _lex(String code, List<_Rule> rules) {
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

// ---------------------------------------------------------------------------
// Dart
// ---------------------------------------------------------------------------

final List<_Rule> _dartRules = <_Rule>[
  _Rule(RegExp(r'//[^\n]*|/\*[\s\S]*?\*/'), SyntaxTokenKind.comment),
  _Rule(
    RegExp(
      // Adjacent raw-string pieces: the pattern contains both """ and '''
      // sequences, so no single raw literal can hold it.
      r'r"""[\s\S]*?"""' // raw triple-double
      r"|r'''[\s\S]*?'''" // raw triple-single
      r'|"""[\s\S]*?"""' // triple-double
      r"|'''[\s\S]*?'''" // triple-single
      r'|r?"(?:\\.|[^"\\\n])*"' // "..."
      r"|r?'(?:\\.|[^'\\\n])*'", // '...'
    ),
    SyntaxTokenKind.string,
  ),
  _Rule(RegExp(r'@[A-Za-z_]\w*'), SyntaxTokenKind.annotation),
  _Rule(
    RegExp(
      r'\b(?:abstract|as|assert|async|await|break|case|catch|class|const|continue|default|do|else|enum|export|extends|extension|external|factory|final|for|get|hide|if|implements|import|in|interface|is|late|library|mixin|new|on|operator|part|required|rethrow|return|sealed|set|show|static|super|switch|sync|this|throw|try|typedef|var|void|while|with|yield)\b',
    ),
    SyntaxTokenKind.keyword,
  ),
  _Rule(RegExp(r'\b(?:true|false|null)\b'), SyntaxTokenKind.constant),
  _Rule(
    RegExp(r'\b\d[\d_]*(?:\.\d+)?(?:[eE][+-]?\d+)?\b'),
    SyntaxTokenKind.number,
  ),
  _Rule(RegExp(r'\b[A-Z][A-Za-z0-9_]*\b'), SyntaxTokenKind.type),
  _Rule(RegExp(r'\b[A-Z][A-Z0-9_]{2,}\b'), SyntaxTokenKind.constant),
  _Rule(RegExp(r'\.[A-Za-z_]\w*'), SyntaxTokenKind.variable),
  _Rule(RegExp(r'\b[a-z_][A-Za-z0-9_]*(?=\s*\()'), SyntaxTokenKind.function),
  _Rule(RegExp(r'[=!<>+\-*/%&|^~?:]+'), SyntaxTokenKind.operator),
];

// ---------------------------------------------------------------------------
// JavaScript / TypeScript (shared core; TS adds a few keywords)
// ---------------------------------------------------------------------------

final List<_Rule> _jsRules = <_Rule>[
  _Rule(RegExp(r'//[^\n]*|/\*[\s\S]*?\*/'), SyntaxTokenKind.comment),
  _Rule(
    RegExp(
      r'`(?:\\.|[^`\\])*`' // `template ${}`
      r'|"(?:\\.|[^"\\\n])*"' // "..."
      r"|\'(?:\\.|[^\'\\\n])*'", // '...'
    ),
    SyntaxTokenKind.string,
  ),
  _Rule(RegExp(r'@[A-Za-z_]\w*'), SyntaxTokenKind.annotation),
  _Rule(
    RegExp(
      r'\b(?:async|await|break|case|catch|class|const|continue|debugger|default|delete|do|else|export|extends|finally|for|from|function|get|if|implements|import|in|instanceof|interface|let|new|of|operator|private|protected|public|readonly|return|set|static|super|switch|this|throw|try|typeof|var|void|while|with|yield|as|satisfies|declare|namespace|abstract|enum|keyof|infer|is|unique|global|asserts)\b',
    ),
    SyntaxTokenKind.keyword,
  ),
  _Rule(
    RegExp(r'\b(?:true|false|null|undefined|NaN|Infinity)\b'),
    SyntaxTokenKind.constant,
  ),
  _Rule(
    RegExp(r'\b0[xX][0-9A-Fa-f_]+|\b\d[\d_]*(?:\.\d+)?(?:[eE][+-]?\d+)?\b'),
    SyntaxTokenKind.number,
  ),
  _Rule(RegExp(r'\b[A-Z][A-Za-z0-9_]*\b'), SyntaxTokenKind.type),
  // Lowercase built-in types (string, number, boolean, …).
  _Rule(
    RegExp(
      r'\b(?:string|number|boolean|any|unknown|never|object|symbol|bigint)\b',
    ),
    SyntaxTokenKind.type,
  ),
  _Rule(RegExp(r'\.[A-Za-z_$][\w$]*'), SyntaxTokenKind.variable),
  _Rule(RegExp(r'\b[a-z_$][\w$]*(?=\s*\()'), SyntaxTokenKind.function),
  _Rule(RegExp(r'[=!<>+\-*/%&|^~?:]+'), SyntaxTokenKind.operator),
];

/// JSX/TSX: the JS core plus tag and attribute rules (basics only).
List<_Rule> _jsxRules({required bool typescript}) {
  return <_Rule>[
    _Rule(RegExp(r'//[^\n]*|/\*[\s\S]*?\*/'), SyntaxTokenKind.comment),
    _Rule(
      RegExp(
        r'`(?:\\.|[^`\\])*`' // `template ${}`
        r'|"(?:\\.|[^"\\\n])*"' // "..."
        r"|\'(?:\\.|[^\'\\\n])*'", // '...'
      ),
      SyntaxTokenKind.string,
    ),
    _Rule(RegExp(r'</?[A-Za-z][\w.-]*'), SyntaxTokenKind.tag),
    _Rule(RegExp(r'[A-Za-z_][\w.-]*(?=\s*=)'), SyntaxTokenKind.attribute),
    _Rule(RegExp(r'@[A-Za-z_]\w*'), SyntaxTokenKind.annotation),
    _Rule(
      RegExp(
        typescript
            ? r'\b(?:async|await|break|case|catch|class|const|continue|debugger|default|delete|do|else|export|extends|finally|for|from|function|get|if|implements|import|in|instanceof|interface|let|new|of|operator|private|protected|public|readonly|return|set|static|super|switch|this|throw|try|typeof|var|void|while|with|yield|as|satisfies|declare|namespace|abstract|enum|keyof|infer|is|unique|global|asserts)\b'
            : r'\b(?:async|await|break|case|catch|class|const|continue|debugger|default|delete|do|else|export|extends|finally|for|from|function|get|if|implements|import|in|instanceof|interface|let|new|of|operator|private|protected|public|readonly|return|set|static|super|switch|this|throw|try|typeof|var|void|while|with|yield|as|satisfies|declare|namespace|abstract|enum|keyof|infer|is|unique|global|asserts)\b',
      ),
      SyntaxTokenKind.keyword,
    ),
    _Rule(
      RegExp(r'\b(?:true|false|null|undefined|NaN|Infinity)\b'),
      SyntaxTokenKind.constant,
    ),
    _Rule(
      RegExp(r'\b0[xX][0-9A-Fa-f_]+|\b\d[\d_]*(?:\.\d+)?(?:[eE][+-]?\d+)?\b'),
      SyntaxTokenKind.number,
    ),
    _Rule(RegExp(r'\b[A-Z][A-Za-z0-9_]*\b'), SyntaxTokenKind.type),
    _Rule(RegExp(r'\.[A-Za-z_$][\w$]*'), SyntaxTokenKind.variable),
    _Rule(RegExp(r'\b[a-z_$][\w$]*(?=\s*\()'), SyntaxTokenKind.function),
    _Rule(RegExp(r'[=!<>+\-*/%&|^~?:]+'), SyntaxTokenKind.operator),
  ];
}

// ---------------------------------------------------------------------------
// Python
// ---------------------------------------------------------------------------

final List<_Rule> _pythonRules = <_Rule>[
  _Rule(RegExp(r'#[^\n]*'), SyntaxTokenKind.comment),
  _Rule(
    RegExp(
      r'[rbfu]{0,2}"""[\s\S]*?"""' // """docstring"""
      r"|[rbfu]{0,2}'''[\s\S]*?'''" // '''docstring'''
      r'''|[rbfu]{0,2}"(?:\\.|[^"\\\n])*"''' // "..."
      r"|[rbfu]{0,2}'(?:\\.|[^'\\\n])*'", // '...'
    ),
    SyntaxTokenKind.string,
  ),
  _Rule(RegExp(r'@[A-Za-z_]\w*'), SyntaxTokenKind.annotation),
  _Rule(
    RegExp(
      r'\b(?:False|None|True|and|as|assert|async|await|break|class|continue|def|del|elif|else|except|finally|for|from|global|if|import|in|is|lambda|nonlocal|not|or|pass|raise|return|try|while|with|yield|match|case|type)\b',
    ),
    SyntaxTokenKind.keyword,
  ),
  _Rule(
    RegExp(r'\b\d[\d_]*(?:\.\d+)?(?:[eE][+-]?\d+)?[jJ]?\b'),
    SyntaxTokenKind.number,
  ),
  _Rule(RegExp(r'\b[A-Z][A-Z0-9_]{2,}\b'), SyntaxTokenKind.constant),
  _Rule(RegExp(r'\.[A-Za-z_]\w*'), SyntaxTokenKind.variable),
  _Rule(RegExp(r'\bself\b'), SyntaxTokenKind.variable),
  _Rule(RegExp(r'\b[a-z_]\w*(?=\s*\()'), SyntaxTokenKind.function),
];

// ---------------------------------------------------------------------------
// JSON
// ---------------------------------------------------------------------------

final List<_Rule> _jsonRules = <_Rule>[
  // Keys: a string immediately followed by a colon.
  _Rule(RegExp(r'"(?:\\.|[^"\\\n])*"(?=\s*:)'), SyntaxTokenKind.attribute),
  _Rule(RegExp(r'"(?:\\.|[^"\\\n])*"'), SyntaxTokenKind.string),
  _Rule(
    RegExp(r'-?\b\d+(?:\.\d+)?(?:[eE][+-]?\d+)?\b'),
    SyntaxTokenKind.number,
  ),
  _Rule(RegExp(r'\b(?:true|false|null)\b'), SyntaxTokenKind.constant),
  _Rule(RegExp(r'[{}\[\]:,]'), SyntaxTokenKind.operator),
];

// ---------------------------------------------------------------------------
// YAML
// ---------------------------------------------------------------------------

final List<_Rule> _yamlRules = <_Rule>[
  _Rule(RegExp(r'(?:^|[\s])#[^\n]*', multiLine: true), SyntaxTokenKind.comment),
  _Rule(
    RegExp(
      r'"(?:\\.|[^"\\\n])*"' // "..."
      r"'(?:[^']|'')*'", // '...' ('' is an escaped quote)
    ),
    SyntaxTokenKind.string,
  ),
  _Rule(
    RegExp(r'^[ \t]*[\w./-]+(?=\s*:)', multiLine: true),
    SyntaxTokenKind.variable,
  ),
  _Rule(RegExp(r'\$\{[^}]*\}'), SyntaxTokenKind.variable),
  _Rule(
    RegExp(r'\b(?:true|false|null|yes|no|on|off|~)\b'),
    SyntaxTokenKind.constant,
  ),
  _Rule(RegExp(r'\b\d+(?:\.\d+)?\b'), SyntaxTokenKind.number),
  _Rule(
    RegExp(r'^\s*(?:---|\.\.\.)\s*$', multiLine: true),
    SyntaxTokenKind.operator,
  ),
  _Rule(RegExp(r'[-{}[\],:&*!|>]'), SyntaxTokenKind.operator),
];

// ---------------------------------------------------------------------------
// Bash / shell
// ---------------------------------------------------------------------------

final List<_Rule> _bashRules = <_Rule>[
  _Rule(
    RegExp(
      r'"(?:\\.|[^"\\\n])*"' // "..."
      r"|\'(?:\\.|[^\'\\\n])*'", // '...'
    ),
    SyntaxTokenKind.string,
  ),
  // '#' starts a comment only at line start or after whitespace.
  _Rule(
    RegExp(r'(?:^|[\s(])#[^\n]*', multiLine: true),
    SyntaxTokenKind.comment,
  ),
  _Rule(RegExp(r'\$\{[^}]*\}|\$\w+'), SyntaxTokenKind.variable),
  _Rule(
    RegExp(
      r'\b(?:if|then|else|elif|fi|for|while|until|do|done|case|esac|function|in|echo|printf|return|exit|local|export|source|alias|unalias|set|unset|shift|read|cd|ls|mkdir|rm|cp|mv|cat|grep|find|chmod|chown|sudo|apt|brew|flutter|dart|npm|npx|node|git|curl|wget|pip|python|sh|bash|zsh|true|false)\b',
    ),
    SyntaxTokenKind.keyword,
  ),
  _Rule(RegExp(r'\b\d+\b'), SyntaxTokenKind.number),
  _Rule(RegExp(r'--?[\w][\w-]*'), SyntaxTokenKind.constant),
  _Rule(RegExp(r'[|&;<>()$]'), SyntaxTokenKind.operator),
];

// ---------------------------------------------------------------------------
// HTML
// ---------------------------------------------------------------------------

final List<_Rule> _htmlRules = <_Rule>[
  _Rule(RegExp(r'<!--[\s\S]*?-->'), SyntaxTokenKind.comment),
  _Rule(
    RegExp(r'<!DOCTYPE[^>]*>', caseSensitive: false),
    SyntaxTokenKind.keyword,
  ),
  _Rule(RegExp(r'</?[A-Za-z][\w-]*'), SyntaxTokenKind.tag),
  _Rule(RegExp(r'[A-Za-z_][\w-]*(?=\s*=)'), SyntaxTokenKind.attribute),
  _Rule(
    RegExp(
      r'"(?:\\.|[^"\\])*"' // "..."
      r"|\'(?:\\.|[^\'\\])*'", // '...'
    ),
    SyntaxTokenKind.string,
  ),
  _Rule(RegExp(r'&[\w#]+;'), SyntaxTokenKind.constant),
  _Rule(RegExp(r'/?>'), SyntaxTokenKind.operator),
];

// ---------------------------------------------------------------------------
// CSS
// ---------------------------------------------------------------------------

final List<_Rule> _cssRules = <_Rule>[
  _Rule(RegExp(r'/\*[\s\S]*?\*/'), SyntaxTokenKind.comment),
  _Rule(RegExp(r'@[\w-]+'), SyntaxTokenKind.annotation),
  _Rule(
    RegExp(
      r'"(?:\\.|[^"\\\n])*"' // "..."
      r"|\'(?:\\.|[^\'\\\n])*'", // '...'
    ),
    SyntaxTokenKind.string,
  ),
  _Rule(RegExp(r'#[0-9A-Fa-f]{3,8}\b'), SyntaxTokenKind.constant),
  // Selector line: everything up to the opening brace (stops before ':' so
  // pseudo-classes/elements match the annotation rule below; the lookahead
  // keeps property lines like `color: red;` out).
  _Rule(
    RegExp(r'^[^{}\n:]+(?=[^{}\n]*\{)', multiLine: true),
    SyntaxTokenKind.type,
  ),
  _Rule(
    RegExp(r'::?[a-z-]+(?:\([^)]*\))?', caseSensitive: false),
    SyntaxTokenKind.annotation,
  ),
  // Property name: identifier directly followed by a colon.
  _Rule(RegExp(r'[a-zA-Z-][\w-]*(?=\s*:)'), SyntaxTokenKind.variable),
  _Rule(
    RegExp(
      r'\b\d+(?:\.\d+)?(?:px|em|rem|%|vh|vw|vmin|vmax|s|ms|deg|fr|ch|ex|cm|mm|in|pt|pc)?\b',
    ),
    SyntaxTokenKind.number,
  ),
  _Rule(RegExp(r'!important\b'), SyntaxTokenKind.annotation),
  _Rule(RegExp(r'[{}();:,.>+~*=%]'), SyntaxTokenKind.operator),
];

// ---------------------------------------------------------------------------
// Kotlin
// ---------------------------------------------------------------------------

final List<_Rule> _kotlinRules = <_Rule>[
  _Rule(RegExp(r'//[^\n]*|/\*[\s\S]*?\*/'), SyntaxTokenKind.comment),
  _Rule(RegExp(r'"""[\s\S]*?"""|"(?:\\.|[^"\\\n])*"'), SyntaxTokenKind.string),
  _Rule(RegExp(r'@[A-Za-z_]\w*'), SyntaxTokenKind.annotation),
  _Rule(
    RegExp(
      r'\b(?:package|import|class|interface|object|fun|val|var|return|if|else|when|for|while|do|try|catch|finally|throw|is|in|as|by|constructor|init|companion|data|sealed|abstract|open|override|private|public|internal|protected|lateinit|suspend|inline|reified|out|infix|operator|this|super|null|true|false|typealias|enum|annotation|break|continue|where|dynamic|vararg|tailrec|external|const|actual|expect)\b',
    ),
    SyntaxTokenKind.keyword,
  ),
  _Rule(
    RegExp(r'\b0[xX][0-9A-Fa-f_]+|\b\d[\d_]*(?:\.\d+)?[fFL]?\b'),
    SyntaxTokenKind.number,
  ),
  _Rule(RegExp(r'\b[A-Z][A-Za-z0-9_]*\b'), SyntaxTokenKind.type),
  _Rule(RegExp(r'\.[A-Za-z_]\w*'), SyntaxTokenKind.variable),
  _Rule(RegExp(r'\b[a-z_]\w*(?=\s*\()'), SyntaxTokenKind.function),
];

// ---------------------------------------------------------------------------
// Swift
// ---------------------------------------------------------------------------

final List<_Rule> _swiftRules = <_Rule>[
  _Rule(RegExp(r'//[^\n]*|/\*[\s\S]*?\*/'), SyntaxTokenKind.comment),
  _Rule(RegExp(r'"""[\s\S]*?"""|"(?:\\.|[^"\\\n])*"'), SyntaxTokenKind.string),
  _Rule(RegExp(r'@[A-Za-z_]\w*'), SyntaxTokenKind.annotation),
  _Rule(
    RegExp(
      r'\b(?:import|class|struct|enum|protocol|extension|func|let|var|return|if|else|guard|switch|case|default|for|while|do|catch|throw|throws|rethrows|try|init|deinit|self|super|nil|true|false|typealias|associatedtype|where|in|is|as|any|some|mutating|nonmutating|static|final|override|public|private|internal|fileprivate|open|lazy|weak|unowned|convenience|required|dynamic|optional|indirect|operator|precedencegroup|async|await|actor|isolated|nonisolated|macro|package|consuming|borrowing)\b',
    ),
    SyntaxTokenKind.keyword,
  ),
  _Rule(RegExp(r'\b\d[\d_]*(?:\.\d+)?\b'), SyntaxTokenKind.number),
  _Rule(RegExp(r'\b[A-Z][A-Za-z0-9_]*\b'), SyntaxTokenKind.type),
  _Rule(RegExp(r'\.[A-Za-z_]\w*'), SyntaxTokenKind.variable),
  _Rule(RegExp(r'\b[a-z_]\w*(?=\s*\()'), SyntaxTokenKind.function),
];

// ---------------------------------------------------------------------------
// Markdown (best-effort structural coloring)
// ---------------------------------------------------------------------------

final List<_Rule> _markdownRules = <_Rule>[
  _Rule(RegExp(r'^#{1,6}[^\n]*', multiLine: true), SyntaxTokenKind.keyword),
  _Rule(
    RegExp(r'^```[\s\S]*?^```|^~~~[\s\S]*?~~~', multiLine: true),
    SyntaxTokenKind.string,
  ),
  _Rule(RegExp(r'`[^`\n]*`'), SyntaxTokenKind.string),
  _Rule(RegExp(r'\*\*[^*\n]+\*\*|__[^_\n]+__'), SyntaxTokenKind.constant),
  _Rule(
    RegExp(r'!\[[^\]\n]*\]\([^)\n]*\)|\[[^\]\n]*\]\([^)\n]*\)'),
    SyntaxTokenKind.tag,
  ),
  _Rule(
    RegExp(r'^\s*(?:[-*+]|\d+\.)\s', multiLine: true),
    SyntaxTokenKind.operator,
  ),
  _Rule(RegExp(r'^\s*>{1,6}\s?', multiLine: true), SyntaxTokenKind.comment),
  _Rule(
    RegExp(r'^\s*(?:-{3,}|\*{3,}|_{3,})\s*$', multiLine: true),
    SyntaxTokenKind.operator,
  ),
  _Rule(RegExp(r'https?://[^\s)\]]+'), SyntaxTokenKind.attribute),
];

// ---------------------------------------------------------------------------
// Dispatch
// ---------------------------------------------------------------------------

/// Lexes [code] for [language] into non-overlapping tokens (gaps are plain).
List<SyntaxToken> scanLanguage(String code, SyntaxLanguage language) {
  return switch (language) {
    SyntaxLanguage.dart => _lex(code, _dartRules),
    SyntaxLanguage.javascript => _lex(code, _jsRules),
    SyntaxLanguage.typescript => _lex(code, _jsRules),
    SyntaxLanguage.jsx => _lex(code, _jsxRules(typescript: false)),
    SyntaxLanguage.tsx => _lex(code, _jsxRules(typescript: true)),
    SyntaxLanguage.python => _lex(code, _pythonRules),
    SyntaxLanguage.json => _lex(code, _jsonRules),
    SyntaxLanguage.yaml => _lex(code, _yamlRules),
    SyntaxLanguage.bash => _lex(code, _bashRules),
    SyntaxLanguage.html => _lex(code, _htmlRules),
    SyntaxLanguage.css => _lex(code, _cssRules),
    SyntaxLanguage.kotlin => _lex(code, _kotlinRules),
    SyntaxLanguage.swift => _lex(code, _swiftRules),
    SyntaxLanguage.markdown => _lex(code, _markdownRules),
  };
}
