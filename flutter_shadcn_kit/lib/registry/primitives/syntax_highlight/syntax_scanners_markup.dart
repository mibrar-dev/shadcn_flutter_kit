// Markup and data-family rule lists: HTML, CSS, JSON, YAML, Markdown.
//
// These are the formats whose tokens are structural (tags, selectors, keys)
// rather than lexical, so each list is driven by the delimiter that opens the
// construct instead of by a shared keyword set.

import '../../theme/syntax_colors.dart';
import 'syntax_lexer.dart';

// ---------------------------------------------------------------------------
// HTML
// ---------------------------------------------------------------------------

final List<SyntaxScanRule> htmlScanRules = <SyntaxScanRule>[
  SyntaxScanRule(RegExp(r'<!--[\s\S]*?-->'), SyntaxTokenKind.comment),
  SyntaxScanRule(
    RegExp(r'<!DOCTYPE[^>]*>', caseSensitive: false),
    SyntaxTokenKind.keyword,
  ),
  SyntaxScanRule(RegExp(r'</?[A-Za-z][\w-]*'), SyntaxTokenKind.tag),
  SyntaxScanRule(RegExp(r'[A-Za-z_][\w-]*(?=\s*=)'), SyntaxTokenKind.attribute),
  SyntaxScanRule(
    RegExp(
      r'"(?:\\.|[^"\\])*"' // "..."
      r"|\'(?:\\.|[^\'\\])*'", // '...'
    ),
    SyntaxTokenKind.string,
  ),
  SyntaxScanRule(RegExp(r'&[\w#]+;'), SyntaxTokenKind.constant),
  SyntaxScanRule(RegExp(r'/?>'), SyntaxTokenKind.operator),
];

// ---------------------------------------------------------------------------
// CSS
// ---------------------------------------------------------------------------

final List<SyntaxScanRule> cssScanRules = <SyntaxScanRule>[
  SyntaxScanRule(RegExp(r'/\*[\s\S]*?\*/'), SyntaxTokenKind.comment),
  SyntaxScanRule(RegExp(r'@[\w-]+'), SyntaxTokenKind.annotation),
  SyntaxScanRule(
    RegExp(
      r'"(?:\\.|[^"\\\n])*"' // "..."
      r"|\'(?:\\.|[^\'\\\n])*'", // '...'
    ),
    SyntaxTokenKind.string,
  ),
  SyntaxScanRule(RegExp(r'#[0-9A-Fa-f]{3,8}\b'), SyntaxTokenKind.constant),
  // Selector line: everything up to the opening brace (stops before ':' so
  // pseudo-classes/elements match the annotation rule below; the lookahead
  // keeps property lines like `color: red;` out).
  SyntaxScanRule(
    RegExp(r'^[^{}\n:]+(?=[^{}\n]*\{)', multiLine: true),
    SyntaxTokenKind.type,
  ),
  SyntaxScanRule(
    RegExp(r'::?[a-z-]+(?:\([^)]*\))?', caseSensitive: false),
    SyntaxTokenKind.annotation,
  ),
  // Property name: identifier directly followed by a colon.
  SyntaxScanRule(RegExp(r'[a-zA-Z-][\w-]*(?=\s*:)'), SyntaxTokenKind.variable),
  SyntaxScanRule(
    RegExp(
      r'\b\d+(?:\.\d+)?(?:px|em|rem|%|vh|vw|vmin|vmax|s|ms|deg|fr|ch|ex|cm|mm|in|pt|pc)?\b',
    ),
    SyntaxTokenKind.number,
  ),
  SyntaxScanRule(RegExp(r'!important\b'), SyntaxTokenKind.annotation),
  SyntaxScanRule(RegExp(r'[{}();:,.>+~*=%]'), SyntaxTokenKind.operator),
];

// ---------------------------------------------------------------------------
// JSON
// ---------------------------------------------------------------------------

