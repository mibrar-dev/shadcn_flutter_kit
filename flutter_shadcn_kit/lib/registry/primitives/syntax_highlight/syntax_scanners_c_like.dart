// C-like family rule lists: Dart, Kotlin, Swift.
//
// All three share one shape — line and block comments, string literals (with
// raw or triple-quoted variants), `@`-annotations, keywords, numbers,
// capitalized type names, `.member` variables and call-site functions — so they
// sit together; only the literal and keyword sets differ.

import '../../theme/syntax_colors.dart';
import 'syntax_lexer.dart';

// ---------------------------------------------------------------------------
// Dart
// ---------------------------------------------------------------------------

final List<SyntaxScanRule> dartScanRules = <SyntaxScanRule>[
  SyntaxScanRule(RegExp(r'//[^\n]*|/\*[\s\S]*?\*/'), SyntaxTokenKind.comment),
  SyntaxScanRule(
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
  SyntaxScanRule(RegExp(r'@[A-Za-z_]\w*'), SyntaxTokenKind.annotation),
  SyntaxScanRule(
    RegExp(
      r'\b(?:abstract|as|assert|async|await|break|case|catch|class|const|continue|default|do|else|enum|export|extends|extension|external|factory|final|for|get|hide|if|implements|import|in|interface|is|late|library|mixin|new|on|operator|part|required|rethrow|return|sealed|set|show|static|super|switch|sync|this|throw|try|typedef|var|void|while|with|yield)\b',
    ),
    SyntaxTokenKind.keyword,
  ),
  SyntaxScanRule(RegExp(r'\b(?:true|false|null)\b'), SyntaxTokenKind.constant),
  SyntaxScanRule(
    RegExp(r'\b\d[\d_]*(?:\.\d+)?(?:[eE][+-]?\d+)?\b'),
    SyntaxTokenKind.number,
  ),
  // ALL_CAPS names are constants and must win over the type rule below,
  // whose character class is a superset of this one.
  SyntaxScanRule(RegExp(r'\b[A-Z][A-Z0-9_]{2,}\b'), SyntaxTokenKind.constant),
  SyntaxScanRule(RegExp(r'\b[A-Z][A-Za-z0-9_]*\b'), SyntaxTokenKind.type),
  SyntaxScanRule(RegExp(r'\.[A-Za-z_]\w*'), SyntaxTokenKind.variable),
  SyntaxScanRule(
    RegExp(r'\b[a-z_][A-Za-z0-9_]*(?=\s*\()'),
    SyntaxTokenKind.function,
  ),
  SyntaxScanRule(RegExp(r'[=!<>+\-*/%&|^~?:]+'), SyntaxTokenKind.operator),
];

// ---------------------------------------------------------------------------
// Kotlin
// ---------------------------------------------------------------------------

final List<SyntaxScanRule> kotlinScanRules = <SyntaxScanRule>[
  SyntaxScanRule(RegExp(r'//[^\n]*|/\*[\s\S]*?\*/'), SyntaxTokenKind.comment),
  SyntaxScanRule(
    RegExp(r'"""[\s\S]*?"""|"(?:\\.|[^"\\\n])*"'),
    SyntaxTokenKind.string,
  ),
  SyntaxScanRule(RegExp(r'@[A-Za-z_]\w*'), SyntaxTokenKind.annotation),
  SyntaxScanRule(
    RegExp(
      r'\b(?:package|import|class|interface|object|fun|val|var|return|if|else|when|for|while|do|try|catch|finally|throw|is|in|as|by|constructor|init|companion|data|sealed|abstract|open|override|private|public|internal|protected|lateinit|suspend|inline|reified|out|infix|operator|this|super|null|true|false|typealias|enum|annotation|break|continue|where|dynamic|vararg|tailrec|external|const|actual|expect)\b',
    ),
    SyntaxTokenKind.keyword,
  ),
  SyntaxScanRule(
    RegExp(r'\b0[xX][0-9A-Fa-f_]+|\b\d[\d_]*(?:\.\d+)?[fFL]?\b'),
    SyntaxTokenKind.number,
  ),
  SyntaxScanRule(RegExp(r'\b[A-Z][A-Za-z0-9_]*\b'), SyntaxTokenKind.type),
  SyntaxScanRule(RegExp(r'\.[A-Za-z_]\w*'), SyntaxTokenKind.variable),
  SyntaxScanRule(RegExp(r'\b[a-z_]\w*(?=\s*\()'), SyntaxTokenKind.function),
];

// ---------------------------------------------------------------------------
// Swift
// ---------------------------------------------------------------------------

final List<SyntaxScanRule> swiftScanRules = <SyntaxScanRule>[
  SyntaxScanRule(RegExp(r'//[^\n]*|/\*[\s\S]*?\*/'), SyntaxTokenKind.comment),
  SyntaxScanRule(
    RegExp(r'"""[\s\S]*?"""|"(?:\\.|[^"\\\n])*"'),
    SyntaxTokenKind.string,
  ),
  SyntaxScanRule(RegExp(r'@[A-Za-z_]\w*'), SyntaxTokenKind.annotation),
  SyntaxScanRule(
    RegExp(
      r'\b(?:import|class|struct|enum|protocol|extension|func|let|var|return|if|else|guard|switch|case|default|for|while|do|catch|throw|throws|rethrows|try|init|deinit|self|super|nil|true|false|typealias|associatedtype|where|in|is|as|any|some|mutating|nonmutating|static|final|override|public|private|internal|fileprivate|open|lazy|weak|unowned|convenience|required|dynamic|optional|indirect|operator|precedencegroup|async|await|actor|isolated|nonisolated|macro|package|consuming|borrowing)\b',
    ),
    SyntaxTokenKind.keyword,
  ),
  SyntaxScanRule(RegExp(r'\b\d[\d_]*(?:\.\d+)?\b'), SyntaxTokenKind.number),
  SyntaxScanRule(RegExp(r'\b[A-Z][A-Za-z0-9_]*\b'), SyntaxTokenKind.type),
  SyntaxScanRule(RegExp(r'\.[A-Za-z_]\w*'), SyntaxTokenKind.variable),
  SyntaxScanRule(RegExp(r'\b[a-z_]\w*(?=\s*\()'), SyntaxTokenKind.function),
];
