// Renderers for the code-shaped generated files:
// `docs_snippets.dart` (highlight maps + install file lists),
// `app_theme.dart` (all 43 presets, assembled from the kit generator) and
// `component_previews.dart` (deferred preview registry for D4).

import 'dart_highlight.dart';
import 'literals.dart';
import 'readme_scan.dart';
import 'registry_scan.dart';
import 'render_common.dart';

// The kit's values-only theme generator is the single source of truth for a
// preset's Dart blocks; importing its source (a VM-only library) keeps the
// docs output byte-identical to the CLI output by construction.
import '../../../flutter_shadcn_kit/tool/rearch/gen_app_theme.dart' as kit;

/// The docs mirror's theme library (sibling `color_tokens.dart`/`tokens.dart`
/// are derived from it by the kit generator).
const String kDocsThemeImport = 'package:docs/ui/shadcn/theme/theme.dart';

/// Renders `lib/generated/docs_snippets.dart`.
String renderDocsSnippets(DocsModel model) {
  final StringBuffer out = StringBuffer()
    ..write(
      banner(
        sources: const <String>[
          'flutter_shadcn_kit/lib/registry/components/<id>/README.md',
          'flutter_shadcn_kit/lib/registry/manifests/registry.json',
        ],
        regenerate: 'dart run tool/gen_docs_data.dart',
        notes: <String>[
          'Highlight classes are generated with package:analyzer (Dart) and',
          'small scanners (bash/json) at codegen time; `tokenClasses` holds',
          'one class per character of `code`: p plain, c comment, k keyword,',
          's string. `kComponentFileLists` drives the manual install tab.',
        ],
      ),
    )
    ..writeln()
    ..writeln("import 'package:flutter/widgets.dart';")
    ..writeln()
    ..writeln('/// Highlight class of one character run in a code snippet.')
    ..writeln('enum DocsCodeToken {')
    ..writeln('  /// Unstyled code.')
    ..writeln('  plain,')
    ..writeln()
    ..writeln('  /// `//`, `/* */` or `#` comments.')
    ..writeln('  comment,')
    ..writeln()
    ..writeln('  /// Language keywords and CLI command words.')
    ..writeln('  keyword,')
    ..writeln()
    ..writeln('  /// String literals.')
    ..writeln('  string,')
    ..writeln('}')
    ..writeln()
    ..writeln('/// One README code block plus its generated highlight classes.')
    ..writeln('class DocsSnippet {')
    ..writeln('  /// Creates a snippet.')
    ..writeln('  const DocsSnippet({')
    ..writeln('    required this.id,')
    ..writeln('    required this.componentId,')
    ..writeln('    required this.language,')
    ..writeln('    required this.code,')
    ..writeln('    required this.tokenClasses,')
    ..writeln('  });')
    ..writeln()
    ..writeln('  /// Stable id (`button.0`).')
    ..writeln('  final String id;')
    ..writeln()
    ..writeln('  /// Owning component id.')
    ..writeln('  final String componentId;')
    ..writeln()
    ..writeln('  /// Fence language (`dart`, `bash`).')
    ..writeln('  final String language;')
    ..writeln()
    ..writeln('  /// Block content, verbatim.')
    ..writeln('  final String code;')
    ..writeln()
    ..writeln('  /// One class per character of [code] (`p`/`c`/`k`/`s`).')
    ..writeln('  final String tokenClasses;')
    ..writeln()
    ..writeln('  /// Builds the highlighted spans for this snippet.')
    ..writeln('  List<TextSpan> spans({')
    ..writeln('    required TextStyle plain,')
    ..writeln('    required TextStyle comment,')
    ..writeln('    required TextStyle keyword,')
    ..writeln('    required TextStyle string,')
    ..writeln('  }) {')
    ..writeln('    final List<TextSpan> result = <TextSpan>[];')
    ..writeln('    if (code.isEmpty) {')
    ..writeln('      return result;')
    ..writeln('    }')
    ..writeln('    int start = 0;')
    ..writeln('    DocsCodeToken current = _tokenAt(0);')
    ..writeln('    for (int i = 1; i < code.length; i++) {')
    ..writeln('      final DocsCodeToken next = _tokenAt(i);')
    ..writeln('      if (next != current) {')
    ..writeln('        result.add(')
    ..writeln('          TextSpan(')
    ..writeln('            text: code.substring(start, i),')
    ..writeln(
      '            style: _styleFor(current, plain, comment, keyword, string),',
    )
    ..writeln('          ),')
    ..writeln('        );')
    ..writeln('        start = i;')
    ..writeln('        current = next;')
    ..writeln('      }')
    ..writeln('    }')
    ..writeln('    result.add(')
    ..writeln('      TextSpan(')
    ..writeln('        text: code.substring(start),')
    ..writeln(
      '        style: _styleFor(current, plain, comment, keyword, string),',
    )
    ..writeln('      ),')
    ..writeln('    );')
    ..writeln('    return result;')
    ..writeln('  }')
    ..writeln()
    ..writeln('  DocsCodeToken _tokenAt(int index) {')
    ..writeln('    return switch (tokenClasses.codeUnitAt(index)) {')
    ..writeln('      0x63 => DocsCodeToken.comment,')
    ..writeln('      0x6B => DocsCodeToken.keyword,')
    ..writeln('      0x73 => DocsCodeToken.string,')
    ..writeln('      _ => DocsCodeToken.plain,')
    ..writeln('    };')
    ..writeln('  }')
    ..writeln()
    ..writeln('  static TextStyle _styleFor(')
    ..writeln('    DocsCodeToken token,')
    ..writeln('    TextStyle plain,')
    ..writeln('    TextStyle comment,')
    ..writeln('    TextStyle keyword,')
    ..writeln('    TextStyle string,')
    ..writeln('  ) {')
    ..writeln('    return switch (token) {')
    ..writeln('      DocsCodeToken.plain => plain,')
    ..writeln('      DocsCodeToken.comment => comment,')
    ..writeln('      DocsCodeToken.keyword => keyword,')
    ..writeln('      DocsCodeToken.string => string,')
    ..writeln('    };')
    ..writeln('  }')
    ..writeln('}')
    ..writeln();

  out
    ..writeln('/// README code blocks keyed by component id, in README order.')
    ..writeln(
      'const Map<String, List<DocsSnippet>> kDocsSnippets = '
      '<String, List<DocsSnippet>>{',
    );
  for (final ComponentFacts component in model.scan.components) {
    final List<ReadmeBlock> blocks =
        model.snippets[component.id] ?? const <ReadmeBlock>[];
    out.writeln('  ${dartString(component.id)}: <DocsSnippet>[');
    for (int i = 0; i < blocks.length; i++) {
      final ReadmeBlock block = blocks[i];
      out
        ..writeln('    DocsSnippet(')
        ..writeln('      id: ${dartString('${component.id}.$i')},')
        ..writeln('      componentId: ${dartString(component.id)},')
        ..writeln('      language: ${dartString(block.language)},')
        ..writeln('      code: ${dartCodeString(block.code)},')
        ..writeln(
          '      tokenClasses: ${dartString(classifySnippet(block.language, block.code))},',
        )
        ..writeln('    ),');
    }
    out.writeln('  ],');
  }
  out
    ..writeln('};')
    ..writeln()
    ..writeln(
      '/// Note shown next to every manual install file list (user-owned',
    )
    ..writeln('/// `*_theme.dart` files are never overwritten by the CLI).')
    ..writeln(
      "const String kUserOwnedNote = 'User-owned *_theme.dart files are never overwritten.';",
    )
    ..writeln()
    ..writeln('/// The exact files the CLI installs for one component.')
    ..writeln('class DocsFileList {')
    ..writeln('  /// Creates the list.')
    ..writeln('  const DocsFileList({')
    ..writeln('    required this.componentId,')
    ..writeln('    required this.files,')
    ..writeln('    required this.userOwned,')
    ..writeln('  });')
    ..writeln()
    ..writeln('  /// Owning component id.')
    ..writeln('  final String componentId;')
    ..writeln()
    ..writeln('  /// Registry-owned files, install-root relative.')
    ..writeln('  final List<String> files;')
    ..writeln()
    ..writeln('  /// User-owned files, install-root relative.')
    ..writeln('  final List<String> userOwned;')
    ..writeln('}')
    ..writeln()
    ..writeln('/// Install file lists keyed by component id.')
    ..writeln(
      'const Map<String, DocsFileList> kComponentFileLists = '
      '<String, DocsFileList>{',
    );
  for (final ComponentFacts component in model.scan.components) {
    final List<String> files = <String>[
      for (final String file in component.files)
        '${model.scan.installRoot}/$file',
    ];
    final List<String> userOwned = <String>[
      for (final String file in component.userOwned)
        '${model.scan.installRoot}/$file',
    ];
    out
      ..writeln('  ${dartString(component.id)}: DocsFileList(')
      ..writeln('    componentId: ${dartString(component.id)},')
      ..writeln('    files: ${stringList(files, indent: '    ', appended: 1)},')
      ..writeln(
        '    userOwned: ${stringList(userOwned, indent: '    ', appended: 1)},',
      )
      ..writeln('  ),');
  }
  out.writeln('};');
  return out.toString();
}

