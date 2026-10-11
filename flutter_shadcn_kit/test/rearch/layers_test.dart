import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import '../../tool/rearch/src/layers.dart';
import '../../tool/rearch/src/path_utils.dart';

void main() {
  final fixtureRoot = joinPath(
    Directory.current.path,
    'test/rearch/fixtures/layers',
  );

  late LayersReport report;

  setUpAll(() {
    report = runLayersCheck(root: fixtureRoot);
  });

  test('no-material finds Material imports', () {
    final findings = report.findings
        .where((finding) => finding.rule == 'no-material')
        .toList();
    expect(findings, hasLength(1));
    expect(findings.single.file, 'components/control/alpha/alpha.dart');
    expect(findings.single.severity, 'error');
  });

  test('no-part finds part and part of directives', () {
    final findings = report.findings
        .where((finding) => finding.rule == 'no-part')
        .toList();
    expect(findings, hasLength(2));
    expect(findings.map((finding) => finding.file).toSet(), <String>{
      'components/control/alpha/alpha.dart',
      'components/control/alpha/part_file.dart',
    });
  });

  test('no-ignore-for-file finds ignore_for_file comments', () {
    final findings = report.findings
        .where((finding) => finding.rule == 'no-ignore-for-file')
        .toList();
    expect(findings, hasLength(1));
    expect(findings.single.file, 'components/control/alpha/alpha.dart');
    expect(findings.single.line, 1);
  });

  test('layer-direction flags shared code importing components', () {
    final findings = report.findings
        .where((finding) => finding.rule == 'layer-direction')
        .toList();
    expect(findings, hasLength(1));
    final finding = findings.single;
    expect(finding.file, 'shared/primitives/clickable.dart');
    expect(finding.details!['importerLayer'], 'shared');
    expect(finding.details!['targetLayer'], 'layer-3');
    expect(finding.details!['target'], 'components/form/beta/beta.dart');
  });

  test('undeclared-dependency flags missing component and shared deps', () {
    final findings = report.findings
        .where((finding) => finding.rule == 'undeclared-dependency')
        .toList();
    expect(findings, hasLength(3));
    expect(
      findings.every(
        (finding) => finding.file == 'components/control/alpha/alpha.dart',
      ),
      isTrue,
    );
    final messages = findings.map((finding) => finding.message).toList()
      ..sort();
    expect(
      messages,
      <String>[
        "missing component dependency 'beta' in meta.json "
            'dependencies.components',
        "missing shared dependency 'clickable' in meta.json "
            'dependencies.shared',
        "missing shared dependency 'util' in meta.json "
            'dependencies.shared',
      ]..sort(),
    );
    expect(
      findings
          .where((finding) => finding.details!['dependency'] == 'beta')
          .single
          .details!['importSites'],
      1,
    );
  });

  test('file-too-long is a warning above 400 lines', () {
    final findings = report.findings
        .where((finding) => finding.rule == 'file-too-long')
        .toList();
    expect(findings, hasLength(1));
    expect(findings.single.severity, 'warning');
    expect(findings.single.file, 'components/control/alpha/long_file.dart');
  });

  test('summary reports error and warning totals', () {
    final json = report.toJson();
    final summary = json['summary']! as Map<String, Object?>;
    expect(summary['errors'], 8);
    expect(summary['warnings'], 1);
    final rules = summary['rules']! as Map<String, Object?>;
    expect((rules['no-material']! as Map<String, Object?>)['count'], 1);
    expect(
      (rules['file-too-long']! as Map<String, Object?>)['severity'],
      'warning',
    );
  });

  test('--rule subset runs only the requested rules', () {
    final subset = runLayersCheck(root: fixtureRoot, rules: {'no-material'});
    expect(subset.findings, hasLength(1));
    expect(subset.rules, <String>['no-material']);
    final rules =
        (subset.toJson()['summary']! as Map<String, Object?>)['rules']!
            as Map<String, Object?>;
    expect(rules.keys, <String>['no-material']);
  });

  test('unknown rule ids are rejected', () {
    expect(
      () => runLayersCheck(root: fixtureRoot, rules: {'does-not-exist'}),
      throwsArgumentError,
    );
  });
}
