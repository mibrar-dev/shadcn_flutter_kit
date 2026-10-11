// Renderers for the block-shaped generated files (P6-B3):
// `docs_blocks.dart` (catalog + categories, main bundle) and
// `block_sources.dart` (every block file's source + highlight classes, loaded
// with the deferred Blocks pages so the landing route never ships them).
//
// The deferred preview registry lives in `render_previews.dart`
// (`block_previews.dart`).

import 'dart_highlight.dart';
import 'literals.dart';
import 'registry_scan.dart';
import 'render_common.dart';

/// The install-root-relative Dart files of [block], entry first.
List<String> _blockFiles(RegistryScan scan, BlockFacts block) => <String>[
  for (final String file in block.files) '${scan.installRoot}/$file',
];

/// `Settings & Account` → `settings-account`.
String blockCategorySlug(String category) {
  final StringBuffer out = StringBuffer();
  for (final String ch in category.toLowerCase().split('')) {
    final bool alphaNumeric = RegExp('[a-z0-9]').hasMatch(ch);
    out.write(alphaNumeric ? ch : '-');
  }
  return out
      .toString()
      .replaceAll(RegExp('-+'), '-')
      .replaceAll(RegExp(r'^-|-$'), '');
}

/// Renders `lib/generated/docs_blocks.dart`: the block catalog, the six block
/// families (sidebar groups) and nothing else — no sources.
String renderDocsBlocks(DocsModel model) {
  final RegistryScan scan = model.scan;
  final List<String> literals = <String>[
    for (final BlockFacts block in scan.blocks) _blockLiteral(scan, block),
  ];
  final StringBuffer out = StringBuffer()
    ..write(
      banner(
        sources: const <String>[
          'flutter_shadcn_kit/lib/registry/manifests/registry.json',
          'flutter_shadcn_kit/lib/registry/blocks/<id>/meta.json',
        ],
        regenerate: kRegenerateCommand,
        notes: <String>[
          'Every block, block family and block file list is derived from the',
          'registry manifest; the Blocks pages never hard-code block facts.',
          'Block sources (code view) live in lib/blocks/block_sources.dart,',
          'loaded with the deferred Blocks pages.',
        ],
      ),
    )
    ..writeln()
    ..writeln(
      '/// One installable block, generated from the registry manifest.',
    )
    ..writeln('class DocsBlock {')
    ..writeln('  /// Creates a block entry.')
    ..writeln('  const DocsBlock({')
    ..writeln('    required this.id,')
    ..writeln('    required this.name,')
    ..writeln('    required this.category,')
    ..writeln('    required this.description,')
    ..writeln('    required this.viewport,')
    ..writeln('    required this.install,')
    ..writeln('    required this.import,')
    ..writeln('    required this.files,')
    ..writeln('    required this.deps,')
    ..writeln('    required this.tags,')
    ..writeln('  });')
    ..writeln()
    ..writeln('  /// Registry id / route segment (`/blocks/<id>`).')
    ..writeln('  final String id;')
    ..writeln()
    ..writeln('  /// Display name (`Dashboard 01`).')
    ..writeln('  final String name;')
    ..writeln()
    ..writeln('  /// Block family (`Dashboard`, `Sidebar`, …).')
    ..writeln('  final String category;')
    ..writeln()
    ..writeln('  /// One-line description from the manifest.')
    ..writeln('  final String description;')
    ..writeln()
    ..writeln('  /// Viewport hint from `meta.json` (`desktop`, `mobile`).')
    ..writeln('  final String viewport;')
    ..writeln()
    ..writeln('  /// `flutter_shadcn add <id>` from the manifest.')
    ..writeln('  final String install;')
    ..writeln()
    ..writeln('  /// Corrected import line for the installed layout.')
    ..writeln('  final String import;')
    ..writeln()
    ..writeln('  /// Install-root-relative Dart files, entry first.')
    ..writeln('  final List<String> files;')
    ..writeln()
    ..writeln('  /// Component ids the block composes (manifest `deps`).')
    ..writeln('  final List<String> deps;')
    ..writeln()
    ..writeln('  /// Manifest tags, sorted.')
    ..writeln('  final List<String> tags;')
    ..writeln()
    ..writeln('  /// Route slug of the block family (`settings-account`).')
    ..writeln('  String get categorySlug => blockCategorySlug(category);')
    ..writeln()
    ..writeln('  /// Whether the block targets a phone viewport.')
    ..writeln('  bool get isMobile => viewport == \'mobile\';')
    ..writeln('}')
    ..writeln()
    ..writeln('/// One block family (dashboard, sidebar, …) with its blocks.')
    ..writeln('class DocsBlockCategory {')
    ..writeln('  /// Creates a family entry.')
    ..writeln(
      '  const DocsBlockCategory({required this.id, required this.blocks});',
    )
    ..writeln()
    ..writeln('  /// Family name as written in `meta.json` (`Authentication`).')
    ..writeln('  final String id;')
    ..writeln()
    ..writeln('  /// Route slug (lower-case, hyphenated).')
    ..writeln('  String get slug => blockCategorySlug(id);')
    ..writeln()
    ..writeln('  /// The family\'s blocks, ordered by id.')
    ..writeln('  final List<DocsBlock> blocks;')
    ..writeln()
    ..writeln('  /// Number of blocks in the family.')
    ..writeln('  int get count => blocks.length;')
    ..writeln('}')
    ..writeln()
    ..writeln('/// Route slug of a block family (`Settings & Account`')
    ..writeln('/// → `settings-account`).')
    ..writeln('String blockCategorySlug(String id) {')
    ..writeln("  return id.toLowerCase().replaceAll(RegExp('[^a-z0-9]+'), '-')")
    ..writeln("      .replaceAll(RegExp(r'^-|-\$'), '');")
    ..writeln('}')
    ..writeln();

  out
    ..writeln(
      '/// All ${scan.blocks.length} installable blocks, ordered by family '
      'then id.',
    )
    ..writeln('const List<DocsBlock> kBlocks = <DocsBlock>[');
  for (final String literal in literals) {
    out.writeln('  $literal,');
  }
  out
    ..writeln('];')
    ..writeln();

  final Map<String, List<BlockFacts>> byCategory = <String, List<BlockFacts>>{};
  for (final BlockFacts block in scan.blocks) {
    byCategory.putIfAbsent(block.category, () => <BlockFacts>[]).add(block);
  }
  final List<String> categories = byCategory.keys.toList()..sort();
  out
    ..writeln(
      '/// The ${categories.length} block families, alphabetical, with their '
      'blocks.',
    )
    ..writeln(
      'const List<DocsBlockCategory> kBlockCategories = '
      '<DocsBlockCategory>[',
    );
  for (final String category in categories) {
    out.writeln('  DocsBlockCategory(');
    out.writeln('    id: ${dartString(category)},');
    out.writeln('    blocks: <DocsBlock>[');
    for (final BlockFacts block in byCategory[category]!) {
      out.writeln('      ${literals[scan.blocks.indexOf(block)]},');
    }
    out
      ..writeln('    ],')
      ..writeln('  ),');
  }
  out.writeln('];');
  return out.toString();
}

