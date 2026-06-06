# File Diff Viewer

A comprehensive file diff viewer with unified and split layouts.

`FileDiffViewer` renders review-friendly file patches with file headers, hunk
headers, line numbers, additions, deletions, unchanged context, renamed files,
collapsed unchanged hunks, copyable patch text, and optional split-side
comparison.

```dart
FileDiffViewer(
  layout: FileDiffLayout.split,
  files: [
    FileDiff(
      path: 'lib/example.dart',
      status: 'modified',
      hunks: [
        FileDiffHunk(
          header: '@@ -1,3 +1,4 @@',
          lines: [
            FileDiffLine.context(
              oldLineNumber: 1,
              newLineNumber: 1,
              content: 'class Example {',
            ),
            FileDiffLine.deletion(
              oldLineNumber: 2,
              content: '  final String label;',
            ),
            FileDiffLine.addition(
              newLineNumber: 2,
              content: '  final String title;',
            ),
          ],
        ),
      ],
    ),
  ],
)
```

## Features

- Unified or split layout via `FileDiffLayout`.
- File-level addition/deletion counts.
- Optional file headers, line numbers, copy action, max height, and minimum
  code width before horizontal scrolling.
- Collapsible hunks for long unchanged ranges.
- `FileDiffSegment` support for inline changed spans.
- `FileDiffViewerTheme` for colors, gutter styling, border radius, and line
  padding.
