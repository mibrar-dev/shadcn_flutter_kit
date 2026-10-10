// Named examples for the `file_diff_viewer` component (P6-F3 preview contract).
//
// One focused demo per example; the first entry is the default. Spacing comes
// from the ambient theme, so the examples follow the selected preset and the
// site light/dark toggle.

import 'package:flutter/widgets.dart';

import '../../foundation/component_preview.dart';
import 'file_diff_viewer.dart';

/// A two-hunk patch; the second hunk starts collapsed.
const FileDiff _patch = FileDiff(
  path: 'lib/src/widget.dart',
  hunks: <FileDiffHunk>[
    FileDiffHunk(
      header: '@@ -10,7 +10,8 @@',
      lines: <FileDiffLine>[
        FileDiffLine(
          type: FileDiffLineType.context,
          content: 'Widget build(BuildContext context) {',
          oldLineNumber: 10,
          newLineNumber: 10,
        ),
        FileDiffLine(
          type: FileDiffLineType.deletion,
          content: '  return Text(label);',
          oldLineNumber: 11,
        ),
        FileDiffLine(
          type: FileDiffLineType.addition,
          content: '  return Text(label, maxLines: 1);',
          newLineNumber: 11,
        ),
        FileDiffLine(
          type: FileDiffLineType.context,
          content: '}',
          oldLineNumber: 12,
          newLineNumber: 12,
        ),
      ],
    ),
    FileDiffHunk(
      header: '@@ -40,6 +41,9 @@',
      collapsed: true,
      lines: <FileDiffLine>[
        FileDiffLine(
          type: FileDiffLineType.context,
          content: 'void unusedHelper() {}',
          oldLineNumber: 40,
          newLineNumber: 41,
        ),
      ],
    ),
  ],
);

/// Compact single-column patch (the shadcn default).
Widget _unified(BuildContext context) {
  return const FileDiffViewer(maxHeight: 260, files: <FileDiff>[_patch]);
}

/// Old and new sides beside each other.
Widget _split(BuildContext context) {
  return const FileDiffViewer(
    layout: FileDiffLayout.split,
    showCopyAction: false,
    files: <FileDiff>[_patch],
  );
}

/// Named docs examples for `file_diff_viewer`; the first entry is the default.
const List<ComponentPreview> fileDiffViewerPreviews = <ComponentPreview>[
  ComponentPreview('Unified', _unified),
  ComponentPreview('Split', _split),
];
