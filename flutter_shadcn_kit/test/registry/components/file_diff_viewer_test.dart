import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_shadcn_kit/registry/components/display/file_diff_viewer/file_diff_viewer.dart';
import 'package:flutter_shadcn_kit/registry/shared/icons/radix_icons.dart';
import 'package:flutter_shadcn_kit/registry/shared/theme/theme.dart' as shadcn;

void main() {
  testWidgets('FileDiffViewer renders file headers and stats', (tester) async {
    await tester.pumpWidget(_testHost(const FileDiffViewer(files: _testFiles)));

    expect(find.text('lib/example.dart'), findsOneWidget);
    expect(find.text('+1'), findsOneWidget);
    expect(find.text('-1'), findsOneWidget);
    expect(find.textContaining('newValue'), findsOneWidget);
  });

  testWidgets('FileDiffViewer renders file icon in the header', (tester) async {
    await tester.pumpWidget(_testHost(const FileDiffViewer(files: _testFiles)));

    expect(find.byIcon(RadixIcons.fileText), findsOneWidget);
  });

  testWidgets('FileDiffViewer hides copy actions when requested', (
    tester,
  ) async {
    await tester.pumpWidget(
      _testHost(const FileDiffViewer(files: _testFiles, showCopyAction: false)),
    );

    expect(find.text('Copy'), findsNothing);
  });

  testWidgets('FileDiffViewer hides file headers when requested', (
    tester,
  ) async {
    await tester.pumpWidget(
      _testHost(
        const FileDiffViewer(files: _testFiles, showFileHeaders: false),
      ),
    );

    expect(find.text('lib/example.dart'), findsNothing);
    expect(find.textContaining('newValue'), findsOneWidget);
  });

  testWidgets('FileDiffViewer hides line number gutters when requested', (
    tester,
  ) async {
    await tester.pumpWidget(
      _testHost(
        const FileDiffViewer(files: _testFiles, showLineNumbers: false),
      ),
    );

    expect(find.text('1'), findsNothing);
    expect(find.text('2'), findsNothing);
    expect(find.textContaining('newValue'), findsOneWidget);
  });

  testWidgets('FileDiffViewer uses configurable minimum content width', (
    tester,
  ) async {
    const minContentWidth = 960.0;

    await tester.pumpWidget(
      _testHost(
        const FileDiffViewer(
          files: _testFiles,
          minContentWidth: minContentWidth,
        ),
      ),
    );

    final sizedBoxes = tester.widgetList<SizedBox>(find.byType(SizedBox));

    expect(sizedBoxes.any((box) => box.width == minContentWidth), isTrue);
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

  testWidgets('FileDiffViewer applies code typography theme tokens', (
    tester,
  ) async {
    const codeFontFamily = 'JetBrains Mono';
    const codeFontSize = 13.0;

    await tester.pumpWidget(
      _testHost(
        shadcn.ComponentTheme<FileDiffViewerTheme>(
          data: const FileDiffViewerTheme(
            codeFontFamily: codeFontFamily,
            codeFontSize: codeFontSize,
          ),
          child: const FileDiffViewer(files: _testFiles),
        ),
      ),
    );

    final hunkText = tester.widget<Text>(find.textContaining('@@').first);

    expect(hunkText.style?.fontFamily, codeFontFamily);
    expect(hunkText.style?.fontSize, codeFontSize);
  });

  testWidgets('FileDiffViewer applies gutter width theme token', (
    tester,
  ) async {
    const gutterWidth = 72.0;

    await tester.pumpWidget(
      _testHost(
        shadcn.ComponentTheme<FileDiffViewerTheme>(
          data: const FileDiffViewerTheme(gutterWidth: gutterWidth),
          child: const FileDiffViewer(files: _testFiles),
        ),
      ),
    );

    final sizedBoxes = tester.widgetList<Container>(find.byType(Container));

    expect(
      sizedBoxes.any(
        (container) => container.constraints?.maxWidth == gutterWidth,
      ),
      isTrue,
    );
  });

  testWidgets('FileDiffViewer renders circular change markers', (tester) async {
    await tester.pumpWidget(_testHost(const FileDiffViewer(files: _testFiles)));

    final containers = tester.widgetList<Container>(find.byType(Container));

    expect(
      containers.any((container) {
        final decoration = container.decoration;
        return decoration is BoxDecoration &&
            decoration.shape == BoxShape.circle;
      }),
      isTrue,
    );
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
