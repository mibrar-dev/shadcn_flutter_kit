// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:flutter/material.dart';
import '../group/group_widget.dart';

/// GroupPreview defines a reusable type for this registry module.
class GroupPreview extends StatelessWidget {
  const GroupPreview({super.key});

  @override
  /// Executes `build` behavior for this component/composite.
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 200,
          height: 140,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(8),
            ),
            child: GroupWidget(
              children: [
                /// Creates a `GroupPositioned` instance.
                const GroupPositioned(top: 8, left: 8, child: Text('Layered')),

                /// Creates a `GroupPositioned.fromRect` instance.
                GroupPositioned.fromRect(
                  rect: const Rect.fromLTWH(24, 40, 90, 50),
                  child: Container(color: Colors.blue.shade300),
                ),

                /// Creates a `GroupPositioned` instance.
                const GroupPositioned(
                  right: 8,
                  bottom: 8,
                  child: Icon(Icons.layers),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
