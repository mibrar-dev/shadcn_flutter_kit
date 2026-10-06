// One-off converter: legacy preset JSON + tweakcn CLI atoms ->
// lib/registry_next/themes/<id>.json (schemaVersion 2) + index.json.
//
// Usage:
//   dart run tool/rearch/migrate_presets.dart [--legacy <dir>] [--cli <file>]
//       [--out <dir>] [--report <file>] [--help]
//
// Provenance rules, all verified against the data (see
// rearch/reports/P2D_PRESETS.md):
//
// * colours <- legacy JSON. The CLI colour maps are only cross-checked, never
//   trusted: vercel's CLI maps are literally empty.
// * shadow atoms <- CLI tweakcn atoms. `darkTokens` overrides `lightTokens` per
//   atom and an empty `darkTokens` means "same as light".
// * fonts <- CLI (authoritative per the brief). The light side wins because
//   fonts are mode-independent (QA P1-D); the 9 dark font overrides are
//   dropped and reported.
// * radius / spacing / tracking <- legacy JSON light side, converted to
//   unitless rem (radius) and rem/em (spacing, tracking). The CLI agrees on
//   every value it defines and any disagreement is reported.
// * a preset with no CLI shadow atoms (8 of 42, not the 3 predicted) gets its
//   atoms recovered from the legacy single shadow entry and is flagged
//   `"shadowsDerived": "from-legacy"`.
//
// Re-running is idempotent: the output depends only on the two read-only inputs.

import 'dart:convert';
import 'dart:io';

import 'package:analyzer/dart/ast/ast.dart';

import 'gen_app_theme.dart';
import 'src/cli_args.dart';
import 'src/dart_parse.dart';

const String _usage =
    'Usage: dart run tool/rearch/migrate_presets.dart [--legacy <dir>]\n'
    '         [--cli <file>] [--out <dir>] [--report <file>] [--help]\n'
    '  --legacy <dir>    schemaVersion 1 preset directory\n'
    '  --cli <file>      tweakcn preset_theme_data.dart\n'
    '  --out <dir>       canonical preset output directory\n'
    '  --report <file>   Write the JSON cross-check report here\n'
    '  --help            Print this help';

/// One entry of `registryThemePresetsData` in the CLI repository.
class CliPreset {
  CliPreset({
    required this.id,
    required this.name,
    required this.light,
    required this.dark,
    required this.lightTokens,
    required this.darkTokens,
  });

  /// Preset id and human readable name.
  final String id, name;

  /// `AARRGGBB` colour tokens, keyed by token name.
  final Map<String, String> light, dark;

  /// CSS value strings keyed by `fontSans`, `radius`, `shadowBlur`, ...
  final Map<String, String> lightTokens, darkTokens;
}

/// The six atom keys of a `lightTokens`/`darkTokens` map.
const List<String> shadowAtomKeys = <String>[
  'shadowColor',
  'shadowOpacity',
  'shadowBlur',
  'shadowSpread',
  'shadowOffsetX',
  'shadowOffsetY',
];

/// Reads `registryThemePresetsData` with the analyzer AST (never with regex).
List<CliPreset> readCliPresets(String path) {
  final file = parseDartFile(path, path);
  if (file.syntaxErrorCount > 0) {
    throw FormatException('$path has ${file.syntaxErrorCount} syntax error(s)');
  }
  final presets = <CliPreset>[];
  for (final declaration in file.unit.declarations) {
    if (declaration is! TopLevelVariableDeclaration) continue;
    final variables = declaration.variables.variables;
    if (variables.length != 1) continue;
    final variable = variables.first;
    if (variable.name.lexeme != 'registryThemePresetsData') continue;
    final list = variable.initializer;
    if (list is! ListLiteral) {
      throw FormatException('registryThemePresetsData is not a list literal');
    }
    for (final element in list.elements) {
      // Unresolved parsing yields a MethodInvocation for `Foo(...)` and an
      // InstanceCreationExpression only when the type is already known.
      final ArgumentList arguments;
      if (element is InstanceCreationExpression) {
        arguments = element.argumentList;
      } else if (element is MethodInvocation) {
        arguments = element.argumentList;
      } else {
        throw FormatException('unexpected list element: ${element.toSource()}');
      }
      final named = <String, Expression>{};
      for (final argument in arguments.arguments) {
        if (argument is! NamedExpression) {
          throw FormatException('unexpected argument: ${argument.toSource()}');
        }
        named[argument.name.label.name] = argument.expression;
      }
      presets.add(
        CliPreset(
          id: _cliString(named, 'id', path),
          name: _cliString(named, 'name', path),
          light: _cliMap(named, 'light', path),
          dark: _cliMap(named, 'dark', path),
          lightTokens: _cliMap(named, 'lightTokens', path),
          darkTokens: _cliMap(named, 'darkTokens', path),
        ),
      );
    }
  }
  if (presets.isEmpty) throw FormatException('no presets found in $path');
  return presets;
}

