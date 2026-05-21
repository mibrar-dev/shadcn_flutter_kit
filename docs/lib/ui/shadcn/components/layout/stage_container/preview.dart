// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:flutter/material.dart';

import '../stage_container/stage_container.dart';

/// StageContainerPreview defines a reusable type for this registry module.
class StageContainerPreview extends StatelessWidget {
  const StageContainerPreview({super.key});

  @override
  /// Executes `build` behavior for this component/composite.
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: StageContainer(
          builder: (context, padding) {
            return Padding(
              padding: padding,
              child: Container(
                padding: const EdgeInsets.all(24),
                color: Colors.blueGrey.shade50,
                child: const Text('Stage content'),
              ),
            );
          },
        ),
      ),
    );
  }
}
