// CLI: render one canonical preset (lib/registry_next/themes/<id>.json,
// schemaVersion 2) as a values-only `app_theme.dart` for the theme layer.
//
// Usage:
//   dart run tool/rearch/gen_app_theme.dart <preset.json> <out.dart>
//       [--theme-import <uri>] [--help]
//   --theme-import <uri>   Library that exports `ShadcnThemeData`. Its
//                          siblings `color_tokens.dart` and `tokens.dart` are
//                          imported as well, because `ShadcnColors`,
//                          `ShadcnTokens`, `ShadcnFonts` and `ShadowScale`
//                          live there. `package:flutter/widgets.dart` is
//                          always imported for `Color` and `Brightness`.
//
// The file this writes is deliberately free of logic: one const colour map
// per brightness, one `final` token block per brightness (ShadowScale.derive
// is a factory, so the blocks cannot be const), an optional const font block
// and one `build<Id>Theme(Brightness)` factory. Output is `dart format` clean:
// every construct is emitted on one line when it fits in 80 columns and
// exploded with a trailing comma otherwise, which is exactly what the tall
// style formatter produces.
//
// This library holds no Flutter import (it must run on the plain Dart VM), so
// the values stay numbers and strings. `test/registry_next/themes` parses the
// emitted file back into real `ShadcnColors` objects.

import 'dart:convert';
import 'dart:io';

import 'src/cli_args.dart';

/// Default library that exports `ShadcnThemeData` in the kit itself.
const String defaultThemeImport =
    'package:flutter_shadcn_kit/registry_next/theme/theme.dart';

/// The 32 colour tokens in `ShadcnColors` declaration order (PLAN 6.1).
///
/// Kept as data so the emitted argument order matches the constructor. The
/// test asserts this list equals `themes.schema.json` `$defs.colorMap.required`
/// and the key set of all 42 presets, so the three cannot drift.
const List<String> colorTokenKeys = <String>[
  'background',
  'foreground',
  'card',
  'cardForeground',
  'popover',
  'popoverForeground',
  'primary',
  'primaryForeground',
  'secondary',
  'secondaryForeground',
  'muted',
  'mutedForeground',
  'accent',
  'accentForeground',
  'destructive',
  'destructiveForeground',
  'border',
  'input',
  'ring',
  'chart1',
  'chart2',
  'chart3',
  'chart4',
  'chart5',
  'sidebar',
  'sidebarForeground',
  'sidebarPrimary',
  'sidebarPrimaryForeground',
  'sidebarAccent',
  'sidebarAccentForeground',
  'sidebarBorder',
  'sidebarRing',
];

/// Matches the `colorToken` schema pattern (`#RRGGBB` or `#RRGGBBAA`).
final RegExp hexColorPattern = RegExp(r'^#[0-9A-Fa-f]{6}([0-9A-Fa-f]{2})?$');

/// Parses `#RRGGBB` / `#RRGGBBAA` into a 32-bit ARGB int.
///
/// The alpha byte defaults to `FF`; it is never dropped when present, which is
/// what the legacy presets got wrong for shadcn's 10%-alpha dark border.
int parseHexColor(String value) {
  if (!hexColorPattern.hasMatch(value)) {
    throw FormatException('Not a #RRGGBB[AA] colour: $value');
  }
  final digits = value.substring(1);
  final rgb = int.parse(digits.substring(0, 6), radix: 16);
  final alpha = digits.length == 8
      ? int.parse(digits.substring(6, 8), radix: 16)
      : 0xFF;
  return (alpha << 24) | rgb;
}

/// Formats ARGB as `#RRGGBB`, or `#RRGGBBAA` when the colour is translucent.
String formatHexColor(int argb) {
  final alpha = (argb >> 24) & 0xFF;
  final rgb = (argb & 0xFFFFFF).toRadixString(16).padLeft(6, '0');
  if (alpha == 0xFF) return '#${rgb.toUpperCase()}';
  final a = alpha.toRadixString(16).padLeft(2, '0').toUpperCase();
  return '#${rgb.toUpperCase()}$a';
}