String _cliString(Map<String, Expression> named, String key, String path) {
  final value = named[key];
  if (value is! SimpleStringLiteral) {
    throw FormatException('$path: $key is not a string literal');
  }
  return value.value;
}

Map<String, String> _cliMap(
  Map<String, Expression> named,
  String key,
  String path,
) {
  final value = named[key];
  if (value is! SetOrMapLiteral) {
    throw FormatException('$path: $key is not a map literal');
  }
  final result = <String, String>{};
  for (final element in value.elements) {
    if (element is! MapLiteralEntry) {
      throw FormatException('$path: $key has a non entry element');
    }
    final key0 = element.key;
    final value0 = element.value;
    if (key0 is! SimpleStringLiteral || value0 is! SimpleStringLiteral) {
      throw FormatException('$path: $key has a non string entry');
    }
    result[key0.value] = value0.value;
  }
  return result;
}

final RegExp _length = RegExp(r'^(-?\d*\.?\d+)(px|rem)$');

final RegExp _hsl = RegExp(
  r'^hsl\(\s*(-?[\d.]+)(?:deg)?\s+([\d.]+)%\s+([\d.]+)%'
  r'(?:\s*/\s*([\d.]+)(%?))?\s*\)$',
);

final RegExp _rgba = RegExp(
  r'^rgba\(\s*([\d.]+)\s*,\s*([\d.]+)\s*,\s*([\d.]+)\s*'
  r'(?:,\s*([\d.]+))?\s*\)$',
);

/// Parses a CSS length to logical pixels (`8px`, `0.25rem`, `-1px`, `0rem`).
double cssLengthToPx(String value) {
  final match = _length.firstMatch(value.trim());
  if (match == null) throw FormatException('Not a px/rem length: $value');
  final amount = double.parse(match.group(1)!);
  return match.group(2) == 'rem' ? amount * 16 : amount;
}

/// Parses a unitless CSS number, accepting `normal` as zero.
double cssNumber(String value) {
  final text = value.trim();
  if (text == 'normal') return 0;
  final parsed = double.tryParse(text);
  if (parsed == null) throw FormatException('Not a number: $value');
  return parsed;
}

/// Parses a CSS colour (`#abc`, `#RRGGBB`, `#RRGGBBAA`, `hsl(...)`,
/// `rgba(...)`) to 32-bit ARGB with the CSS Color 4 conversion (clamped to the
/// sRGB gamut, alpha 0..1 -> byte).
int cssColorToArgb(String value) {
  final text = value.trim().toLowerCase();
  if (text.startsWith('#')) {
    var digits = text.substring(1);
    if (digits.length == 3 || digits.length == 4) {
      digits = digits.split('').map((c) => '$c$c').join();
    }
    if (digits.length != 6 && digits.length != 8) {
      throw FormatException('Not a hex colour: $value');
    }
    final alpha = digits.length == 8
        ? int.parse(digits.substring(6, 8), radix: 16)
        : 0xFF;
    return (alpha << 24) | int.parse(digits.substring(0, 6), radix: 16);
  }
  final rgba = _rgba.firstMatch(text);
  if (rgba != null) {
    return _argb(
      _channel(rgba.group(1)!),
      _channel(rgba.group(2)!),
      _channel(rgba.group(3)!),
      double.tryParse(rgba.group(4) ?? '') ?? 1,
    );
  }
  final hsl = _hsl.firstMatch(text);
  if (hsl == null) throw FormatException('Not a CSS colour: $value');
  final hue = double.parse(hsl.group(1)!);
  final saturation = double.parse(hsl.group(2)!) / 100;
  final lightness = double.parse(hsl.group(3)!) / 100;
  final alpha = hsl.group(4) == null
      ? 1.0
      : double.parse(hsl.group(4)!) * (hsl.group(5) == '%' ? 0.01 : 1);
  final chroma = (1 - (2 * lightness - 1).abs()) * saturation;
  final second = chroma * (1 - ((hue / 60) % 2 - 1).abs());
  final offset = lightness - chroma / 2;
  final table = <List<double>>[
    [chroma, second, 0],
    [second, chroma, 0],
    [0, chroma, second],
    [0, second, chroma],
    [second, 0, chroma],
    [chroma, 0, second],
  ];
  final rgb = table[(hue / 60).floor() % 6];
  int channel(double part) => ((part + offset) * 255).round().clamp(0, 255);
  return _argb(channel(rgb[0]), channel(rgb[1]), channel(rgb[2]), alpha);
}

