// Static scan for hard-coded spatial literals in the registry (P6-D9b).
//
// Parses every `lib/registry/**/*.dart` file with package:analyzer
// (unresolved AST — no analysis context needed) and collects each spatial
// literal it finds. `spatial_scan_rules.dart` classifies every value; this
// file walks the AST and writes the report.
//
// Run: `dart run test/registry/layout_audit/spatial_scan.dart`
// from the `flutter_shadcn_kit` package. Writes
// `rearch/reports/p6_spacing_audit.json`.

import 'dart:convert';
import 'dart:io';

import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/analysis/utilities.dart';
import 'spatial_scan_rules.dart';
import 'spatial_scan_visitor.dart';

/// Minimal path helpers, so the scan needs no extra dependency.
String joinPath(String base, List<String> parts) {
  final StringBuffer out = StringBuffer();
  out.write(base);
  for (final String part in parts) {
    if (part.isEmpty || part == '.') {
      continue;
    }
    final String trimmed = part.startsWith('/') ? part.substring(1) : part;
    if (out.isNotEmpty && !out.toString().endsWith('/')) {
      out.write('/');
    }
    out.write(trimmed);
  }
  return out.isEmpty ? '.' : out.toString();
}

String dirnameOf(String filePath) {
  final int slash = filePath.lastIndexOf('/');
  return slash <= 0 ? '.' : filePath.substring(0, slash);
}

String basename(String filePath) {
  final int slash = filePath.lastIndexOf('/');
  return slash < 0 ? filePath : filePath.substring(slash + 1);
}

String relativePath(String path, String from) {
  if (path.startsWith(from)) {
    final String rest = path.substring(from.length);
    return rest.startsWith('/') ? rest.substring(1) : rest;
  }
  return path;
}

/// Component id a registry file belongs to (`components/<id>/...`), or the
/// layer for shared layers (`theme`, `primitives`, `foundation`).
String componentOf(String relativePath) {
  final List<String> parts = relativePath.split('/');
  if (parts.length >= 2 && parts[0] == 'components') {
    return parts[1];
  }
  return parts.isEmpty ? '?' : parts[0];
}

/// Every Dart file under the registry, relative to it, sorted.
List<String> registryFiles(String registryRoot) {
  final Directory root = Directory(registryRoot);
  final List<String> files = <String>[];
  for (final FileSystemEntity entity in root.listSync(recursive: true)) {
    if (entity is! File) {
      continue;
    }
    if (!entity.path.endsWith('.dart')) {
      continue;
    }
    files.add(relativePath(entity.path, registryRoot));
  }
  files.sort();
  return files;
}

/// Scans the whole registry and returns one site per spatial literal.
List<SpatialSite> scanRegistry(String registryRoot) {
  final List<SpatialSite> sites = <SpatialSite>[];
  for (final String relative in registryFiles(registryRoot)) {
    final File file = File(joinPath(registryRoot, <String>[relative]));
    final String source = file.readAsStringSync();
    final ParseStringResult result = parseString(
      content: source,
      path: file.path,
    );
    final SpatialVisitor visitor = SpatialVisitor(relative, result.lineInfo);
    result.unit.accept(visitor);
    sites.addAll(visitor.sites);
  }
  return sites;
}

