// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:data_widget/data_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' show Icons;
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../../../shared/primitives/clickable.dart';
import '../../../shared/utils/color_extensions.dart';
import '../../../shared/theme/theme.dart';
import '../../../shared/utils/constants.dart';
import '../icon/icon.dart';

part '_impl/core/_path_painter.dart';
part '_impl/core/_tree_item_view_state.dart';
part '_impl/core/_tree_view_state.dart';
part '_impl/core/branch_line.dart';
part '_impl/core/collapse_tree_node_intent.dart';
part '_impl/core/directional_select_tree_node_intent.dart';
part '_impl/core/expand_tree_node_intent.dart';
part '_impl/core/focus_change_reason.dart';
part '_impl/core/indent_guide_line.dart';
part '_impl/core/indent_guide_none.dart';
part '_impl/core/indent_guide_path.dart';
part '_impl/core/select_tree_node_intent.dart';
part '_impl/core/selection_position.dart';
part '_impl/core/tree_item.dart';
part '_impl/core/tree_item_expand_default_handler.dart';
part '_impl/core/tree_item_view.dart';
part '_impl/core/tree_node.dart';
part '_impl/core/tree_node_data.dart';
part '_impl/core/tree_node_depth.dart';
part '_impl/core/tree_root.dart';
part '_impl/core/tree_selection_default_handler.dart';
part '_impl/core/tree_view.dart';

/// Theme configuration for [TreeView] appearance and behavior.
///
/// TreeTheme defines the visual styling and behavioral options for tree view
/// components including branch lines, padding, expand icons, and selection modes.
/// All properties are optional and fall back to theme defaults when not specified.
///
/// Example:
/// ```dart
/// ComponentTheme<TreeTheme>(
///   data: TreeTheme(
///     branchLine: BranchLine.path,
///     padding: EdgeInsets.all(12),
///     expandIcon: true,
///     allowMultiSelect: true,
///     recursiveSelection: true,
///   ),
///   child: TreeView(...),
/// )
/// ```
class TreeTheme extends ComponentThemeData {
  /// The branch line style for connecting tree nodes.
  ///
  /// Type: `BranchLine?`. If null, uses BranchLine.path. Controls how visual
  /// connections are drawn between parent and child nodes in the tree hierarchy.
  final BranchLine? branchLine;

  /// Padding around the entire tree view content.
  ///
  /// Type: `EdgeInsetsGeometry?`. If null, uses 8 pixels on all sides.
  /// This padding is applied to the scroll view containing all tree items.
  final EdgeInsetsGeometry? padding;

  /// Whether to show expand/collapse icons for nodes with children.
  ///
  /// Type: `bool?`. If null, defaults to true. When false, nodes cannot be
  /// visually expanded or collapsed, though the data structure remains hierarchical.
  final bool? expandIcon;

  /// Whether multiple nodes can be selected simultaneously.
  ///
  /// Type: `bool?`. If null, defaults to true. When false, selecting a node
  /// automatically deselects all other nodes, enforcing single selection mode.
  final bool? allowMultiSelect;

  /// Whether selecting a parent node also selects its children.
  ///
  /// Type: `bool?`. If null, defaults to true. When true, selection operations
  /// recursively affect all descendant nodes.
  final bool? recursiveSelection;

  /// Creates a theme for tree view components.
  ///
  /// This constructor allows customization of tree visualization and behavior
  /// including branch lines, spacing, icons, and selection modes.
  ///
  /// Parameters:
  /// - [branchLine] (BranchLine?): Visual style for lines connecting tree nodes
  /// - [padding] (EdgeInsetsGeometry?): Padding around tree items
  /// - [expandIcon] (bool?): Whether to show expand/collapse icons
  /// - [allowMultiSelect] (bool?): Whether multiple nodes can be selected simultaneously
  /// - [recursiveSelection] (bool?): Whether selecting parent selects all children
  ///
  /// Example:
  /// ```dart
  /// TreeTheme(
  ///   branchLine: BranchLine.solid,
  ///   padding: EdgeInsets.all(8),
  ///   allowMultiSelect: true,
  /// )
  /// ```
  const TreeTheme({
    super.themeDensity,
    super.themeSpacing,
    super.themeShadows,
    this.branchLine,
    this.padding,
    this.expandIcon,
    this.allowMultiSelect,
    this.recursiveSelection,
  });

