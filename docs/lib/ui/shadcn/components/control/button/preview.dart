// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:flutter/material.dart';

import '../button/button.dart';

/// ButtonPreview defines a reusable type for this registry module.
class ButtonPreview extends StatelessWidget {
  const ButtonPreview({super.key});

  @override
  /// Executes `build` behavior for this component/composite.
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            /// Creates a `PrimaryButton` instance.
            PrimaryButton(onPressed: () {}, child: const Text('Primary')),

            /// Creates a `SecondaryButton` instance.
            SecondaryButton(onPressed: () {}, child: const Text('Secondary')),

            /// Creates a `OutlineButton` instance.
            OutlineButton(onPressed: () {}, child: const Text('Outline')),

            /// Creates a `GhostButton` instance.
            GhostButton(onPressed: () {}, child: const Text('Ghost')),

            /// Creates a `DestructiveButton` instance.
            DestructiveButton(onPressed: () {}, child: const Text('Delete')),

            /// Creates a `LinkButton` instance.
            LinkButton(onPressed: () {}, child: const Text('Link')),
          ],
        ),
      ),
    );
  }
}
