// User-owned overrides for the `tree` component theme.
//
// Values only: CLI updates never overwrite this file and Studio rewrites it
// deterministically. Unset fields fall through to `treeDefaults` and the
// global tokens, so an empty override keeps the exact token look.
//
// Sparse example (uncomment and complete to customise the guides):
//
//   const TreeTheme treeThemeOverrides = TreeTheme(
//     branchLine: TreeBranchLine.line,
//     branchLineColor: ThemedColor.ref(ColorRef.mutedForeground, alpha: 0.4),
//     selectedBackground: ThemedColor.ref(ColorRef.accent, alpha: 0.3),
//   );

import 'package:flutter/widgets.dart';

import 'tree_style.dart';

/// Tree overrides applied app-wide through `ComponentThemes`.
const TreeTheme treeThemeOverrides = TreeTheme();
