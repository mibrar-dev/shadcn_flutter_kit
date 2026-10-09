// Script family rule lists: JavaScript / TypeScript / JSX, Python, Bash.

import '../../theme/syntax_colors.dart';
import 'syntax_lexer.dart';

// ---------------------------------------------------------------------------
// JavaScript / TypeScript (shared core; TS reuses the same list)
// ---------------------------------------------------------------------------

final List<SyntaxScanRule> javascriptScanRules = <SyntaxScanRule>[
  SyntaxScanRule(RegExp(r'//[^\n]*|/\*[\s\S]*?\*/'), SyntaxTokenKind.comment),
  SyntaxScanRule(
    RegExp(
      r'`(?:\\.|[^`\\])*`' // `template ${}`
      r'|"(?:\\.|[^"\\\n])*"' // "..."
      r"|\'(?:\\.|[^\'\\\n])*'", // '...'
    ),
    SyntaxTokenKind.string,
  ),
  SyntaxScanRule(RegExp(r'@[A-Za-z_]\w*'), SyntaxTokenKind.annotation),
  SyntaxScanRule(
    RegExp(
      r'\b(?:async|await|break|case|catch|class|const|continue|debugger|default|delete|do|else|export|extends|finally|for|from|function|get|if|implements|import|in|instanceof|interface|let|new|of|operator|private|protected|public|readonly|return|set|static|super|switch|this|throw|try|typeof|var|void|while|with|yield|as|satisfies|declare|namespace|abstract|enum|keyof|infer|is|unique|global|asserts)\b',
    ),
    SyntaxTokenKind.keyword,
  ),
  SyntaxScanRule(
    RegExp(r'\b(?:true|false|null|undefined|NaN|Infinity)\b'),
    SyntaxTokenKind.constant,
  ),
  SyntaxScanRule(
    RegExp(r'\b0[xX][0-9A-Fa-f_]+|\b\d[\d_]*(?:\.\d+)?(?:[eE][+-]?\d+)?\b'),
    SyntaxTokenKind.number,
  ),
  SyntaxScanRule(RegExp(r'\b[A-Z][A-Za-z0-9_]*\b'), SyntaxTokenKind.type),
  // Lowercase built-in types (string, number, boolean, …).
  SyntaxScanRule(
    RegExp(
      r'\b(?:string|number|boolean|any|unknown|never|object|symbol|bigint)\b',
    ),
    SyntaxTokenKind.type,
  ),
  SyntaxScanRule(RegExp(r'\.[A-Za-z_$][\w$]*'), SyntaxTokenKind.variable),
  SyntaxScanRule(RegExp(r'\b[a-z_$][\w$]*(?=\s*\()'), SyntaxTokenKind.function),
  SyntaxScanRule(RegExp(r'[=!<>+\-*/%&|^~?:]+'), SyntaxTokenKind.operator),
];

/// JSX/TSX: the JS core plus tag and attribute rules (basics only). JSX and
/// TSX share one list — the keyword set is the same in both.
final List<SyntaxScanRule> jsxScanRules = <SyntaxScanRule>[
  SyntaxScanRule(RegExp(r'//[^\n]*|/\*[\s\S]*?\*/'), SyntaxTokenKind.comment),
  SyntaxScanRule(
    RegExp(
      r'`(?:\\.|[^`\\])*`' // `template ${}`
      r'|"(?:\\.|[^"\\\n])*"' // "..."
      r"|\'(?:\\.|[^\'\\\n])*'", // '...'
    ),
    SyntaxTokenKind.string,
  ),
  SyntaxScanRule(RegExp(r'</?[A-Za-z][\w.-]*'), SyntaxTokenKind.tag),
  SyntaxScanRule(
    RegExp(r'[A-Za-z_][\w.-]*(?=\s*=)'),
    SyntaxTokenKind.attribute,
  ),
  SyntaxScanRule(RegExp(r'@[A-Za-z_]\w*'), SyntaxTokenKind.annotation),
  SyntaxScanRule(
    RegExp(
      r'\b(?:async|await|break|case|catch|class|const|continue|debugger|default|delete|do|else|export|extends|finally|for|from|function|get|if|implements|import|in|instanceof|interface|let|new|of|operator|private|protected|public|readonly|return|set|static|super|switch|this|throw|try|typeof|var|void|while|with|yield|as|satisfies|declare|namespace|abstract|enum|keyof|infer|is|unique|global|asserts)\b',
    ),
    SyntaxTokenKind.keyword,
  ),
  SyntaxScanRule(
    RegExp(r'\b(?:true|false|null|undefined|NaN|Infinity)\b'),
    SyntaxTokenKind.constant,
  ),
  SyntaxScanRule(
    RegExp(r'\b0[xX][0-9A-Fa-f_]+|\b\d[\d_]*(?:\.\d+)?(?:[eE][+-]?\d+)?\b'),
    SyntaxTokenKind.number,
  ),
  SyntaxScanRule(RegExp(r'\b[A-Z][A-Za-z0-9_]*\b'), SyntaxTokenKind.type),
  SyntaxScanRule(RegExp(r'\.[A-Za-z_$][\w$]*'), SyntaxTokenKind.variable),
  SyntaxScanRule(RegExp(r'\b[a-z_$][\w$]*(?=\s*\()'), SyntaxTokenKind.function),
  SyntaxScanRule(RegExp(r'[=!<>+\-*/%&|^~?:]+'), SyntaxTokenKind.operator),
];