int _channel(String value) => double.parse(value).round().clamp(0, 255);

int _argb(int r, int g, int b, double alpha) {
  return ((alpha * 255).round().clamp(0, 255) << 24) | (r << 16) | (g << 8) | b;
}

/// Rounds an opacity to 6 decimals: enough for `ShadowScale.derive` to land on
/// the exact legacy alpha byte, without dragging 17-digit doubles into the JSON.
double _opacity(double value) => (value * 1e6).round() / 1e6;

/// Keeps integral numbers integral in the JSON output (`radius: 0`, not `0.0`).
Object _num3(double value) =>
    value == value.roundToDouble() ? value.round() : value;

/// Legacy colours are `0xAARRGGBB` strings; canonical form is `#RRGGBBAA`.
int parseLegacyColor(String value) {
  final text = value.startsWith('0x') || value.startsWith('0X')
      ? value.substring(2)
      : value;
  final argb = int.parse(text.padLeft(8, 'F'), radix: 16);
  return ((argb >> 24) << 24) | (argb & 0xFFFFFF);
}

/// CLI letter spacing in em (`0.025em`, `0.5px`, `0rem`, `normal`).
double _cliTrackingEm(String value) {
  final text = value.trim();
  if (text.endsWith('rem')) return cssLengthToPx(text) / 16;
  if (text.endsWith('em')) {
    return double.parse(text.substring(0, text.length - 2));
  }
  if (text.endsWith('px')) return cssLengthToPx(text) / 16;
  return cssNumber(text);
}

Map<String, Object?> _object(Object? value, String what) {
  if (value is! Map) throw FormatException('$what is not an object: $value');
  return <String, Object?>{
    for (final entry in value.entries) entry.key.toString(): entry.value,
  };
}

String _string(Map<String, Object?> map, String key) {
  final value = map[key];
  if (value is! String) throw FormatException('$key is not a string: $value');
  return value;
}

double _num2(Map<String, Object?> map, String key) {
  final value = map[key];
  if (value is! num) throw FormatException('$key is not a number: $value');
  return value.toDouble();
}

/// The legacy `shadows` block holds a list per size; all eight lists are
/// byte-identical, so the first entry of the `shadow` size is the base value.
Map<String, Object?> _legacyShadowEntry(Map<String, Object?> legacyTokens) {
  final shadows = _object(legacyTokens['shadows'], 'legacy shadows');
  final list = shadows['shadow'];
  if (list is! List || list.isEmpty) {
    throw FormatException('legacy shadows.shadow is not a non empty list');
  }
  return _object(list.first, 'legacy shadow');
}

/// Recovers atoms from the legacy single shadow entry (the bug the new schema
/// removes is that all eight sizes hold this same entry).
ShadowAtoms _legacyShadowAtoms(Map<String, Object?> legacyTokens) {
  final entry = _legacyShadowEntry(legacyTokens);
  final argb = parseLegacyColor(_string(entry, 'color'));
  return ShadowAtoms(
    color: (argb & 0xFFFFFF) | 0xFF000000,
    opacity: _opacity(((argb >> 24) & 0xFF) / 255),
    blur: _num2(entry, 'blur'),
    spread: _num2(entry, 'spread'),
    offsetX: _num2(entry, 'x'),
    offsetY: _num2(entry, 'y'),
  );
}

/// Comparable snapshot of the recovered atoms (ShadowAtoms has no `==`, and the
/// raw entries hold a nested list whose `==` is identity).
String _legacyShadowKey(Map<String, Object?> legacyTokens) {
  final atoms = _legacyShadowAtoms(legacyTokens);
  return <double>[
    atoms.color.toDouble(),
    atoms.opacity,
    atoms.blur,
    atoms.spread,
    atoms.offsetX,
    atoms.offsetY,
  ].join(',');
}

