// Model building for the docs codegen: registry scan + analyzer extraction
// + README/CLI parsing, then rendering the whole bundle.

import 'dart:io';

import 'dart_scan.dart';
import 'api_model.dart';
import 'block_class.dart';
import 'readme_scan.dart';
import 'registry_scan.dart';
import 'render_api.dart';
import 'render_blocks.dart';
import 'render_code.dart';
import 'render_common.dart';
import 'render_files.dart';
import 'render_presets.dart';
import 'render_previews.dart';
import 'render_tables.dart';

/// Fenced languages that become `DocsSnippet`s.
const Set<String> kSnippetLanguages = <String>{
  'dart',
  'bash',
  'sh',
  'shell',
  'json',
  'jsonc',
};

/// Locates `cli_snapshot.txt` (cwd first, then next to this entry point).
String _findCliSnapshot() {
  final List<String> candidates = <String>['tool/cli_snapshot.txt'];
  if (Platform.script.scheme == 'file') {
    candidates.add(
      '${File.fromUri(Platform.script).parent.path}/cli_snapshot.txt',
    );
  }
  for (final String candidate in candidates) {
    if (File(candidate).existsSync()) {
      return candidate;
    }
  }
  return candidates.first;
}

/// Builds the model from the registry (no file writes).
DocsModel buildDocsModel(String registryRoot) {
  final RegistryScan scan = scanRegistry(registryRoot);
  final Map<String, ApiFacts> api = <String, ApiFacts>{};
  final Map<String, String?> previewClasses = <String, String?>{};
  final Map<String, String?> previewExamples = <String, String?>{};
  final Map<String, List<String>> previewExampleNames =
      <String, List<String>>{};
  final Map<String, List<KeyboardRowFacts>> keyboard =
      <String, List<KeyboardRowFacts>>{};
  final Map<String, List<ReadmeBlock>> snippets = <String, List<ReadmeBlock>>{};

  for (final ComponentFacts component in scan.components) {
    final File entry = File('${scan.root}/${component.entry}');
    if (!entry.existsSync()) {
      throw RegistryScanException(
        '${component.id}: missing entry file ${component.entry}',
      );
    }
    final String entrySource = entry.readAsStringSync();
    api[component.id] = extractApi(
      source: entrySource,
      nameCandidates: <String>[
        pascalCase(component.name),
        pascalCase(component.id),
        ...component.apiClasses,
      ],
      declared: DeclaredMembers(
        methods: component.apiMethods,
        constants: component.apiConstants,
        functions: component.apiFunctions,
      ),
      sources: declaredSources(scan.root, component, entrySource, entry.path),
    );

    final File preview = File(
      '${scan.root}/components/${component.id}/preview.dart',
    );
    if (!preview.existsSync()) {
      throw RegistryScanException(
        '${component.id}: missing preview.dart (the deferred preview '
        'registry needs it)',
      );
    }
    // The P6-F3 preview contract swaps the single gallery class for a
    // named-example list; both are supported, one of the two must exist.
    final String previewSource = preview.readAsStringSync();
    previewClasses[component.id] = findPreviewClass(
      source: previewSource,
      componentId: component.id,
      displayName: component.name,
    );
    final String? exampleList = findPreviewExampleList(source: previewSource);
    previewExamples[component.id] = exampleList;
    previewExampleNames[component.id] = findPreviewExamples(
      source: previewSource,
    );
    if (previewClasses[component.id] == null &&
        previewExamples[component.id] == null) {
      throw DartScanException(
        '${component.id}/preview.dart: neither a <name>Previews list nor one '
        '*Preview widget class',
      );
    }

    final File readme = File(
      '${scan.root}/components/${component.id}/README.md',
    );
    final ReadmeDoc doc = readme.existsSync()
        ? parseReadme(readme.readAsStringSync())
        : const ReadmeDoc(blocks: <ReadmeBlock>[], sections: <ReadmeSection>[]);
    keyboard[component.id] = keyboardRows(doc);
    snippets[component.id] = <ReadmeBlock>[
      for (final ReadmeBlock block in doc.blocks)
        if (kSnippetLanguages.contains(block.language)) block,
    ];
  }

  final File cliSnapshot = File(_findCliSnapshot());
  if (!cliSnapshot.existsSync()) {
    throw RegistryScanException(
      'missing ${cliSnapshot.absolute.path} (hand-maintained CLI snapshot)',
    );
  }
  final List<CliCommandFacts> cliCommands = parseCliSnapshot(
    cliSnapshot.readAsStringSync(),
  );
  if (cliCommands.isEmpty) {
    throw RegistryScanException(
      'cli_snapshot.txt has no `\$ flutter_shadcn …` sections',
    );
  }

  final Map<String, List<BlockFileFacts>> blockSources =
      <String, List<BlockFileFacts>>{};
  final Map<String, String> blockClasses = <String, String>{};
  for (final BlockFacts block in scan.blocks) {
    final List<BlockFileFacts> files = <BlockFileFacts>[];
    for (final String file in block.files) {
      final File source = File('${scan.root}/$file');
      if (!source.existsSync()) {
        throw RegistryScanException('${block.id}: missing file ${source.path}');
      }
      files.add(BlockFileFacts(path: file, code: source.readAsStringSync()));
    }
    blockSources[block.id] = files;
    blockClasses[block.id] = findBlockWidgetClass(
      source: files.first.code,
      blockId: block.id,
    );
  }

  return DocsModel(
    scan: scan,
    api: api,
    previewClasses: previewClasses,
    previewExamples: previewExamples,
    previewExampleNames: previewExampleNames,
    keyboard: keyboard,
    snippets: snippets,
    cliCommands: cliCommands,
    blockSources: blockSources,
    blockClasses: blockClasses,
  );
}

