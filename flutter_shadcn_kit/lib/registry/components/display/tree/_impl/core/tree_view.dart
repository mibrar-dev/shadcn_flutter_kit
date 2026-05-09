// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../tree.dart';

/// A comprehensive tree view widget with hierarchical data display and interaction.
///
/// TreeView provides a scrollable tree interface that displays hierarchical data
/// with support for expansion/collapse, multi-selection, keyboard navigation,
/// and visual branch lines. It handles complex tree operations like recursive
/// selection, range selection, and immutable state updates.
///
/// The widget supports both mouse and keyboard interaction including:
/// - Click to select items and toggle expansion
/// - Ctrl+Click for multi-selection
/// - Shift+Click for range selection
/// - Arrow keys for navigation and selection
/// - Space bar for selection toggle
/// - Left/Right arrows for expand/collapse
///
/// Features:
/// - Hierarchical data display with customizable branch lines
/// - Single and multi-selection modes with recursive selection support
/// - Keyboard navigation and accessibility
/// - Scrollable content with shrink wrap support
/// - Customizable expand icons and visual styling
/// - Immutable state management with helper methods
/// - Focus management and scope integration
///
/// The tree uses immutable data structures where all modifications return new
/// instances. Helper methods and extensions provide convenient operations for
/// common tree manipulations like expanding, selecting, and filtering nodes.
///
/// Example:
/// ```dart
/// TreeView<String>(
///   nodes: [
///     TreeItem(
///       data: 'Documents',
///       expanded: true,
///       children: [
///         TreeItem(data: 'document1.txt'),
///         TreeItem(data: 'document2.txt'),
///       ],
///     ),
///     TreeItem(data: 'Images'),
///   ],
///   builder: (context, item) => Text(item.data),
///   onSelectionChanged: (selected, multiSelect, isSelected) {
///     // Handle selection changes
///   },
/// )
/// ```
class TreeView<T> extends StatefulWidget {
  /// Creates a default selection changed handler for tree nodes.
  ///
  /// Returns a handler that manages node selection state changes in a tree view.
  /// The handler updates the tree structure when selection changes occur.
  ///
  /// Parameters:
  /// - [nodes] (`List<TreeNode<K>>`, required): Current tree node list
  /// - [onChanged] (`ValueChanged<List<TreeNode<K>>>`, required): Callback when nodes change
  ///
  /// Returns a `TreeNodeSelectionChanged<K>` function that handles selection changes.
  static TreeNodeSelectionChanged<K> defaultSelectionHandler<K>(
    List<TreeNode<K>> nodes,
    ValueChanged<List<TreeNode<K>>> onChanged,
  ) {
    return TreeSelectionDefaultHandler(nodes, onChanged).call;
  }

  /// Creates a default expand/collapse handler for tree items.
  ///
  /// Returns a handler that manages the expanded/collapsed state of a specific
  /// tree node. The handler updates the tree structure when expansion changes.
  ///
  /// Parameters:
  /// - [nodes] (`List<TreeNode<K>>`, required): Current tree node list
  /// - [target] (`TreeNode<K>`, required): The node being expanded/collapsed
  /// - [onChanged] (`ValueChanged<List<TreeNode<K>>>`, required): Callback when nodes change
  ///
  /// Returns a `ValueChanged<bool>` function that handles expand/collapse events.
  static ValueChanged<bool> defaultItemExpandHandler<K>(
    List<TreeNode<K>> nodes,
    TreeNode<K> target,
    ValueChanged<List<TreeNode<K>>> onChanged,
  ) {
    return TreeItemExpandDefaultHandler(nodes, target, onChanged).call;
  }

