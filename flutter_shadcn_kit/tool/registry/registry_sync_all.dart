import 'dart:convert';
import 'dart:io';

import '../common/registry_component_metadata.dart';
import 'registry_barrel.dart';

typedef JsonMap = Map<String, dynamic>;

typedef JsonList = List<dynamic>;

const _allowedTiers = {'primitive', 'component', 'pattern'};
final _semVerPattern = RegExp(
  r'^\d+\.\d+\.\d+(?:-[0-9A-Za-z-]+(?:\.[0-9A-Za-z-]+)*)?(?:\+[0-9A-Za-z-]+(?:\.[0-9A-Za-z-]+)*)?$',
);

class _RegistryValidationError implements Exception {
  _RegistryValidationError(this.message);

  final String message;

  @override
  String toString() => message;
}

class _PendingMetaWrite {
  _PendingMetaWrite({
    required this.metadata,
    required this.originalMeta,
    required this.updatedMeta,
  });

  final ComponentMetadataPaths metadata;
  final JsonMap originalMeta;
  final JsonMap updatedMeta;
}

Directory? _findRepoRoot(Directory start) {
  Directory current = start.absolute;
  while (true) {
    final candidate = File(
      '${current.path}/lib/registry/manifests/components.json',
    );
    if (candidate.existsSync()) {
      return current;
    }
    final parent = current.parent;
    if (parent.path == current.path) {
      return null;
    }
    current = parent;
  }
}

JsonMap _readJson(File file) {
  return jsonDecode(file.readAsStringSync()) as JsonMap;
}

void _writeJson(File file, Object data) {
  final encoder = const JsonEncoder.withIndent('  ');
  file.writeAsStringSync('${encoder.convert(data)}\n');
}

void _writeRootBarrel(Directory root) {
  final output = File('${root.path}/lib/flutter_shadcn_kit.dart');
  output.writeAsStringSync(buildRootBarrel(root));
}

String _join(String a, String b) {
  if (a.endsWith(Platform.pathSeparator)) {
    return '$a$b';
  }
  return '$a${Platform.pathSeparator}$b';
}

class _ParsedArgs {
  _ParsedArgs(this.values, this.flags);

  final Map<String, List<String>> values;
  final Set<String> flags;

  bool hasFlag(String name) => flags.contains(name);
  String? getValue(String name) => values[name]?.last;
}

_ParsedArgs _parseArgs(List<String> args) {
  final values = <String, List<String>>{};
  final flags = <String>{};
  for (var i = 0; i < args.length; i++) {
    final arg = args[i];
    if (!arg.startsWith('--')) continue;
    final trimmed = arg.substring(2);
    if (trimmed.isEmpty) continue;
    final eqIndex = trimmed.indexOf('=');
    if (eqIndex != -1) {
      final key = trimmed.substring(0, eqIndex);
      final value = trimmed.substring(eqIndex + 1);
      values.putIfAbsent(key, () => []).add(value);
      continue;
    }
    if (i + 1 < args.length && !args[i + 1].startsWith('--')) {
      final value = args[i + 1];
      i += 1;
      values.putIfAbsent(trimmed, () => []).add(value);
      continue;
    }
    flags.add(trimmed);
  }
  return _ParsedArgs(values, flags);
}

int _parseManifestVersion(dynamic value, {int fallback = 1}) {
  if (value is int) return value;
  if (value is String) {
    final parsed = int.tryParse(value);
    if (parsed != null) return parsed;
  }
  return fallback;
}

void _printUsage() {
  stdout.writeln(
    'Usage: dart run tool/registry/registry_sync_all.dart [options]',
  );
  stdout.writeln('');
  stdout.writeln('Syncs registry components.json, docs snapshot,');
  stdout.writeln('docs registry mirror,');
  stdout.writeln('and refreshes component meta.json files.');
  stdout.writeln('');
  stdout.writeln('Options:');
  stdout.writeln(
    '  --bump-manifest-version       Increment manifestVersion in components.json.',
  );
  stdout.writeln(
    '  --set-manifest-version <int>  Set manifestVersion explicitly.',
  );
  stdout.writeln('  --force                       Skip manifestVersion guard.');
  stdout.writeln('  -h, --help                    Show this help.');
  stdout.writeln('');
  stdout.writeln(
    'Notes: If manifestVersion > 1, the script refuses to run unless',
  );
  stdout.writeln(
    '  --bump-manifest-version, --set-manifest-version, or --force is used.',
  );
}

