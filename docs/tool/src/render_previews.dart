// Renderers for the preview-shaped generated files (P6-F4):
// `docs_previews.dart` (named-example labels + counts per component) and
// `component_previews.dart` (deferred preview registry with an example index).
//
// Split out of `render_code.dart` for the ~400-line rule.

import 'literals.dart';
import 'registry_scan.dart';
import 'render_common.dart';

/// Renders `lib/generated/docs_previews.dart`: the named-example labels
/// (P6-F4) every component page shows in its `Select`.
///
/// Names are read with `package:analyzer` from the exported
/// `const List<ComponentPreview>` of each `preview.dart` (see
/// `findPreviewExamples`); the count of one component is the length of its
/// list. Old single-gallery previews (building blocks) map to an empty list.
String renderDocsPreviews(DocsModel model) {
  final StringBuffer out = StringBuffer()
    ..write(
      banner(
        sources: const <String>[
          'flutter_shadcn_kit/lib/registry/components/<id>/preview.dart',
        ],
        regenerate: 'dart run tool/gen_docs_data.dart',
        notes: <String>[
          'Example labels are read with package:analyzer from the exported',
          'const List<ComponentPreview>; kComponentPreviews drives the docs',
          'example Select (first entry is the default).',
        ],
      ),
    )
    ..writeln()
    ..writeln(
      '/// Named docs examples keyed by component id, in declaration order.',
    )
    ..writeln('///')
    ..writeln(
      '/// The first entry is the default example the page shows first.',
    )
    ..writeln(
      'const Map<String, List<String>> kComponentPreviews = '
      '<String, List<String>>{',
    );
  for (final ComponentFacts component in model.scan.components) {
    final List<String> names =
        model.previewExampleNames[component.id] ?? const <String>[];
    out.writeln(
      '  ${dartString(component.id)}: ${stringList(names, indent: '  ', appended: 1)},',
    );
  }
  out
    ..writeln('};')
    ..writeln()
    ..writeln('/// Example counts keyed by component id.')
    ..writeln(
      'const Map<String, int> kComponentPreviewCounts = <String, int>{',
    );
  for (final ComponentFacts component in model.scan.components) {
    final int count =
        (model.previewExampleNames[component.id] ?? const <String>[]).length;
    out.writeln('  ${dartString(component.id)}: $count,');
  }
  out.writeln('};');
  return out.toString();
}

/// Renders `lib/previews/component_previews.dart`: the deferred preview
/// registry D4's component pages load. Preview files arrive in the docs app
/// through the registry mirror (`lib/ui/shadcn/components/<id>/preview.dart`,
/// synced by `tool/sync_registry.sh` and hash-covered by the manifest).
String renderComponentPreviews(
  RegistryScan scan,
  Map<String, String?> previewClasses,
  Map<String, String?> previewExamples,
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
          'component page asks for its preview. Class names and example',
          'lists are read from the preview sources with package:analyzer.',
          'P6-F4: loadComponentPreview takes an example index into the',
          'named-example list (first entry is the default).',
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
      '/// Loads the preview widget for [componentId] and [exampleIndex],',
    )
    ..writeln('/// fetching its deferred chunk first.')
    ..writeln('///')
    ..writeln('/// [exampleIndex] selects one entry of the exported')
    ..writeln(
      '/// `const List<ComponentPreview>` (first entry is the default);',
    )
    ..writeln(
      '/// old single-gallery previews ignore it. Throws [ArgumentError]',
    )
    ..writeln('/// for unknown ids and [RangeError] for unknown examples.')
    ..writeln(
      'Future<Widget> loadComponentPreview(String componentId, [int exampleIndex = 0]) =>',
    )
    ..writeln('    switch (componentId) {');
  for (final ComponentFacts component in scan.components) {
    final String prefix = _prefix(component.id);
    final String? exampleList = previewExamples[component.id];
    final String? className = previewClasses[component.id];
    if (exampleList == null) {
      out.writeln(
        "      ${dartString(component.id)} => $prefix.loadLibrary().then((_) => $prefix.$className()),",
      );
    } else {
      out.writeln(
        "      ${dartString(component.id)} => $prefix.loadLibrary().then((_) => Builder(builder: $prefix.$exampleList[exampleIndex].builder)),",
      );
    }
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
