// Gallery preview for the `file_diff_viewer` component.
//
// Widgets-only: a unified diff with a collapsed hunk, the split layout, a
// renamed file and a scoped `ComponentTheme<FileDiffViewerTheme>` leg.

import 'package:flutter/widgets.dart';

import '../../theme/color_tokens.dart';
import '../../theme/theme.dart';
import 'file_diff_viewer.dart';

/// Preview entry point used by the docs gallery.
class FileDiffViewerPreview extends StatelessWidget {
  /// Creates the preview.
  const FileDiffViewerPreview({super.key});

  static const FileDiff _renamed = FileDiff(
    path: 'lib/src/renamed.dart',
    oldPath: 'lib/src/old_name.dart',
    status: 'renamed',
    hunks: <FileDiffHunk>[
      FileDiffHunk(
        header: '@@ -1,3 +1,4 @@',
        lines: <FileDiffLine>[
          FileDiffLine(
            type: FileDiffLineType.context,
            content: 'class Example {',
            oldLineNumber: 1,
            newLineNumber: 1,
          ),
          FileDiffLine(
            type: FileDiffLineType.addition,
            content: '  final int value;',
            newLineNumber: 2,
          ),
        ],
      ),
    ],
  );

  static const FileDiff _patch = FileDiff(
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

  @override
  Widget build(BuildContext context) {
    // The gallery ships its own navigator so the selection region has an
    // Overlay ancestor wherever the preview is mounted.
    return ShadcnTheme(
      data: const ShadcnThemeData(),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Navigator(
          onGenerateRoute: (RouteSettings settings) => PageRouteBuilder<void>(
            settings: settings,
            pageBuilder: (BuildContext context, _, _) =>
                const _FileDiffViewerPreviewBody(),
          ),
        ),
      ),
    );
  }
}

class _FileDiffViewerPreviewBody extends StatelessWidget {
  const _FileDiffViewerPreviewBody();

  @override
  Widget build(BuildContext context) {
    final ShadcnColors colors = ShadcnTheme.of(context).colors;
    return ColoredBox(
      color: colors.background,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              FileDiffViewer(
                maxHeight: 260,
                files: <FileDiff>[
                  FileDiffViewerPreview._patch,
                  FileDiffViewerPreview._renamed,
                ],
              ),
              const SizedBox(height: 24),
              FileDiffViewer(
                layout: FileDiffLayout.split,
                showCopyAction: false,
                files: const <FileDiff>[FileDiffViewerPreview._patch],
              ),
              const SizedBox(height: 24),
              ComponentTheme<FileDiffViewerTheme>(
                data: const FileDiffViewerTheme(
                  additionColor: ThemedColor.value(Color(0xFF16A34A)),
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                ),
                child: const FileDiffViewer(
                  showFileHeaders: false,
                  files: <FileDiff>[FileDiffViewerPreview._renamed],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
