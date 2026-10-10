// Builds lib/registry/manifests/registry.json (schemaVersion 2) from the
// post-cutover flat registry tree.
//
// Data sources:
//   * components/<id>/meta.json — identity, deps, api, theme, files;
//   * foundation/, theme/, primitives/ — unit file sets and primitive deps
//     (derived from real relative imports; layers have no meta.json);
//   * themes/*.json — presets;
//   * pubspec.yaml — registry version and package constraints.
//
// The output is deterministic: no timestamps, keys sorted recursively. The
// contract is rearch/reports/registry_manifest.v2.schema.json (P5-A) and
// rearch/reports/P5_CLI_PLAN.md section 9.

import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:yaml/yaml.dart';

import '../../rearch/src/json_utils.dart';
import 'dart_imports.dart';
import 'layer_scan.dart';
import 'manifest_error.dart';

/// Builds the manifest JSON for the registry at [appRoot] (the
/// flutter_shadcn_kit package root). Throws [ManifestBuildException] on any
/// tree inconsistency; the caller writes or diffs the result.
String buildRegistryManifest(String appRoot) {
  return stableJsonEncode(_Builder(appRoot).build());
}

/// A component directory as read from its meta.json.
class _Component {
  _Component({
    required this.id,
    required this.meta,
    required this.metaFiles,
    required this.userTheme,
    required this.preview,
  });

  final String id;
  final Map<String, dynamic> meta;
  final List<String> metaFiles;

  /// `<id>_theme.dart` when the file exists in the directory.
  final String? userTheme;

  /// `preview.dart` when listed in meta files.
  final String? preview;

  Map<String, dynamic> get deps => meta['deps'] as Map<String, dynamic>;
}

class _Builder {
  _Builder(this.appRoot) : root = '$appRoot/lib/registry';

  final String appRoot;
  final String root;

  late final YamlMap _pubspec =
      loadYaml(File('$appRoot/pubspec.yaml').readAsStringSync()) as YamlMap;

  /// pubspec dependency name -> version constraint (sdk deps excluded).
  Map<String, String> get constraints {
    final result = <String, String>{};
    final deps = _pubspec['dependencies'];
    if (deps is YamlMap) {
      for (final entry in deps.entries) {
        final value = entry.value;
        if (value is String) {
          result[entry.key as String] = value;
        }
      }
    }
    return result;
  }

  Map<String, Object?> build() {
    final components = _readComponents();
    final declared = _declaredLayerIds(components);
    final foundation = scanLayer(root, 'foundation', declared['foundation']!);
    final theme = scanLayer(root, 'theme', declared['theme']!);
    final primitives = scanLayer(root, 'primitives', declared['primitives']!);
    _validateComponentDeps(components, foundation, theme, primitives);

    final deps = primitiveDeps(primitives);
    final hashes = <String, String>{};

    final componentJson = <String, Object?>{};
    for (final id in components.keys.toList()..sort()) {
      componentJson[id] = _componentJson(components[id]!, hashes);
    }
    // Theme presets are hashed too: `themes/<id>.json` is the input the CLI
    // renders into `<installRoot>/theme/app_theme.dart`, so a consumer that
    // caches or diffs the generated file needs the preset digest to tell "the
    // preset changed" from "only the theme selection changed".
    final themesJson = _themesJson();
    for (final preset in themesJson.values) {
      hashes[(preset as Map<String, Object?>)['file']! as String] = _sha256(
        (preset['file']! as String),
      );
    }
    for (final file in <String>[
      ...foundation.allFiles,
      ...theme.allFiles,
      ...primitives.allFiles,
    ]) {
      hashes[file] = _sha256(file);
    }

    return <String, Object?>{
      'schemaVersion': 2,
      'registry': <String, Object?>{
        'name': 'shadcn_flutter',
        'version': _pubspec['version'] as String,
      },
      'install': <String, Object?>{
        'root': 'lib/ui/shadcn',
        'componentsDir': 'components',
        'layerDirs': <String, Object?>{
          'foundation': 'foundation',
          'theme': 'theme',
          'primitives': 'primitives',
        },
        'userOwnedSuffix': '_theme.dart',
      },
      'foundation': _unitsJson(foundation),
      'theme': _unitsJson(theme),
      'primitives': _primitivesJson(primitives, deps),
      'components': componentJson,
      'themes': themesJson,
      'fileHashes': hashes,
    };
  }

