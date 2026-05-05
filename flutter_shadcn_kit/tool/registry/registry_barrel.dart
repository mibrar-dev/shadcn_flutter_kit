import 'dart:convert';
import 'dart:io';

typedef JsonMap = Map<String, dynamic>;
typedef JsonList = List<dynamic>;

const List<String> sharedThemeExports = <String>[
  'registry/shared/theme/app_theme.dart',
  'registry/shared/theme/app_theme_preset.dart',
  'registry/shared/theme/color_scheme.dart',
  'registry/shared/theme/component_theme_global_registry.dart',
  'registry/shared/theme/generated_colors.dart',
  'registry/shared/theme/preset_themes.dart',
  'registry/shared/theme/theme.dart',
  'registry/shared/theme/typography.dart',
];

const Map<String, List<String>> barrelHideOverrides = <String, List<String>>{
  'registry/components/form/text_field/text_field.dart': <String>[
    'AcceptSuggestionIntent',
    'AutoComplete',
    'AutoCompleteCompleter',
    'AutoCompleteIntent',
    'AutoCompleteMode',
    'AutoCompleteTheme',
    'buildEditableTextContextMenu',
    'InputAutoCompleteFeature',
    'InputCopyFeature',
    'InputFeaturePosition',
    'InputHintFeature',
    'InputClearFeature',
    'InputLeadingFeature',
    'InputPasswordToggleFeature',
    'InputPasteFeature',
    'InputRevalidateFeature',
    'InputShowHintIntent',
    'InputSpinnerFeature',
    'InputTrailingFeature',
    'NavigateSuggestionIntent',
    'PasswordPeekMode',
    'SuggestionBuilder',
  ],
  'registry/components/layout/scrollable/scrollable.dart': <String>[
    'ScrollableBuilder',
    'ScrollableClient',
    'ScrollableClientTheme',
    'ScrollableClientViewport',
    'RenderScrollableClientViewport',
  ],
  'registry/components/layout/table/table.dart': <String>[
    'Table',
    'TableRow',
  ],
  'registry/components/navigation/tabs/tabs.dart': <String>[
    'KeyedTabChild',
    'KeyedTabChildWidget',
    'KeyedTabItem',
    'TabBuilder',
    'TabChildBuilder',
    'TabChild',
    'TabContainer',
    'TabChildWidget',
    'TabContainerData',
    'TabContainerTheme',
    'TabItem',
    'TabPaneData',
    'TabPaneItemBuilder',
    'TabPane',
    'TabPaneState',
    'TabPaneTheme',
  ],
  'registry/components/overlay/menu/menu.dart': <String>[
    'Menubar',
    'MenubarState',
    'MenubarTheme',
    'MenuPopup',
    'MenuPopupTheme',
  ],
};

Directory? findRegistryRoot(Directory start) {
  Directory current = start.absolute;
  while (true) {
    final candidate = File(
      '${current.path}/lib/registry/manifests/components.json',
    );
    if (candidate.existsSync()) {
      return current;
    }
    final parent = current.parent;
    if (parent.path == current.path) {
      return null;
    }
    current = parent;
  }
}

String? _resolveComponentEntryPoint(JsonMap component) {
  final category = component['category'];
  final id = component['id'];
  if (category is! String || id is! String) {
    return null;
  }

  final prefix = 'registry/components/$category/$id/';
  final topLevelSources = (component['files'] as JsonList? ?? const <dynamic>[])
      .whereType<JsonMap>()
      .map((file) => file['source'])
      .whereType<String>()
      .where((source) {
        if (!source.startsWith(prefix)) return false;
        final relative = source.substring(prefix.length);
        if (relative.contains('/')) return false;
        if (!relative.endsWith('.dart')) return false;
        return !relative.startsWith('_');
      })
      .toList();

  final conventionalEntryPoint = '$prefix$id.dart';
  if (topLevelSources.contains(conventionalEntryPoint)) {
    return conventionalEntryPoint;
  }

  if (topLevelSources.length == 1) {
    return topLevelSources.single;
  }

  return null;
}

String buildRootBarrel(Directory registryRoot) {
  final manifest = File(
    '${registryRoot.path}/lib/registry/manifests/components.json',
  );
  final data = jsonDecode(manifest.readAsStringSync()) as JsonMap;
  final components = (data['components'] as JsonList? ?? const <dynamic>[])
      .whereType<JsonMap>()
      .toList();

  final componentExports = <String>[];
  for (final component in components) {
    final entryPoint = _resolveComponentEntryPoint(component);
    if (entryPoint == null) continue;
    componentExports.add(entryPoint);
  }
  componentExports.sort();

  final lines = <String>[
    '// GENERATED FILE - DO NOT EDIT.',
    '// Run: dart run tool/registry/registry_barrel_generate.dart',
    '',
  ];

  for (final export in sharedThemeExports) {
    lines.add("export '$export';");
  }

  lines.add('');

  for (final export in componentExports) {
    final hides = barrelHideOverrides[export];
    if (hides == null || hides.isEmpty) {
      lines.add("export '$export';");
      continue;
    }

    if (hides.length == 1) {
      lines.add("export '$export' hide ${hides.single};");
      continue;
    }

    lines.add("export '$export'");
    lines.add('    hide');
    for (var i = 0; i < hides.length; i++) {
      final suffix = i == hides.length - 1 ? ';' : ',';
      lines.add('        ${hides[i]}$suffix');
    }
  }

  return '${lines.join('\n')}\n';
}