final List<SyntaxScanRule> jsonScanRules = <SyntaxScanRule>[
  // Keys: a string immediately followed by a colon.
  SyntaxScanRule(
    RegExp(r'"(?:\\.|[^"\\\n])*"(?=\s*:)'),
    SyntaxTokenKind.attribute,
  ),
  SyntaxScanRule(RegExp(r'"(?:\\.|[^"\\\n])*"'), SyntaxTokenKind.string),
  SyntaxScanRule(
    RegExp(r'-?\b\d+(?:\.\d+)?(?:[eE][+-]?\d+)?\b'),
    SyntaxTokenKind.number,
  ),
  SyntaxScanRule(RegExp(r'\b(?:true|false|null)\b'), SyntaxTokenKind.constant),
  SyntaxScanRule(RegExp(r'[{}\[\]:,]'), SyntaxTokenKind.operator),
];

// ---------------------------------------------------------------------------
// YAML
// ---------------------------------------------------------------------------

final List<SyntaxScanRule> yamlScanRules = <SyntaxScanRule>[
  SyntaxScanRule(
    RegExp(r'(?:^|[\s])#[^\n]*', multiLine: true),
    SyntaxTokenKind.comment,
  ),
  SyntaxScanRule(
    RegExp(
      r'"(?:\\.|[^"\\\n])*"' // "..."
      r"|'(?:[^']|'')*'", // '...' ('' is an escaped quote)
    ),
    SyntaxTokenKind.string,
  ),
  SyntaxScanRule(
    RegExp(r'^[ \t]*[\w./-]+(?=\s*:)', multiLine: true),
    SyntaxTokenKind.variable,
  ),
  SyntaxScanRule(RegExp(r'\$\{[^}]*\}'), SyntaxTokenKind.variable),
  SyntaxScanRule(
    RegExp(r'\b(?:true|false|null|yes|no|on|off|~)\b'),
    SyntaxTokenKind.constant,
  ),
  SyntaxScanRule(RegExp(r'\b\d+(?:\.\d+)?\b'), SyntaxTokenKind.number),
  SyntaxScanRule(
    RegExp(r'^\s*(?:---|\.\.\.)\s*$', multiLine: true),
    SyntaxTokenKind.operator,
  ),
  SyntaxScanRule(RegExp(r'[-{}[\],:&*!|>]'), SyntaxTokenKind.operator),
];

// ---------------------------------------------------------------------------
// Markdown (best-effort structural coloring)
// ---------------------------------------------------------------------------

final List<SyntaxScanRule> markdownScanRules = <SyntaxScanRule>[
  SyntaxScanRule(
    RegExp(r'^#{1,6}[^\n]*', multiLine: true),
    SyntaxTokenKind.keyword,
  ),
  SyntaxScanRule(
    RegExp(r'^```[\s\S]*?^```|^~~~[\s\S]*?~~~', multiLine: true),
    SyntaxTokenKind.string,
  ),
  SyntaxScanRule(RegExp(r'`[^`\n]*`'), SyntaxTokenKind.string),
  SyntaxScanRule(
    RegExp(r'\*\*[^*\n]+\*\*|__[^_\n]+__'),
    SyntaxTokenKind.constant,
  ),
  SyntaxScanRule(
    RegExp(r'!\[[^\]\n]*\]\([^)\n]*\)|\[[^\]\n]*\]\([^)\n]*\)'),
    SyntaxTokenKind.tag,
  ),
  SyntaxScanRule(
    RegExp(r'^\s*(?:[-*+]|\d+\.)\s', multiLine: true),
    SyntaxTokenKind.operator,
  ),
  SyntaxScanRule(
    RegExp(r'^\s*>{1,6}\s?', multiLine: true),
    SyntaxTokenKind.comment,
  ),
  SyntaxScanRule(
    RegExp(r'^\s*(?:-{3,}|\*{3,}|_{3,})\s*$', multiLine: true),
    SyntaxTokenKind.operator,
  ),
  SyntaxScanRule(RegExp(r'https?://[^\s)\]]+'), SyntaxTokenKind.attribute),
];
