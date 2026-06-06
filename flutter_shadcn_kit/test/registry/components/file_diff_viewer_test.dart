import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_shadcn_kit/registry/components/display/file_diff_viewer/file_diff_viewer.dart';
import 'package:flutter_shadcn_kit/registry/shared/theme/theme.dart' as shadcn;

void main() {
  testWidgets('FileDiffViewer renders file headers and stats', (tester) async {
    await tester.pumpWidget(
      const shadcn.Theme(
        data: shadcn.ThemeData(),
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: FileDiffViewer(
            files: [
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
            ],
          ),
        ),
      ),
    );

    expect(find.text('lib/example.dart'), findsOneWidget);
    expect(find.text('+1'), findsOneWidget);
    expect(find.text('-1'), findsOneWidget);
    expect(find.textContaining('newValue'), findsOneWidget);
  });
}
