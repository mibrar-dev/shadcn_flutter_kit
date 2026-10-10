// Registry input scan for the docs codegen.
//
// Reads the post-cutover registry (manifest + per-component `meta.json`
// fallback + `themes/index.json`) and returns plain data objects. Every fact
// the docs site displays comes through here; nothing is hand-typed in the
// generated outputs. Only reads files.

import 'dart:convert';
import 'dart:io';

export 'block_scan.dart';

import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';

import 'block_scan.dart';

/// The registry tree does not look like the post-cutover layout.
class RegistryScanException implements Exception {
  /// Creates the exception with a [message].
  RegistryScanException(this.message);

  /// What is wrong.
  final String message;

  @override
  String toString() => 'registry scan: $message';
}

/// One `<Name>Theme` field: `name` from `meta.json`, `type - description`
/// split on the first ` - `.
class ThemeFieldValue {
  /// Creates a field value.
  const ThemeFieldValue({
    required this.name,
    required this.type,
    required this.description,
  });

  /// Field name (`primary`).
  final String name;

  /// Declared type (`ButtonVariantStyle?`).
  final String type;

  /// Description (`filled high-emphasis row`), or empty.
  final String description;
}

/// Every generated fact about one component, normalised from the manifest
/// with `meta.json` as a fallback for stale manifests.
class ComponentFacts {
  /// Creates the facts.
  ComponentFacts({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    required this.install,
    required this.import,
    required this.entry,
    required this.files,
    required this.userOwned,
    required this.tags,
    required this.deps,
    required this.themeClass,
    required this.themeDefaults,
    required this.themeUserFile,
    required this.themeFields,
    required this.apiClasses,
    required this.apiMethods,
    required this.apiConstants,
    required this.apiFunctions,
    required this.listed,
  });

  /// Registry id == directory name.
  final String id;

  /// Manifest display name (`Button`).
  final String name;

  /// Manifest category (`control`, `display`, …).
  final String category;

  /// One-line description.
  final String description;

  /// `flutter_shadcn add <id>`.
  final String install;

  /// Corrected user import line for the installed layout.
  final String import;

  /// Registry-relative entry file (`components/button/button.dart`).
  final String entry;

  /// Registry-relative installed files (manifest `files`, no previews, no
  /// user-owned theme).
  final List<String> files;

  /// Registry-relative user-owned files (`*_theme.dart`).
  final List<String> userOwned;

  /// Manifest tags.
  final List<String> tags;

  /// Manifest deps per layer (`foundation`, `theme`, `primitives`,
  /// `components`), each sorted.
  final Map<String, List<String>> deps;

  /// `<Name>Theme` class, or null when the component has no theme.
  final String? themeClass;

  /// Defaults constant (`buttonDefaults`), or null.
  final String? themeDefaults;

  /// Declared user theme file (`button_theme.dart`), or null.
  final String? themeUserFile;

  /// Theme fields, sorted by name.
  final List<ThemeFieldValue> themeFields;

  /// Manifest `api.classes` (used as class-name fallback candidates).
  final List<String> apiClasses;

  /// Manifest `api.methods` (`ColorDerivative.fromColor`): the entry points
  /// surfaced when the primary constructor is private or parameterless.
  final List<String> apiMethods;

  /// Manifest `api.constants` (`TextInputFormatters.toUpperCase`).
  final List<String> apiConstants;

  /// Manifest `api.functions` (`constraintToNewText`).
  final List<String> apiFunctions;

  /// Whether the docs site lists this component in the sidebar, index and
  /// palette. `listed: false` marks the building blocks (P6-F3): they stay
  /// installable and reachable through the component pager/API links, but are
  /// hidden from the browsable surfaces.
  final bool listed;

  /// Whether this component physically owns a `*_theme.dart`.
  bool get hasUserTheme => userOwned.isNotEmpty;

  /// Whether a `<Name>Theme` class is recorded.
  bool get hasTheme => (themeClass ?? '').isNotEmpty;

  /// Installed Dart file count: manifest files + user-owned theme file.
  int get fileCount => files.length + userOwned.length;
}

/// One theme preset from `themes/index.json` + the manifest `themes` block.
class PresetFacts {
  /// Creates the preset facts.
  const PresetFacts({
    required this.id,
    required this.name,
    required this.modes,
    required this.file,
  });

  /// Preset id (`modern-minimal`).
  final String id;

  /// Display name (`Modern Minimal`).
  final String name;

  /// Modes in declaration order (`light`, `dark`).
  final List<String> modes;

  /// Registry-relative preset file (`themes/modern-minimal.json`).
  final String file;
}

