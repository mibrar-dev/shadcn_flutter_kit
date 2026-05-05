import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:yaml/yaml.dart';

void main() {
  test(
    'consumer fixture pubspec fonts align with manifest-driven shared font groups',
    () {
      final packageRoot = Directory.current.path;
      final manifest = _readJson(
        '$packageRoot/lib/registry/manifests/components.json',
      );
      final fixtureInstallState = _readJson(
        '$packageRoot/flutter_cli_verification_example/lib/ui/shadcn/components.json',
      );
      final canonicalPubspec = _readYaml('$packageRoot/pubspec.yaml');
      final fixturePubspec = _readYaml(
        '$packageRoot/flutter_cli_verification_example/pubspec.yaml',
      );

      final sharedEntries = {
        for (final entry in (manifest['shared'] as List<dynamic>)
            .whereType<Map>()
            .cast<Map<dynamic, dynamic>>())
          entry['id'] as String: entry,
      };
      final componentEntries = {
        for (final entry in (manifest['components'] as List<dynamic>)
            .whereType<Map>()
            .cast<Map<dynamic, dynamic>>())
          entry['id'] as String: entry,
      };

      final installed = (fixtureInstallState['installed'] as List<dynamic>)
          .whereType<String>()
          .toList();
      final componentClosure = _resolveComponentClosure(installed, componentEntries);
      final expectedSharedIds = _resolveSharedIds(componentClosure, componentEntries);

      final expectedRegistryFontSources = <String>{
        for (final sharedId in expectedSharedIds)
          ..._sharedFontSources(sharedEntries[sharedId]),
      };
      final expectedFixtureAssets = expectedRegistryFontSources
          .map((source) => source.replaceFirst('registry/shared/', 'assets/'))
          .toList()
        ..sort();

      final expectedFonts = _filterFonts(
        _extractFlutterFonts(canonicalPubspec),
        expectedFixtureAssets.toSet(),
      );
      final actualFonts = _extractFlutterFonts(fixturePubspec);

      expect(actualFonts, expectedFonts);

      final actualFixtureAssets = _listFixtureFontAssets(
        '$packageRoot/flutter_cli_verification_example/assets/fonts',
      );
      expect(actualFixtureAssets, expectedFixtureAssets);
    },
  );
}

Map<String, dynamic> _readJson(String path) {
  return jsonDecode(File(path).readAsStringSync()) as Map<String, dynamic>;
}

YamlMap _readYaml(String path) {
  return loadYaml(File(path).readAsStringSync()) as YamlMap;
}

List<String> _resolveComponentClosure(
  List<String> installed,
  Map<String, Map<dynamic, dynamic>> componentEntries,
) {
  final resolved = <String>{};
  final queue = <String>[...installed];

  while (queue.isNotEmpty) {
    final componentId = queue.removeLast();
    if (!resolved.add(componentId)) continue;
    final entry = componentEntries[componentId];
    if (entry == null) continue;
    final dependsOn = (entry['dependsOn'] as List<dynamic>? ?? const <dynamic>[])
        .whereType<String>();
    queue.addAll(dependsOn);
  }

  final ordered = resolved.toList()..sort();
  return ordered;
}

Set<String> _resolveSharedIds(
  List<String> componentClosure,
  Map<String, Map<dynamic, dynamic>> componentEntries,
) {
  final sharedIds = <String>{};
  for (final componentId in componentClosure) {
    final entry = componentEntries[componentId];
    if (entry == null) continue;
    sharedIds.addAll(
      (entry['shared'] as List<dynamic>? ?? const <dynamic>[])
          .whereType<String>(),
    );
  }
  return sharedIds;
}

Iterable<String> _sharedFontSources(Map<dynamic, dynamic>? sharedEntry) sync* {
  if (sharedEntry == null) return;
  final files = sharedEntry['files'] as List<dynamic>? ?? const <dynamic>[];
  for (final file in files.whereType<Map<dynamic, dynamic>>()) {
    final source = file['source'];
    if (source is String && source.startsWith('registry/shared/fonts/')) {
      yield source;
    }
  }
}

List<Map<String, dynamic>> _extractFlutterFonts(YamlMap pubspec) {
  final flutter = pubspec['flutter'];
  if (flutter is! YamlMap) return const <Map<String, dynamic>>[];
  final fonts = flutter['fonts'];
  if (fonts is! YamlList) return const <Map<String, dynamic>>[];

  return fonts
      .whereType<YamlMap>()
      .map((entry) {
        final family = entry['family'] as String;
        final files = (entry['fonts'] as YamlList)
            .whereType<YamlMap>()
            .map((font) => <String, dynamic>{
                  'asset': font['asset'] as String,
                  if (font['weight'] != null) 'weight': font['weight'],
                  if (font['style'] != null) 'style': font['style'],
                })
            .toList();
        return <String, dynamic>{'family': family, 'fonts': files};
      })
      .toList();
}

List<Map<String, dynamic>> _filterFonts(
  List<Map<String, dynamic>> fonts,
  Set<String> expectedAssets,
) {
  final expectedAssetByBasename = <String, String>{
    for (final asset in expectedAssets) _basename(asset): asset,
  };
  final filtered = <Map<String, dynamic>>[];

  for (final familyEntry in fonts) {
    final files = (familyEntry['fonts'] as List<dynamic>)
        .whereType<Map<String, dynamic>>()
        .map((font) {
          final originalAsset = font['asset'] as String;
          final expectedAsset = expectedAssetByBasename[_basename(originalAsset)];
          if (expectedAsset == null) return null;
          return <String, dynamic>{
            ...font,
            'asset': expectedAsset,
          };
        })
        .whereType<Map<String, dynamic>>()
        .toList();
    if (files.isEmpty) continue;
    filtered.add(<String, dynamic>{
      'family': familyEntry['family'],
      'fonts': files,
    });
  }

  return filtered;
}

String _basename(String path) => path.split('/').last;

List<String> _listFixtureFontAssets(String fontsRootPath) {
  final root = Directory(fontsRootPath);
  final files = root
      .listSync(recursive: true)
      .whereType<File>()
      .map((file) {
        final relative = file.path.substring(root.path.length + 1).replaceAll(
          '\\',
          '/',
        );
        return 'assets/fonts/$relative';
      })
      .toList()
    ..sort();
  return files;
}