/// Renders `lib/generated/app_theme.dart` from all presets.
///
/// Each preset block is the verbatim body of
/// `kit/ThemeValues.toDartSource()` output (header + imports stripped);
/// `gen_docs_data_test.dart` asserts the byte equality per preset.
String renderAppTheme(
  RegistryScan scan, {
  String themeImport = kDocsThemeImport,
}) {
  final Map<String, String> blocks = <String, String>{};
  for (final PresetFacts preset in scan.presets) {
    final kit.ThemeValues values = kit.ThemeValues.fromJson(
      kit.readPreset('${scan.root}/${preset.file}'),
    );
    final String source = values.toDartSource(themeImport: themeImport);
    final int cut = source.indexOf('/// Colour tokens for ');
    if (cut < 0) {
      throw StateError('${preset.id}: unexpected kit generator output');
    }
    blocks[preset.id] = source.substring(cut);
  }

  final StringBuffer out = StringBuffer()
    ..write(
      banner(
        sources: <String>[
          'flutter_shadcn_kit/lib/registry/themes/*.json '
              '(${scan.presets.length} presets, index.json order)',
        ],
        regenerate: 'dart run tool/gen_docs_data.dart',
        notes: <String>[
          'Every per-preset block below is the verbatim output of the kit',
          'generator flutter_shadcn_kit/tool/rearch/gen_app_theme.dart for',
          'that preset (minus its per-file header and imports).',
          'tool/gen_docs_data_test.dart asserts the byte equality per preset.',
          'buildDocsTheme is the docs-side resolver; the kit tool emits one',
          'file per preset, the docs bundle all of them.',
        ],
      ),
    )
    ..writeln()
    ..writeln("import 'package:flutter/widgets.dart';")
    ..writeln()
    ..writeln("import 'package:docs/ui/shadcn/theme/color_tokens.dart';")
    ..writeln("import 'package:docs/ui/shadcn/theme/theme.dart';")
    ..writeln("import 'package:docs/ui/shadcn/theme/tokens.dart';")
    ..writeln();

  for (final PresetFacts preset in scan.presets) {
    out
      ..write(blocks[preset.id])
      ..writeln();
  }

  out
    ..writeln(
      '/// Default docs preset (mirrors `kDefaultDocsPresetId` in '
      '`state/docs_state.dart`).',
    )
    ..writeln("const String kDocsDefaultPresetId = 'neutral';")
    ..writeln()
    ..writeln('/// Resolves the generated theme factory for [presetId] and')
    ..writeln('/// [brightness].')
    ..writeln('///')
    ..writeln(
      '/// Unknown ids (a stale localStorage preference from an older docs',
    )
    ..writeln('/// build) fall back to [kDocsDefaultPresetId].')
    ..writeln(
      'ShadcnThemeData buildDocsTheme('
      'String presetId, Brightness brightness) {',
    )
    ..writeln('  return switch (presetId) {');
  for (final PresetFacts preset in scan.presets) {
    out.writeln(
      '    ${dartString(preset.id)} => ${_factoryName(preset.id)}(brightness),',
    );
  }
  out
    ..writeln('    _ => ${_factoryName('neutral')}(brightness),')
    ..writeln('  };')
    ..writeln('}');
  return out.toString();
}

