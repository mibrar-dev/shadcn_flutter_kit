// Small AST helpers shared by the docs codegen's two extractors
// (`dart_scan.dart` for the primary class/function, `api_members.dart` for
// the declared member rows).
//
// Doc comments and formal parameters are read from the analyzer "fragments"
// AST (`FormalParameter.name` / `.defaultClause` / `.functionTypedSuffix`)
// used by analyzer ^14; `parseClean` in the caller records parse diagnostics
// instead of failing the run.

import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/token.dart';

import 'api_model.dart';

/// Field declarations of a class, keyed by name, with their type and doc.
class FieldFacts {
  /// Creates the facts.
  const FieldFacts({required this.type, this.doc});

  /// Declared type (`ButtonVariant`), or empty.
  final String type;

  /// Doc comment text, or null.
  final String? doc;
}

/// Doc comment attached to [node], or null.
String? docComment(AstNode node) {
  final List<String> comments = <String>[];
  Token? comment = node.beginToken.precedingComments;
  while (comment != null) {
    comments.add(comment.lexeme);
    comment = comment.next;
  }
  Token token = node.beginToken;
  while (_isComment(token)) {
    comments.add(token.lexeme);
    final Token? next = token.next;
    if (next == null) {
      break;
    }
    token = next;
  }
  return comments.isEmpty ? null : comments.join('\n');
}

bool _isComment(Token token) =>
    token.type == TokenType.SINGLE_LINE_COMMENT ||
    token.type == TokenType.MULTI_LINE_COMMENT ||
    token.type == TokenType.SCRIPT_TAG;

/// Strips `///`, `//` and `/** */` markers from a raw doc comment.
String? cleanDocText(String? raw) {
  if (raw == null) {
    return null;
  }
  final List<String> lines = <String>[
    for (final String line in raw.split('\n'))
      line
          .replaceFirst(RegExp(r'^\s*///?'), '')
          .replaceFirst(RegExp(r'^\s*/\*+'), '')
          .replaceFirst(RegExp(r'\*/\s*$'), '')
          .replaceFirst(RegExp(r'^\s*\*'), '')
          .trim(),
  ];
  while (lines.isNotEmpty && lines.first.isEmpty) {
    lines.removeAt(0);
  }
  while (lines.isNotEmpty && lines.last.isEmpty) {
    lines.removeLast();
  }
  return lines.isEmpty ? null : lines.join('\n');
}

/// The first paragraph of a cleaned doc comment, joined on spaces.
String firstParagraph(String? doc) {
  if (doc == null) {
    return '';
  }
  final StringBuffer buffer = StringBuffer();
  for (final String line in doc.split('\n')) {
    if (line.isEmpty) {
      break;
    }
    if (buffer.isNotEmpty) {
      buffer.write(' ');
    }
    buffer.write(line);
  }
  return buffer.toString();
}

/// One-liner over [docComment] + [cleanDocText] + [firstParagraph]: null when
/// the node carries no doc comment.
String? firstDocLine(AstNode node) {
  final String text = firstParagraph(cleanDocText(docComment(node)));
  return text.isEmpty ? null : text;
}

/// Field declarations of [declaration] keyed by name, with type and doc.
Map<String, FieldFacts> fieldsOf(ClassDeclaration declaration) {
  final Map<String, FieldFacts> fields = <String, FieldFacts>{};
  for (final FieldDeclaration field
      in declaration.body.members.whereType<FieldDeclaration>()) {
    final String? doc = cleanDocText(docComment(field));
    for (final VariableDeclaration variable in field.fields.variables) {
      fields[variable.name.lexeme] = FieldFacts(
        type: field.fields.type?.toSource() ?? '',
        doc: doc,
      );
    }
  }
  return fields;
}

/// One formal parameter as an [ApiParamFacts], or null for infrastructure
/// parameters (`super.key`).
ApiParamFacts? formalParamFacts(
  FormalParameter parameter,
  Map<String, FieldFacts> fields,
  String source,
) {
  final Token? nameToken = parameter.name;
  final String? name = nameToken?.lexeme;
  if (name == null || (parameter is SuperFormalParameter && name == 'key')) {
    return null;
  }
  // `defaultClause.value2` is experimental and `.value` is deprecated in the
  // fragments AST; slice the clause's source range instead.
  final FormalParameterDefaultClause? clause = parameter.defaultClause;
  final String? defaultValue = clause == null
      ? null
      : source
            .substring(clause.offset, clause.end)
            .replaceFirst(RegExp(r'^[=:]\s*'), '')
            .trim();
  final FieldFacts? field = fields[name];
  final String type = switch (parameter) {
    FieldFormalParameter() =>
      field?.type.isNotEmpty == true
          ? field!.type
          : (parameter.type?.toSource() ?? ''),
    _ when parameter.functionTypedSuffix != null => functionTypeOf(parameter),
    _ => parameter.type?.toSource() ?? '',
  };
  final String? doc = field?.doc ?? firstDocLine(parameter);
  return ApiParamFacts(
    name: name,
    type: type,
    isRequired: parameter.isRequired,
    defaultValue: defaultValue,
    doc: doc,
  );
}

/// `void Function(int, bool)`-style source for a function-typed parameter.
String functionTypeOf(FormalParameter parameter) {
  final String returnType = parameter.type?.toSource() ?? 'void';
  final FunctionTypedFormalParameterSuffix suffix =
      parameter.functionTypedSuffix!;
  final String arguments = suffix.formalParameters.parameters
      .map((FormalParameter p) => p.toSource())
      .join(', ');
  final String nullable = suffix.question != null ? '?' : '';
  return '$returnType Function($arguments)$nullable';
}