/// One global theme token: the shadcn CSS variable name in camelCase plus the
/// CSS variable it mirrors (`cardForeground` ↔ `--card-foreground`).
class ThemeTokenFacts {
  /// Creates a token fact.
  const ThemeTokenFacts({required this.name, required this.cssVar});

  /// camelCase token name (`cardForeground`), matching the preset JSON key.
  final String name;

  /// shadcn CSS variable (`--card-foreground`).
  final String cssVar;
}

/// Everything the codegen needs from the registry, deterministically ordered.
class RegistryScan {
  /// Creates the scan result.
  const RegistryScan({
    required this.root,
    required this.schemaVersion,
    required this.components,
    required this.blocks,
    required this.presets,
    required this.themeTokens,
    required this.materialImports,
    required this.installRoot,
  });

  /// Registry root as given on the command line.
  final String root;

  /// Manifest `schemaVersion`.
  final int schemaVersion;

  /// Components ordered by category, then id.
  final List<ComponentFacts> components;

  /// Blocks ordered by category, then id (P6-B1 layer 4).
  final List<BlockFacts> blocks;

  /// Presets in `themes/index.json` order.
  final List<PresetFacts> presets;

  /// Global theme tokens in registry declaration order: the 32 `ShadcnColors`
  /// colour fields (minus `brightness`) followed by the `radius` token.
  final List<ThemeTokenFacts> themeTokens;

  /// Count of `package:flutter/material.dart` / `cupertino.dart` import
  /// directives found in the registry Dart sources (the stats band's `0`).
  final int materialImports;

  /// Install root recorded in the manifest (`lib/ui/shadcn`).
  final String installRoot;
}

/// Reads [rootPath] and returns the scan.
RegistryScan scanRegistry(String rootPath) {
  final Directory root = Directory(rootPath);
  final File manifestFile = File('${root.path}/manifests/registry.json');
  if (!manifestFile.existsSync()) {
    throw RegistryScanException(
      'missing manifest: ${manifestFile.path} (expected the post-cutover '
      'registry root)',
    );
  }
  final Map<String, Object?> manifest = _object(
    jsonDecode(manifestFile.readAsStringSync()),
    'manifest',
  );
  final Map<String, Object?> componentsJson = _object(
    manifest['components'],
    'components',
  );
  final Map<String, Object?> themesJson = _object(manifest['themes'], 'themes');

  final List<ComponentFacts> components = <ComponentFacts>[
    for (final MapEntry<String, Object?> entry in componentsJson.entries)
      _componentFacts(root, entry.key, _object(entry.value, entry.key)),
  ];
  components.sort((ComponentFacts a, ComponentFacts b) {
    final int byCategory = a.category.compareTo(b.category);
    return byCategory != 0 ? byCategory : a.id.compareTo(b.id);
  });

  final Map<String, Object?> blocksJson = _objectOrEmpty(manifest['blocks']);
  final List<BlockFacts> blocks = scanBlocks(root, blocksJson);

  final List<PresetFacts> presets = _presets(root, themesJson);
  final List<ThemeTokenFacts> themeTokens = _themeTokens(root);
  final _ImportScan imports = _scanImports(root);
  final Map<String, Object?> install = _objectOrEmpty(manifest['install']);
  return RegistryScan(
    root: root.path,
    schemaVersion: (manifest['schemaVersion'] as num?)?.toInt() ?? 0,
    components: components,
    blocks: blocks,
    presets: presets,
    themeTokens: themeTokens,
    materialImports: imports.materialImports,
    installRoot: _string(install['root'], 'lib/ui/shadcn'),
  );
}

