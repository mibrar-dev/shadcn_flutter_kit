import 'dart:io';

class _ConfigFile {
  final String importPath;
  final String alias;
  final String configClass;
  final String componentId;
  final List<_Registration> regs;

  const _ConfigFile({
    required this.importPath,
    required this.alias,
    required this.configClass,
    required this.componentId,
    required this.regs,
  });
}

class _Registration {
  final String resolverField;

  const _Registration({required this.resolverField});
}

String _basename(String path) {
  final normalized = path.replaceAll('\\', '/');
  final parts = normalized.split('/');
  for (var i = parts.length - 1; i >= 0; i--) {
    final part = parts[i];
    if (part.isNotEmpty) return part;
  }
  return '';
}

String _snakeToPascal(String value) {
  return value
      .split('_')
      .where((part) => part.isNotEmpty)
      .map((part) => '${part[0].toUpperCase()}${part.substring(1)}')
      .join();
}

String _registrarNameForComponent(String componentId) {
  return 'register${_snakeToPascal(componentId)}ThemeGlobals';
}

String _registrarFlagNameForComponent(String componentId) {
  final lowerCamel = componentId
      .split('_')
      .where((part) => part.isNotEmpty)
      .toList();
  if (lowerCamel.isEmpty) {
    return '_themeGlobalsRegistered';
  }
  final first = lowerCamel.first;
  final rest = lowerCamel
      .skip(1)
      .map((part) => '${part[0].toUpperCase()}${part.substring(1)}')
      .join();
  return '_$first${rest}ThemeGlobalsRegistered';
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
    r'static\s+(?:const|final)\s+([A-Za-z0-9_<>, ?]+)\s+([A-Za-z0-9_]+)\s*=',
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
    final componentId = _basename(f.parent.parent.parent.parent.path);

    final regs = <_Registration>[];
    for (final m in registrationRe.allMatches(content)) {
      final typeName = m.group(1)!.trim();
      final resolverField = m.group(2)!;
      final normalizedType = typeName.replaceAll('?', '').trim();
      if (resolverField.startsWith('_')) continue;
      if (normalizedType == 'String') continue;
      if (normalizedType.startsWith('Map<')) continue;
      if (normalizedType.endsWith('Defaults')) continue;
      if (normalizedType.endsWith('Tokens')) continue;
      if (normalizedType.endsWith('WidgetDefaults')) continue;
      if (normalizedType.endsWith('WidgetTokens')) continue;
      regs.add(_Registration(resolverField: resolverField));
    }

    if (regs.isEmpty) continue;

    configs.add(
      _ConfigFile(
        importPath: relImportPath,
        alias: 'c$i',
        configClass: configClass,
        componentId: componentId,
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
    ..writeln();

  for (final c in configs) {
    final registrarName = _registrarNameForComponent(c.componentId);
    final registrarFlag = _registrarFlagNameForComponent(c.componentId);

    buffer
      ..writeln('bool $registrarFlag = false;')
      ..writeln()
      ..writeln('/// Registers ${c.componentId} theme globals once.')
      ..writeln('void $registrarName() {')
      ..writeln('  if ($registrarFlag) return;');

    for (final reg in c.regs) {
      buffer
        ..writeln('  ComponentThemeGlobalRegistry.register(')
        ..writeln('    () => ${c.alias}.${c.configClass}.${reg.resolverField},')
        ..writeln('  );');
    }

    buffer
      ..writeln('  $registrarFlag = true;')
      ..writeln('}')
      ..writeln();
  }

  buffer
    ..writeln('/// Registers all component token-config globals once.')
    ..writeln('void registerComponentThemeGlobalConfigs() {')
    ..writeln('  if (_componentThemeGlobalsRegistered) return;');

  for (final c in configs) {
    buffer.writeln('  ${_registrarNameForComponent(c.componentId)}();');
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
