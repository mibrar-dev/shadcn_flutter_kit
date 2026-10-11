// Per-example source extraction for the docs codegen (P7-D1).
//
// Every `preview.dart` exports `const <camel>Previews =
// [ComponentPreview('Name', _builderFn, description: ...)]`. The component
// pages show each example in its own Preview | Code card, so the Code tab
// needs exactly the code for that example: the builder function plus the
// private helper widgets/classes/variables it uses from the same file.
//
// Uses `package:analyzer` (unresolved AST, no regex for structure): the
// top-level declarations of the file become the lookup table, and each
// example grows a closure over the identifiers its builder body mentions.
// Only private (`_`) helpers can collide by accident, and every entry in the
// table is a real declaration, so the closure never invents code.

import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';

import 'ast_docs.dart';

/// One example's extracted source: the label, the optional `description:`
/// of its `ComponentPreview`, the builder expression, and the assembled
/// display code (imports + builder + helpers, in file order).
class DocsExampleSourceFacts {
  /// Creates the facts.
  const DocsExampleSourceFacts({
    required this.name,
    this.description,
    required this.builder,
    required this.code,
  });

  /// Label shown on the card (`Default`, `With groups`).
  final String name;

  /// Optional one-line explanation under the card heading.
  final String? description;

  /// Builder expression source (`_buttonDefault`).
  final String builder;

  /// Display code: rewritten imports + the builder and its helpers.
  final String code;
}

/// One top-level declaration slice of a preview file.
class _Decl {
  _Decl({required this.names, required this.slice});

  /// Declared top-level names (one for functions/classes, possibly several
  /// for a multi-variable declaration).
  final Set<String> names;

  /// Source slice including the doc comment when one is attached.
  final String slice;
}

final RegExp _identifier = RegExp('[A-Za-z_][A-Za-z0-9_]*');

/// Extracts one [DocsExampleSourceFacts] per `ComponentPreview` element.
///
/// [source] is the `preview.dart` text, [previewDir] its registry-relative
/// directory (`components/button`), [componentImport] the manifest `import`
/// line (only used when the file has no resolvable imports at all).
/// Returns an empty list for old single-gallery previews (no
/// `List<ComponentPreview>` export).
List<DocsExampleSourceFacts> extractExampleSources({
  required String source,
  required String previewDir,
  required String componentImport,
}) {
  final ParseStringResult result = parseString(
    content: source,
    throwIfDiagnostics: false,
  );
  final CompilationUnit unit = result.unit;
  final ListLiteral? list = _previewList(unit);
  if (list == null) {
    return const <DocsExampleSourceFacts>[];
  }
  final List<_Decl> decls = _declarations(unit, source);
  final Map<String, int> byName = <String, int>{};
  for (int i = 0; i < decls.length; i++) {
    for (final String name in decls[i].names) {
      byName.putIfAbsent(name, () => i);
    }
  }
  final String header = _header(
    unit,
    previewDir: previewDir,
    fallbackImport: componentImport,
  );
  final List<DocsExampleSourceFacts> out = <DocsExampleSourceFacts>[];
  for (final CollectionElement element in list.elements) {
    if (element is! Expression) {
      continue;
    }
    final _PreviewElement? parsed = _parseElement(element, source);
    if (parsed == null) {
      continue;
    }
    final Set<int> picked = <int>{};
    final List<int> queue = <int>[];
    void addName(String name) {
      final int? index = byName[name];
      if (index != null && picked.add(index)) {
        queue.add(index);
      }
    }

    for (final Match match in _identifier.allMatches(parsed.builderSource)) {
      addName(match.group(0)!);
    }
    while (queue.isNotEmpty) {
      final int index = queue.removeLast();
      for (final Match match in _identifier.allMatches(decls[index].slice)) {
        addName(match.group(0)!);
      }
    }
    // An inline closure builder has no declaration; its source is the body.
    final List<String> bodies = <String>[
      if (parsed.inlineBody != null) parsed.inlineBody!,
      for (int i = 0; i < decls.length; i++)
        if (picked.contains(i)) decls[i].slice,
    ];
    final String code = '$header\n\n${bodies.join('\n\n')}\n';
    out.add(
      DocsExampleSourceFacts(
        name: parsed.name,
        description: parsed.description,
        builder: parsed.builderSource,
        code: code,
      ),
    );
  }
  return out;
}

/// The `List<ComponentPreview>` literal of the file, or null.
ListLiteral? _previewList(CompilationUnit unit) {
  for (final CompilationUnitMember member in unit.declarations) {
    if (member is! TopLevelVariableDeclaration) {
      continue;
    }
    final String type =
        member.variables.type?.toSource().replaceAll(' ', '') ?? '';
    if (type != 'List<ComponentPreview>') {
      continue;
    }
    if (member.variables.variables.length != 1) {
      continue;
    }
    final Expression? initializer =
        member.variables.variables.first.initializer;
    if (initializer is ListLiteral) {
      return initializer;
    }
  }
  return null;
}

/// One parsed `ComponentPreview(...)` element.
class _PreviewElement {
  _PreviewElement({
    required this.name,
    this.description,
    required this.builderSource,
    this.inlineBody,
  });

  final String name;
  final String? description;
  final String builderSource;
  final String? inlineBody;
}

_PreviewElement? _parseElement(Expression element, String source) {
  final ArgumentList? arguments = switch (element) {
    InstanceCreationExpression miles => miles.argumentList,
    MethodInvocation call => call.argumentList,
    _ => null,
  };
  if (arguments == null) {
    return null;
  }
  return _parseArguments(arguments, source);
}

