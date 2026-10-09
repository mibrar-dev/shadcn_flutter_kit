// Gallery preview for the `navigation_menu` component: plain items,
// dropdown content, content lists and a dark subtree. Widgets-only; the docs
// app embeds [NavigationMenuPreview] directly.

import 'package:flutter/widgets.dart';

import '../../foundation/gap.dart';
import '../../theme/color_tokens.dart';
import '../../theme/theme.dart';
import 'navigation_menu.dart';

/// Renders the navigation menu gallery.
class NavigationMenuPreview extends StatelessWidget {
  /// Creates the preview.
  const NavigationMenuPreview({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: DefaultTextStyle(
        style: const TextStyle(fontSize: 13),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _section(
                'Bar',
                NavigationMenu(
                  children: <Widget>[
                    NavigationMenuItem(
                      onPressed: () {},
                      child: const Text('Home'),
                    ),
                    NavigationMenuItem(
                      content: const NavigationMenuContentList(
                        children: <Widget>[
                          NavigationMenuContent(
                            title: Text('Web Apps'),
                            content: Text('Ship in the browser'),
                          ),
                          NavigationMenuContent(
                            title: Text('Mobile Apps'),
                            content: Text('Ship on the go'),
                          ),
                        ],
                      ),
                      child: const Text('Products'),
                    ),
                    NavigationMenuItem(
                      content: const Text('Company info here'),
                      child: const Text('About'),
                    ),
                  ],
                ),
              ),
              const Gap(24),
              _section(
                'Content list',
                const NavigationMenuContentList(
                  crossAxisCount: 2,
                  children: <Widget>[
                    NavigationMenuContent(
                      title: Text('Dashboard'),
                      content: Text('Analytics and insights'),
                    ),
                    NavigationMenuContent(
                      title: Text('Settings'),
                      content: Text('Preferences'),
                    ),
                    NavigationMenuContent(
                      title: Text('Billing'),
                      content: Text('Plans and invoices'),
                    ),
                  ],
                ),
              ),
              const Gap(24),
              _section(
                'Dark',
                ShadcnTheme(
                  data: const ShadcnThemeData(
                    colors: ShadcnColors.darkFallback,
                  ),
                  child: NavigationMenu(
                    children: <Widget>[
                      NavigationMenuItem(
                        onPressed: () {},
                        child: const Text('Home'),
                      ),
                      NavigationMenuItem(
                        content: const Text('Dark popover'),
                        child: const Text('More'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _section(String title, Widget child) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          title,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        const Gap(8),
        child,
      ],
    );
  }
}
