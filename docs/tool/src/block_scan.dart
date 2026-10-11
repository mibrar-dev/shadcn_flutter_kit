// Registry input scan for the blocks layer (P6-B1): reads the manifest
// `blocks` map and validates every block the same way the kit's
// `block-installable` layer rule does, so the docs Blocks pages are generated
// from registry facts instead of hand-typed rows.

import 'dart:io';

import 'registry_scan.dart';

/// One installable block: a composed, page-level layout (dashboard, login
/// card, sidebar shell) shipped as registry source with its preview.
class BlockFacts {
  /// Creates the facts.
  const BlockFacts({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    required this.viewport,
    required this.install,
    required this.import,
    required this.entry,
    required this.files,
    required this.docs,
    required this.deps,
    required this.tags,
  });

  /// Registry id == directory name (`dashboard-01`).
  final String id;

  /// Manifest display name (`Dashboard 01`).
  final String name;

  /// Block family (`Dashboard`, `Authentication`, …).
  final String category;

  /// One-line description.
  final String description;

  /// Viewport hint: `desktop` or `mobile`.
  final String viewport;

  /// `flutter_shadcn add <id>`.
  final String install;

  /// Corrected user import line for the installed layout.
  final String import;

  /// Registry-relative entry file (`blocks/login-01/login_01.dart`).
  final String entry;

  /// Registry-relative Dart files, entry first, no README.
  final List<String> files;

  /// Registry-relative docs files (`blocks/<id>/README.md`).
  final List<String> docs;

  /// Manifest deps per layer, each sorted.
  final Map<String, List<String>> deps;

  /// Manifest tags, sorted.
  final List<String> tags;

  /// Whether the block targets a phone viewport.
  bool get isMobile => viewport == 'mobile';
}

/// One block file plus its verbatim source (the docs code view).
class BlockFileFacts {
  /// Creates the file facts.
  const BlockFileFacts({required this.path, required this.code});

  /// Registry-relative path (`blocks/login-01/login_01.dart`).
  final String path;

  /// File source, verbatim.
  final String code;
}

/// Reads and validates every block in the manifest `blocks` map, ordered by
/// category then id.
///
/// Throws [RegistryScanException] on the first violated rule so a broken
/// block fails `gen_docs_data.dart --check` instead of shipping a half-rendered
/// Blocks page. The rules mirror the kit's `block-installable` layer check.
List<BlockFacts> scanBlocks(Directory root, Map<String, Object?> blocksJson) {
  final List<BlockFacts> blocks = <BlockFacts>[
    for (final MapEntry<String, Object?> entry in blocksJson.entries)
      _blockFacts(root, entry.key, _object(entry.value, entry.key)),
  ];
  blocks.sort((BlockFacts a, BlockFacts b) {
    final int byCategory = a.category.compareTo(b.category);
    return byCategory != 0 ? byCategory : a.id.compareTo(b.id);
  });
  if (blocks.map((BlockFacts b) => b.id).toSet().length != blocks.length) {
    throw RegistryScanException('blocks: duplicate block id');
  }
  return blocks;
}

BlockFacts _blockFacts(
  Directory root,
  String id,
  Map<String, Object?> manifest,
) {
  final String name = _string(manifest['name'], '');
  final String category = _string(manifest['category'], '');
  final String description = _string(manifest['description'], '');
  final String viewport = _string(manifest['viewport'], '');
  final String entry = _string(manifest['entry'], '');
  final List<String> files = _strings(manifest['files'], 'files');
  final List<String> docs = _strings(manifest['docs'], 'docs');
  if (name.isEmpty || category.isEmpty || description.isEmpty) {
    throw RegistryScanException('block $id: name/category/description missing');
  }
  if (viewport != 'desktop' && viewport != 'mobile') {
    throw RegistryScanException(
      'block $id: viewport must be desktop or mobile (got "$viewport")',
    );
  }
  if (entry.isEmpty) {
    throw RegistryScanException('block $id: no entry file');
  }
  if (files.isEmpty || files.first != entry) {
    throw RegistryScanException('block $id: files must start with $entry');
  }
  final Map<String, List<String>> deps = <String, List<String>>{
    for (final String layer in const <String>[
      'components',
      'primitives',
      'foundation',
      'theme',
    ])
      layer: _strings(_objectOrEmpty(manifest['deps'])[layer], 'deps.$layer')
        ..sort(),
  };
  final BlockFacts facts = BlockFacts(
    id: id,
    name: name,
    category: category,
    description: description,
    viewport: viewport,
    install: _string(manifest['install'], 'flutter_shadcn add $id'),
    import: _string(manifest['import'], ''),
    entry: entry,
    files: files,
    docs: docs,
    deps: deps,
    tags: _strings(manifest['tags'], 'tags')..sort(),
  );
  for (final String file in facts.files) {
    final File dart = File('${root.path}/$file');
    if (!dart.existsSync()) {
      throw RegistryScanException('block $id: missing file $file');
    }
  }
  for (final String doc in facts.docs) {
    if (!File('${root.path}/$doc').existsSync()) {
      throw RegistryScanException('block $id: missing doc $doc');
    }
  }
  return facts;
}

Map<String, Object?> _object(Object? value, String what) {
  if (value is! Map) {
    throw RegistryScanException('$what is not a JSON object');
  }
  return <String, Object?>{
    for (final MapEntry<Object?, Object?> entry in value.entries)
      entry.key.toString(): entry.value,
  };
}

Map<String, Object?> _objectOrEmpty(Object? value) =>
    value is Map ? _object(value, 'object') : const <String, Object?>{};

String _string(Object? value, String fallback) =>
    value is String ? value : fallback;

List<String> _strings(Object? value, String what) {
  if (value == null) {
    return <String>[];
  }
  if (value is! List) {
    throw RegistryScanException('$what is not a JSON list');
  }
  return <String>[for (final Object? item in value) '$item'];
}
