// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:flutter/material.dart';
import '../triple_dots/triple_dots.dart';

/// Core class used by the triple dots component.
class TripleDotsPreview extends StatelessWidget {
  const TripleDotsPreview({super.key});

  /// Builds the widget tree for triple dots.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            MoreDots(count: 3, spacing: 4),

            SizedBox(height: 12),

            MoreDots(direction: Axis.vertical, count: 5, spacing: 6),
          ],
        ),
      ),
    );
  }
}