  String _sha256(String relPath) =>
      sha256.convert(File('$root/$relPath').readAsBytesSync()).toString();

  Map<String, _Component> _readComponents() {
    final components = <String, _Component>{};
    for (final entity in Directory('$root/components').listSync()) {
      if (entity is! Directory) continue;
      final id = _baseName(entity.path);
      final metaFile = File('${entity.path}/meta.json');
      if (!metaFile.existsSync()) {
        throw ManifestBuildException("component '$id' has no meta.json");
      }
      final meta =
          jsonDecode(metaFile.readAsStringSync()) as Map<String, dynamic>;
      if (meta['id'] != id) {
        throw ManifestBuildException(
          "component '$id' meta.id is '${meta['id']}'",
        );
      }
      final files = meta['files'];
      if (files is! List) {
        throw ManifestBuildException("component '$id' has no files list");
      }
      final metaFiles = files.whereType<String>().toList();
      components[id] = _Component(
        id: id,
        meta: meta,
        metaFiles: metaFiles,
        userTheme: File('${entity.path}/${id}_theme.dart').existsSync()
            ? '${id}_theme.dart'
            : null,
        preview: metaFiles.contains('preview.dart') ? 'preview.dart' : null,
      );
    }
    return components;
  }

  Map<String, Set<String>> _declaredLayerIds(
    Map<String, _Component> components,
  ) {
    final declared = <String, Set<String>>{
      'foundation': <String>{},
      'theme': <String>{},
      'primitives': <String>{},
    };
    for (final component in components.values) {
      for (final layer in declared.keys) {
        final list = component.deps[layer];
        if (list is! List) {
          throw ManifestBuildException(
            "component '${component.id}' deps.$layer is missing",
          );
        }
        declared[layer]!.addAll(list.whereType<String>());
      }
    }
    return declared;
  }

  void _validateComponentDeps(
    Map<String, _Component> components,
    LayerScan foundation,
    LayerScan theme,
    LayerScan primitives,
  ) {
    const expectedKeys = <String>{
      'foundation',
      'theme',
      'primitives',
      'components',
    };
    for (final component in components.values) {
      final deps = component.deps;
      if (deps.length != expectedKeys.length ||
          !expectedKeys.every(deps.containsKey)) {
        throw ManifestBuildException(
          "component '${component.id}' deps must have exactly "
          'foundation, theme, primitives, components',
        );
      }
      _checkLayerDeps(component, 'foundation', foundation.units.keys.toSet());
      _checkLayerDeps(component, 'theme', theme.units.keys.toSet());
      _checkLayerDeps(component, 'primitives', primitives.units.keys.toSet());
      for (final entry in (deps['components'] as List).whereType<String>()) {
        if (!components.containsKey(entry)) {
          throw ManifestBuildException(
            "component '${component.id}' deps.components '$entry' does not exist",
          );
        }
        if (entry == component.id) {
          throw ManifestBuildException(
            "component '${component.id}' depends on itself",
          );
        }
      }
      final entryFile = '$root/components/${component.id}/${component.id}.dart';
      if (!File(entryFile).existsSync()) {
        throw ManifestBuildException(
          "component '${component.id}' has no entry file",
        );
      }
      if (!component.metaFiles.contains('${component.id}.dart')) {
        throw ManifestBuildException(
          "component '${component.id}' files list misses '${component.id}.dart'",
        );
      }
      for (final file in component.metaFiles) {
        if (!File('$root/components/${component.id}/$file').existsSync()) {
          throw ManifestBuildException(
            "component '${component.id}' files entry '$file' does not exist",
          );
        }
      }
      final import = component.meta['import'];
      if (import is! String ||
          !import.contains('/ui/shadcn/components/${component.id}/')) {
        throw ManifestBuildException(
          "component '${component.id}' meta import must use "
          'ui/shadcn/components/<id>/',
        );
      }
    }
  }

  void _checkLayerDeps(
    _Component component,
    String layer,
    Set<String> unitIds,
  ) {
    for (final entry in (component.deps[layer] as List).whereType<String>()) {
      if (!unitIds.contains(entry)) {
        throw ManifestBuildException(
          "component '${component.id}' deps.$layer entry '$entry' does not exist",
        );
      }
    }
  }

  Map<String, Object?> _unitsJson(LayerScan scan) {
    final json = <String, Object?>{};
    for (final id in scan.units.keys.toList()..sort()) {
      final files = scan.units[id]!;
      final entry = <String, Object?>{'files': files};
      final packages = _packagesFor(files);
      if (packages.isNotEmpty) {
        entry['packages'] = packages;
      }
      json[id] = entry;
    }
    return json;
  }

