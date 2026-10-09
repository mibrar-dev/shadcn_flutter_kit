// User-owned overrides for the `file_diff_viewer` component theme.
//
// Values only: CLI updates never overwrite this file and Studio rewrites it
// deterministically. Unset fields fall through to `fileDiffViewerDefaults`
// and the global tokens, so an empty override keeps the exact token look.
//
// Sparse example (uncomment and complete to customise the viewer):
//
//   const FileDiffViewerTheme fileDiffViewerThemeOverrides =
//       FileDiffViewerTheme(
//         additionColor: ThemedColor.ref(ColorRef.chart1),
//         borderRadius: BorderRadius.all(Radius.circular(4)),
//         linePadding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
//       );

import 'package:flutter/widgets.dart';

import 'file_diff_viewer_style.dart';

/// Overrides applied app-wide through `ComponentThemes`.
const FileDiffViewerTheme fileDiffViewerThemeOverrides = FileDiffViewerTheme();
