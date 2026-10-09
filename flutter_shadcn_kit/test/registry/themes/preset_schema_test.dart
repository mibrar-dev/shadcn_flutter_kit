// Every one of the 43 canonical presets must satisfy
// `lib/registry/themes/themes.schema.json`, and the generator's token list
// must agree with the schema (so the emitted `ShadcnColors` arguments can never
// drift from the validated key set).

import 'package:flutter_test/flutter_test.dart';

import '../../../tool/rearch/gen_app_theme.dart' as gen;
import 'schema_check.dart';

void main() {
  final schema = readJsonMap('$themesDir/themes.schema.json');
  final index = readJsonMap('$themesDir/index.json');
  final files = presetFiles();

  test('all 43 presets are present', () {
    expect(files.length, 43);
    expect(index['count'], 43);
    expect((index['themes']! as List).length, 43);
  });

  test('every preset validates against themes.schema.json', () {
    final failures = <String>[];
    for (final file in files) {
      final preset = readJsonMap('$themesDir/$file');
      final errors = validateSchema(preset, schema);
      if (errors.isNotEmpty) {
        failures.add('$file: ${errors.join('; ')}');
      }
      expect(preset['id'], file.replaceAll('.json', ''), reason: file);
    }
    expect(failures, isEmpty);
  });

  test('index.json lists every preset file exactly once', () {
    final listed =
        (index['themes']! as List)
            .cast<Map<String, Object?>>()
            .map((entry) => entry['file']! as String)
            .toList()
          ..sort();
    expect(listed, files);
    for (final entry
        in (index['themes']! as List).cast<Map<String, Object?>>()) {
      final preset = readJsonMap('$themesDir/${entry['file']}');
      expect(entry['id'], preset['id']);
      expect(entry['name'], preset['name']);
    }
  });

  test('generator token list equals the schema colour key set', () {
    final required =
        ((schema[r'$defs']! as Map)['colorMap']! as Map)['required']! as List;
    expect(gen.colorTokenKeys, required.cast<String>());
  });

  test('colours keep their alpha channel', () {
    // 32 colour tokens per mode plus two shadow colours, all `#RRGGBB[AA]`.
    var withAlpha = 0;
    for (final file in files) {
      final preset = readJsonMap('$themesDir/$file');
      final hexes = <String>[];
      for (final mode in const ['light', 'dark']) {
        final colors = (preset[mode]! as Map).cast<String, Object?>();
        expect(colors.keys.toSet(), gen.colorTokenKeys.toSet(), reason: file);
        hexes.addAll(colors.values.map((value) => value! as String));
      }
      final shadow = (preset['shadow']! as Map).cast<String, Object?>();
      for (final mode in const ['light', 'dark']) {
        hexes.add((shadow[mode]! as Map)['color']! as String);
      }
      for (final value in hexes) {
        expect(
          RegExp(r'^#[0-9A-F]{6}([0-9A-F]{2})?$').hasMatch(value),
          isTrue,
          reason: '$file $value',
        );
        if (value.length == 9) withAlpha += 1;
      }
    }
    // Alpha is a first class part of the format, not an accident of the data:
    // tweakcn stores `hsl(0 0% 20% / 0.1)` for graphite, and the converter kept
    // it instead of flattening it to `#333333`.
    expect(withAlpha, greaterThan(0));
    expect(
      ((readJsonMap('$themesDir/graphite.json')['shadow']! as Map)
              .cast<String, Object?>()['light']!
          as Map)['color'],
      '#3333331A',
    );
  });

  test('no preset stores a derived shadow size', () {
    for (final file in files) {
      final shadow = (readJsonMap('$themesDir/$file')['shadow']! as Map)
          .cast<String, Object?>();
      expect(shadow.keys.toSet(), <String>{'light', 'dark'}, reason: file);
      for (final mode in const ['light', 'dark']) {
        expect((shadow[mode]! as Map).keys.toSet(), <String>{
          'color',
          'opacity',
          'blur',
          'spread',
          'offsetX',
          'offsetY',
        }, reason: '$file $mode');
      }
    }
  });

  test('shadowsDerived marks exactly the presets without CLI atoms', () {
    final derived = <String>[];
    for (final file in files) {
      final preset = readJsonMap('$themesDir/$file');
      expect(
        preset['shadowsDerived'],
        anyOf('cli', 'from-legacy'),
        reason: file,
      );
      if (preset['shadowsDerived'] == 'from-legacy') {
        derived.add(preset['id']! as String);
      }
    }
    expect(derived, <String>[
      'caffeine',
      'candyland',
      'claude',
      'modern-minimal',
      'nature',
      // `neutral` has no CLI atoms either; its atoms come from shadcn's
      // `--shadow-sm` in themes-css/neutral.css (documented in P6-D3 round 3).
      'neutral',
      'northern-lights',
      'starry-night',
      't3-chat',
    ]);
  });

  test('no preset falls back to a light map in dark mode', () {
    // Regression guard for the P2-D migration bug where `vercel`'s dark map
    // was a byte-for-byte copy of its light map: a preset whose light and dark
    // colour maps are identical is always a data error, never a design.
    final identical = <String>[];
    for (final file in files) {
      final preset = readJsonMap('$themesDir/$file');
      if (preset['light'] == preset['dark']) {
        identical.add(file);
      }
    }
    expect(identical, isEmpty, reason: 'light == dark for: $identical');
  });

  test('rem and em units survive the migration', () {
    // claude: legacy spacing.base 3.84px and tracking 0 -> 0.24rem / 0em.
    final claude = readJsonMap('$themesDir/claude.json');
    expect(claude['spacing'], 0.24);
    expect((claude['tracking']! as Map)['normal'], 0);
    expect(claude['radius'], 0.5);
    // notebook: legacy tracking 0.5px -> 0.03125em.
    final notebook = readJsonMap('$themesDir/notebook.json');
    expect((notebook['tracking']! as Map)['normal'], 0.03125);
    // sage-garden: legacy spacing.base 3.68px -> 0.23rem.
    expect(readJsonMap('$themesDir/sage-garden.json')['spacing'], 0.23);
  });
}