bool _syncDocsRegistryMirror(Directory root) {
  final docsDirs = <Directory>[
    Directory('${root.parent.path}/docs'),
    Directory('${root.path}/docs'),
  ];

  for (final docsDir in docsDirs) {
    final syncScript = File('${docsDir.path}/scripts/sync_registry.py');
    if (!syncScript.existsSync()) continue;

    final result = Process.runSync('python3', const [
      'scripts/sync_registry.py',
    ], workingDirectory: docsDir.path);
    if (result.exitCode != 0) {
      stderr.writeln('Docs registry mirror sync failed.');
      if (result.stdout.toString().trim().isNotEmpty) {
        stderr.writeln(result.stdout);
      }
      if (result.stderr.toString().trim().isNotEmpty) {
        stderr.writeln(result.stderr);
      }
      exitCode = result.exitCode;
      return false;
    }

    stdout.writeln('Docs registry mirror synced: ${docsDir.path}.');
    return true;
  }

  stdout.writeln(
    'Docs registry mirror sync skipped: docs/scripts/sync_registry.py not found.',
  );
  return true;
}

final _partOfPattern = RegExp(
  "^\\s*part\\s+of\\s+['\\\"]([^'\\\"]+)['\\\"]\\s*;",
  multiLine: true,
);
final _partPattern = RegExp(
  "^\\s*part\\s+(?!of\\b)['\\\"]([^'\\\"]+)['\\\"]\\s*;",
  multiLine: true,
);

bool _isResolvablePartRef(String ref) {
  if (ref.contains(':')) return false;
  return ref.endsWith('.dart');
}

String? _relativeToEntry(File file, Directory entryDir) {
  final entryRoot = entryDir.absolute.path;
  final entryPrefix = entryRoot.endsWith(Platform.pathSeparator)
      ? entryRoot
      : '$entryRoot${Platform.pathSeparator}';
  final absolutePath = file.absolute.path;
  if (!absolutePath.startsWith(entryPrefix)) return null;
  return absolutePath.substring(entryPrefix.length).replaceAll('\\', '/');
}

String? _resolveRelativeToEntry({
  required Directory entryDir,
  required File sourceFile,
  required String ref,
}) {
  if (!_isResolvablePartRef(ref)) return null;
  final resolved = File(_join(sourceFile.parent.path, ref)).absolute;
  return _relativeToEntry(resolved, entryDir);
}

Map<String, Set<String>> _collectPartDependencies(Directory entryDir) {
  final dependencies = <String, Set<String>>{};
  for (final entity in entryDir.listSync(recursive: true)) {
    if (entity is! File) continue;
    if (!entity.path.endsWith('.dart')) continue;
    final rel = _relativeToEntry(entity, entryDir);
    if (rel == null) continue;
    final content = entity.readAsStringSync();

    for (final match in _partPattern.allMatches(content)) {
      final ref = match.group(1);
      if (ref == null) continue;
      final partRel = _resolveRelativeToEntry(
        entryDir: entryDir,
        sourceFile: entity,
        ref: ref,
      );
      if (partRel == null) continue;
      dependencies.putIfAbsent(rel, () => <String>{}).add(partRel);
    }

    for (final match in _partOfPattern.allMatches(content)) {
      final ref = match.group(1);
      if (ref == null) continue;
      final libraryRel = _resolveRelativeToEntry(
        entryDir: entryDir,
        sourceFile: entity,
        ref: ref,
      );
      if (libraryRel == null) continue;
      dependencies.putIfAbsent(libraryRel, () => <String>{}).add(rel);
    }
  }
  return dependencies;
}