  Map<String, Object?> _primitivesJson(
    LayerScan scan,
    Map<String, List<String>> deps,
  ) {
    final json = <String, Object?>{};
    for (final id in scan.units.keys.toList()..sort()) {
      final files = scan.units[id]!;
      final entry = <String, Object?>{
        'files': files,
        'deps': <String, Object?>{'primitives': deps[id]},
      };
      final packages = _packagesFor(files);
      if (packages.isNotEmpty) {
        entry['packages'] = packages;
      }
      json[id] = entry;
    }
    return json;
  }

  Map<String, Object?> _componentJson(
    _Component component,
    Map<String, String> hashes,
  ) {
    final id = component.id;
    final userOwned = component.userTheme == null
        ? <String>[]
        : <String>['components/$id/${component.userTheme}'];
    final files = <String>[
      for (final file in component.metaFiles)
        if (file != 'preview.dart' && file != component.userTheme)
          'components/$id/$file',
    ]..sort();
    final json = <String, Object?>{
      'name': component.meta['name'],
      'category': component.meta['category'],
      'description': component.meta['description'] ?? '',
      'entry': 'components/$id/$id.dart',
      'files': files,
      'userOwned': userOwned,
      'deps': component.meta['deps'],
      'tags': component.meta['tags'] ?? const <String>[],
      'listed': component.meta['listed'] != false,
      'api': component.meta['api'] ?? const <String, Object?>{},
      'install': component.meta['install'],
      'import': component.meta['import'],
    };
    if (component.meta['theme'] != null) {
      json['theme'] = component.meta['theme'];
    }
    final packages = _packagesFor(<String>[
      for (final file in component.metaFiles) 'components/$id/$file',
    ]);
    if (packages.isNotEmpty) {
      json['packages'] = packages;
    }
    for (final file in files) {
      hashes[file] = _sha256(file);
    }
    for (final file in userOwned) {
      hashes[file] = _sha256(file);
    }
    if (component.preview != null) {
      final preview = 'components/$id/${component.preview}';
      hashes[preview] = _sha256(preview);
    }
    return json;
  }

  Map<String, Object?> _themesJson() {
    final dir = Directory('$root/themes');
    if (!dir.existsSync()) {
      throw ManifestBuildException('themes directory is missing');
    }
    final files =
        dir
            .listSync()
            .whereType<File>()
            .where((file) => file.path.endsWith('.json'))
            .toList()
          ..sort((a, b) => a.path.compareTo(b.path));
    final json = <String, Object?>{};
    for (final file in files) {
      final name = _baseName(file.path);
      if (name == 'index.json' || name == 'themes.schema.json') {
        continue;
      }
      final data = jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
      final id = data['id'];
      final presetName = data['name'];
      if (id is! String || '$id.json' != name) {
        throw ManifestBuildException("theme '$name' has a mismatched id '$id'");
      }
      if (presetName is! String || presetName.isEmpty) {
        throw ManifestBuildException("theme '$name' has no name");
      }
      if (data['light'] is! Map || data['dark'] is! Map) {
        throw ManifestBuildException(
          "theme '$name' must define light and dark",
        );
      }
      json[id] = <String, Object?>{
        'file': 'themes/$name',
        'name': presetName,
        'modes': <String>['light', 'dark'],
      };
    }
    return json;
  }

  List<Map<String, Object?>> _packagesFor(List<String> relFiles) {
    final names = <String>{};
    for (final file in relFiles) {
      for (final uri in directiveUris('$root/$file')) {
        if (!uri.startsWith('package:')) continue;
        final name = uri.substring('package:'.length).split('/').first;
        if (name == 'flutter' || name == 'flutter_shadcn_kit') continue;
        names.add(name);
      }
    }
    final entries = <Map<String, Object?>>[];
    for (final name in names.toList()..sort()) {
      if (name == 'flutter_localizations') {
        entries.add(<String, Object?>{'name': name, 'sdk': true});
        continue;
      }
      final constraint = constraints[name];
      if (constraint == null) {
        throw ManifestBuildException(
          "package '$name' is imported but has no pubspec constraint",
        );
      }
      entries.add(<String, Object?>{'name': name, 'constraint': constraint});
    }
    return entries;
  }
}

String _baseName(String path) => path.split(Platform.pathSeparator).last;