/// Dark legacy atoms win per field so a preset with distinct legacy shadows
/// keeps them (they are identical in every recovered preset today).
ShadowAtoms _mergeLegacyAtoms(ShadowAtoms light, ShadowAtoms dark) =>
    ShadowAtoms(
      color: dark.color != light.color ? dark.color : light.color,
      opacity: dark.opacity != light.opacity ? dark.opacity : light.opacity,
      blur: dark.blur != light.blur ? dark.blur : light.blur,
      spread: dark.spread != light.spread ? dark.spread : light.spread,
      offsetX: dark.offsetX != light.offsetX ? dark.offsetX : light.offsetX,
      offsetY: dark.offsetY != light.offsetY ? dark.offsetY : light.offsetY,
    );

/// Reads atoms from a CLI token map, or null when any of the six is absent.
ShadowAtoms? _mergeAtoms(
  Map<String, String> lightTokens,
  Map<String, String> darkTokens,
) {
  String? pick(String key) => darkTokens[key] ?? lightTokens[key];
  if (shadowAtomKeys.any((key) => pick(key) == null)) return null;
  return ShadowAtoms(
    color: cssColorToArgb(pick('shadowColor')!),
    opacity: _opacity(cssNumber(pick('shadowOpacity')!)),
    blur: cssLengthToPx(pick('shadowBlur')!),
    spread: cssLengthToPx(pick('shadowSpread')!),
    offsetX: cssLengthToPx(pick('shadowOffsetX')!),
    offsetY: cssLengthToPx(pick('shadowOffsetY')!),
  );
}

Map<String, Object?> _atomsJson(ShadowAtoms atoms) => <String, Object?>{
  'color': formatHexColor(atoms.color),
  'opacity': _num3(atoms.opacity),
  'blur': _num3(atoms.blur),
  'spread': _num3(atoms.spread),
  'offsetX': _num3(atoms.offsetX),
  'offsetY': _num3(atoms.offsetY),
};

/// One migrated preset plus the provenance notes gathered for it.
class PresetBuild {
  PresetBuild({
    required this.document,
    required this.notes,
    required this.fonts,
    required this.legacyDarkShadowDiffers,
  });

  /// The canonical preset document, in schema key order.
  final Map<String, Object?> document;

  /// Human readable provenance and mismatch notes.
  final List<String> notes;

  /// Font slots that were present, e.g. `sans`, `mono`.
  final List<String> fonts;

  /// Whether the legacy JSON gave dark a different shadow than light.
  final bool legacyDarkShadowDiffers;
}

