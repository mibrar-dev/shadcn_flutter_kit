// AST walk for the P6-D9b spacing audit.
//
// Collects one `SpatialSite` per spatial literal. Two spellings of the same
// call are scanned: `const EdgeInsets.all(4)` (an `InstanceCreationExpression`
// because of the `const` keyword) and bare `EdgeInsets.all(4)` /
// `Gap(theme.spacing.sm)`, which `parseString` — without type resolution —
// keeps as a `MethodInvocation` (`Gap` is then the method name, `EdgeInsets`
// the target and `all` the method).
//
// `spatial_scan_rules.dart` classifies every value this walk records.

import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/source/line_info.dart';

import 'spatial_scan_rules.dart';

/// Walks one compilation unit collecting spatial literals.
class SpatialVisitor extends RecursiveAstVisitor<void> {
  SpatialVisitor(this.file, this.lineInfo);

  final String file;
  final LineInfo lineInfo;

  /// 1-based line of [node] in the parsed file.
  int _line(AstNode node) => lineInfo.getLocation(node.offset).lineNumber;
  final List<SpatialSite> sites = <SpatialSite>[];
  final List<String> _scope = <String>[];

  String get _decl {
    if (_scope.isEmpty) {
      return '';
    }
    return _scope.join('.');
  }

  void _add({
    required int line,
    required String kind,
    required String construct,
    required String value,
    required String argName,
  }) {
    final String trimmed = value.trim();
    sites.add(
      SpatialSite(
        file: file,
        line: line,
        kind: kind,
        construct: construct,
        value: trimmed,
        classification: classifyValue(trimmed, argName, kind),
        decl: _decl,
        isFinding: classifyValue(trimmed, argName, kind) == 'raw',
      ),
    );
  }

  @override
  void visitVariableDeclaration(VariableDeclaration node) {
    _scope.add(node.name.lexeme);
    super.visitVariableDeclaration(node);
    _scope.removeLast();
  }

  @override
  void visitMethodDeclaration(MethodDeclaration node) {
    _scope.add(node.name.lexeme);
    super.visitMethodDeclaration(node);
    _scope.removeLast();
  }

  @override
  void visitFunctionDeclaration(FunctionDeclaration node) {
    _scope.add(node.name.lexeme);
    super.visitFunctionDeclaration(node);
    _scope.removeLast();
  }

  @override
  void visitConstructorDeclaration(ConstructorDeclaration node) {
    _scope.add(node.name?.lexeme ?? '<ctor>');
    super.visitConstructorDeclaration(node);
    _scope.removeLast();
  }

  /// Type name of a constructor-like call target (`EdgeInsets.all(4)` reads
  /// as a method invocation on the `EdgeInsets` target without resolution).
  String _typeNameOf(Expression? target) {
    if (target is SimpleIdentifier) {
      return target.name;
    }
    if (target is PrefixedIdentifier) {
      return target.identifier.name;
    }
    if (target is PropertyAccess) {
      return target.propertyName.name;
    }
    return '';
  }

  @override
  void visitInstanceCreationExpression(InstanceCreationExpression node) {
    _record(
      type: node.constructorName.type.name.lexeme,
      ctor: node.constructorName.name?.name ?? '',
      arguments: node.argumentList,
      constructLine: _line(node),
    );
    super.visitInstanceCreationExpression(node);
  }

  @override
  void visitMethodInvocation(MethodInvocation node) {
    // `parseString` does not resolve types, so a bare `EdgeInsets.all(4)`
    // parses as a method invocation (target `EdgeInsets`, method `all`) rather
    // than an `InstanceCreationExpression`. Both spellings are scanned.
    final Expression? target = node.target;
    // `Gap(4)` is a bare call (target null, method `Gap`); `EdgeInsets.all(4)`
    // is a prefixed call (target `EdgeInsets`, method `all`, i.e. the ctor).
    final String type = target == null
        ? node.methodName.name
        : _typeNameOf(target);
    final String ctor = target == null ? '' : node.methodName.name;
    if (type.isNotEmpty) {
      _record(
        type: type,
        ctor: ctor,
        arguments: node.argumentList,
        constructLine: _line(node),
      );
    }
    super.visitMethodInvocation(node);
  }

  @override
  void visitNamedArgument(NamedArgument node) {
    const Set<String> spacingArgs = <String>{
      'spacing',
      'runSpacing',
      'crossAxisSpacing',
      'mainAxisSpacing',
    };
    final String name = node.name.lexeme;
    if (spacingArgs.contains(name) && _inFlexSlot(node)) {
      _add(
        line: _line(node.argumentExpression),
        kind: 'spacing_arg',
        construct: 'flex.spacing',
        value: node.argumentExpression.toSource(),
        argName: name,
      );
    }
    super.visitNamedArgument(node);
  }

