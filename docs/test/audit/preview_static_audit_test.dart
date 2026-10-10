// Static audit of every registry `preview.dart` (P6-D9a, P6-F4).
//
// Uses `package:analyzer` (a dev dependency) instead of regexes to answer,
// per component:
//   * does it export a named-example list (`const List<ComponentPreview>`)?
//     -> `examples` (P6-F3 contract, first entry is the default)
//   * does it still ship the old single gallery class? -> `previewClass`
//   * does it hard-code a `ShadcnTheme` and therefore ignore the site mode?
//     -> `rootOverride` line (must be 0)
//   * does it dump every enum variant at once? -> `variantDumps` (must be empty)
//
// Run: flutter test test/audit/preview_static_audit_test.dart

import 'dart:io';

import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

/// One audit row, printed as a `ROW ...` line so a harness can scrape it.
class Row {
  /// Creates a row.
  Row(this.id, this.previewClass);

  /// Component id.
  final String id;

  /// The exported preview class name, or empty when the file ships the
  /// P6-F3 named-example list instead.
  final String previewClass;

  /// Named examples in declaration order (empty for old galleries).
  List<String> examples = <String>[];

  /// The component's PascalCase stem (`Button` for `button`).
  String get stem =>
      previewClass.isEmpty ? '' : previewClass.replaceFirst('Preview', '');

  /// Constructor-name histogram with counts >= 2, or matching [stem].
  Map<String, int> instanceHistogram = <String, int>{};

  /// `preview.dart` line that pins the root theme, or 0.
  int rootOverride = 0;

  /// `preview.dart` lines with a nested hard-coded dark `ShadcnThemeData`.
  final List<int> darkSections = <int>[];

  /// `X.values` loops that dump every variant at once.
  final List<String> variantDumps = <String>[];

  /// Section labels in declaration order (old galleries only).
  final List<String> sections = <String>[];

  /// Human-readable findings.
  final List<String> issues = <String>[];
}

void main() {
  final Directory root = Directory('lib/ui/shadcn/components');
  final List<Row> rows = <Row>[];
  final List<String> errors = <String>[];

  for (final FileSystemEntity e in root.listSync()) {
    if (e is! Directory) continue;
    final File f = File('${e.path}/preview.dart');
    if (!f.existsSync()) continue;
    final String id = e.path.replaceAll('\\', '/').split('/').last;
    final ParseStringResult r = parseString(
      content: f.readAsStringSync(),
      throwIfDiagnostics: false,
    );
    try {
      rows.add(_analyse(id, r.unit));
    } catch (err) {
      errors.add('$id: $err');
    }
  }

  rows.sort((Row a, Row b) => a.id.compareTo(b.id));

  test('preview static audit', () {
    expect(errors, isEmpty, reason: errors.join('\n'));
    final StringBuffer out = StringBuffer(
      '=== PREVIEW STATIC AUDIT '
      '(${rows.length}) ===\n',
    );
    for (final Row row in rows) {
      out.writeln(
        'ROW ${row.id}|${row.previewClass}|root=${row.rootOverride}'
        '|dark=${row.darkSections.length}'
        '|dumps=${row.variantDumps.join('+')}'
        '|examples=${row.examples.join('~')}'
        '|sections=${row.sections.join('~')}'
        '|instances=${row.instanceHistogram.entries.map((MapEntry<String, int> e) => '${e.key}:${e.value}').join(',')}',
      );
      for (final String issue in row.issues) {
        out.writeln('ISSUE ${row.id} $issue');
      }
    }
    final String path =
        Platform.environment['PREVIEW_AUDIT_OUT'] ??
        'build/audit/preview_static_audit.txt';
    final File outFile = File(path)..parent.createSync(recursive: true);
    outFile.writeAsStringSync(out.toString());
    debugPrint('wrote $path (${rows.length} rows)');
    expect(rows.length, 118);
    // P6-F4 contract gates: no pinned themes anywhere; no variant dumps in
    // old galleries. Named examples may iterate `.values` inside ONE example
    // (button Sizes, stepper sizes, toast placements): the page still shows
    // one example at a time behind the Select, so the D2 gallery problem
    // (one page-long dump of every variant) is gone.
    final List<String> pinned = <String>[
      for (final Row row in rows)
        if (row.rootOverride > 0 || row.darkSections.isNotEmpty) row.id,
    ];
    expect(pinned, isEmpty, reason: 'previews pinning a theme: $pinned');
    final List<String> dumps = <String>[
      for (final Row row in rows)
        if (row.variantDumps.isNotEmpty && row.examples.isEmpty) row.id,
    ];
    expect(dumps, isEmpty, reason: 'galleries dumping variants: $dumps');
  });
}

