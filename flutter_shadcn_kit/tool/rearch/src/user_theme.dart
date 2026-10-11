// Checks for user-owned component theme files (`<name>_theme.dart`).
//
// Contract: the file is values only. Exactly one allowed import shape,
// top-level `const` variable declarations, no functions, closures,
// `resolveWith` callbacks, or non-const constructor calls.

import 'dart:io';

import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';

import 'dart_parse.dart';
import 'path_utils.dart';

/// A single violation in a user theme file.
class UserThemeFinding {
  UserThemeFinding({
    required this.file,
    required this.line,
    required this.message,
  });

  final String file;
  final int line;
  final String message;

  Map<String, Object?> toJson() => <String, Object?>{
    'file': file,
    'line': line,
    'message': message,
  };
}

/// Whether [relPath] (root-relative) names a component user theme file:
/// `components/<name>/<name>_theme.dart`.
bool isUserThemeFile(String relPath) {
  final segments = relPath.split('/');
  if (segments.length < 3 || segments[0] != 'components') {
    return false;
  }
  return segments.last == '${segments[segments.length - 2]}_theme.dart';
}

/// The component name for `components/<name>/<name>_theme.dart`, or null.
String? _componentNameOf(String relPath) {
  final segments = relPath.split('/');
  if (segments.length < 3 || segments[0] != 'components') {
    return null;
  }
  final name = segments[1];
  return baseName(relPath) == '${name}_theme.dart' ? name : null;
}

/// Validates one parsed user theme file.
List<UserThemeFinding> checkUserThemeFile(ParsedDartFile parsed) {
  final findings = <UserThemeFinding>[];
  final name = _componentNameOf(parsed.relPath);
  void add(int line, String message) {
    findings.add(
      UserThemeFinding(file: parsed.relPath, line: line, message: message),
    );
  }

  for (final directive in parsed.unit.directives) {
    if (directive is ImportDirective) {
      final uri = directive.uri.stringValue ?? '';
      final allowed =
          uri == 'package:flutter/widgets.dart' ||
          (name != null && uri.endsWith('${name}_style.dart')) ||
          uri.startsWith('../../theme/');
      if (!allowed) {
        add(
          parsed.lineOf(directive.offset),
          "import '$uri' is not allowed in a user theme file",
        );
      }
      continue;
    }
    add(
      parsed.lineOf(directive.offset),
      'export/part directives are not allowed',
    );
  }

  for (final declaration in parsed.unit.declarations) {
    if (declaration is TopLevelVariableDeclaration) {
      if (!declaration.variables.isConst) {
        add(
          parsed.lineOf(declaration.offset),
          'only top-level const variable declarations are allowed',
        );
      }
      continue;
    }
    if (declaration is FunctionDeclaration) {
      add(
        parsed.lineOf(declaration.offset),
        'function declarations are not allowed',
      );
      continue;
    }
    add(
      parsed.lineOf(declaration.offset),
      'only top-level const variable declarations are allowed',
    );
  }
  parsed.unit.accept(_Visitor(parsed, add));
  return findings;
}

class _Visitor extends RecursiveAstVisitor<void> {
  _Visitor(this.parsed, this.add);

  final ParsedDartFile parsed;
  final void Function(int line, String message) add;

  @override
  void visitFunctionDeclaration(FunctionDeclaration node) {
    // Top-level functions are already reported by the declarations scan.
    if (node.parent is CompilationUnit) {
      super.visitFunctionDeclaration(node);
      return;
    }
    add(parsed.lineOf(node.offset), 'function declarations are not allowed');
  }

  @override
  void visitFunctionExpression(FunctionExpression node) {
    // Arrow bodies of top-level function declarations surface as
    // FunctionExpression children; those declarations are flagged already.
    if (node.parent is FunctionDeclaration) {
      super.visitFunctionExpression(node);
      return;
    }
    add(
      parsed.lineOf(node.offset),
      'closures/function expressions are not allowed',
    );
  }

  @override
  void visitInstanceCreationExpression(InstanceCreationExpression node) {
    if (!node.isConst && !_enclosingConstVariable(node)) {
      add(
        parsed.lineOf(node.offset),
        'non-const constructor call is not allowed',
      );
    }
    super.visitInstanceCreationExpression(node);
  }

  @override
  void visitSimpleIdentifier(SimpleIdentifier node) {
    if (node.name == 'resolveWith') {
      add(parsed.lineOf(node.offset), "'resolveWith' is not allowed");
    }
    super.visitSimpleIdentifier(node);
  }

  bool _enclosingConstVariable(AstNode node) {
    var parent = node.parent;
    while (parent != null) {
      if (parent is VariableDeclarationList && parent.isConst) {
        return true;
      }
      parent = parent.parent;
    }
    return false;
  }
}

/// Scans [root] (a registry tree) for `components/<name>/<name>_theme.dart`
/// files and validates each.
List<UserThemeFinding> checkUserThemes(String root) {
  final findings = <UserThemeFinding>[];
  final componentsDir = Directory(joinPath(root, 'components'));
  if (!componentsDir.existsSync()) {
    return findings;
  }
  for (final entity in componentsDir.listSync(recursive: true)) {
    if (entity is! File || !entity.path.endsWith('.dart')) {
      continue;
    }
    final relPath = relativePath(
      normalizePath(entity.path),
      normalizePath(root),
    );
    if (!isUserThemeFile(relPath)) {
      continue;
    }
    findings.addAll(checkUserThemeFile(parseDartFile(entity.path, relPath)));
  }
  findings.sort((a, b) {
    final byFile = a.file.compareTo(b.file);
    return byFile != 0 ? byFile : a.line.compareTo(b.line);
  });
  return findings;
}
