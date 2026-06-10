import 'package:docs/shadcn_ui.dart';

/// Unified diff layout (default).
///
/// `FileDiffViewer` renders file patches in a review-ready format. The default
/// unified layout shows deletions and additions in a single column, matching
/// the style of GitHub and GitLab PR views.
class FileDiffViewerExample1 extends StatelessWidget {
  const FileDiffViewerExample1({super.key});

  @override
  Widget build(BuildContext context) {
    return const FileDiffViewer(
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
                  content:
                      '  const LoginScreen({super.key});',
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