String _factoryName(String id) {
  final String prefix = kit.camelCase(id);
  final String capitalized = prefix.isEmpty
      ? prefix
      : prefix[0].toUpperCase() + prefix.substring(1);
  return 'build${capitalized}Theme';
}

/// Renders `lib/previews/component_previews.dart`: the deferred preview
/// registry D4's component pages load. Preview files arrive in the docs app
/// through the registry mirror (`lib/ui/shadcn/components/<id>/preview.dart`,
/// synced by `tool/sync_registry.sh` and hash-covered by the manifest).
String renderComponentPreviews(
  RegistryScan scan,
  Map<String, String> previewClasses,
) {
  final StringBuffer out = StringBuffer()
    ..write(
      banner(
        sources: const <String>[
          'flutter_shadcn_kit/lib/registry/components/<id>/preview.dart',
        ],
        regenerate: 'dart run tool/gen_docs_data.dart',
        notes: <String>[
          'One deferred import per component; the chunk is fetched when a',
          'component page asks for its preview. Class names are read from',
          'the preview sources with package:analyzer.',
        ],
      ),
    )
    ..writeln()
    ..writeln("import 'package:flutter/widgets.dart';")
    ..writeln();
  for (final ComponentFacts component in scan.components) {
    out.writeln(
      "import 'package:docs/ui/shadcn/components/${component.id}/preview.dart' deferred as ${_prefix(component.id)};",
    );
  }
  out
    ..writeln()
    ..writeln(
      '/// Loads the preview widget for [componentId], fetching its deferred',
    )
    ..writeln('/// chunk first. Throws [ArgumentError] for unknown ids.')
    ..writeln('Future<Widget> loadComponentPreview(String componentId) =>')
    ..writeln('    switch (componentId) {');
  for (final ComponentFacts component in scan.components) {
    final String prefix = _prefix(component.id);
    final String className = previewClasses[component.id]!;
    out.writeln(
      "      ${dartString(component.id)} => $prefix.loadLibrary().then((_) => $prefix.$className()),",
    );
  }
  out
    ..writeln(
      "      _ => throw ArgumentError.value(componentId, 'componentId', "
      "'no registered preview'),",
    )
    ..writeln('    };');
  return out.toString();
}

String _prefix(String id) =>
    'preview_${id.replaceAll(RegExp('[^A-Za-z0-9_]'), '_')}';
