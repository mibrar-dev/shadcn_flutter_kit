import 'dart:convert';
import 'dart:io';

import '../common/registry_component_metadata.dart';

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

class _ParsedArgs {
  _ParsedArgs(this.values, this.flags);

  final Map<String, List<String>> values;
  final Set<String> flags;

  bool hasFlag(String name) => flags.contains(name);
  List<String> getValues(String name) => values[name] ?? const [];
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

List<String> _parseCsvValues(List<String> values) {
  final output = <String>[];
  for (final value in values) {
    final parts = value.split(',');
    for (final part in parts) {
      final trimmed = part.trim();
      if (trimmed.isEmpty) continue;
      output.add(trimmed);
    }
  }
  return output;
}

Map<String, String> _parseComponentVersionOverrides(List<String> values) {
  final overrides = <String, String>{};
  for (final raw in values) {
    final cleaned = raw.trim();
    if (cleaned.isEmpty) continue;
    final separator = cleaned.contains('=')
        ? '='
        : (cleaned.contains(':') ? ':' : '');
    if (separator.isEmpty) continue;
    final parts = cleaned.split(separator);
    if (parts.length < 2) continue;
    final id = parts.first.trim();
    final version = parts.sublist(1).join(separator).trim();
    if (id.isEmpty || version.isEmpty) continue;
    overrides[id] = version;
  }
  return overrides;
}

void _printUsage() {
  stdout.writeln(
    'Usage: dart run tool/registry/registry_meta_update.dart [options]',
  );
  stdout.writeln('');
  stdout.writeln('Updates existing component meta.json files with:');
  stdout.writeln('  - files list');
  stdout.writeln('  - dependencies (from existing meta + components.json)');
  stdout.writeln('  - api section (copied from {id}.meta.json when present)');
  stdout.writeln('  - version (must already exist or be set explicitly)');
  stdout.writeln('');
  stdout.writeln('Options:');
  stdout.writeln(
    '  --components <ids>           Comma-separated component ids to update.',
  );
  stdout.writeln(
    '  --set-component-version <v>  Set version for all targeted components.',
  );
  stdout.writeln(
    '  --component-version <id=v>   Set version for a specific component (repeatable).',
  );
  stdout.writeln('  -h, --help                   Show this help.');
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
  String? versionOverride,
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
    value: versionOverride ?? meta['version'],
    metadataPath: versionOverride == null ? metadataPath : 'CLI override',
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
  final componentTargets = _parseCsvValues(
    parsed.getValues('components'),
  ).toSet();
  final componentVersionOverrides = _parseComponentVersionOverrides(
    parsed.getValues('component-version'),
  );
  componentTargets.addAll(componentVersionOverrides.keys);
  final componentVersionAll = parsed.getValue('set-component-version');
  final defaultVersion = parsed.getValue('default-version');
  if (defaultVersion != null) {
    stderr.writeln(
      'Error: --default-version is no longer supported. '
      'Set version in meta.json or use --set-component-version/--component-version.',
    );
    exitCode = 2;
    return;
  }
  final filterEnabled = componentTargets.isNotEmpty;

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
  final existingList = (registry['components'] as JsonList?) ?? <dynamic>[];
  final existingEntries = <String, JsonMap>{};
  for (final entry in existingList) {
    if (entry is Map && entry['id'] is String) {
      existingEntries[entry['id'] as String] = Map<String, dynamic>.from(entry);
    }
  }

  final updatedMetaFiles = <String>[];
  final pendingMetaWrites = <_PendingMetaWrite>[];
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
        if (filterEnabled && !componentTargets.contains(id)) {
          continue;
        }
        final category = _basename(entryDir.parent.path);
        final fileList = listComponentSourceFilesRelative(entryDir);
        final overrideVersion =
            componentVersionOverrides[id] ?? componentVersionAll;

        try {
          final updatedMeta = _mergeMeta(
            id: id,
            category: category,
            meta: meta,
            existingEntry: existingEntries[id],
            fileList: fileList,
            metadataPath: metadata.canonicalMeta.path,
            versionOverride: overrideVersion,
          );

          final readmeMetaFile = preferredFile(
            canonical: metadata.canonicalReadmeMeta,
            legacy: metadata.legacyReadmeMeta,
          );
          if (readmeMetaFile.existsSync()) {
            final readmeMeta = _readJson(readmeMetaFile);
            if (readmeMeta['api'] != null) {
              updatedMeta['api'] = readmeMeta['api'];
            }
          }

          pendingMetaWrites.add(
            _PendingMetaWrite(
              metadata: metadata,
              originalMeta: meta,
              updatedMeta: updatedMeta,
            ),
          );
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

  final docsRegistryRoot = findSiblingDocsRegistryRoot(root);
  if (docsRegistryRoot != null) {
    syncDocsRegistryMetadata(
      registryDir: registryDir,
      docsRegistryRoot: docsRegistryRoot,
    );
  }

  stdout.writeln('Meta generation complete.');
  stdout.writeln('Meta files updated: ${updatedMetaFiles.length}.');
  if (filterEnabled) {
    stdout.writeln('Filtered update: ${componentTargets.toList()..sort()}');
  }
  if (missingMetaFiles.isNotEmpty) {
    stdout.writeln(
      'Missing component metadata files: ${missingMetaFiles.length}.',
    );
  }
}