List<JsonMap> _buildFileMappings({
  required Directory registryDir,
  required Directory entryDir,
  required String type,
}) {
  final files = <JsonMap>[];
  final baseRel = entryDir.path
      .substring(registryDir.path.length + 1)
      .replaceAll('\\', '/');
  final relFiles = listComponentSourceFilesRelative(entryDir);
  final partDependencies = type == 'components'
      ? _collectPartDependencies(entryDir)
      : const {};
  for (final rel in relFiles) {
    final registryRel = '$baseRel/$rel';
    final source = type == 'components' ? 'registry/$registryRel' : registryRel;
    final destination = '{installPath}/$registryRel';
    final mapping = <String, dynamic>{
      'source': source,
      'destination': destination,
    };
    final deps = partDependencies[rel];
    if (deps != null && deps.isNotEmpty && type == 'components') {
      mapping['dependsOn'] = deps
          .map((depRel) => {'source': 'registry/$baseRel/$depRel'})
          .toList();
    }
    files.add(mapping);
  }
  return files;
}

String _stripExtension(String name) {
  final index = name.lastIndexOf('.');
  if (index <= 0) return name;
  return name.substring(0, index);
}

String? _extractSource(dynamic entry) {
  if (entry is String) return entry;
  if (entry is Map && entry['source'] is String) {
    return entry['source'] as String;
  }
  return null;
}

String _topFolderFromSource(String source) {
  const prefix = 'registry/shared/';
  final rel = source.startsWith(prefix)
      ? source.substring(prefix.length)
      : source;
  final parts = rel.split('/');
  return parts.first;
}

String _sharedDestination(String source) {
  const prefix = 'registry/shared/';
  final rel = source.startsWith(prefix)
      ? source.substring(prefix.length)
      : source;
  return '{sharedPath}/$rel';
}

String? _preferredSharedEntryIdForSource(String source) {
  switch (source) {
    case 'registry/shared/fonts/lucide.ttf':
    case 'registry/shared/icons/lucide_icons.dart':
    case 'registry/shared/icons/lucide_icons_list.dart':
      return 'lucide_icons';
    case 'registry/shared/fonts/radix.otf':
    case 'registry/shared/icons/radix_icons.dart':
    case 'registry/shared/icons/radix_icons_list.dart':
      return 'radix_icons';
    case 'registry/shared/fonts/bootstrap.otf':
    case 'registry/shared/icons/bootstrap_icons.dart':
    case 'registry/shared/icons/bootstrap_icons_list.dart':
      return 'bootstrap_icons';
    case 'registry/shared/fonts/NotoSansSymbols2-Regular.ttf':
      return 'theme';
  }

  if (source.startsWith('registry/shared/fonts/geist/')) {
    return 'theme';
  }

  return null;
}

String _defaultSharedEntryDescription(String id, String source) {
  switch (id) {
    case 'bootstrap_icons':
      return 'Bootstrap icon font mappings used by icon-based components.';
    case 'lucide_icons':
      return 'Lucide icon font mappings used by controls.';
    case 'radix_icons':
      return 'Radix icon font mappings used by menus.';
    case 'theme':
      return 'Core theme data, color schemes, and typography.';
  }

  return 'Shared helpers from ${source.replaceFirst('registry/shared/', '')}.';
}

String _resolveSharedEntryId({
  required String source,
  required Map<String, JsonMap> entries,
  required Map<String, Set<String>> entryFolders,
}) {
  final preferred = _preferredSharedEntryIdForSource(source);
  if (preferred != null) {
    return preferred;
  }

  const prefix = 'registry/shared/';
  final rel = source.startsWith(prefix)
      ? source.substring(prefix.length)
      : source;
  final baseName = _stripExtension(_basename(rel));
  if (entries.containsKey(baseName)) {
    return baseName;
  }
  final topFolder = rel.split('/').first;
  final matches = entryFolders.entries
      .where((entry) => entry.value.contains(topFolder))
      .map((entry) => entry.key)
      .toList();
  if (matches.length == 1) {
    return matches.first;
  }
  var candidate = baseName.isEmpty ? topFolder : baseName;
  var unique = candidate;
  var counter = 1;
  while (entries.containsKey(unique)) {
    unique = '${candidate}_$counter';
    counter += 1;
  }
  return unique;
}

