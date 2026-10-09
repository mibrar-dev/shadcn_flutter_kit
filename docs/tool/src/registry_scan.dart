// Registry input scan for the docs codegen.
//
// Reads the post-cutover registry (manifest + per-component `meta.json`
// fallback + `themes/index.json`) and returns plain data objects. Every fact
// the docs site displays comes through here; nothing is hand-typed in the
// generated outputs. Only reads files.

import 'dart:convert';
import 'dart:io';

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

/// Everything the codegen needs from the registry, deterministically ordered.
class RegistryScan {
  /// Creates the scan result.
  const RegistryScan({
    required this.root,
    required this.schemaVersion,
    required this.components,
    required this.presets,
    required this.materialImports,
    required this.installRoot,
  });

  /// Registry root as given on the command line.
  final String root;

  /// Manifest `schemaVersion`.
  final int schemaVersion;

  /// Components ordered by category, then id.
  final List<ComponentFacts> components;

  /// Presets in `themes/index.json` order.
  final List<PresetFacts> presets;

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

  final List<PresetFacts> presets = _presets(root, themesJson);
  final _ImportScan imports = _scanImports(root);
  final Map<String, Object?> install = _objectOrEmpty(manifest['install']);
  return RegistryScan(
    root: root.path,
    schemaVersion: (manifest['schemaVersion'] as num?)?.toInt() ?? 0,
    components: components,
    presets: presets,
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
  );
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