  /// Creates a copy of this theme with the given fields replaced.
  ///
  /// Parameters:
  /// - [branchLine] (`ValueGetter<BranchLine?>?`, optional): New branch line style.
  /// - [padding] (`ValueGetter<EdgeInsetsGeometry?>?`, optional): New padding.
  /// - [expandIcon] (`ValueGetter<bool?>?`, optional): New expand icon visibility.
  /// - [allowMultiSelect] (`ValueGetter<bool?>?`, optional): New multi-select setting.
  /// - [recursiveSelection] (`ValueGetter<bool?>?`, optional): New recursive selection setting.
  ///
  /// Returns: A new [TreeTheme] with updated properties.
  TreeTheme copyWith({
    ValueGetter<BranchLine?>? branchLine,
    ValueGetter<EdgeInsetsGeometry?>? padding,
    ValueGetter<bool?>? expandIcon,
    ValueGetter<bool?>? allowMultiSelect,
    ValueGetter<bool?>? recursiveSelection,
  }) {
    return TreeTheme(
      branchLine: branchLine == null ? this.branchLine : branchLine(),
      padding: padding == null ? this.padding : padding(),
      expandIcon: expandIcon == null ? this.expandIcon : expandIcon(),
      allowMultiSelect: allowMultiSelect == null
          ? this.allowMultiSelect
          : allowMultiSelect(),
      recursiveSelection: recursiveSelection == null
          ? this.recursiveSelection
          : recursiveSelection(),
    );
  }

  /// Compares two tree values for structural equality.
  @override
  bool operator ==(Object other) =>
      other is TreeTheme &&
      other.branchLine == branchLine &&
      other.padding == padding &&
      other.expandIcon == expandIcon &&
      other.allowMultiSelect == allowMultiSelect &&
      other.recursiveSelection == recursiveSelection;

  @override
  int get hashCode => Object.hash(
    branchLine,
    padding,
    expandIcon,
    allowMultiSelect,
    recursiveSelection,
  );

  /// Returns a debug string for this tree value.
  @override
  String toString() =>
      'TreeTheme(branchLine: $branchLine, padding: $padding, expandIcon: $expandIcon, allowMultiSelect: $allowMultiSelect, recursiveSelection: $recursiveSelection)';
}

BorderRadius _borderRadiusFromPosition(
  SelectionPosition? position,
  double value,
) {
  if (position == SelectionPosition.start) {
    return BorderRadius.vertical(top: Radius.circular(value));
  } else if (position == SelectionPosition.end) {
    return BorderRadius.vertical(bottom: Radius.circular(value));
  } else if (position == SelectionPosition.single) {
    return BorderRadius.all(Radius.circular(value));
  }
  return BorderRadius.zero;
}

/// Function that transforms a tree node, optionally returning a new node.
///
/// Used for operations like updating, replacing, or removing nodes.
/// Return null to remove the node, or return a modified node to replace it.
typedef TreeNodeUnaryOperator<K> = TreeNode<K>? Function(TreeNode<K> node);

/// Function that transforms a tree node with parent context.
///
/// Similar to [TreeNodeUnaryOperator] but provides access to the parent node.
/// Useful for operations that need parent-child relationship information.
typedef TreeNodeUnaryOperatorWithParent<K> =
    TreeNode<K>? Function(TreeNode<K>? parent, TreeNode<K> node);

/// Extension methods for manipulating lists of tree nodes.
///
/// Provides convenience methods for common tree operations like expansion,
/// collapse, selection, and node replacement. All methods return a new list
/// and do not modify the original.
extension TreeNodeListExtension<K> on List<TreeNode<K>> {
  /// Applies an operator to all nodes in the tree.
  ///
  /// Parameters:
  /// - [operator] (`TreeNodeUnaryOperator<K>`, required): Transform function.
  ///
  /// Returns: `List<TreeNode<K>>` — new tree with transformed nodes.
  List<TreeNode<K>> replaceNodes(TreeNodeUnaryOperator<K> operator) {
    return TreeView.replaceNodes(this, operator);
  }

  /// Replaces a specific node in the tree.
  ///
  /// Parameters:
  /// - [oldNode] (`TreeNode<K>`, required): Node to replace.
  /// - [newNode] (`TreeNode<K>`, required): Replacement node.
  ///
  /// Returns: `List<TreeNode<K>>` — new tree with node replaced.
  List<TreeNode<K>> replaceNode(TreeNode<K> oldNode, TreeNode<K> newNode) {
    return TreeView.replaceNode(this, oldNode, newNode);
  }

  /// Replaces a node by its item value.
  ///
  /// Parameters:
  /// - [oldItem] (`K`, required): Item value to find.
  /// - [newItem] (`TreeNode<K>`, required): Replacement node.
  ///
  /// Returns: `List<TreeNode<K>>` — new tree with item replaced.
  List<TreeNode<K>> replaceItem(K oldItem, TreeNode<K> newItem) {
    return TreeView.replaceItem(this, oldItem, newItem);
  }

  /// Expands all nodes in the tree.
  ///
  /// Returns: `List<TreeNode<K>>` — new tree with all nodes expanded.
  List<TreeNode<K>> expandAll() {
    return TreeView.expandAll(this);
  }

