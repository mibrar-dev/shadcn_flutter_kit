// Top-level declaration extraction shared by the single-owner check.

import 'package:analyzer/dart/ast/ast.dart';

import 'dart_parse.dart';

/// A top-level declaration found in a parsed file.
class TopLevelDecl {
  TopLevelDecl({
    required this.name,
    required this.kind,
    required this.file,
    required this.node,
  });

  /// Declared name.
  final String name;

  /// One of: class, mixin, enum, extension, extensionType, typedef, function,
  /// variable.
  final String kind;

  /// Owning parsed file.
  final ParsedDartFile file;

  /// The AST node used for line/identity computation.
  final AstNode node;

  /// Whether the name is public.
  bool get isPublic => !name.startsWith('_');

  /// 1-based line of the declaration.
  int get line => file.lineOf(node.offset);

  /// Whitespace and comment free source of the declaration.
  String get normalizedSource => normalizedTokenSource(file, node);
}

/// Collects all top-level declarations of [file].
List<TopLevelDecl> collectTopLevelDeclarations(ParsedDartFile file) {
  final declarations = <TopLevelDecl>[];
  for (final member in file.unit.declarations) {
    if (member is ClassDeclaration) {
      _add(
        declarations,
        member.namePart.typeName.lexeme,
        'class',
        file,
        member,
      );
    } else if (member is MixinDeclaration) {
      _add(declarations, member.name.lexeme, 'mixin', file, member);
    } else if (member is EnumDeclaration) {
      _add(declarations, member.namePart.typeName.lexeme, 'enum', file, member);
    } else if (member is ExtensionDeclaration) {
      final name = member.name?.lexeme;
      if (name != null) {
        _add(declarations, name, 'extension', file, member);
      }
    } else if (member is ExtensionTypeDeclaration) {
      _add(
        declarations,
        member.namePart.typeName.lexeme,
        'extensionType',
        file,
        member,
      );
    } else if (member is TypeAlias) {
      _add(declarations, member.name.lexeme, 'typedef', file, member);
    } else if (member is FunctionDeclaration) {
      _add(declarations, member.name.lexeme, 'function', file, member);
    } else if (member is TopLevelVariableDeclaration) {
      for (final variable in member.variables.variables) {
        _add(declarations, variable.name.lexeme, 'variable', file, variable);
      }
    }
  }
  return declarations;
}

void _add(
  List<TopLevelDecl> declarations,
  String name,
  String kind,
  ParsedDartFile file,
  AstNode node,
) {
  if (name.isEmpty) {
    return;
  }
  declarations.add(
    TopLevelDecl(name: name, kind: kind, file: file, node: node),
  );
}
