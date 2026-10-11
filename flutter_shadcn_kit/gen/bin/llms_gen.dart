// ignore_for_file: avoid_print

import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:glob/glob.dart';
import 'dart:io';
import 'package:file/local.dart';

const targetOutputs = ['gen/llms-full.txt', '../docs/public/llms-full.txt'];

void main(List<String> args) async {
  await generateLLMSFull();
}

List<Glob> readFilesToInclude() {
  File includeFile = File('llms-include.txt');
  if (!includeFile.existsSync()) {
    return [];
  }
  List<String> lines = includeFile.readAsLinesSync();
  return lines
      .map((line) => line.trim())
      .where((line) => line.isNotEmpty && !line.startsWith('#'))
      // Normalize leading slashes so patterns like "/docs/**" work cross-platform.
      .map((line) => line.startsWith('/') ? line.substring(1) : line)
      .map((line) => Glob(line))
      .toList();
}

/*
Output format:
For classes and methods:
/// <Dartdoc comments>
class ClassName extends SuperClass with Mixins implements Interfaces {
  /// <Dartdoc comments>
  Type fieldName;
  /// <Dartdoc comments>
  ClassName(Parameter params);
  /// <Dartdoc comments>
  ReturnType methodName(Parameter params);
  /// <Dartdoc comments>
  static ReturnType staticMethodName(Parameter params);
  /// <Dartdoc comments>
  ReturnType get propertyName;
  /// <Dartdoc comments>
  set propertyName(Type value);
  // ...
}
For example files:
# File: <relative path from root>
<contents of the file>
*/