ComponentFacts _componentFacts(
  Directory root,
  String id,
  Map<String, Object?> manifest,
) {
  final Map<String, Object?> meta = _readMeta(root, id);
  String? fromMeta(String key) {
    final Object? value = meta[key];
    return value is String && value.isNotEmpty ? value : null;
  }

  final Map<String, Object?> theme = _objectOrEmpty(manifest['theme']);
  final Map<String, Object?> metaTheme = _objectOrEmpty(meta['theme']);
  final Map<String, Object?> fieldsJson = _objectOrEmpty(
    theme['fields'] ?? metaTheme['fields'],
  );
  final List<ThemeFieldValue> fields = <ThemeFieldValue>[
    for (final MapEntry<String, Object?> field in fieldsJson.entries)
      _themeField(field.key, '${field.value}'),
  ]..sort((ThemeFieldValue a, ThemeFieldValue b) => a.name.compareTo(b.name));

  final Map<String, Object?> manifestDeps = _objectOrEmpty(manifest['deps']);
  final Map<String, Object?> metaDeps = _objectOrEmpty(meta['deps']);
  final Map<String, List<String>> deps = <String, List<String>>{
    for (final String layer in const <String>[
      'components',
      'primitives',
      'foundation',
      'theme',
    ])
      layer: _strings(manifestDeps[layer] ?? metaDeps[layer], layer)..sort(),
  };

  return ComponentFacts(
    id: id,
    name: _string(manifest['name'] ?? meta['name'], id),
    category: _string(manifest['category'] ?? meta['category'], 'utility'),
    description: _string(manifest['description'] ?? meta['description'], ''),
    install: fromMeta('install') ?? 'flutter_shadcn add $id',
    import: _string(manifest['import'] ?? meta['import'], ''),
    entry: _string(manifest['entry'], 'components/$id/$id.dart'),
    files: _strings(manifest['files'], 'files'),
    userOwned: _strings(manifest['userOwned'], 'userOwned'),
    tags: _strings(manifest['tags'] ?? meta['tags'], 'tags')..sort(),
    deps: deps,
    themeClass: (theme['class'] ?? metaTheme['class'])?.toString(),
    themeDefaults: (theme['defaults'] ?? metaTheme['defaults'])?.toString(),
    themeUserFile: (theme['userFile'] ?? metaTheme['userFile'])?.toString(),
    themeFields: fields,
    apiClasses: _strings(
      _objectOrEmpty(manifest['api'])['classes'] ??
          _objectOrEmpty(meta['api'])['classes'],
      'api.classes',
    ),
    apiMethods: _apiList(manifest, meta, 'methods'),
    apiConstants: _apiList(manifest, meta, 'constants'),
    apiFunctions: _apiList(manifest, meta, 'functions'),
    listed: _bool(manifest['listed'] ?? meta['listed'], true),
  );
}

/// One `api` list from the manifest, with `meta.json` as the fallback.
List<String> _apiList(
  Map<String, Object?> manifest,
  Map<String, Object?> meta,
  String key,
) {
  final Object? value =
      _objectOrEmpty(manifest['api'])[key] ?? _objectOrEmpty(meta['api'])[key];
  return value == null ? const <String>[] : _strings(value, 'api.$key');
}

Map<String, Object?> _readMeta(Directory root, String id) {
  final File meta = File('${root.path}/components/$id/meta.json');
  if (!meta.existsSync()) {
    return const <String, Object?>{};
  }
  try {
    return _object(jsonDecode(meta.readAsStringSync()), 'meta.json');
  } on FormatException {
    return const <String, Object?>{};
  }
}

ThemeFieldValue _themeField(String name, String raw) {
  final int split = raw.indexOf(' - ');
  if (split < 0) {
    return ThemeFieldValue(name: name, type: raw.trim(), description: '');
  }
  return ThemeFieldValue(
    name: name,
    type: raw.substring(0, split).trim(),
    description: raw.substring(split + 3).trim(),
  );
}

List<PresetFacts> _presets(
  Directory root,
  Map<String, Object?> manifestThemes,
) {
  final File index = File('${root.path}/themes/index.json');
  if (!index.existsSync()) {
    throw RegistryScanException('missing ${index.path}');
  }
  final Map<String, Object?> indexJson = _object(
    jsonDecode(index.readAsStringSync()),
    'themes/index.json',
  );
  final List<Object?> entries =
      (indexJson['themes'] as List<Object?>?) ?? const <Object?>[];
  return <PresetFacts>[
    for (final Object? entry in entries)
      _preset(root, _object(entry, 'theme entry'), manifestThemes),
  ];
}

PresetFacts _preset(
  Directory root,
  Map<String, Object?> entry,
  Map<String, Object?> manifestThemes,
) {
  final String id = _string(entry['id'], '');
  final Map<String, Object?> manifestTheme = _objectOrEmpty(manifestThemes[id]);
  final String file = _string(
    manifestTheme['file'] ?? entry['file'],
    'themes/$id.json',
  );
  List<String> modes = _strings(manifestTheme['modes'], 'modes');
  if (modes.isEmpty) {
    // Manifest fallback: derive from the preset document itself.
    final Map<String, Object?> preset = _object(
      jsonDecode(File('${root.path}/$file').readAsStringSync()),
      file,
    );
    modes = <String>[
      if (preset['light'] is Map) 'light',
      if (preset['dark'] is Map) 'dark',
    ];
  }
  return PresetFacts(
    id: id,
    name: _string(manifestTheme['name'] ?? entry['name'], id),
    modes: modes,
    file: file,
  );
}

