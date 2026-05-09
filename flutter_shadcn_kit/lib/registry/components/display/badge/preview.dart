// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:flutter/material.dart';
import '../badge/badge.dart';

/// Core class used by the badge component.
class BadgePreview extends StatelessWidget {
  const BadgePreview({super.key});

  /// Builds the widget tree for badge.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              spacing: 16,
              children: [
                // Primary badges
                const Wrap(
                  spacing: 8,
                  children: [
                    PrimaryBadge(child: Text('Primary')),

                    PrimaryBadge(child: Text('Badge')),
                  ],
                ),
                // Secondary badges
                const Wrap(
                  spacing: 8,
                  children: [
                    SecondaryBadge(child: Text('Secondary')),

                    SecondaryBadge(child: Text('Badge')),
                  ],
                ),
                // Destructive badges
                const Wrap(
                  spacing: 8,
                  children: [
                    DestructiveBadge(child: Text('Destructive')),

                    DestructiveBadge(child: Text('Error')),
                  ],
                ),
                // Outline badges
                const Wrap(
                  spacing: 8,
                  children: [
                    OutlineBadge(child: Text('Outline')),

                    OutlineBadge(child: Text('Badge')),
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
