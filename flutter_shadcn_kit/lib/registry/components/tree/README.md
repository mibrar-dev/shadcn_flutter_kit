# Tree

Immutable hierarchical list with expand/collapse, selection and themed indent
guides. Widgets-only, built on `primitives/clickable` for the rows.

## When to use

- File trees, org charts, nested settings.
- Any list whose items have children and an expanded state.

For a single-select dropdown of nested options use `select` / `command`; for a
flat, non-interactive list use `steps`.

## Snippets

```dart
List<TreeNode<String>> _nodes = <TreeNode<String>>[
  TreeItem<String>(
    data: 'Documents',
    expanded: true,
    children: <TreeNode<String>>[TreeItem<String>(data: 'a.txt')],
  ),
];

Tree<String>(
  nodes: _nodes,
  builder: (context, item) => TreeRow(
    leading: const Icon(LucideIcons.file),
    child: Text(item.data),
  ),
  onExpandedChanged: (node, expanded) => setState(
    () => _nodes = expanded ? _nodes.expandNode(node) : _nodes.collapseNode(node),
  ),
  onSelectionChanged: (nodes, multi, selected) => setState(
    () => _nodes = multi && selected
        ? _nodes.updateNodes((n) => n.selected ? null : n.updateState(selected: true))
        : _nodes.setSelectedNodes(nodes),
  ),
);
```

## API

| Type | Notes |
|---|---|
| `Tree<T>` | `nodes` + `builder` (required), `onSelectionChanged`, `onExpandedChanged`, `allowMultiSelect`, `recursiveSelection`, `branchLine`, `padding`, `shrinkWrap`, `controller`, `focusNode`, `theme` |
| `TreeItem<T>` | `data`, `children`, `expanded`, `selected`; `updateState` / `updateChildren` return new nodes |
| `TreeNode<T>` | the abstract node (children + flags) |
| `TreeNodeListExtension<T>` | `updateNodes`, `expandAll`, `collapseAll`, `expandNode`, `collapseNode`, `setSelectedNodes`, `toggleSelectedNode`, `selectedNodes`, `selectedItems` |
| `TreeRow` | the themed row: guides, expand toggle, selection paint |
| `TreeBranchLine` | `none`, `line`, `path` |
| `TreeSelectionPosition` | `start`, `middle`, `end`, `single` |
| `TreeSelectionGesture` | `plain`, `toggle`, `range`, `all` |
| `TreeSelectionRange` | an inclusive index span: `start`, `end`, `length`, `contains` |

The tree is **controlled**: it never mutates `nodes`. It reports what the user
did and you apply it with the immutable operations, so `updateNodes` returning
the receiver (nothing changed) lets you skip `setState`.

Keyboard: <kbd>Tab</kbd> moves between rows, <kbd>Enter</kbd>/<kbd>Space</kbd>
activates (reports the selection), <kbd>→</kbd> expands and <kbd>←</kbd>
collapses the focused row.

### Multi-select

With `allowMultiSelect` (the default) the modifiers add the usual gestures.
Every gesture still *reports* through `onSelectionChanged`; the tree never
applies one itself.

| Input | Reports |
|---|---|
| click / <kbd>Space</kbd> | that row's subtree (`recursiveSelection`), `selected: !node.selected` |
| <kbd>Ctrl</kbd>/<kbd>Cmd</kbd> + click | that row alone, `selected: !node.selected` — merge it with `toggleSelectedNode` |
| <kbd>Shift</kbd> + click | every **visible** row from the anchor to that one, `selected: true` |
| <kbd>Shift</kbd> + <kbd>↑</kbd>/<kbd>↓</kbd> | the same span, and the focus moves to the row the span stops on |
| <kbd>Ctrl</kbd>/<kbd>Cmd</kbd> + <kbd>A</kbd> | every visible row, `selected: true` |

The anchor is the last plain or <kbd>Ctrl</kbd>/<kbd>Cmd</kbd> click. A range
click leaves the anchor where it is, so repeated <kbd>Shift</kbd> clicks grow
and shrink the span. A range that starts before the anchor reports the span in
visual order, forwards or backwards.

The modifiers are read from `HardwareKeyboard.instance` **at event time**
(`isShiftPressed`, `isControlPressed`, `isMetaPressed` — Cmd is the macOS
multi-select modifier) and turned into a gesture by the pure
`resolveTreeSelectionGesture` / `resolveTreeSelectionIntent` in
`primitives/tree_selection/`. No widget field remembers that a modifier is down,
so nothing can latch: moving the focus with <kbd>Shift</kbd> held cannot leave
range mode on, which is the bug the old `_rangeMultiSelect` flag had.

With `allowMultiSelect: false` every gesture collapses to a plain click on that
one row (`multiSelect: false`), and <kbd>Shift</kbd>+<kbd>↑/↓</kbd> and
<kbd>Ctrl</kbd>+<kbd>A</kbd> are inert.

Two details worth knowing:

- The anchor is an **index into the visible rows**, clamped by
  `selectionRange` when the tree expanded or collapsed under it. A stale anchor
  can never throw or produce an inverted span; it clamps to the nearest row.
