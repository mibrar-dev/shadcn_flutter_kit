// Renderers for the registry-shaped generated files:
// `docs_data.dart` (catalog + stats) and `docs_search.dart` (search index).

import 'literals.dart';
import 'readme_scan.dart';
import 'registry_scan.dart';
import 'render_common.dart';

/// Renders `lib/generated/docs_data.dart`.
String renderDocsData(DocsModel model) {
  final RegistryScan scan = model.scan;
  final StringBuffer out = StringBuffer()
    ..write(
      banner(
        sources: kManifestSources,
        regenerate: kRegenerateCommand,
        notes: <String>[
          'Every component, preset, category and stat is derived from the',
          'registry manifest; docs pages never hard-code registry facts.',
        ],
      ),
    )
    ..writeln()
    ..writeln(
      '/// One installable component, generated from the registry manifest.',
    )
    ..writeln('class DocsComponent {')
    ..writeln('  /// Creates a component entry.')
    ..writeln('  const DocsComponent({')
    ..writeln('    required this.id,')
    ..writeln('    required this.name,')
    ..writeln('    required this.category,')
    ..writeln('    required this.description,')
    ..writeln('    required this.install,')
    ..writeln('    required this.import,')
    ..writeln('    required this.fileCount,')
    ..writeln('    required this.stability,')
    ..writeln('    required this.listed,')
    ..writeln('  });')
    ..writeln()
    ..writeln('  /// Registry id / directory name.')
    ..writeln('  final String id;')
    ..writeln()
    ..writeln('  /// Display name.')
    ..writeln('  final String name;')
    ..writeln()
    ..writeln('  /// Manifest category (`form`, `overlay`, `display`, …).')
    ..writeln('  final String category;')
    ..writeln()
    ..writeln('  /// One-line description from the manifest.')
    ..writeln('  final String description;')
    ..writeln()
    ..writeln('  /// `flutter_shadcn add <id>` from the manifest.')
    ..writeln('  final String install;')
    ..writeln()
    ..writeln('  /// Corrected import line for the installed layout.')
    ..writeln('  final String import;')
    ..writeln()
    ..writeln(
      '  /// Installed Dart files: manifest `files` + user-owned theme file.',
    )
    ..writeln('  final int fileCount;')
    ..writeln()
    ..writeln(
      '  /// `stable` for every component — the manifest has no stability',
    )
    ..writeln('  /// field yet; this is a docs-site presentation constant.')
    ..writeln('  final String stability;')
    ..writeln()
    ..writeln(
      '  /// Whether the docs site lists this component (sidebar, index,',
    )
    ..writeln(
      '  /// palette). `listed: false` marks the building blocks: installable',
    )
    ..writeln('  /// and reachable through API links, but not browsable.')
    ..writeln('  final bool listed;')
    ..writeln('}')
    ..writeln()
    ..writeln('/// One theme preset, generated from `themes/index.json`.')
    ..writeln('class DocsPreset {')
    ..writeln('  /// Creates a preset entry.')
    ..writeln('  const DocsPreset({')
    ..writeln('    required this.id,')
    ..writeln('    required this.name,')
    ..writeln('    required this.modes,')
    ..writeln('  });')
    ..writeln()
    ..writeln('  /// Preset id (`modern-minimal`).')
    ..writeln('  final String id;')
    ..writeln()
    ..writeln('  /// Display name (`Modern Minimal`).')
    ..writeln('  final String name;')
    ..writeln()
    ..writeln('  /// Supported modes in declaration order (`light`, `dark`).')
    ..writeln('  final List<String> modes;')
    ..writeln('}')
    ..writeln()
    ..writeln('/// A catalog category with its component count.')
    ..writeln('class DocsCategory {')
    ..writeln('  /// Creates a category entry.')
    ..writeln('  const DocsCategory({required this.id, required this.count});')
    ..writeln()
    ..writeln('  /// Category id (`form`).')
    ..writeln('  final String id;')
    ..writeln()
    ..writeln('  /// Number of components in the category.')
    ..writeln('  final int count;')
    ..writeln('}')
    ..writeln()
    ..writeln('/// Compact link-grid row: id + name only (components index).')
    ..writeln('class DocsComponentLink {')
    ..writeln('  /// Creates a link row.')
    ..writeln(
      '  const DocsComponentLink({required this.id, required this.name});',
    )
    ..writeln()
    ..writeln('  /// Registry id / route segment (`/docs/components/<id>`).')
    ..writeln('  final String id;')
    ..writeln()
    ..writeln('  /// Display name.')
    ..writeln('  final String name;')
    ..writeln('}')
    ..writeln()
    ..writeln('/// Landing stats band values, each derived from the registry.')
    ..writeln('class DocsStats {')
    ..writeln('  /// Creates the stats block.')
    ..writeln('  const DocsStats({')
    ..writeln('    required this.components,')
    ..writeln('    required this.presets,')
    ..writeln('    required this.materialImports,')
    ..writeln('    required this.modes,')
    ..writeln('  });')
    ..writeln()
    ..writeln(
      '  /// Installable component count: manifest `components` entries.',
    )
    ..writeln('  final int components;')
    ..writeln()
    ..writeln('  /// Preset count: `themes/index.json` entries.')
    ..writeln('  final int presets;')
    ..writeln()
    ..writeln('  /// Material/Cupertino import directives found across the')
    ..writeln('  /// registry Dart files (must be 0).')
    ..writeln('  final int materialImports;')
    ..writeln()
    ..writeln('  /// Distinct preset modes (2: light + dark).')
    ..writeln('  final int modes;')
    ..writeln('}')
    ..writeln()
    ..writeln(
      '/// One global theme token: the shadcn CSS variable name in camelCase.',
    )
    ..writeln('class DocsThemeToken {')
    ..writeln('  /// Creates a token entry.')
    ..writeln(
      '  const DocsThemeToken({required this.name, required this.cssVar});',
    )
    ..writeln()
    ..writeln('  /// camelCase token name (`cardForeground`).')
    ..writeln('  final String name;')
    ..writeln()
    ..writeln('  /// shadcn CSS variable (`--card-foreground`).')
    ..writeln('  final String cssVar;')
    ..writeln('}')
    ..writeln();

  final List<String> components = <String>[
    for (final ComponentFacts component in scan.components)
      _componentLiteral(component),
  ];
  out
    ..writeln(
      '/// All ${scan.components.length} installable components, ordered by '
      'category then id.',
    )
    ..writeln('const List<DocsComponent> kComponents = <DocsComponent>[');
  for (final String component in components) {
    out.writeln('  $component,');
  }
  out
    ..writeln('];')
    ..writeln()
    ..writeln(
      '/// The ${scan.presets.length} theme presets in `themes/index.json` '
      'order.',
    )
    ..writeln('const List<DocsPreset> kPresets = <DocsPreset>[');
  for (final PresetFacts preset in scan.presets) {
    out.writeln(
      '  DocsPreset(id: ${dartString(preset.id)}, name: '
      '${dartString(preset.name)}, modes: ${stringList(preset.modes)}),',
    );
  }
  out
    ..writeln('];')
    ..writeln()
    ..writeln(
      '/// The ${scan.themeTokens.length} global theme tokens in registry '
      'declaration order (32 colours, then radius).',
    )
    ..writeln('const List<DocsThemeToken> kThemeTokens = <DocsThemeToken>[');
  for (final ThemeTokenFacts token in scan.themeTokens) {
    out.writeln(
      '  DocsThemeToken(name: ${dartString(token.name)}, cssVar: '
      '${dartString(token.cssVar)}),',
    );
  }
  out
    ..writeln('];')
    ..writeln();

  final List<ComponentFacts> alphabetical = <ComponentFacts>[...scan.components]
    ..sort(
      (ComponentFacts a, ComponentFacts b) =>
          a.name.toLowerCase().compareTo(b.name.toLowerCase()),
    );
  out
    ..writeln(
      '/// All ${scan.components.length} components as index-grid links, '
      'alphabetical by name.',
    )
    ..writeln(
      'const List<DocsComponentLink> kComponentLinks = <DocsComponentLink>[',
    );
  for (final ComponentFacts component in alphabetical) {
    out.writeln(
      '  DocsComponentLink(id: ${dartString(component.id)}, name: '
      '${dartString(component.name)}),',
    );
  }
  out
    ..writeln('];')
    ..writeln();

  final Map<String, int> counts = <String, int>{};
  for (final ComponentFacts component in scan.components) {
    counts[component.category] = (counts[component.category] ?? 0) + 1;
  }
  final List<String> categories = counts.keys.toList()
    ..sort((String a, String b) {
      final int byCount = counts[b]!.compareTo(counts[a]!);
      return byCount != 0 ? byCount : a.compareTo(b);
    });
  out
    ..writeln('/// Catalog categories, count descending then id.')
    ..writeln('const List<DocsCategory> kCategories = <DocsCategory>[');
  for (final String category in categories) {
    out.writeln(
      '  DocsCategory(id: ${dartString(category)}, count: '
      '${counts[category]}),',
    );
  }
  out
    ..writeln('];')
    ..writeln()
    ..writeln('/// Stats band values, each with its derivation.')
    ..writeln('const DocsStats kStats = DocsStats(')
    ..writeln('  components: ${scan.components.length}, // manifest entries')
    ..writeln('  presets: ${scan.presets.length}, // themes/index.json entries')
    ..writeln(
      '  materialImports: ${scan.materialImports}, // registry import '
      'directives',
    )
    ..writeln('  modes: ${_distinctModes(scan)}, // distinct preset modes')
    ..writeln(');')
    ..writeln();
  _writeCategoryGroups(out, scan);
  return out.toString();
}

