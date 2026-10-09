// `/docs/theming` (spec §1/§2.6): the token system, the token convention, the
// generated token table, the radius scale, presets, per-component theme
// resolution and animated theming. Structure mirrors the reference page;
// every fact (token names, preset count) comes from the generated registry
// data and the registry theme layer.

import 'package:flutter/widgets.dart';

import '../generated/docs_data.dart';
import '../routing/docs_nav.dart';
import '../routing/docs_router.dart';
import '../ui/shadcn/foundation/gap.dart';
import '../widgets/code_figure.dart';
import '../widgets/docs_article.dart';
import '../widgets/docs_samples.dart';
import '../widgets/docs_shell.dart';
import '../widgets/heading_anchor.dart';
import '../widgets/theme_token_table.dart';
import '../widgets/typeset.dart';

/// `/docs/theming`.
class ThemingPage extends StatelessWidget {
  /// Creates the theming page.
  const ThemingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ({DocsNavLink? previous, DocsNavLink? next}) neighbors =
        docsPageNeighbors('/docs/theming');
    return DocsLayout(
      child: DocsArticle(
        title: 'Theming',
        description: 'Tokens, presets and per-component theme overrides.',
        previous: neighbors.previous,
        next: neighbors.next,
        children: <Widget>[
          const TypesetParagraph(
            'Build your theme from tokens. Every colour, radius, font and '
            'shadow a component reads comes from the active ShadcnThemeData, '
            'so a preset switch re-themes the whole app without touching '
            'component code.',
          ),
          const HeadingAnchor(id: 'tokens', title: 'Tokens'),
          TypesetParagraph.rich(<InlineSpan>[
            const TextSpan(
              text: 'Each colour token is named after the shadcn ',
            ),
            typesetInlineCodeSpan('CSS'),
            const TextSpan(text: ' variable in camelCase: '),
            typesetInlineCodeSpan('--background'),
            const TextSpan(text: ' becomes '),
            typesetInlineCodeSpan('background'),
            const TextSpan(text: ', and '),
            typesetInlineCodeSpan('--card-foreground'),
            const TextSpan(text: ' becomes '),
            typesetInlineCodeSpan('cardForeground'),
            const TextSpan(
              text:
                  '. The tokens live on ShadcnColors; the resolved theme is '
                  'ShadcnThemeData, read with ',
            ),
            typesetInlineCodeSpan('ShadcnTheme.of(context)'),
            const TextSpan(text: '.'),
          ]),
          DocsCodeFigure(
            code: kThemingSamples['token-read']!.code,
            language: 'dart',
          ),
          const HeadingAnchor(
            id: 'token-convention',
            title: 'Token Convention',
          ),
          const TypesetParagraph(
            'Tokens come in semantic background/foreground pairs. The base '
            'token controls the surface colour and the -foreground token '
            'controls the text and icons that sit on that surface, so a '
            'component never hard-codes a contrast colour.',
          ),
          DocsCodeFigure(
            code: kThemingSamples['token-pair']!.code,
            language: 'dart',
          ),
          const HeadingAnchor(id: 'theme-tokens', title: 'Theme Tokens'),
          TypesetParagraph(
            'These ${kThemeTokens.length} tokens are defined for both '
            'brightnesses in every preset, plus the radius factor.',
          ),
          const Gap(16),
          const ThemeTokenTable(),
          const HeadingAnchor(id: 'radius-scale', title: 'Radius Scale'),
          const TypesetParagraph(
            'radius is the base radius factor: the unitless rem number a '
            'preset stores. The component radius steps derive from it, so a '
            'single value updates every rounded surface.',
          ),
          DocsCodeFigure(
            code: kThemingSamples['radius']!.code,
            language: 'dart',
          ),
          const HeadingAnchor(id: 'presets', title: 'Presets'),
          TypesetParagraph.rich(<InlineSpan>[
            TextSpan(text: 'The kit ships '),
            TextSpan(
              text: '${kStats.presets} presets',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            const TextSpan(
              text:
                  ' across light and dark. The CLI uses the neutral preset by '
                  'default; apply another one with ',
            ),
            typesetInlineCodeSpan('flutter_shadcn theme apply <preset>'),
            const TextSpan(text: '. Try them on the '),
            typesetLinkSpan(
              'Themes page',
              () => DocsRouterScope.of(context).go(context, '/themes'),
            ),
            const TextSpan(text: '.'),
          ]),
          DocsCodeFigure(
            code: kThemingSamples['preset-apply']!.code,
            language: 'bash',
          ),
          const HeadingAnchor(
            id: 'component-themes',
            title: 'Component Themes',
          ),
          const TypesetParagraph(
            'Every component resolves its style through four legs, from '
            'highest to lowest priority: a widget argument, the nearest '
            'ComponentTheme in the tree, the app overrides registered at the '
            'root, then the token-derived defaults.',
          ),
          const TypesetParagraph(
            'The app leg is the user-owned <name>_theme.dart file the CLI '
            'writes next to each component. CLI updates never overwrite it, '
            'so your overrides survive an upgrade.',
          ),
          DocsCodeFigure(
            code: kThemingSamples['component-theme']!.code,
            language: 'dart',
          ),
          const HeadingAnchor(
            id: 'animated-theming',
            title: 'Animated Theming',
          ),
          const TypesetParagraph(
            'AnimatedShadcnTheme animates ShadcnThemeData changes over the '
            'duration and curve you pass. Colours tween; layout does not, so '
            'a preset or mode switch never reflows the page.',
          ),
          DocsCodeFigure(
            code: kThemingSamples['animated']!.code,
            language: 'dart',
          ),
        ],
      ),
    );
  }
}
