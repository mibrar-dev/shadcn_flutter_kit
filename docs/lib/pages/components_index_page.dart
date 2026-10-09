// `/docs/components` — the components index (spec §2.5): an H1 + description,
// the "All Components" H2, the generated alphabetical link grid, a rule and a
// closing sentence. The old search toolbar, category pills, cards and
// mini-previews are deleted; search lives in the header palette only.
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
    final DocsComponentLink first = kComponentLinks.first;
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
          const HeadingAnchor(id: 'all-components', title: 'All Components'),
          const ComponentLinkGrid(),
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