void readAllDocs(void Function(String content) writer) {
  // Walk lib/ and extract class-like API surfaces with dartdoc comments.
  // Only signatures are emitted (no bodies), matching the format sketched above.
  final libDir = Directory('lib/registry');
  if (!libDir.existsSync()) return;

  // Helper to convert a documentation comment to lines prefixed with '///'.
  String doc(Comment? comment) {
    if (comment == null) return '';
    // Join tokens to preserve any intra-line formatting.
    final text = comment.tokens.map((t) => t.lexeme).join('\n');
    if (text.trim().isEmpty) return '';
    // Ensure each line begins with '///'. If the token lexemes already contain
    // '///', keep as-is; otherwise, prefix.
    final lines = text.split('\n');
    return lines
        .map((l) => l.trim().startsWith('///') ? l : '/// ${l.trim()}')
        .join('\n');
  }

  // Detect whether an initializer represents an IconData value so we can
  // suppress dumping large icon initializer payloads in llms-full.txt.
  bool isIconDataInit({String? typeSrc, String? initSrc}) {
    final t = (typeSrc ?? '').trim();
    final i = (initSrc ?? '').trim();
    if (i.isEmpty) return false;
    final typeIsIconData = RegExp(r'(^|\W)IconData(\W||\z)').hasMatch(t);
    final initConstructsIconData = RegExp(
      r'^(const\s+)?IconData\s*\(',
    ).hasMatch(i);
    final initIsKnownIconRef =
        i.startsWith('Icons.') ||
        i.startsWith('LucideIcons.') ||
        i.startsWith('BootstrapIcons.') ||
        i.startsWith('RadixIcons.');
    // If the type is IconData and initializer either constructs or refers to
    // a known icon, treat it as IconData initializer.
    if (typeIsIconData && (initConstructsIconData || initIsKnownIconRef)) {
      return true;
    }
    // If type is not explicitly IconData but initializer constructs IconData,
    // also treat as IconData initializer.
    if (!typeIsIconData && initConstructsIconData) return true;
    return false;
  }

  // Render a type parameter list or return empty string.
  String toSrcOrEmpty(AstNode? node) => node == null ? '' : node.toSource();

  bool isPrivateName(String name) => name.startsWith('_');

  // Field declarations (possibly multiple variables in one).
  String fieldSignature(FieldDeclaration node) {
    final b = StringBuffer();
    final docs = doc(node.documentationComment);
    final isStatic = node.isStatic;
    final isConst = node.fields.isConst;
    final isFinal = node.fields.isFinal;
    final typeSrc = node.fields.type?.toSource();
    for (final v in node.fields.variables) {
      final name = v.name.lexeme;
      if (isPrivateName(v.name.lexeme)) continue;
      if (docs.isNotEmpty) b.writeln(docs);
      final init = v.initializer?.toSource().trim();
      final staticPart = isStatic ? 'static ' : '';
      final constPart = isConst ? 'const ' : (isFinal ? 'final ' : '');
      final typePart = typeSrc ?? (isConst ? '' : 'var');
      final typeSpace = typePart.isNotEmpty ? ' ' : '';
      if (isConst && init != null && init.isNotEmpty) {
        if (isIconDataInit(typeSrc: typeSrc, initSrc: init)) {
          // Suppress IconData initializer payloads.
          b.writeln('  $staticPart$typePart$typeSpace$name;');
        } else {
          b.writeln('  $staticPart$constPart$typePart$typeSpace$name = $init;');
        }
      } else {
        b.writeln('  $staticPart$typePart$typeSpace$name;');
      }
    }
    return b.toString();
  }

  String constructorSignature(ConstructorDeclaration node) {
    // Skip private named constructors
    final ctorName = node.name?.lexeme;
    if (ctorName != null && isPrivateName(ctorName)) return '';
    final docs = doc(node.documentationComment);
    final b = StringBuffer();
    if (docs.isNotEmpty) b.writeln(docs);
    final mod = node.factoryKeyword != null
        ? 'factory '
        : (node.constKeyword != null ? 'const ' : '');
    final className = node.typeName?.toSource() ?? '';
    final name = ctorName;
    final params = node.parameters.toSource();
    b.writeln('  $mod$className${name != null ? '.$name' : ''}$params;');
    return b.toString();
  }

  String methodSignature(MethodDeclaration node) {
    // Skip private methods/getters/setters
    final nameLex = node.name.lexeme;
    if (isPrivateName(nameLex)) return '';
    final docs = doc(node.documentationComment);
    final b = StringBuffer();
    if (docs.isNotEmpty) b.writeln(docs);
    final isStatic = node.isStatic;
    final typeParams = toSrcOrEmpty(node.typeParameters);
    if (node.isGetter) {
      final rt = node.returnType?.toSource() ?? 'dynamic';
      b.writeln('  ${isStatic ? 'static ' : ''}$rt get ${node.name.lexeme};');
    } else if (node.isSetter) {
      // Setter always has one param; use parameter list to keep name/type.
      final params = node.parameters?.toSource() ?? '(value)';
      b.writeln(
        '  ${isStatic ? 'static ' : ''}set ${node.name.lexeme}$params;',
      );
    } else {
      final rt = node.returnType?.toSource() ?? 'void';
      final op = node.operatorKeyword != null ? 'operator ' : '';
      final name = node.name.lexeme;
      final params = node.parameters?.toSource() ?? '()';
      b.writeln(
        '  ${isStatic ? 'static ' : ''}$rt $op$name$typeParams$params;',
      );
    }
    return b.toString();
  }

  String classHeader(ClassDeclaration node) {
    final isAbstract = node.abstractKeyword != null;
    final isMixinClass = node.mixinKeyword != null;
    final name = node.namePart.typeName.lexeme;
    final typeParams = toSrcOrEmpty(node.namePart.typeParameters);
    final extendsClause = node.extendsClause == null
        ? ''
        : ' extends ${node.extendsClause!.superclass.toSource()}';
    final withClause = node.withClause == null
        ? ''
        : ' with ${node.withClause!.mixinTypes.map((t) => t.toSource()).join(', ')}';
    final implementsClause = node.implementsClause == null
        ? ''
        : ' implements ${node.implementsClause!.interfaces.map((t) => t.toSource()).join(', ')}';
    return '${isAbstract ? 'abstract ' : ''}${isMixinClass ? 'mixin ' : ''}class '
        '$name$typeParams$extendsClause$withClause$implementsClause';
  }

  String mixinHeader(MixinDeclaration node) {
    final name = node.name.lexeme;
    final typeParams = toSrcOrEmpty(node.typeParameters);
    final onClause = node.onClause == null
        ? ''
        : ' on ${node.onClause!.superclassConstraints.map((t) => t.toSource()).join(', ')}';
    final implementsClause = node.implementsClause == null
        ? ''
        : ' implements ${node.implementsClause!.interfaces.join(', ')}';
    return 'mixin $name$typeParams$onClause$implementsClause';
  }

  String extensionHeader(ExtensionDeclaration node) {
    final name = node.name?.lexeme ?? '';
    final typeParams = toSrcOrEmpty(node.typeParameters);
    final onType = node.onClause?.extendedType.toSource() ?? '';
    return 'extension${name.isNotEmpty ? ' $name' : ''}$typeParams on $onType';
  }

  String enumSignature(EnumDeclaration node) {
    final docs = doc(node.documentationComment);
    final names = node.body.constants
        .map((c) => c.name.lexeme)
        .where((n) => !isPrivateName(n))
        .join(', ');
    return [
      if (docs.isNotEmpty) docs,
      'enum ${node.namePart.typeName.lexeme} { $names }',
    ].join('\n');
  }

  String topLevelVariableSignature(TopLevelVariableDeclaration node) {
    final b = StringBuffer();
    final docs = doc(node.documentationComment);
    final list = node.variables;
    final type = list.type?.toSource();
    final isFinal = list.isFinal;
    final isConst = list.isConst;
    final isLate = list.lateKeyword != null;
    for (final v in list.variables) {
      final name = v.name.lexeme;
      if (isPrivateName(name)) continue;
      if (docs.isNotEmpty) b.writeln(docs);
      final latePart = isLate ? 'late ' : '';
      final modifier = isConst
          ? 'const '
          : isFinal
          ? 'final '
          : (type == null ? 'var ' : '');
      final typePart = type ?? '';
      final space = typePart.isNotEmpty ? ' ' : '';
      final init = v.initializer?.toSource().trim();
      if (isConst && init != null && init.isNotEmpty) {
        if (isIconDataInit(typeSrc: type, initSrc: init)) {
          // Suppress IconData initializer payloads.
          b.writeln('$latePart$modifier$typePart$space$name;');
        } else {
          b.writeln('$latePart$modifier$typePart$space$name = $init;');
        }
      } else {
        b.writeln('$latePart$modifier$typePart$space$name;');
      }
    }
    return b.toString();
  }

  String topLevelFunctionSignature(FunctionDeclaration node) {
    final name = node.name.lexeme;
    if (isPrivateName(name)) return '';
    final docs = doc(node.documentationComment);
    final b = StringBuffer();
    if (docs.isNotEmpty) b.writeln(docs);
    final isGetter = node.isGetter;
    final isSetter = node.isSetter;
    final typeParams = toSrcOrEmpty(node.functionExpression.typeParameters);
    if (isGetter) {
      final rt = node.returnType?.toSource() ?? 'dynamic';
      b.writeln('$rt get $name;');
    } else if (isSetter) {
      final params =
          node.functionExpression.parameters?.toSource() ?? '(value)';
      b.writeln('set $name$params;');
    } else {
      final rt = node.returnType?.toSource() ?? 'void';
      final params = node.functionExpression.parameters?.toSource() ?? '()';
      b.writeln('$rt $name$typeParams$params;');
    }
    return b.toString();
  }

  for (final entity in libDir.listSync(recursive: true)) {
    if (entity is! File) continue;
    if (!entity.path.endsWith('.dart')) continue;
    final source = entity.readAsStringSync();
    final result = parseString(content: source, path: entity.path);
    final unit = result.unit;

    final buffer = StringBuffer();

    for (final decl in unit.declarations) {
      if (decl is ClassDeclaration) {
        if (isPrivateName(decl.namePart.typeName.lexeme)) continue;
        final docs = doc(decl.documentationComment);
        if (docs.isNotEmpty) buffer.writeln(docs);
        buffer.writeln('${classHeader(decl)} {');
        for (final member in decl.body.members) {
          if (member is FieldDeclaration) {
            buffer.write(fieldSignature(member));
          } else if (member is ConstructorDeclaration) {
            final sig = constructorSignature(member);
            if (sig.isNotEmpty) buffer.write(sig);
          } else if (member is MethodDeclaration) {
            final sig = methodSignature(member);
            if (sig.isNotEmpty) buffer.write(sig);
          }
        }
        buffer.writeln('}');
        buffer.writeln();
      } else if (decl is MixinDeclaration) {
        if (isPrivateName(decl.name.lexeme)) continue;
        final docs = doc(decl.documentationComment);
        if (docs.isNotEmpty) buffer.writeln(docs);
        buffer.writeln('${mixinHeader(decl)} {');
        for (final member in decl.body.members) {
          if (member is FieldDeclaration) {
            buffer.write(fieldSignature(member));
          } else if (member is MethodDeclaration) {
            final sig = methodSignature(member);
            if (sig.isNotEmpty) buffer.write(sig);
          }
        }
        buffer.writeln('}');
        buffer.writeln();
      } else if (decl is ExtensionDeclaration) {
        final extName = decl.name?.lexeme;
        if (extName != null && isPrivateName(extName)) continue;
        final docs = doc(decl.documentationComment);
        if (docs.isNotEmpty) buffer.writeln(docs);
        buffer.writeln('${extensionHeader(decl)} {');
        for (final member in decl.body.members) {
          if (member is FieldDeclaration) {
            buffer.write(fieldSignature(member));
          } else if (member is MethodDeclaration) {
            final sig = methodSignature(member);
            if (sig.isNotEmpty) buffer.write(sig);
          }
        }
        buffer.writeln('}');
        buffer.writeln();
      } else if (decl is EnumDeclaration) {
        if (isPrivateName(decl.namePart.typeName.lexeme)) continue;
        buffer.writeln(enumSignature(decl));
        buffer.writeln();
      } else if (decl is TopLevelVariableDeclaration) {
        final sig = topLevelVariableSignature(decl);
        if (sig.isNotEmpty) {
          buffer.writeln(sig);
          buffer.writeln();
        }
      } else if (decl is FunctionDeclaration) {
        final sig = topLevelFunctionSignature(decl);
        if (sig.isNotEmpty) {
          buffer.writeln(sig);
          buffer.writeln();
        }
      }
    }

    final out = buffer.toString().trim();
    if (out.isNotEmpty) {
      writer(out);
    }
  }
}

