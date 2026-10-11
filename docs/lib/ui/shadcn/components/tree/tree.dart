// The `tree` component: an immutable node model, the immutable operations over
// a node list, and the [Tree] widget with its rows.
//
// Ported from `components/display/tree` (3,136 LOC, 25 files). The old tree
// duplicated its whole node API three times (static methods on `TreeView`, a
// `List` extension and a deprecated `Tree` alias forwarding both), read
// `package:flutter/material.dart` for `Icons`, and painted rows through
// `Data.inherit` + a hand-rolled `Clickable`; see README.md "Fixed bugs".
//
// The node model moved to `primitives/tree_selection/tree_nodes.dart` and the
// modifier-driven multi-selection maths to `tree_selection.dart` beside it,
// so both stay testable without a widget tree. The theme, the branch-line
// variant table, the row context and the themed [TreeRow] live in
// `tree_style.dart`.

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../../foundation/data.dart';
import '../../primitives/tree_selection/tree_nodes.dart';
import '../../primitives/tree_selection/tree_selection.dart';
import '../../theme/theme.dart';
import 'tree_style.dart';

export '../../primitives/tree_selection/tree_nodes.dart';
export '../../primitives/tree_selection/tree_selection.dart';
export 'tree_style.dart';

/// Called when a node's selection changes.
typedef TreeNodeSelectionChanged<T> =
    void Function(List<TreeNode<T>> nodes, bool multiSelect, bool selected);

/// Called when a node is expanded or collapsed.
typedef TreeNodeExpandedChanged<T> =
    void Function(TreeNode<T> node, bool expanded);

/// A hierarchical list with expand/collapse and selection.
///
/// The tree is immutable and controlled: it renders [nodes] and reports
/// changes through [onSelectionChanged] / [onExpandedChanged]; apply the
/// returned list with the `TreeNodeListExtension` operations.
///
/// ```dart
/// Tree<String>(
///   nodes: nodes,
///   builder: (context, item) => TreeRow(child: Text(item.data)),
///   onExpandedChanged: (node, expanded) => setState(() => _nodes =
///       expanded ? _nodes.expandNode(node) : _nodes.collapseNode(node)),
/// );
/// ```
///
/// When [allowMultiSelect] is on, the modifiers add the usual gestures. They
/// are read from the keyboard at press time, so a modifier released while the
/// focus moved cannot leave a gesture latched:
///
/// | Input | Gesture |
/// |---|---|
/// | click / <kbd>Space</kbd> | replace the selection with the row |
/// | <kbd>Ctrl</kbd>/<kbd>Cmd</kbd> + click | add or remove that one row |
/// | <kbd>Shift</kbd> + click | every row from the anchor to that one |
/// | <kbd>Shift</kbd> + <kbd>↑</kbd>/<kbd>↓</kbd> | extend the range, and move the focus |
/// | <kbd>Ctrl</kbd>/<kbd>Cmd</kbd> + <kbd>A</kbd> | every visible row |
///
/// The anchor is the last plain or Ctrl/Cmd click; a range click leaves it
/// where it is, so repeated <kbd>Shift</kbd> clicks grow and shrink the span.
class Tree<T> extends StatefulWidget {
  /// Creates a tree.
  const Tree({
    super.key,
    required this.nodes,
    required this.builder,
    this.onSelectionChanged,
    this.onExpandedChanged,
    this.allowMultiSelect = true,
    this.recursiveSelection = true,
    this.branchLine,
    this.padding,
    this.shrinkWrap = false,
    this.controller,
    this.focusNode,
    this.theme,
  });

  /// The nodes to render, root level.
  final List<TreeNode<T>> nodes;

  /// Builds the content of one item.
  final Widget Function(BuildContext context, TreeItem<T> item) builder;

  /// Called when a row is activated.
  final TreeNodeSelectionChanged<T>? onSelectionChanged;

  /// Called when a row is expanded or collapsed.
  final TreeNodeExpandedChanged<T>? onExpandedChanged;

  /// Whether [onSelectionChanged] may report several nodes at once.
  ///
  /// When false every gesture collapses to a plain click: a <kbd>Shift</kbd> or
  /// <kbd>Ctrl</kbd> chord selects that one row and nothing else.
  final bool allowMultiSelect;

