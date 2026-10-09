// Landing page (spec §2.1): announcement badge → H1 → description → two pill
// CTAs → the live collage. The stats band, marquee, feature grid, steps, CTA
// band and 4-column footer are deleted per spec §5.1; the one-line footer
// lives in the shell.

import 'package:flutter/widgets.dart';

import '../generated/docs_data.dart';
import '../routing/docs_router.dart';
import '../ui/shadcn/components/button/button.dart';
import '../ui/shadcn/foundation/gap.dart';
import '../ui/shadcn/theme/theme.dart';
import '../widgets/announcement.dart';
import '../widgets/collage.dart';
import '../widgets/docs_footer.dart';
import '../widgets/docs_tokens.dart';

/// `/` — the landing page.
class LandingPage extends StatelessWidget {
  /// Creates the landing page.
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    final double width = MediaQuery.sizeOf(context).width;
    final bool xl = width >= 1280;
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Padding(
            // Spec §2.1: `py-8` base, `md:py-16`, `lg:py-20` on top; the
            // measured gap below the CTAs is 72 px to the first collage card
            // (48 px section padding + the collage's 24 px top padding).
            padding: EdgeInsets.fromLTRB(
              24,
              width >= 768 ? (xl ? 80 : 64) : 32,
              24,
              width >= 768 ? 48 : 32,
            ),
            child: Column(
              children: <Widget>[
                Announcement(
                  label: '${kStats.components} components ready to install',
                  onPressed: () =>
                      DocsRouterScope.of(context).go(context, '/docs'),
                ),
                Gap(xl ? 16 : 8),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 896),
                  child: Text(
                    'A Flutter component kit you own',
                    textAlign: TextAlign.center,
                    style: docsText(
                      context,
                      size: xl ? 48 : 30,
                      weight: FontWeight.w600,
                      height: 1.1,
                      letterSpacing: xl ? -2.4 : 0,
                      color: theme.colors.foreground,
                    ),
                  ),
                ),
                Gap(xl ? 16 : 8),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 896),
                  // The reference balances this paragraph into two near-equal
                  // lines (`text-balance`, measured 633 px max line); the
                  // explicit break reproduces that at every width — each
                  // half still wraps naturally on narrow screens.
                  child: Text(
                    'Widgets-only, accessible components with thoughtful '
                    'defaults.\nInstall the source with one command and make '
                    'every token ours.',
                    textAlign: TextAlign.center,
                    style: docsText(
                      context,
                      size: width >= 640 ? 18 : 16,
                      height: 28 / 18,
                    ),
                  ),
                ),
                const Gap(20),
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 8,
                  runSpacing: 8,
                  children: <Widget>[
                    _PillButton(
                      label: 'Get Started',
                      primary: true,
                      onPressed: () => DocsRouterScope.of(
                        context,
                      ).go(context, '/docs/installation'),
                    ),
                    _PillButton(
                      label: 'View Components',
                      primary: false,
                      onPressed: () => DocsRouterScope.of(
                        context,
                      ).go(context, '/docs/components'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const DocsCollage(),
          DocsFooter(
            onDocs: () => DocsRouterScope.of(context).go(context, '/docs'),
            onCli: () => DocsRouterScope.of(context).go(context, '/docs/cli'),
          ),
        ],
      ),
    );
  }
}

class _PillButton extends StatelessWidget {
  const _PillButton({
    required this.label,
    required this.primary,
    required this.onPressed,
  });

  final String label;
  final bool primary;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    // The reference CTAs are 35/36 px pills (radius 26). The registry button
    // derives its radius from the `radius` token, so the token is scoped to
    // this subtree: radiusMd = 1.25 * 16 - 2 = 18 = half of the 36 px box.
    return ShadcnTheme(
      data: theme.copyWith(tokens: () => theme.tokens.copyWith(radius: 1.25)),
      child: Button(
        variant: primary ? ButtonVariant.primary : ButtonVariant.secondary,
        size: ButtonSize.md,
        onPressed: onPressed,
        child: Text(label),
      ),
    );
  }
}
