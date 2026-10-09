// Modifier-driven multi-selection for a tree: what a click or a key press asked
// for, and the inclusive span of rows a range selection covers.
//
// Both files here are pure — no widget state, no keyboard listener. The
// modifiers are read from `HardwareKeyboard` by the caller *at event time* and
// passed in as booleans, so nothing can latch: the old tree stored
// `_rangeMultiSelect` in a mutable field and its key-up handler was the only
// thing that could clear it, so moving the focus while a modifier was held left
// range mode stuck on.

import 'package:flutter/foundation.dart' show listEquals;

/// One node of a tree: children plus the expanded/selected flags.
///
/// Immutable: [updateState] and [updateChildren] return a new node.
abstract class TreeNode<T> {
  /// Creates a node.
  const TreeNode();

  /// Children of this node; empty for a leaf.
  List<TreeNode<T>> get children;

  /// Whether the children are visible.
  bool get expanded;

  /// Whether the node is selected.
  bool get selected;

  /// Whether the node has no children.
  bool get leaf => children.isEmpty;

  /// Returns a copy with the given flags replaced.
  TreeNode<T> updateState({bool? expanded, bool? selected});

  /// Returns a copy with [children] replaced.
  TreeNode<T> updateChildren(List<TreeNode<T>> children);
}

/// A data-bearing tree node.
class TreeItem<T> extends TreeNode<T> {
  /// Creates a node.
  const TreeItem({
    required this.data,
    this.children = const <Never>[],
    this.expanded = false,
    this.selected = false,
  });

  /// The payload this node shows.
  final T data;

  @override
  final List<TreeNode<T>> children;

  @override
  final bool expanded;

  @override
  final bool selected;

  @override
  TreeItem<T> updateState({bool? expanded, bool? selected}) => TreeItem<T>(
    data: data,
    children: children,
    expanded: expanded ?? this.expanded,
    selected: selected ?? this.selected,
  );

  @override
  TreeItem<T> updateChildren(List<TreeNode<T>> children) => TreeItem<T>(
    data: data,
    children: children,
    expanded: expanded,
    selected: selected,
  );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is TreeItem<T> &&
        other.data == data &&
        other.expanded == expanded &&
        other.selected == selected &&
        listEquals(other.children, children);
  }

  @override
  int get hashCode => Object.hash(data, expanded, selected, children.length);

  @override
  String toString() =>
      'TreeItem(data: $data, expanded: $expanded, selected: $selected, '
      'children: ${children.length})';
}

/// Transforms a node; returning null removes it from its parent.
typedef TreeNodeUnaryOperator<T> = TreeNode<T>? Function(TreeNode<T> node);

/// The immutable operations a tree needs: every method returns a new list.
///
/// [updateNodes] is the general primitive every other method is built on, so a
/// caller whose operation is not listed here is one call away.
extension TreeNodeListExtension<T> on List<TreeNode<T>> {
  /// Applies [transform] to every node, depth first; null removes it.
  ///
  /// Returns the receiver when nothing changed, so callers can skip a rebuild.
  List<TreeNode<T>> updateNodes(TreeNodeUnaryOperator<T> transform) =>
      _mapNodes(this, transform) ?? this;

  /// Expands every node.
  List<TreeNode<T>> expandAll() => updateNodes(
    (node) => node.expanded ? null : node.updateState(expanded: true),
  );

  /// Collapses every node.
  List<TreeNode<T>> collapseAll() => updateNodes(
    (node) => node.expanded ? node.updateState(expanded: false) : null,
  );

  /// Expands [target].
  List<TreeNode<T>> expandNode(TreeNode<T> target) => updateNodes(
    (node) => node == target && !node.expanded
        ? node.updateState(expanded: true)
        : null,
  );

  /// Collapses [target].
  List<TreeNode<T>> collapseNode(TreeNode<T> target) => updateNodes(
    (node) => node == target && node.expanded
        ? node.updateState(expanded: false)
        : null,
  );

  /// Replaces the selection with [targets].
  List<TreeNode<T>> setSelectedNodes(Iterable<TreeNode<T>> targets) =>
      updateNodes((node) => node.updateState(selected: targets.contains(node)));

  /// Flips the selection flag of [target], keeping every other flag.
  ///
  /// The toggle half of Ctrl/Cmd-click: adding or removing one row without
  /// disturbing the rest of the selection.
  List<TreeNode<T>> toggleSelectedNode(TreeNode<T> target) => updateNodes(
    (node) =>
        node == target ? node.updateState(selected: !node.selected) : null,
  );

  /// The selected nodes, depth first.
  List<TreeNode<T>> get selectedNodes => <TreeNode<T>>[
    for (final TreeNode<T> node in this) ...<TreeNode<T>>[
      ...node.selected ? <TreeNode<T>>[node] : const <Never>[],
      ...node.children.selectedNodes,
    ],
  ];

  /// The data of every selected [TreeItem], depth first.
  List<T> get selectedItems => <T>[
    for (final TreeNode<T> node in selectedNodes)
      if (node is TreeItem<T>) node.data,
  ];
}

List<TreeNode<T>>? _mapNodes<T>(
  List<TreeNode<T>> nodes,
  TreeNodeUnaryOperator<T> transform,
) {
  List<TreeNode<T>>? result;
  for (int i = 0; i < nodes.length; i++) {
    final TreeNode<T> node = nodes[i];
    final TreeNode<T>? replaced = transform(node);
    final TreeNode<T> base = replaced ?? node;
    final List<TreeNode<T>>? children = _mapNodes(base.children, transform);
    if (replaced == null && children == null) {
      continue;
    }
    // One copy per level, reused: rebuilding it per node dropped earlier edits.
    result ??= List<TreeNode<T>>.of(nodes);
    result[i] = children == null ? base : base.updateChildren(children);
  }
  return result;
}