Row _analyse(String id, CompilationUnit unit) {
  final String previewClass = _previewClassName(unit);
  final Row row = Row(id, previewClass);
  row.examples = _previewExamples(unit);

  final _ForVisitor forVisitor = _ForVisitor();
  unit.accept(forVisitor);
  for (final ForStatement fs in forVisitor.statements) {
    final Expression? iterable = _iterableOfLoop(fs.forLoopParts);
    if (iterable == null) continue;
    final String src = iterable.toSource();
    if (src.endsWith('.values')) row.variantDumps.add(src);
  }
  for (final ForElement fe in forVisitor.elements) {
    final Expression? iterable = _iterableOfLoop(fe.forLoopParts);
    if (iterable == null) continue;
    final String src = iterable.toSource();
    if (src.endsWith('.values')) row.variantDumps.add(src);
  }
  for (final SpreadElement se in forVisitor.spreads) {
    final String src = se.expression.toSource();
    if (src.endsWith('.values')) row.variantDumps.add(src);
  }

  final _CreationVisitor countVisitor = _CreationVisitor();
  unit.accept(countVisitor);
  final Map<String, int> histogram = <String, int>{};
  for (final InstanceCreationExpression ic in countVisitor.nodes) {
    final String name = ic.constructorName.type.name.lexeme;
    histogram[name] = (histogram[name] ?? 0) + 1;
  }
  if (row.stem.isNotEmpty) {
    histogram.removeWhere(
      (String k, int v) => v < 2 && !k.startsWith(row.stem),
    );
  }
  row.instanceHistogram = histogram;

  final _InvocationVisitor invVisitor = _InvocationVisitor();
  unit.accept(invVisitor);
  for (final MethodInvocation mi in invVisitor.calls) {
    if (mi.methodName.name == '_section' &&
        mi.argumentList.arguments.isNotEmpty) {
      final Argument a = mi.argumentList.arguments.first;
      if (a is StringLiteral) row.sections.add(a.stringValue ?? '?');
    }
  }

  for (final InstanceCreationExpression ic in countVisitor.nodes) {
    if (ic.constructorName.type.name.lexeme != 'ShadcnThemeData') continue;
    if (ic.argumentList.arguments.isEmpty) continue;
    final bool hasDark = ic.toSource().contains('darkFallback');
    final bool hasColors = ic.argumentList.arguments.any(
      (Argument a) => a is NamedArgument && a.name.lexeme == 'colors',
    );
    if (hasColors && hasDark) {
      row.darkSections.add(unit.lineInfo.getLocation(ic.offset).lineNumber);
    }
  }

  row.rootOverride = _rootOverrideLine(unit);

  if (row.previewClass.isEmpty && row.examples.isEmpty) {
    row.issues.add(
      'NO-PREVIEW — neither a <name>Previews list nor a *Preview class.',
    );
  }
  if (row.rootOverride > 0) {
    row.issues.add(
      'ROOT-THEME-HARD-CODED preview.dart:${row.rootOverride} — build() '
      'returns a ShadcnTheme with explicit data, so the preview ignores the '
      'site light/dark mode.',
    );
  }
  if (row.darkSections.isNotEmpty) {
    row.issues.add(
      'HARD-CODED-DARK-SECTION preview.dart:${row.darkSections.join(',')} — '
      'a nested dark block duplicates the site toggle.',
    );
  }
  if (row.variantDumps.isNotEmpty) {
    row.issues.add('VARIANT-DUMP ${row.variantDumps.join(',')}');
  }
  return row;
}

/// The old gallery class name, or empty when the file ships the named list.
String _previewClassName(CompilationUnit unit) {
  final List<ClassDeclaration> candidates = unit.declarations
      .whereType<ClassDeclaration>()
      .where(
        (ClassDeclaration c) =>
            !c.namePart.typeName.lexeme.startsWith('_') &&
            c.namePart.typeName.lexeme.endsWith('Preview') &&
            _isWidget(c),
      )
      .toList(growable: false);
  if (candidates.isEmpty) {
    return '';
  }
  return candidates.first.namePart.typeName.lexeme;
}

