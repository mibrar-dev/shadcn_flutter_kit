// Registry scanning: file walking, component metadata, owner units and the
// manifest based shared-id -> file mapping used by check_layers.

import 'dart:convert';
import 'dart:io';

import 'package:analyzer/dart/ast/ast.dart';

import 'dart_parse.dart';
import 'manifests.dart';
import 'path_utils.dart';

/// A component directory that contains a `meta.json`.
class ComponentInfo {
  ComponentInfo({
    required this.id,
    required this.dir,
    required this.relDir,
    required this.dirName,
    required this.meta,
    required this.entryRelPath,
  });

  /// Component id from `meta.json` (`dependencies.components` uses these).
  final String id;

  /// Absolute component directory.
  final String dir;

  /// Component directory relative to the scan root.
  final String relDir;

  /// Directory name on disk (may differ from [id], e.g. `sortable` vs
  /// `form_sortable`).
  final String dirName;

  /// Raw `meta.json` content.
  final Map<String, dynamic> meta;

  /// Entry file (`<id>.dart`, `<dir>.dart`, or the single top-level dart file)
  /// relative to the scan root, or null when the component has none.
  final String? entryRelPath;

  /// Ids declared in `dependencies.components`.
  List<String> get componentDeps {
    final deps = meta['dependencies'];
    if (deps is! Map) {
      return const <String>[];
    }
    final list = deps['components'];
    return list is List ? list.whereType<String>().toList() : const <String>[];
  }

  /// Ids declared in `dependencies.shared`.
  List<String> get sharedDeps {
    final deps = meta['dependencies'];
    if (deps is! Map) {
      return const <String>[];
    }
    final list = deps['shared'];
    return list is List ? list.whereType<String>().toList() : const <String>[];
  }
}

/// The unit that owns a declaration for the single-owner rule.
class OwnerUnit {
  const OwnerUnit(this.label, this.kind, {this.component});

  /// Display label, e.g. `button` or `shared/primitives/clickable`.
  final String label;

  /// One of `component`, `shared`, `unknown`.
  final String kind;

  /// Set when [kind] is `component`.
  final ComponentInfo? component;

  @override
  String toString() => label;
}

/// Everything the guardrail scripts need to know about a registry tree.
class RegistryScan {
  RegistryScan._({
    required this.root,
    required this.skipGenerated,
    required this.dartFiles,
    required this.components,
    required Map<String, ComponentInfo> componentByDir,
    required Map<String, Set<String>> sharedIdsByRelPath,
  }) : _componentByDir = componentByDir,
       _sharedIdsByRelPath = sharedIdsByRelPath;

  /// Absolute scan root (normally `lib/registry`).
  final String root;

  /// Whether `shared/theme/generated/**` files were skipped.
  final bool skipGenerated;

  /// Absolute paths of every scanned Dart file, sorted.
  final List<String> dartFiles;

  /// Components sorted by directory.
  final List<ComponentInfo> components;

  final Map<String, ComponentInfo> _componentByDir;
  final Map<String, Set<String>> _sharedIdsByRelPath;
  final Map<String, String> _nearestComponentCache = {};
  final Map<String, Map<String, String>> _groupExportOwners = {};

