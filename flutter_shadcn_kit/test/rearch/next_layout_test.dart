import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import '../../tool/rearch/src/layers.dart';
import '../../tool/rearch/src/path_utils.dart';
import '../../tool/rearch/src/user_theme.dart';

void main() {
  final fixtureRoot = joinPath(
    Directory.current.path,
    'test/rearch/fixtures/next_layout',
  );

  test('installable flags missing entry file, id mismatch, missing files', () {
    final report = runLayersCheck(
      root: fixtureRoot,
      rules: <String>{'installable'},
      newLayout: true,
    );
    final findings = report.findings
        .where((finding) => finding.rule == 'installable')
        .toList();
    final messagesByFile = <String, List<String>>{};
    for (final finding in findings) {
      (messagesByFile[finding.file] ??= <String>[]).add(finding.message);
    }
    expect(
      messagesByFile.keys,
      containsAll(<String>[
        'components/missing_entry',
        'components/wrong_id/meta.json',
      ]),
    );
    expect(
      messagesByFile['components/missing_entry'],
      contains("missing entry file 'missing_entry.dart'"),
    );
    expect(
      messagesByFile['components/missing_entry/meta.json'],
      contains("listed file 'missing_entry.dart' does not exist"),
    );
    expect(
      messagesByFile['components/wrong_id/meta.json'],
      contains("id 'other_name' does not match directory name 'wrong_id'"),
    );
    // Clean components produce no findings.
    expect(
      findings.any((finding) => finding.file.startsWith('components/button')),
      isFalse,
    );
    expect(
      findings.any((finding) => finding.file.startsWith('components/badge')),
      isFalse,
    );
  });

  test('no-impl-dir flags _impl directories in the new tree', () {
    final report = runLayersCheck(
      root: fixtureRoot,
      rules: <String>{'no-impl-dir'},
      newLayout: true,
    );
    final findings = report.findings
        .where((finding) => finding.rule == 'no-impl-dir')
        .toList();
    expect(findings, hasLength(1));
    expect(findings.single.file, 'components/impl_dir/_impl');
    expect(findings.single.severity, 'error');
  });

  test('no-impl-dir is off for the legacy tree', () {
    final legacy = joinPath(
      Directory.current.path,
      'test/rearch/fixtures/layers',
    );
    final report = runLayersCheck(root: legacy, rules: <String>{'no-impl-dir'});
    expect(report.findings, isEmpty);
  });

  test('undeclared-dependency skips preview.dart files', () {
    final report = runLayersCheck(
      root: fixtureRoot,
      rules: <String>{'undeclared-dependency'},
      newLayout: true,
    );
    final findings = report.findings
        .where((finding) => finding.rule == 'undeclared-dependency')
        .toList();
    // badge.dart imports button without declaring it.
    expect(
      findings.any(
        (finding) =>
            finding.file == 'components/badge/badge.dart' &&
            finding.message.contains("'button'"),
      ),
      isTrue,
    );
    // button/preview.dart imports badge but previews are exempt.
    expect(
      findings.any((finding) => finding.file.endsWith('preview.dart')),
      isFalse,
    );
  });

  test('layer-direction works on the new tree', () {
    final report = runLayersCheck(
      root: fixtureRoot,
      rules: <String>{'layer-direction'},
      newLayout: true,
    );
    final findings = report.findings
        .where((finding) => finding.rule == 'layer-direction')
        .toList();
    expect(findings, hasLength(1));
    expect(findings.single.file, 'foundation/gap.dart');
    expect(findings.single.details!['importerLayer'], 'layer-0');
    expect(findings.single.details!['targetLayer'], 'layer-3');
  });

  test('checkUserThemes flags only the invalid theme file', () {
    final findings = checkUserThemes(fixtureRoot);
    expect(
      findings.every(
        (finding) =>
            finding.file == 'components/bad_theme/bad_theme_theme.dart',
      ),
      isTrue,
    );
    final messages = findings.map((finding) => finding.message).toSet();
    expect(
      messages,
      containsAll(<String>[
        "import 'package:flutter/material.dart' is not allowed in a user theme file",
        'function declarations are not allowed',
        'closures/function expressions are not allowed',
        'non-const constructor call is not allowed',
        "'resolveWith' is not allowed",
        'only top-level const variable declarations are allowed',
      ]),
    );
  });
}