  /// Whether selecting a parent also selects its descendants.
  ///
  /// Range and select-all report the visible rows as they are; the subtree
  /// expansion only applies to a plain, toggle or range click on one row.
  final bool recursiveSelection;

  /// Guide style; falls back to the theme.
  final TreeBranchLine? branchLine;

  /// Padding around the tree; falls back to the theme.
  final EdgeInsetsGeometry? padding;

  /// Whether the list shrinks to its content.
  final bool shrinkWrap;

  /// Scroll controller for the list.
  final ScrollController? controller;

  /// Focus scope of the tree.
  final FocusScopeNode? focusNode;

  /// Widget-leg theme override, merged on top of the other legs.
  final TreeTheme? theme;

  @override
  State<Tree<T>> createState() => _TreeState<T>();
}

class _TreeState<T> extends State<Tree<T>> {
  final List<FocusNode> _rowFocusNodes = <FocusNode>[];

  /// The rows of the last build, in visual order; a range is a span of this.
  List<TreeItem<T>> _visible = <TreeItem<T>>[];

  /// Index of the last plain or Ctrl/Cmd click, or null before the first one.
  ///
  /// This is an index, not a mode: there is deliberately no field anywhere that
  /// remembers that Shift is down, which is what made the old tree's
  /// `_rangeMultiSelect` flag stick when the focus moved with Shift held.
  int? _anchorIndex;

  void _syncFocusNodes(int count) {
    while (_rowFocusNodes.length > count) {
      _rowFocusNodes.removeLast().dispose();
    }
    while (_rowFocusNodes.length < count) {
      _rowFocusNodes.add(FocusNode(debugLabel: 'TreeRow'));
    }
  }