  /// Loads the registry tree rooted at [root].
  static RegistryScan load(String root, {bool skipGenerated = true}) {
    final absoluteRoot = normalizePath(File(root).absolute.path);
    final dartFiles = <String>[];
    final components = <ComponentInfo>[];
    final componentByDir = <String, ComponentInfo>{};

    final entities = Directory(
      absoluteRoot,
    ).listSync(recursive: true, followLinks: false);
    for (final entity in entities) {
      final absPath = normalizePath(entity.path);
      final relPath = relativePath(absPath, absoluteRoot);
      if (entity is! File) {
        continue;
      }
      if (baseName(absPath) == 'meta.json' && relPath != 'meta.json') {
        final component = _loadComponent(absPath, relPath, absoluteRoot);
        components.add(component);
        componentByDir[component.dir] = component;
        continue;
      }
      if (!absPath.endsWith('.dart')) {
        continue;
      }
      if (skipGenerated && relPath.startsWith('shared/theme/generated/')) {
        continue;
      }
      dartFiles.add(absPath);
    }
    dartFiles.sort();
    components.sort((a, b) => a.relDir.compareTo(b.relDir));

    final scan = RegistryScan._(
      root: absoluteRoot,
      skipGenerated: skipGenerated,
      dartFiles: dartFiles,
      components: components,
      componentByDir: componentByDir,
      sharedIdsByRelPath: loadSharedIdsByRelPath(absoluteRoot),
    );
    return scan;
  }

  /// Path of [absPath] relative to the scan root.
  String relPathOf(String absPath) => relativePath(absPath, root);

  /// Whether [relPath] (relative to the root) exists as a file.
  bool fileExists(String relPath) => File(joinPath(root, relPath)).existsSync();

  /// The nearest component owning [absPath], or null.
  ComponentInfo? componentFor(String absPath) {
    var dir = dirName(absPath);
    final checked = <String>[];
    ComponentInfo? found;
    while (true) {
      if (!isWithin(dir, root)) {
        break;
      }
      final cached = _nearestComponentCache[dir];
      if (cached != null) {
        found = cached.isEmpty ? null : _componentByDir[cached];
        break;
      }
      checked.add(dir);
      final component = _componentByDir[dir];
      if (component != null) {
        found = component;
        break;
      }
      if (dir == root) {
        break;
      }
      dir = dirName(dir);
    }
    for (final dir in checked) {
      _nearestComponentCache[dir] = found?.dir ?? '';
    }
    return found;
  }

  /// The owner unit of [absPath].
  ///
  /// Component files belong to their nearest ancestor with `meta.json`.
  /// Shared files belong to `shared/<group>/<file-stem>`; files under
  /// `_impl/` are attributed to the shared group's owning entry file when one
  /// can be determined (same stem at the group root, or an entry file that
  /// exports the `_impl` file), otherwise `UNKNOWN`.
  OwnerUnit ownerOf(String absPath) {
    final component = componentFor(absPath);
    if (component != null) {
      return OwnerUnit(component.id, 'component', component: component);
    }
    final relPath = relPathOf(absPath);
    if (relPath.startsWith('shared/')) {
      final segments = relPath.split('/');
      if (segments.length >= 3) {
        final group = segments[1];
        final stem = stemOf(relPath);
        if (segments.contains('_impl')) {
          final entryRelPath = 'shared/$group/$stem.dart';
          if (fileExists(entryRelPath)) {
            return OwnerUnit('shared/$group/$stem', 'shared');
          }
          final exportOwners = _entryOwnersForGroup(group);
          final owner = exportOwners[relPath];
          if (owner != null) {
            return OwnerUnit(owner, 'shared');
          }
          return const OwnerUnit('UNKNOWN', 'unknown');
        }
        return OwnerUnit('shared/$group/$stem', 'shared');
      }
      return OwnerUnit('shared/${stemOf(relPath)}', 'shared');
    }
    return const OwnerUnit('UNKNOWN', 'unknown');
  }

  /// Shared ids that cover [relPath] (relative to the root).
  Set<String> sharedIdsForRelPath(String relPath) =>
      _sharedIdsByRelPath[normalizePath(relPath)] ?? const <String>{};

