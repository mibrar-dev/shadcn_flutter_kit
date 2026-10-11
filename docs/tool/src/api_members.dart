// Member-level API extraction for the docs codegen.
//
// Complements `dart_scan.dart`: when a component's primary constructor
// carries no parameters (or is private) the real call surface is its static
// methods, factory constructors, static fields and top-level functions — the
// names a component declares under the manifest `api.methods` /
// `api.constants` / `api.functions` lists. Only declared names become rows
// (`color` -> `ColorDerivative.fromColor`, `formatter` ->
// `TextInputFormatters.time`), so the docs never invent an API surface.
//
// Declared but unresolvable names are reported by [unresolvedEntries] — via
// the `unresolved` sink — and skipped, so a stale manifest entry can never
// fabricate a row.

import 'package:analyzer/dart/ast/ast.dart';

import 'api_model.dart';
import 'ast_docs.dart';

/// Whether [className] owns at least one entry of [declared], or [declared]
/// holds only owner-less (top-level) entries.
bool declaresEntriesFor(String className, DeclaredMembers declared) {
  if (declared.isEmpty) {
    return false;
  }
  bool anyOwned = false;
  for (final String name in declared.names) {
    final int dot = name.lastIndexOf('.');
    if (dot < 0) {
      continue;
    }
    anyOwned = true;
    if (name.substring(0, dot) == className) {
      return true;
    }
  }
  return !anyOwned;
}

/// Rows for every declared entry that resolves in one of [sources], in
/// declared order (methods, constants, functions).
///
/// Resolution walks [sources] in order, so a component whose entry file comes
/// first keeps resolving there; the remaining installed files catch the
/// surface declared elsewhere (`button_style.dart`, `button_theme.dart`).
///
/// [unresolved] collects the names that could not be found in any file.
List<ApiMemberFacts> extractDeclaredMembers({
  required List<DeclaredSource> sources,
  required DeclaredMembers declared,
  List<String>? unresolved,
}) {
  if (declared.isEmpty) {
    return const <ApiMemberFacts>[];
  }
  final List<ApiMemberFacts> rows = <ApiMemberFacts>[];
  for (final String entry in declared.names) {
    ApiMemberFacts? row;
    for (final DeclaredSource source in sources) {
      row = _resolveEntry(source: source, entry: entry);
      if (row != null) {
        break;
      }
    }
    if (row == null) {
      unresolved?.add(entry);
      continue;
    }
    rows.add(row);
  }
  return rows;
}

ApiMemberFacts? _resolveEntry({
  required DeclaredSource source,
  required String entry,
}) {
  final CompilationUnit unit = source.unit;
  final int dot = entry.lastIndexOf('.');
  if (dot < 0) {
    // Owner-less name: a top-level function or variable.
    for (final CompilationUnitMember member in unit.declarations) {
      if (member is FunctionDeclaration && member.name.lexeme == entry) {
        return _rowOf(
          member,
          source.source,
          const <String, FieldFacts>{},
          entry,
        );
      }
      if (member is TopLevelVariableDeclaration) {
        for (final VariableDeclaration variable in member.variables.variables) {
          if (variable.name.lexeme == entry) {
            return _rowOf(
              member,
              source.source,
              const <String, FieldFacts>{},
              entry,
            );
          }
        }
      }
    }
    return null;
  }

  final String owner = entry.substring(0, dot);
  final String member = entry.substring(dot + 1);
  final Declaration? holder = _declarationNamed(unit, owner);
  if (holder == null) {
    return null;
  }
  final Map<String, FieldFacts> fields = holder is ClassDeclaration
      ? fieldsOf(holder)
      : const <String, FieldFacts>{};
  for (final AstNode node in _memberNodes(holder)) {
    if (_nameOf(node) == member) {
      return _rowOf(node, source.source, fields, entry);
    }
  }
  return null;
}

Declaration? _declarationNamed(CompilationUnit unit, String name) {
  for (final CompilationUnitMember member in unit.declarations) {
    final String? declared = switch (member) {
      ClassDeclaration() => member.namePart.typeName.lexeme,
      EnumDeclaration() => member.namePart.typeName.lexeme,
      MixinDeclaration() => member.name.lexeme,
      ExtensionDeclaration() => member.name?.lexeme,
      ExtensionTypeDeclaration() => member.namePart.typeName.lexeme,
      _ => null,
    };
    if (declared == name) {
      return member as Declaration;
    }
  }
  return null;
}

