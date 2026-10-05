import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import '../../tool/rearch/src/api_diff.dart';
import '../../tool/rearch/src/api_extract.dart';
import '../../tool/rearch/src/api_model.dart';
import '../../tool/rearch/src/json_utils.dart';
import '../../tool/rearch/src/path_utils.dart';

void main() {
  final apiRoot = joinPath(Directory.current.path, 'test/rearch/fixtures/api');
  final apiV2Root = joinPath(
    Directory.current.path,
    'test/rearch/fixtures/api_v2',
  );
  final componentDir = joinPath(apiRoot, 'components/control/widgetx');
  final componentV2Dir = joinPath(apiV2Root, 'components/control/widgetx');

  late ApiComponentSnapshot component;

  setUpAll(() {
    final snapshot = buildApiSnapshot(
      root: apiRoot,
      componentDir: componentDir,
    );
    component = snapshot.components.single;
  });

  test('entry file metadata is reported', () {
    expect(component.id, 'widgetx');
    expect(component.entry, 'components/control/widgetx/widgetx.dart');
    expect(
      component.files,
      contains('components/control/widgetx/parts/api.dart'),
    );
    expect(
      component.files,
      contains('components/control/widgetx/parts/api_part.dart'),
    );
  });

  test('export show/hide combinators filter symbols', () {
    final names = component.symbols.map((symbol) => symbol.name).toSet();
    expect(
      names,
      containsAll(<String>[
        'WidgetXShell',
        'WidgetX',
        'PartClass',
        'Kept',
        'ShownThing',
        'topLevel',
        'version',
        'WidgetCallback',
      ]),
    );
    expect(names, isNot(contains('Dropped')));
    expect(names, isNot(contains('Removed')));
    expect(names, isNot(contains('HiddenThing')));
  });

  test('class members include constructors, fields, getters and statics', () {
    final widgetX = component.symbols.firstWhere(
      (symbol) => symbol.name == 'WidgetX',
    );
    final memberKeys = widgetX.members.map((member) => member.key).toSet();
    expect(
      memberKeys,
      containsAll(<String>[
        'constructor:WidgetX',
        'constructor:WidgetX.named',
        'field:id',
        'field:kind',
        'method:doWork',
        'getter:size',
        'setter:size',
        'method:create',
      ]),
    );
    final named = widgetX.members.firstWhere(
      (member) => member.name == 'WidgetX.named',
    );
    final parameters = named.extra['parameters']! as List<Object?>;
    expect(parameters, hasLength(3));
    final count = parameters.first! as Map<String, Object?>;
    expect(count['name'], 'count');
    // `required this.count` writes no type annotation at the parameter.
    expect(count['type'], isNull);
    expect(count['kind'], 'named-required');
    expect(count['required'], isTrue);
    final label = parameters[1]! as Map<String, Object?>;
    // `this.label` writes no type annotation at the parameter either.
    expect(label['type'], isNull);
    expect(label['kind'], 'named-optional');
  });

  test('function parameters keep their written types', () {
    final topLevel = component.symbols.firstWhere(
      (symbol) => symbol.name == 'topLevel',
    );
    final parameters = topLevel.extra['parameters']! as List<Object?>;
    final name = parameters.single! as Map<String, Object?>;
    expect(name['type'], 'String');
    expect(name['kind'], 'named-required');
  });

  test('snapshot JSON is stable sorted', () {
    final json = stableJsonEncode(component.toJson());
    final names = component.symbols.map((symbol) => symbol.name).toList();
    final sorted = names.toList()..sort();
    expect(names, sorted);
    final firstKey = json.indexOf('"id"');
    final secondKey = json.indexOf('"symbolCount"');
    expect(firstKey, greaterThan(-1));
    expect(secondKey, greaterThan(-1));
  });

  test('--all skips components without an entry file', () {
    final snapshot = buildApiSnapshot(root: apiRoot, all: true);
    expect(snapshot.components.map((entry) => entry.id), <String>['widgetx']);
    expect(snapshot.skipped, isEmpty);
  });

  test('diff reports added, removed and changed members', () {
    final oldSnapshot = buildApiSnapshot(
      root: apiRoot,
      componentDir: componentDir,
    );
    final newSnapshot = buildApiSnapshot(
      root: apiV2Root,
      componentDir: componentV2Dir,
    );
    final diff = diffApiSnapshots(oldSnapshot.toJson(), newSnapshot.toJson());
    expect(diff.addedSymbols.map((symbol) => symbol.name), <String>[
      'AddedThing',
    ]);
    expect(diff.removedSymbols.map((symbol) => symbol.name), <String>[
      'topLevel',
    ]);
    final widgetX = diff.changedSymbols.firstWhere(
      (changed) => changed.ref.name == 'WidgetX',
    );
    expect(widgetX.addedMembers, contains('method:newMethod'));
    expect(widgetX.changedMembers, contains('method:doWork'));
    expect(widgetX.removedMembers, isEmpty);
    final kept = diff.changedSymbols.firstWhere(
      (changed) => changed.ref.name == 'Kept',
    );
    expect(kept.addedMembers, contains('field:newField'));
    expect(diff.isEmpty, isFalse);
    expect(diff.format(), contains('widgetx'));
    expect(diff.format(), contains('+ class AddedThing'));
  });

  test('identical snapshots produce an empty diff', () {
    final first = buildApiSnapshot(root: apiRoot, componentDir: componentDir);
    final second = buildApiSnapshot(root: apiRoot, componentDir: componentDir);
    final diff = diffApiSnapshots(first.toJson(), second.toJson());
    expect(diff.isEmpty, isTrue);
    expect(diff.format(), 'api diff: no changes');
  });
}
