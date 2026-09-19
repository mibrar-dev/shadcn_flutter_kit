// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../tree.dart';

/// Upstream-compatibility alias for [TreeView].
///
/// Upstream `shadcn_flutter` names this widget `Tree`. The registry renamed it
/// to [TreeView] (and `TreeItemNode` to [TreeItem]). This subclass preserves
/// the upstream name so existing code keeps compiling. Static helpers (e.g.
/// `Tree.replaceNodes`, `Tree.expandAll`) resolve through inheritance.
///
/// Note: upstream also has a *widget* named `TreeItem` (the row widget). That
/// name is taken in this library by the [TreeItem] data node, so the upstream
/// row widget cannot be aliased here — use [TreeItemView] instead.
@Deprecated('Use TreeView instead')
class Tree<T> extends TreeView<T> {
  /// Creates a [Tree] (alias of [TreeView]).
  const Tree({
    super.key,
    required super.nodes,
    required super.builder,
    super.shrinkWrap = false,
    super.controller,
    super.branchLine,
    super.padding,
    super.expandIcon,
    super.allowMultiSelect,
    super.focusNode,
    super.onSelectionChanged,
    super.recursiveSelection,
  });

  /// Upstream-compatibility forwarder. See [TreeView.defaultSelectionHandler].
  static TreeNodeSelectionChanged<K> defaultSelectionHandler<K>(List<TreeNode<K>> nodes,
    ValueChanged<List<TreeNode<K>>> onChanged,) {
    return TreeView.defaultSelectionHandler<K>(nodes, onChanged);
  }

  /// Upstream-compatibility forwarder. See [TreeView.defaultItemExpandHandler].
  static ValueChanged<bool> defaultItemExpandHandler<K>(List<TreeNode<K>> nodes,
    TreeNode<K> target,
    ValueChanged<List<TreeNode<K>>> onChanged,) {
    return TreeView.defaultItemExpandHandler<K>(nodes, target, onChanged);
  }

  /// Upstream-compatibility forwarder. See [TreeView.replaceNodes].
  static List<TreeNode<K>> replaceNodes<K>(List<TreeNode<K>> nodes,
    TreeNodeUnaryOperator<K> operator,) {
    return TreeView.replaceNodes<K>(nodes, operator);
  }

  /// Upstream-compatibility forwarder. See [TreeView.replaceNodesWithParent].
  static List<TreeNode<K>> replaceNodesWithParent<K>(List<TreeNode<K>> nodes,
    TreeNodeUnaryOperatorWithParent<K> operator,) {
    return TreeView.replaceNodesWithParent<K>(nodes, operator);
  }

  /// Upstream-compatibility forwarder. See [TreeView.replaceNode].
  static List<TreeNode<K>> replaceNode<K>(List<TreeNode<K>> nodes,
    TreeNode<K> oldNode,
    TreeNode<K> newNode,) {
    return TreeView.replaceNode<K>(nodes, oldNode, newNode);
  }

  /// Upstream-compatibility forwarder. See [TreeView.replaceItem].
  static List<TreeNode<K>> replaceItem<K>(List<TreeNode<K>> nodes,
    K oldItem,
    TreeNode<K> newItem,) {
    return TreeView.replaceItem<K>(nodes, oldItem, newItem);
  }

  /// Upstream-compatibility forwarder. See [TreeView.updateRecursiveSelection].
  static List<TreeNode<K>> updateRecursiveSelection<K>(List<TreeNode<K>> nodes,) {
    return TreeView.updateRecursiveSelection<K>(nodes);
  }

  /// Upstream-compatibility forwarder. See [TreeView.getSelectedNodes].
  static List<TreeNode<K>> getSelectedNodes<K>(List<TreeNode<K>> nodes) {
    return TreeView.getSelectedNodes<K>(nodes);
  }

  /// Upstream-compatibility forwarder. See [TreeView.getSelectedItems].
  static List<K> getSelectedItems<K>(List<TreeNode<K>> nodes) {
    return TreeView.getSelectedItems<K>(nodes);
  }

  /// Upstream-compatibility forwarder. See [TreeView.expandAll].
  static List<TreeNode<K>> expandAll<K>(List<TreeNode<K>> nodes) {
    return TreeView.expandAll<K>(nodes);
  }

  /// Upstream-compatibility forwarder. See [TreeView.collapseAll].
  static List<TreeNode<K>> collapseAll<K>(List<TreeNode<K>> nodes) {
    return TreeView.collapseAll<K>(nodes);
  }

  /// Upstream-compatibility forwarder. See [TreeView.expandNode].
  static List<TreeNode<K>> expandNode<K>(List<TreeNode<K>> nodes,
    TreeNode<K> target,) {
    return TreeView.expandNode<K>(nodes, target);
  }

  /// Upstream-compatibility forwarder. See [TreeView.expandItem].
  static List<TreeNode<K>> expandItem<K>(List<TreeNode<K>> nodes, K target) {
    return TreeView.expandItem<K>(nodes, target);
  }

  /// Upstream-compatibility forwarder. See [TreeView.collapseNode].
  static List<TreeNode<K>> collapseNode<K>(List<TreeNode<K>> nodes,
    TreeNode<K> target,) {
    return TreeView.collapseNode<K>(nodes, target);
  }

  /// Upstream-compatibility forwarder. See [TreeView.collapseItem].
  static List<TreeNode<K>> collapseItem<K>(List<TreeNode<K>> nodes, K target) {
    return TreeView.collapseItem<K>(nodes, target);
  }

