// Generates `test/registry/previews_test.dart` from the registry previews.
//
// The P6-F3 preview contract: every listed `lib/registry/components/<id>/`
// exports `const List<ComponentPreview> <camelName>Previews` from its
// `preview.dart`, the first entry being the default example. This generator
// parses each `preview.dart` with `package:analyzer` (no resolution), finds
// that top-level variable and emits the table the test iterates, so the test
// can never drift from the registry again.
//
// Usage:
//   dart run tool/registry/gen_previews_test.dart [--check]
//
// The output is passed through `dart format` before it is written, so the file
// on disk is byte-identical to the generated text and `--check` is a plain
// equality comparison.

import 'dart:convert';
import 'dart:io';

import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';

/// One listed component and the preview list variable it exports.
class _PreviewEntry {
  _PreviewEntry(this.id, this.variable);

  final String id;
  final String variable;
}

/// Newline character, spelled out so the template below stays literal.
final String _nl = String.fromCharCode(10);

void main(List<String> args) {
  final check = args.contains('--check');
  final root = _appRoot();
  final entries = <_PreviewEntry>[];
  final pending = <String>[];
  for (final entity in Directory('$root/lib/registry/components').listSync()) {
    if (entity is! Directory) continue;
    final id = entity.path.split('/').last;
    if (!_isListed(File('${entity.path}/meta.json'))) continue;
    final preview = File('${entity.path}/preview.dart');
    if (!preview.existsSync()) {
      stderr.writeln('listed component "$id" has no preview.dart');
      exitCode = 66;
      return;
    }
    final variable = _previewListName(preview);
    if (variable == null) {
      pending.add(id);
      continue;
    }
    entries.add(_PreviewEntry(id, variable));
  }
  entries.sort((a, b) => a.id.compareTo(b.id));
  pending.sort();
  final partial = args.contains('--partial');
  if (pending.isNotEmpty && !partial) {
    stderr.writeln(
      '${pending.length} listed preview(s) do not export a '
      'List<ComponentPreview> yet:',
    );
    stderr.writeln('  ${pending.join(', ')}');
    stderr.writeln(
      'pass --partial to generate the table for the converted ones',
    );
    exitCode = 65;
    return;
  }
  if (pending.isNotEmpty) {
    stderr.writeln('partial run: ${pending.length} preview(s) pending.');
  }

  final formatted = _format(_render(entries, pending));
  final out = File('$root/test/registry/previews_test.dart');
  if (check) {
    final current = out.existsSync() ? out.readAsStringSync() : '';
    if (current != formatted) {
      stderr.writeln('${out.path} is not up to date.');
      stderr.writeln('run: dart run tool/registry/gen_previews_test.dart');
      exitCode = 1;
      return;
    }
    stdout.writeln('${out.path} is up to date (${entries.length} components).');
    return;
  }
  out.parent.createSync(recursive: true);
  out.writeAsStringSync(formatted);
  stdout.writeln('Generated ${out.path} (${entries.length} components).');
}

/// Runs `dart format` over [source] and returns the formatted text.
String _format(String source) {
  final scratch = File(
    '${Directory.systemTemp.path}/shadcn_gen_previews_test.dart',
  );
  scratch.writeAsStringSync(source);
  final result = Process.runSync('dart', <String>['format', scratch.path]);
  if (result.exitCode != 0) {
    stderr.writeln('dart format failed on the generated test:');
    stderr.writeln(result.stdout);
    stderr.writeln(result.stderr);
    throw StateError('cannot format the generated previews test');
  }
  final formatted = scratch.readAsStringSync();
  scratch.deleteSync();
  return formatted;
}

/// Whether `meta.json` keeps the component in the docs chrome (default true).
bool _isListed(File metaFile) {
  final meta = jsonDecode(metaFile.readAsStringSync());
  return meta is Map<String, dynamic> && meta['listed'] != false;
}

/// Name of the exported `const List<ComponentPreview>` variable, or null.
String? _previewListName(File preview) {
  final ParseStringResult result = parseString(
    content: preview.readAsStringSync(),
    path: preview.path,
  );
  for (final Declaration declaration in result.unit.declarations) {
    if (declaration is! TopLevelVariableDeclaration) continue;
    final list = declaration.variables;
    if (list.variables.length != 1) continue;
    // The declared type of the list, read from the AST (no resolution).
    final type = list.type?.toSource() ?? '';
    if (type.replaceAll(' ', '') != 'List<ComponentPreview>') continue;
    return list.variables.first.name.lexeme;
  }
  return null;
}

/// The flutter_shadcn_kit package root, found by walking up from cwd.
String _appRoot() {
  var dir = Directory.current.absolute;
  while (true) {
    if (File('${dir.path}/pubspec.yaml').existsSync() &&
        Directory('${dir.path}/lib/registry').existsSync()) {
      return dir.path;
    }
    final parent = dir.parent;
    if (parent.path == dir.path) {
      throw StateError('cannot locate the flutter_shadcn_kit package root');
    }
    dir = parent;
  }
}