List<JsonMap> _updateSharedEntries(
  Directory registryDir,
  List<dynamic>? existingShared,
) {
  final sharedRoot = Directory('${registryDir.path}/shared');
  if (!sharedRoot.existsSync()) {
    return existingShared?.whereType<Map>().map(JsonMap.from).toList() ??
        <JsonMap>[];
  }

  final allSources = listSharedSourceFilesRelative(sharedRoot)
      .map((rel) => 'registry/shared/$rel')
      .where((source) => !_isSharedFontAssetSource(source))
      .toList();
  allSources.sort();
  final allSourceSet = allSources.toSet();

  final updatedEntries = <String, JsonMap>{};
  final order = <String>[];
  final fileToEntry = <String, String>{};
  final entryFolders = <String, Set<String>>{};

  for (final entry in existingShared ?? <dynamic>[]) {
    if (entry is! Map) continue;
    final id = entry['id'];
    if (id is! String || id.isEmpty) continue;
    if (!updatedEntries.containsKey(id)) {
      final normalized = <String, dynamic>{
        'id': id,
        if (entry['description'] is String) 'description': entry['description'],
        'files': <Map<String, String>>[],
      };
      updatedEntries[id] = normalized;
      order.add(id);
    }

    final files = (entry['files'] as List?) ?? <dynamic>[];
    for (final file in files) {
      final source = _extractSource(file);
      if (source == null || !allSourceSet.contains(source)) continue;
      if (fileToEntry.containsKey(source)) continue;

      final targetId = _preferredSharedEntryIdForSource(source) ?? id;
      var targetEntry = updatedEntries[targetId];
      if (targetEntry == null) {
        targetEntry = <String, dynamic>{
          'id': targetId,
          'description': _defaultSharedEntryDescription(targetId, source),
          'files': <Map<String, String>>[],
        };
        updatedEntries[targetId] = targetEntry;
      }
      final targetFiles = (targetEntry['files'] as List)
          .cast<Map<String, String>>();

      targetFiles.add({
        'source': source,
        'destination': _sharedDestination(source),
      });
      fileToEntry[source] = targetId;
    }
  }

  for (final entry in updatedEntries.entries) {
    final files = (entry.value['files'] as List).cast<Map<String, String>>();
    final folders = <String>{};
    for (final file in files) {
      final source = file['source'];
      if (source == null) continue;
      folders.add(_topFolderFromSource(source));
    }
    entryFolders[entry.key] = folders;
  }

  for (final source in allSources) {
    if (fileToEntry.containsKey(source)) continue;
    final id = _resolveSharedEntryId(
      source: source,
      entries: updatedEntries,
      entryFolders: entryFolders,
    );

    var entry = updatedEntries[id];
    if (entry == null) {
      entry = <String, dynamic>{
        'id': id,
        'description': _defaultSharedEntryDescription(id, source),
        'files': <Map<String, String>>[],
      };
      updatedEntries[id] = entry;
      entryFolders[id] = <String>{};
    }

    (entry['files'] as List).add({
      'source': source,
      'destination': _sharedDestination(source),
    });
    fileToEntry[source] = id;
    entryFolders[id]!.add(_topFolderFromSource(source));
  }

  final output = <JsonMap>[];
  for (final id in order) {
    final entry = updatedEntries[id];
    if (entry == null) continue;
    final files = (entry['files'] as List).cast<Map<String, String>>();
    if (files.isEmpty) continue;
    files.sort((a, b) => a['source']!.compareTo(b['source']!));
    output.add(entry);
  }

  final newIds = updatedEntries.keys.where((id) => !order.contains(id)).toList()
    ..sort();
  for (final id in newIds) {
    final entry = updatedEntries[id]!;
    final files = (entry['files'] as List).cast<Map<String, String>>();
    if (files.isEmpty) continue;
    files.sort((a, b) => a['source']!.compareTo(b['source']!));
    output.add(entry);
  }

  return output;
}

bool _isSharedFontAssetSource(String source) {
  return source == 'registry/shared/fonts/NotoSansSymbols2-Regular.ttf' ||
      source.startsWith('registry/shared/fonts/geist/') ||
      source == 'registry/shared/fonts/lucide.ttf' ||
      source == 'registry/shared/fonts/radix.otf' ||
      source == 'registry/shared/fonts/bootstrap.otf';
}