  static List<TreeNode<K>>? _replaceNodes<K>(
    List<TreeNode<K>> nodes,
    TreeNodeUnaryOperator<K> operator,
  ) {
    List<TreeNode<K>> newNodes = List.from(nodes);

    bool changed = false;
    for (int i = 0; i < newNodes.length; i++) {
      final node = newNodes[i];

      var newNode = operator(node);
      List<TreeNode<K>>? newChildren = _replaceNodes(
        (newNode ?? node).children,
        operator,
      );
      if (newChildren != null) {
        newNode = (newNode ?? node).updateChildren(newChildren);
      }
      if (newNode != null) {
        newNodes[i] = newNode;
        changed = true;
      }
    }
    return changed ? newNodes : null;
  }

  static List<TreeNode<K>>? _replaceNodesWithParent<K>(
    TreeNode<K>? parent,
    List<TreeNode<K>> nodes,
    TreeNodeUnaryOperatorWithParent<K> operator,
  ) {
    List<TreeNode<K>> newNodes = List.from(nodes);

    bool changed = false;
    for (int i = 0; i < newNodes.length; i++) {
      final node = newNodes[i];

      var newNode = operator(parent, node);
      List<TreeNode<K>>? newChildren = _replaceNodesWithParent(
        newNode ?? node,
        (newNode ?? node).children,
        operator,
      );
      if (newChildren != null) {
        newNode = (newNode ?? node).updateChildren(newChildren);
      }
      if (newNode != null) {
        newNodes[i] = newNode;
        changed = true;
      }
    }
    return changed ? newNodes : null;
  }

  /// Applies a transformation operator to all nodes in a tree.
  ///
  /// Parameters:
  /// - [nodes] (`List<TreeNode<K>>`, required): Tree nodes.
  /// - [operator] (`TreeNodeUnaryOperator<K>`, required): Transformation function.
  ///
  /// Returns: `List<TreeNode<K>>` — transformed tree.
  static List<TreeNode<K>> replaceNodes<K>(
    List<TreeNode<K>> nodes,
    TreeNodeUnaryOperator<K> operator,
  ) {
    return _replaceNodes(nodes, operator) ?? nodes;
  }

  /// Applies a transformation operator to all nodes with parent context.
  ///
  /// Parameters:
  /// - [nodes] (`List<TreeNode<K>>`, required): Tree nodes.
  /// - [operator] (`TreeNodeUnaryOperatorWithParent<K>`, required): Transformation function.
  ///
  /// Returns: `List<TreeNode<K>>` — transformed tree.
  static List<TreeNode<K>> replaceNodesWithParent<K>(
    List<TreeNode<K>> nodes,
    TreeNodeUnaryOperatorWithParent<K> operator,
  ) {
    return _replaceNodesWithParent(null, nodes, operator) ?? nodes;
  }

  /// Replaces a specific node in the tree.
  ///
  /// Parameters:
  /// - [nodes] (`List<TreeNode<K>>`, required): Tree nodes.
  /// - [oldNode] (`TreeNode<K>`, required): Node to replace.
  /// - [newNode] (`TreeNode<K>`, required): Replacement node.
  ///
  /// Returns: `List<TreeNode<K>>` — tree with node replaced.
  static List<TreeNode<K>> replaceNode<K>(
    List<TreeNode<K>> nodes,
    TreeNode<K> oldNode,
    TreeNode<K> newNode,
  ) {
    return replaceNodes(nodes, (node) {
      return node == oldNode ? newNode : null;
    });
  }

  /// Replaces a node by matching its item value.
  ///
  /// Parameters:
  /// - [nodes] (`List<TreeNode<K>>`, required): Tree nodes.
  /// - [oldItem] (`K`, required): Item value to find.
  /// - [newItem] (`TreeNode<K>`, required): Replacement node.
  ///
  /// Returns: `List<TreeNode<K>>` — tree with item replaced.
  static List<TreeNode<K>> replaceItem<K>(
    List<TreeNode<K>> nodes,
    K oldItem,
    TreeNode<K> newItem,
  ) {
    return replaceNodes(nodes, (node) {
      if (node is TreeItem<K> && node.data == oldItem) {
        return newItem;
      }
      return null;
    });
  }

