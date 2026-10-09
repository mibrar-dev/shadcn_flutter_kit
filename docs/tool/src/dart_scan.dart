// `package:analyzer` scanning for the docs codegen.
//
// Two jobs:
//  1. API extraction — the primary class's unnamed-constructor parameters
//     (name, type, default, doc, required) and the class doc summary.
//  2. Code classification — the 4-class highlight map (`p` plain, `c`
//     comment, `k` keyword, `s` string) for README code blocks, using the
//     analyzer tokenizer for Dart and tiny regex/character scanners for
//     bash and JSON.
//
// `package:analyzer` 6.4.1 cannot parse 9 registry files under Dart 3.13
// (MISSING_IDENTIFIER); extraction stays usable there — `parseClean` records
// the condition instead of failing the run.

import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/token.dart';

/// A codegen input cannot be scanned as expected.
class DartScanException implements Exception {
  /// Creates the exception with a [message].
  DartScanException(this.message);

  /// What is wrong.
  final String message;

  @override
  String toString() => 'dart scan: $message';
}

/// One constructor parameter row of [ApiFacts].
class ApiParamFacts {
  /// Creates the row.
  const ApiParamFacts({
    required this.name,
    required this.type,
    required this.isRequired,
    this.defaultValue,
    this.doc,
  });

  /// Parameter name (`variant`).
  final String name;

  /// Declared type (`ButtonVariant`), or empty when unresolved.
  final String type;

  /// Whether the parameter is required (positional or named `required`).
  final bool isRequired;

  /// Default expression source (`ButtonVariant.primary`), or null.
  final String? defaultValue;

  /// Doc comment text, or null.
  final String? doc;
}

/// Extracted API for one component.
class ApiFacts {
  /// Creates the facts.
  const ApiFacts({
    required this.hasApiTable,
    required this.parseClean,
    this.symbol = '',
    this.summary,
    this.params = const <ApiParamFacts>[],
  });

  /// Whether a primary constructor was found.
  final bool hasApiTable;

  /// Whether `package:analyzer` parsed the entry file without diagnostics.
  final bool parseClean;

  /// Primary class name (`Button`).
  final String symbol;

  /// First paragraph of the class doc, or null.
  final String? summary;

  /// Constructor parameters, required first.
  final List<ApiParamFacts> params;
}

/// Extracts the API table facts for one component entry file.
///
/// [nameCandidates] is the preference order: the class named after the
/// manifest display name, the class named after the directory id, then the
/// manifest `api.classes` list; the first candidate that is declared in the
/// file (and, for the manifest fallback, is a `StatelessWidget` /
/// `StatefulWidget`) wins. Function-first components (dialog, popup) have no
/// candidate and report `hasApiTable: false` per the build plan §2.2.
ApiFacts extractApi({
  required String source,
  required List<String> nameCandidates,
}) {
  final ParseStringResult result = parseString(
    content: source,
    throwIfDiagnostics: false,
  );
  final bool parseClean = result.errors.isEmpty;
  final List<ClassDeclaration> classes = result.unit.declarations
      .whereType<ClassDeclaration>()
      .toList(growable: false);
  if (classes.isEmpty) {
    return ApiFacts(hasApiTable: false, parseClean: parseClean);
  }

  ClassDeclaration? selected;
  for (final String candidate in nameCandidates.take(2)) {
    selected = _classNamed(classes, candidate);
    if (selected != null) {
      break;
    }
  }
  if (selected == null) {
    for (final String candidate in nameCandidates.skip(2)) {
      final ClassDeclaration? match = _classNamed(classes, candidate);
      if (match != null && _isWidget(match)) {
        selected = match;
        break;
      }
    }
  }
  if (selected == null) {
    return ApiFacts(hasApiTable: false, parseClean: parseClean);
  }

  final Map<String, _FieldFacts> fields = _fieldsOf(selected);
  final ConstructorDeclaration? constructor = selected.members
      .whereType<ConstructorDeclaration>()
      .where((ConstructorDeclaration c) => c.name == null)
      .firstOrNull;
  final String summary = _firstParagraph(_cleanDoc(docComment(selected)));
  if (constructor == null) {
    return ApiFacts(
      hasApiTable: false,
      parseClean: parseClean,
      symbol: selected.name.lexeme,
      summary: summary.isEmpty ? null : summary,
    );
  }

  final List<ApiParamFacts> required = <ApiParamFacts>[];
  final List<ApiParamFacts> optional = <ApiParamFacts>[];
  for (final FormalParameter parameter in constructor.parameters.parameters) {
    final _ParamFacts? facts = _paramFacts(parameter, fields);
    if (facts == null) {
      continue; // `super.key` and other infrastructure parameters.
    }
    (facts.isRequired ? required : optional).add(
      ApiParamFacts(
        name: facts.name,
        type: facts.type,
        isRequired: facts.isRequired,
        defaultValue: facts.defaultValue,
        doc: facts.doc,
      ),
    );
  }
  return ApiFacts(
    hasApiTable: true,
    parseClean: parseClean,
    symbol: selected.name.lexeme,
    summary: summary.isEmpty ? null : summary,
    params: <ApiParamFacts>[...required, ...optional],
  );
}