String _blockLiteral(RegistryScan scan, BlockFacts block) {
  return callExpr('DocsBlock', <String>[
    'id: ${dartString(block.id)}',
    'name: ${dartString(block.name)}',
    'category: ${dartString(block.category)}',
    'description: ${dartStringSmart(block.description)}',
    'viewport: ${dartString(block.viewport)}',
    'install: ${dartString(block.install)}',
    'import: ${dartStringSmart(block.import)}',
    'files: ${stringList(_blockFiles(scan, block), indent: '    ', appended: 2)}',
    'deps: ${stringList(block.deps['components'] ?? const <String>[], indent: '    ', appended: 2)}',
    'tags: ${stringList(block.tags, indent: '    ', appended: 2)}',
  ], indent: '  ');
}

/// Renders `lib/blocks/block_sources.dart`: every block file's verbatim source
/// plus its 4-class highlight map, keyed by block id.
///
/// This is the heaviest generated library (all 16 blocks, ~4.4k lines of
/// Dart), so it is imported by the deferred Blocks pages only.
String renderBlockSources(
  RegistryScan scan,
  Map<String, List<BlockFileFacts>> blockSources,
) {
  final StringBuffer out = StringBuffer()
    ..write(
      banner(
        sources: const <String>[
          'flutter_shadcn_kit/lib/registry/blocks/<id>/<file>.dart',
        ],
        regenerate: kRegenerateCommand,
        notes: <String>[
          'The Blocks code view: one file per block, verbatim, with the same',
          '4-class highlight map the README snippets use (`p`/`c`/`k`/`s`,',
          'one class per character). Imported by the deferred Blocks pages.',
        ],
      ),
    )
    ..writeln()
    ..writeln()
    ..writeln('/// One block file: its install-root-relative path and source.')
    ..writeln('class DocsBlockFile {')
    ..writeln('  /// Creates a block file entry.')
    ..writeln('  const DocsBlockFile({')
    ..writeln('    required this.path,')
    ..writeln('    required this.code,')
    ..writeln('    required this.tokenClasses,')
    ..writeln('  });')
    ..writeln()
    ..writeln('  /// Install-root-relative path (`lib/ui/shadcn/blocks/…`).')
    ..writeln('  final String path;')
    ..writeln()
    ..writeln('  /// File source, verbatim.')
    ..writeln('  final String code;')
    ..writeln()
    ..writeln('  /// One highlight class per character of [code].')
    ..writeln('  final String tokenClasses;')
    ..writeln()
    ..writeln('  /// File name without its block-directory prefix.')
    ..writeln('  String get name => path.split(\'/\').last;')
    ..writeln('}')
    ..writeln()
    ..writeln('/// Block files keyed by block id, in manifest `files` order.')
    ..writeln(
      'const Map<String, List<DocsBlockFile>> kBlockFileSources = '
      '<String, List<DocsBlockFile>>{',
    );
  for (final BlockFacts block in scan.blocks) {
    final List<BlockFileFacts> files =
        blockSources[block.id] ?? const <BlockFileFacts>[];
    out.writeln('  ${dartString(block.id)}: <DocsBlockFile>[');
    for (final BlockFileFacts file in files) {
      out
        ..writeln('    DocsBlockFile(')
        ..writeln(
          '      path: ${dartString('${scan.installRoot}/${file.path}')},',
        )
        ..writeln('      code: ${dartCodeString(file.code)},')
        ..writeln(
          '      tokenClasses: ${dartString(classifySnippet('dart', file.code))},',
        )
        ..writeln('    ),');
    }
    out.writeln('  ],');
  }
  out.writeln('};');
  return out.toString();
}