/// Renders every generated file, keyed by target path.
Map<String, String> renderBundle(
  DocsModel model, {
  required String outDir,
  required String previewsPath,
  required String themeImport,
  String blockSourcesPath = 'lib/blocks/block_sources.dart',
  String blockPreviewsPath = 'lib/previews/block_previews.dart',
}) {
  return <String, String>{
    '$outDir/docs_data.dart': renderDocsData(model),
    '$outDir/docs_api.dart': renderDocsApi(model),
    '$outDir/docs_tables.dart': renderDocsTables(model),
    '$outDir/docs_search.dart': renderDocsSearch(model),
    '$outDir/docs_snippets.dart': renderDocsSnippets(model),
    '$outDir/docs_blocks.dart': renderDocsBlocks(model),
    '$outDir/docs_preset_sources.dart': renderPresetSources(model.scan),
    '$outDir/docs_previews.dart': renderDocsPreviews(model),
    '$outDir/app_theme.dart': renderAppTheme(
      model.scan,
      themeImport: themeImport,
    ),
    previewsPath: renderComponentPreviews(
      model.scan,
      model.previewClasses,
      model.previewExamples,
    ),
    blockSourcesPath: renderBlockSources(model.scan, model.blockSources),
    blockPreviewsPath: renderBlockPreviews(model.scan, model.blockClasses),
  };
}

/// Multi-line model summary printed before writing/checking.
String describeModel(DocsModel model) {
  final int withApi = model.api.values
      .where((ApiFacts facts) => facts.hasApiTable)
      .length;
  final List<String> parseErrors = <String>[
    for (final ComponentFacts component in model.scan.components)
      if (!(model.api[component.id]?.parseClean ?? true)) component.id,
  ];
  final List<String> gaps = <String>[
    for (final ComponentFacts component in model.scan.components)
      if ((model.keyboard[component.id] ?? const <KeyboardRowFacts>[]).isEmpty)
        component.id,
  ];
  int snippetCount = 0;
  final Map<String, int> snippetLanguages = <String, int>{};
  for (final List<ReadmeBlock> blocks in model.snippets.values) {
    for (final ReadmeBlock block in blocks) {
      snippetCount++;
      snippetLanguages[block.language] =
          (snippetLanguages[block.language] ?? 0) + 1;
    }
  }
  final String languages = snippetLanguages.entries
      .map((MapEntry<String, int> entry) => '${entry.key} ${entry.value}')
      .join(', ');
  final List<String> memberComponents = <String>[
    for (final ComponentFacts component in model.scan.components)
      if ((model.api[component.id]?.members.length ?? 0) > 0) component.id,
  ];
  final int memberRows = model.api.values.fold<int>(
    0,
    (int sum, ApiFacts facts) => sum + facts.members.length,
  );
  final String members = memberRows == 0
      ? ''
      : 'api members: $memberRows declared rows '
            '(${memberComponents.join(', ')})\n';
  return 'components: ${model.scan.components.length} '
      '(${model.scan.components.where((ComponentFacts c) => c.listed).length} '
      'listed), '
      'presets: ${model.scan.presets.length} '
      '(+${model.scan.presets.length} json/dart sources), '
      'blocks: ${model.scan.blocks.length} '
      '(${model.blockSources.values.fold<int>(0, (int sum, List<BlockFileFacts> f) => sum + f.length)} files)\n'
      'snippets: $snippetCount ($languages)\n'
      'api tables: $withApi with parameters, '
      '${model.scan.components.length - withApi} without\n'
      '$members'
      'keyboard: ${gaps.length} gaps of ${model.scan.components.length} '
      'components\n'
      'keyboard gaps: ${gaps.join(', ')}\n'
      'parse errors (entry files): '
      '${parseErrors.isEmpty ? 'none' : parseErrors.join(', ')}\n'
      'previews: ${model.scan.components.length} deferred imports';
}
