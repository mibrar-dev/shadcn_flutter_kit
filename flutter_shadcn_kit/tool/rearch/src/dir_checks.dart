// Directory-level findings: `installable` and `no-impl-dir`.
//
// These rules inspect the component directories themselves instead of the
// parsed Dart files, so they live outside the per-file checks.

import 'dart:convert';
import 'dart:io';

import 'layer_checks.dart';
import 'path_utils.dart';
import 'registry_scan.dart';

/// Directories that should be installable components.
///
/// New layout: every directory directly under `components/`.
/// Legacy layout: every directory one level below a category folder, i.e.
/// `components/<category>/<name>`.
List<Directory> _componentDirs(String root, {required bool newLayout}) {
  final componentsDir = Directory(joinPath(root, 'components'));
  if (!componentsDir.existsSync()) {
    return const <Directory>[];
  }
  final dirs = <Directory>[];
  for (final entity in componentsDir.listSync(followLinks: false)) {
    if (entity is! Directory) {
      continue;
    }
    if (newLayout) {
      dirs.add(entity);
    } else {
      for (final child in entity.listSync(followLinks: false)) {
        if (child is Directory) {
          dirs.add(child);
        }
      }
    }
  }
  dirs.sort((a, b) => a.path.compareTo(b.path));
  return dirs;
}

/// `installable` rule: every component directory is self-contained.
///
/// Per component it requires a `meta.json`, `meta['id']` equal to the
/// directory name, an entry file `<dir>.dart`, and every path listed in
/// `meta['files']` (when present) to exist on disk.
List<LayerFinding> installableFindings(
  RegistryScan scan, {
  required bool newLayout,
}) {
  final findings = <LayerFinding>[];
  for (final dir in _componentDirs(scan.root, newLayout: newLayout)) {
    final relDir = relativePath(dir.path, scan.root);
    final dirNameOnDisk = baseName(relDir);
    final metaFile = File(joinPath(dir.path, 'meta.json'));
    if (!metaFile.existsSync()) {
      findings.add(
        LayerFinding(
          rule: 'installable',
          file: relDir,
          line: 0,
          message: 'missing meta.json',
        ),
      );
      continue;
    }
    final Map<String, dynamic> meta;
    try {
      meta = (jsonDecode(metaFile.readAsStringSync()) as Map)
          .cast<String, dynamic>();
    } on FormatException {
      findings.add(
        LayerFinding(
          rule: 'installable',
          file: '$relDir/meta.json',
          line: 0,
          message: 'meta.json is not valid JSON',
        ),
      );
      continue;
    }
    final id = meta['id'];
    if (id is String && id != dirNameOnDisk) {
      findings.add(
        LayerFinding(
          rule: 'installable',
          file: '$relDir/meta.json',
          line: 0,
          message: "id '$id' does not match directory name '$dirNameOnDisk'",
        ),
      );
    }
    final entry = File(joinPath(dir.path, '$dirNameOnDisk.dart'));
    if (!entry.existsSync()) {
      findings.add(
        LayerFinding(
          rule: 'installable',
          file: relDir,
          line: 0,
          message: "missing entry file '$dirNameOnDisk.dart'",
        ),
      );
    }
    final listed = meta['files'];
    if (listed is List) {
      for (final item in listed) {
        if (item is! String) {
          continue;
        }
        if (!File(joinPath(dir.path, item)).existsSync()) {
          findings.add(
            LayerFinding(
              rule: 'installable',
              file: '$relDir/meta.json',
              line: 0,
              message: "listed file '$item' does not exist",
            ),
          );
        }
      }
    }
  }
  return findings;
}

/// `no-impl-dir` rule: the new tree forbids `_impl/` directories under
/// `components/`.
List<LayerFinding> noImplDirFindings(RegistryScan scan) {
  final findings = <LayerFinding>[];
  final componentsDir = Directory(joinPath(scan.root, 'components'));
  if (!componentsDir.existsSync()) {
    return findings;
  }
  for (final entity in componentsDir.listSync(recursive: true)) {
    if (entity is Directory && baseName(entity.path) == '_impl') {
      findings.add(
        LayerFinding(
          rule: 'no-impl-dir',
          file: relativePath(entity.path, scan.root),
          line: 0,
          message: '_impl/ directories are not allowed in the new layout',
        ),
      );
    }
  }
  findings.sort((a, b) => a.file.compareTo(b.file));
  return findings;
}