  /// Collapses all nodes in the tree.
  ///
  /// Returns: `List<TreeNode<K>>` — new tree with all nodes collapsed.
  List<TreeNode<K>> collapseAll() {
    return TreeView.collapseAll(this);
  }

  /// Expands a specific node.
  ///
  /// Parameters:
  /// - [target] (`TreeNode<K>`, required): Node to expand.
  ///
  /// Returns: `List<TreeNode<K>>` — new tree with node expanded.
  List<TreeNode<K>> expandNode(TreeNode<K> target) {
    return TreeView.expandNode(this, target);
  }

  /// Expands a node by its item value.
  ///
  /// Parameters:
  /// - [target] (`K`, required): Item value to find and expand.
  ///
  /// Returns: `List<TreeNode<K>>` — new tree with item expanded.
  List<TreeNode<K>> expandItem(K target) {
    return TreeView.expandItem(this, target);
  }

  /// Collapses a specific node.
  ///
  /// Parameters:
  /// - [target] (`TreeNode<K>`, required): Node to collapse.
  ///
  /// Returns: `List<TreeNode<K>>` — new tree with node collapsed.
  List<TreeNode<K>> collapseNode(TreeNode<K> target) {
    return TreeView.collapseNode(this, target);
  }

  /// Collapses a node by its item value.
  ///
  /// Parameters:
  /// - [target] (`K`, required): Item value to find and collapse.
  ///
  /// Returns: `List<TreeNode<K>>` — new tree with item collapsed.
  List<TreeNode<K>> collapseItem(K target) {
    return TreeView.collapseItem(this, target);
  }

  /// Gets all selected nodes in the tree.
  ///
  /// Returns: `List<TreeNode<K>>` — list of selected nodes.
  List<TreeNode<K>> get selectedNodes {
    return TreeView.getSelectedNodes(this);
  }

  /// Gets all selected item values in the tree.
  ///
  /// Returns: `List<K>` — list of selected item values.
  List<K> get selectedItems {
    return TreeView.getSelectedItems(this);
  }

  /// Selects a specific node.
  ///
  /// Parameters:
  /// - [target] (`TreeNode<K>`, required): Node to select.
  ///
  /// Returns: `List<TreeNode<K>>` — new tree with node selected.
  List<TreeNode<K>> selectNode(TreeNode<K> target) {
    return TreeView.selectNode(this, target);
  }

  /// Selects a node by its item value.
  ///
  /// Parameters:
  /// - [target] (`K`, required): Item value to find and select.
  ///
  /// Returns: `List<TreeNode<K>>` — new tree with item selected.
  List<TreeNode<K>> selectItem(K target) {
    return TreeView.selectItem(this, target);
  }

  /// Deselects a specific node.
  ///
  /// Parameters:
  /// - [target] (`TreeNode<K>`, required): Node to deselect.
  ///
  /// Returns: `List<TreeNode<K>>` — new tree with node deselected.
  List<TreeNode<K>> deselectNode(TreeNode<K> target) {
    return TreeView.deselectNode(this, target);
  }

  /// Deselects a node by its item value.
  ///
  /// Parameters:
  /// - [target] (`K`, required): Item value to find and deselect.
  ///
  /// Returns: `List<TreeNode<K>>` — new tree with item deselected.
  List<TreeNode<K>> deselectItem(K target) {
    return TreeView.deselectItem(this, target);
  }

  /// Toggles selection state of a specific node.
  ///
  /// Parameters:
  /// - [target] (`TreeNode<K>`, required): Node to toggle.
  ///
  /// Returns: `List<TreeNode<K>>` — new tree with node selection toggled.
  List<TreeNode<K>> toggleSelectNode(TreeNode<K> target) {
    return TreeView.toggleSelectNode(this, target);
  }

  /// Toggles selection state of multiple nodes.
  ///
  /// Parameters:
  /// - [targets] (`Iterable<TreeNode<K>>`, required): Nodes to toggle.
  ///
  /// Returns: `List<TreeNode<K>>` — new tree with nodes toggled.
  List<TreeNode<K>> toggleSelectNodes(Iterable<TreeNode<K>> targets) {
    return TreeView.toggleSelectNodes(this, targets);
  }

  /// Toggles selection state of a node by its item value.
  ///
  /// Parameters:
  /// - [target] (`K`, required): Item value to toggle.
  ///
  /// Returns: `List<TreeNode<K>>` — new tree with item toggled.
  List<TreeNode<K>> toggleSelectItem(K target) {
    return TreeView.toggleSelectItem(this, target);
  }

  /// Toggles selection state of multiple items.
  ///
  /// Parameters:
  /// - [targets] (`Iterable<K>`, required): Item values to toggle.
  ///
  /// Returns: `List<TreeNode<K>>` — new tree with items toggled.
  List<TreeNode<K>> toggleSelectItems(Iterable<K> targets) {
    return TreeView.toggleSelectItems(this, targets);
  }

