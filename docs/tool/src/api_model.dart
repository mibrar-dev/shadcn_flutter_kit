// Data model shared by the docs codegen's API extraction (`dart_scan.dart`,
// `api_members.dart`) and the `docs_api.dart` renderer.
//
// Plain data only — no `package:analyzer` AST types — so the renderer and the
// golden tests depend on this file without pulling in the analyzer.
//
// (`DeclaredSource` is the one exception: it carries the parsed unit that
// `api_members.dart` resolves declared names against.)

import 'package:analyzer/dart/ast/ast.dart';

/// One constructor parameter row of [ApiFacts] and [ApiMemberFacts].
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

/// One declared entry point of a component: a static method, a factory
/// constructor, a static field or a top-level function named under the
/// manifest `api.methods` / `api.constants` / `api.functions` lists.
///
/// [name] keeps the declared form (`TextInputFormatters.time`,
/// `constraintToNewText`) so the docs table shows the real call site.
class ApiMemberFacts {
  /// Creates the row.
  const ApiMemberFacts({
    required this.name,
    required this.kind,
    this.returnType = '',
    this.isStatic = false,
    this.params = const <ApiParamFacts>[],
    this.doc,
  });

  /// Declared name (`TextInputFormatters.time`, `constraintToNewText`).
  final String name;

  /// Declaration kind found in the source: `method`, `factory`,
  /// `constructor`, `getter`, `setter`, `constant`, `field` or `function`.
  final String kind;

  /// Declared return type, or the owning class for constructors.
  final String returnType;

  /// Whether the member is static.
  final bool isStatic;

  /// Parameters, required first.
  final List<ApiParamFacts> params;

  /// First paragraph of the doc comment, or null.
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
    this.members = const <ApiMemberFacts>[],
  });

  /// Whether a primary constructor or function was found.
  final bool hasApiTable;

  /// Whether `package:analyzer` parsed the entry file without diagnostics.
  final bool parseClean;

  /// Primary class name (`Button`).
  final String symbol;

  /// First paragraph of the class doc, or null.
  final String? summary;

  /// Constructor parameters, required first.
  final List<ApiParamFacts> params;

  /// Declared static methods / factories / constants / top-level functions,
  /// emitted when the primary constructor carries no parameters or is
  /// private (`color`, `formatter`).
  final List<ApiMemberFacts> members;
}

/// The entry points a component declares in its manifest `api` section:
/// `methods` and `constants` are `Owner.member` names, `functions` are
/// top-level names.
///
/// The lists are the codegen's contract with the registry: only declared
/// names become rows, so the docs never invent an API surface.
class DeclaredMembers {
  /// Creates the declared set.
  const DeclaredMembers({
    this.methods = const <String>[],
    this.constants = const <String>[],
    this.functions = const <String>[],
  });

  /// `api.methods` entries (`ColorDerivative.fromColor`).
  final List<String> methods;

  /// `api.constants` entries (`TextInputFormatters.toUpperCase`).
  final List<String> constants;

  /// `api.functions` entries (`constraintToNewText`).
  final List<String> functions;

  /// Whether nothing is declared.
  bool get isEmpty => methods.isEmpty && constants.isEmpty && functions.isEmpty;

  /// Every declared name in list order (methods, constants, functions).
  List<String> get names => <String>[...methods, ...constants, ...functions];
}

/// One parsed Dart file of a component, used to resolve declared entry points.
///
/// A component's public API is spread across every file it installs
/// (`button.dart`, `button_style.dart`, the user-owned `button_theme.dart`),
/// not only its entry file, so declared names resolve against the whole set.
/// [path] is used only in diagnostics.
class DeclaredSource {
  /// Creates the source.
  const DeclaredSource({
    required this.path,
    required this.unit,
    required this.source,
  });

  /// Registry-relative file path (`components/button/button_style.dart`).
  final String path;

  /// Parsed compilation unit.
  final CompilationUnit unit;

  /// Raw source text (default clauses are sliced from it).
  final String source;
}
