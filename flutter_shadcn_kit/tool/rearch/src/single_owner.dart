// Single-owner check: every top-level name must be declared in exactly one
// owner unit (component or shared module). Public duplicates are errors,
// private duplicates are warnings.

import 'dart_parse.dart';
import 'declarations.dart';
import 'registry_scan.dart';

/// One declaration site of a duplicated name.
class DuplicateSite {
  DuplicateSite({
    required this.file,
    required this.line,
    required this.kind,
    required this.owner,
    required this.variant,
    required this.isPublic,
  });

  /// File path relative to the scan root.
  final String file;

  /// 1-based line.
  final int line;

  /// Declaration kind.
  final String kind;

  /// Owner unit label.
  final String owner;

  /// Index of the distinct normalized source variant (0-based).
  final int variant;

  /// Whether the declared name is public.
  final bool isPublic;

  /// JSON form.
  Map<String, Object?> toJson() => <String, Object?>{
    'file': file,
    'line': line,
    'kind': kind,
    'owner': owner,
    'variant': variant,
    'public': isPublic,
  };
}

/// A duplicated top-level name and every declaration site.
class DuplicateName {
  DuplicateName({
    required this.name,
    required this.isPublic,
    required this.identical,
    required this.kinds,
    required this.ownerUnits,
    required this.sites,
  });

  /// Duplicated name.
  final String name;

  /// Whether the name is public (public duplicates are errors).
  final bool isPublic;

  /// Whether every copy is identical after normalization.
  final bool identical;

  /// Declaration kinds seen for this name, sorted.
  final List<String> kinds;

  /// Owning unit labels, sorted.
  final List<String> ownerUnits;

  /// Declaration sites, sorted by file and line.
  final List<DuplicateSite> sites;

  /// `error` for public duplicates, `warning` otherwise.
  String get severity => isPublic ? 'error' : 'warning';

  /// JSON form.
  Map<String, Object?> toJson() => <String, Object?>{
    'name': name,
    'public': isPublic,
    'severity': severity,
    'identical': identical,
    'kinds': kinds,
    'ownerUnits': ownerUnits,
    'declarations': [for (final site in sites) site.toJson()],
  };
}

/// Result of a single-owner scan.
class SingleOwnerReport {
  SingleOwnerReport({
    required this.root,
    required this.skipGenerated,
    required this.generatedAt,
    required this.filesScanned,
    required this.filesWithSyntaxErrors,
    required this.declarations,
    required this.sameOwnerRepeats,
    required this.duplicates,
  });

  /// Scan root.
  final String root;

  /// Whether generated files were skipped.
  final bool skipGenerated;

  /// UTC timestamp of the run.
  final String generatedAt;

  /// Number of Dart files scanned.
  final int filesScanned;

  /// Number of files the parser reported syntax errors for.
  final int filesWithSyntaxErrors;

  /// Number of top-level declarations collected.
  final int declarations;

  /// Repeats inside a single owner unit (not counted as duplicates).
  final int sameOwnerRepeats;

  /// Duplicated names, sorted by name.
  final List<DuplicateName> duplicates;

  int _count(bool Function(DuplicateName) test) =>
      duplicates.where(test).length;

  /// Public duplicate count.
  int get publicDuplicates => _count((duplicate) => duplicate.isPublic);

  /// Private duplicate count.
  int get privateDuplicates => _count((duplicate) => !duplicate.isPublic);

  /// Duplicates whose copies are textually identical.
  int get identicalDuplicates => _count((duplicate) => duplicate.identical);

  /// Duplicates with diverged copies.
  int get divergedDuplicates => _count((duplicate) => !duplicate.identical);

  /// Whether any error level duplicate exists.
  bool get hasErrors => publicDuplicates > 0;

  /// Summary demanded by `--strict`.
  Map<String, Object?> toJson() => <String, Object?>{
    'tool': 'check_single_owner',
    'schemaVersion': 1,
    'generatedAt': generatedAt,
    'root': root,
    'skipGenerated': skipGenerated,
    'summary': <String, Object?>{
      'filesScanned': filesScanned,
      'filesWithSyntaxErrors': filesWithSyntaxErrors,
      'declarations': declarations,
      'sameOwnerRepeats': sameOwnerRepeats,
      'duplicateNames': duplicates.length,
      'publicDuplicates': publicDuplicates,
      'privateDuplicates': privateDuplicates,
      'identicalDuplicates': identicalDuplicates,
      'divergedDuplicates': divergedDuplicates,
      'errors': publicDuplicates,
      'warnings': privateDuplicates,
      'topOwnerUnits': _topOwnerUnits(),
    },
    'duplicates': [for (final duplicate in duplicates) duplicate.toJson()],
  };