  /// Updates selection state to maintain parent-child consistency.
  ///
  /// Parameters:
  /// - [nodes] (`List<TreeNode<K>>`, required): Tree nodes.
  ///
  /// Returns: `List<TreeNode<K>>` — tree with updated selection.
  static List<TreeNode<K>> updateRecursiveSelection<K>(
    List<TreeNode<K>> nodes,
  ) {
    return replaceNodesWithParent(nodes, (parent, node) {
      if (node is TreeItem<K> &&
          !node.selected &&
          parent != null &&
          parent.selected) {
        return node.updateState(selected: true);
      }
      return null;
    });
  }

  /// Gets all selected nodes from the tree.
  ///
  /// Parameters:
  /// - [nodes] (`List<TreeNode<K>>`, required): Tree nodes.
  ///
  /// Returns: `List<TreeNode<K>>` — selected nodes.
  static List<TreeNode<K>> getSelectedNodes<K>(List<TreeNode<K>> nodes) {
    return nodes.where((node) => node.selected).toList();
  }

  /// Gets all selected item values from the tree.
  ///
  /// Parameters:
  /// - [nodes] (`List<TreeNode<K>>`, required): Tree nodes.
  ///
  /// Returns: `List<K>` — selected item values.
  static List<K> getSelectedItems<K>(List<TreeNode<K>> nodes) {
    return nodes
        .whereType<TreeItem<K>>()
        .where((node) => node.selected)
        .map((node) => node.data)
        .toList();
  }

  /// Expands all nodes in the tree.
  ///
  /// Parameters:
  /// - [nodes] (`List<TreeNode<K>>`, required): Tree nodes.
  ///
  /// Returns: `List<TreeNode<K>>` — tree with all nodes expanded.
  static List<TreeNode<K>> expandAll<K>(List<TreeNode<K>> nodes) {
    return replaceNodes(nodes, (node) {
      return node.expanded ? null : node.updateState(expanded: true);
    });
  }

  /// Collapses all nodes in the tree.
  ///
  /// Parameters:
  /// - [nodes] (`List<TreeNode<K>>`, required): Tree nodes.
  ///
  /// Returns: `List<TreeNode<K>>` — tree with all nodes collapsed.
  static List<TreeNode<K>> collapseAll<K>(List<TreeNode<K>> nodes) {
    return replaceNodes(nodes, (node) {
      return node.expanded ? node.updateState(expanded: false) : null;
    });
  }

  /// Expands a specific node.
  ///
  /// Parameters:
  /// - [nodes] (`List<TreeNode<K>>`, required): Tree nodes.
  /// - [target] (`TreeNode<K>`, required): Node to expand.
  ///
  /// Returns: `List<TreeNode<K>>` — tree with node expanded.
  static List<TreeNode<K>> expandNode<K>(
    List<TreeNode<K>> nodes,
    TreeNode<K> target,
  ) {
    return replaceNodes(nodes, (node) {
      return node == target ? node.updateState(expanded: true) : null;
    });
  }

  /// Expands a node by its item value.
  ///
  /// Parameters:
  /// - [nodes] (`List<TreeNode<K>>`, required): Tree nodes.
  /// - [target] (`K`, required): Item value to expand.
  ///
  /// Returns: `List<TreeNode<K>>` — tree with item expanded.
  static List<TreeNode<K>> expandItem<K>(List<TreeNode<K>> nodes, K target) {
    return replaceNodes(nodes, (node) {
      if (node is TreeItem<K> && node.data == target && !node.expanded) {
        return node.updateState(expanded: true);
      }
      return null;
    });
  }

  /// Collapses a specific node.
  ///
  /// Parameters:
  /// - [nodes] (`List<TreeNode<K>>`, required): Tree nodes.
  /// - [target] (`TreeNode<K>`, required): Node to collapse.
  ///
  /// Returns: `List<TreeNode<K>>` — tree with node collapsed.
  static List<TreeNode<K>> collapseNode<K>(
    List<TreeNode<K>> nodes,
    TreeNode<K> target,
  ) {
    return replaceNodes(nodes, (node) {
      return node == target ? node.updateState(expanded: false) : null;
    });
  }