/// The six base shadow atoms for one brightness, all lengths in px.
///
/// [color] is ARGB; `ShadowScale.derive` multiplies its alpha by [opacity], so
/// a colour that already carries alpha (tweakcn stores `hsl(330 70% 30% /
/// 0.12)`) stays correct instead of being overwritten.
class ShadowAtoms {
  const ShadowAtoms({
    required this.color,
    required this.opacity,
    required this.blur,
    required this.spread,
    required this.offsetX,
    required this.offsetY,
  });

  /// Reads a `shadowAtoms` schema object.
  factory ShadowAtoms.fromJson(Object? value) {
    final map = _stringKeyed(value, 'shadow atoms');
    return ShadowAtoms(
      color: parseHexColor(_string(map, 'color')),
      opacity: _num2(map, 'opacity'),
      blur: _num2(map, 'blur'),
      spread: _num2(map, 'spread'),
      offsetX: _num2(map, 'offsetX'),
      offsetY: _num2(map, 'offsetY'),
    );
  }

  /// ARGB shadow colour.
  final int color;

  /// Base alpha in 0..1.
  final double opacity;

  /// Blur radius in px.
  final double blur;

  /// Spread radius in px.
  final double spread;

  /// Horizontal offset in px.
  final double offsetX;

  /// Vertical offset in px.
  final double offsetY;
}

/// One preset, normalised: ARGB colours, rem/em numbers, base shadow atoms.
///
/// `radius` and `spacing` stay in rem and `tracking` in em; the generated Dart
/// converts them to logical pixels (`* 16`) because that is the unit Flutter's
/// `letterSpacing` and `SpacingScale` use. Radius is already unitless.
class ThemeValues {
  ThemeValues({
    required this.id,
    required this.name,
    required this.light,
    required this.dark,
    required this.radius,
    required this.spacing,
    required this.tracking,
    required this.lightShadow,
    required this.darkShadow,
    required this.fonts,
  });

  /// Reads a decoded preset document.
  factory ThemeValues.fromJson(Map<String, Object?> preset) {
    final light = _stringKeyed(preset['light'], 'light');
    final dark = _stringKeyed(preset['dark'], 'dark');
    final shadow = _stringKeyed(preset['shadow'], 'shadow');
    final trackingMap = _stringKeyed(preset['tracking'], 'tracking');
    final fontsMap = preset['fonts'] == null
        ? const <String, Object?>{}
        : _stringKeyed(preset['fonts'], 'fonts');
    return ThemeValues(
      id: _string(preset, 'id'),
      name: _string(preset, 'name'),
      light: _colors(light, 'light'),
      dark: _colors(dark, 'dark'),
      radius: _num2(preset, 'radius'),
      spacing: _num2(preset, 'spacing'),
      tracking: <String, double>{
        for (final step in const ['normal', 'tight', 'wide'])
          if (trackingMap.containsKey(step)) step: _num2(trackingMap, step),
      },
      lightShadow: ShadowAtoms.fromJson(shadow['light']),
      darkShadow: ShadowAtoms.fromJson(shadow['dark']),
      fonts: <String, String>{
        for (final slot in const ['sans', 'serif', 'mono'])
          if (fontsMap.containsKey(slot)) slot: _string(fontsMap, slot),
      },
    );
  }

  /// Preset id, e.g. `amber-minimal`.
  final String id;

  /// Human readable preset name.
  final String name;

  /// Colour tokens per mode as ARGB.
  final Map<String, int> light, dark;

  /// `--radius` in rem (used unitless) and `--spacing` in rem.
  final double radius, spacing;

  /// `--tracking-*` in em, keyed `normal`, `tight`, `wide`.
  final Map<String, double> tracking;

  /// Base shadow atoms per mode.
  final ShadowAtoms lightShadow, darkShadow;

  /// Font family lists keyed `sans`, `serif`, `mono`; may be empty.
  final Map<String, String> fonts;

  /// Dart identifier fragment for [id], e.g. `amberMinimal`.
  String get prefix => camelCase(id);

  /// Capitalised [prefix], e.g. `AmberMinimal`.
  String get classPrefix =>
      prefix.isEmpty ? prefix : prefix[0].toUpperCase() + prefix.substring(1);

  /// Whether the preset names at least one family.
  bool get hasFonts => fonts.isNotEmpty;