/// The global theme tokens, parsed from the registry theme layer:
/// the `ShadcnColors` `Color` fields in declaration order, then the
/// `ShadcnTokens.radius` field. Names are camelCase of the shadcn CSS
/// variables (PLAN §6.1).
List<ThemeTokenFacts> _themeTokens(Directory root) {
  final List<({String name, String type})> colors = _classFields(
    '${root.path}/theme/color_tokens.dart',
    'ShadcnColors',
  );
  final List<({String name, String type})> tokens = _classFields(
    '${root.path}/theme/tokens.dart',
    'ShadcnTokens',
  );
  final List<String> names = <String>[
    for (final ({String name, String type}) field in colors)
      if (field.type == 'Color') field.name,
    for (final ({String name, String type}) field in tokens)
      if (field.name == 'radius') field.name,
  ];
  if (names.isEmpty) {
    throw RegistryScanException(
      'no theme tokens parsed from ${root.path}/theme/color_tokens.dart',
    );
  }
  return <ThemeTokenFacts>[
    for (final String name in names)
      ThemeTokenFacts(name: name, cssVar: _cssVarName(name)),
  ];
}

/// Field declarations of [className] in [path], in source order.
///
/// Uses `package:analyzer` (never regex): the theme layer is Dart source and
/// the token list must follow renames automatically.
List<({String name, String type})> _classFields(String path, String className) {
  final File file = File(path);
  if (!file.existsSync()) {
    throw RegistryScanException('missing theme source: $path');
  }
  final ParseStringResult result = parseString(
    content: file.readAsStringSync(),
    throwIfDiagnostics: false,
  );
  ClassDeclaration? target;
  for (final CompilationUnitMember member in result.unit.declarations) {
    if (member is ClassDeclaration &&
        member.namePart.typeName.lexeme == className) {
      target = member;
      break;
    }
  }
  if (target == null) {
    throw RegistryScanException('$path: class $className not found');
  }
  final List<({String name, String type})> fields =
      <({String name, String type})>[];
  for (final ClassMember member in target.body.members) {
    if (member is! FieldDeclaration || member.isStatic) {
      continue;
    }
    final String type = member.fields.type?.toSource() ?? '';
    for (final VariableDeclaration variable in member.fields.variables) {
      fields.add((name: variable.name.lexeme, type: type));
    }
  }
  return fields;
}

/// camelCase → shadcn CSS variable (`cardForeground` → `--card-foreground`,
/// `chart1` → `--chart-1`).
String _cssVarName(String name) {
  final StringBuffer out = StringBuffer('--');
  for (int i = 0; i < name.length; i++) {
    final String ch = name[i];
    final bool upper = ch.toUpperCase() == ch && ch.toLowerCase() != ch;
    final bool digit = _isDigit(ch);
    final bool afterLetter =
        i > 0 && !_isDigit(name[i - 1]) && name[i - 1] != '-';
    if (upper) {
      out
        ..write('-')
        ..write(ch.toLowerCase());
    } else if (digit && afterLetter) {
      out
        ..write('-')
        ..write(ch);
    } else {
      out.write(ch);
    }
  }
  return out.toString();
}

bool _isDigit(String ch) {
  final int code = ch.codeUnitAt(0);
  return code >= 0x30 && code <= 0x39;
}

final RegExp _materialImport = RegExp(
  r"^import 'package:flutter/(material|cupertino)\.dart'",
  multiLine: true,
);

_ImportScan _scanImports(Directory root) {
  int materialImports = 0;
  for (final File file in root.listSync(recursive: true).whereType<File>()) {
    if (!file.path.endsWith('.dart')) {
      continue;
    }
    final String source = file.readAsStringSync();
    materialImports += _materialImport.allMatches(source).length;
  }
  return _ImportScan(materialImports: materialImports);
}

// ---------------------------------------------------------------------------
// JSON helpers.
// ---------------------------------------------------------------------------

Map<String, Object?> _object(Object? value, String what) {
  if (value is! Map) {
    throw RegistryScanException('$what is not a JSON object');
  }
  return <String, Object?>{
    for (final MapEntry<Object?, Object?> entry in value.entries)
      entry.key.toString(): entry.value,
  };
}

Map<String, Object?> _objectOrEmpty(Object? value) =>
    value is Map ? _object(value, 'object') : const <String, Object?>{};

String _string(Object? value, String fallback) =>
    value is String ? value : fallback;

bool _bool(Object? value, bool fallback) => value is bool ? value : fallback;

List<String> _strings(Object? value, String what) {
  if (value == null) {
    return <String>[];
  }
  if (value is! List) {
    throw RegistryScanException('$what is not a JSON list');
  }
  return <String>[for (final Object? item in value) '$item'];
}

class _ImportScan {
  const _ImportScan({required this.materialImports});

  final int materialImports;
}
