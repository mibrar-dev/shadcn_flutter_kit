// Layer and hygiene report for the registry tree.
//
// Rules and their severities:
//   no-material             error  - Material/Cupertino imports or exports.
//   no-part                 error  - `part` / `part of` directives.
//   no-ignore-for-file      error  - `// ignore_for_file:` comments.
//   layer-direction         error  - imports that point at a higher layer.
//   undeclared-dependency   error  - imports missing from meta.json deps.
//   file-too-long           warning - more than 400 physical lines.
//   unused-dependency       warning - declared deps never imported (deps
//                                      format only).
//
// The per-file rule logic lives in layer_checks.dart.
//
// Dependency checking has two modes, picked per component by the presence
// of a `deps` object in its meta.json:
//   * registry_next mode (`deps: {"foundation": [...], "theme": [...],
//     "primitives": [...], "components": [...]}`): every entry is a file
//     stem relative to that layer (`"data"` = `foundation/data.dart`) or a
//     folder name (`"form_core"` = `primitives/form_core/`). An import not
//     covered by a declared entry is an `undeclared-dependency` error, and
//     a declared entry never imported by the component is an
//     `unused-dependency` warning.
//   * legacy mode (`dependencies.components` / `dependencies.shared`):
//     unchanged behaviour driven by the shared manifests.

import 'dart_parse.dart';
import 'dir_checks.dart';
import 'layer_checks.dart';
import 'registry_scan.dart';

/// All rule ids, in report order.
const List<String> layerRuleIds = <String>[
  'no-material',
  'no-part',
  'no-ignore-for-file',
  'layer-direction',
  'undeclared-dependency',
  'file-too-long',
  'unused-dependency',
  'installable',
  'no-impl-dir',
];

/// Result of a layer/hygiene scan.
class LayersReport {
  LayersReport({
    required this.root,
    required this.skipGenerated,
    required this.generatedAt,
    required this.rules,
    required this.filesScanned,
    required this.filesWithSyntaxErrors,
    required this.findings,
  });

  /// Scan root.
  final String root;

  /// Whether generated files were skipped.
  final bool skipGenerated;

  /// UTC timestamp of the run.
  final String generatedAt;

  /// Rule ids that were run, in report order.
  final List<String> rules;

  /// Number of Dart files scanned.
  final int filesScanned;

  /// Number of files the parser reported syntax errors for.
  final int filesWithSyntaxErrors;

  /// Findings sorted by rule, file, line.
  final List<LayerFinding> findings;

  /// Whether any error level finding exists.
  bool get hasErrors => findings.any((finding) => finding.severity == 'error');

  /// Number of findings for [rule].
  int countFor(String rule) =>
      findings.where((finding) => finding.rule == rule).length;

  /// JSON form.
  Map<String, Object?> toJson() => <String, Object?>{
    'tool': 'check_layers',
    'schemaVersion': 1,
    'generatedAt': generatedAt,
    'root': root,
    'skipGenerated': skipGenerated,
    'summary': <String, Object?>{
      'filesScanned': filesScanned,
      'filesWithSyntaxErrors': filesWithSyntaxErrors,
      'errors': findings.where((f) => f.severity == 'error').length,
      'warnings': findings.where((f) => f.severity == 'warning').length,
      'rules': <String, Object?>{
        for (final rule in rules)
          rule: <String, Object?>{
            'count': countFor(rule),
            'severity': layerWarningRules.contains(rule) ? 'warning' : 'error',
            'topFiles': _topFiles(rule),
          },
      },
    },
    'findings': [for (final finding in findings) finding.toJson()],
  };

  List<Map<String, Object?>> _topFiles(String rule) {
    final counts = <String, int>{};
    for (final finding in findings) {
      if (finding.rule == rule) {
        counts[finding.file] = (counts[finding.file] ?? 0) + 1;
      }
    }
    final entries = counts.entries.toList()
      ..sort((a, b) {
        final byCount = b.value.compareTo(a.value);
        return byCount != 0 ? byCount : a.key.compareTo(b.key);
      });
    return <Map<String, Object?>>[
      for (final entry in entries.take(20))
        <String, Object?>{'file': entry.key, 'count': entry.value},
    ];
  }

  /// Human readable summary lines.
  List<String> summaryLines() {
    final lines = <String>[
      'check_layers: $filesScanned files scanned, '
          '$filesWithSyntaxErrors files with syntax errors',
      for (final rule in rules)
        '  $rule: ${countFor(rule)} '
            '(${layerWarningRules.contains(rule) ? 'warning' : 'error'})',
    ];
    return lines;
  }
}

/// Runs the selected layer/hygiene [rules] over [root].
LayersReport runLayersCheck({
  required String root,
  bool skipGenerated = true,
  Set<String>? rules,
  bool? newLayout,
}) {
  final enabled = rules == null
      ? layerRuleIds.toSet()
      : Set<String>.from(rules);
  final unknown = enabled.difference(layerRuleIds.toSet());
  if (unknown.isNotEmpty) {
    throw ArgumentError(
      'Unknown rule(s): ${(unknown.toList()..sort()).join(', ')}. '
      'Known rules: ${layerRuleIds.join(', ')}',
    );
  }
  final orderedRules = layerRuleIds
      .where(enabled.contains)
      .toList(growable: false);

  // `--new-layout` on the CLI; inferred for roots ending in `registry_next`.
  final isNewLayout = newLayout ?? root.endsWith('registry_next');

  final scan = RegistryScan.load(root, skipGenerated: skipGenerated);
  final findings = <LayerFinding>[];
  final dependencies = DependencyCollector();
  var filesWithSyntaxErrors = 0;

  for (final absPath in scan.dartFiles) {
    final relPath = scan.relPathOf(absPath);
    final parsed = parseDartFile(absPath, relPath);
    if (parsed.syntaxErrorCount > 0) {
      filesWithSyntaxErrors += 1;
    }
    checkLayerFile(
      scan: scan,
      parsed: parsed,
      enabled: enabled,
      findings: findings,
      dependencies: dependencies,
    );
  }
  if (enabled.contains('undeclared-dependency')) {
    dependencies.flush(findings);
  }
  if (enabled.contains('unused-dependency')) {
    dependencies.flushUnused(findings, scan);
  }
  if (enabled.contains('installable')) {
    findings.addAll(installableFindings(scan, newLayout: isNewLayout));
  }
  if (enabled.contains('no-impl-dir') && isNewLayout) {
    findings.addAll(noImplDirFindings(scan));
  }

  findings.sort((a, b) {
    final byRule = layerRuleIds
        .indexOf(a.rule)
        .compareTo(layerRuleIds.indexOf(b.rule));
    if (byRule != 0) {
      return byRule;
    }
    final byFile = a.file.compareTo(b.file);
    return byFile != 0 ? byFile : a.line.compareTo(b.line);
  });

  return LayersReport(
    root: scan.root,
    skipGenerated: scan.skipGenerated,
    generatedAt: DateTime.now().toUtc().toIso8601String(),
    rules: orderedRules,
    filesScanned: scan.dartFiles.length,
    filesWithSyntaxErrors: filesWithSyntaxErrors,
    findings: findings,
  );
}
