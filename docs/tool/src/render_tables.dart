// Renderer for `docs_tables.dart`: keyboard/a11y rows, dependency chips,
// related-component ids and the parsed CLI snapshot.

import 'literals.dart';
import 'readme_scan.dart';
import 'registry_scan.dart';
import 'render_common.dart';

/// Renders `lib/generated/docs_tables.dart`.
String renderDocsTables(DocsModel model) {
  final StringBuffer out = StringBuffer()
    ..write(
      banner(
        sources: const <String>[
          'flutter_shadcn_kit/lib/registry/components/<id>/README.md',
          'flutter_shadcn_kit/lib/registry/manifests/registry.json',
          'docs/tool/cli_snapshot.txt',
        ],
        regenerate: kRegenerateCommand,
        notes: <String>[
          'Keyboard rows are a conservative heuristic over README sections',
          'whose heading matches keyboard|a11y|accessib|behavio(u)r;',
          'components with no rows are listed in kKeyboardGaps and MUST NOT',
          'be hand-filled — extend the component README instead.',
        ],
      ),
    )
    ..writeln()
    ..writeln('/// One keyboard/a11y row parsed from a README.')
    ..writeln('class DocsKeyboardRow {')
    ..writeln('  /// Creates the row.')
    ..writeln('  const DocsKeyboardRow({')
    ..writeln('    required this.keys,')
    ..writeln('    required this.action,')
    ..writeln('    required this.source,')
    ..writeln('  });')
    ..writeln()
    ..writeln('  /// Key or key combination (`ArrowDown / ArrowUp`).')
    ..writeln('  final String keys;')
    ..writeln()
    ..writeln('  /// What the key does.')
    ..writeln('  final String action;')
    ..writeln()
    ..writeln('  /// README section the row came from.')
    ..writeln('  final String source;')
    ..writeln('}')
    ..writeln()
    ..writeln('/// Registry layer a dependency belongs to.')
    ..writeln('enum DocsDepKind {')
    ..writeln('  /// Another component (flagged edge, e.g. tabs -> sortable).')
    ..writeln('  component,')
    ..writeln()
    ..writeln('  /// Shared primitive.')
    ..writeln('  primitive,')
    ..writeln()
    ..writeln('  /// Foundation layer unit.')
    ..writeln('  foundation,')
    ..writeln()
    ..writeln('  /// Theme layer unit.')
    ..writeln('  theme,')
    ..writeln('}')
    ..writeln()
    ..writeln('/// One dependency chip.')
    ..writeln('class DocsDep {')
    ..writeln('  /// Creates a dependency chip.')
    ..writeln('  const DocsDep({required this.id, required this.kind});')
    ..writeln()
    ..writeln('  /// Unit id (`clickable`, `button`, `theme`).')
    ..writeln('  final String id;')
    ..writeln()
    ..writeln('  /// Owning layer.')
    ..writeln('  final DocsDepKind kind;')
    ..writeln('}')
    ..writeln()
    ..writeln('/// One flag of a CLI command section.')
    ..writeln('class DocsCliFlag {')
    ..writeln('  /// Creates the flag.')
    ..writeln('  const DocsCliFlag({')
    ..writeln('    required this.name,')
    ..writeln('    this.alias,')
    ..writeln('    this.placeholder,')
    ..writeln('    required this.description,')
    ..writeln('  });')
    ..writeln()
    ..writeln('  /// Long flag name (`--dry-run`).')
    ..writeln('  final String name;')
    ..writeln()
    ..writeln('  /// Short alias (`-h`), or null.')
    ..writeln('  final String? alias;')
    ..writeln()
    ..writeln('  /// Value placeholder (`<path>`), or null.')
    ..writeln('  final String? placeholder;')
    ..writeln()
    ..writeln('  /// One-line description.')
    ..writeln('  final String description;')
    ..writeln('}')
    ..writeln()
    ..writeln('/// One command section of cli_snapshot.txt.')
    ..writeln('class DocsCliCommand {')
    ..writeln('  /// Creates the command.')
    ..writeln('  const DocsCliCommand({')
    ..writeln('    required this.label,')
    ..writeln('    required this.invocation,')
    ..writeln('    required this.usage,')
    ..writeln('    required this.summary,')
    ..writeln('    required this.helpText,')
    ..writeln('    required this.flags,')
    ..writeln('  });')
    ..writeln()
    ..writeln('  /// Invocation without `--help` (`flutter_shadcn add`).')
    ..writeln('  final String label;')
    ..writeln()
    ..writeln('  /// Full invocation line.')
    ..writeln('  final String invocation;')
    ..writeln()
    ..writeln('  /// `Usage:` string.')
    ..writeln('  final String usage;')
    ..writeln()
    ..writeln('  /// First description line of the section.')
    ..writeln('  final String summary;')
    ..writeln()
    ..writeln('  /// Section body verbatim (renders in `CodeSnippet`).')
    ..writeln('  final String helpText;')
    ..writeln()
    ..writeln('  /// Parsed flags.')
    ..writeln('  final List<DocsCliFlag> flags;')
    ..writeln('}')
    ..writeln();

  out
    ..writeln('/// Keyboard/a11y rows keyed by component id (empty = gap).')
    ..writeln(
      'const Map<String, List<DocsKeyboardRow>> kKeyboardRows = '
      '<String, List<DocsKeyboardRow>>{',
    );
  final List<String> gaps = <String>[];
  for (final ComponentFacts component in model.scan.components) {
    final List<KeyboardRowFacts> rows =
        model.keyboard[component.id] ?? const <KeyboardRowFacts>[];
    if (rows.isEmpty) {
      gaps.add(component.id);
      out.writeln('  ${dartString(component.id)}: <DocsKeyboardRow>[],');
      continue;
    }
    final List<String> items = <String>[
      for (final KeyboardRowFacts row in rows)
        callExpr('DocsKeyboardRow', <String>[
          'keys: ${dartString(row.keys)}',
          'action: ${dartString(row.action)}',
          'source: ${dartString(row.source)}',
        ], indent: '    '),
    ];
    out.writeln(
      '  ${dartString(component.id)}: ${listExpr('<DocsKeyboardRow>', items, indent: '  ', appended: 1)},',
    );
  }
  out
    ..writeln('};')
    ..writeln()
    ..writeln(
      '/// Components without keyboard/a11y rows in their README today.',
    )
    ..writeln(
      '/// Extend the component README (never this file) to close a gap.',
    )
    ..writeln('const List<String> kKeyboardGaps = <String>[');
  for (final String gap in gaps) {
    out.writeln('  ${dartString(gap)},');
  }
  out
    ..writeln('];')
    ..writeln()
    ..writeln(
      '/// Dependency chips keyed by component id (components first, then '
      'primitives, foundation, theme).',
    )
    ..writeln(
      'const Map<String, List<DocsDep>> kComponentDeps = '
      '<String, List<DocsDep>>{',
    );
  for (final ComponentFacts component in model.scan.components) {
    final List<String> items = <String>[
      for (final String layer in const <String>[
        'components',
        'primitives',
        'foundation',
        'theme',
      ])
        for (final String id in component.deps[layer] ?? const <String>[])
          'DocsDep(id: ${dartString(id)}, kind: DocsDepKind.${_depKindName(layer)})',
    ];
    out.writeln(
      '  ${dartString(component.id)}: ${listExpr('<DocsDep>', items, indent: '  ', appended: 1)},',
    );
  }
  out
    ..writeln('};')
    ..writeln()
    ..writeln('/// Parsed cli_snapshot.txt command sections.')
    ..writeln('const List<DocsCliCommand> kCliCommands = <DocsCliCommand>[');
  for (final CliCommandFacts command in model.cliCommands) {
    final List<String> flags = <String>[
      for (final CliFlagFacts flag in command.flags)
        callExpr('DocsCliFlag', <String>[
          'name: ${dartString(flag.name)}',
          if (flag.alias != null) 'alias: ${dartString(flag.alias!)}',
          if (flag.placeholder != null)
            'placeholder: ${dartString(flag.placeholder!)}',
          'description: ${dartString(flag.description)}',
        ], indent: '      '),
    ];
    out.writeln(
      '  ${callExpr(
        'DocsCliCommand',
        <String>['label: ${dartString(command.label)}', 'invocation: ${dartString(command.invocation)}', 'usage: ${dartString(command.usage)}', 'summary: ${dartString(command.summary)}', 'helpText: ${dartString(command.helpText)}', 'flags: ${listExpr('<DocsCliFlag>', flags, indent: '    ', appended: 1)}'],
        indent: '  ',
        suffix: ',',
      )}',
    );
  }
  out.writeln('];');
  return out.toString();
}

String _depKindName(String layer) => switch (layer) {
  'components' => 'component',
  'primitives' => 'primitive',
  _ => layer,
};
