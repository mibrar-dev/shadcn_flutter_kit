// Model building for the docs codegen: registry scan + analyzer extraction
// + README/CLI parsing, then rendering the whole bundle.

import 'dart:io';

import 'dart_scan.dart';
import 'readme_scan.dart';
import 'registry_scan.dart';
import 'render_api.dart';
import 'render_code.dart';
import 'render_common.dart';
import 'render_files.dart';
import 'render_presets.dart';
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
  final Map<String, String> previewClasses = <String, String>{};
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
    api[component.id] = extractApi(
      source: entry.readAsStringSync(),
      nameCandidates: <String>[
        pascalCase(component.name),
        pascalCase(component.id),
        ...component.apiClasses,
      ],
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
    previewClasses[component.id] = findPreviewClass(
      source: preview.readAsStringSync(),
      componentId: component.id,
      displayName: component.name,
    );

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

  return DocsModel(
    scan: scan,
    api: api,
    previewClasses: previewClasses,
    keyboard: keyboard,
    snippets: snippets,
    cliCommands: cliCommands,
  );
}

/// Renders every generated file, keyed by target path.
Map<String, String> renderBundle(
  DocsModel model, {
  required String outDir,
  required String previewsPath,
  required String themeImport,
}) {
  return <String, String>{
    '$outDir/docs_data.dart': renderDocsData(model),
    '$outDir/docs_api.dart': renderDocsApi(model),
    '$outDir/docs_tables.dart': renderDocsTables(model),
    '$outDir/docs_search.dart': renderDocsSearch(model),
    '$outDir/docs_snippets.dart': renderDocsSnippets(model),
    '$outDir/docs_preset_sources.dart': renderPresetSources(model.scan),
    '$outDir/app_theme.dart': renderAppTheme(
      model.scan,
      themeImport: themeImport,
    ),
    previewsPath: renderComponentPreviews(model.scan, model.previewClasses),
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
  return 'components: ${model.scan.components.length}, '
      'presets: ${model.scan.presets.length} '
      '(+${model.scan.presets.length} json/dart sources)\n'
      'snippets: $snippetCount ($languages)\n'
      'api tables: $withApi with parameters, '
      '${model.scan.components.length - withApi} without\n'
      'keyboard: ${gaps.length} gaps of ${model.scan.components.length} '
      'components\n'
      'keyboard gaps: ${gaps.join(', ')}\n'
      'parse errors (entry files): '
      '${parseErrors.isEmpty ? 'none' : parseErrors.join(', ')}\n'
      'previews: ${model.scan.components.length} deferred imports';
}