  /// Whether [node] is a Flex/Wrap/Grid spacing slot (`Column(spacing: 4)`).
  bool _inFlexSlot(NamedArgument node) {
    final AstNode? enclosing = node.parent?.parent;
    String? type;
    if (enclosing is InstanceCreationExpression) {
      type = enclosing.constructorName.type.name.lexeme;
    } else if (enclosing is MethodInvocation) {
      type = _typeNameOf(enclosing.target);
    }
    return type != null &&
        const <String>{
          'Column',
          'Row',
          'Flex',
          'Wrap',
          'GridTile',
          'SliverGridDelegateWithFixedCrossAxisCount',
          'Flow',
        }.contains(type);
  }

  /// Value expression of an argument.
  Expression _valueOf(Argument arg) => arg.argumentExpression;

  /// Argument name of an argument, or [named] for positional ones.
  String _argNameOf(Argument arg, String named) =>
      arg is NamedArgument ? arg.name.lexeme : named;

  /// Records every spatial literal of one constructor-like call.
  void _record({
    required String type,
    required String ctor,
    required ArgumentList arguments,
    required int constructLine,
  }) {
    final String construct = <String>[
      type,
      if (ctor.isNotEmpty) '.$ctor',
    ].join();

    if (edgeInsetsArgs.containsKey(type) &&
        edgeInsetsArgs[type]!.contains(ctor)) {
      if (type == 'EdgeInsetsDensity' ||
          type == 'DirectionalEdgeInsetsDensity') {
        // Density-aware by construction; no literal to classify.
        _add(
          line: constructLine,
          kind: 'edge_insets',
          construct: construct,
          value: construct,
          argName: 'derived',
        );
        return;
      }
      for (final Argument arg in arguments.arguments) {
        final Expression value = _valueOf(arg);
        _add(
          line: _line(value),
          kind: 'edge_insets',
          construct: construct,
          value: value.toSource(),
          argName: _argNameOf(arg, 'value'),
        );
      }
      return;
    }

    if (type == 'Gap' || type == 'SliverGap') {
      for (final Argument arg in arguments.arguments) {
        final Expression value = _valueOf(arg);
        _add(
          line: _line(value),
          kind: 'gap',
          construct: construct,
          value: value.toSource(),
          argName: _argNameOf(arg, 'gap'),
        );
      }
      return;
    }

    if (type == 'SizedBox') {
      for (final Argument arg in arguments.arguments) {
        final Expression value = _valueOf(arg);
        final String argName = _argNameOf(arg, ctor == 'square' ? 'width' : '');
        if (argName == 'width' || argName == 'height') {
          _add(
            line: _line(value),
            kind: 'sized_box',
            construct: construct,
            value: value.toSource(),
            argName: argName,
          );
        }
      }
      return;
    }

    if (type == 'BoxConstraints') {
      for (final Argument arg in arguments.arguments) {
        final Expression value = _valueOf(arg);
        final String argName = _argNameOf(arg, '');
        if (argName.startsWith('min') || argName.startsWith('max')) {
          _add(
            line: _line(value),
            kind: 'box_constraints',
            construct: construct,
            value: value.toSource(),
            argName: argName,
          );
        }
      }
      return;
    }

    if (type == 'Padding') {
      for (final Argument arg in arguments.arguments) {
        final Expression value = _valueOf(arg);
        // A nested `EdgeInsets...(...)` argument is recorded by its own visit;
        // only a themed/literal expression reaches this branch.
        if (_argNameOf(arg, '') != 'padding') {
          continue;
        }
        if (spatialConstruction.hasMatch(value.toSource().trim())) {
          continue;
        }
        _add(
          line: _line(value),
          kind: 'padding',
          construct: construct,
          value: value.toSource(),
          argName: 'padding',
        );
      }
      return;
    }

    if (type == 'BorderSide' ||
        type == 'Divider' ||
        type == 'VerticalDivider') {
      for (final Argument arg in arguments.arguments) {
        final Expression value = _valueOf(arg);
        final String argName = _argNameOf(arg, '');
        if (argName == 'width' ||
            argName == 'height' ||
            argName == 'thickness') {
          _add(
            line: _line(value),
            kind: type == 'BorderSide' ? 'border' : 'divider',
            construct: construct,
            value: value.toSource(),
            argName: argName,
          );
        }
      }
    }
  }
}