_PreviewElement? _parseArguments(ArgumentList arguments, String source) {
  // Positional arguments are `Expression`s; `NamedArgument` is not, so it
  // is excluded here and read separately below.
  final List<Expression> positional = <Expression>[
    for (final Argument argument in arguments.arguments)
      if (argument is Expression) argument,
  ];
  if (positional.length < 2) {
    return null;
  }
  final String? name = (positional[0] as StringLiteral?)?.stringValue;
  if (name == null || name.isEmpty) {
    return null;
  }
  final Expression builderArg = positional[1];
  final String builderSource = source
      .substring(builderArg.offset, builderArg.end)
      .trim();
  final String? inlineBody = builderArg is FunctionExpression
      ? source.substring(builderArg.offset, builderArg.end).trim()
      : null;
  String? description;
  for (final Argument argument in arguments.arguments) {
    if (argument is NamedArgument && argument.name.lexeme == 'description') {
      for (final Object child in argument.childEntities) {
        if (child is StringLiteral) {
          description = child.stringValue;
        }
      }
    }
  }
  return _PreviewElement(
    name: name,
    description: description,
    builderSource: builderSource,
    inlineBody: inlineBody,
  );
}

/// Every top-level declaration except imports/exports/parts and the
/// `...Previews` list itself, in file order.
List<_Decl> _declarations(CompilationUnit unit, String source) {
  final List<_Decl> out = <_Decl>[];
  for (final CompilationUnitMember member in unit.declarations) {
    switch (member) {
      case TopLevelVariableDeclaration():
        final List<String> names = <String>[
          for (final VariableDeclaration variable in member.variables.variables)
            variable.name.lexeme,
        ];
        if (names.any((String name) => name.endsWith('Previews'))) {
          continue;
        }
        out.add(_Decl(names: names.toSet(), slice: _slice(member, source)));
      case FunctionDeclaration():
        out.add(
          _Decl(
            names: <String>{member.name.lexeme},
            slice: _slice(member, source),
          ),
        );
      case ClassDeclaration():
        out.add(
          _Decl(
            names: <String>{member.namePart.typeName.lexeme},
            slice: _slice(member, source),
          ),
        );
      case EnumDeclaration():
        // Same fragments-AST shape as classes: the name carries type
        // parameters (`namePart`).
        final String enumName = member.namePart
            .toSource()
            .split('<')
            .first
            .trim();
        out.add(
          _Decl(names: <String>{enumName}, slice: _slice(member, source)),
        );
      case MixinDeclaration():
        out.add(
          _Decl(
            names: <String>{member.name.lexeme},
            slice: _slice(member, source),
          ),
        );
      case ExtensionDeclaration():
        final String? name = member.name?.lexeme;
        if (name != null) {
          out.add(_Decl(names: <String>{name}, slice: _slice(member, source)));
        }
      case FunctionTypeAlias():
        out.add(
          _Decl(
            names: <String>{member.name.lexeme},
            slice: _slice(member, source),
          ),
        );
      case GenericTypeAlias():
        out.add(
          _Decl(
            names: <String>{member.name.lexeme},
            slice: _slice(member, source),
          ),
        );
      case ExtensionTypeDeclaration():
        // No preview file declares one today; the name part keeps the
        // closure correct if one ever appears.
        final String name = member.namePart.toSource().split('<').first.trim();
        out.add(_Decl(names: <String>{name}, slice: _slice(member, source)));
    }
  }
  return out;
}

/// Source slice of [node] with its `///` doc comment prepended when the
/// analyzer left it out of the node range.
String _slice(AstNode node, String source) {
  String slice = source.substring(node.offset, node.end).trim();
  final String? doc = docComment(node);
  if (doc != null && !slice.startsWith(doc.split('\n').first.trim())) {
    slice = '${doc.trim()}\n$slice';
  }
  return slice;
}

/// The display-code import header: every file import rewritten to the
/// installed layout, minus the docs-only preview contract.
String _header(
  CompilationUnit unit, {
  required String previewDir,
  required String fallbackImport,
}) {
  final List<String> rewritten = <String>[];
  for (final Directive directive in unit.directives) {
    if (directive is! ImportDirective) {
      continue;
    }
    final String? uri = directive.uri.stringValue;
    if (uri == null || uri.isEmpty) {
      continue;
    }
    if (uri.contains('foundation/component_preview')) {
      continue;
    }
    if (uri.startsWith('dart:') || uri.startsWith('package:')) {
      rewritten.add("import '$uri';");
      continue;
    }
    final String? resolved = _resolveRelative(previewDir, uri);
    if (resolved == null) {
      continue;
    }
    rewritten.add("import 'package:<your_app>/ui/shadcn/$resolved';");
  }
  if (rewritten.isEmpty) {
    // Unreachable in practice (every preview imports its component), but
    // the fallback keeps the snippet valid instead of import-less.
    rewritten.add("import 'package:flutter/widgets.dart';");
    rewritten.add(fallbackImport);
  }
  return rewritten.join('\n');
}

/// Resolves a relative import of a file in [previewDir] to a
/// registry-relative path, or null when it escapes the registry.
String? _resolveRelative(String previewDir, String uri) {
  final List<String> parts = <String>[...previewDir.split('/')];
  for (final String segment in uri.split('/')) {
    if (segment.isEmpty || segment == '.') {
      continue;
    }
    if (segment == '..') {
      if (parts.isEmpty) {
        return null;
      }
      parts.removeLast();
      continue;
    }
    parts.add(segment);
  }
  return parts.join('/');
}
