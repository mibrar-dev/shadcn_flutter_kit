// `/docs/components` — the components index (spec §2.5): an H1 + description,
// one H2 section per generated component category, the generated link grid in
// each section, a rule and a closing sentence. The old search toolbar,
// category pills, cards and mini-previews are deleted; search lives in the
// header palette only.
//
// P6-B3: the single alphabetical "All Components" grid became category
// sections (`Forms & Inputs`, `Data Display`, …), the same grouping the sidebar
// and the palette use. Building blocks (`listed: false`) are not listed here;
// they stay reachable through the component pager/API links.
//
// There is no "New Components" section: the registry has no new/date marker,
// so inventing one would break the "facts come from the registry" rule.

import 'package:flutter/widgets.dart';

import '../generated/docs_data.dart';
import '../routing/docs_nav.dart';
import '../widgets/component_link_grid.dart';
import '../widgets/docs_article.dart';
import '../widgets/docs_shell.dart';
import '../widgets/heading_anchor.dart';
import '../widgets/typeset.dart';

/// `/docs/components` — the index.
class ComponentsIndexPage extends StatelessWidget {
  /// Creates the index page.
  const ComponentsIndexPage({super.key});

  @override
  Widget build(BuildContext context) {
    final DocsComponentLink first = kComponentCategoryGroups
        .expand((DocsComponentCategory group) => group.components)
        .first;
    return DocsLayout(
      child: DocsArticle(
        title: 'Components',
        description:
            'Every component available in the registry, generated from the '
            'manifest. Pick one to see its live preview, install command and '
            'API.',
        next: DocsNavLink(
          label: first.name,
          location: '/docs/components/${first.id}',
        ),
        children: <Widget>[
          for (final DocsComponentCategory group in kComponentCategoryGroups)
            HeadingAnchor(id: componentCategorySlug(group.id), title: group.id),
          for (final DocsComponentCategory group in kComponentCategoryGroups)
            ComponentLinkGrid(links: group.components),
          const TypesetRule(),
          const TypesetParagraph(
            'Can’t find what you need? Every component installs as editable '
            'source, so a missing piece can start from the closest match and '
            'grow with your app.',
          ),
        ],
      ),
    );
  }
}
