// Renderer for the per-example generated file (P7-D1):
// `docs_example_sources.dart` (one display-code entry per named preview
// example, keyed by component id).
//
// Split out of `render_code.dart` for the ~400-line rule.

import 'example_sources.dart';
import 'literals.dart';
import 'registry_scan.dart';
import 'render_common.dart';

/// Renders `lib/generated/docs_example_sources.dart`.
String renderDocsExampleSources(DocsModel model) {
  final StringBuffer out = StringBuffer()
    ..write(
      banner(
        sources: const <String>[
          'flutter_shadcn_kit/lib/registry/components/<id>/preview.dart',
        ],
        regenerate: 'dart run tool/gen_docs_data.dart',
        notes: <String>[
          'One display-code entry per ComponentPreview element: the imports',
          'for the component plus the example builder and the private',
          'helpers it uses (read with package:analyzer, see',
          'tool/src/example_sources.dart). `kExampleSources` drives the',
          'per-example Code tabs (first entry of each list is the default).',
        ],
      ),
    )
    ..writeln()
    ..writeln('/// One named example plus its display code.')
    ..writeln('class DocsExampleSource {')
    ..writeln('  /// Creates the source.')
    ..writeln('  const DocsExampleSource({')
    ..writeln('    required this.name,')
    ..writeln('    this.description,')
    ..writeln('    required this.builder,')
    ..writeln('    required this.code,')
    ..writeln('  });')
    ..writeln()
    ..writeln('  /// Label shown on the card (`Default`, `With groups`).')
    ..writeln('  final String name;')
    ..writeln()
    ..writeln('  /// Optional one-line explanation under the card heading.')
    ..writeln('  final String? description;')
    ..writeln()
    ..writeln('  /// Builder expression (`_buttonDefault`).')
    ..writeln('  final String builder;')
    ..writeln()
    ..writeln('  /// Display code: imports plus the example body, verbatim.')
    ..writeln('  final String code;')
    ..writeln('}')
    ..writeln()
    ..writeln(
      '/// Example sources keyed by component id, in declaration order.',
    )
    ..writeln(
      'const Map<String, List<DocsExampleSource>> kExampleSources = '
      '<String, List<DocsExampleSource>>{',
    );
  for (final ComponentFacts component in model.scan.components) {
    final List<DocsExampleSourceFacts> examples =
        model.exampleSources[component.id] ?? const <DocsExampleSourceFacts>[];
    out.writeln('  ${dartString(component.id)}: <DocsExampleSource>[');
    for (final DocsExampleSourceFacts example in examples) {
      out
        ..writeln('    DocsExampleSource(')
        ..writeln('      name: ${dartString(example.name)},');
      if (example.description != null) {
        out.writeln(
          '      description: ${dartStringSmart(example.description!)},',
        );
      }
      out
        ..writeln('      builder: ${dartString(example.builder)},')
        ..writeln('      code: ${dartCodeString(example.code)},')
        ..writeln('    ),');
    }
    out.writeln('  ],');
  }
  out.writeln('};');
  return out.toString();
}