String _componentLiteral(ComponentFacts component) {
  return callExpr('DocsComponent', <String>[
    'id: ${dartString(component.id)}',
    'name: ${dartString(component.name)}',
    'category: ${dartString(component.category)}',
    'description: ${dartStringSmart(component.description)}',
    'install: ${dartString(component.install)}',
    'import: ${dartStringSmart(component.import)}',
    'fileCount: ${component.fileCount}',
    "stability: 'stable'",
    'listed: ${component.listed}',
  ], indent: '  ');
}

/// One category group of the components index and the sidebar: the category id
/// plus its listed components, alphabetical by name.
class _CategoryGroup {
  const _CategoryGroup(this.id, this.links);

  final String id;
  final List<ComponentFacts> links;
}

/// The listed components grouped by category, count descending then id (the
/// order `kCategories` uses), each group alphabetical by name.
List<_CategoryGroup> _componentCategoryGroups(RegistryScan scan) {
  final Map<String, List<ComponentFacts>> byCategory =
      <String, List<ComponentFacts>>{};
  for (final ComponentFacts component in scan.components) {
    if (!component.listed) {
      continue;
    }
    byCategory
        .putIfAbsent(component.category, () => <ComponentFacts>[])
        .add(component);
  }
  final List<String> ordered = byCategory.keys.toList()
    ..sort((String a, String b) {
      final int byCount = byCategory[b]!.length.compareTo(
        byCategory[a]!.length,
      );
      return byCount != 0 ? byCount : a.compareTo(b);
    });
  return <_CategoryGroup>[
    for (final String category in ordered)
      _CategoryGroup(
        category,
        byCategory[category]!..sort(
          (ComponentFacts a, ComponentFacts b) =>
              a.name.toLowerCase().compareTo(b.name.toLowerCase()),
        ),
      ),
  ];
}