  /// Resolves a directive URI to a path relative to the scan root.
  ///
  /// Handles relative references with and without a leading `./` (the
  /// registry uses both styles), the package's own `package:` URIs, and
  /// returns null for `dart:`, foreign packages and targets outside the root.
  String? resolveUri(String importerAbsPath, String uri) {
    if (uri.startsWith('dart:')) {
      return null;
    }
    if (uri.startsWith('package:')) {
      const selfPrefix = 'package:flutter_shadcn_kit/';
      if (!uri.startsWith(selfPrefix)) {
        return null;
      }
      final rest = uri.substring(selfPrefix.length);
      if (rest.startsWith('registry/')) {
        return rest.substring('registry/'.length);
      }
      return null;
    }
    if (uri.contains(':') || uri.startsWith('/')) {
      // Other schemes (http, file, ...) and absolute file paths.
      return null;
    }
    final target = normalizePath(joinPath(dirName(importerAbsPath), uri));
    if (!isWithin(target, root)) {
      return null;
    }
    return relPathOf(target);
  }

  static ComponentInfo _loadComponent(
    String metaPath,
    String relPath,
    String root,
  ) {
    final dir = dirName(metaPath);
    final meta = (jsonDecode(File(metaPath).readAsStringSync()) as Map)
        .cast<String, dynamic>();
    final id = meta['id'] is String && (meta['id'] as String).isNotEmpty
        ? meta['id'] as String
        : baseName(dir);
    final entryAbsPath = _resolveEntry(dir, id, meta);
    return ComponentInfo(
      id: id,
      dir: dir,
      relDir: relativePath(dir, root),
      dirName: baseName(dir),
      meta: meta,
      entryRelPath: entryAbsPath == null
          ? null
          : relativePath(entryAbsPath, root),
    );
  }

  static String? _resolveEntry(
    String dir,
    String id,
    Map<String, dynamic> meta,
  ) {
    final candidates = <String>['$id.dart', '${baseName(dir)}.dart'];
    for (final candidate in candidates) {
      final file = File(joinPath(dir, candidate));
      if (file.existsSync()) {
        return file.path;
      }
    }
    final listed = meta['files'];
    if (listed is List) {
      final topLevel = listed
          .whereType<String>()
          .where((file) => !file.contains('/'))
          .where((file) => file.endsWith('.dart'))
          .where((file) => file != 'preview.dart')
          .toList();
      for (final candidate in topLevel) {
        final file = File(joinPath(dir, candidate));
        if (file.existsSync()) {
          return file.path;
        }
      }
    }
    final onDisk = Directory(dir)
        .listSync()
        .whereType<File>()
        .map((file) => baseName(file.path))
        .where((name) => name.endsWith('.dart') && name != 'preview.dart')
        .toList();
    if (onDisk.length == 1) {
      return joinPath(dir, onDisk.single);
    }
    return null;
  }

  Map<String, String> _entryOwnersForGroup(String group) {
    final cached = _groupExportOwners[group];
    if (cached != null) {
      return cached;
    }
    final owners = <String, String>{};
    final groupRel = 'shared/$group';
    final groupAbs = joinPath(root, groupRel);
    if (!Directory(groupAbs).existsSync()) {
      _groupExportOwners[group] = owners;
      return owners;
    }
    final entries =
        Directory(groupAbs)
            .listSync()
            .whereType<File>()
            .where(
              (file) =>
                  file.path.endsWith('.dart') && dirName(file.path) == groupAbs,
            )
            .toList()
          ..sort((a, b) => a.path.compareTo(b.path));
    for (final entry in entries) {
      final entryStem = stemOf(entry.path);
      ParsedDartFile parsed;
      try {
        parsed = parseDartFile(entry.path, relativePath(entry.path, root));
      } on FileSystemException {
        continue;
      }
      for (final directive in parsed.unit.directives) {
        if (directive is! ExportDirective) {
          continue;
        }
        final uri = directive.uri.stringValue;
        if (uri == null) {
          continue;
        }
        final targetRel = resolveUri(entry.path, uri);
        if (targetRel != null && targetRel.startsWith('$groupRel/')) {
          owners.putIfAbsent(targetRel, () => 'shared/$group/$entryStem');
        }
      }
    }
    _groupExportOwners[group] = owners;
    return owners;
  }
}
