import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import '../../tool/rearch/src/path_utils.dart';
import '../../tool/rearch/src/registry_scan.dart';
import '../../tool/rearch/src/single_owner.dart';

void main() {
  final fixtureRoot = joinPath(
    Directory.current.path,
    'test/rearch/fixtures/single_owner',
  );

  late SingleOwnerReport report;
  late RegistryScan scan;

  setUpAll(() {
    report = runSingleOwnerCheck(root: fixtureRoot);
    scan = RegistryScan.load(fixtureRoot);
  });

  test('reports only names declared in more than one owner unit', () {
    final names = report.duplicates.map((duplicate) => duplicate.name).toSet();
    expect(names, <String>{'Duplicated', 'Diverged', '_PrivateRepeat'});
    expect(
      report.duplicates.map((duplicate) => duplicate.name),
      containsAll(<String>['Duplicated', 'Diverged']),
    );
  });

  test('identical public copies are errors with identical: true', () {
    final duplicated = report.duplicates.firstWhere(
      (entry) => entry.name == 'Duplicated',
    );
    expect(duplicated.isPublic, isTrue);
    expect(duplicated.severity, 'error');
    expect(duplicated.identical, isTrue);
    expect(duplicated.ownerUnits, <String>['alpha', 'beta']);
    expect(duplicated.sites, hasLength(2));
    expect(duplicated.sites.map((site) => site.variant).toSet(), <int>{0});
  });

  test('diverged public copies are errors with identical: false', () {
    final diverged = report.duplicates.firstWhere(
      (entry) => entry.name == 'Diverged',
    );
    expect(diverged.isPublic, isTrue);
    expect(diverged.severity, 'error');
    expect(diverged.identical, isFalse);
    expect(diverged.sites.map((site) => site.variant).toSet(), <int>{0, 1});
  });

  test('private duplicates are warnings', () {
    final privateRepeat = report.duplicates.firstWhere(
      (entry) => entry.name == '_PrivateRepeat',
    );
    expect(privateRepeat.isPublic, isFalse);
    expect(privateRepeat.severity, 'warning');
    expect(privateRepeat.identical, isTrue);
  });

  test('summary counts match the duplicates', () {
    final json = report.toJson();
    final summary = json['summary']! as Map<String, Object?>;
    expect(summary['duplicateNames'], 3);
    expect(summary['publicDuplicates'], 2);
    expect(summary['privateDuplicates'], 1);
    expect(summary['identicalDuplicates'], 2);
    expect(summary['divergedDuplicates'], 1);
    expect(summary['errors'], 2);
    expect(summary['warnings'], 1);
    expect(report.hasErrors, isTrue);
  });

  group('owner unit heuristic', () {
    OwnerUnit ownerOf(String relPath) =>
        scan.ownerOf(joinPath(scan.root, relPath));

    test('component file belongs to its nearest meta.json ancestor', () {
      expect(ownerOf('components/control/alpha/alpha.dart').label, 'alpha');
      expect(ownerOf('components/form/gamma/gamma.dart').kind, 'component');
    });

    test('shared _impl file follows the same-stem entry file', () {
      expect(
        ownerOf('shared/primitives/_impl/core/helper.dart').label,
        'shared/primitives/helper',
      );
    });

    test('shared _impl file follows an entry file that exports it', () {
      expect(
        ownerOf('shared/utils/_impl/core/__borrow_info.dart').label,
        'shared/utils/util',
      );
    });

    test('shared file without an owning entry file is UNKNOWN', () {
      expect(
        ownerOf('shared/primitives/_impl/core/other_widget_stuff.dart').kind,
        'unknown',
      );
    });

    test('top level shared file owns itself', () {
      expect(
        ownerOf('shared/primitives/other_widget.dart').label,
        'shared/primitives/other_widget',
      );
    });
  });
}
