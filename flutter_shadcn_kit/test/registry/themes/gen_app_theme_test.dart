// Round trip: preset JSON -> `app_theme.dart` for ALL 42 presets, then the two
// gates a user app would hit on install - `dart format` must be a no-op and
// `dart analyze` must report zero issues.
//
// Both gates run once for the whole batch (one analyzer context, one formatter
// pass) instead of 84 subprocesses. Generated files live in
// `.dart_tool/rearch_gen/` so the `package:flutter_shadcn_kit/...` imports
// resolve against this package's `package_config.json`.

import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import '../../../tool/rearch/gen_app_theme.dart' as gen;
import 'schema_check.dart';

/// Clears this suite's own previous output. `.dart_tool/rearch_gen/` is scratch
/// space, and only files this suite creates (`*_app_theme.dart`) are removed -
/// a stale file there would fail the `dart analyze` gate below.
void cleanGenerated() {
  final dir = Directory(genDir);
  if (!dir.existsSync()) return;
  for (final entity in dir.listSync()) {
    if (entity is File && entity.path.endsWith('_app_theme.dart')) {
      entity.deleteSync();
    }
  }
}

/// Writes every preset's theme file and returns the generated paths.
List<String> generateAll() {
  cleanGenerated();
  final files = presetFiles();
  final written = <String>[];
  for (final file in files) {
    final values = gen.ThemeValues.fromJson(readJsonMap('$themesDir/$file'));
    final out =
        '$genDir/${file.replaceAll('.json', '').replaceAll('-', '_')}'
        '_app_theme.dart';
    final target = File(out)..parent.createSync(recursive: true);
    target.writeAsStringSync(values.toDartSource());
    written.add(out);
  }
  return written;
}

void main() {
  test('all 42 presets generate a format clean, analyzable theme file', () {
    final written = generateAll();
    expect(written.length, 42);

    final format = Process.runSync('dart', <String>[
      'format',
      '--output=none',
      '--set-exit-if-changed',
      genDir,
    ]);
    expect(
      format.exitCode,
      0,
      reason:
          'dart format would rewrite generated files:\n'
          '${format.stdout}\n${format.stderr}',
    );

    final analyze = Process.runSync('dart', <String>['analyze', genDir]);
    expect(
      analyze.exitCode,
      0,
      reason:
          'dart analyze found issues in generated files:\n'
          '${analyze.stdout}\n${analyze.stderr}',
    );
    expect('${analyze.stdout}${analyze.stderr}', contains('No issues found!'));
  }, timeout: const Timeout(Duration(minutes: 10)));

  test('the generated file is values only: no logic, no other imports', () {
    final source = gen.ThemeValues.fromJson(
      readJsonMap('$themesDir/amber-minimal.json'),
    ).toDartSource();
    final imports = RegExp(
      r"^import '(.+)';$",
      multiLine: true,
    ).allMatches(source).map((m) => m.group(1)).toList();
    expect(imports, <String>[
      'package:flutter/widgets.dart',
      gen.defaultThemeImport,
      'package:flutter_shadcn_kit/registry/theme/color_tokens.dart',
      'package:flutter_shadcn_kit/registry/theme/tokens.dart',
    ]);
    // No control flow and no types of its own: declarations plus one factory.
    final code = source
        .split('\n')
        .where((line) => !line.trimLeft().startsWith('//'))
        .toList();
    expect(
      RegExp(r'\bif\b|\bfor\b|\bwhile\b|\bclass\b').hasMatch(code.join('\n')),
      isFalse,
    );
    expect(code.where((l) => l.startsWith('const ')).length, 3);
    expect(code.where((l) => l.startsWith('final ')).length, 2);
    expect(code.where((l) => l.startsWith('ShadcnThemeData build')).length, 1);
    expect(source, contains('ShadcnThemeData buildAmberMinimalTheme('));
  });

  test('a preset without fonts emits no font block', () {
    final source = gen.ThemeValues.fromJson(
      readJsonMap('$themesDir/claude.json'),
    ).toDartSource();
    expect(source, isNot(contains('ShadcnFonts')));
    expect(source, isNot(contains('fonts:')));
    expect(source, contains('ShadcnThemeData buildClaudeTheme(Brightness'));
  });

  test('the theme import can be redirected with --theme-import', () {
    final source = gen.ThemeValues.fromJson(
      readJsonMap('$themesDir/mono.json'),
    ).toDartSource(themeImport: 'package:my_app/ui/theme.dart');
    expect(source, contains("import 'package:my_app/ui/theme.dart';"));
    expect(source, contains("import 'package:my_app/ui/color_tokens.dart';"));
    expect(source, contains("import 'package:my_app/ui/tokens.dart';"));
    expect(source, isNot(contains(gen.defaultThemeImport)));
  });

  test('siblingUri keeps the import directory', () {
    expect(gen.siblingUri('a/b/theme.dart', 'tokens.dart'), 'a/b/tokens.dart');
    expect(gen.siblingUri('theme.dart', 'tokens.dart'), 'tokens.dart');
  });

  test('camelCase produces valid identifiers for every preset id', () {
    expect(gen.camelCase('amber-minimal'), 'amberMinimal');
    expect(gen.camelCase('doom-64'), 'doom64');
    expect(gen.camelCase('t3-chat'), 't3Chat');
    for (final file in presetFiles()) {
      final id = file.replaceAll('.json', '');
      expect(gen.camelCase(id), matches(RegExp(r'^[a-z][a-zA-Z0-9]*$')));
    }
  });
}
