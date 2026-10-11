// The Examples section of component pages (P7-D1, shadcn docs layout).
//
// After Installation and Usage, every remaining named example renders as
// `### <Name>` + optional description + its own Preview | Code card. The
// headings register with the article controller, so the right-hand "On This
// Page" TOC lists every example. Single-example components render nothing
// here (the main demo card above already shows them).

import 'package:flutter/widgets.dart';

import '../generated/docs_example_sources.dart';
import '../ui/shadcn/foundation/gap.dart';
import 'example_preview_card.dart';
import 'heading_anchor.dart';
import 'typeset.dart';

/// The per-example cards below Usage (`### <Name>` + card each).
class ComponentExamplesSection extends StatelessWidget {
  /// Creates the section for [componentId].
  const ComponentExamplesSection({super.key, required this.componentId});

  /// The registry component id.
  final String componentId;

  @override
  Widget build(BuildContext context) {
    final List<DocsExampleSource> sources =
        kExampleSources[componentId] ?? const <DocsExampleSource>[];
    if (sources.length < 2) {
      return const SizedBox.shrink();
    }
    final Set<String> used = <String>{};
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const HeadingAnchor(id: 'examples', title: 'Examples'),
        for (int i = 1; i < sources.length; i++) ...<Widget>[
          HeadingAnchor(
            id: _anchorId(sources[i].name, used),
            title: sources[i].name,
            level: 3,
          ),
          if (sources[i].description != null) ...<Widget>[
            TypesetParagraph(sources[i].description!),
            const Gap(12),
          ],
          ExamplePreviewCard(
            componentId: componentId,
            exampleIndex: i,
            source: sources[i],
          ),
        ],
      ],
    );
  }
}

/// URL-safe anchor id for an example name, unique within the page.
String _anchorId(String name, Set<String> used) {
  String slug = name
      .toLowerCase()
      .replaceAll(RegExp('[^a-z0-9]+'), '-')
      .replaceAll(RegExp('^-+|-+\$'), '');
  if (slug.isEmpty) {
    slug = 'example';
  }
  String id = 'example-$slug';
  int counter = 2;
  while (!used.add(id)) {
    id = 'example-$slug-$counter';
    counter++;
  }
  return id;
}