  /// Collapses a node by its item value.
  ///
  /// Parameters:
  /// - [nodes] (`List<TreeNode<K>>`, required): Tree nodes.
  /// - [target] (`K`, required): Item value to collapse.
  ///
  /// Returns: `List<TreeNode<K>>` — tree with item collapsed.
  static List<TreeNode<K>> collapseItem<K>(List<TreeNode<K>> nodes, K target) {
    return replaceNodes(nodes, (node) {
      if (node is TreeItem<K> && node.data == target) {
        return node.updateState(expanded: false);
      }
      return null;
    });
  }

  /// Selects a specific node.
  ///
  /// Parameters:
  /// - [nodes] (`List<TreeNode<K>>`, required): Tree nodes.
  /// - [target] (`TreeNode<K>`, required): Node to select.
  ///
  /// Returns: `List<TreeNode<K>>` — tree with node selected.
  static List<TreeNode<K>> selectNode<K>(
    List<TreeNode<K>> nodes,
    TreeNode<K> target,
  ) {
    return replaceNodes(nodes, (node) {
      return node == target ? node.updateState(selected: true) : null;
    });
  }

  /// Selects a node by its item value.
  ///
  /// Parameters:
  /// - [nodes] (`List<TreeNode<K>>`, required): Tree nodes.
  /// - [target] (`K`, required): Item value to select.
  ///
  /// Returns: `List<TreeNode<K>>` — tree with item selected.
  static List<TreeNode<K>> selectItem<K>(List<TreeNode<K>> nodes, K target) {
    return replaceNodes(nodes, (node) {
      if (node is TreeItem<K> && node.data == target) {
        return node.updateState(selected: true);
      }
      return null;
    });
  }

  /// Deselects a specific node.
  ///
  /// Parameters:
  /// - [nodes] (`List<TreeNode<K>>`, required): Tree nodes.
  /// - [target] (`TreeNode<K>`, required): Node to deselect.
  ///
  /// Returns: `List<TreeNode<K>>` — tree with node deselected.
  static List<TreeNode<K>> deselectNode<K>(
    List<TreeNode<K>> nodes,
    TreeNode<K> target,
  ) {
    return replaceNodes(nodes, (node) {
      return node == target ? node.updateState(selected: false) : null;
    });
  }

  /// Deselects a node by its item value.
  ///
  /// Parameters:
  /// - [nodes] (`List<TreeNode<K>>`, required): Tree nodes.
  /// - [target] (`K`, required): Item value to deselect.
  ///
  /// Returns: `List<TreeNode<K>>` — tree with item deselected.
  static List<TreeNode<K>> deselectItem<K>(List<TreeNode<K>> nodes, K target) {
    return replaceNodes(nodes, (node) {
      if (node is TreeItem<K> && node.data == target) {
        return node.updateState(selected: false);
      }
      return null;
    });
  }

  /// Toggles selection state of a specific node.
  ///
  /// Parameters:
  /// - [nodes] (`List<TreeNode<K>>`, required): Tree nodes.
  /// - [target] (`TreeNode<K>`, required): Node to toggle.
  ///
  /// Returns: `List<TreeNode<K>>` — tree with node selection toggled.
  static List<TreeNode<K>> toggleSelectNode<K>(
    List<TreeNode<K>> nodes,
    TreeNode<K> target,
  ) {
    return replaceNodes(nodes, (node) {
      return node == target ? node.updateState(selected: !node.selected) : null;
    });
  }

  /// Toggles selection state of multiple nodes.
  ///
  /// Parameters:
  /// - [nodes] (`List<TreeNode<K>>`, required): Tree nodes.
  /// - [targets] (`Iterable<TreeNode<K>>`, required): Nodes to toggle.
  ///
  /// Returns: `List<TreeNode<K>>` — tree with nodes toggled.
  static List<TreeNode<K>> toggleSelectNodes<K>(
    List<TreeNode<K>> nodes,
    Iterable<TreeNode<K>> targets,
  ) {
    return replaceNodes(nodes, (node) {
      return targets.contains(node)
          ? node.updateState(selected: !node.selected)
          : null;
    });
  }

