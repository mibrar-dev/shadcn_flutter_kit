// Generates `test/registry/blocks/blocks_render_test.dart` and
// `test/registry/blocks/blocks_meta_test.dart` from the blocks tree.
//
// A block (`lib/registry/blocks/<id>/`) is the layer-4 unit of the registry:
// its public widget in `<underscored id>.dart` is the preview, `meta.json`
// carries identity + deps, `README.md` the docs.
//
// The render test pumps every block at 375, 768 and 1440 wide, under the
// neutral and claude presets in light and dark, and asserts nothing throws
// and nothing overflows. The meta test asserts that `meta.json` deps equal
// the layer units the block really imports (the generator derives them here
// with `package:analyzer`, so a drift changes the generated file and the
// `--check` gate fails).
//
// Usage:
//   dart run tool/registry/gen_blocks_test.dart [--check]
//
// The output is passed through `dart format` before it is written, so the
// files on disk are byte-identical to the generated text and `--check` is a
// plain equality comparison.

import 'dart:io';

import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';

/// One block directory read from the tree.
class _Block {
  _Block(this.id, this.widget, this.deps);

  /// Directory name and meta id, e.g. `dashboard-01`.
  final String id;

  /// Public widget class the entry file declares, e.g. `Dashboard01`.
  final String widget;

  /// Layer unit ids the block's Dart files import.
  final Map<String, List<String>> deps;

  /// Dart file stem: `dashboard-01` lives in `dashboard_01.dart`, because
  /// Dart file names must satisfy the `file_names` lint.
  String get stem => id.replaceAll('-', '_');

  /// Dart files of the block, sorted.
  List<String> get files => _files[id]!;
}

/// Dart file names per block id.
final Map<String, List<String>> _files = <String, List<String>>{};

void main(List<String> args) {
  final check = args.contains('--check');
  final root = _appRoot();
  final blocks = _readBlocks(root);
  if (blocks.isEmpty) {
    stderr.writeln('no blocks found under $root/lib/registry/blocks');
    exitCode = 66;
    return;
  }
  final render = _format(_renderTest(blocks), root);
  final meta = _format(_renderMetaTest(blocks), root);
  final renderFile = File('$root/test/registry/blocks/blocks_render_test.dart');
  final metaFile = File('$root/test/registry/blocks/blocks_meta_test.dart');
  if (check) {
    var ok = true;
    for (final entry in <File, String>{
      renderFile: render,
      metaFile: meta,
    }.entries) {
      final current = entry.key.existsSync()
          ? entry.key.readAsStringSync()
          : '';
      if (current != entry.value) {
        stderr.writeln('${entry.key.path} is not up to date.');
        ok = false;
      }
    }
    if (!ok) {
      stderr.writeln('run: dart run tool/registry/gen_blocks_test.dart');
      exitCode = 1;
      return;
    }
    stdout.writeln('blocks tests are up to date (${blocks.length} blocks).');
    return;
  }
  renderFile.parent.createSync(recursive: true);
  renderFile.writeAsStringSync(render);
  metaFile.writeAsStringSync(meta);
  stdout.writeln('Generated 2 block test files (${blocks.length} blocks).');
}

/// Runs `dart format` over [source] and returns the formatted text.
///
/// The scratch file lives inside the package, not in the system temp dir: the
/// formatter picks the language version from the enclosing pubspec, and a file
/// outside any package is formatted with the old style while the generated
/// test (inside the package) is formatted with the package's version.
String _format(String source, String root) {
  final scratch = File('\$root/.dart_tool/blocks_test_scratch.dart');
  scratch.parent.createSync(recursive: true);
  scratch.writeAsStringSync(source);
  final result = Process.runSync('dart', <String>['format', scratch.path]);
  if (result.exitCode != 0) {
    stderr.writeln('dart format failed on the generated test:');
    stderr.writeln(result.stdout);
    stderr.writeln(result.stderr);
    throw StateError('cannot format the generated blocks test');
  }
  final formatted = scratch.readAsStringSync();
  scratch.deleteSync();
  return formatted;
}

