import 'dart:convert';
import 'dart:io';

const _defaultVersion = '1.0.0';
const _defaultTier = 'component';

String _join(String a, String b) {
  if (a.endsWith(Platform.pathSeparator)) {
    return '$a$b';
  }
  return '$a${Platform.pathSeparator}$b';
}

String _toSnake(String input) {
  final cleaned = input
      .replaceAll(RegExp(r'[/\\]+'), ' ')
      .replaceAll('-', ' ')
      .trim();
  if (cleaned.isEmpty) return '';
  final buffer = StringBuffer();
  for (var i = 0; i < cleaned.length; i++) {
    final ch = cleaned[i];
    if (ch == ' ') {
      if (buffer.isNotEmpty && buffer.toString().endsWith('_') == false) {
        buffer.write('_');
      }
      continue;
    }
    final isUpper = ch.toUpperCase() == ch && ch.toLowerCase() != ch;
    final isPrevLower =
        i > 0 &&
        cleaned[i - 1].toLowerCase() == cleaned[i - 1] &&
        cleaned[i - 1].toUpperCase() != cleaned[i - 1];
    if (isUpper && isPrevLower) {
      buffer.write('_');
    }
    buffer.write(ch.toLowerCase());
  }
  return buffer.toString().replaceAll(RegExp(r'_+'), '_');
}

String _toTitle(String input) {
  final parts = input.replaceAll('_', ' ').split(RegExp(r'\s+'));
  return parts
      .where((p) => p.isNotEmpty)
      .map((p) => p[0].toUpperCase() + p.substring(1))
      .join(' ');
}

String _toPascal(String input) {
  final parts = input.replaceAll('_', ' ').split(RegExp(r'\s+'));
  return parts
      .where((p) => p.isNotEmpty)
      .map((p) => p[0].toUpperCase() + p.substring(1))
      .join('');
}

bool _isHiddenPath(String relativePath) {
  final parts = relativePath.replaceAll('\\', '/').split('/');
  return parts.any((part) => part.startsWith('.'));
}

void _printUsage() {
  stdout.writeln(
    'Usage: dart run scripts/new_component.dart <name> '
    '--category <category> [--description <text>] [--sync]',
  );
  stdout.writeln(
    '   or: dart run scripts/new_component.dart <name> '
    '--category <category> --remove [--sync]',
  );
  stdout.writeln('   or: dart run scripts/new_component.dart --sync');
  stdout.writeln('');
  stdout.writeln('Options:');
  stdout.writeln('  --category       Registry category (required)');
  stdout.writeln('  --description    Short description for meta.json');
  stdout.writeln('  --sync           Run registry sync after changes');
  stdout.writeln('  --remove         Remove the component and clean manifests');
  stdout.writeln('  --help, -h       Show this help output');
}

class _ParsedArgs {
  _ParsedArgs({
    this.name,
    this.category,
    this.description = '',
    this.sync = false,
    this.remove = false,
  });

  final String? name;
  final String? category;
  final String description;
  final bool sync;
  final bool remove;
}

_ParsedArgs _parseArgs(List<String> args) {
  String? name;
  String? category;
  var description = '';
  var sync = false;
  var remove = false;

  for (var i = 0; i < args.length; i++) {
    final arg = args[i];
    if (arg.startsWith('--')) {
      final key = arg.substring(2);
      switch (key) {
        case 'category':
          if (i + 1 < args.length) {
            category = args[++i];
          }
          break;
        case 'description':
          if (i + 1 < args.length) {
            description = args[++i];
          }
          break;
        case 'sync':
          sync = true;
          break;
        case 'remove':
          remove = true;
          break;
      }
    } else {
      name ??= arg;
    }
  }

  return _ParsedArgs(
    name: name,
    category: category,
    description: description,
    sync: sync,
    remove: remove,
  );
}

void _runToolScript(Directory repoRoot, String scriptName) {
  final result = Process.runSync('dart', [
    'run',
    'tool/$scriptName',
  ], workingDirectory: repoRoot.path);
  stdout.write(result.stdout);
  stderr.write(result.stderr);
  if (result.exitCode != 0) {
    throw ProcessException(
      'dart',
      ['run', 'tool/$scriptName'],
      'Tool script failed with exit code ${result.exitCode}.',
      result.exitCode,
    );
  }
}

void _runSync(Directory repoRoot) {
  _runToolScript(repoRoot, 'registry_sync_all.dart');
  _runToolScript(repoRoot, 'registry_index_generate.dart');
}