/// The member nodes of [holder] that can be named by a declared entry.
Iterable<AstNode> _memberNodes(Declaration holder) {
  return switch (holder) {
    ClassDeclaration holder => holder.body.members.cast<AstNode>(),
    MixinDeclaration holder => holder.body.members.cast<AstNode>(),
    ExtensionDeclaration holder => holder.body.members.cast<AstNode>(),
    ExtensionTypeDeclaration holder => holder.body.members.cast<AstNode>(),
    EnumDeclaration holder => <AstNode>[
      ...holder.body.constants,
      ...holder.body.members,
    ],
    _ => const <AstNode>[],
  };
}

String? _nameOf(AstNode node) {
  return switch (node) {
    MethodDeclaration() => node.name.lexeme,
    ConstructorDeclaration() => node.name?.lexeme,
    FieldDeclaration() =>
      node.fields.variables.isEmpty
          ? null
          : node.fields.variables.first.name.lexeme,
    EnumConstantDeclaration() => node.name.lexeme,
    _ => null,
  };
}

ApiMemberFacts _rowOf(
  AstNode node,
  String source,
  Map<String, FieldFacts> fields,
  String entry,
) {
  final List<ApiParamFacts> params = <ApiParamFacts>[];
  final List<FormalParameter>? declared = switch (node) {
    MethodDeclaration() => node.parameters?.parameters,
    ConstructorDeclaration() => node.parameters.parameters,
    FunctionDeclaration() => node.functionExpression.parameters?.parameters,
    TopLevelVariableDeclaration() => null,
    _ => null,
  };
  if (declared != null) {
    for (final FormalParameter parameter in declared) {
      final ApiParamFacts? facts = formalParamFacts(parameter, fields, source);
      if (facts == null) {
        continue; // `super.key` and other infrastructure parameters.
      }
      params.add(facts);
    }
  }

  final String returnType = switch (node) {
    MethodDeclaration() => node.returnType?.toSource() ?? '',
    FunctionDeclaration() => node.returnType?.toSource() ?? 'void',
    FieldDeclaration() => node.fields.type?.toSource() ?? '',
    TopLevelVariableDeclaration() => node.variables.type?.toSource() ?? '',
    // A constructor's "return type" is the type it creates.
    ConstructorDeclaration() => _ownerOf(entry),
    EnumConstantDeclaration() => _ownerOf(entry),
    _ => '',
  };

  return ApiMemberFacts(
    name: entry,
    kind: _kindOf(node),
    returnType: returnType,
    isStatic: _isStatic(node),
    params: _requiredFirst(params),
    doc: firstDocLine(node),
  );
}

/// Required parameters first, then optional, declaration order kept.
List<ApiParamFacts> _requiredFirst(List<ApiParamFacts> params) {
  final List<ApiParamFacts> required = <ApiParamFacts>[
    for (final ApiParamFacts param in params)
      if (param.isRequired) param,
  ];
  final List<ApiParamFacts> optional = <ApiParamFacts>[
    for (final ApiParamFacts param in params)
      if (!param.isRequired) param,
  ];
  return <ApiParamFacts>[...required, ...optional];
}

String _kindOf(AstNode node) {
  return switch (node) {
    MethodDeclaration() when node.isGetter => 'getter',
    MethodDeclaration() when node.isSetter => 'setter',
    MethodDeclaration() => 'method',
    ConstructorDeclaration() =>
      node.factoryKeyword != null ? 'factory' : 'constructor',
    FieldDeclaration() => node.fields.isConst ? 'constant' : 'field',
    TopLevelVariableDeclaration() =>
      node.variables.isConst ? 'constant' : 'field',
    EnumConstantDeclaration() => 'constant',
    FunctionDeclaration() => 'function',
    _ => 'method',
  };
}

bool _isStatic(AstNode node) {
  return switch (node) {
    MethodDeclaration() => node.isStatic,
    FieldDeclaration() => node.isStatic,
    _ => false,
  };
}

/// The `Owner` part of a declared `Owner.member` name.
String _ownerOf(String entry) {
  final int dot = entry.lastIndexOf('.');
  return dot < 0 ? entry : entry.substring(0, dot);
}
