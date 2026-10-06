import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import '../../tool/rearch/src/layers.dart';
import '../../tool/rearch/src/path_utils.dart';

void main() {
  final fixtureRoot = joinPath(
    Directory.current.path,
    'test/rearch/fixtures/layers_next',
  );

  late LayersReport report;

  setUpAll(() {
    report = runLayersCheck(
      root: fixtureRoot,
      rules: {'undeclared-dependency', 'unused-dependency'},
    );
  });

  test('fully declared deps produce no findings', () {
    final findings = report.findings
        .where((finding) => finding.file.startsWith('components/ok/'))
        .toList();
    expect(findings, isEmpty);
  });

  test('folder-style primitive dep satisfies imports', () {
    final findings = report.findings
        .where((finding) => finding.file.startsWith('components/folder_dep/'))
        .toList();
    expect(findings, isEmpty);
  });

  test('undeclared theme and component imports are errors', () {
    final findings =
        report.findings
            .where(
              (finding) =>
                  finding.rule == 'undeclared-dependency' &&
                  finding.file.startsWith('components/bad_undeclared/'),
            )
            .toList()
          ..sort((a, b) => a.message.compareTo(b.message));
    expect(findings, hasLength(2));
    expect(findings.map((finding) => finding.message).toList(), <String>[
      "missing component dependency 'ok' in meta.json deps.components",
      "missing dependency 'tokens.dart' in meta.json deps.theme",
    ]);
    expect(findings.every((finding) => finding.severity == 'error'), isTrue);
  });

  test('declared but never imported deps are warnings', () {
    final findings = report.findings
        .where(
          (finding) =>
              finding.rule == 'unused-dependency' &&
              finding.file.startsWith('components/bad_unused/'),
        )
        .toList();
    expect(findings, hasLength(1));
    final finding = findings.single;
    expect(finding.severity, 'warning');
    expect(finding.file, 'components/bad_unused/meta.json');
    expect(
      finding.message,
      "declared dependency 'gap' in deps.foundation "
      'is never imported',
    );
  });

  test('old fixture tree still uses dependencies format', () {
    final legacy = runLayersCheck(
      root: joinPath(Directory.current.path, 'test/rearch/fixtures/layers'),
      rules: {'undeclared-dependency', 'unused-dependency'},
    );
    expect(legacy.countFor('undeclared-dependency'), 3);
    expect(legacy.countFor('unused-dependency'), 0);
  });
}
