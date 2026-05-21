// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:flutter/material.dart';

import '../collapsible/collapsible.dart';
import '../outlined_container/outlined_container.dart';

/// CollapsiblePreview defines a reusable type for this registry module.
class CollapsiblePreview extends StatelessWidget {
  const CollapsiblePreview({super.key});

  @override
  /// Executes `build` behavior for this component/composite.
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 360,
          child: Collapsible(
            children: [
              /// Creates a `CollapsibleTrigger` instance.
              const CollapsibleTrigger(child: Text('Recent activity')),

              /// Creates a `SizedBox` instance.
              const SizedBox(height: 8),

              /// Creates a `OutlinedContainer` instance.
              OutlinedContainer(
                padding: const EdgeInsets.all(12),
                child: const Text('@ibrar-x/shadcn_flutter_kit'),
              ),

              /// Creates a `CollapsibleContent` instance.
              CollapsibleContent(
                child: Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: OutlinedContainer(
                    padding: const EdgeInsets.all(12),
                    child: const Text('@flutter/flutter'),
                  ),
                ),
              ),

              /// Creates a `CollapsibleContent` instance.
              CollapsibleContent(
                child: Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: OutlinedContainer(
                    padding: const EdgeInsets.all(12),
                    child: const Text('@dart-lang/sdk'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