  @override
  void dispose() {
    for (final FocusNode node in _rowFocusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  /// Visits every visible [TreeItem] with its indent guides.
  void _walk(
    List<TreeNode<T>> nodes,
    List<TreeNodeDepth> depth,
    void Function(TreeItem<T> node, List<TreeNodeDepth> depth) visit,
  ) {
    for (int i = 0; i < nodes.length; i++) {
      final TreeNode<T> node = nodes[i];
      if (node is! TreeItem<T>) {
        continue;
      }
      final List<TreeNodeDepth> next = List<TreeNodeDepth>.of(depth)
        ..add(TreeNodeDepth(i, nodes.length));
      visit(node, next);
      if (node.expanded) {
        _walk(node.children, next, visit);
      }
    }
  }

  /// [node] plus every descendant, used for recursive selection.
  List<TreeNode<T>> _subtree(TreeNode<T> node) => <TreeNode<T>>[
    node,
    for (final TreeNode<T> child in node.children) ..._subtree(child),
  ];

  /// The nodes one click on [node] reports, honouring [Tree.recursiveSelection].
  List<TreeNode<T>> _expand(TreeNode<T> node) =>
      widget.recursiveSelection ? _subtree(node) : <TreeNode<T>>[node];

  /// Index of the focused row, or -1 when the tree has no focus.
  int get _focusedIndex {
    for (int i = 0; i < _rowFocusNodes.length; i++) {
      if (_rowFocusNodes[i].hasFocus) {
        return i;
      }
    }
    return -1;
  }

  /// Reports what a pointer press on row [index] asked for.
  ///
  /// The modifiers come from the keyboard *now*, not from a remembered press.
  void _select(int index) {
    final HardwareKeyboard keyboard = HardwareKeyboard.instance;
    _apply(
      resolveTreeSelectionGesture(
        shiftPressed: keyboard.isShiftPressed,
        multiPressed: keyboard.isControlPressed || keyboard.isMetaPressed,
      ),
      index,
    );
  }

  /// Reports [TreeSelectionGesture.all] for every visible row.
  void _selectAll() => _apply(TreeSelectionGesture.all, 0);

  /// Reports the selection for [index] under [gesture] and moves the anchor.
  void _apply(TreeSelectionGesture gesture, int index) {
    final TreeNodeSelectionChanged<T>? handler = widget.onSelectionChanged;
    if (handler == null || _visible.isEmpty) {
      return;
    }
    final bool multi = widget.allowMultiSelect;
    final int at = index.clamp(0, _visible.length - 1);
    final TreeItem<T> node = _visible[at];
    switch (gesture) {
      case TreeSelectionGesture.all:
        handler(_visible, true, true);
      case TreeSelectionGesture.range when multi && _anchorIndex != null:
        final TreeSelectionRange range = selectionRange(
          anchor: _anchorIndex!,
          target: at,
          length: _visible.length,
        );
        handler(
          <TreeNode<T>>[
            for (int i = range.start; i <= range.end; i++) _visible[i],
          ],
          true,
          true,
        );
      // Single-select, or a range gesture with no anchor yet: both act like a
      // plain click and (re)seat the anchor.
      case TreeSelectionGesture.range ||
          TreeSelectionGesture.toggle ||
          TreeSelectionGesture.plain:
        _anchorIndex = at;
        handler(_expand(node), multi, !node.selected);
    }
  }

  KeyEventResult _handleKey(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent || !widget.allowMultiSelect) {
      return KeyEventResult.ignored;
    }
    final HardwareKeyboard keyboard = HardwareKeyboard.instance;
    if (event.logicalKey == LogicalKeyboardKey.keyA &&
        (keyboard.isControlPressed || keyboard.isMetaPressed)) {
      _selectAll();
      return KeyEventResult.handled;
    }
    final int step = switch (event.logicalKey) {
      LogicalKeyboardKey.arrowUp => -1,
      LogicalKeyboardKey.arrowDown => 1,
      _ => 0,
    };
    // A plain arrow keeps the default directional traversal.
    if (step == 0 || !keyboard.isShiftPressed || _visible.isEmpty) {
      return KeyEventResult.ignored;
    }
    final int from = _focusedIndex;
    if (from < 0) {
      return KeyEventResult.ignored;
    }
    final int to = (from + step).clamp(0, _visible.length - 1);
    if (to == from) {
      return KeyEventResult.ignored;
    }
    // Move the focus explicitly instead of letting the default traversal do it,
    // so the row the range stops on is the row the focus lands on.
    _rowFocusNodes[to].requestFocus();
    _apply(
      resolveTreeSelectionIntent(selectAll: false, shiftPressed: true),
      to,
    );
    return KeyEventResult.handled;
  }

  @override
  Widget build(BuildContext context) {
    final TreeTheme style = resolveComponentStyle<TreeTheme, TreeTheme>(
      context,
      widget: widget.theme,
      select: (t) => t,
      defaults: treeDefaults,
    );
    final List<TreeItem<T>> visible = <TreeItem<T>>[];
    final List<List<TreeNodeDepth>> depths = <List<TreeNodeDepth>>[];
    _walk(widget.nodes, const <TreeNodeDepth>[], (
      TreeItem<T> node,
      List<TreeNodeDepth> depth,
    ) {
      visible.add(node);
      depths.add(depth);
    });
    _visible = visible;
    _syncFocusNodes(visible.length);

    // Runs of selected rows are rounded as a group: a row is the start, middle
    // or end of its run (or alone).
    final List<TreeSelectionPosition?> positions =
        List<TreeSelectionPosition?>.filled(visible.length, null);
    for (final TreeSelectionRange run in selectedRuns(<bool>[
      for (final TreeItem<T> node in visible) node.selected,
    ])) {
      for (int i = run.start; i <= run.end; i++) {
        positions[i] = run.length == 1
            ? TreeSelectionPosition.single
            : i == run.start
            ? TreeSelectionPosition.start
            : i == run.end
            ? TreeSelectionPosition.end
            : TreeSelectionPosition.middle;
      }
    }

    final List<Widget> rows = <Widget>[];
    for (int i = 0; i < visible.length; i++) {
      final TreeItem<T> node = visible[i];
      rows.add(
        Data<TreeRowContext>.inherit(
          data: TreeRowContext(
            depth: depths[i],
            branchLine: widget.branchLine,
            focusNode: _rowFocusNodes[i],
            theme: widget.theme,
            expanded: node.expanded,
            expandable: !node.leaf,
            selectionPosition: positions[i],
            onToggle: (bool expanded) =>
                widget.onExpandedChanged?.call(node, expanded),
            onSelect: () => _select(i),
          ),
          child: widget.builder(context, node),
        ),
      );
    }

    return FocusScope(
      node: widget.focusNode,
      onKeyEvent: _handleKey,
      child: ListView.builder(
        shrinkWrap: widget.shrinkWrap,
        controller: widget.controller,
        padding: widget.padding ?? style.padding,
        itemCount: rows.length,
        itemBuilder: (BuildContext context, int i) => rows[i],
      ),
    );
  }
}
