// Named examples for the `tree` component (P6-F3 preview contract).
//
// One focused demo per example; the first entry is the default. Spacing comes
// from the ambient theme, so the examples follow the selected preset and the
// site light/dark toggle. Each tree shrink-wraps so it fits the stage.

import 'package:flutter/widgets.dart';

import '../../components/icon/icon.dart';
import '../../foundation/component_preview.dart';
import '../../foundation/icons/lucide_icons.dart';
import 'tree.dart';

List<TreeNode<String>> _nodes() => <TreeNode<String>>[
  TreeItem<String>(
    data: 'Documents',
    expanded: true,
    children: <TreeNode<String>>[
      TreeItem<String>(data: 'report.pdf', selected: true),
      TreeItem<String>(data: 'notes.md'),
      TreeItem<String>(
        data: 'archive',
        children: <TreeNode<String>>[TreeItem<String>(data: '2024.zip')],
      ),
    ],
  ),
  TreeItem<String>(data: 'Pictures'),
];

Widget _tree({TreeBranchLine? branchLine, List<TreeNode<String>>? nodes}) {
  return SizedBox(
    width: 320,
    child: Tree<String>(
      nodes: nodes ?? _nodes(),
      branchLine: branchLine,
      shrinkWrap: true,
      builder: (BuildContext context, TreeItem<String> item) => TreeRow(
        leading: Icon(
          item.leaf ? LucideIcons.file : LucideIcons.folder,
        ).iconSmall(),
        trailing: const Icon(LucideIcons.ellipsis).iconSmall(),
        child: Text(item.data),
      ),
    ),
  );
}

/// Default path guides with an expanded, selected subtree.
Widget _default(BuildContext context) => _tree();

/// Plain vertical line guides.
Widget _lines(BuildContext context) {
  return _tree(branchLine: TreeBranchLine.line);
}

/// No guides.
Widget _none(BuildContext context) {
  return _tree(branchLine: TreeBranchLine.none);
}

/// Everything collapsed.
Widget _collapsed(BuildContext context) {
  return _tree(
    nodes: <TreeNode<String>>[
      TreeItem<String>(
        data: 'Documents',
        children: <TreeNode<String>>[TreeItem<String>(data: 'report.pdf')],
      ),
      TreeItem<String>(data: 'Pictures'),
    ],
  );
}

/// Named docs examples for `tree`; the first entry is the default.
const List<ComponentPreview> treePreviews = <ComponentPreview>[
  ComponentPreview('Default', _default),
  ComponentPreview('Line guides', _lines),
  ComponentPreview('No guides', _none),
  ComponentPreview('Collapsed', _collapsed),
];
