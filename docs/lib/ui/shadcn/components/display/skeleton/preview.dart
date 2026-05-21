// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:flutter/material.dart';
import '../avatar/avatar.dart';
import '../skeleton/skeleton.dart';
import '../../../shared/primitives/basic.dart';
import '../../../shared/theme/theme.dart';

/// Core class used by the skeleton component.
class SkeletonPreview extends StatelessWidget {
  const SkeletonPreview({super.key});

  /// Builds the widget tree for skeleton.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Basic(
              title: Text('Skeleton Example 1'),
              content: Text(
                'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
              ),
              leading: Avatar(initials: ''),
              trailing: Icon(Icons.arrow_forward),
            ),

            const DensityGap(gap2xl),

            Basic(
              title: const Text('Skeleton Example 1'),
              content: const Text(
                'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
              ),
              leading: const Avatar(initials: '').asSkeleton(),
              trailing: const Icon(Icons.arrow_forward),
            ).asSkeleton(),
          ],
        ),
      ),
    );
  }
}
