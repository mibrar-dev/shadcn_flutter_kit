// Unresolved Dart parsing helpers built on package:analyzer `parseString`.

import 'dart:io';

import 'package:analyzer/dart/analysis/features.dart';
import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/token.dart';
import 'package:analyzer/source/line_info.dart';

/// A parsed (unresolved) Dart file plus metadata used by the tooling.
class ParsedDartFile {
  ParsedDartFile({
    required this.absPath,
    required this.relPath,
    required this.content,
    required this.unit,
    required this.lineInfo,
    required this.syntaxErrorCount,
  });

  /// Absolute path on disk.
  final String absPath;

  /// Path relative to the scan root, using forward slashes.
  final String relPath;

  /// Raw file content.
  final String content;

  /// The unresolved compilation unit.
  final CompilationUnit unit;

  /// Line/column lookup for offsets in [content].
  final LineInfo lineInfo;

  /// Number of syntax diagnostics reported by the parser.
  final int syntaxErrorCount;

  List<Token>? _tokens;

  /// All tokens of the file, in source order (including EOF).
  List<Token> get tokens {
    var cached = _tokens;
    if (cached != null) {
      return cached;
    }
    final list = <Token>[];
    for (Token? token = unit.beginToken; token != null; token = token.next) {
      list.add(token);
      // The EOF token's `next` points at itself in analyzer 6.4.1, so a plain
      // `token != null` walk never terminates.
      if (token.isEof) {
        break;
      }
    }
    _tokens = list;
    return list;
  }

  /// Every comment in the file, in source order.
  Iterable<Token> get comments sync* {
    for (final token in tokens) {
      for (
        Token? comment = token.precedingComments;
        comment != null;
        comment = comment.next
      ) {
        yield comment;
      }
    }
  }

  /// 1-based line of [offset].
  int lineOf(int offset) => lineInfo.getLocation(offset).lineNumber;

  /// Number of physical lines.
  int get lineCount {
    var count = 1;
    for (var index = 0; index < content.length; index += 1) {
      if (content.codeUnitAt(index) == 0x0A) {
        count += 1;
      }
    }
    return count;
  }

  /// The line of the first `ignore_for_file:` comment, or null.
  int? get firstIgnoreForFileLine {
    for (final comment in comments) {
      if (comment.lexeme.contains('ignore_for_file:')) {
        return lineOf(comment.offset);
      }
    }
    return null;
  }
}

/// Parses the file at [absPath] as unresolved Dart.
ParsedDartFile parseDartFile(String absPath, String relPath) {
  final content = File(absPath).readAsStringSync();
  final result = parseString(
    content: content,
    path: absPath,
    featureSet: FeatureSet.latestLanguageVersion(),
    throwIfDiagnostics: false,
  );
  return ParsedDartFile(
    absPath: absPath,
    relPath: relPath,
    content: content,
    unit: result.unit,
    lineInfo: result.lineInfo,
    syntaxErrorCount: result.errors.length,
  );
}

/// The source of [node] as a whitespace and comment free token sequence.
///
/// Used by the single-owner check to tell copy-paste duplicates
/// (`identical: true`) apart from diverged forks (`identical: false`).
String normalizedTokenSource(ParsedDartFile file, AstNode node) {
  final tokens = file.tokens;
  var low = 0;
  var high = tokens.length;
  while (low < high) {
    final mid = (low + high) >> 1;
    if (tokens[mid].offset < node.offset) {
      low = mid + 1;
    } else {
      high = mid;
    }
  }
  final buffer = StringBuffer();
  for (var index = low; index < tokens.length; index += 1) {
    final token = tokens[index];
    if (token.offset >= node.end) {
      break;
    }
    buffer.write(token.lexeme);
    buffer.write('|');
  }
  return buffer.toString();
}

/// Collapses whitespace in an already extracted source snippet.
String normalizeWhitespace(String? source) {
  if (source == null) {
    return '';
  }
  return source.replaceAll(RegExp(r'\s+'), ' ').trim();
}
