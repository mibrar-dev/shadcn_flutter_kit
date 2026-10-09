// Gallery preview for the `tree` component: the default guides, a selection,
// a collapsed subtree, the guide variants and the dark palette.
// Widgets-only; the docs app embeds [TreePreview] directly.

import 'package:flutter/widgets.dart';

import '../../foundation/gap.dart';
import '../../components/icon/icon.dart';
import '../../foundation/icons/lucide_icons.dart';
import '../../theme/color_tokens.dart';
import '../../theme/theme.dart';
import 'tree.dart';

/// Renders the tree gallery.
class TreePreview extends StatelessWidget {
  /// Creates the preview.
  const TreePreview({super.key});

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
    final List<TreeNode<String>> source = nodes ?? _nodes();
    return Tree<String>(
      nodes: source,
      branchLine: branchLine,
      shrinkWrap: true,
      builder: (BuildContext context, TreeItem<String> item) => TreeRow(
        leading: Icon(
          item.leaf ? LucideIcons.file : LucideIcons.folder,
        ).iconSmall(),
        trailing: const Icon(LucideIcons.ellipsis).iconSmall(),
        child: Text(item.data),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    return Directionality(
      textDirection: TextDirection.ltr,
      child: DefaultTextStyle(
        style: TextStyle(color: theme.colors.foreground, fontSize: 13),
        child: ColoredBox(
          color: theme.colors.background,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _section('Default (path guides)', _tree()),
                const Gap(24),
                _section('Line guides', _tree(branchLine: TreeBranchLine.line)),
                const Gap(24),
                _section('No guides', _tree(branchLine: TreeBranchLine.none)),
                const Gap(24),
                _section('Collapsed', _tree(nodes: _collapsed())),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<TreeNode<String>> _collapsed() => <TreeNode<String>>[
    TreeItem<String>(
      data: 'Documents',
      children: <TreeNode<String>>[TreeItem<String>(data: 'report.pdf')],
    ),
    TreeItem<String>(data: 'Pictures'),
  ];

  Widget _section(String title, Widget child) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        const Gap(8),
        child,
      ],
    );
  }
}

/// The same gallery rendered with the dark token set.
class TreePreviewDark extends StatelessWidget {
  /// Creates the dark preview.
  const TreePreviewDark({super.key});

  @override
  Widget build(BuildContext context) {
    return ShadcnTheme(
      data: const ShadcnThemeData(colors: ShadcnColors.darkFallback),
      child: const TreePreview(),
    );
  }
}
