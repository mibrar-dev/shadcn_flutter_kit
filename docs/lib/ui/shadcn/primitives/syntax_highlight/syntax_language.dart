// Language identification for syntax highlighting.
//
// Two entry points: [syntaxLanguageFromId] maps an explicit language id or
// fence tag (```` ```dart ````) with aliases (`js`, `ts`, `sh`, `py`, `yml`…)
// to a [SyntaxLanguage]; [syntaxLanguageGuess] conservatively detects a
// language from the code text itself (fence tag first, then high-precision
// content signals) and returns null when nothing matches — unknown stays
// plain. No regex here can throw: all patterns are total.

/// Languages the tokenizer understands. Unknown ids render plain.
enum SyntaxLanguage {
  dart,
  javascript,
  typescript,
  jsx,
  tsx,
  python,
  json,
  yaml,
  bash,
  html,
  css,
  kotlin,
  swift,
  markdown,
}

/// Maps a language id / fence tag to a [SyntaxLanguage].
///
/// Accepts aliases (`js`, `jsx`, `ts`, `tsx`, `node` → javascript/typescript
/// family, `py` → python, `yml` → yaml, `sh`/`zsh`/`shell`/`console` → bash,
/// `md` → markdown, `kt` → kotlin). `null`, empty or unknown ids return
/// null (plain). The match is case-insensitive.
SyntaxLanguage? syntaxLanguageFromId(String? id) {
  if (id == null) return null;
  switch (id.trim().toLowerCase()) {
    case '':
      return null;
    case 'dart':
    case 'flutter':
      return SyntaxLanguage.dart;
    case 'js':
    case 'javascript':
    case 'node':
    case 'cjs':
    case 'mjs':
      return SyntaxLanguage.javascript;
    case 'ts':
    case 'typescript':
    case 'mts':
      return SyntaxLanguage.typescript;
    case 'jsx':
    case 'react':
      return SyntaxLanguage.jsx;
    case 'tsx':
      return SyntaxLanguage.tsx;
    case 'py':
    case 'python':
    case 'python3':
      return SyntaxLanguage.python;
    case 'json':
    case 'jsonc':
    case 'json5':
      return SyntaxLanguage.json;
    case 'yaml':
    case 'yml':
      return SyntaxLanguage.yaml;
    case 'sh':
    case 'bash':
    case 'zsh':
    case 'shell':
    case 'console':
    case 'terminal':
    case 'shellscript':
      return SyntaxLanguage.bash;
    case 'html':
    case 'xml':
    case 'vue':
    case 'svelte':
    case 'htm':
      return SyntaxLanguage.html;
    case 'css':
    case 'scss':
    case 'less':
    case 'sass':
      return SyntaxLanguage.css;
    case 'kt':
    case 'kts':
    case 'kotlin':
      return SyntaxLanguage.kotlin;
    case 'swift':
      return SyntaxLanguage.swift;
    case 'md':
    case 'markdown':
      return SyntaxLanguage.markdown;
    default:
      return null;
  }
}

/// Best-effort detection of [code]'s language for the `code_snippet` default
/// (`language` prop left null). Order: an opening fence tag wins, then
/// high-precision content signals; anything else is null (plain).
///
/// The heuristic is deliberately conservative — it only fires on unambiguous
/// markers so plain text and unknown languages never get mis-colored.
SyntaxLanguage? syntaxLanguageGuess(String code) {
  final String trimmed = code.trimLeft();
  // 1. An explicit fence tag at the very start (```dart / ~~~py).
  final fence = RegExp(
    r'^(?:```+|~~~+)\s*([A-Za-z][\w+-]*)',
  ).firstMatch(trimmed);
  if (fence != null) {
    final fromTag = syntaxLanguageFromId(fence.group(1));
    if (fromTag != null) return fromTag;
  }
  // 2. Strong single-language markers.
  if (RegExp(r'''^import\s+['"]package:flutter/''').hasMatch(trimmed) ||
      RegExp(r'''^import\s+['"]dart:''').hasMatch(trimmed) ||
      RegExp(r'^\s*void\s+main\s*\(', multiLine: true).hasMatch(trimmed)) {
    return SyntaxLanguage.dart;
  }
  if (RegExp(r'^#!\S*\b(?:ba)?sh\b|^#!\S*\bzsh\b').hasMatch(trimmed)) {
    return SyntaxLanguage.bash;
  }
  if (RegExp(
    r'^<!DOCTYPE html|^<html[\s>]',
    caseSensitive: false,
  ).hasMatch(trimmed)) {
    return SyntaxLanguage.html;
  }
  if (RegExp(r'^<\?xml').hasMatch(trimmed)) {
    return SyntaxLanguage.html;
  }
  if (RegExp(r'^import\s+(?:UIKit|Foundation|SwiftUI)\b').hasMatch(trimmed)) {
    return SyntaxLanguage.swift;
  }
  if (RegExp(r'^\s*def\s+\w+\s*\([^)]*\)\s*:').hasMatch(trimmed) ||
      RegExp(
        r'^\s*(?:async\s+)?def\s+\w+\s*\(.*\)\s*(?:->\s*\w+\s*)?:',
      ).hasMatch(trimmed)) {
    return SyntaxLanguage.python;
  }
  if (RegExp(r'^\s*(?:pub\s+)?(?:fun|val|var)\s+\w+').hasMatch(trimmed) &&
      trimmed.contains(RegExp(r'\b(?:Unit|Int|String|Boolean)\b'))) {
    return SyntaxLanguage.kotlin;
  }
  if (RegExp(r'^\s*(?:const|let|var|function)\s+\w+').hasMatch(trimmed) ||
      RegExp(r'=>').hasMatch(trimmed) ||
      RegExp(r'^\s*console\.log\(', multiLine: true).hasMatch(trimmed)) {
    return SyntaxLanguage.javascript;
  }
  final String body = trimmed.trim();
  if (body.isEmpty) return null;
  // 3. Whole-document shapes.
  if ((body.startsWith('{') || body.startsWith('[')) &&
      RegExp(r'^[\s{}\[\]",:0-9aeflnrtyA-FLNR\.\-+]*$').hasMatch(body)) {
    return SyntaxLanguage.json;
  }
  return null;
}
