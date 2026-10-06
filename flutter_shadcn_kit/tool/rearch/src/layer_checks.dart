// Per-file layer and hygiene checks used by runLayersCheck.

import 'package:analyzer/dart/ast/ast.dart';

import 'dart_parse.dart';
import 'path_utils.dart';
import 'registry_scan.dart';

/// Collects undeclared dependency sites and flushes them as aggregated
/// findings once every file has been checked.
class DependencyCollector {
  final Map<String, List<_DependencySite>> _sites = {};
  final Map<String, DependencyMeta> _meta = {};

  void add({
    required String file,
    required String key,
    required DependencyMeta meta,
    required String uri,
    required String target,
    required int line,
  }) {
    final mapKey = '$file\u0000$key';
    _meta[mapKey] = meta;
    (_sites[mapKey] ??= <_DependencySite>[]).add(
      _DependencySite(uri: uri, target: target, line: line),
    );
  }

  /// Appends one aggregated finding per (file, missing dependency).
  void flush(List<LayerFinding> findings) {
    final keys = _sites.keys.toList()..sort();
    for (final key in keys) {
      final separator = key.indexOf('\u0000');
      final file = key.substring(0, separator);
      final dependencyMeta = _meta[key]!;
      final fileSites = _sites[key]!
        ..sort((a, b) {
          final byLine = a.line.compareTo(b.line);
          return byLine != 0 ? byLine : a.uri.compareTo(b.uri);
        });
      findings.add(
        LayerFinding(
          rule: 'undeclared-dependency',
          file: file,
          line: fileSites.first.line,
          message: dependencyMeta.message,
          details: <String, Object?>{
            'kind': dependencyMeta.kind,
            'dependency': dependencyMeta.dependency,
            'importSites': fileSites.length,
            'examples': [for (final site in fileSites.take(5)) site.toJson()],
          },
        ),
      );
    }
  }
}

/// A single rule violation.
class LayerFinding {
  LayerFinding({
    required this.rule,
    required this.file,
    required this.line,
    required this.message,
    this.details,
  });

  /// Rule id.
  final String rule;

  /// File path relative to the scan root.
  final String file;

  /// 1-based line (0 when the finding covers the whole file).
  final int line;

  /// Human readable explanation.
  final String message;

  /// Additional structured context.
  final Map<String, Object?>? details;

  /// Severity derived from the rule id.
  String get severity => layerWarningRules.contains(rule) ? 'warning' : 'error';

  /// JSON form.
  Map<String, Object?> toJson() => <String, Object?>{
    'rule': rule,
    'severity': severity,
    'file': file,
    'line': line,
    'message': message,
    if (details != null) 'details': details,
  };
}

/// Rules reported as warnings; everything else is an error.
const Set<String> layerWarningRules = <String>{'file-too-long'};

/// Maximum file length before `file-too-long` fires.
const int maxFileLines = 400;

/// Runs every enabled rule for one parsed file.
void checkLayerFile({
  required RegistryScan scan,
  required ParsedDartFile parsed,
  required Set<String> enabled,
  required List<LayerFinding> findings,
  required DependencyCollector dependencies,
}) {
  if (enabled.contains('no-ignore-for-file')) {
    final line = parsed.firstIgnoreForFileLine;
    if (line != null) {
      findings.add(
        LayerFinding(
          rule: 'no-ignore-for-file',
          file: parsed.relPath,
          line: line,
          message: 'file uses an ignore_for_file comment',
        ),
      );
    }
  }
  if (enabled.contains('file-too-long') && parsed.lineCount > maxFileLines) {
    findings.add(
      LayerFinding(
        rule: 'file-too-long',
        file: parsed.relPath,
        line: 0,
        message: '${parsed.lineCount} lines (limit $maxFileLines)',
      ),
    );
  }

  final owner = scan.ownerOf(parsed.absPath);
  final importerLayer = _layerOfRelPath(parsed.relPath);

  for (final directive in parsed.unit.directives) {
    final int line;
    String? uri;
    final String directiveKind;
    if (directive is ImportDirective) {
      line = parsed.lineOf(directive.offset);
      uri = directive.uri.stringValue;
      directiveKind = 'import';
    } else if (directive is ExportDirective) {
      line = parsed.lineOf(directive.offset);
      uri = directive.uri.stringValue;
      directiveKind = 'export';
    } else if (directive is PartDirective) {
      if (enabled.contains('no-part')) {
        findings.add(
          LayerFinding(
            rule: 'no-part',
            file: parsed.relPath,
            line: parsed.lineOf(directive.offset),
            message: 'part directive',
          ),
        );
      }
      continue;
    } else if (directive is PartOfDirective) {
      if (enabled.contains('no-part')) {
        findings.add(
          LayerFinding(
            rule: 'no-part',
            file: parsed.relPath,
            line: parsed.lineOf(directive.offset),
            message: 'part of directive',
          ),
        );
      }
      continue;
    } else {
      continue;
    }
    if (uri == null) {
      continue;
    }
    if (enabled.contains('no-material') && _isMaterialUri(uri)) {
      findings.add(
        LayerFinding(
          rule: 'no-material',
          file: parsed.relPath,
          line: line,
          message: '$directiveKind of $uri',
          details: <String, Object?>{'uri': uri},
        ),
      );
    }
    final targetRelPath = scan.resolveUri(parsed.absPath, uri);
    if (targetRelPath == null) {
      continue;
    }
    if (enabled.contains('layer-direction') && importerLayer != null) {
      final targetLayer = _layerOfRelPath(targetRelPath);
      if (targetLayer != null &&
          _violatesLayerDirection(importerLayer, targetLayer)) {
        findings.add(
          LayerFinding(
            rule: 'layer-direction',
            file: parsed.relPath,
            line: line,
            message:
                '${importerLayer.describe} $directiveKind '
                '${targetLayer.describe} file $targetRelPath; only '
                'same-or-lower layers are allowed',
            details: <String, Object?>{
              'importerLayer': importerLayer.name,
              'targetLayer': targetLayer.name,
              'target': targetRelPath,
              'uri': uri,
            },
          ),
        );
      }
    }
    if (enabled.contains('undeclared-dependency') &&
        owner.kind == 'component' &&
        baseName(parsed.relPath) != 'preview.dart') {
      _checkDependency(
        scan: scan,
        owner: owner,
        parsed: parsed,
        uri: uri,
        line: line,
        targetRelPath: targetRelPath,
        dependencies: dependencies,
      );
    }
  }
}