/// Writes `rearch/reports/p6_spacing_audit.json`.
///
/// `failingTests` is the list of audit test ids that fail today (recorded in
/// `failing_tests.txt` at the audit root, one per line); it is embedded so the
/// JSON stays the single report artifact.
void writeReport(
  List<SpatialSite> sites,
  String outPath,
  List<String> failing,
) {
  final Map<String, List<SpatialSite>> byComponent =
      <String, List<SpatialSite>>{};
  for (final SpatialSite site in sites) {
    byComponent
        .putIfAbsent(componentOf(site.file), () => <SpatialSite>[])
        .add(site);
  }

  List<Map<String, Object?>> findingsOf(List<SpatialSite> sites) => sites
      .where((SpatialSite s) => s.isFinding)
      .map(
        (SpatialSite s) => <String, Object?>{
          'file': 'lib/registry/${s.file}',
          'line': s.line,
          'kind': s.kind,
          'construct': s.construct,
          'value': s.value,
          'should_be': s.kind == 'gap'
              ? 'Gap(theme.spacing.<step>)'
              : s.kind == 'spacing_arg'
              ? 'theme.spacing.<step>'
              : 'EdgeInsets.all(theme.spacing.<step>) or '
                    'EdgeInsetsDensity.<...>',
          'decl': s.decl,
        },
      )
      .toList();

  bool isPreview(SpatialSite s) => basename(s.file) == 'preview.dart';

  final Map<String, Object?> components = <String, Object?>{};
  final List<String> compliant = <String>[];
  int implFindings = 0;
  int previewFindings = 0;
  for (final MapEntry<String, List<SpatialSite>> entry in byComponent.entries) {
    final List<SpatialSite> implSites = entry.value
        .where((SpatialSite s) => !isPreview(s))
        .toList();
    final List<SpatialSite> previewSites = entry.value
        .where(isPreview)
        .toList();
    final List<Map<String, Object?>> impl = findingsOf(implSites);
    final List<Map<String, Object?>> preview = findingsOf(previewSites);
    implFindings += impl.length;
    previewFindings += preview.length;
    if (impl.isEmpty) {
      compliant.add(entry.key);
    }
    components[entry.key] = <String, Object?>{
      'compliant': impl.isEmpty,
      'sites': entry.value.length,
      'impl_findings': impl,
      'preview_findings': preview,
    };
  }
  compliant.sort();

  final Map<String, int> byClassification = <String, int>{};
  for (final SpatialSite site in sites) {
    byClassification.update(
      site.classification,
      (int v) => v + 1,
      ifAbsent: () => 1,
    );
  }

  final Map<String, Object?> report = <String, Object?>{
    'id': 'P6-D9b',
    'generated_by': 'test/registry/layout_audit/spatial_scan.dart',
    'registry': 'flutter_shadcn_kit/lib/registry',
    'tool': 'package:analyzer parseString (unresolved AST)',
    'classification_legend': <String, String>{
      'derived_spacing': 'scales with the preset spacing base (COMPLIANT)',
      'derived_density':
          'scales with density (EdgeInsetsDensity / resolveEdgeInsets / '
          'density-scaled literal) (COMPLIANT)',
      'theme_default':
          'resolved through a component theme / widget leg (COMPLIANT when '
          'its own default is density-derived)',
      'computed': 'expression over parameters, not a literal (COMPLIANT)',
      'border_hairline': '1px border or divider — allowed by the audit rules',
      'icon_size': 'icon glyph size owned by the component theme — allowed',
      'shadcn_fixed': 'size pinned by shadcn in a box context — allowed',
      'layout_cap': 'width/height layout cap, not padding — allowed',
      'raw': 'literal padding/gap/spacing that does not scale — FINDING',
    },
    'totals': <String, Object?>{
      'sites': sites.length,
      'components': byComponent.length,
      'findings': implFindings + previewFindings,
      'impl_findings': implFindings,
      'preview_findings': previewFindings,
      'by_classification': byClassification,
    },
    'compliant_components': compliant,
    'components': components,
    'failing_tests': failing,
  };

  File(outPath)
    ..createSync(recursive: true)
    ..writeAsStringSync(const JsonEncoder.withIndent('  ').convert(report));
}

void main(List<String> args) {
  // Resolve against this script's location so the scan can be run from any
  // working directory: <kit>/flutter_shadcn_kit/test/registry/layout_audit.
  final String scriptDir = dirnameOf(Platform.script.toFilePath());
  final String kitRoot = joinPath(scriptDir, <String>['..', '..', '..', '..']);
  final String registryRoot = args.isNotEmpty
      ? args[0]
      : joinPath(kitRoot, <String>['flutter_shadcn_kit', 'lib', 'registry']);
  final String outPath = args.length > 1
      ? args[1]
      : joinPath(kitRoot, <String>[
          'rearch',
          'reports',
          'p6_spacing_audit.json',
        ]);

  final List<SpatialSite> sites = scanRegistry(registryRoot);
  final List<String> failing = <String>[];
  final File failingFile = File(
    joinPath(dirnameOf(Platform.script.toFilePath()), <String>[
      'failing_tests.txt',
    ]),
  );
  if (failingFile.existsSync()) {
    failing.addAll(
      failingFile
          .readAsLinesSync()
          .map((String line) => line.trim())
          .where((String line) => line.isNotEmpty && !line.startsWith('#')),
    );
  }

  writeReport(sites, outPath, failing);

  final int raw = sites.where((SpatialSite s) => s.isFinding).length;
  final Map<String, int> byKind = <String, int>{};
  final Map<String, int> byClass = <String, int>{};
  for (final SpatialSite site in sites) {
    byKind.update(site.kind, (int v) => v + 1, ifAbsent: () => 1);
    byClass.update(site.classification, (int v) => v + 1, ifAbsent: () => 1);
  }
  stdout.writeln('scanned ${sites.length} spatial literals in $registryRoot');
  stdout.writeln('raw (non-scaling) findings: $raw');
  stdout.writeln('by kind: $byKind');
  stdout.writeln('by classification: $byClass');
  stdout.writeln('report: $outPath');
}
