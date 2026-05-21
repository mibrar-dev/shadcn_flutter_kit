// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:flutter/material.dart';

import '../navigation_menu/navigation_menu.dart';

/// NavigationMenuPreview defines a reusable type for this registry module.
class NavigationMenuPreview extends StatelessWidget {
  const NavigationMenuPreview({super.key});

  @override
  /// Executes `build` behavior for this component/composite.
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: NavigationMenu(
          children: [
            /// Creates a `NavigationMenuItem` instance.
            NavigationMenuItem(
              content: NavigationMenuContentList(
                children: const [
                  /// Creates a `NavigationMenuContent` instance.
                  NavigationMenuContent(
                    title: Text('Web Apps'),
                    content: Text('Landing pages and dashboards.'),
                  ),

                  /// Creates a `NavigationMenuContent` instance.
                  NavigationMenuContent(
                    title: Text('Mobile'),
                    content: Text('Native iOS and Android builds.'),
                  ),
                ],
              ),
              child: const Text('Products'),
            ),

            /// Creates a `NavigationMenuItem` instance.
            NavigationMenuItem(
              content: NavigationMenuContentList(
                children: const [
                  /// Creates a `NavigationMenuContent` instance.
                  NavigationMenuContent(
                    title: Text('About'),
                    content: Text('Team, culture, and careers.'),
                  ),

                  /// Creates a `NavigationMenuContent` instance.
                  NavigationMenuContent(
                    title: Text('Blog'),
                    content: Text('Product updates and guides.'),
                  ),
                ],
              ),
              child: const Text('Company'),
            ),

            /// Creates a `NavigationMenuItem` instance.
            NavigationMenuItem(onPressed: () {}, child: const Text('Contact')),
          ],
        ),
      ),
    );
  }
}