void _writeMainDart({
  required Directory kitRoot,
  required String category,
  required String componentId,
  required String title,
  required String previewClassName,
}) {
  final mainFile = File(_join(kitRoot.path, 'lib/main.dart'));
  mainFile.writeAsStringSync(
    "import 'package:flutter/widgets.dart';\n"
    "import 'package:flutter_shadcn_kit/registry/components/$category/$componentId/preview.dart';\n"
    '\n'
    "import 'package:flutter_shadcn_kit/registry/components/layout/app/app.dart';\n"
    "import 'package:flutter_shadcn_kit/registry/components/display/empty_state/preview.dart';\n"
    "import 'package:flutter_shadcn_kit/registry/components/utility/shadcn_localizations/shadcn_localizations.dart';\n"
    "import 'package:flutter_shadcn_kit/registry/shared/theme/theme.dart' as shadcn;\n"
    '\n'
    'void main() {\n'
    '  runApp(const _RegistryApp());\n'
    '}\n'
    '\n'
    'class _RegistryApp extends StatelessWidget {\n'
    '  const _RegistryApp();\n'
    '\n'
    '  @override\n'
    '  Widget build(BuildContext context) {\n'
    '    return ShadcnApp(\n'
    "      title: '$title Preview',\n"
    '      theme: const shadcn.ThemeData(),\n'
    '      localizationsDelegates: ShadcnLocalizations.localizationsDelegates,\n'
    '      supportedLocales: ShadcnLocalizations.supportedLocales,\n'
    '      home: const $previewClassName(),\n'
    '    );\n'
    '  }\n'
    '}\n',
  );
}

bool _removeFromComponentsJson(File jsonFile, String componentId) {
  if (!jsonFile.existsSync()) return false;
  final data = jsonDecode(jsonFile.readAsStringSync()) as Map<String, dynamic>;
  final components = (data['components'] as List).cast<Map<String, dynamic>>();
  final updated = components.where((c) => c['id'] != componentId).toList();
  if (updated.length == components.length) {
    return false;
  }
  data['components'] = updated;
  jsonFile.writeAsStringSync(
    '${const JsonEncoder.withIndent('  ').convert(data)}\n',
  );
  return true;
}