/// Converts one legacy preset plus its CLI atoms into the canonical document.
PresetBuild buildPreset(Map<String, Object?> legacy, CliPreset cli) {
  final notes = <String>[];
  final legacyLight = _object(legacy['light'], 'legacy light');
  final legacyDark = _object(legacy['dark'], 'legacy dark');
  final tokens = _object(legacy['tokens'], 'legacy tokens');
  final legacyLightTokens = _object(tokens['light'], 'legacy tokens.light');
  final legacyDarkTokens = _object(tokens['dark'], 'legacy tokens.dark');

  final light = <String, Object?>{};
  final dark = <String, Object?>{};
  for (final key in colorTokenKeys) {
    light[key] = formatHexColor(parseLegacyColor(_string(legacyLight, key)));
    dark[key] = formatHexColor(parseLegacyColor(_string(legacyDark, key)));
  }
  _crossCheckColors(cli, light, dark, notes);

  final radius = _num2(legacyLightTokens, 'radius');
  final spacingPx = _num2(
    _object(legacyLightTokens['spacing'], 'legacy spacing'),
    'base',
  );
  final trackingPx = _num2(
    _object(legacyLightTokens['tracking'], 'legacy tracking'),
    'normal',
  );
  _crossCheckScalar(
    cli,
    'radius',
    cssLengthToPx(cli.lightTokens['radius']!) / 16,
    radius,
    notes,
  );
  for (final token in const ['spacing', 'tracking']) {
    final cliValue = cli.lightTokens[token];
    if (cliValue == null) continue;
    _crossCheckScalar(
      cli,
      token,
      token == 'spacing'
          ? cssLengthToPx(cliValue) / 16
          : _cliTrackingEm(cliValue),
      token == 'spacing' ? spacingPx / 16 : trackingPx / 16,
      notes,
    );
  }
  final darkRadius = _num2(legacyDarkTokens, 'radius');
  if (darkRadius != radius) {
    notes.add('legacy dark radius $darkRadius dropped (radius is per preset)');
  }

  final fonts = <String, Object?>{};
  final present = <String>[];
  for (final slot in const ['sans', 'serif', 'mono']) {
    final cliKey = 'font${slot[0].toUpperCase()}${slot.substring(1)}';
    final value = cli.lightTokens[cliKey];
    if (value == null) continue;
    fonts[slot] = value;
    present.add(slot);
    final legacyValue = legacyLightTokens[cliKey];
    if (legacyValue != null && legacyValue != value) {
      notes.add('$cliKey differs: legacy "$legacyValue" cli "$value"');
    }
  }
  for (final darkFont in cli.darkTokens.entries) {
    if (darkFont.key.startsWith('font') &&
        darkFont.value != cli.lightTokens[darkFont.key]) {
      notes.add(
        'dark ${darkFont.key} "${darkFont.value}" dropped '
        '(fonts are mode-independent)',
      );
    }
  }

  final cliLightAtoms = _mergeAtoms(cli.lightTokens, const {});
  final cliDarkAtoms = _mergeAtoms(cli.lightTokens, cli.darkTokens);
  final lightAtoms = cliLightAtoms ?? _legacyShadowAtoms(legacyLightTokens);
  final darkAtoms =
      cliDarkAtoms ??
      _mergeLegacyAtoms(
        _legacyShadowAtoms(legacyLightTokens),
        _legacyShadowAtoms(legacyDarkTokens),
      );
  if (cliLightAtoms == null) {
    notes.add('no CLI shadow atoms; recovered from the legacy shadow entry');
  }
  _crossCheckShadow(legacyLightTokens, lightAtoms, notes);

  return PresetBuild(
    document: <String, Object?>{
      r'$schema': './themes.schema.json',
      'id': cli.id,
      'name': cli.name,
      'schemaVersion': 2,
      'light': light,
      'dark': dark,
      if (fonts.isNotEmpty) 'fonts': fonts,
      'radius': _num3(radius),
      'spacing': _num3(spacingPx / 16),
      'tracking': <String, Object?>{'normal': _num3(trackingPx / 16)},
      'shadow': <String, Object?>{
        'light': _atomsJson(lightAtoms),
        'dark': _atomsJson(darkAtoms),
      },
      'shadowsDerived': cliLightAtoms == null ? 'from-legacy' : 'cli',
    },
    notes: notes,
    fonts: present,
    legacyDarkShadowDiffers:
        _legacyShadowKey(legacyDarkTokens) !=
        _legacyShadowKey(legacyLightTokens),
  );
}

/// Compares every migrated colour with the CLI colour map for the same token.
void _crossCheckColors(
  CliPreset cli,
  Map<String, Object?> light,
  Map<String, Object?> dark,
  List<String> notes,
) {
  if (cli.light.isEmpty && cli.dark.isEmpty) {
    notes.add('CLI colour maps are empty; colours taken from the legacy JSON');
    return;
  }
  for (final side in const ['light', 'dark']) {
    final cliColors = side == 'light' ? cli.light : cli.dark;
    final migrated = side == 'light' ? light : dark;
    for (final key in colorTokenKeys) {
      final cliValue = cliColors[key];
      if (cliValue == null) {
        notes.add('CLI $side has no $key');
        continue;
      }
      final cliArgb = int.parse(cliValue.padLeft(8, 'F'), radix: 16);
      if (formatHexColor(cliArgb) != migrated[key]) {
        notes.add(
          'colour mismatch $side.$key: cli #$cliValue legacy ${migrated[key]}',
        );
      }
    }
  }
}

void _crossCheckScalar(
  CliPreset cli,
  String key,
  double cliValue,
  double legacyValue,
  List<String> notes,
) {
  if ((cliValue - legacyValue).abs() > 1e-9) {
    notes.add(
      'token mismatch ${cli.id}.$key: cli $cliValue legacy $legacyValue',
    );
  }
}

/// Compares the migrated atoms with the legacy single shadow entry, i.e. with
/// what today's app actually renders for the `shadow` size. Alpha is compared
/// as a byte, so rounding inside `ShadowScale.derive` cannot produce noise.
void _crossCheckShadow(
  Map<String, Object?> legacyTokens,
  ShadowAtoms atoms,
  List<String> notes,
) {
  final entry = _legacyShadowEntry(legacyTokens);
  final derived = _argb(
    (atoms.color >> 16) & 0xFF,
    (atoms.color >> 8) & 0xFF,
    atoms.color & 0xFF,
    ((atoms.color >> 24) & 0xFF) / 255 * atoms.opacity,
  );
  if (derived != parseLegacyColor(_string(entry, 'color'))) {
    notes.add(
      'shadow color differs from legacy: legacy '
      '${formatHexColor(parseLegacyColor(_string(entry, 'color')))} '
      'migrated ${formatHexColor(derived)}',
    );
  }
  final geometry = <String, double>{
    'x': atoms.offsetX,
    'y': atoms.offsetY,
    'blur': atoms.blur,
    'spread': atoms.spread,
  };
  for (final field in geometry.entries) {
    final legacy = _num2(entry, field.key);
    if ((field.value - legacy).abs() > 1e-9) {
      notes.add(
        'shadow ${field.key} differs from legacy: legacy $legacy '
        'migrated ${field.value}',
      );
    }
  }
}

