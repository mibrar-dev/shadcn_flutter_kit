import 'package:docs/shadcn_ui.dart';

/// Split (side-by-side) diff layout.
///
/// Pass `layout: FileDiffLayout.split` for a side-by-side view that shows the
/// old version on the left and the new version on the right — useful when
/// reviewing larger changes where context matters.
class FileDiffViewerExample2 extends StatelessWidget {
  const FileDiffViewerExample2({super.key});

  @override
  Widget build(BuildContext context) {
    return const FileDiffViewer(
      layout: FileDiffLayout.split,
      files: [
        FileDiff(
          path: 'lib/src/auth/login.dart',
          status: 'modified',
          hunks: [
            FileDiffHunk(
              header: '@@ -1,6 +1,10 @@',
              lines: [
                FileDiffLine.context(
                  oldLineNumber: 1,
                  newLineNumber: 1,
                  content: "import 'package:flutter/material.dart';",
                ),
                FileDiffLine.deletion(
                  oldLineNumber: 2,
                  content: 'class LoginScreen extends StatelessWidget {',
                ),
                FileDiffLine.addition(
                  newLineNumber: 2,
                  content: 'class LoginScreen extends StatefulWidget {',
                ),
                FileDiffLine.addition(
                  newLineNumber: 3,
                  content: '  const LoginScreen({super.key});',
                ),
                FileDiffLine.addition(
                  newLineNumber: 4,
                  content: '',
                ),
                FileDiffLine.addition(
                  newLineNumber: 5,
                  content:
                      '  State<LoginScreen> createState() => _LoginScreenState();',
                ),
                FileDiffLine.context(
                  oldLineNumber: 3,
                  newLineNumber: 6,
                  content: '}',
                ),
              ],
            ),
          ],
        ),
      ],
      maxHeight: 320,
    );
  }
}
