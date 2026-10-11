// Code-block highlight classification for the docs codegen (4-class scheme).
//
// Dart uses the `package:analyzer` tokenizer; bash and JSON use small,
// documented character scanners. Whitespace and everything unclassified is
// `plain` (`p`); the other classes are comment (`c`), keyword (`k`) and
// string (`s`). Output is one class character per source character.

import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/token.dart';

// ---------------------------------------------------------------------------
// Highlight classification (4-class scheme).
// ---------------------------------------------------------------------------

/// Plain text class.
const int kTokenPlain = 0x70; // p

/// Comment class (`//`, `/* */`, bash `#`).
const int kTokenComment = 0x63; // c

/// Keyword class (`final`, `await`, bash commands, JSON true/false/null).
const int kTokenKeyword = 0x6B; // k

/// String class.
const int kTokenString = 0x73; // s

/// Classifies [code] according to [language]; unknown languages are plain.
String classifySnippet(String language, String code) {
  switch (language) {
    case 'dart':
      return classifyDart(code);
    case 'bash':
    case 'sh':
    case 'shell':
      return classifyBash(code);
    case 'json':
    case 'jsonc':
      return classifyJson(code);
    default:
      return String.fromCharCodes(List<int>.filled(code.length, kTokenPlain));
  }
}

/// Dart classification via the `package:analyzer` tokenizer.
String classifyDart(String code) {
  final List<int> classes = List<int>.filled(code.length, kTokenPlain);
  if (code.isEmpty) {
    return '';
  }
  final ParseStringResult result = parseString(
    content: code,
    throwIfDiagnostics: false,
  );
  Token? token = result.unit.beginToken;
  while (token != null) {
    _paintToken(token, classes, code.length);
    Token? comment = token.precedingComments;
    while (comment != null) {
      _paintToken(comment, classes, code.length);
      comment = comment.next;
    }
    if (token.type == TokenType.EOF) {
      break;
    }
    token = token.next;
  }
  return String.fromCharCodes(classes);
}

void _paintToken(Token token, List<int> classes, int length) {
  final int kind;
  if (token.type == TokenType.SINGLE_LINE_COMMENT ||
      token.type == TokenType.MULTI_LINE_COMMENT) {
    kind = kTokenComment;
  } else if (token.keyword != null) {
    kind = kTokenKeyword;
  } else if (token.type == TokenType.STRING) {
    kind = kTokenString;
  } else {
    return;
  }
  final int start = token.offset.clamp(0, length);
  final int end = token.end.clamp(0, length);
  for (int i = start; i < end; i++) {
    classes[i] = kind;
  }
}

/// Bash classification: comments, quotes and command-position words.
String classifyBash(String code) {
  final List<int> classes = List<int>.filled(code.length, kTokenPlain);
  int i = 0;
  while (i < code.length) {
    final int char = code.codeUnitAt(i);
    if (char == 0x23) {
      // `#` to end of line.
      final int newline = code.indexOf('\n', i);
      final int end = newline < 0 ? code.length : newline;
      for (int j = i; j < end; j++) {
        classes[j] = kTokenComment;
      }
      i = end;
    } else if (char == 0x27 || char == 0x22) {
      final int quote = char;
      int j = i + 1;
      while (j < code.length &&
          code.codeUnitAt(j) != quote &&
          code.codeUnitAt(j) != 0x0A) {
        j++;
      }
      if (j < code.length && code.codeUnitAt(j) == quote) {
        j++;
      }
      for (int k = i; k < j; k++) {
        classes[k] = kTokenString;
      }
      i = j;
    } else if (_isWordStart(char)) {
      int j = i;
      while (j < code.length && _isWordChar(code.codeUnitAt(j))) {
        j++;
      }
      if (_bashWordIsKeyword(code, i, j)) {
        for (int k = i; k < j; k++) {
          classes[k] = kTokenKeyword;
        }
      }
      i = j;
    } else {
      i++;
    }
  }
  return String.fromCharCodes(classes);
}

bool _bashWordIsKeyword(String code, int start, int end) {
  if (code.codeUnitAt(start) == 0x2D) {
    return true; // --flag
  }
  final int lineStart = start == 0 ? 0 : code.lastIndexOf('\n', start - 1) + 1;
  final String before = code.substring(lineStart, start);
  if (RegExp(r'^\s*\$?\s*$').hasMatch(before)) {
    return true; // first word of the command line
  }
  final RegExpMatch? previous = RegExp(
    r'([A-Za-z][\w-]*)\s+$',
  ).firstMatch(before);
  return previous != null &&
      const <String>{
        'flutter_shadcn',
        'flutter',
        'dart',
        'sh',
        'bash',
      }.contains(previous.group(1));
}

bool _isWordStart(int char) =>
    (char >= 0x41 && char <= 0x5A) ||
    (char >= 0x61 && char <= 0x7A) ||
    char == 0x2D ||
    char == 0x5F;

bool _isWordChar(int char) =>
    _isWordStart(char) || (char >= 0x30 && char <= 0x39) || char == 0x2E;

/// JSON / JSONC classification: strings, `true`/`false`/`null`, comments.
String classifyJson(String code) {
  final List<int> classes = List<int>.filled(code.length, kTokenPlain);
  int i = 0;
  while (i < code.length) {
    final int char = code.codeUnitAt(i);
    if (char == 0x22) {
      int j = i + 1;
      while (j < code.length) {
        if (code.codeUnitAt(j) == 0x5C) {
          j += 2;
          continue;
        }
        if (code.codeUnitAt(j) == 0x22 || code.codeUnitAt(j) == 0x0A) {
          break;
        }
        j++;
      }
      if (j < code.length && code.codeUnitAt(j) == 0x22) {
        j++;
      }
      for (int k = i; k < j && k < code.length; k++) {
        classes[k] = kTokenString;
      }
      i = j;
    } else if (char == 0x2F && i + 1 < code.length) {
      final int next = code.codeUnitAt(i + 1);
      final bool line = next == 0x2F;
      final bool block = next == 0x2A;
      if (line || block) {
        int j = i + (line ? 2 : 2);
        while (j < code.length) {
          if (line && code.codeUnitAt(j) == 0x0A) {
            break;
          }
          if (block &&
              code.codeUnitAt(j) == 0x2A &&
              code.codeUnitAt(j + 1) == 0x2F) {
            j += 2;
            break;
          }
          j++;
        }
        for (int k = i; k < j && k < code.length; k++) {
          classes[k] = kTokenComment;
        }
        i = j;
      } else {
        i++;
      }
    } else if (_isWordStart(char)) {
      int j = i;
      while (j < code.length && _isWordChar(code.codeUnitAt(j))) {
        j++;
      }
      final String word = code.substring(i, j);
      if (word == 'true' || word == 'false' || word == 'null') {
        for (int k = i; k < j; k++) {
          classes[k] = kTokenKeyword;
        }
      }
      i = j;
    } else {
      i++;
    }
  }
  return String.fromCharCodes(classes);
}
