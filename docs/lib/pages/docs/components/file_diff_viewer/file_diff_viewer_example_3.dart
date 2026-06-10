import 'package:docs/shadcn_ui.dart';

/// Multiple files — added, renamed, and deleted statuses.
///
/// Pass a list of `FileDiff` objects to review an entire changeset at once.
/// Each file can carry an `added`, `modified`, `renamed`, or `deleted` status,
/// and individual hunks can be collapsed by default.
class FileDiffViewerExample3 extends StatelessWidget {
  const FileDiffViewerExample3({super.key});

  @override
  Widget build(BuildContext context) {
    return const FileDiffViewer(
      files: [
        FileDiff(
          path: 'lib/src/utils/logger.dart',
          status: 'added',
          hunks: [
            FileDiffHunk(
              header: '@@ -0,0 +1,8 @@',
              lines: [
                FileDiffLine.addition(
                  newLineNumber: 1,
                  content: "import 'dart:developer' as dev;",
                ),
                FileDiffLine.addition(
                  newLineNumber: 2,
                  content: '',
                ),
                FileDiffLine.addition(
                  newLineNumber: 3,
                  content: 'void log(String message) =>',
                ),
                FileDiffLine.addition(
                  newLineNumber: 4,
                  content: "    dev.log(message, name: 'app');",
                ),
              ],
            ),
          ],
        ),
        FileDiff(
          path: 'lib/src/utils/helpers.dart',
          oldPath: 'lib/src/helpers.dart',
          status: 'renamed',
          hunks: [
            FileDiffHunk(
              header: '@@ -1,3 +1,3 @@',
              lines: [
                FileDiffLine.deletion(
                  oldLineNumber: 1,
                  content: '// helpers.dart',
                ),
                FileDiffLine.addition(
                  newLineNumber: 1,
                  content: '// utils/helpers.dart',
                ),
                FileDiffLine.context(
                  oldLineNumber: 2,
                  newLineNumber: 2,
                  content: '',
                ),
              ],
            ),
          ],
        ),
        FileDiff(
          path: 'lib/src/legacy/old_api.dart',
          status: 'deleted',
          hunks: [
            FileDiffHunk(
              header: '@@ -1,4 +0,0 @@',
              collapsed: true,
              lines: [
                FileDiffLine.deletion(
                  oldLineNumber: 1,
                  content: '// Deprecated — use logger.dart instead.',
                ),
                FileDiffLine.deletion(
                  oldLineNumber: 2,
                  content: 'void oldLog(String msg) => print(msg);',
                ),
              ],
            ),
          ],
        ),
      ],
      maxHeight: 420,
    );
  }
}
