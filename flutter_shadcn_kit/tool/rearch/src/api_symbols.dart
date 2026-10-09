// Public API symbol extraction for a single parsed Dart file.

import 'package:analyzer/dart/ast/ast.dart';

import 'api_model.dart';
import 'dart_parse.dart';

/// Extracts the public symbols of a single parsed file.
List<ApiSymbol> extractPublicSymbols(ParsedDartFile file) {
  final symbols = <ApiSymbol>[];
  for (final member in file.unit.declarations) {
    if (member is ClassDeclaration) {
      _addSymbol(
        symbols,
        file,
        'class',
        member.namePart.typeName.lexeme,
        extra: _classExtra(member),
        members: _classMembers(
          member.body.members,
          member.namePart.typeName.lexeme,
        ),
      );
    } else if (member is MixinDeclaration) {
      _addSymbol(
        symbols,
        file,
        'mixin',
        member.name.lexeme,
        members: _classMembers(member.body.members, member.name.lexeme),
      );
    } else if (member is EnumDeclaration) {
      _addSymbol(
        symbols,
        file,
        'enum',
        member.namePart.typeName.lexeme,
        members: <ApiMember>[
          for (final constant in member.body.constants)
            ApiMember(kind: 'enumConstant', name: constant.name.lexeme),
          ..._classMembers(
            member.body.members,
            member.namePart.typeName.lexeme,
          ),
        ],
      );
    } else if (member is ExtensionDeclaration) {
      final name = member.name?.lexeme;
      if (name != null) {
        _addSymbol(
          symbols,
          file,
          'extension',
          name,
          members: _classMembers(member.body.members, name),
        );
      }
    } else if (member is ExtensionTypeDeclaration) {
      // Members of extension types are not extracted; the registry does not
      // use them.
      _addSymbol(
        symbols,
        file,
        'extensionType',
        member.namePart.typeName.lexeme,
      );
    } else if (member is TypeAlias) {
      _addSymbol(
        symbols,
        file,
        'typedef',
        member.name.lexeme,
        extra: <String, Object?>{
          'alias': member is GenericTypeAlias
              ? _typeText(member.type)
              : normalizeWhitespace(member.toSource()),
        },
      );
    } else if (member is FunctionDeclaration) {
      final kind = member.isGetter
          ? 'getter'
          : member.isSetter
          ? 'setter'
          : 'function';
      _addSymbol(
        symbols,
        file,
        kind,
        member.name.lexeme,
        extra: <String, Object?>{
          'type': _typeText(member.returnType),
          if (!member.isGetter)
            'parameters': _parameters(member.functionExpression.parameters),
        },
      );
    } else if (member is TopLevelVariableDeclaration) {
      final type = _typeText(member.variables.type);
      for (final variable in member.variables.variables) {
        _addSymbol(
          symbols,
          file,
          'variable',
          variable.name.lexeme,
          extra: <String, Object?>{
            'type': type,
            if (member.variables.isFinal) 'final': true,
            if (member.variables.isConst) 'const': true,
          },
        );
      }
    }
  }
  return symbols;
}

void _addSymbol(
  List<ApiSymbol> symbols,
  ParsedDartFile file,
  String kind,
  String name, {
  Map<String, Object?> extra = const <String, Object?>{},
  List<ApiMember> members = const <ApiMember>[],
}) {
  if (name.startsWith('_')) {
    return;
  }
  final sortedMembers = members.toList()
    ..sort((a, b) {
      final byKind = a.kind.compareTo(b.kind);
      return byKind != 0 ? byKind : a.name.compareTo(b.name);
    });
  symbols.add(
    ApiSymbol(
      kind: kind,
      name: name,
      file: file.relPath,
      extra: extra,
      members: sortedMembers,
    ),
  );
}

Map<String, Object?> _classExtra(ClassDeclaration declaration) =>
    <String, Object?>{
      if (declaration.abstractKeyword != null) 'abstract': true,
      if (declaration.baseKeyword != null) 'base': true,
      if (declaration.interfaceKeyword != null) 'interface': true,
      if (declaration.finalKeyword != null) 'final': true,
    };

List<ApiMember> _classMembers(List<ClassMember> members, String className) {
  final result = <ApiMember>[];
  for (final member in members) {
    if (member is ConstructorDeclaration) {
      final name = member.name == null
          ? className
          : '$className.${member.name!.lexeme}';
      result.add(
        ApiMember(
          kind: 'constructor',
          name: name,
          extra: <String, Object?>{
            if (member.constKeyword != null) 'const': true,
            if (member.factoryKeyword != null) 'factory': true,
            'parameters': _parameters(member.parameters),
          },
        ),
      );
    } else if (member is MethodDeclaration) {
      final kind = member.isGetter
          ? 'getter'
          : member.isSetter
          ? 'setter'
          : 'method';
      result.add(
        ApiMember(
          kind: kind,
          name: member.name.lexeme,
          extra: <String, Object?>{
            if (member.isStatic) 'static': true,
            if (member.body is EmptyFunctionBody) 'abstract': true,
            if (member.isOperator) 'operator': true,
            'type': _typeText(member.returnType),
            if (!member.isGetter) 'parameters': _parameters(member.parameters),
          },
        ),
      );
    } else if (member is FieldDeclaration) {
      final type = _typeText(member.fields.type);
      for (final variable in member.fields.variables) {
        result.add(
          ApiMember(
            kind: 'field',
            name: variable.name.lexeme,
            extra: <String, Object?>{
              'type': type,
              if (member.isStatic) 'static': true,
              if (member.fields.isFinal) 'final': true,
              if (member.fields.isConst) 'const': true,
            },
          ),
        );
      }
    }
  }
  return result;
}

List<Map<String, Object?>> _parameters(FormalParameterList? list) {
  if (list == null) {
    return const <Map<String, Object?>>[];
  }
  return <Map<String, Object?>>[
    for (final parameter in list.parameters) _parameter(parameter),
  ];
}

Map<String, Object?> _parameter(FormalParameter parameter) {
  final kindLabel = parameter.isNamed
      ? (parameter.isRequired ? 'named-required' : 'named-optional')
      : (parameter.isRequiredPositional
            ? 'required-positional'
            : 'optional-positional');
  final nameAndType = _nameAndType(parameter);
  return apiParameter(
    name: nameAndType.$1,
    type: nameAndType.$2,
    kind: kindLabel,
    required: parameter.isRequired,
  );
}

(String, String?) _nameAndType(FormalParameter parameter) {
  final name = parameter.name?.lexeme ?? '';
  final String? type;
  if (parameter.functionTypedSuffix != null) {
    type = normalizeWhitespace(parameter.toSource());
  } else {
    type = _typeText(parameter.type);
  }
  return (name, type);
}

String? _typeText(TypeAnnotation? type) {
  if (type == null) {
    return null;
  }
  final text = normalizeWhitespace(type.toSource());
  return text.isEmpty ? null : text;
}