/// Example names of the exported `const List<ComponentPreview>`, in order.
List<String> _previewExamples(CompilationUnit unit) {
  for (final Declaration declaration in unit.declarations) {
    if (declaration is! TopLevelVariableDeclaration) {
      continue;
    }
    final String type =
        declaration.variables.type?.toSource().replaceAll(' ', '') ?? '';
    if (type != 'List<ComponentPreview>') {
      continue;
    }
    if (declaration.variables.variables.length != 1) {
      continue;
    }
    final Expression? initializer =
        declaration.variables.variables.first.initializer;
    if (initializer is! ListLiteral) {
      continue;
    }
    final List<String> names = <String>[];
    for (final CollectionElement element in initializer.elements) {
      if (element is! Expression) {
        continue;
      }
      final String? constructor = switch (element) {
        InstanceCreationExpression miles =>
          miles.constructorName.type.name.lexeme,
        MethodInvocation call => call.methodName.name,
        _ => null,
      };
      if (constructor != 'ComponentPreview') {
        continue;
      }
      final ArgumentList arguments = switch (element) {
        InstanceCreationExpression miles => miles.argumentList,
        MethodInvocation call => call.argumentList,
        _ => throw StateError('unreachable'),
      };
      for (final Argument argument in arguments.arguments) {
        if (argument is NamedArgument) {
          continue;
        }
        if (argument is SimpleStringLiteral) {
          names.add(argument.value);
          break;
        }
        if (argument is AdjacentStrings) {
          final String? value = argument.stringValue;
          if (value != null) {
            names.add(value);
          }
          break;
        }
        break;
      }
    }
    return names;
  }
  return const <String>[];
}

bool _isWidget(ClassDeclaration declaration) {
  final String base = declaration.extendsClause?.superclass.toSource() ?? '';
  return base == 'StatelessWidget' || base == 'StatefulWidget';
}

/// Line of a `ShadcnThemeData(` constructor returned directly from any
/// `build` method, or 0 when previews read the ambient theme.
int _rootOverrideLine(CompilationUnit unit) {
  for (final Declaration declaration in unit.declarations) {
    if (declaration is! ClassDeclaration) {
      continue;
    }
    final MethodDeclaration? build = _method(declaration, 'build');
    if (build == null) {
      continue;
    }
    final Expression? body = _returnedExpression(build);
    if (body == null) {
      continue;
    }
    final String src = body.toSource().trim();
    final String bare = src.startsWith('const ')
        ? src.substring('const '.length).trimLeft()
        : src;
    if (!bare.startsWith('ShadcnTheme(')) {
      continue;
    }
    final _CreationVisitor v = _CreationVisitor();
    body.accept(v);
    for (final InstanceCreationExpression ic in v.nodes) {
      if (ic.constructorName.type.name.lexeme == 'ShadcnThemeData') {
        return unit.lineInfo.getLocation(ic.offset).lineNumber;
      }
    }
    return unit.lineInfo.getLocation(build.offset).lineNumber;
  }
  return 0;
}

/// The expression after the first `return` in [m], unwrapping block bodies.
Expression? _returnedExpression(MethodDeclaration m) {
  final _ReturnVisitor v = _ReturnVisitor();
  m.accept(v);
  if (v.returns.isEmpty) return null;
  return v.returns.first.expression;
}

Expression? _iterableOfLoop(ForLoopParts parts) => switch (parts) {
  final ForEachParts p => p.iterable,
  _ => null,
};

MethodDeclaration? _method(ClassDeclaration cls, String name) {
  for (final ClassMember m in cls.body.members) {
    if (m is MethodDeclaration && m.name.lexeme == name) return m;
  }
  return null;
}

class _ForVisitor extends GeneralizingAstVisitor<void> {
  final List<ForStatement> statements = <ForStatement>[];
  final List<ForElement> elements = <ForElement>[];
  final List<SpreadElement> spreads = <SpreadElement>[];
  @override
  void visitForStatement(ForStatement node) {
    statements.add(node);
    super.visitForStatement(node);
  }

  @override
  void visitForElement(ForElement node) {
    elements.add(node);
    super.visitForElement(node);
  }

  @override
  void visitSpreadElement(SpreadElement node) {
    spreads.add(node);
    super.visitSpreadElement(node);
  }
}

class _InvocationVisitor extends GeneralizingAstVisitor<void> {
  final List<MethodInvocation> calls = <MethodInvocation>[];
  @override
  void visitMethodInvocation(MethodInvocation node) {
    calls.add(node);
    super.visitMethodInvocation(node);
  }
}

class _ReturnVisitor extends GeneralizingAstVisitor<void> {
  final List<ReturnStatement> returns = <ReturnStatement>[];
  @override
  void visitReturnStatement(ReturnStatement node) {
    returns.add(node);
    super.visitReturnStatement(node);
  }
}

class _CreationVisitor extends GeneralizingAstVisitor<void> {
  final List<InstanceCreationExpression> nodes = <InstanceCreationExpression>[];
  @override
  void visitInstanceCreationExpression(InstanceCreationExpression node) {
    nodes.add(node);
    super.visitInstanceCreationExpression(node);
  }
}
