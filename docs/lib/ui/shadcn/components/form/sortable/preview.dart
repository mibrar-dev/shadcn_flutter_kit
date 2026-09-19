// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:flutter/material.dart';
import '../sortable/sortable.dart';

/// SortablePreview defines a reusable type for this registry module.
///
/// Demonstrates the upstream-parity [RawSortableStack] primitive. Note that
/// [RawSortableList] is a work-in-progress stub (like upstream) whose `build`
/// throws [UnimplementedError], so it is intentionally not rendered here.
class SortablePreview extends StatelessWidget {
  const SortablePreview({super.key});

  @override
  /// Executes `build` behavior for this component/composite.
  Widget build(BuildContext context) {
    // No Scaffold: previews also render inside the unbounded docs
    // detail-page column.
    return const Center(
      child: RawSortableStack(
        children: [
          RawSortableItemPositioned(
            offset: Offset.zero,
            child: Text('Form sortable (RawSortableStack)'),
          ),
        ],
      ),
    );
  }
}