  List<Map<String, Object?>> _topOwnerUnits() {
    final counts = <String, int>{};
    for (final duplicate in duplicates) {
      for (final owner in duplicate.ownerUnits) {
        counts[owner] = (counts[owner] ?? 0) + 1;
      }
    }
    final entries = counts.entries.toList()
      ..sort((a, b) {
        final byCount = b.value.compareTo(a.value);
        return byCount != 0 ? byCount : a.key.compareTo(b.key);
      });
    return <Map<String, Object?>>[
      for (final entry in entries.take(20))
        <String, Object?>{'owner': entry.key, 'duplicateNames': entry.value},
    ];
  }

  /// Human readable summary lines.
  List<String> summaryLines() {
    final lines = <String>[
      'check_single_owner: $filesScanned files scanned, '
          '$declarations declarations, '
          '$filesWithSyntaxErrors files with syntax errors',
      'duplicate names: ${duplicates.length} '
          '(public $publicDuplicates, private $privateDuplicates) - '
          'identical $identicalDuplicates, diverged $divergedDuplicates',
      if (sameOwnerRepeats > 0)
        'same-owner repeats (not duplicates): $sameOwnerRepeats',
    ];
    for (final duplicate in duplicates) {
      final kindLabel = duplicate.kinds.join('/');
      final identity = duplicate.identical ? 'identical' : 'diverged';
      final owners = duplicate.ownerUnits.join(', ');
      lines.add(
        '${duplicate.severity.toUpperCase()} ${duplicate.name} '
        '($kindLabel, $identity; owners: $owners)',
      );
      for (final site in duplicate.sites) {
        lines.add('    ${site.file}:${site.line} [${site.owner}]');
      }
    }
    return lines;
  }
}

/// Runs the single-owner check over [root].
SingleOwnerReport runSingleOwnerCheck({
  required String root,
  bool skipGenerated = true,
}) {
  final scan = RegistryScan.load(root, skipGenerated: skipGenerated);
  final byName = <String, List<TopLevelDecl>>{};
  var declarations = 0;
  var filesWithSyntaxErrors = 0;
  for (final absPath in scan.dartFiles) {
    final relPath = scan.relPathOf(absPath);
    final parsed = parseDartFile(absPath, relPath);
    if (parsed.syntaxErrorCount > 0) {
      filesWithSyntaxErrors += 1;
    }
    for (final declaration in collectTopLevelDeclarations(parsed)) {
      declarations += 1;
      (byName[declaration.name] ??= <TopLevelDecl>[]).add(declaration);
    }
  }

  final duplicates = <DuplicateName>[];
  var sameOwnerRepeats = 0;
  for (final entry in byName.entries) {
    if (entry.value.length < 2) {
      continue;
    }
    final ownerLabels = <String>[];
    for (final declaration in entry.value) {
      final owner = scan.ownerOf(declaration.file.absPath);
      if (!ownerLabels.contains(owner.label)) {
        ownerLabels.add(owner.label);
      }
    }
    if (ownerLabels.length < 2) {
      sameOwnerRepeats += 1;
      continue;
    }
    duplicates.add(_buildDuplicate(scan, entry.key, entry.value));
  }
  duplicates.sort((a, b) => a.name.compareTo(b.name));

  return SingleOwnerReport(
    root: scan.root,
    skipGenerated: scan.skipGenerated,
    generatedAt: DateTime.now().toUtc().toIso8601String(),
    filesScanned: scan.dartFiles.length,
    filesWithSyntaxErrors: filesWithSyntaxErrors,
    declarations: declarations,
    sameOwnerRepeats: sameOwnerRepeats,
    duplicates: duplicates,
  );
}

DuplicateName _buildDuplicate(
  RegistryScan scan,
  String name,
  List<TopLevelDecl> declarations,
) {
  final variants = <String, int>{};
  final sites = <DuplicateSite>[];
  final kinds = <String>{};
  final owners = <String>{};
  for (final declaration in declarations) {
    final source = declaration.normalizedSource;
    final variant = variants.putIfAbsent(source, () => variants.length);
    final owner = scan.ownerOf(declaration.file.absPath).label;
    kinds.add(declaration.kind);
    owners.add(owner);
    sites.add(
      DuplicateSite(
        file: declaration.file.relPath,
        line: declaration.line,
        kind: declaration.kind,
        owner: owner,
        variant: variant,
        isPublic: declaration.isPublic,
      ),
    );
  }
  sites.sort((a, b) {
    final byFile = a.file.compareTo(b.file);
    return byFile != 0 ? byFile : a.line.compareTo(b.line);
  });
  final sortedKinds = kinds.toList()..sort();
  final sortedOwners = owners.toList()..sort();
  return DuplicateName(
    name: name,
    isPublic: !name.startsWith('_'),
    identical: variants.length == 1,
    kinds: sortedKinds,
    ownerUnits: sortedOwners,
    sites: sites,
  );
}
