// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:flutter/material.dart';
import '../focus_outline/focus_outline.dart';

/// FocusOutlinePreview defines a reusable type for this registry module.
class FocusOutlinePreview extends StatelessWidget {
  const FocusOutlinePreview({super.key});

  @override
  /// Executes `build` behavior for this component/composite.
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            /// Creates a `FocusOutline` instance.
            FocusOutline(
              focused: true,
              child: TextButton(onPressed: () {}, child: const Text('Focused')),
            ),

            /// Creates a `SizedBox` instance.
            const SizedBox(height: 12),

            /// Creates a `FocusOutline` instance.
            FocusOutline(
              focused: false,
              child: TextButton(
                onPressed: () {},
                child: const Text('Unfocused'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
