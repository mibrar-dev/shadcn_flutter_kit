// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../tree.dart';

/// Represents depth information for a tree node.
///
/// Contains index and count information used for rendering
/// indent guides and branch lines.
class TreeNodeDepth {
  /// Index of this child among its siblings (0-based).
  final int childIndex;

  /// Total number of children at this level.
  final int childCount;

  /// Creates a [TreeNodeDepth] with the specified index and count.
  TreeNodeDepth(this.childIndex, this.childCount);
}
