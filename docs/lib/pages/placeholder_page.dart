// The not-found page: the last fallback in the route switch. Every sitemap URL
// now resolves to a real page (D3 landing/introduction/index, D4 component
// template/themes/installation/CLI, D4b theming/dark mode); only unknown URLs
// reach here.

import 'package:flutter/widgets.dart';

import '../routing/docs_router.dart';
import '../ui/shadcn/components/button/button.dart';
import '../ui/shadcn/foundation/gap.dart';
import '../ui/shadcn/theme/theme.dart';
import '../widgets/docs_tokens.dart';

/// A readable not-found page.
class DocsPlaceholderPage extends StatelessWidget {
  /// Creates the placeholder for [config].
  const DocsPlaceholderPage({super.key, required this.config});

  /// The route being rendered.
  final DocsRouteConfiguration config;

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    final bool docsRoute = config.route != DocsRoute.themes;
    return ColoredBox(
      color: theme.colors.background,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  config.route == DocsRoute.notFound
                      ? 'Page not found'
                      : config.title,
                  textAlign: TextAlign.center,
                  style: docsText(
                    context,
                    size: 30,
                    weight: FontWeight.w600,
                    letterSpacing: -0.75,
                  ),
                ),
                const Gap(12),
                Text(
                  'This URL does not match any docs route. Use the header or '
                  'the command palette to find a page.',
                  textAlign: TextAlign.center,
                  style: docsText(
                    context,
                    size: 15,
                    height: 1.5,
                    color: theme.colors.mutedForeground,
                  ),
                ),
                const Gap(24),
                if (docsRoute)
                  Button(
                    variant: ButtonVariant.secondary,
                    size: ButtonSize.sm,
                    onPressed: () =>
                        DocsRouterScope.of(context).go(context, '/docs'),
                    child: const Text('Back to the introduction'),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