  /// Toggles selection state of a node by its item value.
  ///
  /// Parameters:
  /// - [nodes] (`List<TreeNode<K>>`, required): Tree nodes.
  /// - [target] (`K`, required): Item value to toggle.
  ///
  /// Returns: `List<TreeNode<K>>` — tree with item toggled.
  static List<TreeNode<K>> toggleSelectItem<K>(
    List<TreeNode<K>> nodes,
    K target,
  ) {
    return replaceNodes(nodes, (node) {
      if (node is TreeItem<K> && node.data == target) {
        return node.updateState(selected: !node.selected);
      }
      return null;
    });
  }

  /// Toggles selection state of multiple items.
  ///
  /// Parameters:
  /// - [nodes] (`List<TreeNode<K>>`, required): Tree nodes.
  /// - [targets] (`Iterable<K>`, required): Item values to toggle.
  ///
  /// Returns: `List<TreeNode<K>>` — tree with items toggled.
  static List<TreeNode<K>> toggleSelectItems<K>(
    List<TreeNode<K>> nodes,
    Iterable<K> targets,
  ) {
    return replaceNodes(nodes, (node) {
      if (node is TreeItem<K> && targets.contains(node.data)) {
        return node.updateState(selected: !node.selected);
      }
      return null;
    });
  }

  /// Selects all nodes in the tree.
  ///
  /// Parameters:
  /// - [nodes] (`List<TreeNode<K>>`, required): Tree nodes.
  ///
  /// Returns: `List<TreeNode<K>>` — tree with all nodes selected.
  static List<TreeNode<K>> selectAll<K>(List<TreeNode<K>> nodes) {
    return replaceNodes(nodes, (node) {
      return node.updateState(selected: true);
    });
  }

  /// Deselects all nodes in the tree.
  ///
  /// Parameters:
  /// - [nodes] (`List<TreeNode<K>>`, required): Tree nodes.
  ///
  /// Returns: `List<TreeNode<K>>` — tree with all nodes deselected.
  static List<TreeNode<K>> deselectAll<K>(List<TreeNode<K>> nodes) {
    return replaceNodes(nodes, (node) {
      return node.updateState(selected: false);
    });
  }

  /// Toggles selection state of all nodes.
  ///
  /// Parameters:
  /// - [nodes] (`List<TreeNode<K>>`, required): Tree nodes.
  ///
  /// Returns: `List<TreeNode<K>>` — tree with all selections toggled.
  static List<TreeNode<K>> toggleSelectAll<K>(List<TreeNode<K>> nodes) {
    return replaceNodes(nodes, (node) {
      return node.updateState(selected: !node.selected);
    });
  }

  /// Selects specific nodes.
  ///
  /// Parameters:
  /// - [nodes] (`List<TreeNode<K>>`, required): Tree nodes.
  /// - [selectedNodes] (`Iterable<TreeNode<K>>`, required): Nodes to select.
  ///
  /// Returns: `List<TreeNode<K>>` — tree with specified nodes selected.
  static List<TreeNode<K>> selectNodes<K>(
    List<TreeNode<K>> nodes,
    Iterable<TreeNode<K>> selectedNodes,
  ) {
    return replaceNodes(nodes, (node) {
      return selectedNodes.contains(node)
          ? node.updateState(selected: true)
          : null;
    });
  }

  /// Selects nodes by their item values.
  ///
  /// Parameters:
  /// - [nodes] (`List<TreeNode<K>>`, required): Tree nodes.
  /// - [selectedItems] (`Iterable<K>`, required): Item values to select.
  ///
  /// Returns: `List<TreeNode<K>>` — tree with specified items selected.
  static List<TreeNode<K>> selectItems<K>(
    List<TreeNode<K>> nodes,
    Iterable<K> selectedItems,
  ) {
    return replaceNodes(nodes, (node) {
      if (node is TreeItem<K> && selectedItems.contains(node.data)) {
        return node.updateState(selected: true);
      }
      return null;
    });
  }

