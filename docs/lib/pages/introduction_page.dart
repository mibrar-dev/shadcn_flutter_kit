// `/docs` — the introduction (spec §2.3 prose inside the docs shell).
// Original wording; every number comes from the generated registry facts.

import 'package:flutter/widgets.dart';

import '../generated/docs_data.dart';
import '../routing/docs_nav.dart';
import '../widgets/docs_article.dart';
import '../widgets/docs_shell.dart';
import '../widgets/heading_anchor.dart';
import '../widgets/typeset.dart';

/// `/docs` — introduction.
class IntroductionPage extends StatelessWidget {
  /// Creates the introduction page.
  const IntroductionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ({DocsNavLink? previous, DocsNavLink? next}) neighbors =
        docsPageNeighbors('/docs');
    return DocsLayout(
      child: DocsArticle(
        title: 'Introduction',
        description:
            'A widgets-only Flutter component kit you install as source. '
            'No package dependency, no Material, no wrapper to fight.',
        previous: neighbors.previous,
        next: neighbors.next,
        children: <Widget>[
          const TypesetParagraph(
            'Every component in this kit is copied into your app, so the '
            'source is yours to read, edit and extend. The registry defines '
            'each component once: its widget file, its style file, its theme '
            'overrides and a generated manifest the CLI installs from.',
          ),
          const TypesetParagraph(
            'There is exactly one implementation per component. No variant '
            'wrappers, no per-style subclasses and no Material widgets under '
            'the hood; the components are built from the kit primitives and '
            'the active theme tokens.',
          ),
          const HeadingAnchor(id: 'source-you-own', title: 'Source you own'),
          TypesetParagraph(
            'A component arrives as a folder under your UI directory. The '
            'theme file inside it is user-owned: CLI updates never overwrite '
            'your overrides, so you can change any token-driven value without '
            'forking the registry.',
          ),
          TypesetBullets(
            items: <List<InlineSpan>>[
              <InlineSpan>[
                const TextSpan(
                  text: 'Open source: ',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const TextSpan(
                  text:
                      'the component files are plain Flutter widgets you can '
                      'diff, review and commit.',
                ),
              ],
              <InlineSpan>[
                const TextSpan(
                  text: 'Predictable interfaces: ',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const TextSpan(
                  text:
                      'one constructor plus enums, so examples and AI tools '
                      'can learn the pattern once.',
                ),
              ],
              <InlineSpan>[
                const TextSpan(
                  text: 'Generated docs: ',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                TextSpan(
                  text:
                      'the ${kStats.components} reference pages are built from '
                      'the registry manifest, never hand-written.',
                ),
              ],
            ],
          ),
          const HeadingAnchor(
            id: 'one-command-install',
            title: 'One command install',
          ),
          TypesetParagraph.rich(<InlineSpan>[
            const TextSpan(text: 'Add a component with '),
            typesetInlineCodeSpan('flutter_shadcn add <component>'),
            const TextSpan(
              text:
                  '. The CLI writes the component, its shared dependencies '
                  'and a user-owned theme file, and records the exact hashes '
                  'in a lock file so updates stay reviewable.',
            ),
          ]),
          const HeadingAnchor(id: 'presets', title: 'Presets included'),
          TypesetParagraph(
            'The kit ships ${kStats.presets} theme presets across '
            '${kStats.modes} modes. A preset is data: colour tokens, radius '
            'and fonts, resolved through the same theme layer the components '
            'read at build time.',
          ),
          const TypesetParagraph(
            'Try them on the Themes page, or read the Theming page to see how '
            'a preset maps onto the token names.',
          ),
        ],
      ),
    );
  }
}
