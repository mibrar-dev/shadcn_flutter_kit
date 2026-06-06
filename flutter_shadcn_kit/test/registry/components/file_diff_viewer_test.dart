import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_shadcn_kit/registry/components/display/file_diff_viewer/file_diff_viewer.dart';
import 'package:flutter_shadcn_kit/registry/shared/theme/theme.dart' as shadcn;

void main() {
  testWidgets('FileDiffViewer renders file headers and stats', (tester) async {
    await tester.pumpWidget(_testHost(const FileDiffViewer(files: _testFiles)));

    expect(find.text('lib/example.dart'), findsOneWidget);
    expect(find.text('+1'), findsOneWidget);
    expect(find.text('-1'), findsOneWidget);
    expect(find.textContaining('newValue'), findsOneWidget);
  });

  testWidgets('FileDiffViewer hides copy actions when requested', (
    tester,
  ) async {
    await tester.pumpWidget(
      _testHost(const FileDiffViewer(files: _testFiles, showCopyAction: false)),
    );

    expect(find.text('Copy'), findsNothing);
  });

  testWidgets('FileDiffViewer expands collapsed hunks', (tester) async {
    await tester.pumpWidget(
      _testHost(
        const FileDiffViewer(
          files: [
            FileDiff(
              path: 'lib/collapsed.dart',
              hunks: [
                FileDiffHunk(
                  header: '@@ -10,1 +10,1 @@',
                  collapsed: true,
                  lines: [
                    FileDiffLine.context(
                      oldLineNumber: 10,
                      newLineNumber: 10,
                      content: 'final hidden = true;',
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );

    expect(find.text('Show 1 unchanged lines'), findsOneWidget);
    expect(find.textContaining('hidden = true'), findsNothing);

    await tester.tap(find.text('Show 1 unchanged lines'));
    await tester.pump();

    expect(find.textContaining('hidden = true'), findsOneWidget);
  });
}

Widget _testHost(Widget child) {
  return shadcn.Theme(
    data: const shadcn.ThemeData(),
    child: Directionality(textDirection: TextDirection.ltr, child: child),
  );
}

const _testFiles = [
  FileDiff(
    path: 'lib/example.dart',
    hunks: [
      FileDiffHunk(
        header: '@@ -1,2 +1,3 @@',
        lines: [
          FileDiffLine.context(
            oldLineNumber: 1,
            newLineNumber: 1,
            content: 'class Example {}',
          ),
          FileDiffLine.deletion(
            oldLineNumber: 2,
            content: 'final oldValue = 1;',
          ),
          FileDiffLine.addition(
            newLineNumber: 2,
            content: 'final newValue = 1;',
          ),
        ],
      ),
    ],
  ),
];