  /// Upstream-compatibility forwarder. See [TreeView.selectNode].
  static List<TreeNode<K>> selectNode<K>(List<TreeNode<K>> nodes,
    TreeNode<K> target,) {
    return TreeView.selectNode<K>(nodes, target);
  }

  /// Upstream-compatibility forwarder. See [TreeView.selectItem].
  static List<TreeNode<K>> selectItem<K>(List<TreeNode<K>> nodes, K target) {
    return TreeView.selectItem<K>(nodes, target);
  }

  /// Upstream-compatibility forwarder. See [TreeView.deselectNode].
  static List<TreeNode<K>> deselectNode<K>(List<TreeNode<K>> nodes,
    TreeNode<K> target,) {
    return TreeView.deselectNode<K>(nodes, target);
  }

  /// Upstream-compatibility forwarder. See [TreeView.deselectItem].
  static List<TreeNode<K>> deselectItem<K>(List<TreeNode<K>> nodes, K target) {
    return TreeView.deselectItem<K>(nodes, target);
  }

  /// Upstream-compatibility forwarder. See [TreeView.toggleSelectNode].
  static List<TreeNode<K>> toggleSelectNode<K>(List<TreeNode<K>> nodes,
    TreeNode<K> target,) {
    return TreeView.toggleSelectNode<K>(nodes, target);
  }

  /// Upstream-compatibility forwarder. See [TreeView.toggleSelectNodes].
  static List<TreeNode<K>> toggleSelectNodes<K>(List<TreeNode<K>> nodes,
    Iterable<TreeNode<K>> targets,) {
    return TreeView.toggleSelectNodes<K>(nodes, targets);
  }

  /// Upstream-compatibility forwarder. See [TreeView.toggleSelectItem].
  static List<TreeNode<K>> toggleSelectItem<K>(List<TreeNode<K>> nodes,
    K target,) {
    return TreeView.toggleSelectItem<K>(nodes, target);
  }

  /// Upstream-compatibility forwarder. See [TreeView.toggleSelectItems].
  static List<TreeNode<K>> toggleSelectItems<K>(List<TreeNode<K>> nodes,
    Iterable<K> targets,) {
    return TreeView.toggleSelectItems<K>(nodes, targets);
  }

  /// Upstream-compatibility forwarder. See [TreeView.selectAll].
  static List<TreeNode<K>> selectAll<K>(List<TreeNode<K>> nodes) {
    return TreeView.selectAll<K>(nodes);
  }

  /// Upstream-compatibility forwarder. See [TreeView.deselectAll].
  static List<TreeNode<K>> deselectAll<K>(List<TreeNode<K>> nodes) {
    return TreeView.deselectAll<K>(nodes);
  }

  /// Upstream-compatibility forwarder. See [TreeView.toggleSelectAll].
  static List<TreeNode<K>> toggleSelectAll<K>(List<TreeNode<K>> nodes) {
    return TreeView.toggleSelectAll<K>(nodes);
  }

  /// Upstream-compatibility forwarder. See [TreeView.selectNodes].
  static List<TreeNode<K>> selectNodes<K>(List<TreeNode<K>> nodes,
    Iterable<TreeNode<K>> selectedNodes,) {
    return TreeView.selectNodes<K>(nodes, selectedNodes);
  }

  /// Upstream-compatibility forwarder. See [TreeView.selectItems].
  static List<TreeNode<K>> selectItems<K>(List<TreeNode<K>> nodes,
    Iterable<K> selectedItems,) {
    return TreeView.selectItems<K>(nodes, selectedItems);
  }

  /// Upstream-compatibility forwarder. See [TreeView.deselectNodes].
  static List<TreeNode<K>> deselectNodes<K>(List<TreeNode<K>> nodes,
    Iterable<TreeNode<K>> deselectedNodes,) {
    return TreeView.deselectNodes<K>(nodes, deselectedNodes);
  }

  /// Upstream-compatibility forwarder. See [TreeView.deselectItems].
  static List<TreeNode<K>> deselectItems<K>(List<TreeNode<K>> nodes,
    Iterable<K> deselectedItems,) {
    return TreeView.deselectItems<K>(nodes, deselectedItems);
  }

  /// Upstream-compatibility forwarder. See [TreeView.setSelectedNodes].
  static List<TreeNode<K>> setSelectedNodes<K>(List<TreeNode<K>> nodes,
    Iterable<TreeNode<K>> selectedNodes,) {
    return TreeView.setSelectedNodes<K>(nodes, selectedNodes);
  }

  /// Upstream-compatibility forwarder. See [TreeView.setSelectedItems].
  static List<TreeNode<K>> setSelectedItems<K>(List<TreeNode<K>> nodes,
    Iterable<K> selectedItems,) {
    return TreeView.setSelectedItems<K>(nodes, selectedItems);
  }
}

/// Upstream-compatibility alias for the [TreeItem] data node.
///
/// Upstream `shadcn_flutter` names this node `TreeItemNode`. Constructor calls
/// (`TreeItemNode(data: ...)`) and type tests work through this typedef.
@Deprecated('Use TreeItem instead')
typedef TreeItemNode<T> = TreeItem<T>;

/// Upstream-compatibility alias for the [TreeRoot] container node.
///
/// Upstream `shadcn_flutter` names this node `TreeRootNode`.
@Deprecated('Use TreeRoot instead')
typedef TreeRootNode<T> = TreeRoot<T>;
