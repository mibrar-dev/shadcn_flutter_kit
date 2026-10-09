// `package:analyzer` scanning for the docs codegen.
//
// Two jobs:
//  1. API extraction — the primary class's unnamed-constructor parameters
//     (name, type, default, doc, required) and the class doc summary; when
//     that constructor carries no parameters (or is private) the declared
//     static methods / factories / constants / top-level functions are
//     emitted instead (see `api_members.dart`).
//  2. Code classification — the 4-class highlight map (`p` plain, `c`
//     comment, `k` keyword, `s` string) for README code blocks, using the
//     analyzer tokenizer for Dart and tiny regex/character scanners for
//     bash and JSON.
//
// Written against the analyzer "fragments" AST (`ClassDeclaration.namePart` /
// `.body.members`, `FormalParameter.name` / `.defaultClause` /
// `.functionTypedSuffix`) used by analyzer ^14, which the docs pubspec now
// resolves. `parseClean` records parse diagnostics instead of failing the run.

import 'dart:io';

import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';

import 'api_members.dart';
import 'api_model.dart';
import 'ast_docs.dart';
import 'registry_scan.dart';

/// A codegen input cannot be scanned as expected.
class DartScanException implements Exception {
  /// Creates the exception with a [message].
  DartScanException(this.message);

  /// What is wrong.
  final String message;

  @override
  String toString() => 'dart scan: $message';
}

/// Extracts the API table facts for one component entry file.
///
/// [nameCandidates] is the preference order: the class named after the
/// manifest display name, the class named after the directory id, then the
/// manifest `api.classes` list. [declared] carries the manifest
/// `api.methods` / `api.constants` / `api.functions` entry points and
/// [sources] the parsed files they are resolved against (see
/// [declaredSources]).
/// Selection order:
///
///  1. a class named exactly after the display name or the directory id;
///  2. a widget class from the manifest `api.classes` list;
///  3. the primary top-level function (function-first components: dialog →
///     `showShadcnDialog`, popup → `showShadcnPopup`, drawer → `openDrawer`);
///  4. the manifest `api.classes` fallback list, in this order:
///     a. a class that cannot be instantiated publicly and owns declared
///        entries — the factory set (`formatter` → `TextInputFormatters`,
///        whose only constructor is `_()`), so its static methods and
///        constants become the rows;
///     b. the first candidate with a public unnamed constructor (so the
///        table carries real parameters);
///     c. the first declared candidate (symbol + summary only). This
///        resolves the irregular components whose primary type does not
///        carry the display name (`autocomplete` →
///        `AutoCompleteFeature`, `alpha` → `AlphaPainter`, `color` →
///        `ColorDerivative`, `locale_utils` → `SizeUnitLocale`).
///
/// Whenever the selected primary constructor has no parameters or is
/// private, the rows come from [declared] (`color` → `ColorDerivative`
/// factories, `formatter` → `TextInputFormatters.*`).
ApiFacts extractApi({
  required String source,
  required List<String> nameCandidates,
  DeclaredMembers declared = const DeclaredMembers(),
  List<DeclaredSource> sources = const <DeclaredSource>[],
}) {
  final ParseStringResult result = parseString(
    content: source,
    throwIfDiagnostics: false,
  );
  final bool parseClean = result.errors.isEmpty;
  final List<ClassDeclaration> classes = result.unit.declarations
      .whereType<ClassDeclaration>()
      .toList(growable: false);

  ClassDeclaration? selected;
  if (classes.isNotEmpty) {
    for (final String candidate in nameCandidates.take(2)) {
      selected = _classNamed(classes, candidate);
      if (selected != null) {
        break;
      }
    }
    selected ??= _widgetClass(classes, nameCandidates);
    if (selected != null) {
      return _classApiFacts(selected, result, parseClean, declared, sources);
    }
  }

  final ApiFacts functionFacts = _functionApiFacts(
    result,
    nameCandidates,
    source,
    parseClean,
  );
  if (functionFacts.hasApiTable) {
    return functionFacts;
  }

  if (classes.isNotEmpty) {
    final ClassDeclaration? manifestClass = _manifestClass(
      classes,
      nameCandidates,
      declared,
    );
    if (manifestClass != null) {
      return _classApiFacts(
        manifestClass,
        result,
        parseClean,
        declared,
        sources,
      );
    }
  }
  return functionFacts;
}

/// A widget class from the manifest `api.classes` fallback list.
ClassDeclaration? _widgetClass(
  List<ClassDeclaration> classes,
  List<String> nameCandidates,
) {
  for (final String candidate in nameCandidates.skip(2)) {
    final ClassDeclaration? match = _classNamed(classes, candidate);
    if (match != null && _isWidget(match)) {
      return match;
    }
  }
  return null;
}