/// Every block directory, sorted by id.
List<_Block> _readBlocks(String root) {
  final result = <_Block>[];
  final dir = Directory('$root/lib/registry/blocks');
  if (!dir.existsSync()) return result;
  for (final entity in dir.listSync()) {
    if (entity is! Directory) continue;
    final id = entity.path.split('/').last;
    final files =
        Directory(entity.path)
            .listSync()
            .whereType<File>()
            .where((file) => file.path.endsWith('.dart'))
            .map((file) => file.path.split('/').last)
            .toList()
          ..sort();
    if (!files.contains('${id.replaceAll('-', '_')}.dart')) {
      stderr.writeln('block "$id" has no entry file');
      exitCode = 66;
      return result;
    }
    _files[id] = files;
    final widget = _publicWidgetName(
      File('${entity.path}/${id.replaceAll('-', '_')}.dart'),
      id,
    );
    if (widget == null) {
      stderr.writeln('block "$id" exports no public widget');
      exitCode = 66;
      return result;
    }
    result.add(
      _Block(id, widget, _layerUnits(files.map((f) => '${entity.path}/$f'))),
    );
  }
  result.sort((a, b) => a.id.compareTo(b.id));
  return result;
}

/// The block's public widget class, read from the AST: the class named after
/// the PascalCase of the block id.
String? _publicWidgetName(File entry, String id) {
  final result = parseString(
    content: entry.readAsStringSync(),
    path: entry.path,
    throwIfDiagnostics: false,
  );
  final expected = _pascal(id);
  for (final Declaration declaration in result.unit.declarations) {
    if (declaration is! ClassDeclaration) continue;
    final name = declaration.namePart.typeName.lexeme;
    if (name == expected && !name.startsWith('_')) return name;
  }
  return null;
}

/// Layer unit ids the block imports: `components/card/card.dart` yields
/// `components -> card`, `foundation/gap.dart` yields `foundation -> gap`.
/// Parsed with `package:analyzer`, never with a regex.
Map<String, List<String>> _layerUnits(Iterable<String> dartFiles) {
  final units = <String, Set<String>>{
    'foundation': <String>{},
    'theme': <String>{},
    'primitives': <String>{},
    'components': <String>{},
  };
  for (final path in dartFiles) {
    final parsed = parseString(
      content: File(path).readAsStringSync(),
      path: path,
      throwIfDiagnostics: false,
    );
    for (final directive in parsed.unit.directives) {
      if (directive is! ImportDirective) continue;
      final uri = directive.uri.stringValue;
      if (uri == null || !uri.startsWith('../../')) continue;
      final segments = uri.substring('../../'.length).split('/');
      if (segments.length < 2 || !units.containsKey(segments.first)) continue;
      final id = segments.length > 2
          ? segments[1]
          : segments[1].substring(0, segments[1].length - '.dart'.length);
      units[segments.first]!.add(id);
    }
  }
  return <String, List<String>>{
    for (final entry in units.entries) entry.key: entry.value.toList()..sort(),
  };
}

String _pascal(String id) => id
    .split('-')
    .map(
      (part) =>
          part.isEmpty ? part : '${part[0].toUpperCase()}${part.substring(1)}',
    )
    .join();

String _renderTest(List<_Block> blocks) {
  final imports = <String>[
    for (final block in blocks)
      "import 'package:flutter_shadcn_kit/registry/blocks/${block.id}/"
          "${block.stem}.dart';",
  ];
  final pumps = <String>[
    for (final block in blocks)
      'await pumpBlock(tester, const ${block.widget}(), theme, width);',
  ];
  return '''
// GENERATED by tool/registry/gen_blocks_test.dart.
//
// P6-B1 block contract: every block must pump at 375, 768 and 1440 wide,
// under the neutral and claude presets in light and dark, with no exception
// and no overflow. A block's public widget is the preview, so it is pumped
// exactly as an app would render it.
//
// Regenerate with:
//   dart run tool/registry/gen_blocks_test.dart [--check]

import 'package:flutter_test/flutter_test.dart';

import 'blocks_support.dart';

${imports.join('\n')}

void main() {
  for (final preset in blockPresets) {
    for (final brightness in blockBrightnesses) {
      testWidgets('\$preset / \${brightness.name}', (WidgetTester tester) async {
        final theme = blockTheme(preset, brightness);
        for (final width in blockWidths) {
${pumps.map((pump) => '          $pump').join('\n')}
        }
      });
    }
  }
}
''';
}