// ---------------------------------------------------------------------------
// Python
// ---------------------------------------------------------------------------

final List<SyntaxScanRule> pythonScanRules = <SyntaxScanRule>[
  SyntaxScanRule(RegExp(r'#[^\n]*'), SyntaxTokenKind.comment),
  SyntaxScanRule(
    RegExp(
      r'[rbfu]{0,2}"""[\s\S]*?"""' // """docstring"""
      r"|[rbfu]{0,2}'''[\s\S]*?'''" // '''docstring'''
      r'''|[rbfu]{0,2}"(?:\\.|[^"\\\n])*"''' // "..."
      r"|[rbfu]{0,2}'(?:\\.|[^'\\\n])*'", // '...'
    ),
    SyntaxTokenKind.string,
  ),
  SyntaxScanRule(RegExp(r'@[A-Za-z_]\w*'), SyntaxTokenKind.annotation),
  SyntaxScanRule(
    RegExp(
      r'\b(?:False|None|True|and|as|assert|async|await|break|class|continue|def|del|elif|else|except|finally|for|from|global|if|import|in|is|lambda|nonlocal|not|or|pass|raise|return|try|while|with|yield|match|case|type)\b',
    ),
    SyntaxTokenKind.keyword,
  ),
  SyntaxScanRule(
    RegExp(r'\b\d[\d_]*(?:\.\d+)?(?:[eE][+-]?\d+)?[jJ]?\b'),
    SyntaxTokenKind.number,
  ),
  SyntaxScanRule(RegExp(r'\b[A-Z][A-Z0-9_]{2,}\b'), SyntaxTokenKind.constant),
  SyntaxScanRule(RegExp(r'\.[A-Za-z_]\w*'), SyntaxTokenKind.variable),
  SyntaxScanRule(RegExp(r'\bself\b'), SyntaxTokenKind.variable),
  SyntaxScanRule(RegExp(r'\b[a-z_]\w*(?=\s*\()'), SyntaxTokenKind.function),
];

// ---------------------------------------------------------------------------
// Bash / shell
// ---------------------------------------------------------------------------

final List<SyntaxScanRule> bashScanRules = <SyntaxScanRule>[
  SyntaxScanRule(
    RegExp(
      r'"(?:\\.|[^"\\\n])*"' // "..."
      r"|\'(?:\\.|[^\'\\\n])*'", // '...'
    ),
    SyntaxTokenKind.string,
  ),
  // '#' starts a comment only at line start or after whitespace.
  SyntaxScanRule(
    RegExp(r'(?:^|[\s(])#[^\n]*', multiLine: true),
    SyntaxTokenKind.comment,
  ),
  SyntaxScanRule(RegExp(r'\$\{[^}]*\}|\$\w+'), SyntaxTokenKind.variable),
  SyntaxScanRule(
    RegExp(
      r'\b(?:if|then|else|elif|fi|for|while|until|do|done|case|esac|function|in|echo|printf|return|exit|local|export|source|alias|unalias|set|unset|shift|read|cd|ls|mkdir|rm|cp|mv|cat|grep|find|chmod|chown|sudo|apt|brew|flutter|dart|npm|npx|node|git|curl|wget|pip|python|sh|bash|zsh|true|false)\b',
    ),
    SyntaxTokenKind.keyword,
  ),
  SyntaxScanRule(RegExp(r'\b\d+\b'), SyntaxTokenKind.number),
  SyntaxScanRule(RegExp(r'--?[\w][\w-]*'), SyntaxTokenKind.constant),
  SyntaxScanRule(RegExp(r'[|&;<>()$]'), SyntaxTokenKind.operator),
];
