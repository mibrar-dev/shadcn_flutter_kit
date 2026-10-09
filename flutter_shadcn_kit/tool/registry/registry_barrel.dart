import 'dart:io';

/// Locates the flutter_shadcn_kit root by walking up from [start] until the
/// flat registry layout is found (its generated manifest, or the theme layer
/// before the manifest has been generated for the first time).
Directory? findRegistryRoot(Directory start) {
  Directory current = start.absolute;
  while (true) {
    final manifest = File(
      '${current.path}/lib/registry/manifests/registry.json',
    );
    final theme = File('${current.path}/lib/registry/theme/theme.dart');
    if (manifest.existsSync() || theme.existsSync()) {
      return current;
    }
    final parent = current.parent;
    if (parent.path == current.path) {
      return null;
    }
    current = parent;
  }
}

/// Builds the package barrel for the flat registry layout: every file in
/// `registry/theme/` plus every `registry/components/<id>/<id>.dart` entry,
/// sorted alphabetically.
String buildRootBarrel(Directory registryRoot) {
  final registry = Directory('${registryRoot.path}/lib/registry');

  final themeExports = _dartExports(
    Directory('${registry.path}/theme'),
    prefix: 'registry/theme/',
  );

  final componentExports = <String>[];
  for (final entity in Directory('${registry.path}/components').listSync()) {
    if (entity is! Directory) {
      continue;
    }
    final id = _baseName(entity.path);
    if (File('${entity.path}/$id.dart').existsSync()) {
      componentExports.add('registry/components/$id/$id.dart');
    }
  }
  componentExports.sort();

  final lines = <String>[
    '// GENERATED FILE - DO NOT EDIT.',
    '// Run: dart run tool/registry/registry_barrel_generate.dart',
    '',
  ];
  for (final export in themeExports) {
    lines.add("export '$export';");
  }
  lines.add('');
  for (final export in componentExports) {
    lines.add("export '$export';");
  }
  return '${lines.join('\n')}\n';
}

List<String> _dartExports(Directory directory, {required String prefix}) {
  final exports = <String>[];
  for (final entity in directory.listSync()) {
    if (entity is File && entity.path.endsWith('.dart')) {
      exports.add('$prefix${_baseName(entity.path)}');
    }
  }
  exports.sort();
  return exports;
}

String _baseName(String path) {
  final segments = path.split(Platform.pathSeparator);
  return segments.lastWhere((segment) => segment.isNotEmpty);
}
