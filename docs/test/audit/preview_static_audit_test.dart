// Static audit of every registry `preview.dart` (P6-D9a).
//
// Uses `package:analyzer` (a dev dependency) instead of regexes to answer,
// per component:
//   * does the preview hard-code a `ShadcnTheme` at its root and therefore
//     ignore the docs site's light/dark mode?      -> `rootOverride` line
//   * does it render a nested, hard-coded dark section? -> `darkSections`
//   * does it dump every enum variant at once?       -> `variantDumps`
//   * which named sections does it render today?      -> `sections`
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

  /// The exported preview class name.
  final String previewClass;

  /// The component's PascalCase stem (`Button` for `button`).
  late final String stem = previewClass.replaceFirst('Preview', '');

  /// Constructor-name histogram with counts >= 2, or matching [stem].
  Map<String, int> instanceHistogram = <String, int>{};

  /// `preview.dart` line that pins the root theme, or 0.
  int rootOverride = 0;

  /// `preview.dart` lines with a nested hard-coded dark `ShadcnThemeData`.
  final List<int> darkSections = <int>[];

  /// `X.values` loops that dump every variant at once.
  final List<String> variantDumps = <String>[];

  /// Section labels in declaration order.
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
        '|sections=${row.sections.join('~')}'
        '|instances=${row.instanceHistogram.entries.map((MapEntry<String, int> e) => '${e.key}:${e.value}').join(',')}',
      );
      for (final String issue in row.issues) {
        out.writeln('ISSUE ${row.id} $issue');
      }
    }
    // The test runner truncates long prints; write the full report to a
    // gitignored file (override with PREVIEW_AUDIT_OUT) and assert on the
    // aggregate so the test still fails when the audit regresses.
    final String path =
        Platform.environment['PREVIEW_AUDIT_OUT'] ??
        'build/audit/preview_static_audit.txt';
    final File outFile = File(path)..parent.createSync(recursive: true);
    outFile.writeAsStringSync(out.toString());
    debugPrint('wrote $path (${rows.length} rows)');
    expect(rows.length, 118);
  });
}

Row _analyse(String id, CompilationUnit unit) {
  final Row row = Row(
    id,
    unit.declarations
        .whereType<ClassDeclaration>()
        .firstWhere(
          (ClassDeclaration c) =>
              !c.namePart.typeName.lexeme.startsWith('_') &&
              c.namePart.typeName.lexeme.endsWith('Preview'),
        )
        .namePart
        .typeName
        .lexeme,
  );

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
  histogram.removeWhere((String k, int v) => v < 2 && !k.startsWith(row.stem));
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

  final ClassDeclaration cls = unit.declarations
      .whereType<ClassDeclaration>()
      .firstWhere(
        (ClassDeclaration c) =>
            !c.namePart.typeName.lexeme.startsWith('_') &&
            c.namePart.typeName.lexeme.endsWith('Preview'),
      );

  row.rootOverride = _rootOverrideLine(cls, unit);

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
  if (row.sections.isEmpty && row.variantDumps.isEmpty) {
    row.issues.add('NO-NAMED-SECTIONS — preview has no _section() labels.');
  }
  return row;
}

/// Line of the `ShadcnThemeData(` constructor that the preview's `build`
/// returns directly, or 0 when the preview reads the ambient theme.
///
/// A nested `ShadcnTheme` inside a section helper is reported separately as
/// [Row.darkSections]; only a build method whose *returned* widget hard-codes
/// the data ignores the site's light/dark mode.
int _rootOverrideLine(ClassDeclaration cls, CompilationUnit unit) {
  final MethodDeclaration? build = _method(cls, 'build');
  if (build == null) return 0;
  final Expression? body = _returnedExpression(build);
  if (body == null) return 0;
  final String src = body.toSource().trim();
  final String bare = src.startsWith('const ')
      ? src.substring('const '.length).trimLeft()
      : src;
  if (!bare.startsWith('ShadcnTheme(')) return 0;
  int line = 0;
  final _CreationVisitor v = _CreationVisitor();
  body.accept(v);
  for (final InstanceCreationExpression ic in v.nodes) {
    if (ic.constructorName.type.name.lexeme == 'ShadcnThemeData') {
      line = unit.lineInfo.getLocation(ic.offset).lineNumber;
    }
  }
  return line == 0 ? unit.lineInfo.getLocation(build.offset).lineNumber : line;
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