String _titleCase(String input) {
  final parts = input.replaceAll('_', ' ').split(RegExp(r'\s+'));
  return parts
      .where((p) => p.isNotEmpty)
      .map((p) => p[0].toUpperCase() + p.substring(1))
      .join(' ');
}

String _basename(String path) {
  final normalized = path.replaceAll('\\', '/');
  final parts = normalized.split('/');
  for (var i = parts.length - 1; i >= 0; i--) {
    final part = parts[i];
    if (part.isNotEmpty) {
      return part;
    }
  }
  return '';
}

List<String> _asStringList(dynamic value) {
  if (value is List) {
    return value.whereType<String>().toList();
  }
  return <String>[];
}

JsonMap _asJsonMap(dynamic value) {
  if (value is Map) {
    return Map<String, dynamic>.from(value);
  }
  return <String, dynamic>{};
}

bool _deepEquals(dynamic a, dynamic b) {
  if (a is Map && b is Map) {
    if (a.length != b.length) return false;
    for (final key in a.keys) {
      if (!b.containsKey(key)) return false;
      if (!_deepEquals(a[key], b[key])) return false;
    }
    return true;
  }
  if (a is List && b is List) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (!_deepEquals(a[i], b[i])) return false;
    }
    return true;
  }
  return a == b;
}

JsonMap _mergeMeta({
  required String id,
  required String category,
  required JsonMap meta,
  required JsonMap? existingEntry,
  required List<String> fileList,
  required String metadataPath,
}) {
  final updated = JsonMap.from(meta);

  final name =
      meta['name'] as String? ??
      (existingEntry?['name'] as String?) ??
      _titleCase(id);
  final description =
      meta['description'] as String? ??
      (existingEntry?['description'] as String?) ??
      '';
  final tier = _requireTier(
    id: id,
    value: meta['tier'],
    metadataPath: metadataPath,
  );
  final version = _requireVersion(
    id: id,
    value: meta['version'],
    metadataPath: metadataPath,
  );

  final tags = meta['tags'] is List
      ? (meta['tags'] as List).whereType<String>().toList()
      : (existingEntry?['tags'] is List
            ? (existingEntry?['tags'] as List).whereType<String>().toList()
            : <String>[category, id]);

  final metaDeps = _asJsonMap(meta['dependencies']);
  final shared = _asStringList(metaDeps['shared']);
  final components = _asStringList(metaDeps['components']);

  final existingShared = existingEntry?['shared'] is List
      ? (existingEntry?['shared'] as List).whereType<String>().toList()
      : <String>[];
  final existingComponents = existingEntry?['dependsOn'] is List
      ? (existingEntry?['dependsOn'] as List).whereType<String>().toList()
      : <String>[];

  final resolvedShared = shared.isNotEmpty ? shared : existingShared;
  final resolvedComponents = components.isNotEmpty
      ? components
      : existingComponents;

  final metaPubspecRaw = metaDeps['pubspec'];
  var metaPubspec = <String, dynamic>{};
  var metaDevPubspec = <String, dynamic>{};
  if (metaPubspecRaw is Map) {
    if (metaPubspecRaw.containsKey('dependencies') ||
        metaPubspecRaw.containsKey('dev_dependencies')) {
      final deps = metaPubspecRaw['dependencies'];
      final devDeps = metaPubspecRaw['dev_dependencies'];
      if (deps is Map) {
        metaPubspec = Map<String, dynamic>.from(deps);
      }
      if (devDeps is Map) {
        metaDevPubspec = Map<String, dynamic>.from(devDeps);
      }
    } else {
      metaPubspec = Map<String, dynamic>.from(metaPubspecRaw);
    }
  }

  final existingPubspec = _asJsonMap(existingEntry?['pubspec']);
  final existingDeps = _asJsonMap(existingPubspec['dependencies']);
  final existingDevDeps = _asJsonMap(existingPubspec['dev_dependencies']);

  final resolvedPubspec = metaPubspec.isNotEmpty ? metaPubspec : existingDeps;
  final resolvedDevPubspec = metaDevPubspec.isNotEmpty
      ? metaDevPubspec
      : existingDevDeps;

  final assets = meta['assets'] is List
      ? (meta['assets'] as List).whereType<String>().toList()
      : (existingEntry?['assets'] is List
            ? (existingEntry?['assets'] as List).whereType<String>().toList()
            : <String>[]);
  final postInstall = meta['postInstall'] is List
      ? (meta['postInstall'] as List).whereType<String>().toList()
      : (existingEntry?['postInstall'] is List
            ? (existingEntry?['postInstall'] as List)
                  .whereType<String>()
                  .toList()
            : <String>[]);

  updated['id'] = id;
  updated['name'] = name;
  updated['description'] = description;
  updated['category'] = category;
  updated['tier'] = tier;
  updated['tags'] = tags;
  updated['dependencies'] = {
    'shared': resolvedShared,
    'components': resolvedComponents,
    'pubspec': resolvedPubspec,
    if (resolvedDevPubspec.isNotEmpty) 'dev_dependencies': resolvedDevPubspec,
  };
  if (assets.isNotEmpty) {
    updated['assets'] = assets;
  }
  if (postInstall.isNotEmpty) {
    updated['postInstall'] = postInstall;
  }
  updated['files'] = fileList;
  updated['version'] = version;

  return updated;
}

