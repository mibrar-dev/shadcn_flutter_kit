// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:flutter/material.dart' hide TextButton;

import '../breadcrumb/breadcrumb.dart';
import '../../control/button/button.dart';
import '../../display/triple_dots/triple_dots.dart';

/// BreadcrumbPreview defines a reusable type for this registry module.
class BreadcrumbPreview extends StatelessWidget {
  const BreadcrumbPreview({super.key});

  @override
  /// Executes `build` behavior for this component/composite.
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              spacing: 24,
              children: [
                // Breadcrumb with arrow separator
                /// Creates a `Breadcrumb` instance.
                Breadcrumb(
                  separator: Breadcrumb.arrowSeparator,
                  children: [
                    /// Creates a `LinkButton` instance.
                    LinkButton(onPressed: () {}, child: const Text('Home')),

                    /// Creates a `MoreDots` instance.
                    const MoreDots(),

                    /// Creates a `LinkButton` instance.
                    LinkButton(
                      onPressed: () {},
                      child: const Text('Components'),
                    ),

                    /// Creates a `Text` instance.
                    const Text('Breadcrumb'),
                  ],
                ),
                // Breadcrumb with slash separator
                /// Creates a `Breadcrumb` instance.
                Breadcrumb(
                  separator: Breadcrumb.slashSeparator,
                  children: [
                    /// Creates a `LinkButton` instance.
                    LinkButton(onPressed: () {}, child: const Text('Docs')),

                    /// Creates a `LinkButton` instance.
                    LinkButton(
                      onPressed: () {},
                      child: const Text('UI Components'),
                    ),

                    /// Creates a `Text` instance.
                    const Text('Navigation'),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