/// `flutter_shadcn_kit` root, derived from this script's location.
String _appRoot() {
  final parts = Platform.script.toFilePath().split(Platform.pathSeparator);
  return parts.sublist(0, parts.length - 3).join(Platform.pathSeparator);
}

/// Encodes with the key order of the inserted maps preserved.
String _encode(Object? value) =>
    '${const JsonEncoder.withIndent('  ').convert(value)}\n';

void main(List<String> args) {
  final cli = CliArgs.parse(
    args,
    valueOptions: <String>{'legacy', 'cli', 'out', 'report'},
  );
  if (cli.flag('help')) {
    stdout.writeln(_usage);
    return;
  }
  if (cli.errors.isNotEmpty) {
    for (final error in cli.errors) {
      stderr.writeln(error);
    }
    stderr.writeln(_usage);
    exitCode = 64;
    return;
  }
  final appRoot = _appRoot();
  final legacyDir =
      cli.value('legacy') ?? '$appRoot/lib/registry/themes_preset';
  final cliFile =
      cli.value('cli') ??
      '$appRoot/../../shadcn_flutter_cli/lib/registry/shared/theme/'
          'preset_theme_data.dart';
  final outDir = cli.value('out') ?? '$appRoot/lib/registry_next/themes';
  final legacyFiles =
      Directory(legacyDir)
          .listSync()
          .whereType<File>()
          .where((f) => f.path.endsWith('.json'))
          .toList()
        ..sort((a, b) => a.path.compareTo(b.path));
  if (legacyFiles.isEmpty) {
    stderr.writeln('No legacy presets in $legacyDir');
    exitCode = 66;
    return;
  }

  final List<CliPreset> cliPresets;
  try {
    cliPresets = readCliPresets(cliFile);
  } on Object catch (error) {
    stderr.writeln('Cannot read CLI atoms from $cliFile: $error');
    exitCode = 66;
    return;
  }
  final byId = <String, CliPreset>{for (final p in cliPresets) p.id: p};

  final index = <Map<String, Object?>>[];
  final report = <String, Object?>{
    'legacyDir': legacyDir,
    'cliFile': cliFile,
    'outDir': outDir,
    'presets': <Map<String, Object?>>[],
  };
  final reportPresets = report['presets']! as List<Map<String, Object?>>;
  for (final file in legacyFiles) {
    final legacy = _object(jsonDecode(file.readAsStringSync()), file.path);
    final id = _string(legacy, 'id');
    final cliPreset = byId[id];
    if (cliPreset == null) {
      stderr.writeln('No CLI atoms for $id');
      exitCode = 65;
      return;
    }
    final build = buildPreset(legacy, cliPreset);
    File('$outDir/$id.json').writeAsStringSync(_encode(build.document));
    index.add(<String, Object?>{
      'id': id,
      'name': _string(legacy, 'name'),
      'file': '$id.json',
    });
    reportPresets.add(<String, Object?>{
      'id': id,
      'shadowsDerived': build.document['shadowsDerived'],
      'fonts': build.fonts,
      'legacyDarkShadowDiffers': build.legacyDarkShadowDiffers,
      'notes': build.notes,
    });
    for (final note in build.notes) {
      stdout.writeln('[$id] $note');
    }
  }
  index.sort((a, b) => (a['id']! as String).compareTo(b['id']! as String));
  File('$outDir/index.json').writeAsStringSync(
    _encode(<String, Object?>{
      'schemaVersion': 2,
      'count': index.length,
      'themes': index,
    }),
  );
  final reportPath = cli.value('report');
  if (reportPath != null) {
    File(reportPath).writeAsStringSync(_encode(report));
    stdout.writeln('report written: $reportPath');
  }
  stdout.writeln(
    '${index.length} presets written to $outDir '
    '(legacy $legacyDir, cli atoms $cliFile)',
  );
}
