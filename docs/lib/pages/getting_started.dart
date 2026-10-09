// `/docs/installation` — getting started (spec §2.6): a typeset page with
// `.step`-numbered H3 counters and code figures. The steps are the measured
// shadcn installation flow: create a project, install the layer core, add
// components, choose a preset. Every command comes from the CLI snapshot.

import 'package:flutter/widgets.dart';

import '../routing/docs_nav.dart';
import '../ui/shadcn/foundation/gap.dart';
import '../ui/shadcn/foundation/icons/lucide_icons.dart';
import '../ui/shadcn/theme/theme.dart';
import '../widgets/docs_article.dart';
import '../widgets/docs_shell.dart';
import '../widgets/docs_tokens.dart';
import '../widgets/heading_anchor.dart';
import '../widgets/typeset.dart';

/// `/docs/installation` — getting started.
class GettingStartedPage extends StatelessWidget {
  /// Creates the installation page.
  const GettingStartedPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ({DocsNavLink? previous, DocsNavLink? next}) neighbors =
        docsPageNeighbors('/docs/installation');
    return DocsLayout(
      child: DocsArticle(
        title: 'Getting started',
        description:
            'Install the shadcn_flutter_kit registry into your Flutter project '
            'and start building with widgets-only components.',
        previous: neighbors.previous,
        next: neighbors.next,
        children: <Widget>[
          const TypesetParagraph(
            'The kit installs as source: every component is copied into your '
            'project, so the code is yours to read, edit and extend. There is '
            'no package dependency and no Material wrapper to fight.',
          ),
          const _StepCounter(
            number: 1,
            title: 'Create a Flutter project',
            code: 'flutter create my_app',
          ),
          const _StepCounter(
            number: 2,
            title: 'Install the layer core',
            code: 'flutter_shadcn init',
          ),
          const _StepCounter(
            number: 3,
            title: 'Add components',
            code: 'flutter_shadcn add button',
          ),
          const _StepCounter(
            number: 4,
            title: 'Choose a preset',
            code: 'flutter_shadcn theme apply modern-minimal',
          ),
          const HeadingAnchor(id: 'verify', title: 'Verify'),
          const TypesetParagraph(
            'After installation, your project has the registry layer core '
            '(foundation + theme) and the components you added. Run the app '
            'to see the components in action.',
          ),
          const TypesetBullets(
            items: <List<InlineSpan>>[
              <InlineSpan>[
                TextSpan(
                  text: 'Layer core: ',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                TextSpan(
                  text:
                      'foundation, theme and primitives install first; '
                      'components depend on them.',
                ),
              ],
              <InlineSpan>[
                TextSpan(
                  text: 'Lock file: ',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                TextSpan(
                  text:
                      'shadcn.lock v2 records the exact hashes so updates '
                      'stay reviewable.',
                ),
              ],
              <InlineSpan>[
                TextSpan(
                  text: 'User-owned themes: ',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                TextSpan(
                  text:
                      '*_theme.dart files are never overwritten by CLI '
                      'updates.',
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

/// A `.step`-numbered H3 with a code figure (spec §2.3).
class _StepCounter extends StatelessWidget {
  const _StepCounter({
    required this.number,
    required this.title,
    required this.code,
  });

  final int number;
  final String title;
  final String code;

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    final DocsSiteColors site = DocsSiteColors.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: theme.colors.muted,
                  shape: BoxShape.circle,
                  border: Border.all(color: theme.colors.border),
                ),
                alignment: Alignment.center,
                child: Text(
                  '$number',
                  style: theme.typography.mono.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const Gap(16),
              Text(
                title,
                style: docsText(
                  context,
                  size: 16.875,
                  weight: FontWeight.w600,
                  height: 24.47 / 16.875,
                ),
              ),
            ],
          ),
          const Gap(16),
          Container(
            decoration: BoxDecoration(
              color: site.codeSurface,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: theme.colors.border.withValues(alpha: 0.3),
              ),
            ),
            child: Column(
              children: <Widget>[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: <Widget>[
                      Icon(
                        LucideIcons.terminal,
                        size: 16,
                        color: theme.colors.foreground.withValues(alpha: 0.7),
                      ),
                      const Gap(8),
                      Text(
                        code,
                        style: theme.typography.mono.copyWith(
                          fontSize: 14,
                          height: 24.5 / 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
