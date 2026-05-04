import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';

void main(List<String> args) {
  if (args.contains('-h') || args.contains('--help')) {
    _printUsage();
    return;
  }

  final registryDir = _findRegistryDir(Directory.current);
  if (registryDir == null) {
    stderr.writeln('Error: Could not locate lib/registry directory.');
    exitCode = 1;
    return;
  }

  String? defaultThemeId;
  String outputFileName = 'manifests/theme.index.json';

  for (var i = 0; i < args.length; i++) {
    final arg = args[i];
    if (arg == '--default' && i + 1 < args.length) {
      defaultThemeId = args[i + 1].trim();
      i += 1;
      continue;
    }
    if (arg == '--output' && i + 1 < args.length) {
      outputFileName = args[i + 1].trim();
      i += 1;
      continue;
    }
  }

  final themesPresetDir = Directory('${registryDir.path}/themes_preset');
  if (!themesPresetDir.existsSync()) {
    stderr.writeln('Error: ${themesPresetDir.path} does not exist.');
    exitCode = 1;
    return;
  }

  final presetFiles =
      themesPresetDir
          .listSync()
          .whereType<File>()
          .where((file) => file.path.toLowerCase().endsWith('.json'))
          .toList()
        ..sort((a, b) => a.path.compareTo(b.path));

  if (presetFiles.isEmpty) {
    stderr.writeln('Error: No JSON files found in ${themesPresetDir.path}.');
    exitCode = 1;
    return;
  }

  final themes = <Map<String, dynamic>>[];
  final seenIds = <String>{};

  for (final file in presetFiles) {
    final content = file.readAsStringSync();
    final decoded = jsonDecode(content);
    if (decoded is! Map<String, dynamic>) {
      stderr.writeln('Skipping ${file.path}: top-level JSON is not an object.');
      continue;
    }

    final id = (decoded['id'] as String?)?.trim();
    final name = (decoded['name'] as String?)?.trim();
    final description = (decoded['description'] as String?)?.trim();
    final light = decoded['light'];

    if (id == null || id.isEmpty || name == null || name.isEmpty) {
      stderr.writeln('Skipping ${file.path}: missing required id/name.');
      continue;
    }
    if (seenIds.contains(id)) {
      stderr.writeln('Skipping ${file.path}: duplicate id "$id".');
      continue;
    }
    seenIds.add(id);

    String? primary;
    String? background;
    if (light is Map<String, dynamic>) {
      primary = light['primary'] as String?;
      background = light['background'] as String?;
    }

    final entry = <String, dynamic>{
      'id': id,
      'name': name,
      if (description != null && description.isNotEmpty)
        'description': description,
      if (primary != null || background != null)
        'preview': {
          if (primary != null) 'primary': primary,
          if (background != null) 'background': background,
        },
      'files': _themeFiles(registryDir: registryDir, themeId: id),
    };

    themes.add(entry);
  }

  themes.sort((a, b) {
    final left = (a['id'] as String).toLowerCase();
    final right = (b['id'] as String).toLowerCase();
    return left.compareTo(right);
  });

  if (themes.isEmpty) {
    stderr.writeln('Error: No valid theme preset entries found.');
    exitCode = 1;
    return;
  }

  if (defaultThemeId != null && !seenIds.contains(defaultThemeId)) {
    stderr.writeln(
      'Error: --default "$defaultThemeId" does not exist in themes_preset JSON files.',
    );
    exitCode = 1;
    return;
  }

  final output = <String, dynamic>{
    r'$schema':
        'https://flutter-shadcn.github.io/registry-directory/registry/themes.index.schema.v1.json',
    'schemaVersion': 1,
    'generatedAt': DateTime.now().toUtc().toIso8601String(),
    if (defaultThemeId != null) 'defaultThemeId': defaultThemeId,
    'themes': themes,
  };

  final outputFile = File('${registryDir.path}/$outputFileName');
  outputFile.writeAsStringSync(
    const JsonEncoder.withIndent('  ').convert(output),
  );
  stdout.writeln(
    'Generated ${outputFile.path} with ${themes.length} theme(s).',
  );
}

List<Map<String, dynamic>> _themeFiles({
  required Directory registryDir,
  required String themeId,
}) {
  final generatedDir = Directory(
    '${registryDir.path}/shared/theme/generated/$themeId',
  );
  if (!generatedDir.existsSync()) {
    generatedDir.createSync(recursive: true);
  }

  final presetThemesFile = File('${generatedDir.path}/preset_themes.dart');
  if (!presetThemesFile.existsSync()) {
    throw StateError('Missing generated theme file: ${presetThemesFile.path}');
  }

  final presetThemesInstallFile = File(
    '${generatedDir.path}/preset_themes.install.txt',
  );
  presetThemesInstallFile.writeAsStringSync(
    _normalizeInstalledPresetImports(presetThemesFile.readAsStringSync()),
  );

  final appThemePresetInstallFile = File(
    '${generatedDir.path}/app_theme_preset.install.txt',
  );
  appThemePresetInstallFile.writeAsStringSync(_appThemePresetSource());

  return [
    _themeFileEntry(
      registryDir: registryDir,
      file: presetThemesInstallFile,
      target: '{sharedPath}/theme/preset_themes.dart',
    ),
    _themeFileEntry(
      registryDir: registryDir,
      file: appThemePresetInstallFile,
      target: '{sharedPath}/theme/app_theme_preset.dart',
    ),
  ];
}

Map<String, dynamic> _themeFileEntry({
  required Directory registryDir,
  required File file,
  required String target,
}) {
  final source = _registryRelativePath(registryDir, file);
  final bytes = file.readAsBytesSync();
  return {
    'source': source,
    'target': target,
    'sha256': sha256.convert(bytes).toString(),
  };
}

String _registryRelativePath(Directory registryDir, File file) {
  final registryPath = registryDir.absolute.path.replaceAll('\\', '/');
  final filePath = file.absolute.path.replaceAll('\\', '/');
  if (!filePath.startsWith('$registryPath/')) {
    throw StateError('Theme file is outside registry: ${file.path}');
  }
  return filePath.substring(registryPath.length + 1);
}

String _appThemePresetSource() {
  return '''// GENERATED CODE - DO NOT MODIFY BY HAND.
// Run `dart run tool/theme/theme_index_generate.dart` to refresh.

import 'preset_themes.dart';

class InstalledThemePreset {
  static RegistryThemePreset current = registryThemePresets.first;
}
''';
}

String _normalizeInstalledPresetImports(String source) {
  return source
      .replaceAll(
        "import '../../color_scheme.dart';",
        "import 'color_scheme.dart';",
      )
      .replaceAll("import '../../theme.dart';", "import 'theme.dart';");
}

void _printUsage() {
  stdout.writeln(
    'Usage: dart run tool/theme/theme_index_generate.dart [--default <id>] [--output <filename>]',
  );
  stdout.writeln('');
  stdout.writeln(
    'Generates lib/registry/manifests/theme.index.json from lib/registry/themes_preset/*.json',
  );
}

Directory? _findRegistryDir(Directory from) {
  Directory current = from.absolute;
  while (true) {
    final candidate = Directory('${current.path}/lib/registry');
    if (candidate.existsSync()) {
      final marker = File(
        '${candidate.path}/manifests/themes.index.schema.json',
      );
      if (marker.existsSync()) {
        return candidate;
      }
    }

    final parent = current.parent;
    if (parent.path == current.path) {
      return null;
    }
    current = parent;
  }
}
