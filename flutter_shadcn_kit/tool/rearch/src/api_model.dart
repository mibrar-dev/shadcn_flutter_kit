// Public API snapshot model.

import 'json_utils.dart';

/// A parameter of a constructor, method or function.
Map<String, Object?> apiParameter({
  required String name,
  required String? type,
  required String kind,
  required bool required,
}) => <String, Object?>{
  'name': name,
  'type': type,
  'kind': kind,
  'required': required,
};

/// A member of an API symbol (constructor, method, field, ...).
class ApiMember {
  ApiMember({
    required this.kind,
    required this.name,
    this.extra = const <String, Object?>{},
  });

  /// Member kind, e.g. `constructor`, `method`, `field`, `enumConstant`.
  final String kind;

  /// Member name (unnamed constructors use the class name).
  final String name;

  /// Additional stable fields (type, static, parameters, ...).
  final Map<String, Object?> extra;

  /// Diff key: kind plus name.
  String get key => '$kind:$name';

  /// JSON form.
  Map<String, Object?> toJson() => <String, Object?>{
    'kind': kind,
    'name': name,
    ...extra,
  };

  /// Signature used for change detection (no file/line noise).
  String get canonical => stableJsonEncode(toJson(), pretty: false);
}

/// A public top-level API symbol.
class ApiSymbol {
  ApiSymbol({
    required this.kind,
    required this.name,
    required this.file,
    this.extra = const <String, Object?>{},
    this.members = const <ApiMember>[],
  });

  /// Symbol kind, e.g. `class`, `enum`, `function`, `variable`, `typedef`.
  final String kind;

  /// Symbol name.
  final String name;

  /// File relative to the scan root.
  final String file;

  /// Additional stable fields.
  final Map<String, Object?> extra;

  /// Members (classes, mixins, enums, extensions).
  final List<ApiMember> members;

  /// Diff key: kind plus name.
  String get key => '$kind:$name';

  /// JSON form.
  Map<String, Object?> toJson() => <String, Object?>{
    'kind': kind,
    'name': name,
    'file': file,
    ...extra,
    if (members.isNotEmpty)
      'members': [for (final member in members) member.toJson()],
  };

  /// Signature used for change detection (excludes the source file).
  String get canonical => stableJsonEncode(<String, Object?>{
    'kind': kind,
    'name': name,
    ...extra,
    'members': [for (final member in members) member.toJson()],
  }, pretty: false);
}

/// Public API of one component.
class ApiComponentSnapshot {
  ApiComponentSnapshot({
    required this.id,
    required this.entry,
    required this.files,
    required this.symbols,
    this.warnings = const <String>[],
  });

  /// Component id.
  final String id;

  /// Entry file relative to the scan root, or null when no entry was found.
  final String? entry;

  /// Every file reached through exports/parts, relative to the scan root.
  final List<String> files;

  /// Public symbols sorted by name and kind.
  final List<ApiSymbol> symbols;

  /// Extraction warnings (missing targets, duplicate symbols, ...).
  final List<String> warnings;

  /// JSON form.
  Map<String, Object?> toJson() => <String, Object?>{
    'id': id,
    'entry': entry,
    'files': files,
    'symbolCount': symbols.length,
    if (warnings.isNotEmpty) 'warnings': warnings,
    'symbols': [for (final symbol in symbols) symbol.toJson()],
  };
}

/// Whole-registry API snapshot.
class ApiSnapshot {
  ApiSnapshot({
    required this.root,
    required this.generatedAt,
    required this.skipGenerated,
    required this.components,
    this.skipped = const <Map<String, Object?>>[],
  });

  /// Scan root.
  final String root;

  /// UTC timestamp of the run.
  final String generatedAt;

  /// Whether generated files were skipped.
  final bool skipGenerated;

  /// Component snapshots sorted by id.
  final List<ApiComponentSnapshot> components;

  /// Components that could not be snapshotted (no entry file, ...).
  final List<Map<String, Object?>> skipped;

  /// JSON form.
  Map<String, Object?> toJson() => <String, Object?>{
    'tool': 'api_snapshot',
    'schemaVersion': 1,
    'generatedAt': generatedAt,
    'root': root,
    'skipGenerated': skipGenerated,
    'summary': <String, Object?>{
      'components': components.length,
      'skipped': skipped.length,
      'symbols': components.fold<int>(
        0,
        (sum, component) => sum + component.symbols.length,
      ),
    },
    'components': [for (final component in components) component.toJson()],
    if (skipped.isNotEmpty) 'skipped': skipped,
  };

  /// Human readable summary lines.
  List<String> summaryLines() {
    final lines = <String>[
      'api_snapshot: ${components.length} components, '
          '${components.fold<int>(0, (sum, c) => sum + c.symbols.length)} symbols',
    ];
    for (final skip in skipped) {
      lines.add('  skipped ${skip['id']}: ${skip['reason']}');
    }
    return lines;
  }
}