void main(List<String> args) {
  if (args.contains('--help') || args.contains('-h')) {
    _printUsage();
    return;
  }

  final parsed = _parseArgs(args);
  final nameArg = parsed.name;
  final scriptDir = File(Platform.script.toFilePath()).parent;
  final kitRoot = scriptDir.parent;
  final repoRoot = kitRoot.parent;
  final registryRoot = Directory(_join(kitRoot.path, 'lib/registry'));
  final componentsRoot = Directory(_join(registryRoot.path, 'components'));

  if (parsed.sync && nameArg == null && !parsed.remove) {
    _runSync(repoRoot);
    return;
  }

  if (nameArg == null || nameArg.trim().isEmpty) {
    stderr.writeln('Error: component name is required.');
    _printUsage();
    exitCode = 64;
    return;
  }

  final componentId = _toSnake(nameArg);
  final categoryArg = parsed.category?.trim();
  final category = categoryArg != null && categoryArg.isNotEmpty
      ? _toSnake(categoryArg)
      : null;

  if (parsed.remove) {
    Directory? componentDir;
    if (category != null) {
      final candidate = Directory(
        _join(_join(componentsRoot.path, category), componentId),
      );
      if (candidate.existsSync()) {
        componentDir = candidate;
      }
    } else {
      final matches = <Directory>[];
      for (final categoryDir in componentsRoot.listSync()) {
        if (categoryDir is! Directory) continue;
        final candidate = Directory(_join(categoryDir.path, componentId));
        if (candidate.existsSync()) {
          matches.add(candidate);
        }
      }
      if (matches.length == 1) {
        componentDir = matches.first;
      } else if (matches.length > 1) {
        stderr.writeln(
          'Error: component exists in multiple categories. '
          'Provide --category to disambiguate.',
        );
        exitCode = 64;
        return;
      }
    }

    if (componentDir == null || !componentDir.existsSync()) {
      stderr.writeln('Error: component not found.');
      exitCode = 64;
      return;
    }

    componentDir.deleteSync(recursive: true);

    final registryUpdated = _removeFromComponentsJson(
      File(_join(registryRoot.path, 'components.json')),
      componentId,
    );
    final docsUpdated = _removeFromComponentsJson(
      File(_join(repoRoot.path, 'docs/assets/registry/components.json')),
      componentId,
    );

    stdout.writeln(
      'Removed $componentId (components.json updated: '
      '${registryUpdated || docsUpdated}).',
    );

    if (parsed.sync) {
      _runSync(repoRoot);
    }
    return;
  }

  if (category == null || category.isEmpty) {
    stderr.writeln('Error: --category is required.');
    _printUsage();
    exitCode = 64;
    return;
  }

  final description = parsed.description.isNotEmpty
      ? parsed.description
      : '${_toTitle(componentId)} component for the registry.';

  final title = _toTitle(componentId);
  final componentDir = Directory(
    _join(_join(componentsRoot.path, category), componentId),
  );
  componentDir.createSync(recursive: true);
  final implDir = Directory(_join(componentDir.path, '_impl'));
  implDir.createSync(recursive: true);
  for (final name in [
    'core',
    'extensions',
    'state',
    'styles',
    'themes',
    'utils',
    'variants',
  ]) {
    Directory(_join(implDir.path, name)).createSync(recursive: true);
  }

  File(
    _join(componentDir.path, 'README.md'),
  ).writeAsStringSync('# $title\n\n$description\n');
  File(_join(componentDir.path, 'meta.json')).writeAsStringSync(
    '${const JsonEncoder.withIndent('  ').convert({
      'id': componentId,
      'name': title,
      'description': description,
      'category': category,
      'tier': _defaultTier,
      'version': _defaultVersion,
      'tags': [category, componentId],
      'dependencies': {'pubspec': {}, 'shared': [], 'components': []},
    })}\n',
  );
  File(_join(componentDir.path, 'GETTING_STARTED.md')).writeAsStringSync(
    '# Getting Started\n'
    '\n'
    'Hello! This folder is your new component. Think of it like a small toy '
    'box with labeled bins so you always know where things go.\n'
    '\n'
    '## Folder Map\n'
    '- `README.md` tells people what the component is.\n'
    '- `meta.json` is the label the registry uses to install the component.\n'
    '- `$componentId.dart` is the main widget that people import.\n'
    '- `preview.dart` is for the gallery preview.\n'
    '- `_impl/` is the private toolbox for helper code.\n'
    '\n'
    '## Inside `_impl/`\n'
    '- `_impl/core/` for the main building blocks.\n'
    '- `_impl/state/` for controllers and state logic.\n'
    '- `_impl/styles/` for styles and style helpers.\n'
    '- `_impl/themes/` for theme data and theme helpers.\n'
    '- `_impl/utils/` for small helper functions.\n'
    '- `_impl/variants/` for variant widgets and styles.\n'
    '- `_impl/extensions/` for extension methods.\n'
    '\n'
    'If you do not need a folder yet, it can stay empty. That is okay.\n',
  );

  final className = _toPascal(componentId);
  final mainDart = File(_join(componentDir.path, '$componentId.dart'));
  if (!mainDart.existsSync()) {
    mainDart.writeAsStringSync(
      "import 'package:flutter/material.dart';\n\n"
      'class $className extends StatelessWidget {\n'
      '  const $className({super.key});\n\n'
      '  @override\n'
      '  Widget build(BuildContext context) {\n'
      '    return const SizedBox.shrink();\n'
      '  }\n'
      '}\n',
    );
  }

  final previewDart = File(_join(componentDir.path, 'preview.dart'));
  if (!previewDart.existsSync()) {
    previewDart.writeAsStringSync(
      "import 'package:flutter/material.dart' as m;\n\n"
      "import '$componentId.dart';\n\n"
      'class ${className}Preview extends m.StatelessWidget {\n'
      '  const ${className}Preview({super.key});\n\n'
      '  @override\n'
      '  m.Widget build(m.BuildContext context) {\n'
      '    return const m.SizedBox.shrink();\n'
      '  }\n'
      '}\n',
    );
  }

  _writeMainDart(
    kitRoot: kitRoot,
    category: category,
    componentId: componentId,
    title: title,
    previewClassName: '${className}Preview',
  );

  final relFiles = <String>[];
  for (final entity in componentDir.listSync(recursive: true)) {
    if (entity is! File) continue;
    final relPath = entity.path.substring(componentDir.path.length + 1);
    final normalized = relPath.replaceAll('\\', '/');
    if (_isHiddenPath(normalized)) {
      continue;
    }
    final fileName = normalized.split('/').last;
    if (fileName == 'README.md' ||
        fileName == 'GETTING_STARTED.md' ||
        fileName == 'preview.dart' ||
        fileName == 'meta.json' ||
        fileName == 'theme.schema.json' ||
        fileName.endsWith('.meta.json')) {
      continue;
    }
    relFiles.add(normalized);
  }
  relFiles.sort();

  final entry = {
    'id': componentId,
    'name': title,
    'description': description,
    'category': category,
    'tier': _defaultTier,
    'tags': [category, componentId],
    'version': _defaultVersion,
    'files': [
      for (final rel in relFiles)
        {
          'source': 'registry/components/$category/$componentId/$rel',
          'destination': '{installPath}/components/$category/$componentId/$rel',
        },
    ],
    'shared': [],
    'dependsOn': [],
    'pubspec': {'dependencies': {}},
    'assets': [],
    'postInstall': [],
  };

  for (final jsonPath in [
    File(_join(registryRoot.path, 'components.json')),
    File(_join(repoRoot.path, 'docs/assets/registry/components.json')),
  ]) {
    if (!jsonPath.existsSync()) continue;
    final data =
        jsonDecode(jsonPath.readAsStringSync()) as Map<String, dynamic>;
    final comps = (data['components'] as List)
        .cast<Map<String, dynamic>>()
        .where((c) => c['id'] != componentId)
        .toList();
    comps.add(entry);
    data['components'] = comps;
    jsonPath.writeAsStringSync(
      '${const JsonEncoder.withIndent('  ').convert(data)}\n',
    );
  }

  stdout.writeln('Created $category/$componentId in registry.');

  if (parsed.sync) {
    _runSync(repoRoot);
  }
}