JsonMap _buildEntry({
  required Directory registryDir,
  required Directory entryDir,
  required String type,
  required JsonMap meta,
  required JsonMap? existingEntry,
  required String metadataPath,
}) {
  final id = _basename(entryDir.path);
  final category = _basename(entryDir.parent.path);
  final fileList = listComponentSourceFilesRelative(entryDir);

  final updatedMeta = _mergeMeta(
    id: id,
    category: category,
    meta: meta,
    existingEntry: existingEntry,
    fileList: fileList,
    metadataPath: metadataPath,
  );

  final name = updatedMeta['name'] as String? ?? _titleCase(id);
  final description = updatedMeta['description'] as String? ?? '';
  final tier = _requireTier(
    id: id,
    value: updatedMeta['tier'],
    metadataPath: metadataPath,
  );
  final tags = updatedMeta['tags'] is List
      ? (updatedMeta['tags'] as List).whereType<String>().toList()
      : <String>[category, id];

  final deps = _asJsonMap(updatedMeta['dependencies']);
  final shared = _asStringList(deps['shared']);
  final components = _asStringList(deps['components']);
  final pubspecDeps = _asJsonMap(deps['pubspec']);
  final pubspecDev = _asJsonMap(deps['dev_dependencies']);

  final assets = updatedMeta['assets'] is List
      ? (updatedMeta['assets'] as List).whereType<String>().toList()
      : (existingEntry?['assets'] is List
            ? (existingEntry?['assets'] as List).whereType<String>().toList()
            : <String>[]);
  final postInstall = updatedMeta['postInstall'] is List
      ? (updatedMeta['postInstall'] as List).whereType<String>().toList()
      : (existingEntry?['postInstall'] is List
            ? (existingEntry?['postInstall'] as List)
                  .whereType<String>()
                  .toList()
            : <String>[]);

  final files = _buildFileMappings(
    registryDir: registryDir,
    entryDir: entryDir,
    type: type,
  );

  final entry = <String, dynamic>{};
  if (existingEntry != null) {
    entry.addAll(existingEntry);
  }
  entry['id'] = id;
  entry['name'] = name;
  entry['description'] = description;
  entry['category'] = category;
  entry['tier'] = tier;
  entry['tags'] = tags;
  entry['files'] = files;
  entry['shared'] = shared;
  entry['dependsOn'] = components;
  entry['pubspec'] = {
    'dependencies': pubspecDeps,
    if (pubspecDev.isNotEmpty) 'dev_dependencies': pubspecDev,
  };
  entry['assets'] = assets;
  entry['postInstall'] = postInstall;
  entry['version'] = _requireVersion(
    id: id,
    value: updatedMeta['version'],
    metadataPath: metadataPath,
  );

  return entry;
}

