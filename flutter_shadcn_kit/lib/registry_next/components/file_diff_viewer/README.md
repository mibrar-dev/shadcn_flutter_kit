# File diff viewer

Renders one or more files' diffs — unified (two gutters + marker) or split
(old side | new side) — with coloured additions/deletions, stat badges,
collapsible unchanged hunks and a copy-patch action.
Widgets-only: no Material (`SelectableText` is replaced by a
`SelectableRegion` with the kit's own selection controls).

## When to use

- Showing a patch in a review tool, release notes or an in-app changelog.

## Snippets

```dart
FileDiffViewer(
  files: [
    FileDiff(
      path: 'lib/src/widget.dart',
      hunks: [
        FileDiffHunk(
          header: '@@ -10,7 +10,8 @@',
          lines: [
            FileDiffLine(type: FileDiffLineType.context, content: 'Widget build(...) {', oldLineNumber: 10, newLineNumber: 10),
            FileDiffLine(type: FileDiffLineType.addition, content: '  return Text(label);', newLineNumber: 11),
            FileDiffLine(type: FileDiffLineType.deletion, content: '  return label;', oldLineNumber: 11),
          ],
        ),
      ],
    ),
  ],
);

FileDiffViewer(layout: FileDiffLayout.split, files: files);
```

## API

| Parameter | Default | Notes |
|---|---|---|
| `files` | required | `FileDiff` entries, each with `hunks` |
| `layout` | `unified` | `unified` or `split` |
| `showFileHeaders` | true | path + `+N`/`-N` badges + status + copy |
| `showLineNumbers` | true | gutter column(s) |
| `collapseUnchanged` | true | hunks flagged `collapsed` start hidden; tap the header to reveal them |
| `showCopyAction` | true | copies the plain-text patch, confirms with an icon for 1200ms |
| `maxHeight` | null | caps the vertical scroll viewport |
| `minContentWidth` | `720` | horizontal scroll below this width |
| `theme` | null | widget-leg `FileDiffViewerTheme` |

## Theming

`FileDiffViewerTheme` follows the standard four legs: widget `theme`
argument > nearest `ComponentTheme<FileDiffViewerTheme>` > app
`ComponentThemes` > `fileDiffViewerDefaults`. Overrides are values only; see
`file_diff_viewer_theme.dart`. Line fills are the addition/deletion accents
multiplied to 18%, stat badges to 14% — alpha multiplies, never replaces.

## Behaviour notes

- The "Copy" label comes from `ShadcnLocalizations` (`menuCopy`); the
  confirmation reuses a check icon instead of an unlocalised "Copied" string.
- The code font/size come from the ambient `fontMono` / `xSmall` styles (the
  old copy hardcoded `GeistMono`/`12.0`).
- `FileDiff.status` and `FileDiff.toPatch()` are model helpers; inline
  `FileDiffSegment` highlighting was dead code in the old copy and is not
  ported.
