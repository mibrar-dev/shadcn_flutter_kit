// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:flutter/widgets.dart' as m;

import 'file_diff_viewer.dart';
import '../../layout/app/app.dart';
import '../../../shared/theme/theme.dart' as shadcn;

class FileDiffViewerPreview extends m.StatelessWidget {
  const FileDiffViewerPreview({super.key});

  @override
  m.Widget build(m.BuildContext context) {
    return ShadcnApp(
      title: 'File Diff Viewer Preview',
      theme: const shadcn.ThemeData.dark(),
      home: m.Padding(
        padding: const m.EdgeInsets.all(24),
        child: m.SingleChildScrollView(
          child: m.Column(
            crossAxisAlignment: m.CrossAxisAlignment.stretch,
            children: const [
              FileDiffViewer(files: _sampleFiles, maxHeight: 420),
              m.SizedBox(height: 24),
              FileDiffViewer(
                files: _sampleFiles,
                layout: FileDiffLayout.split,
                maxHeight: 360,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

const _sampleFiles = [
  FileDiff(
    path:
        'lib/registry/components/display/file_diff_viewer/file_diff_viewer.dart',
    status: 'modified',
    hunks: [
      FileDiffHunk(
        header: '@@ -1,8 +1,22 @@',
        lines: [
          FileDiffLine.context(
            oldLineNumber: 1,
            newLineNumber: 1,
            content: "import 'package:flutter/widgets.dart';",
          ),
          FileDiffLine.deletion(
            oldLineNumber: 2,
            content: "class FileDiffViewer extends StatelessWidget {",
          ),
          FileDiffLine.addition(
            newLineNumber: 2,
            content: "class FileDiffViewer extends StatefulWidget {",
          ),
          FileDiffLine.addition(
            newLineNumber: 3,
            content: '  final List<FileDiff> files;',
          ),
          FileDiffLine.addition(
            newLineNumber: 4,
            content: '  final FileDiffLayout layout;',
          ),
          FileDiffLine.context(
            oldLineNumber: 3,
            newLineNumber: 5,
            content: '  const FileDiffViewer({super.key});',
          ),
          FileDiffLine.context(
            oldLineNumber: 4,
            newLineNumber: 6,
            content: '}',
          ),
        ],
      ),
      FileDiffHunk(
        header: '@@ -40,16 +58,16 @@',
        collapsed: true,
        lines: [
          FileDiffLine.context(
            oldLineNumber: 40,
            newLineNumber: 58,
            content: '  final theme = Theme.of(context);',
          ),
          FileDiffLine.context(
            oldLineNumber: 41,
            newLineNumber: 59,
            content: '  final background = theme.colorScheme.card;',
          ),
          FileDiffLine.context(
            oldLineNumber: 42,
            newLineNumber: 60,
            content: '  return Container(',
          ),
          FileDiffLine.context(
            oldLineNumber: 43,
            newLineNumber: 61,
            content: '    color: background,',
          ),
        ],
      ),
    ],
  ),
  FileDiff(
    path: 'lib/registry/components/display/file_diff_viewer/README.md',
    oldPath: 'lib/registry/components/display/diff_viewer/README.md',
    status: 'renamed',
    hunks: [
      FileDiffHunk(
        header: '@@ -1,3 +1,8 @@',
        lines: [
          FileDiffLine.deletion(oldLineNumber: 1, content: '# Diff Viewer'),
          FileDiffLine.addition(
            newLineNumber: 1,
            content: '# File Diff Viewer',
          ),
          FileDiffLine.context(oldLineNumber: 2, newLineNumber: 2, content: ''),
          FileDiffLine.addition(
            newLineNumber: 3,
            content: 'Displays review-ready file patches.',
          ),
          FileDiffLine.addition(
            newLineNumber: 4,
            content: 'Supports unified and split layouts.',
          ),
        ],
      ),
    ],
  ),
];