void _writeCategoryGroups(StringBuffer out, RegistryScan scan) {
  final List<_CategoryGroup> groups = _componentCategoryGroups(scan);
  out
    ..writeln('/// One component category with its listed components.')
    ..writeln('class DocsComponentCategory {')
    ..writeln('  /// Creates a category group.')
    ..writeln(
      '  const DocsComponentCategory({required this.id, required this.components});',
    )
    ..writeln()
    ..writeln(
      '  /// Category name as written in `meta.json` (`Forms & Inputs`).',
    )
    ..writeln('  final String id;')
    ..writeln()
    ..writeln('  /// The category\'s listed components, alphabetical by name.')
    ..writeln('  final List<DocsComponentLink> components;')
    ..writeln()
    ..writeln('  /// Number of listed components in the category.')
    ..writeln('  int get count => components.length;')
    ..writeln('}')
    ..writeln()
    ..writeln('/// Route slug of a component category (`forms-inputs`).')
    ..writeln('String componentCategorySlug(String id) {')
    ..writeln(
      '  return id.toLowerCase().replaceAll(RegExp(\'[^a-z0-9]+\'), \'-\')',
    )
    ..writeln("      .replaceAll(RegExp(r'^-|-\$'), '');")
    ..writeln('}')
    ..writeln()
    ..writeln(
      '/// The ${groups.length} component categories with their listed '
      'components,',
    )
    ..writeln(
      '/// count descending then id — the sidebar groups and the index '
      'sections.',
    )
    ..writeln(
      'const List<DocsComponentCategory> kComponentCategoryGroups = '
      '<DocsComponentCategory>[',
    );
  for (final _CategoryGroup group in groups) {
    out.writeln('  DocsComponentCategory(');
    out.writeln('    id: ${dartString(group.id)},');
    out.writeln('    components: <DocsComponentLink>[');
    for (final ComponentFacts component in group.links) {
      out.writeln(
        '      DocsComponentLink(id: ${dartString(component.id)}, name: ${dartString(component.name)}),',
      );
    }
    out
      ..writeln('    ],')
      ..writeln('  ),');
  }
  out.writeln('];');
}

