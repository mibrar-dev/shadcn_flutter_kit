// Shared model + banner for the docs codegen renderers.

import 'api_model.dart';
import 'readme_scan.dart';
import 'registry_scan.dart';

/// Everything the docs renderers need, assembled once by the CLI entry.
class DocsModel {
  /// Creates the model.
  const DocsModel({
    required this.scan,
    required this.api,
    required this.previewClasses,
    required this.previewExamples,
    required this.previewExampleNames,
    required this.keyboard,
    required this.snippets,
    required this.cliCommands,
  });

  /// Registry facts (components, presets, stats inputs).
  final RegistryScan scan;

  /// API tables keyed by component id (all components present).
  final Map<String, ApiFacts> api;

  /// Preview widget class names keyed by component id (null when the file
  /// ships the P6-F3 named-example list instead).
  final Map<String, String?> previewClasses;

  /// Named-example list names keyed by component id (`<name>Previews`);
  /// null when the file ships the old single gallery class.
  final Map<String, String?> previewExamples;

  /// Named-example labels keyed by component id, in declaration order
  /// (P6-F4, read with `package:analyzer`); empty when the file ships the
  /// old single gallery class.
  final Map<String, List<String>> previewExampleNames;

  /// Keyboard rows keyed by component id (empty lists for gaps).
  final Map<String, List<KeyboardRowFacts>> keyboard;

  /// README code blocks keyed by component id.
  final Map<String, List<ReadmeBlock>> snippets;

  /// Parsed `cli_snapshot.txt` sections.
  final List<CliCommandFacts> cliCommands;
}

/// `// GENERATED CODE …` banner shared by every generated file.
String banner({
  required List<String> sources,
  required String regenerate,
  List<String> notes = const <String>[],
}) {
  final StringBuffer buffer = StringBuffer()
    ..writeln('// GENERATED CODE - DO NOT MODIFY BY HAND.')
    ..writeln('//')
    ..writeln('// Sources:');
  for (final String source in sources) {
    buffer.writeln('//   * $source');
  }
  buffer
    ..writeln('//')
    ..writeln('// Regenerate: $regenerate');
  if (notes.isNotEmpty) {
    buffer.writeln('//');
    for (final String note in notes) {
      buffer.writeln('// $note');
    }
  }
  return buffer.toString();
}

const List<String> kManifestSources = <String>[
  'flutter_shadcn_kit/lib/registry/manifests/registry.json',
  'flutter_shadcn_kit/lib/registry/themes/index.json',
];
const String kRegenerateCommand = 'dart run tool/gen_docs_data.dart';