String _requireTier({
  required String id,
  required dynamic value,
  required String metadataPath,
}) {
  if (value is! String || value.trim().isEmpty) {
    throw _RegistryValidationError(
      'Component "$id" is missing tier in $metadataPath.',
    );
  }
  final normalized = value.trim();
  if (_allowedTiers.contains(normalized)) {
    return normalized;
  }
  throw _RegistryValidationError(
    'Component "$id" has invalid tier "$value" in $metadataPath. '
    'Expected one of: ${_allowedTiers.join(', ')}.',
  );
}

String _requireVersion({
  required String id,
  required dynamic value,
  required String metadataPath,
}) {
  if (value is! String || value.trim().isEmpty) {
    throw _RegistryValidationError(
      'Component "$id" is missing version in $metadataPath.',
    );
  }
  final normalized = value.trim();
  if (_semVerPattern.hasMatch(normalized)) {
    return normalized;
  }
  throw _RegistryValidationError(
    'Component "$id" has invalid version "$value" in $metadataPath. '
    'Expected SemVer format such as 1.0.0 or 1.2.3-beta.1.',
  );
}

void main(List<String> args) {
  if (args.contains('-h') || args.contains('--help')) {
    _printUsage();
    return;
  }

  final parsed = _parseArgs(args);
  final force = parsed.hasFlag('force');
  final bumpManifest = parsed.hasFlag('bump-manifest-version');
  final setManifestRaw = parsed.getValue('set-manifest-version');

  int? setManifestVersion;
  if (setManifestRaw != null && setManifestRaw.isNotEmpty) {
    setManifestVersion = int.tryParse(setManifestRaw);
    if (setManifestVersion == null || setManifestVersion < 1) {
      stderr.writeln(
        'Error: --set-manifest-version must be a positive integer.',
      );
      exitCode = 2;
      return;
    }
  }

  final root = _findRepoRoot(Directory.current);
  if (root == null) {
    stderr.writeln(
      'Error: Could not locate lib/registry/manifests/components.json',
    );
    exitCode = 1;
    return;
  }

  final registryDir = Directory('${root.path}/lib/registry');
  final componentsJson = File('${registryDir.path}/manifests/components.json');
  if (!componentsJson.existsSync()) {
    stderr.writeln(
      'Error: components.json not found at ${componentsJson.path}',
    );
    exitCode = 1;
    return;
  }

  final registry = _readJson(componentsJson);
  final manifestVersion = _parseManifestVersion(registry['manifestVersion']);
  if (manifestVersion > 1 &&
      !force &&
      setManifestVersion == null &&
      !bumpManifest) {
    stderr.writeln(
      'Refusing to update manifest: manifestVersion is $manifestVersion. '
      'Use --bump-manifest-version, --set-manifest-version, or --force to override.',
    );
    exitCode = 2;
    return;
  }

  var nextManifestVersion = manifestVersion;
  if (setManifestVersion != null) {
    nextManifestVersion = setManifestVersion;
  } else if (bumpManifest) {
    nextManifestVersion = manifestVersion + 1;
  } else if (nextManifestVersion < 1) {
    nextManifestVersion = 1;
  }
  registry['manifestVersion'] = nextManifestVersion;

  final existingList = (registry['components'] as JsonList?) ?? <dynamic>[];
  final existingEntries = <String, JsonMap>{};
  for (final entry in existingList) {
    if (entry is Map && entry['id'] is String) {
      existingEntries[entry['id'] as String] = Map<String, dynamic>.from(entry);
    }
  }

  final updatedEntries = <String, JsonMap>{};
  final pendingMetaWrites = <_PendingMetaWrite>[];
  final updatedMetaFiles = <String>[];
  final missingMetaFiles = <String>[];
  final validationErrors = <String>[];

  for (final type in ['components', 'composites']) {
    final rootDir = Directory('${registryDir.path}/$type');
    if (!rootDir.existsSync()) continue;

    for (final categoryDir in rootDir.listSync().whereType<Directory>()) {
      for (final entryDir in categoryDir.listSync().whereType<Directory>()) {
        final name = _basename(entryDir.path);
        if (name.startsWith('_') || name.startsWith('.')) continue;

        final id = _basename(entryDir.path);
        final metadata = ComponentMetadataPaths(entryDir: entryDir, id: id);
        final meta = readJsonOrEmpty(
          canonical: metadata.canonicalMeta,
          legacy: metadata.legacyMeta,
        );
        if (!metadata.canonicalMeta.existsSync() &&
            !metadata.legacyMeta.existsSync()) {
          missingMetaFiles.add(metadata.canonicalMeta.path);
        }
        try {
          final updatedEntry = _buildEntry(
            registryDir: registryDir,
            entryDir: entryDir,
            type: type,
            meta: meta,
            existingEntry: existingEntries[id],
            metadataPath: metadata.canonicalMeta.path,
          );

          final fileList = listComponentSourceFilesRelative(entryDir);
          final category = _basename(entryDir.parent.path);
          final updatedMeta = _mergeMeta(
            id: id,
            category: category,
            meta: meta,
            existingEntry: existingEntries[id],
            fileList: fileList,
            metadataPath: metadata.canonicalMeta.path,
          );

          pendingMetaWrites.add(
            _PendingMetaWrite(
              metadata: metadata,
              originalMeta: meta,
              updatedMeta: updatedMeta,
            ),
          );
          updatedEntries[id] = updatedEntry;
        } on _RegistryValidationError catch (error) {
          validationErrors.add(error.message);
        }
      }
    }
  }

  if (validationErrors.isNotEmpty) {
    stderr.writeln('Registry validation failed:');
    for (final error in validationErrors) {
      stderr.writeln('  - $error');
    }
    exitCode = 2;
    return;
  }

  for (final pending in pendingMetaWrites) {
    if (!_deepEquals(pending.originalMeta, pending.updatedMeta)) {
      writeJsonMirrored(
        canonical: pending.metadata.canonicalMeta,
        legacy: pending.metadata.legacyMeta,
        data: pending.updatedMeta,
      );
      updatedMetaFiles.add(pending.metadata.canonicalMeta.path);
    } else {
      mirrorExistingFile(
        canonical: pending.metadata.canonicalMeta,
        legacy: pending.metadata.legacyMeta,
      );
    }
  }

  final updatedList = <JsonMap>[];
  final seen = <String>{};
  for (final entry in existingList) {
    if (entry is! Map || entry['id'] is! String) continue;
    final id = entry['id'] as String;
    final updated = updatedEntries[id];
    if (updated != null) {
      updatedList.add(updated);
      seen.add(id);
    }
  }

  final newEntries =
      updatedEntries.entries
          .where((entry) => !seen.contains(entry.key))
          .toList()
        ..sort((a, b) => a.key.compareTo(b.key));

  updatedList.addAll(newEntries.map((entry) => entry.value));

  final removedIds = existingEntries.keys
      .where((id) => !updatedEntries.containsKey(id))
      .toList();

  registry['components'] = updatedList;
  registry['shared'] = _updateSharedEntries(
    registryDir,
    registry['shared'] as List?,
  );

  _writeJson(componentsJson, registry);
  _writeRootBarrel(root);
  final docsSnapshots = <File>{
    File('${root.path}/docs/assets/registry/components.json'),
    File('${root.parent.path}/docs/assets/registry/components.json'),
  };
  for (final docsSnapshot in docsSnapshots) {
    if (!docsSnapshot.existsSync()) continue;
    _writeJson(docsSnapshot, registry);
  }

  if (!_syncDocsRegistryMirror(root)) {
    return;
  }

  stdout.writeln('Updated components.json.');
  stdout.writeln('Components: ${updatedEntries.length}.');
  stdout.writeln('Manifest version: ${registry['manifestVersion']}.');
  stdout.writeln('Meta files updated: ${updatedMetaFiles.length}.');
  if (missingMetaFiles.isNotEmpty) {
    stdout.writeln(
      'Missing component metadata files: ${missingMetaFiles.length}.',
    );
  }
  if (removedIds.isNotEmpty) {
    stdout.writeln('Removed stale component entries: ${removedIds.length}.');
  }
}