  /// Renders the values-only theme file for this preset.
  String toDartSource({String themeImport = defaultThemeImport}) {
    final out = StringBuffer()
      ..writeln('// GENERATED CODE - DO NOT MODIFY BY HAND.')
      ..writeln('// Source: lib/registry_next/themes/$id.json (id: $id).')
      ..writeln(
        '// Regenerate: dart run tool/rearch/gen_app_theme.dart '
        '$id.json app_theme.dart',
      )
      ..writeln();
    for (final library in <String>[
      'package:flutter/widgets.dart',
      themeImport,
      siblingUri(themeImport, 'color_tokens.dart'),
      siblingUri(themeImport, 'tokens.dart'),
    ]) {
      out.writeln("import '$library';");
    }
    for (final source in <String>[
      _colorsSource('light', light),
      _colorsSource('dark', dark),
      _tokensSource('Light', lightShadow),
      _tokensSource('Dark', darkShadow),
      if (hasFonts) _fontsSource(),
      _buildSource(),
    ]) {
      out
        ..writeln()
        ..writeln(source);
    }
    return out.toString();
  }

  String _colorsSource(String mode, Map<String, int> colors) {
    final args = <String>[
      'brightness: Brightness.${mode == 'light' ? 'light' : 'dark'}',
      for (final key in colorTokenKeys) '$key: Color(0x${_argb(colors[key]!)})',
    ];
    final head =
        'const ShadcnColors $prefix${_capital(mode)}Colors = '
        'ShadcnColors';
    return '''/// Colour tokens for the $name preset, $mode brightness.
${_call(head, args, suffix: ';')}''';
  }

  String _tokensSource(String mode, ShadowAtoms shadow) {
    final args = <String>[
      'radius: ${_num(radius)}',
      'spacingBase: ${_num(spacing * 16)}',
      for (final step in const ['normal', 'tight', 'wide'])
        if (tracking.containsKey(step))
          'tracking${_capital(step)}: ${_num(tracking[step]! * 16)}',
      _call(
        'shadows: ShadowScale.derive',
        <String>[
          'color: Color(0x${_argb(shadow.color)})',
          'opacity: ${_num(shadow.opacity)}',
          'blur: ${_num(shadow.blur)}',
          'spread: ${_num(shadow.spread)}',
          'offsetX: ${_num(shadow.offsetX)}',
          'offsetY: ${_num(shadow.offsetY)}',
        ],
        indent: '  ',
        appended: 1,
      ),
    ];
    final head = 'final ShadcnTokens $prefix${mode}Tokens = ShadcnTokens';
    return '''/// Non-colour tokens for the $name preset, ${mode.toLowerCase()} brightness.
${_call(head, args, suffix: ';')}''';
  }

  String _fontsSource() {
    final args = <String>[
      for (final slot in const ['sans', 'serif', 'mono'])
        if (fonts.containsKey(slot))
          'font${_capital(slot)}: ${_quote(fonts[slot]!)}',
    ];
    return '''/// Mode-independent font families for the $name preset.
${_call('const ShadcnFonts ${prefix}Fonts = ShadcnFonts', args, suffix: ';')}''';
  }

  String _buildSource() {
    final args = <String>[
      'colors: isDark ? ${prefix}DarkColors : ${prefix}LightColors',
      'tokens: isDark ? ${prefix}DarkTokens : ${prefix}LightTokens',
      if (hasFonts) 'fonts: ${prefix}Fonts',
    ];
    return '''/// Builds the ambient theme for the $name preset.
ShadcnThemeData build${classPrefix}Theme(Brightness brightness) {
  final isDark = brightness == Brightness.dark;
  ${_call('return ShadcnThemeData', args, indent: '  ', suffix: ';')}
}''';
  }
}

/// `amber-minimal` -> `amberMinimal`; also strips anything that cannot appear
/// in a Dart identifier so the emitted names always compile.
String camelCase(String id) {
  final parts = id.split(RegExp('[^A-Za-z0-9]')).where((p) => p.isNotEmpty);
  final buffer = StringBuffer();
  for (final part in parts) {
    if (buffer.isEmpty) {
      buffer.write(part.toLowerCase());
    } else {
      buffer.write(_capital(part));
    }
  }
  return buffer.toString();
}

