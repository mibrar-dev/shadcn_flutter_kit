// Language dispatch for the syntax scanners: maps a [SyntaxLanguage] to its
// priority-ordered [SyntaxScanRule] list and runs the engine over the source.
//
// The lists live in one file per language family
// (`syntax_scanners_c_like.dart`, `syntax_scanners_script.dart`,
// `syntax_scanners_markup.dart`); [SyntaxScanRule] and the matching engine live
// in `syntax_lexer.dart`.

import 'syntax_language.dart';
import 'syntax_lexer.dart';
import 'syntax_scanners_c_like.dart';
import 'syntax_scanners_markup.dart';
import 'syntax_scanners_script.dart';
import 'syntax_token.dart';

// ---------------------------------------------------------------------------
// Dispatch
// ---------------------------------------------------------------------------

/// Lexes [code] for [language] into non-overlapping tokens (gaps are plain).
List<SyntaxToken> scanLanguage(String code, SyntaxLanguage language) {
  return switch (language) {
    SyntaxLanguage.dart => lexScanRules(code, dartScanRules),
    SyntaxLanguage.javascript => lexScanRules(code, javascriptScanRules),
    SyntaxLanguage.typescript => lexScanRules(code, javascriptScanRules),
    SyntaxLanguage.jsx => lexScanRules(code, jsxScanRules),
    SyntaxLanguage.tsx => lexScanRules(code, jsxScanRules),
    SyntaxLanguage.python => lexScanRules(code, pythonScanRules),
    SyntaxLanguage.json => lexScanRules(code, jsonScanRules),
    SyntaxLanguage.yaml => lexScanRules(code, yamlScanRules),
    SyntaxLanguage.bash => lexScanRules(code, bashScanRules),
    SyntaxLanguage.html => lexScanRules(code, htmlScanRules),
    SyntaxLanguage.css => lexScanRules(code, cssScanRules),
    SyntaxLanguage.kotlin => lexScanRules(code, kotlinScanRules),
    SyntaxLanguage.swift => lexScanRules(code, swiftScanRules),
    SyntaxLanguage.markdown => lexScanRules(code, markdownScanRules),
  };
}
