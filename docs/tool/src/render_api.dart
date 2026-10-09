// Renderer for `docs_api.dart`: per-component constructor API tables
// (package:analyzer) and theme-field tables (manifest `<Name>Theme` maps).

import 'dart_scan.dart';
import 'literals.dart';
import 'registry_scan.dart';
import 'render_common.dart';

/// Renders `lib/generated/docs_api.dart`.
String renderDocsApi(DocsModel model) {
  final StringBuffer out = StringBuffer()
    ..write(
      banner(
        sources: const <String>[
          'flutter_shadcn_kit/lib/registry/manifests/registry.json',
          'flutter_shadcn_kit/lib/registry/components/<id>/<entry>.dart',
          'flutter_shadcn_kit/lib/registry/components/<id>/README.md',
        ],
        regenerate: kRegenerateCommand,
        notes: <String>[
          'API params are extracted from each component entry file with',
          'package:analyzer (unresolved AST, require-first order).',
          'Theme fields come from the manifest `<Name>Theme` field map.',
          '`parseClean: false` marks entry files the analyzer cannot parse',
          'cleanly; their facts are best-effort.',
        ],
      ),
    )
    ..writeln()
    ..writeln('/// One constructor parameter row.')
    ..writeln('class DocsApiParam {')
    ..writeln('  /// Creates a parameter row.')
    ..writeln('  const DocsApiParam({')
    ..writeln('    required this.name,')
    ..writeln('    required this.type,')
    ..writeln('    required this.isRequired,')
    ..writeln('    this.defaultValue,')
    ..writeln('    this.doc,')
    ..writeln('  });')
    ..writeln()
    ..writeln('  /// Parameter name.')
    ..writeln('  final String name;')
    ..writeln()
    ..writeln('  /// Declared type, or empty when unresolved.')
    ..writeln('  final String type;')
    ..writeln()
    ..writeln('  /// Whether the parameter is required.')
    ..writeln('  final bool isRequired;')
    ..writeln()
    ..writeln('  /// Default expression source, or null.')
    ..writeln('  final String? defaultValue;')
    ..writeln()
    ..writeln('  /// Doc comment, or null.')
    ..writeln('  final String? doc;')
    ..writeln('}')
    ..writeln()
    ..writeln('/// The constructor API table of one component.')
    ..writeln('class DocsApiTable {')
    ..writeln('  /// Creates the table.')
    ..writeln('  const DocsApiTable({')
    ..writeln('    required this.componentId,')
    ..writeln('    required this.symbol,')
    ..writeln('    required this.hasApiTable,')
    ..writeln('    required this.parseClean,')
    ..writeln('    this.summary,')
    ..writeln('    required this.params,')
    ..writeln('  });')
    ..writeln()
    ..writeln('  /// Owning component id.')
    ..writeln('  final String componentId;')
    ..writeln()
    ..writeln('  /// Primary class name (`Button`), or empty.')
    ..writeln('  final String symbol;')
    ..writeln()
    ..writeln('  /// Whether a primary constructor was found.')
    ..writeln('  final bool hasApiTable;')
    ..writeln()
    ..writeln('  /// Whether the entry file parsed without diagnostics.')
    ..writeln('  final bool parseClean;')
    ..writeln()
    ..writeln('  /// First paragraph of the class doc, or null.')
    ..writeln('  final String? summary;')
    ..writeln()
    ..writeln('  /// Constructor parameters, required first.')
    ..writeln('  final List<DocsApiParam> params;')
    ..writeln('}')
    ..writeln()
    ..writeln('/// One `<Name>Theme` field.')
    ..writeln('class DocsThemeField {')
    ..writeln('  /// Creates a field row.')
    ..writeln('  const DocsThemeField({')
    ..writeln('    required this.name,')
    ..writeln('    required this.type,')
    ..writeln('    required this.description,')
    ..writeln('  });')
    ..writeln()
    ..writeln('  /// Field name (`primary`).')
    ..writeln('  final String name;')
    ..writeln()
    ..writeln('  /// Declared type (`ButtonVariantStyle?`).')
    ..writeln('  final String type;')
    ..writeln()
    ..writeln('  /// Description, or empty.')
    ..writeln('  final String description;')
    ..writeln('}')
    ..writeln()
    ..writeln('/// The per-component theme table of one component.')
    ..writeln('class DocsThemeTable {')
    ..writeln('  /// Creates the table.')
    ..writeln('  const DocsThemeTable({')
    ..writeln('    required this.componentId,')
    ..writeln('    required this.themeClass,')
    ..writeln('    required this.themeDefaults,')
    ..writeln('    required this.userFile,')
    ..writeln('    required this.userOwned,')
    ..writeln('    required this.hasTheme,')
    ..writeln('    required this.fields,')
    ..writeln('  });')
    ..writeln()
    ..writeln('  /// Owning component id.')
    ..writeln('  final String componentId;')
    ..writeln()
    ..writeln('  /// `<Name>Theme` class, or empty.')
    ..writeln('  final String themeClass;')
    ..writeln()
    ..writeln('  /// Defaults constant (`buttonDefaults`), or empty.')
    ..writeln('  final String themeDefaults;')
    ..writeln()
    ..writeln('  /// Declared user theme file (`button_theme.dart`), or empty.')
    ..writeln('  final String userFile;')
    ..writeln()
    ..writeln('  /// Whether this component owns the user file.')
    ..writeln('  final bool userOwned;')
    ..writeln()
    ..writeln('  /// Whether the component has a theme class at all.')
    ..writeln('  final bool hasTheme;')
    ..writeln()
    ..writeln('  /// Theme fields, sorted by name.')
    ..writeln('  final List<DocsThemeField> fields;')
    ..writeln('}')
    ..writeln();

  out
    ..writeln('/// API tables keyed by component id (all components present).')
    ..writeln(
      'const Map<String, DocsApiTable> kApiTables = '
      '<String, DocsApiTable>{',
    );
  for (final ComponentFacts component in model.scan.components) {
    out.writeln(
      '  ${dartString(component.id)}: ${_apiTableLiteral(component, model.api[component.id]!)},',
    );
  }
  out
    ..writeln('};')
    ..writeln()
    ..writeln(
      '/// Theme tables keyed by component id (all components present).',
    )
    ..writeln(
      'const Map<String, DocsThemeTable> kThemeTables = '
      '<String, DocsThemeTable>{',
    );
  for (final ComponentFacts component in model.scan.components) {
    out.writeln(
      '  ${dartString(component.id)}: ${_themeTableLiteral(component)},',
    );
  }
  out.writeln('};');
  return out.toString();
}