String _renderMetaTest(List<_Block> blocks) {
  final ids = blocks.map((block) => block.id).toList();
  final quoted = ids.map((id) => "'$id'").join(', ');
  final depChecks = <String>[for (final block in blocks) _depCheck(block)];
  return '''
// GENERATED by tool/registry/gen_blocks_test.dart.
//
// P6-B1 block metadata contract: every block directory has a `meta.json`
// whose category, viewport and files are all present, and whose declared deps
// are exactly the layer units the block imports. The dependency lists below
// are the ones the generator derived from the block's real imports with
// package:analyzer, so a drift between meta.json and the code changes this
// file and fails `gen_blocks_test.dart --check`.

import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import '../../../tool/registry/src/categories.dart';

void main() {
  final appRoot = Directory.current.path;
  final ids = <String>[$quoted];
  final derivedDeps = <String, Map<String, List<String>>>{
${depChecks.join(',\n')},
  };

  test('every block directory is in the table', () {
    final onDisk = Directory('\$appRoot/lib/registry/blocks')
        .listSync()
        .whereType<Directory>()
        .map((entity) => entity.path.split('/').last)
        .toList()
      ..sort();
    expect(onDisk, ids);
  });

  for (final id in ids) {
    group(id, () {
      final meta = jsonDecode(
        File('\$appRoot/lib/registry/blocks/\$id/meta.json').readAsStringSync(),
      ) as Map<String, dynamic>;

      test('meta carries the identity fields', () {
        expect(meta['id'], id);
        expect(meta['name'], isA<String>());
        expect(meta['name'], isNotEmpty);
        expect(meta['description'], isA<String>());
        expect(meta['description'], isNotEmpty);
        expect(meta['install'], 'flutter_shadcn add \$id');
        expect(meta['import'], contains('/ui/shadcn/blocks/\$id/'));
      });

      test('category comes from the block taxonomy', () {
        expect(
          meta['category'],
          isIn(blockCategories),
          reason: 'unknown block category',
        );
      });

      test('viewport is a known hint', () {
        expect(meta['viewport'], anyOf('desktop', 'mobile'));
      });

      test('deps use exactly the four layers', () {
        final deps = meta['deps'] as Map<String, dynamic>;
        expect(deps.keys.toSet(), <String>{
          'foundation',
          'theme',
          'primitives',
          'components',
        });
        for (final entry in deps.entries) {
          expect(entry.value, isA<List<dynamic>>(), reason: entry.key);
          for (final item in entry.value as List) {
            expect(item, isA<String>());
          }
        }
      });

      test('every listed file exists', () {
        for (final file in meta['files'] as List) {
          expect(
            File('\$appRoot/lib/registry/blocks/\$id/\$file').existsSync(),
            isTrue,
            reason: '\$id lists a missing \$file',
          );
        }
      });

      test('README.md exists', () {
        expect(
          File('\$appRoot/lib/registry/blocks/\$id/README.md').existsSync(),
          isTrue,
        );
      });

      test('the entry file is the widget the generator found', () {
        final stem = id.replaceAll('-', '_');
        expect(
          File('\$appRoot/lib/registry/blocks/\$id/\$stem.dart').existsSync(),
          isTrue,
        );
        expect(meta['import'], contains('\$stem.dart'));
      });

      test('meta.json deps equal the real imports', () {
        final deps = meta['deps'] as Map<String, dynamic>;
        for (final layer in const <String>[
          'foundation',
          'theme',
          'primitives',
          'components',
        ]) {
          expect(
            deps[layer],
            derivedDeps[id]![layer],
            reason: 'meta.json deps.\$layer',
          );
        }
      });
    });
  }

  test('every block is in the generated manifest', () {
    final manifest = jsonDecode(
      File('\$appRoot/lib/registry/manifests/registry.json')
          .readAsStringSync(),
    ) as Map<String, dynamic>;
    final blocks = manifest['blocks'] as Map<String, dynamic>;
    for (final id in ids) {
      expect(blocks.containsKey(id), isTrue, reason: '\$id is missing');
    }
  });

  test('the manifest install root carries a blocks directory', () {
    final manifest = jsonDecode(
      File('\$appRoot/lib/registry/manifests/registry.json')
          .readAsStringSync(),
    ) as Map<String, dynamic>;
    final install = manifest['install'] as Map<String, dynamic>;
    expect(install['blocksDir'], 'blocks');
  });
}
''';
}

/// The derived layer units of one block, as a map literal entry.
String _depCheck(_Block block) {
  final layers = <String>[
    for (final layer in const <String>[
      'foundation',
      'theme',
      'primitives',
      'components',
    ])
      "'$layer': <String>[${block.deps[layer]!.map((id) => "'$id'").join(', ')}]",
  ];
  final body = layers.map((line) => '      $line,').join('\n');
  return "    '${block.id}': <String, List<String>>{\n$body\n    }";
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