/// The preview widget class for one component, found in its `preview.dart`.
///
/// Preference: `<DisplayName>Preview`, `<componentId>Preview`, then a single
/// public `*Preview` widget class; anything else fails loudly so the
/// deferred-preview registry can never point at a missing class (`hsl` ->
/// `HSLPreview`, `autocomplete` -> `AutoCompletePreview` are the known
/// irregular names).
String findPreviewClass({
  required String source,
  required String componentId,
  required String displayName,
}) {
  final ParseStringResult result = parseString(
    content: source,
    throwIfDiagnostics: false,
  );
  final List<ClassDeclaration> widgetPreviews = result.unit.declarations
      .whereType<ClassDeclaration>()
      .where(
        (ClassDeclaration c) =>
            !c.name.lexeme.startsWith('_') &&
            c.name.lexeme.endsWith('Preview') &&
            _isWidget(c),
      )
      .toList(growable: false);
  final Set<String> names = <String>{
    for (final ClassDeclaration c in widgetPreviews) c.name.lexeme,
  };
  for (final String preferred in <String>[
    '${pascalCase(displayName)}Preview',
    '${pascalCase(componentId)}Preview',
  ]) {
    if (names.contains(preferred)) {
      return preferred;
    }
  }
  if (widgetPreviews.length == 1) {
    return widgetPreviews.single.name.lexeme;
  }
  throw DartScanException(
    '$componentId/preview.dart: cannot pick one preview class from '
    '${names.toList()..sort()}',
  );
}

/// `amber-minimal` -> `AmberMinimal`; `AutoComplete` stays `AutoComplete`.
String pascalCase(String value) {
  final StringBuffer buffer = StringBuffer();
  for (final String part in value.split(RegExp('[^A-Za-z0-9]'))) {
    if (part.isEmpty) {
      continue;
    }
    buffer.write(part[0].toUpperCase());
    if (part.length > 1) {
      buffer.write(part.substring(1));
    }
  }
  return buffer.toString();
}

// ---------------------------------------------------------------------------
// AST helpers.
// ---------------------------------------------------------------------------

ClassDeclaration? _classNamed(List<ClassDeclaration> classes, String name) {
  for (final ClassDeclaration declaration in classes) {
    if (declaration.name.lexeme == name) {
      return declaration;
    }
  }
  return null;
}

bool _isWidget(ClassDeclaration declaration) {
  final String base = declaration.extendsClause?.superclass.toSource() ?? '';
  return base == 'StatelessWidget' || base == 'StatefulWidget';
}

Map<String, _FieldFacts> _fieldsOf(ClassDeclaration declaration) {
  final Map<String, _FieldFacts> fields = <String, _FieldFacts>{};
  for (final FieldDeclaration field
      in declaration.members.whereType<FieldDeclaration>()) {
    final String? doc = _cleanDoc(docComment(field));
    for (final VariableDeclaration variable in field.fields.variables) {
      fields[variable.name.lexeme] = _FieldFacts(
        type: field.fields.type?.toSource() ?? '',
        doc: doc,
      );
    }
  }
  return fields;
}

_ParamFacts? _paramFacts(
  FormalParameter parameter,
  Map<String, _FieldFacts> fields,
) {
  FormalParameter base = parameter;
  String? defaultValue;
  if (parameter is DefaultFormalParameter) {
    base = parameter.parameter;
    defaultValue = parameter.defaultValue?.toSource();
  }
  final String? name = switch (base) {
    FieldFormalParameter(:final Token name) => name.lexeme,
    SuperFormalParameter(:final Token name) => name.lexeme,
    SimpleFormalParameter(:final Token? name) => name?.lexeme,
    FunctionTypedFormalParameter(:final Token name) => name.lexeme,
    _ => null,
  };
  if (name == null || (base is SuperFormalParameter && name == 'key')) {
    return null;
  }
  final _FieldFacts? field = fields[name];
  final String type = switch (base) {
    FieldFormalParameter() =>
      field?.type.isNotEmpty == true
          ? field!.type
          : (base.type?.toSource() ?? ''),
    SimpleFormalParameter() => base.type?.toSource() ?? '',
    SuperFormalParameter() => base.type?.toSource() ?? '',
    FunctionTypedFormalParameter() => _functionType(base),
    _ => '',
  };
  final String? doc = field?.doc ?? _cleanDoc(docComment(base));
  return _ParamFacts(
    name: name,
    type: type,
    isRequired: parameter.isRequired,
    defaultValue: defaultValue,
    doc: doc,
  );
}

String _functionType(FunctionTypedFormalParameter parameter) {
  final String returnType = parameter.returnType?.toSource() ?? 'void';
  final String arguments = parameter.parameters.parameters
      .map((FormalParameter p) => p.toSource())
      .join(', ');
  final String nullable = parameter.question != null ? '?' : '';
  return '$returnType Function($arguments)$nullable';
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

String? _cleanDoc(String? raw) {
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

String _firstParagraph(String? doc) {
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

class _FieldFacts {
  const _FieldFacts({required this.type, this.doc});

  final String type;
  final String? doc;
}

class _ParamFacts {
  const _ParamFacts({
    required this.name,
    required this.type,
    required this.isRequired,
    this.defaultValue,
    this.doc,
  });

  final String name;
  final String type;
  final bool isRequired;
  final String? defaultValue;
  final String? doc;
}