- `recursiveSelection` applies to a click on one row. A range or
  select-all reports the visible rows as they are, since a span that silently
  grew to include whole subtrees would not match what the user sees.

## Theme resolution

`widget (theme:) > ComponentTheme<TreeTheme> in tree > app overrides
(tree_theme.dart through ComponentThemes) > treeDefaults`, merged per field
with receiver-wins `Mergeable.merge`. The tree's own `theme:` (widget leg),
`branchLine` and focus nodes are forwarded to every row through the
`TreeRowContext` scope.

| `TreeTheme` field | Default |
|---|---|
| `branchLine` | `path` |
| `branchLineColor` | `border` |
| `padding` | `8` (scaled) |
| `indentWidth` | `16` (scaled) |
| `itemPadding` | `8 x 4` (scaled) |
| `itemGap` | `8` (scaled) |
| `selectedBackground` | `primary` at 5% |
| `selectedFocusedBackground` | `primary` at 10% |
| `selectedRadius` | `theme.borderRadiusMd` |

## Fixed bugs (old `registry/components/display/tree`)

- `package:flutter/material.dart` (imported only for `Icons`) is gone; the
  chevron comes from `foundation/icons`.
- The node API was defined **three times** — 32 static methods on `TreeView`, a
  30-method `List` extension forwarding each of them, and a deprecated `Tree`
  subclass forwarding both (~540 lines of code with the doc comments stripped).
  One `TreeNodeListExtension` remains; `Tree` is the widget name (the
  shadcn/upstream name) and the `TreeView`/`Tree` aliases are gone.
- `TreeRoot` (an invisible grouping node) was never instantiated anywhere in the
  repo and is dropped.
- Keyboard range/multi-select ran through `Actions`/`Shortcuts` inside a
  `FocusScope` holding a mutable `_multiSelect`/`_rangeMultiSelect` flag pair
  (bound to <kbd>Shift</kbd>+<kbd>↑/↓</kbd> and <kbd>Ctrl</kbd>+<kbd>Space</kbd>;
  there was no pointer handling at all, so Ctrl/Cmd-click and Shift-click did
  nothing). The gestures are back — and more of them — but the flags are gone:
  the modifiers are read from `HardwareKeyboard` at press time, and the
  key-up-only clearing was the bug (releasing the modifier after the focus
  moved left `_rangeMultiSelect` stuck, turning the next plain click into a
  range selection). Selection is still reported, never applied.
- `_borderRadiusFromPosition` was an `if/else if` chain whose fallthrough
  returned `BorderRadius.zero`, so both an unknown position **and** the ordinary
  `middle` case drew square corners. `TreeSelectionPosition` is now an
  exhaustive `switch` with no `default`, and `middle` has its own case.
- The row painted its selection into an `AnimatedContainer` whose decoration
  resolved against `theme.colorScheme.primary.scaleAlpha(...)` — a non-token
  colour. Selection now resolves `ThemedColor.ref(ColorRef.primary, alpha:)`.
- The old `_TreeViewState` rebuilt the whole flattened list on every build and
  recomputed the selection run with a quadratic nested loop; the run detection
  is now a single pass. (The flatten itself is still per-build, deliberately:
  it is what makes `updateNodes` a pure function of the node list.)
- The deprecated `TreeItemNode` / `TreeRootNode` typedefs are gone (clean
  break).

## Not carried over

- The old widget exposed ~32 static helpers (`replaceNodes`, `selectItems`,
  `toggleSelectAll`, `updateRecursiveSelection`, …). The `TreeNodeListExtension`
  keeps the ones a tree actually needs; anything else is one `updateNodes` call
  away (`updateNodes(transform)` is the general primitive every method is built
  on).
- `selectNodes` / `deselectNodes` are dropped: `setSelectedNodes` replaces the
  selection and `toggleSelectedNode` is the toggle half, so the other two were
  one `updateNodes` call away (see above). The *keyboard range selection* is
  **not** dropped — it is restored, together with the pointer gestures the old
  tree never had (see *Multi-select*).
- `TreeItemView` is now `TreeRow`, and `TreeNodeData` is now `TreeRowContext`;
  `TreeRow` takes the row context as an inherited widget instead of a `BuildContext`
  handed down through constructors.
- `SelectionPosition` is now the `TreeSelectionPosition` enum, and the
  `BranchLine` **class** with its `IndentGuideNone` / `IndentGuideLine` /
  `IndentGuidePath` implementations collapses into the `TreeBranchLine` enum
  plus `TreeTheme.branchLine`. Registering a custom guide implementation is
  gone: set `branchLine` to `none` and draw the guides yourself.
- `FocusChangeReason` (the old focus-report enum), `TreeSelectionDefaultHandler`
  and `TreeItemExpandDefaultHandler` are dropped; keyboard activation and
  expansion are plain `Actions`.

## Getting started

1. Install the component (`flutter_shadcn add tree`) or copy the folder into
   `lib/ui/shadcn/tree/`.
2. Import `tree.dart`; it re-exports `TreeTheme`, `treeDefaults`, `TreeRow` and
   the row context.
3. App-wide overrides go in `tree_theme.dart`; per-subtree overrides use
   `ComponentTheme<TreeTheme>(data: ..., child: ...)`.