  /// Deselects specific nodes.
  ///
  /// Parameters:
  /// - [nodes] (`List<TreeNode<K>>`, required): Tree nodes.
  /// - [deselectedNodes] (`Iterable<TreeNode<K>>`, required): Nodes to deselect.
  ///
  /// Returns: `List<TreeNode<K>>` — tree with specified nodes deselected.
  static List<TreeNode<K>> deselectNodes<K>(
    List<TreeNode<K>> nodes,
    Iterable<TreeNode<K>> deselectedNodes,
  ) {
    return replaceNodes(nodes, (node) {
      return deselectedNodes.contains(node)
          ? node.updateState(selected: false)
          : null;
    });
  }

  /// Deselects nodes by their item values.
  ///
  /// Parameters:
  /// - [nodes] (`List<TreeNode<K>>`, required): Tree nodes.
  /// - [deselectedItems] (`Iterable<K>`, required): Item values to deselect.
  ///
  /// Returns: `List<TreeNode<K>>` — tree with specified items deselected.
  static List<TreeNode<K>> deselectItems<K>(
    List<TreeNode<K>> nodes,
    Iterable<K> deselectedItems,
  ) {
    return replaceNodes(nodes, (node) {
      if (node is TreeItem<K> && deselectedItems.contains(node.data)) {
        return node.updateState(selected: false);
      }
      return null;
    });
  }

  /// Sets the selected nodes, replacing current selection.
  ///
  /// Parameters:
  /// - [nodes] (`List<TreeNode<K>>`, required): Tree nodes.
  /// - [selectedNodes] (`Iterable<TreeNode<K>>`, required): Nodes to select (all others deselected).
  ///
  /// Returns: `List<TreeNode<K>>` — tree with only specified nodes selected.
  static List<TreeNode<K>> setSelectedNodes<K>(
    List<TreeNode<K>> nodes,
    Iterable<TreeNode<K>> selectedNodes,
  ) {
    return replaceNodes(nodes, (node) {
      return node.updateState(selected: selectedNodes.contains(node));
    });
  }

  /// Sets the selected items by value, replacing current selection.
  ///
  /// Parameters:
  /// - [nodes] (`List<TreeNode<K>>`, required): Tree nodes.
  /// - [selectedItems] (`Iterable<K>`, required): Item values to select (all others deselected).
  ///
  /// Returns: `List<TreeNode<K>>` — tree with only specified items selected.
  static List<TreeNode<K>> setSelectedItems<K>(
    List<TreeNode<K>> nodes,
    Iterable<K> selectedItems,
  ) {
    return replaceNodes(nodes, (node) {
      if (node is TreeItem<K>) {
        return node.updateState(selected: selectedItems.contains(node.data));
      }
      return null;
    });
  }

  /// List of tree nodes to display in the tree view.
  ///
  /// Type: `List<TreeNode<T>>`. The root-level nodes that will be rendered
  /// in the tree. Can contain TreeItem instances and TreeRoot containers.
  final List<TreeNode<T>> nodes;

  /// Builder function to create widgets for tree items.
  ///
  /// Type: `Widget Function(BuildContext, TreeItem<T>)`. Called for each
  /// visible tree item to create its visual representation. Receives the
  /// build context and the tree item data.
  final Widget Function(BuildContext context, TreeItem<T> node) builder;

  /// Whether the tree view should size itself to its content.
  ///
  /// Type: `bool`, default: `false`. When true, the tree takes only the space
  /// needed for its content instead of expanding to fill available space.
  final bool shrinkWrap;

  /// Optional scroll controller for the tree's scroll view.
  ///
  /// Type: `ScrollController?`. Allows external control of scrolling behavior
  /// and position within the tree view.
  final ScrollController? controller;