  /// Selects all nodes in the tree.
  ///
  /// Returns: `List<TreeNode<K>>` — new tree with all nodes selected.
  List<TreeNode<K>> selectAll() {
    return TreeView.selectAll(this);
  }

  /// Deselects all nodes in the tree.
  ///
  /// Returns: `List<TreeNode<K>>` — new tree with all nodes deselected.
  List<TreeNode<K>> deselectAll() {
    return TreeView.deselectAll(this);
  }

  /// Toggles selection state of all nodes in the tree.
  ///
  /// Returns: `List<TreeNode<K>>` — new tree with all selections toggled.
  List<TreeNode<K>> toggleSelectAll() {
    return TreeView.toggleSelectAll(this);
  }

  /// Selects specific nodes.
  ///
  /// Parameters:
  /// - [nodes] (`Iterable<TreeNode<K>>`, required): Nodes to select.
  ///
  /// Returns: `List<TreeNode<K>>` — new tree with nodes selected.
  List<TreeNode<K>> selectNodes(Iterable<TreeNode<K>> nodes) {
    return TreeView.selectNodes(this, nodes);
  }

  /// Selects nodes by their item values.
  ///
  /// Parameters:
  /// - [items] (`Iterable<K>`, required): Item values to select.
  ///
  /// Returns: `List<TreeNode<K>>` — new tree with items selected.
  List<TreeNode<K>> selectItems(Iterable<K> items) {
    return TreeView.selectItems(this, items);
  }

  /// Deselects specific nodes.
  ///
  /// Parameters:
  /// - [nodes] (`Iterable<TreeNode<K>>`, required): Nodes to deselect.
  ///
  /// Returns: `List<TreeNode<K>>` — new tree with nodes deselected.
  List<TreeNode<K>> deselectNodes(Iterable<TreeNode<K>> nodes) {
    return TreeView.deselectNodes(this, nodes);
  }

  /// Deselects nodes by their item values.
  ///
  /// Parameters:
  /// - [items] (`Iterable<K>`, required): Item values to deselect.
  ///
  /// Returns: `List<TreeNode<K>>` — new tree with items deselected.
  List<TreeNode<K>> deselectItems(Iterable<K> items) {
    return TreeView.deselectItems(this, items);
  }

  /// Sets the selected nodes, replacing current selection.
  ///
  /// Parameters:
  /// - [nodes] (`Iterable<TreeNode<K>>`, required): Nodes to select.
  ///
  /// Returns: `List<TreeNode<K>>` — new tree with only specified nodes selected.
  List<TreeNode<K>> setSelectedNodes(Iterable<TreeNode<K>> nodes) {
    return TreeView.setSelectedNodes(this, nodes);
  }

  /// Sets the selected items by value, replacing current selection.
  ///
  /// Parameters:
  /// - [items] (`Iterable<K>`, required): Item values to select.
  ///
  /// Returns: `List<TreeNode<K>>` — new tree with only specified items selected.
  List<TreeNode<K>> setSelectedItems(Iterable<K> items) {
    return TreeView.setSelectedItems(this, items);
  }

  /// Applies an operator to all nodes with parent context.
  ///
  /// Parameters:
  /// - [operator] (`TreeNodeUnaryOperatorWithParent<K>`, required): Transform function with parent.
  ///
  /// Returns: `List<TreeNode<K>>` — new tree with transformed nodes.
  List<TreeNode<K>> replaceNodesWithParent(
    TreeNodeUnaryOperatorWithParent<K> operator,
  ) {
    return TreeView.replaceNodesWithParent(this, operator);
  }

  /// Updates selection state based on recursive selection rules.
  ///
  /// Ensures parent-child selection consistency when recursive selection is enabled.
  ///
  /// Returns: `List<TreeNode<K>>` — new tree with updated selection state.
  List<TreeNode<K>> updateRecursiveSelection() {
    return TreeView.updateRecursiveSelection(this);
  }
}

/// Callback invoked when tree node selection changes.
///
/// Parameters:
/// - [selectedNodes]: The nodes affected by the selection change
/// - [multiSelect]: Whether the operation allows multiple selection
/// - [selected]: Whether the nodes are being selected (true) or deselected (false)
typedef TreeNodeSelectionChanged<T> =
    void Function(
      List<TreeNode<T>> selectedNodes,
      bool multiSelect,
      bool selected,
    );

/// Function/type signature used by tree APIs.
typedef _TreeWalker<T> =
    void Function(
      bool parentExpanded,
      TreeNode<T> node,
      List<TreeNodeDepth> depth,
    );

/// Function/type signature used by tree APIs.
typedef _NodeWalker<T> = void Function(TreeNode<T> node);