int _distinctModes(RegistryScan scan) {
  final Set<String> modes = <String>{};
  for (final PresetFacts preset in scan.presets) {
    modes.addAll(preset.modes);
  }
  return modes.length;
}

/// Renders `lib/generated/docs_search.dart`.
String renderDocsSearch(DocsModel model) {
  final StringBuffer out = StringBuffer()
    ..write(
      banner(
        sources: const <String>[
          'flutter_shadcn_kit/lib/registry/manifests/registry.json',
          'flutter_shadcn_kit/lib/registry/themes/index.json',
          'docs/tool/cli_snapshot.txt',
        ],
        regenerate: kRegenerateCommand,
        notes: <String>[
          'Search index for the components index page and the command',
          'palette: components, CLI commands and presets.',
        ],
      ),
    )
    ..writeln()
    ..writeln('/// Search group of a [DocsSearchEntry].')
    ..writeln('enum DocsSearchKind {')
    ..writeln('  /// A component page.')
    ..writeln('  component,')
    ..writeln()
    ..writeln('  /// A block page (`/blocks/<id>`).')
    ..writeln('  block,')
    ..writeln()
    ..writeln('  /// A CLI command.')
    ..writeln('  command,')
    ..writeln()
    ..writeln('  /// A theme preset.')
    ..writeln('  preset,')
    ..writeln('}')
    ..writeln()
    ..writeln('/// One searchable row (`kDocsSearchIndex`).')
    ..writeln('class DocsSearchEntry {')
    ..writeln('  /// Creates a search entry.')
    ..writeln('  const DocsSearchEntry({')
    ..writeln('    required this.label,')
    ..writeln('    required this.kind,')
    ..writeln('    required this.route,')
    ..writeln('    this.tag,')
    ..writeln('    this.keywords = const <String>[],')
    ..writeln('    this.action,')
    ..writeln('  });')
    ..writeln()
    ..writeln('  /// Display label.')
    ..writeln('  final String label;')
    ..writeln()
    ..writeln('  /// Group in the palette.')
    ..writeln('  final DocsSearchKind kind;')
    ..writeln()
    ..writeln('  /// In-app route (`/docs/components/button`).')
    ..writeln('  final String route;')
    ..writeln()
    ..writeln('  /// Right-aligned hint (`12 files`, `CLI`, `preset`).')
    ..writeln('  final String? tag;')
    ..writeln()
    ..writeln('  /// Extra match terms (display name, tags).')
    ..writeln('  final List<String> keywords;')
    ..writeln()
    ..writeln('  /// Footer action (`flutter_shadcn add <id>`), or null.')
    ..writeln('  final String? action;')
    ..writeln('}')
    ..writeln()
    ..writeln('/// Static search index: components, CLI commands, presets.')
    ..writeln(
      'const List<DocsSearchEntry> kDocsSearchIndex = '
      '<DocsSearchEntry>[',
    );

  for (final BlockFacts block in model.scan.blocks) {
    out.writeln(
      '  ${callExpr(
        'DocsSearchEntry',
        <String>[
          'label: ${dartString(block.name)}',
          'kind: DocsSearchKind.block',
          'route: ${dartString('/blocks/${block.id}')}',
          "tag: 'block'",
          'action: ${dartString(block.install)}',
          'keywords: ${stringList(<String>[block.id, block.category], indent: '    ', appended: 1)}',
        ],
        indent: '  ',
        suffix: ',',
      )}',
    );
  }
  for (final ComponentFacts component in model.scan.components) {
    final List<String> keywords = <String>[component.name, ...component.tags];
    out.writeln(
      '  ${callExpr(
        'DocsSearchEntry',
        <String>['label: ${dartString(component.id)}', 'kind: DocsSearchKind.component', 'route: ${dartString('/docs/components/${component.id}')}', 'tag: ${dartString('${component.fileCount} files')}', if (keywords.isNotEmpty) 'keywords: ${stringList(keywords, indent: '    ', appended: 1)}'],
        indent: '  ',
        suffix: ',',
      )}',
    );
  }
  for (final CliCommandFacts command in model.cliCommands) {
    out.writeln(
      '  DocsSearchEntry(label: ${dartString(command.label)}, kind: '
      'DocsSearchKind.command, route: ${dartString('/docs/cli')}, '
      "tag: 'CLI'),",
    );
  }
  for (final PresetFacts preset in model.scan.presets) {
    out.writeln(
      '  DocsSearchEntry(label: ${dartString(preset.id)}, kind: '
      'DocsSearchKind.preset, route: ${dartString('/themes')}, '
      "tag: 'preset', keywords: <String>[${dartString(preset.name)}]),",
    );
  }
  out.writeln('];');
  return out.toString();
}
