import 'dart:io';

class _ConfigFile {
  final String importPath;
  final String alias;
  final String configClass;
  final List<_Registration> regs;

  const _ConfigFile({
    required this.importPath,
    required this.alias,
    required this.configClass,
    required this.regs,
  });
}

class _Registration {
  final String resolverField;

  const _Registration({required this.resolverField});
}

void main() {
  final root = Directory.current.path;
  final componentsDir = Directory('$root/lib/registry/components');
  final outputPath =
      '$root/lib/registry/components/component_theme_global_configs.dart';

  if (!componentsDir.existsSync()) {
    stderr.writeln('Components directory not found: ${componentsDir.path}');
    exitCode = 1;
    return;
  }

  final files =
      componentsDir
          .listSync(recursive: true)
          .whereType<File>()
          .where((f) => f.path.endsWith('_theme_config.dart'))
          .toList()
        ..sort((a, b) => a.path.compareTo(b.path));

  final classRe = RegExp(r'class\s+(\w+ThemeConfig)\s*\{');
  final registrationRe = RegExp(
    r'static const\s+([A-Za-z0-9_]+)\?\s+([A-Za-z0-9_]+)\s*=\s*null\s*;',
  );

  final configs = <_ConfigFile>[];
  for (var i = 0; i < files.length; i++) {
    final f = files[i];
    final content = f.readAsStringSync();
    final classMatch = classRe.firstMatch(content);
    if (classMatch == null) continue;

    final configClass = classMatch.group(1)!;
    final relImportPath = f.path
        .replaceFirst('${componentsDir.path}${Platform.pathSeparator}', '')
        .replaceAll('\\', '/');

    final regs = <_Registration>[];
    for (final m in registrationRe.allMatches(content)) {
      final resolverField = m.group(2)!;
      regs.add(_Registration(resolverField: resolverField));
    }

    configs.add(
      _ConfigFile(
        importPath: relImportPath,
        alias: 'c$i',
        configClass: configClass,
        regs: regs,
      ),
    );
  }

  final buffer = StringBuffer()
    ..writeln('// GENERATED CODE - DO NOT MODIFY BY HAND.')
    ..writeln(
      '// Run: dart run tool/theme/component_theme_global_configs_generate.dart',
    )
    ..writeln()
    ..writeln("import '../shared/theme/component_theme_global_registry.dart';");

  for (final c in configs) {
    buffer.writeln("import '${c.importPath}' as ${c.alias};");
  }

  buffer
    ..writeln()
    ..writeln('bool _componentThemeGlobalsRegistered = false;')
    ..writeln()
    ..writeln('/// Registers all component token-config globals once.')
    ..writeln('void registerComponentThemeGlobalConfigs() {')
    ..writeln('  if (_componentThemeGlobalsRegistered) return;');

  for (final c in configs) {
    for (final reg in c.regs) {
      buffer
        ..writeln('  ComponentThemeGlobalRegistry.register(')
        ..writeln('    () => ${c.alias}.${c.configClass}.${reg.resolverField},')
        ..writeln('  );');
    }
  }

  buffer
    ..writeln('  _componentThemeGlobalsRegistered = true;')
    ..writeln('}');

  File(outputPath).writeAsStringSync(buffer.toString());
  stdout.writeln('Generated: $outputPath');
  stdout.writeln('Configs: ${configs.length}');
  stdout.writeln(
    'Registrations: ${configs.fold<int>(0, (sum, c) => sum + c.regs.length)}',
  );
}