/// Sibling library of [uri]: same directory, [name] file name.
String siblingUri(String uri, String name) {
  final cut = uri.lastIndexOf('/');
  return cut < 0 ? name : '${uri.substring(0, cut + 1)}$name';
}

/// Renders `head(a: 1, b: 2)` plus [suffix] on one line when the whole
/// statement fits in 80 columns, otherwise one argument per line with a
/// trailing comma and the closing parenthesis back at [indent]. [appended] is
/// the number of characters the caller puts after this call (the `,` of the
/// enclosing argument list); it counts towards the one line fit but is not
/// emitted, so an exploded nested call still ends with a single comma.
///
/// This is exactly the tall style `dart format` produces, which is what keeps
/// the emitted file format clean without a `dart_style` dependency.
String _call(
  String head,
  List<String> args, {
  String indent = '',
  String suffix = '',
  int appended = 0,
}) {
  final flat = '$head(${args.join(', ')})$suffix';
  if (indent.length + flat.length + appended <= 80) return flat;
  final body = args.map((a) => '$indent  $a').join(',\n');
  return '$head(\n$body,\n$indent)$suffix';
}

/// `0xFFAABBCC`, always eight upper case digits.
String _argb(int argb) => argb.toRadixString(16).padLeft(8, '0').toUpperCase();

/// Shortest round-tripping Dart literal for [value] (`-30.0`, `3.84`, `0.0`).
String _num(double value) => value.toString();

/// Upper-cases the first character of [text].
String _capital(String text) =>
    text.isEmpty ? text : text[0].toUpperCase() + text.substring(1);

/// Single-quoted Dart string literal; escapes `\` and `'`.
String _quote(String value) =>
    "'${value.replaceAll(r'\', r'\\').replaceAll("'", r"\'")}'";

Map<String, Object?> _stringKeyed(Object? value, String what) {
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

Map<String, int> _colors(Map<String, Object?> map, String mode) {
  final colors = <String, int>{};
  for (final key in colorTokenKeys) {
    colors[key] = parseHexColor(_string(map, key));
  }
  final extra = map.keys.toSet().difference(colorTokenKeys.toSet());
  if (extra.isNotEmpty) {
    throw FormatException('$mode has unknown tokens: ${extra.join(', ')}');
  }
  return colors;
}

const String _usage =
    'Usage: dart run tool/rearch/gen_app_theme.dart <preset.json> <out.dart>\n'
    '         [--theme-import <uri>] [--help]\n'
    '  <preset.json>          Decoded preset, e.g. '
    'lib/registry_next/themes/claude.json\n'
    '  <out.dart>             File to write the values-only theme to\n'
    '  --theme-import <uri>   Library exporting ShadcnThemeData\n'
    "                         (default: $defaultThemeImport)\n"
    '  --help                 Print this help';

/// Reads [path] and returns its decoded preset document.
Map<String, Object?> readPreset(String path) {
  final decoded = jsonDecode(File(path).readAsStringSync());
  if (decoded is! Map) throw FormatException('$path is not a JSON object');
  return <String, Object?>{
    for (final entry in decoded.entries) entry.key.toString(): entry.value,
  };
}

void main(List<String> args) {
  final cli = CliArgs.parse(args, valueOptions: <String>{'theme-import'});
  if (cli.flag('help')) {
    stdout.writeln(_usage);
    return;
  }
  final input = cli.positional(0);
  final output = cli.positional(1);
  if (cli.errors.isNotEmpty || input == null || output == null) {
    for (final error in cli.errors) {
      stderr.writeln(error);
    }
    stderr.writeln(_usage);
    exitCode = 64;
    return;
  }
  try {
    final values = ThemeValues.fromJson(readPreset(input));
    final file = File(output);
    file.parent.createSync(recursive: true);
    file.writeAsStringSync(
      values.toDartSource(
        themeImport: cli.value('theme-import') ?? defaultThemeImport,
      ),
    );
    stdout.writeln('app_theme.dart written: $output (preset ${values.id})');
  } on FormatException catch (error) {
    stderr.writeln('$input: ${error.message}');
    exitCode = 65;
  } on FileSystemException catch (error) {
    stderr.writeln('Cannot read $input: ${error.message}');
    exitCode = 66;
  }
}