String _apiTableLiteral(ComponentFacts component, ApiFacts api) {
  final List<String> params = <String>[
    for (final ApiParamFacts param in api.params)
      callExpr('DocsApiParam', <String>[
        'name: ${dartString(param.name)}',
        'type: ${dartString(param.type)}',
        'isRequired: ${param.isRequired}',
        if (param.defaultValue != null)
          'defaultValue: ${dartString(param.defaultValue!)}',
        if (param.doc != null) 'doc: ${dartString(param.doc!)}',
      ], indent: '      '),
  ];
  return callExpr('DocsApiTable', <String>[
    'componentId: ${dartString(component.id)}',
    'symbol: ${dartString(api.symbol)}',
    'hasApiTable: ${api.hasApiTable}',
    'parseClean: ${api.parseClean}',
    if (api.summary != null) 'summary: ${dartString(api.summary!)}',
    'params: ${listExpr('<DocsApiParam>', params, indent: '    ', appended: 1)}',
  ], indent: '  ');
}

String _themeTableLiteral(ComponentFacts component) {
  final List<String> fields = <String>[
    for (final ThemeFieldValue field in component.themeFields)
      callExpr('DocsThemeField', <String>[
        'name: ${dartString(field.name)}',
        'type: ${dartString(field.type)}',
        'description: ${dartString(field.description)}',
      ], indent: '      '),
  ];
  return callExpr('DocsThemeTable', <String>[
    'componentId: ${dartString(component.id)}',
    'themeClass: ${dartString(component.themeClass ?? '')}',
    'themeDefaults: ${dartString(component.themeDefaults ?? '')}',
    'userFile: ${dartString(component.themeUserFile ?? '')}',
    'userOwned: ${component.hasUserTheme}',
    'hasTheme: ${component.hasTheme}',
    'fields: ${listExpr('<DocsThemeField>', fields, indent: '    ', appended: 1)}',
  ], indent: '  ');
}