/// Picks the primary class from the manifest `api.classes` fallback list.
ClassDeclaration? _manifestClass(
  List<ClassDeclaration> classes,
  List<String> nameCandidates,
  DeclaredMembers declared,
) {
  final List<ClassDeclaration> candidates = <ClassDeclaration>[];
  for (final String candidate in nameCandidates.skip(2)) {
    final ClassDeclaration? match = _classNamed(classes, candidate);
    if (match != null && !candidates.contains(match)) {
      candidates.add(match);
    }
  }
  if (!declared.isEmpty) {
    for (final ClassDeclaration candidate in candidates) {
      if (!_hasPublicUnnamedConstructor(candidate) &&
          declaresEntriesFor(candidate.namePart.typeName.lexeme, declared)) {
        return candidate;
      }
    }
  }
  for (final ClassDeclaration candidate in candidates) {
    if (_hasPublicUnnamedConstructor(candidate)) {
      return candidate;
    }
  }
  return candidates.firstOrNull;
}

/// Extracts the API facts from a class constructor.
///
/// A constructor with parameters is the component's call surface. When it is
/// private (`TextInputFormatters._()`) or takes no parameters
/// (`ColorDerivative()`), the declared entry points of `api.methods` /
/// `api.constants` / `api.functions` are emitted as the rows instead.
ApiFacts _classApiFacts(
  ClassDeclaration selected,
  ParseStringResult result,
  bool parseClean,
  DeclaredMembers declared,
  List<DeclaredSource> sources,
) {
  final Map<String, FieldFacts> fields = fieldsOf(selected);
  final String source = result.content;
  final ConstructorDeclaration? constructor = selected.body.members
      .whereType<ConstructorDeclaration>()
      .where((ConstructorDeclaration c) => c.name == null)
      .where((ConstructorDeclaration c) => !_isPrivate(c))
      .firstOrNull;
  final String summary = firstParagraph(cleanDocText(docComment(selected)));

  if (constructor == null) {
    final List<ApiMemberFacts> members = _declaredMembers(declared, sources);
    return ApiFacts(
      hasApiTable: members.isNotEmpty,
      parseClean: parseClean,
      symbol: selected.namePart.typeName.lexeme,
      summary: summary.isEmpty ? null : summary,
      members: members,
    );
  }

  final List<ApiParamFacts> required = <ApiParamFacts>[];
  final List<ApiParamFacts> optional = <ApiParamFacts>[];
  for (final FormalParameter parameter in constructor.parameters.parameters) {
    final ApiParamFacts? facts = formalParamFacts(parameter, fields, source);
    if (facts == null) {
      continue; // `super.key` and other infrastructure parameters.
    }
    (facts.isRequired ? required : optional).add(facts);
  }
  final List<ApiParamFacts> params = <ApiParamFacts>[...required, ...optional];

  return ApiFacts(
    hasApiTable: true,
    parseClean: parseClean,
    symbol: selected.namePart.typeName.lexeme,
    summary: summary.isEmpty ? null : summary,
    params: params,
    members: params.isEmpty
        ? _declaredMembers(declared, sources)
        : const <ApiMemberFacts>[],
  );
}

/// Rows for the declared entry points that resolve in one of the component's
/// installed files.
///
/// When [sources] is empty — a caller that only passes the entry file — the
/// entry file itself is parsed here, so single-file callers keep working.
List<ApiMemberFacts> _declaredMembers(
  DeclaredMembers declared,
  List<DeclaredSource> sources,
) {
  if (declared.isEmpty) {
    return const <ApiMemberFacts>[];
  }
  return extractDeclaredMembers(sources: sources, declared: declared);
}

/// Parsed files a component's declared entry points resolve against.
///
/// The entry file comes first (so `color`/`formatter` keep resolving there),
/// followed by the component's other installed files and its user-owned theme
/// file: `buttonDefaults` lives in `button_style.dart`, `buttonThemeOverrides`
/// in `button_theme.dart`. Previews are excluded — they are demo code, not API.
///
/// [entrySource] is the already-read entry text; the remaining files are read
/// from [registryRoot] relative to their registry-relative path.
List<DeclaredSource> declaredSources(
  String registryRoot,
  ComponentFacts component,
  String entrySource,
  String entryPath,
) {
  final List<DeclaredSource> sources = <DeclaredSource>[
    DeclaredSource(
      path: entryPath,
      unit: parseString(content: entrySource, throwIfDiagnostics: false).unit,
      source: entrySource,
    ),
  ];
  for (final String file in <String>[
    ...component.files,
    ...component.userOwned,
  ]) {
    if (file == component.entry || file == entryPath) {
      continue;
    }
    final File dart = File('$registryRoot/$file');
    if (!dart.existsSync()) {
      continue;
    }
    final String source = dart.readAsStringSync();
    sources.add(
      DeclaredSource(
        path: file,
        unit: parseString(content: source, throwIfDiagnostics: false).unit,
        source: source,
      ),
    );
  }
  return sources;
}