String _render(List<_PreviewEntry> entries, List<String> pending) {
  final imports = <String>[
    for (final entry in entries)
      "import 'package:flutter_shadcn_kit/registry/components/${entry.id}/"
          'preview.dart\';',
  ];
  final table = <String>[
    for (final entry in entries) "  '${entry.id}': ${entry.variable},",
  ];
  return '''
// GENERATED by tool/registry/gen_previews_test.dart.
//
// P6-F3 preview contract: every named example of every listed component must
// pump inside a 720x420 box and at 375 wide, under the neutral and claude
// presets in light and dark, with no exception and no overflow. Example names
// are unique per component and no preview pins its own theme.
//
// Regenerate with:
//   dart run tool/registry/gen_previews_test.dart [--check]

import 'dart:convert';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter_shadcn_kit/registry/foundation/component_preview.dart';
import 'package:flutter_shadcn_kit/registry/theme/theme.dart';
import 'package:flutter_test/flutter_test.dart';

import 'themes/generated_theme.dart';

${imports.join('\n')}

/// Stage size the docs page hands an example.
const Size _stageSize = Size(720, 420);

/// Width the docs stage collapses to on a phone.
const double _phoneWidth = 375;

/// Preset directory of the registry theme layer.
String get _themesDir =>
    '\${Directory.current.path}/lib/registry/themes';

/// Presets every example is pumped under.
const List<String> _presets = <String>['neutral', 'claude'];

/// Brightnesses every example is pumped under.
const List<Brightness> _brightnesses = <Brightness>[
  Brightness.light,
  Brightness.dark,
];

/// Listed components whose `preview.dart` has not been converted yet; empty
/// on a full run.
const List<String> _pending = <String>[
${pending.map((String id) => "  '$id',").join(_nl)}
];

/// component id -> its named examples; the first one is the default.
final Map<String, List<ComponentPreview>> _previews =
    <String, List<ComponentPreview>>{
${table.join(_nl)}
    };

/// The example inside the bounded 720x420 stage box.
Widget _stageHost(WidgetBuilder builder) {
  return SizedBox.fromSize(
    size: _stageSize,
    child: Builder(builder: builder),
  );
}

/// The same example inside a 375 wide box.
Widget _phoneHost(WidgetBuilder builder) {
  return SizedBox(width: _phoneWidth, child: Builder(builder: builder));
}

/// Pumps [example] under [theme] inside [host] and asserts nothing threw or
/// overflowed.
Future<void> _pump(
  WidgetTester tester,
  ComponentPreview example,
  ShadcnThemeDataView theme,
  Widget host,
) async {
  await tester.pumpWidget(
    ShadcnTheme(
      data: ShadcnThemeData(
        colors: theme.colors,
        tokens: theme.tokens,
        fonts: theme.fonts,
      ),
      child: Directionality(
        textDirection: TextDirection.ltr,
        // The docs page runs every example inside the app shell, so an
        // Overlay exists; without it any text field in a preview throws.
        child: Overlay.wrap(child: Center(child: host)),
      ),
    ),
  );
  await tester.pump();
  // A second frame: a focus change (the command palette autofocuses its
  // search field) is delivered in the frame after the one that mounts it.
  await tester.pump(const Duration(milliseconds: 16));
  final Object? exception = tester.takeException();
  expect(
    exception,
    isNull,
    reason: 'example "\${example.name}" threw: \$exception',
  );
}

/// Every component that has a `preview.dart` and stays listed in the docs, read
/// from the tree so the test cannot silently lose a component when the
/// generator is not re-run.
List<String> _listedComponents(String appRoot) {
  final result = <String>[];
  for (final directory
      in Directory('\$appRoot/lib/registry/components').listSync()) {
    if (directory is! Directory) continue;
    final id = directory.path.split('/').last;
    if (!File('\${directory.path}/preview.dart').existsSync()) continue;
    final meta = jsonDecode(
      File('\${directory.path}/meta.json').readAsStringSync(),
    );
    if (meta is Map<String, dynamic> && meta['listed'] == false) continue;
    result.add(id);
  }
  result.sort();
  return result;
}

void main() {
  final appRoot = Directory.current.path;
  final listed = _listedComponents(appRoot);

  test('every listed component exports its examples', () {
    for (final id in listed) {
      expect(
        _previews.containsKey(id) || _pending.contains(id),
        isTrue,
        reason: 'no preview list for \$id - run gen_previews_test.dart',
      );
    }
  });

  test('no building block leaks into the table', () {
    final expected = listed
        .where((String id) => !_pending.contains(id))
        .toList();
    expect(_previews.keys.toList(), expected);
  });

  test('no preview pins its own theme', () {
    for (final id in _previews.keys) {
      final file = File('\$appRoot/lib/registry/components/\$id/preview.dart');
      expect(file.existsSync(), isTrue, reason: '\$id has no preview.dart');
      expect(
        file.readAsStringSync().contains('ShadcnThemeData('),
        isFalse,
        reason: '\$id/preview.dart hard-codes a theme',
      );
    }
  });

  test('the contract class is exported from foundation', () {
    const preview = ComponentPreview('name', _placeholder);
    expect(preview.name, 'name');
    expect(preview.description, isNull);
  });

  for (final MapEntry<String, List<ComponentPreview>> entry
      in _previews.entries) {
    group(entry.key, () {
      test('exports at least one named example', () {
        expect(entry.value, isNotEmpty);
      });

      test('example names are unique', () {
        final names = entry.value
            .map((ComponentPreview example) => example.name)
            .toList();
        expect(names.toSet().length, names.length);
      });

      for (final String preset in _presets) {
        for (final Brightness brightness in _brightnesses) {
          final ShadcnThemeDataView theme = loadGeneratedTheme(
            '\$_themesDir/\$preset.json',
          ).view(brightness);
          testWidgets('\$preset / \${brightness.name}', (
            WidgetTester tester,
          ) async {
            for (final ComponentPreview example in entry.value) {
              await _pump(tester, example, theme, _stageHost(example.builder));
              await _pump(
                tester,
                example,
                theme,
                _phoneHost(example.builder),
              );
            }
          });
        }
      }
    });
  }
}

Widget _placeholder(BuildContext context) => const SizedBox.shrink();
''';
}
