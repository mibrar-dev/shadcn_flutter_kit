import 'dart:convert';
import 'dart:io';

const List<String> _colorFields = <String>[
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

const List<String> _shadowFields = <String>[
  'shadow2xs',
  'shadowXs',
  'shadowSm',
  'shadow',
  'shadowMd',
  'shadowLg',
  'shadowXl',
  'shadow2xl',
];

const String _defaultLightShadow =
    'const [BoxShadow(offset: Offset(0, 4), blurRadius: 8, spreadRadius: -1, color: Color(0x1A000000))]';
const String _defaultDarkShadow =
    'const [BoxShadow(offset: Offset(20.5, 16.5), blurRadius: 25.5, spreadRadius: -30, color: Color(0x12000000))]';

void main(List<String> args) {
  if (args.contains('--help') || args.contains('-h')) {
    _printUsage();
    return;
  }

  if (_tryHandleConverterRequest(args)) {
    return;
  }

  _runPresetGenerator(args);
}

bool _tryHandleConverterRequest(List<String> args) {
  if (args.length != 1) {
    return false;
  }
  final file = File(args.first);
  if (!file.existsSync()) {
    return false;
  }
  final decoded = jsonDecode(file.readAsStringSync());
  if (decoded is! Map) {
    return false;
  }
  final request = decoded.map((key, value) => MapEntry(key.toString(), value));
  if (_isConverterEnvelope(request)) {
    stdout.write(jsonEncode(_handleConverterEnvelope(request)));
    return true;
  }
  if (_looksLikePresetJson(request)) {
    stdout.write(jsonEncode(_buildPresetDtoMap(_PresetData.fromJson(request))));
    return true;
  }
  return false;
}

bool _isConverterEnvelope(Map<String, dynamic> map) {
  final scope = map['scope']?.toString().trim();
  final action = map['action']?.toString().trim();
  return scope != null &&
      scope.isNotEmpty &&
      action != null &&
      action.isNotEmpty;
}

bool _looksLikePresetJson(Map<String, dynamic> map) {
  return map['id'] != null && map['light'] is Map && map['dark'] is Map;
}

void _runPresetGenerator(List<String> args) {
  final registryDir = _findRegistryDir(Directory.current);
  if (registryDir == null) {
    stderr.writeln('Error: Could not locate lib/registry directory.');
    exitCode = 1;
    return;
  }

  final opts = _parseArgs(args);
  final inputDir = _resolvePath(
    (opts['input-dir'] as String?) ?? '${registryDir.path}/themes_preset',
  );
  final outputDir = _resolvePath(
    (opts['output-dir'] as String?) ??
        '${registryDir.path}/shared/theme/presets',
  );
  final modelsPath = _resolvePath(
    (opts['models-path'] as String?) ??
        '${registryDir.path}/shared/theme/theme_preset_models.dart',
  );
  final appThemePresetPath = _resolvePath(
    (opts['app-theme-preset-path'] as String?) ??
        '${registryDir.path}/shared/theme/app_theme_preset.dart',
  );
  final appThemePath = _resolvePath(
    (opts['app-theme-path'] as String?) ??
        '${registryDir.path}/shared/theme/app_theme.dart',
  );
  final legacyPresetPath = _resolvePath(
    (opts['legacy-preset-path'] as String?) ??
        '${registryDir.path}/shared/theme/preset_themes.dart',
  );

  final input = Directory(inputDir);
  if (!input.existsSync()) {
    stderr.writeln('Error: Input directory does not exist: $inputDir');
    exitCode = 1;
    return;
  }

  final presetId = opts['preset-id'] as String?;
  final presetJsonPath = opts['preset-json'] as String?;
  if (presetId == null && presetJsonPath == null) {
    stderr.writeln('Error: Provide --preset-id=<id> or --preset-json=<path>.');
    exitCode = 1;
    return;
  }

  final output = Directory(outputDir);
  output.createSync(recursive: true);

  final presetFile = _resolvePresetFile(
    inputDir: inputDir,
    presetId: presetId,
    presetJsonPath: presetJsonPath,
  );
  if (presetFile == null || !presetFile.existsSync()) {
    stderr.writeln('Error: Could not resolve preset json file.');
    if (presetId != null) {
      stderr.writeln('Tried: $inputDir/$presetId.json');
    }
    if (presetJsonPath != null) {
      stderr.writeln('Provided: ${_resolvePath(presetJsonPath)}');
    }
    exitCode = 1;
    return;
  }
  final map = jsonDecode(presetFile.readAsStringSync()) as Map<String, dynamic>;
  final selected = _PresetData.fromJson(map);

  File(modelsPath)
    ..createSync(recursive: true)
    ..writeAsStringSync(_buildModelsFile());

  final fileName = '${_snake(selected.id)}.dart';
  final outPath = '$outputDir/$fileName';
  File(outPath)
    ..createSync(recursive: true)
    ..writeAsStringSync(_buildPresetFile(selected, modelsPath, outPath));

  File(appThemePresetPath)
    ..createSync(recursive: true)
    ..writeAsStringSync(
      _buildAppThemePresetFile(
        modelsPath: modelsPath,
        selectedPresetPath: outPath,
        appThemePresetPath: appThemePresetPath,
        selectedVariable: selected.variableName,
      ),
    );

  _updateAppThemeImport(appThemePath, modelsPath);

  final deleteLegacy = (opts['delete-legacy'] as String?) != 'false';
  if (deleteLegacy) {
    final legacyFile = File(legacyPresetPath);
    if (legacyFile.existsSync()) {
      legacyFile.deleteSync();
    }
  }

  stdout.writeln('Generated preset Dart file: $outPath');
  stdout.writeln('Wrote models file: $modelsPath');
  stdout.writeln('Updated app theme preset: $appThemePresetPath');
  stdout.writeln('Updated app theme imports: $appThemePath');
  if (deleteLegacy) {
    stdout.writeln('Removed legacy file if present: $legacyPresetPath');
  }
}

void _printUsage() {
  stdout.writeln(
    'Usage: dart run tool/theme/theme_preset_json_to_dart.dart [options]',
  );
  stdout.writeln('');
  stdout.writeln(
    'Converts one preset json into one theme dart file for CLI installation.',
  );
  stdout.writeln(
    'Also regenerates theme preset models and updates app_theme_preset.dart.',
  );
  stdout.writeln('');
  stdout.writeln('Options:');
  stdout.writeln(
    '  --input-dir=<path>            Source json folder (default: lib/registry/themes_preset)',
  );
  stdout.writeln(
    '  --output-dir=<path>           Output folder for per-theme dart files',
  );
  stdout.writeln(
    '  --preset-id=<id>              Preset id (looks for <input-dir>/<id>.json)',
  );
  stdout.writeln(
    '  --preset-json=<path>          Explicit preset json path (overrides preset-id)',
  );
  stdout.writeln(
    '  --models-path=<path>          Output for theme_preset_models.dart',
  );
  stdout.writeln(
    '  --app-theme-preset-path=<p>   Output for app_theme_preset.dart',
  );
  stdout.writeln(
    '  --app-theme-path=<path>       app_theme.dart path to rewrite imports',
  );
  stdout.writeln(
    '  --legacy-preset-path=<path>   Legacy preset_themes.dart path to delete',
  );
  stdout.writeln(
    '  --delete-legacy=<true|false>  Delete legacy preset file (default: true)',
  );
}

Map<String, Object?> _parseArgs(List<String> args) {
  final result = <String, Object?>{};
  for (final arg in args) {
    if (!arg.startsWith('--')) {
      continue;
    }
    final eq = arg.indexOf('=');
    if (eq == -1) {
      result[arg.substring(2)] = true;
    } else {
      result[arg.substring(2, eq)] = arg.substring(eq + 1);
    }
  }
  return result;
}

String _resolvePath(String path) {
  if (path.startsWith('/')) {
    return path;
  }
  return File(path).absolute.path;
}

Directory? _findRegistryDir(Directory from) {
  Directory current = from.absolute;
  while (true) {
    final candidate = Directory('${current.path}/lib/registry');
    if (candidate.existsSync()) {
      return candidate;
    }
    final parent = current.parent;
    if (parent.path == current.path) {
      return null;
    }
    current = parent;
  }
}

Map<String, dynamic> _handleConverterEnvelope(Map<String, dynamic> request) {
  final scope = request['scope']?.toString().trim() ?? '';
  final action = request['action']?.toString().trim() ?? '';
  final namespace = request['namespace']?.toString().trim();
  final context =
      (request['context'] as Map?)?.cast<String, dynamic>() ??
      const <String, dynamic>{};

  if (scope == 'global' && action == 'apply') {
    return _handleGlobalThemeApply(
      namespace: namespace,
      payloadFile: request['payloadFile']?.toString(),
      context: context,
    );
  }
  if (scope == 'widget') {
    return _handleWidgetThemeRequest(
      action: action,
      namespace: namespace,
      componentId: request['componentId']?.toString(),
      payloadFile: request['payloadFile']?.toString(),
      context: context,
    );
  }
  throw FormatException('Unsupported converter request: $scope/$action');
}

Map<String, dynamic> _handleGlobalThemeApply({
  required String? namespace,
  required String? payloadFile,
  required Map<String, dynamic> context,
}) {
  if (payloadFile == null || payloadFile.trim().isEmpty) {
    throw FormatException('Global theme apply requires payloadFile.');
  }
  final payload = _readJsonFile(payloadFile);
  final preset = _PresetData.fromJson(payload);
  final sharedPath = _requireContextPath(context, 'sharedPath');
  final presetThemesPath = '$sharedPath/theme/preset_themes.dart';
  final appThemePresetPath = '$sharedPath/theme/app_theme_preset.dart';

  return <String, dynamic>{
    'scope': 'global',
    'resolvedNamespace': namespace,
    'preview': <String, dynamic>{
      'themeId': preset.id,
      'themeName': preset.name,
    },
    'messages': <Map<String, String>>[
      <String, String>{
        'level': 'detail',
        'text': 'Prepared global theme preset ${preset.id}.',
      },
    ],
    'installPlan': <String, dynamic>{
      'operations': <Map<String, dynamic>>[
        <String, dynamic>{
          'type': 'write_file',
          'path': presetThemesPath,
          'content': _buildInstalledPresetThemesFile(preset),
        },
        <String, dynamic>{
          'type': 'write_file',
          'path': appThemePresetPath,
          'content': _buildInstalledAppThemePresetFile(),
        },
      ],
    },
  };
}

Map<String, dynamic> _handleWidgetThemeRequest({
  required String action,
  required String? namespace,
  required String? componentId,
  required String? payloadFile,
  required Map<String, dynamic> context,
}) {
  final installPath = _requireContextPath(context, 'installPath');
  final targetDir = _requireContextPath(context, 'targetDir');
  final componentsRoot = Directory('$targetDir/$installPath/components');

  if (action == 'list') {
    final components = _listThemeableComponents(componentsRoot);
    return <String, dynamic>{
      'scope': 'widget',
      'resolvedNamespace': namespace,
      'preview': <String, dynamic>{
        'components': components
            .map(
              (_WidgetThemeDescriptor item) => <String, dynamic>{
                'componentId': item.componentId,
                'targets': item.targets
                    .map((_WidgetThemeTarget target) => target.typeName)
                    .toList(),
              },
            )
            .toList(),
      },
      'messages': components.isEmpty
          ? <Map<String, String>>[
              <String, String>{
                'level': 'info',
                'text': 'No themeable widgets found in the current project.',
              },
            ]
          : const <Map<String, String>>[],
      'installPlan': const <String, dynamic>{
        'operations': <Map<String, dynamic>>[],
      },
    };
  }

  if (componentId == null || componentId.trim().isEmpty) {
    throw FormatException('Widget theme requests require componentId.');
  }

  final descriptor = _findWidgetThemeDescriptor(componentsRoot, componentId);
  if (descriptor == null) {
    return <String, dynamic>{
      'scope': 'widget',
      'resolvedNamespace': namespace,
      'resolvedComponent': componentId,
      'messages': <Map<String, String>>[
        <String, String>{
          'level': 'warn',
          'text':
              'Widget "$componentId" is not installed or does not expose theme config.',
        },
      ],
      'installPlan': const <String, dynamic>{
        'operations': <Map<String, dynamic>>[],
      },
    };
  }

  if (action == 'list-targets') {
    return <String, dynamic>{
      'scope': 'widget',
      'resolvedNamespace': namespace,
      'resolvedComponent': descriptor.componentId,
      'preview': <String, dynamic>{
        'componentId': descriptor.componentId,
        'targets': descriptor.targets
            .map(
              (_WidgetThemeTarget target) => <String, dynamic>{
                'id': target.typeName,
                'default':
                    descriptor.targets.length == 1 &&
                    descriptor.targets.first.typeName == target.typeName,
              },
            )
            .toList(),
      },
      'installPlan': const <String, dynamic>{
        'operations': <Map<String, dynamic>>[],
      },
    };
  }

  if (action == 'reset') {
    final next = _resetWidgetThemeConfig(descriptor);
    return <String, dynamic>{
      'scope': 'widget',
      'resolvedNamespace': namespace,
      'resolvedComponent': descriptor.componentId,
      'installPlan': <String, dynamic>{
        'operations': <Map<String, dynamic>>[
          <String, dynamic>{
            'type': 'write_file',
            'path': _relativePath(targetDir, descriptor.configFile.path),
            'content': next,
          },
        ],
      },
    };
  }

  if (action != 'apply') {
    throw FormatException('Unsupported widget theme action: $action');
  }
  if (payloadFile == null || payloadFile.trim().isEmpty) {
    throw FormatException('Widget theme apply requires payloadFile.');
  }
  final payload = _readJsonFile(payloadFile);
  final resolvedTarget = _resolveWidgetThemeTarget(descriptor, payload);
  final next = _applyWidgetThemeConfig(descriptor, resolvedTarget, payload);
  return <String, dynamic>{
    'scope': 'widget',
    'resolvedNamespace': namespace,
    'resolvedComponent': descriptor.componentId,
    'resolvedTargetThemeType': resolvedTarget.typeName,
    'installPlan': <String, dynamic>{
      'operations': <Map<String, dynamic>>[
        <String, dynamic>{
          'type': 'write_file',
          'path': _relativePath(targetDir, descriptor.configFile.path),
          'content': next,
        },
      ],
    },
  };
}

String _buildModelsFile() {
  return '''// GENERATED CODE - DO NOT MODIFY BY HAND.
// Run `dart run tool/theme/theme_preset_json_to_dart.dart` to refresh.

import 'package:flutter/widgets.dart';

import 'color_scheme.dart';
import 'theme.dart';

class RegistryThemePresetTokens {
  final double radius;
  final SpacingScale spacing;
  final TrackingScale tracking;
  final ShadowScale shadows;
  final String? fontSans;
  final String? fontSerif;
  final String? fontMono;

  const RegistryThemePresetTokens({
    required this.radius,
    required this.spacing,
    required this.tracking,
    required this.shadows,
    this.fontSans,
    this.fontSerif,
    this.fontMono,
  });

  Density get density => Density.fromSpacingScale(spacing);
}

class RegistryThemePreset {
  final String id;
  final String name;
  final ColorScheme light;
  final ColorScheme dark;
  final RegistryThemePresetTokens lightTokens;
  final RegistryThemePresetTokens darkTokens;

  const RegistryThemePreset({
    required this.id,
    required this.name,
    required this.light,
    required this.dark,
    required this.lightTokens,
    required this.darkTokens,
  });
}
''';
}

String _buildPresetFile(_PresetData preset, String modelsPath, String outPath) {
  final modelsImport = _relativeImport(outPath, modelsPath);
  final light = _buildColorScheme('light', preset.light, 'Brightness.light');
  final dark = _buildColorScheme('dark', preset.dark, 'Brightness.dark');
  final lightTokens = _buildTokenScheme(
    'lightTokens',
    preset.lightTokens,
    true,
  );
  final darkTokens = _buildTokenScheme('darkTokens', preset.darkTokens, false);

  return '''// GENERATED CODE - DO NOT MODIFY BY HAND.
// Source: ${preset.id}.json

import 'package:flutter/widgets.dart';

import '$modelsImport';

final RegistryThemePreset ${preset.variableName} = RegistryThemePreset(
  id: '${preset.id}',
  name: ${_dartStringLiteral(preset.name)},
$light
$dark
$lightTokens
$darkTokens
);
''';
}

String _buildAppThemePresetFile({
  required String modelsPath,
  required String selectedPresetPath,
  required String appThemePresetPath,
  required String selectedVariable,
}) {
  final modelsImport = _relativeImport(appThemePresetPath, modelsPath);
  final presetImport = _relativeImport(appThemePresetPath, selectedPresetPath);

  return '''// GENERATED CODE - DO NOT MODIFY BY HAND.
// Run `dart run tool/theme/theme_preset_json_to_dart.dart` to refresh.

import '$modelsImport';
import '$presetImport';

class InstalledThemePreset {
  static RegistryThemePreset current = $selectedVariable;
}
''';
}

String _buildInstalledAppThemePresetFile() {
  return '''// GENERATED CODE - DO NOT MODIFY BY HAND.
// Run `dart run tool/theme/theme_preset_json_to_dart.dart` to refresh.

import 'preset_themes.dart';

class InstalledThemePreset {
  static RegistryThemePreset current = registryThemePresets.first;
}
''';
}

String _buildInstalledPresetThemesFile(_PresetData preset) {
  final light = _buildColorScheme('light', preset.light, 'Brightness.light');
  final dark = _buildColorScheme('dark', preset.dark, 'Brightness.dark');
  final lightTokens = _buildTokenScheme(
    'lightTokens',
    preset.lightTokens,
    true,
  );
  final darkTokens = _buildTokenScheme('darkTokens', preset.darkTokens, false);

  return '''// GENERATED CODE - DO NOT MODIFY BY HAND.
// Source: ${preset.id}.json
// ignore_for_file: prefer_const_constructors

import 'dart:ui';

import 'package:flutter/painting.dart';

import 'color_scheme.dart';
import 'theme.dart';

class RegistryThemePresetTokens {
  final double radius;
  final SpacingScale spacing;
  final TrackingScale tracking;
  final ShadowScale shadows;
  final String? fontSans;
  final String? fontSerif;
  final String? fontMono;

  const RegistryThemePresetTokens({
    required this.radius,
    required this.spacing,
    required this.tracking,
    required this.shadows,
    this.fontSans,
    this.fontSerif,
    this.fontMono,
  });

  Density get density => Density.fromSpacingScale(spacing);
}

class RegistryThemePreset {
  final String id;
  final String name;
  final ColorScheme light;
  final ColorScheme dark;
  final RegistryThemePresetTokens lightTokens;
  final RegistryThemePresetTokens darkTokens;

  const RegistryThemePreset({
    required this.id,
    required this.name,
    required this.light,
    required this.dark,
    required this.lightTokens,
    required this.darkTokens,
  });
}

final List<RegistryThemePreset> registryThemePresets = <RegistryThemePreset>[
  RegistryThemePreset(
    id: '${preset.id}',
    name: ${_dartStringLiteral(preset.name)},
$light
$dark
$lightTokens
$darkTokens
  ),
];
''';
}

Map<String, dynamic> _buildPresetDtoMap(_PresetData preset) {
  return <String, dynamic>{
    'id': preset.id,
    'name': preset.name,
    'light': preset.light,
    'dark': preset.dark,
  };
}

File? _resolvePresetFile({
  required String inputDir,
  required String? presetId,
  required String? presetJsonPath,
}) {
  if (presetJsonPath != null && presetJsonPath.isNotEmpty) {
    return File(_resolvePath(presetJsonPath));
  }
  if (presetId != null && presetId.isNotEmpty) {
    return File('$inputDir/$presetId.json');
  }
  return null;
}

void _updateAppThemeImport(String appThemePath, String modelsPath) {
  final file = File(appThemePath);
  if (!file.existsSync()) {
    return;
  }

  final content = file.readAsStringSync();
  final modelsImport = "import '${_relativeImport(appThemePath, modelsPath)}';";

  var next = content.replaceAll(
    RegExp(r"^import 'preset_themes\.dart';\s*$\n?", multiLine: true),
    '',
  );

  if (!next.contains(modelsImport)) {
    next = next.replaceFirst(
      "import 'app_theme_preset.dart';\n",
      "import 'app_theme_preset.dart';\n$modelsImport\n",
    );
  }

  file.writeAsStringSync(next);
}

String _buildColorScheme(
  String fieldName,
  Map<String, String> scheme,
  String brightness,
) {
  final lines = <String>[];
  lines.add('  $fieldName: const ColorScheme(');
  lines.add('    brightness: $brightness,');
  for (final key in _colorFields) {
    final color = scheme[key] ?? '0xFF000000';
    lines.add('    $key: Color($color),');
  }
  lines.add('  ),');
  return lines.join('\n');
}

String _buildTokenScheme(String fieldName, _TokenData? token, bool isLight) {
  final t = token ?? _TokenData.defaults(isLight: isLight);
  final lines = <String>[];
  lines.add('  $fieldName: RegistryThemePresetTokens(');
  lines.add('    radius: ${_n(t.radius)},');
  lines.add('    spacing: SpacingScale(${_n(t.spacingBase)}),');
  lines.add('    tracking: TrackingScale(normal: ${_n(t.trackingNormal)}),');
  lines.add('    shadows: ShadowScale(');

  for (final field in _shadowFields) {
    final shadows = t.shadows[field];
    if (shadows == null || shadows.isEmpty) {
      lines.add(
        '      $field: ${isLight ? _defaultLightShadow : _defaultDarkShadow},',
      );
      continue;
    }

    final boxShadows = shadows
        .map(
          (_BoxShadowData s) =>
              'BoxShadow(offset: Offset(${_n(s.x)}, ${_n(s.y)}), blurRadius: ${_n(s.blur)}, spreadRadius: ${_n(s.spread)}, color: Color(${s.color}))',
        )
        .join(', ');
    lines.add('      $field: const [$boxShadows],');
  }

  lines.add('    ),');
  if (t.fontSans != null) {
    lines.add('    fontSans: ${_dartStringLiteral(t.fontSans!)},');
  }
  if (t.fontSerif != null) {
    lines.add('    fontSerif: ${_dartStringLiteral(t.fontSerif!)},');
  }
  if (t.fontMono != null) {
    lines.add('    fontMono: ${_dartStringLiteral(t.fontMono!)},');
  }
  lines.add('  ),');

  return lines.join('\n');
}

String _dartStringLiteral(String value) => jsonEncode(value);

String _n(num value) {
  if (value == value.roundToDouble()) {
    return value.toInt().toString();
  }
  return value.toString();
}

String _snake(String value) => value.replaceAll('-', '_').toLowerCase();

String _camel(String value) {
  final parts = value
      .split(RegExp(r'[-_\\s]+'))
      .where((String p) => p.isNotEmpty);
  var out = '';
  var first = true;
  for (final part in parts) {
    final head = part[0].toUpperCase();
    final tail = part.substring(1).toLowerCase();
    if (first) {
      out += part[0].toLowerCase() + tail;
      first = false;
    } else {
      out += '$head$tail';
    }
  }
  return out;
}

String _relativeImport(String fromPath, String toPath) {
  final fromSegments = _splitPath(File(fromPath).absolute.parent.path);
  final toSegments = _splitPath(File(toPath).absolute.path);

  var i = 0;
  while (i < fromSegments.length &&
      i < toSegments.length &&
      fromSegments[i] == toSegments[i]) {
    i += 1;
  }

  final up = List<String>.filled(fromSegments.length - i, '..');
  final down = toSegments.sublist(i);
  return [...up, ...down].join('/');
}

List<String> _splitPath(String path) {
  return path
      .replaceAll('\\', '/')
      .split('/')
      .where((String segment) => segment.isNotEmpty)
      .toList();
}

Map<String, dynamic> _readJsonFile(String path) {
  final file = File(path);
  if (!file.existsSync()) {
    throw FormatException('JSON file not found: $path');
  }
  final decoded = jsonDecode(file.readAsStringSync());
  if (decoded is! Map) {
    throw FormatException('Expected a JSON object in $path');
  }
  return decoded.map((key, value) => MapEntry(key.toString(), value));
}

String _requireContextPath(Map<String, dynamic> context, String key) {
  final value = context[key]?.toString().trim();
  if (value == null || value.isEmpty) {
    throw FormatException('Converter request is missing context.$key.');
  }
  return value;
}

String _relativePath(String rootPath, String filePath) {
  final root = _splitPath(Directory(rootPath).absolute.path);
  final target = _splitPath(File(filePath).absolute.path);
  if (target.length < root.length) {
    throw FormatException('Target path is outside project root: $filePath');
  }
  for (var index = 0; index < root.length; index++) {
    if (root[index] != target[index]) {
      throw FormatException('Target path is outside project root: $filePath');
    }
  }
  return target.sublist(root.length).join('/');
}

List<_WidgetThemeDescriptor> _listThemeableComponents(
  Directory componentsRoot,
) {
  if (!componentsRoot.existsSync()) {
    return const <_WidgetThemeDescriptor>[];
  }
  final descriptors = <_WidgetThemeDescriptor>[];
  for (final entity in componentsRoot.listSync()) {
    if (entity is! Directory) {
      continue;
    }
    final descriptor = _loadWidgetThemeDescriptor(entity);
    if (descriptor != null) {
      descriptors.add(descriptor);
    }
  }
  descriptors.sort(
    (_WidgetThemeDescriptor left, _WidgetThemeDescriptor right) =>
        left.componentId.compareTo(right.componentId),
  );
  return descriptors;
}

_WidgetThemeDescriptor? _findWidgetThemeDescriptor(
  Directory componentsRoot,
  String componentId,
) {
  final normalized = componentId.trim().toLowerCase();
  for (final descriptor in _listThemeableComponents(componentsRoot)) {
    if (descriptor.componentId.toLowerCase() == normalized) {
      return descriptor;
    }
  }
  return null;
}

_WidgetThemeDescriptor? _loadWidgetThemeDescriptor(Directory componentDir) {
  final configDir = Directory('${componentDir.path}/_impl/themes/config');
  if (!configDir.existsSync()) {
    return null;
  }
  final configFiles = configDir
      .listSync()
      .whereType<File>()
      .where((File file) => file.path.endsWith('_theme_config.dart'))
      .toList();
  if (configFiles.isEmpty) {
    return null;
  }
  final configFile = configFiles.first;
  final content = configFile.readAsStringSync();
  final fieldRegex = RegExp(
    r'^  static const ([A-Za-z0-9_]+)\\? ([A-Za-z0-9_]+) = (.*?);$',
    multiLine: true,
    dotAll: true,
  );
  final typeRegex = RegExp(
    r"^  static const String ([A-Za-z0-9_]+)Type = '([^']+)';$",
    multiLine: true,
  );

  final fieldByName = <String, _WidgetThemeField>{};
  for (final match in fieldRegex.allMatches(content)) {
    final fieldType = match.group(1);
    final fieldName = match.group(2);
    final expression = match.group(3);
    if (fieldType == null || fieldName == null || expression == null) {
      continue;
    }
    fieldByName[fieldName] = _WidgetThemeField(
      fieldType: fieldType,
      fieldName: fieldName,
      expression: expression.trim(),
      matchedSource: match.group(0) ?? '',
    );
  }

  final targets = <_WidgetThemeTarget>[];
  for (final match in typeRegex.allMatches(content)) {
    final fieldBase = match.group(1);
    final typeName = match.group(2);
    if (fieldBase == null || typeName == null) {
      continue;
    }
    final field = fieldByName[fieldBase];
    if (field == null) {
      continue;
    }
    targets.add(
      _WidgetThemeTarget(
        fieldType: field.fieldType,
        fieldName: field.fieldName,
        typeName: typeName,
        expression: field.expression,
        matchedSource: field.matchedSource,
      ),
    );
  }

  if (targets.isEmpty) {
    return null;
  }

  return _WidgetThemeDescriptor(
    componentId: componentDir.path
        .replaceAll('\\', '/')
        .split('/')
        .where((String item) => item.isNotEmpty)
        .last,
    configFile: configFile,
    content: content,
    targets: targets,
  );
}

String _resetWidgetThemeConfig(_WidgetThemeDescriptor descriptor) {
  var next = descriptor.content;
  for (final target in descriptor.targets) {
    next = next.replaceFirst(
      target.matchedSource,
      '  static const ${target.fieldType}? ${target.fieldName} = null;',
    );
  }
  return next;
}

_WidgetThemeTarget _resolveWidgetThemeTarget(
  _WidgetThemeDescriptor descriptor,
  Map<String, dynamic> payload,
) {
  final requested =
      payload['targetThemeType']?.toString().trim() ??
      payload['target']?.toString().trim() ??
      payload['type']?.toString().trim();
  if (requested == null || requested.isEmpty) {
    if (descriptor.targets.length == 1) {
      return descriptor.targets.first;
    }
    throw FormatException(
      'Widget theme payload must include targetThemeType when multiple targets exist.',
    );
  }
  for (final target in descriptor.targets) {
    if (target.typeName == requested) {
      return target;
    }
  }
  throw FormatException(
    'Widget theme target "$requested" is not available for ${descriptor.componentId}.',
  );
}

String _applyWidgetThemeConfig(
  _WidgetThemeDescriptor descriptor,
  _WidgetThemeTarget target,
  Map<String, dynamic> payload,
) {
  final expression = _buildWidgetThemeExpression(target.typeName, payload);
  return descriptor.content.replaceFirst(
    target.matchedSource,
    '  static const ${target.fieldType}? ${target.fieldName} = $expression;',
  );
}

String _buildWidgetThemeExpression(
  String targetType,
  Map<String, dynamic> payload,
) {
  final themeCode =
      payload['themeCode']?.toString().trim() ??
      payload['code']?.toString().trim();
  if (themeCode != null && themeCode.isNotEmpty) {
    return themeCode;
  }
  final properties =
      (payload['properties'] as Map?)?.cast<String, dynamic>() ??
      const <String, dynamic>{};
  if (properties.isEmpty) {
    return 'const $targetType()';
  }
  final lines = <String>['const $targetType('];
  final keys = properties.keys.toList()..sort();
  for (final key in keys) {
    lines.add('    $key: ${_dartLiteral(properties[key])},');
  }
  lines.add('  )');
  return lines.join('\\n');
}

String _dartLiteral(Object? value) {
  if (value == null) {
    return 'null';
  }
  if (value is bool || value is num) {
    return value.toString();
  }
  if (value is String) {
    return "'${_escape(value)}'";
  }
  if (value is List) {
    final items = value.map(_dartLiteral).join(', ');
    return 'const [$items]';
  }
  if (value is Map) {
    final typed = value.map(
      (Object? key, Object? innerValue) => MapEntry(key.toString(), innerValue),
    );
    final rawDart = typed['dart']?.toString().trim();
    if (rawDart != null && rawDart.isNotEmpty) {
      return rawDart;
    }
    final entries = typed.entries
        .map(
          (MapEntry<String, Object?> entry) =>
              "'${_escape(entry.key)}': ${_dartLiteral(entry.value)}",
        )
        .join(', ');
    return 'const {$entries}';
  }
  throw FormatException('Unsupported widget theme literal: $value');
}

String _escape(String value) {
  return value
      .replaceAll(r'\', r'\\')
      .replaceAll("'", r"\'")
      .replaceAll(r'$', r'\$')
      .replaceAll('\n', r'\n')
      .replaceAll('\r', r'\r')
      .replaceAll('\t', r'\t');
}

class _WidgetThemeDescriptor {
  const _WidgetThemeDescriptor({
    required this.componentId,
    required this.configFile,
    required this.content,
    required this.targets,
  });

  final String componentId;
  final File configFile;
  final String content;
  final List<_WidgetThemeTarget> targets;
}

class _WidgetThemeField {
  const _WidgetThemeField({
    required this.fieldType,
    required this.fieldName,
    required this.expression,
    required this.matchedSource,
  });

  final String fieldType;
  final String fieldName;
  final String expression;
  final String matchedSource;
}

class _WidgetThemeTarget {
  const _WidgetThemeTarget({
    required this.fieldType,
    required this.fieldName,
    required this.typeName,
    required this.expression,
    required this.matchedSource,
  });

  final String fieldType;
  final String fieldName;
  final String typeName;
  final String expression;
  final String matchedSource;
}

class _PresetData {
  _PresetData({
    required this.id,
    required this.name,
    required this.light,
    required this.dark,
    required this.lightTokens,
    required this.darkTokens,
  });

  final String id;
  final String name;
  final Map<String, String> light;
  final Map<String, String> dark;
  final _TokenData? lightTokens;
  final _TokenData? darkTokens;

  String get variableName => '${_camel(id)}ThemePreset';

  factory _PresetData.fromJson(Map<String, dynamic> map) {
    final tokens = (map['tokens'] as Map?)?.cast<String, dynamic>();

    return _PresetData(
      id: map['id'] as String,
      name: map['name'] as String? ?? map['id'] as String,
      light: _readScheme((map['light'] as Map).cast<String, dynamic>()),
      dark: _readScheme((map['dark'] as Map).cast<String, dynamic>()),
      lightTokens: tokens?['light'] == null
          ? null
          : _TokenData.fromJson(
              (tokens!['light'] as Map).cast<String, dynamic>(),
            ),
      darkTokens: tokens?['dark'] == null
          ? null
          : _TokenData.fromJson(
              (tokens!['dark'] as Map).cast<String, dynamic>(),
            ),
    );
  }

  static Map<String, String> _readScheme(Map<String, dynamic> map) {
    final out = <String, String>{};
    for (final field in _colorFields) {
      out[field] = (map[field] as String?) ?? '0xFF000000';
    }
    return out;
  }
}

class _TokenData {
  _TokenData({
    required this.radius,
    required this.spacingBase,
    required this.trackingNormal,
    required this.shadows,
    this.fontSans,
    this.fontSerif,
    this.fontMono,
  });

  final num radius;
  final num spacingBase;
  final num trackingNormal;
  final Map<String, List<_BoxShadowData>> shadows;
  final String? fontSans;
  final String? fontSerif;
  final String? fontMono;

  factory _TokenData.defaults({required bool isLight}) {
    final defaults = <String, List<_BoxShadowData>>{};
    for (final field in _shadowFields) {
      defaults[field] = <_BoxShadowData>[];
    }

    return _TokenData(
      radius: 0.5,
      spacingBase: isLight ? 4 : 3.84,
      trackingNormal: 0,
      shadows: defaults,
    );
  }

  factory _TokenData.fromJson(Map<String, dynamic> map) {
    final spacing =
        (map['spacing'] as Map?)?.cast<String, dynamic>() ??
        const <String, dynamic>{};
    final tracking =
        (map['tracking'] as Map?)?.cast<String, dynamic>() ??
        const <String, dynamic>{};
    final shadowsMap =
        (map['shadows'] as Map?)?.cast<String, dynamic>() ??
        const <String, dynamic>{};

    final shadows = <String, List<_BoxShadowData>>{};
    for (final field in _shadowFields) {
      final raw = shadowsMap[field] as List?;
      if (raw == null) {
        shadows[field] = <_BoxShadowData>[];
        continue;
      }
      shadows[field] = raw
          .cast<Map>()
          .map((Map v) => _BoxShadowData.fromJson(v.cast<String, dynamic>()))
          .toList();
    }

    return _TokenData(
      radius: (map['radius'] as num?) ?? 0.5,
      spacingBase: (spacing['base'] as num?) ?? 4,
      trackingNormal: (tracking['normal'] as num?) ?? 0,
      shadows: shadows,
      fontSans: map['fontSans'] as String?,
      fontSerif: map['fontSerif'] as String?,
      fontMono: map['fontMono'] as String?,
    );
  }
}

class _BoxShadowData {
  _BoxShadowData({
    required this.x,
    required this.y,
    required this.blur,
    required this.spread,
    required this.color,
  });

  final num x;
  final num y;
  final num blur;
  final num spread;
  final String color;

  factory _BoxShadowData.fromJson(Map<String, dynamic> map) {
    return _BoxShadowData(
      x: map['x'] as num,
      y: map['y'] as num,
      blur: map['blur'] as num,
      spread: map['spread'] as num,
      color: map['color'] as String,
    );
  }
}