/// Extracts the API facts from a function-first component's primary function.
///
/// The primary function is the public top-level function whose name contains
/// the component's PascalCase name (e.g. `showShadcnDialog` for `dialog`,
/// `openDrawer` for `drawer`). When several match, `show*` wins over `open*`,
/// then the first declaration.
ApiFacts _functionApiFacts(
  ParseStringResult result,
  List<String> nameCandidates,
  String source,
  bool parseClean,
) {
  final List<FunctionDeclaration> functions = result.unit.declarations
      .whereType<FunctionDeclaration>()
      .where((FunctionDeclaration f) => !f.name.lexeme.startsWith('_'))
      .toList(growable: false);
  if (functions.isEmpty) {
    return ApiFacts(hasApiTable: false, parseClean: parseClean);
  }

  // Collect functions whose name contains a candidate (case-insensitive).
  final List<FunctionDeclaration> matches = <FunctionDeclaration>[];
  for (final String candidate in nameCandidates.take(2)) {
    final String lower = candidate.toLowerCase();
    for (final FunctionDeclaration function in functions) {
      if (function.name.lexeme.toLowerCase().contains(lower)) {
        matches.add(function);
      }
    }
  }
  if (matches.isEmpty) {
    return ApiFacts(hasApiTable: false, parseClean: parseClean);
  }

  // Preference: show* > open* > first declaration.
  matches.sort((FunctionDeclaration a, FunctionDeclaration b) {
    final int rankA = _functionRank(a.name.lexeme);
    final int rankB = _functionRank(b.name.lexeme);
    if (rankA != rankB) {
      return rankA - rankB;
    }
    return a.offset.compareTo(b.offset);
  });
  final FunctionDeclaration primary = matches.first;

  final List<ApiParamFacts> required = <ApiParamFacts>[];
  final List<ApiParamFacts> optional = <ApiParamFacts>[];
  final FormalParameterList? parameters = primary.functionExpression.parameters;
  if (parameters != null) {
    for (final FormalParameter parameter in parameters.parameters) {
      final ApiParamFacts? facts = formalParamFacts(
        parameter,
        const <String, FieldFacts>{},
        source,
      );
      if (facts == null) {
        continue;
      }
      (facts.isRequired ? required : optional).add(facts);
    }
  }
  return ApiFacts(
    hasApiTable: true,
    parseClean: parseClean,
    symbol: primary.name.lexeme,
    summary: firstDocLine(primary),
    params: <ApiParamFacts>[...required, ...optional],
  );
}

int _functionRank(String name) {
  if (name.startsWith('show')) {
    return 0;
  }
  if (name.startsWith('open')) {
    return 1;
  }
  return 2;
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
            !c.namePart.typeName.lexeme.startsWith('_') &&
            c.namePart.typeName.lexeme.endsWith('Preview') &&
            _isWidget(c),
      )
      .toList(growable: false);
  final Set<String> names = <String>{
    for (final ClassDeclaration c in widgetPreviews) c.namePart.typeName.lexeme,
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
    return widgetPreviews.single.namePart.typeName.lexeme;
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
    if (declaration.namePart.typeName.lexeme == name) {
      return declaration;
    }
  }
  return null;
}

bool _isWidget(ClassDeclaration declaration) {
  final String base = declaration.extendsClause?.superclass.toSource() ?? '';
  return base == 'StatelessWidget' || base == 'StatefulWidget';
}

/// Whether [declaration] declares a public unnamed constructor.
///
/// `TextInputFormatters._()` is private (and therefore not the component's
/// callable surface), while `TimeFormatter({required this.length})` is.
bool _hasPublicUnnamedConstructor(ClassDeclaration declaration) {
  return declaration.body.members.whereType<ConstructorDeclaration>().any(
    (ConstructorDeclaration constructor) =>
        constructor.name == null && !_isPrivate(constructor),
  );
}

/// Whether an unnamed constructor is private (`Foo._()`: its name is `_`).
bool _isPrivate(ConstructorDeclaration constructor) =>
    constructor.name?.lexeme == '_';
