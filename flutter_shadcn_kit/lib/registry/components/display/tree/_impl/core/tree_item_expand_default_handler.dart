// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../tree.dart';

/// Default handler for tree item expand/collapse operations.
///
/// Manages the expansion state of tree nodes when users interact
/// with expand/collapse controls.
///
/// Example:
/// ```dart
/// final handler = TreeItemExpandDefaultHandler(nodes, targetNode, (updated) {
///   setState(() => nodes = updated);
/// });
/// ```
class TreeItemExpandDefaultHandler<T> {
  /// The current list of tree nodes.
  final List<TreeNode<T>> nodes;

  /// Callback when expansion state changes.
  final ValueChanged<List<TreeNode<T>>> onChanged;

  /// The target node to expand or collapse.
  final TreeNode<T> target;

  /// Creates a [TreeItemExpandDefaultHandler].
  TreeItemExpandDefaultHandler(this.nodes, this.target, this.onChanged);

  /// Handles an expand/collapse event.
  ///
  /// Parameters:
  /// - [expanded]: Whether to expand (true) or collapse (false) the node
  void call(bool expanded) {
    if (expanded) {
      onChanged(nodes.expandNode(target));
    } else {
      onChanged(nodes.collapseNode(target));
    }
  }
}