void _checkDependency({
  required RegistryScan scan,
  required OwnerUnit owner,
  required ParsedDartFile parsed,
  required String uri,
  required int line,
  required String targetRelPath,
  required DependencyCollector dependencies,
}) {
  final self = owner.component!;
  final targetOwner = scan.ownerOf(joinPath(scan.root, targetRelPath));
  if (targetOwner.kind == 'component') {
    final targetId = targetOwner.component!.id;
    if (targetId == self.id || self.componentDeps.contains(targetId)) {
      return;
    }
    dependencies.add(
      file: parsed.relPath,
      key: 'component:$targetId',
      meta: DependencyMeta(
        kind: 'component',
        dependency: targetId,
        message:
            "missing component dependency '$targetId' in "
            'meta.json dependencies.components',
      ),
      uri: uri,
      target: targetRelPath,
      line: line,
    );
    return;
  }
  if (targetOwner.kind == 'shared') {
    final ids = scan.sharedIdsForRelPath(targetRelPath);
    if (ids.isEmpty) {
      dependencies.add(
        file: parsed.relPath,
        key: 'shared-unmapped',
        meta: const DependencyMeta(
          kind: 'shared',
          dependency: null,
          message: 'imports a shared file that no manifest shared id covers',
        ),
        uri: uri,
        target: targetRelPath,
        line: line,
      );
      return;
    }
    final missing = ids.difference(self.sharedDeps.toSet()).toList()..sort();
    for (final id in missing) {
      dependencies.add(
        file: parsed.relPath,
        key: 'shared:$id',
        meta: DependencyMeta(
          kind: 'shared',
          dependency: id,
          message:
              "missing shared dependency '$id' in "
              'meta.json dependencies.shared',
        ),
        uri: uri,
        target: targetRelPath,
        line: line,
      );
    }
  }
}

class DependencyMeta {
  const DependencyMeta({
    required this.kind,
    required this.dependency,
    required this.message,
  });

  final String kind;
  final String? dependency;
  final String message;
}

class _DependencySite {
  _DependencySite({
    required this.uri,
    required this.target,
    required this.line,
  });

  final String uri;
  final String target;
  final int line;

  Map<String, Object?> toJson() => <String, Object?>{
    'uri': uri,
    'target': target,
    'line': line,
  };
}

bool _isMaterialUri(String uri) =>
    uri == 'package:flutter/material.dart' ||
    uri == 'package:flutter/cupertino.dart' ||
    uri == 'package:material_ui' ||
    uri.startsWith('package:material_ui/') ||
    uri == 'package:cupertino_ui' ||
    uri.startsWith('package:cupertino_ui/');

/// Layer of a file, by its first path segment.
///
/// Both registry trees are supported:
///   * legacy tree — `shared/**` is the special `shared` layer and
///     `components/<category>/<name>` files are `components` (layer 3);
///   * new tree (`registry_next`) — `foundation`=0, `theme`=1,
///     `primitives`=2 at the root, `components/<name>`=3.
/// Files without a layer segment (manifests, tools, previews outside the
/// tree) return null.
_Layer? _layerOfRelPath(String relPath) {
  final segments = relPath.split('/');
  if (segments.isEmpty) {
    return null;
  }
  switch (segments.first) {
    case 'foundation':
      return const _Layer(0);
    case 'theme':
      return const _Layer(1);
    case 'primitives':
      return const _Layer(2);
    case 'components':
      return const _Layer(3);
    case 'shared':
      return const _Layer.shared();
  }
  return null;
}

/// A file may only import same-or-lower layers.
///
/// During the migration the legacy `shared/**` tree holds foundation, theme
/// and primitive code at once, so numbered layers may import `shared`
/// (allowed), while `shared` files may only import shared/lower layers - a
/// `shared` file importing `components` is a violation.
bool _violatesLayerDirection(_Layer importer, _Layer target) {
  if (importer.isShared) {
    return !target.isShared && target.number == 3;
  }
  if (target.isShared) {
    return false;
  }
  return target.number! > importer.number!;
}

class _Layer {
  const _Layer(this.number) : isShared = false;
  const _Layer.shared() : number = null, isShared = true;

  final int? number;
  final bool isShared;

  String get name => isShared ? 'shared' : 'layer-$number';

  String get describe => isShared ? 'shared (legacy)' : 'layer $number';
}
