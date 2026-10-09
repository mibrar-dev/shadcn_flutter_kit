// Scans one registry layer (foundation/theme/primitives) into unit ids and
// derives the primitive -> primitive dependency edges from real imports.

import 'dart:io';

import 'dart_imports.dart';
import 'manifest_error.dart';

/// One layer's files and unit id -> files mapping.
class LayerScan {
  LayerScan(this.root, this.layer, this.allFiles, this.units);

  /// Registry root (absolute).
  final String root;

  /// Layer name: `foundation`, `theme` or `primitives`.
  final String layer;

  /// All layer dart files, relative to [root], sorted.
  final List<String> allFiles;

  /// Unit id -> the exact files to copy for that unit, sorted.
  final Map<String, List<String>> units;
}

/// Scans `[root]/[layer]`; [declared] adds unit ids referenced by components.
LayerScan scanLayer(String root, String layer, Set<String> declared) {
  final dir = Directory('$root/$layer');
  if (!dir.existsSync()) {
    throw ManifestBuildException("layer directory '$layer' is missing");
  }
  final allFiles = <String>[];
  for (final entity in dir.listSync(recursive: true)) {
    if (entity is File && entity.path.endsWith('.dart')) {
      allFiles.add(entity.path.substring(root.length + 1));
    }
  }
  allFiles.sort();

  final ids = <String>{...declared};
  for (final file in allFiles) {
    final under = file.substring(layer.length + 1);
    final slash = under.indexOf('/');
    ids.add(
      slash == -1
          ? under.substring(0, under.length - 5)
          : under.substring(0, slash),
    );
  }

  final units = <String, List<String>>{};
  for (final id in ids.toList()..sort()) {
    final files = allFiles
        .where((file) => unitCovers(layer, id, file))
        .toList();
    if (files.isEmpty) {
      throw ManifestBuildException("layer '$layer' unit '$id' has no files");
    }
    units[id] = files;
  }
  return LayerScan(root, layer, allFiles, units);
}

/// Whether [id] (a file stem, folder name or nested stem) covers [relPath].
bool unitCovers(String layer, String id, String relPath) =>
    relPath == '$layer/$id.dart' || relPath.startsWith('$layer/$id/');

/// The primitive -> primitive edges, derived from real relative imports.
Map<String, List<String>> primitiveDeps(LayerScan primitives) {
  final deps = <String, Set<String>>{
    for (final id in primitives.units.keys) id: <String>{},
  };
  for (final entry in primitives.units.entries) {
    for (final file in entry.value) {
      final dir = file.substring(0, file.lastIndexOf('/'));
      for (final uri in directiveUris('${primitives.root}/$file')) {
        if (uri.startsWith('package:') || uri.startsWith('dart:')) {
          continue;
        }
        final target = _resolve(dir, uri);
        if (!target.endsWith('.dart') || !target.startsWith('primitives/')) {
          continue;
        }
        final targetId = _mostSpecificUnit(target, primitives.units.keys);
        if (targetId == null) {
          throw ManifestBuildException(
            "primitive import '$target' (from '$file') has no unit",
          );
        }
        if (targetId != entry.key) {
          deps[entry.key]!.add(targetId);
        }
      }
    }
  }
  return <String, List<String>>{
    for (final entry in deps.entries) entry.key: entry.value.toList()..sort(),
  };
}

String _resolve(String dir, String uri) {
  try {
    return normalizeRelPath('$dir/$uri');
  } on ArgumentError {
    throw ManifestBuildException("import '$uri' from '$dir' escapes the root");
  }
}

String? _mostSpecificUnit(String target, Iterable<String> ids) {
  String? best;
  for (final id in ids) {
    if (target == 'primitives/$id.dart' ||
        target.startsWith('primitives/$id/')) {
      if (best == null || id.length > best.length) {
        best = id;
      }
    }
  }
  return best;
}