  /// The style of branch lines connecting tree nodes.
  ///
  /// Type: `BranchLine?`. If null, uses the theme's branch line or BranchLine.path.
  /// Controls the visual connections drawn between parent and child nodes.
  final BranchLine? branchLine;

  /// Padding around the tree view content.
  ///
  /// Type: `EdgeInsetsGeometry?`. If null, uses 8 pixels on all sides.
  /// Applied to the entire tree view scroll area.
  final EdgeInsetsGeometry? padding;

  /// Whether to show expand/collapse icons for nodes with children.
  ///
  /// Type: `bool?`. If null, defaults to true from theme. When false,
  /// nodes cannot be visually expanded or collapsed.
  final bool? expandIcon;

  /// Whether multiple tree nodes can be selected simultaneously.
  ///
  /// Type: `bool?`. If null, defaults to true from theme. When false,
  /// selecting a node automatically deselects all others.
  final bool? allowMultiSelect;

  /// Optional focus scope node for keyboard navigation.
  ///
  /// Type: `FocusScopeNode?`. Controls focus behavior within the tree view
  /// for keyboard navigation and accessibility.
  final FocusScopeNode? focusNode;

  /// Callback invoked when node selection changes.
  ///
  /// Type: `TreeNodeSelectionChanged<T>?`. Called with the affected nodes,
  /// whether multi-select mode is active, and the new selection state.
  final TreeNodeSelectionChanged<T>? onSelectionChanged;

  /// Whether selecting a parent node also selects its children.
  ///
  /// Type: `bool?`. If null, defaults to true from theme. When true,
  /// selection operations recursively affect all descendant nodes.
  final bool? recursiveSelection;

  /// Creates a [TreeView] with hierarchical data display and interaction.
  ///
  /// Configures a tree view widget that displays hierarchical data with support
  /// for expansion, selection, keyboard navigation, and visual styling.
  ///
  /// Parameters:
  /// - [key] (Key?): Widget identifier for the widget tree
  /// - [nodes] (`List<TreeNode<T>>`, required): Root-level tree nodes to display
  /// - [builder] (Widget Function(BuildContext, `TreeItem<T>`), required): Builder for tree items
  /// - [shrinkWrap] (bool, default: false): Whether to size to content
  /// - [controller] (ScrollController?, optional): Scroll controller for the tree
  /// - [branchLine] (BranchLine?, optional): Style for connecting lines
  /// - [padding] (EdgeInsetsGeometry?, optional): Padding around content
  /// - [expandIcon] (bool?, optional): Whether to show expand/collapse icons
  /// - [allowMultiSelect] (bool?, optional): Whether to allow multi-selection
  /// - [focusNode] (FocusScopeNode?, optional): Focus node for keyboard navigation
  /// - [onSelectionChanged] (`TreeNodeSelectionChanged<T>?`, optional): Selection callback
  /// - [recursiveSelection] (bool?, optional): Whether to select children recursively
  ///
  /// Example:
  /// ```dart
  /// TreeView<FileItem>(
  ///   nodes: fileTreeNodes,
  ///   allowMultiSelect: true,
  ///   recursiveSelection: true,
  ///   branchLine: BranchLine.path,
  ///   builder: (context, item) => ListTile(
  ///     leading: Icon(item.data.isDirectory ? Icons.folder : Icons.file_copy),
  ///     title: Text(item.data.name),
  ///     subtitle: Text(item.data.path),
  ///   ),
  ///   onSelectionChanged: (selectedNodes, multiSelect, isSelected) {
  ///     handleSelectionChange(selectedNodes, isSelected);
  ///   },
  /// )
  /// ```
  const TreeView({
    super.key,
    required this.nodes,
    required this.builder,
    this.shrinkWrap = false,
    this.controller,
    this.branchLine,
    this.padding,
    this.expandIcon,
    this.allowMultiSelect,
    this.focusNode,
    this.onSelectionChanged,
    this.recursiveSelection,
  });

  /// Creates the State object used by this tree widget.
  @override
  State<TreeView<T>> createState() => _TreeViewState<T>();
}