Future<void> generateLLMSFull() async {
  final targets = targetOutputs.join(', ');
  print('Generating full LLMs documentation at $targets');
  final sinks = <IOSink>[];
  for (final output in targetOutputs) {
    final target = File(output);
    if (!target.parent.existsSync()) {
      target.parent.createSync(recursive: true);
    }
    sinks.add(target.openWrite());
  }
  // Remove empty/whitespace-only lines from any block before writing.
  String stripEmptyLines(String input) {
    final lines = input.split(RegExp(r'\r?\n'));
    final kept = <String>[];
    for (final line in lines) {
      if (line.trim().isEmpty) continue;
      kept.add(line);
    }
    return kept.join('\n');
  }

  // 1) Prepend README.md at the very beginning, if present.
  final readmeFile = File('README.md');
  if (readmeFile.existsSync()) {
    final readmeText = readmeFile.readAsStringSync();
    final filtered = stripEmptyLines(readmeText);
    if (filtered.isNotEmpty) {
      for (final sink in sinks) {
        sink.writeln(filtered);
      }
    }
  }

  readAllDocs((content) {
    final filtered = stripEmptyLines(content);
    if (filtered.isEmpty) return;
    for (final sink in sinks) {
      sink.writeln(filtered);
    }
  });
  for (Glob glob in readFilesToInclude()) {
    print('Including files matching pattern: ${glob.pattern}');
    for (FileSystemEntity entity in glob.listFileSystemSync(
      // FileSystem
      const LocalFileSystem(),
    )) {
      if (entity is File && entity.path.endsWith('.dart')) {
        String relativePath = entity.path.replaceFirst(
          'docs/',
          '',
        ); // relative to root
        // only include files that has number (e.g., tile_example_1.dart, tile_example_2.dart)
        if (!RegExp(r'_\d+\.dart$').hasMatch(relativePath)) {
          continue;
        }
        print('Including file: $relativePath');
        for (final sink in sinks) {
          sink.writeln('# File: $relativePath');
        }
        final fileText = entity.readAsStringSync();
        final filtered = stripEmptyLines(fileText);
        if (filtered.isNotEmpty) {
          for (final sink in sinks) {
            sink.writeln(filtered);
          }
        }
      }
    }
  }
  for (final sink in sinks) {
    await sink.close();
  }
  print('Generation complete.');
  print('Total size: ${File(targetOutputs.first).lengthSync()} bytes');
}

// Topic and usage generation moved to gen/bin/dotguides_gen.dart
