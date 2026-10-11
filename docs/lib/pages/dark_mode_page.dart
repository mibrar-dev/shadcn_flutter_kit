// `/docs/dark-mode` (spec §1/§2.6): how brightness works, how to set the
// mode, how to toggle it and how to follow the system. Structure mirrors the
// reference page; the framework-picker cards do not exist here (one
// implementation), so the page is prose + code figures.

import 'package:flutter/widgets.dart';

import '../routing/docs_nav.dart';
import '../routing/docs_router.dart';
import '../widgets/code_figure.dart';
import '../widgets/docs_article.dart';
import '../widgets/docs_samples.dart';
import '../widgets/docs_shell.dart';
import '../widgets/heading_anchor.dart';
import '../widgets/typeset.dart';

/// `/docs/dark-mode`.
class DarkModePage extends StatelessWidget {
  /// Creates the dark-mode page.
  const DarkModePage({super.key});

  @override
  Widget build(BuildContext context) {
    final ({DocsNavLink? previous, DocsNavLink? next}) neighbors =
        docsPageNeighbors('/docs/dark-mode');
    return DocsLayout(
      child: DocsArticle(
        title: 'Dark Mode',
        description: 'Adding dark mode to your app.',
        previous: neighbors.previous,
        next: neighbors.next,
        children: <Widget>[
          const TypesetParagraph(
            'Every preset defines a light and a dark token set. Dark mode is '
            'not a filter over the light theme: it is a second set of the '
            'same tokens, so components read one code path in both modes.',
          ),
          const HeadingAnchor(id: 'how-it-works', title: 'How It Works'),
          TypesetParagraph.rich(<InlineSpan>[
            const TextSpan(
              text:
                  'ShadcnColors carries the resolved brightness, so any '
                  'widget below the app shell can read the mode with ',
            ),
            typesetInlineCodeSpan('ShadcnTheme.of(context).brightness'),
            const TextSpan(
              text:
                  '. Components use that value only for behaviour, never to '
                  'pick colours: the colours already match the mode.',
            ),
          ]),
          DocsCodeFigure(
            code: kDarkModeSamples['read-brightness']!.code,
            language: 'dart',
          ),
          const HeadingAnchor(
            id: 'setting-the-mode',
            title: 'Setting the Mode',
          ),
          TypesetParagraph.rich(<InlineSpan>[
            const TextSpan(text: 'Pass a theme per brightness and a '),
            typesetInlineCodeSpan('ThemeMode'),
            const TextSpan(
              text: ' to ShadcnApp. The mode is system, light or dark; with ',
            ),
            typesetInlineCodeSpan('ThemeMode.system'),
            const TextSpan(
              text:
                  ' the shell resolves the platform brightness for you '
                  '(the old Material wrapper resolved it too early).',
            ),
          ]),
          DocsCodeFigure(
            code: kDarkModeSamples['app-themes']!.code,
            language: 'dart',
          ),
          const HeadingAnchor(id: 'toggling', title: 'Toggling the Mode'),
          const TypesetParagraph(
            'A toggle stores an explicit mode. Once the user chooses, stop '
            'following the platform and persist the choice so the next visit '
            'opens in the same mode.',
          ),
          DocsCodeFigure(
            code: kDarkModeSamples['toggle']!.code,
            language: 'dart',
          ),
          const HeadingAnchor(
            id: 'following-the-system',
            title: 'Following the System',
          ),
          TypesetParagraph.rich(<InlineSpan>[
            const TextSpan(
              text:
                  'This site itself defaults to the system brightness and '
                  'persists an explicit choice once you use the ',
            ),
            typesetLinkSpan(
              'theme toggle',
              () => DocsRouterScope.of(context).go(context, '/docs/theming'),
            ),
            const TextSpan(
              text:
                  ' in the header. Use the same pattern: system by default, '
                  'an explicit mode after the first toggle.',
            ),
          ]),
        ],
      ),
    );
  }
}
