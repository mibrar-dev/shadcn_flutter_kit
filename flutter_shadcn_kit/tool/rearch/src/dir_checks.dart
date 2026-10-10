// Directory-level findings: `installable`, `block-installable` and
// `no-impl-dir`.
//
// These rules inspect the component directories themselves instead of the
// parsed Dart files, so they live outside the per-file checks.

import 'dart:convert';
import 'dart:io';

import '../../registry/src/categories.dart';
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

/// Dart file name of a block id: `dashboard-01` lives in `dashboard_01.dart`,
/// because Dart file names must satisfy the `file_names` lint.
String blockStemOf(String id) => id.replaceAll('-', '_');

/// `block-installable` rule: every block directory is self-contained.
///
/// Per block it requires a `meta.json`, `meta['id']` equal to the directory
/// name, a `README.md`, a `category` and a `viewport` from the P6-B1
/// taxonomies, the entry file `<underscored id>.dart`, every path listed in
/// `meta['files']` to exist on disk, and every Dart file to stay inside the
/// 400-line budget.
List<LayerFinding> blockInstallableFindings(RegistryScan scan) {
  final findings = <LayerFinding>[];
  final blocksDir = Directory(joinPath(scan.root, 'blocks'));
  if (!blocksDir.existsSync()) {
    return findings;
  }
  for (final entity
      in blocksDir.listSync().toList()
        ..sort((a, b) => a.path.compareTo(b.path))) {
    if (entity is! Directory) continue;
    final relDir = relativePath(entity.path, scan.root);
    final id = baseName(relDir);
    final metaFile = File(joinPath(entity.path, 'meta.json'));
    if (!metaFile.existsSync()) {
      findings.add(
        LayerFinding(
          rule: 'block-installable',
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
          rule: 'block-installable',
          file: '$relDir/meta.json',
          line: 0,
          message: 'meta.json is not valid JSON',
        ),
      );
      continue;
    }
    if (meta['id'] is String && meta['id'] != id) {
      findings.add(
        LayerFinding(
          rule: 'block-installable',
          file: '$relDir/meta.json',
          line: 0,
          message: "id '${meta['id']}' does not match directory name '$id'",
        ),
      );
    }
    if (!File(joinPath(entity.path, 'README.md')).existsSync()) {
      findings.add(
        LayerFinding(
          rule: 'block-installable',
          file: relDir,
          line: 0,
          message: 'missing README.md',
        ),
      );
    }
    final category = meta['category'];
    if (category is! String || !isBlockCategory(category)) {
      findings.add(
        LayerFinding(
          rule: 'block-installable',
          file: '$relDir/meta.json',
          line: 0,
          message:
              "category '$category' is not a block category "
              '(${blockCategories.join(', ')})',
        ),
      );
    }
    final viewport = meta['viewport'];
    if (viewport is! String || !blockViewports.contains(viewport)) {
      findings.add(
        LayerFinding(
          rule: 'block-installable',
          file: '$relDir/meta.json',
          line: 0,
          message:
              "viewport '$viewport' is not one of "
              '${blockViewports.join(', ')}',
        ),
      );
    }
    final entry = File(joinPath(entity.path, '${blockStemOf(id)}.dart'));
    if (!entry.existsSync()) {
      findings.add(
        LayerFinding(
          rule: 'block-installable',
          file: relDir,
          line: 0,
          message: "missing entry file '${blockStemOf(id)}.dart'",
        ),
      );
    }
    final listed = meta['files'];
    if (listed is List) {
      for (final item in listed) {
        if (item is! String) continue;
        if (!File(joinPath(entity.path, item)).existsSync()) {
          findings.add(
            LayerFinding(
              rule: 'block-installable',
              file: '$relDir/meta.json',
              line: 0,
              message: "listed file '$item' does not exist",
            ),
          );
        }
      }
    }
    for (final file in Directory(
      entity.path,
    ).listSync().whereType<File>().where((f) => f.path.endsWith('.dart'))) {
      final lines = file.readAsLinesSync().length;
      if (lines > maxFileLines) {
        findings.add(
          LayerFinding(
            rule: 'block-installable',
            file: relativePath(file.path, scan.root),
            line: 0,
            message: '$lines lines (limit $maxFileLines)',
          ),
        );
      }
    }
  }
  findings.sort((a, b) => a.file.compareTo(b.file));
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
