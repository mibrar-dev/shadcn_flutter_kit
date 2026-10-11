// QA for `file_diff_viewer` previews (P7-Q1 batch E): behaviour, robustness.
//
// Regression cover for: the file header overflowing at 375px (badges +
// status + copy sat outside the horizontal scroller), the mouse-only hunk
// toggle, unscaled confirmation/chevron icons, the copy-feedback timer race
// and mirrored code rows in RTL.

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_shadcn_kit/registry/components/button/button.dart';
import 'package:flutter_shadcn_kit/registry/components/file_diff_viewer/file_diff_viewer.dart';
import 'package:flutter_shadcn_kit/registry/components/file_diff_viewer/preview.dart';
import 'package:flutter_shadcn_kit/registry/foundation/icons/radix_icons.dart';
import 'package:flutter_shadcn_kit/registry/primitives/clickable.dart';
import 'package:flutter_shadcn_kit/registry/theme/color_tokens.dart';
import 'package:flutter_shadcn_kit/registry/theme/theme.dart';
import 'package:flutter_test/flutter_test.dart';

const FileDiff _patch = FileDiff(
  path: 'lib/src/widget.dart',
  hunks: <FileDiffHunk>[
    FileDiffHunk(
      header: '@@ -10,3 +10,4 @@',
      lines: <FileDiffLine>[
        FileDiffLine(
          type: FileDiffLineType.context,
          content: 'Widget build() {',
          oldLineNumber: 10,
          newLineNumber: 10,
        ),
        FileDiffLine(
          type: FileDiffLineType.deletion,
          content: '  return label;',
          oldLineNumber: 11,
        ),
        FileDiffLine(
          type: FileDiffLineType.addition,
          content: '  return Text(label);',
          newLineNumber: 11,
        ),
      ],
    ),
    FileDiffHunk(
      header: '@@ -40,1 +41,1 @@',
      collapsed: true,
      lines: <FileDiffLine>[
        FileDiffLine(
          type: FileDiffLineType.context,
          content: 'void hidden() {}',
          oldLineNumber: 40,
          newLineNumber: 41,
        ),
      ],
    ),
  ],
);

const FileDiff _longPath = FileDiff(
  path: 'lib/src/features/dashboard/widgets/very_long_widget_name.dart',
  status: 'modified',
  hunks: <FileDiffHunk>[
    FileDiffHunk(
      header: '@@ -1,2 +1,3 @@',
      lines: <FileDiffLine>[
        FileDiffLine(
          type: FileDiffLineType.context,
          content: 'x',
          oldLineNumber: 1,
          newLineNumber: 1,
        ),
        FileDiffLine(
          type: FileDiffLineType.addition,
          content: 'y',
          newLineNumber: 2,
        ),
      ],
    ),
  ],
);

Widget _frame(
  Widget child, {
  ShadcnThemeData data = const ShadcnThemeData(),
  TextDirection direction = TextDirection.ltr,
  double? width,
}) {
  return ShadcnTheme(
    data: data,
    child: Directionality(
      textDirection: direction,
      // The SelectableRegion needs an Overlay ancestor, as in real apps.
      child: Navigator(
        onGenerateRoute: (RouteSettings settings) => PageRouteBuilder<void>(
          settings: settings,
          pageBuilder: (BuildContext context, _, _) => Center(
            child: width == null ? child : SizedBox(width: width, child: child),
          ),
        ),
      ),
    ),
  );
}

void _mockClipboard(WidgetTester tester) {
  tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
    SystemChannels.platform,
    (MethodCall call) async {
      if (call.method == 'Clipboard.getData') {
        return <String, dynamic>{'text': ''};
      }
      return null;
    },
  );
  addTearDown(
    () => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
      SystemChannels.platform,
      null,
    ),
  );
}

Clickable _hunkToggle(WidgetTester tester, String header) {
  return tester.widget<Clickable>(
    find.ancestor(of: find.text(header), matching: find.byType(Clickable)),
  );
}

void main() {
  testWidgets('every preview pumps light + dark with no exception', (
    tester,
  ) async {
    for (final preview in fileDiffViewerPreviews) {
      for (final colors in <ShadcnColors>[
        ShadcnColors.lightFallback,
        ShadcnColors.darkFallback,
      ]) {
        // Reset first: the frame's Navigator keeps its first route, so
        // without this every iteration would re-show the first preview.
        await tester.pumpWidget(const SizedBox.shrink());
        await tester.pumpWidget(
          _frame(
            Builder(builder: preview.builder),
            data: ShadcnThemeData(colors: colors),
          ),
        );
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 100));
        expect(
          tester.takeException(),
          isNull,
          reason: '${preview.name} light/dark',
        );
      }
    }
  });

  testWidgets('long header wraps at 375px with no overflow', (tester) async {
    await tester.pumpWidget(
      _frame(const FileDiffViewer(files: <FileDiff>[_longPath]), width: 375),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    expect(tester.takeException(), isNull);
    expect(find.textContaining('very_long_widget_name'), findsOneWidget);
  });

  testWidgets('collapsed hunk header is a keyboard-accessible toggle', (
    tester,
  ) async {
    await tester.pumpWidget(
      _frame(const FileDiffViewer(files: <FileDiff>[_patch])),
    );
    expect(find.text('void hidden() {}'), findsNothing);
    // The collapsed header owns an enabled Clickable (keyboard + tap).
    expect(_hunkToggle(tester, '@@ -40,1 +41,1 @@').onPressed, isNotNull);
    await tester.tap(find.text('@@ -40,1 +41,1 @@'));
    await tester.pump();
    expect(find.text('void hidden() {}'), findsOneWidget);
  });

  testWidgets('visible hunk header renders static (no toggle)', (tester) async {
    await tester.pumpWidget(
      _frame(const FileDiffViewer(files: <FileDiff>[_patch])),
    );
    expect(_hunkToggle(tester, '@@ -10,3 +10,4 @@').onPressed, isNull);
  });

  testWidgets('rapid copy taps restart the confirmation window', (
    tester,
  ) async {
    _mockClipboard(tester);
    await tester.pumpWidget(
      _frame(const FileDiffViewer(files: <FileDiff>[_patch])),
    );
    await tester.tap(find.text('Copy'));
    await tester.pump();
    expect(find.byIcon(RadixIcons.check), findsOneWidget);

    // 1100ms into the first 1200ms window, tap again: the stale timer must
    // not clear the newer confirmation.
    await tester.pump(const Duration(milliseconds: 1100));
    await tester.tap(find.byType(Button));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 1100));
    expect(
      find.byIcon(RadixIcons.check),
      findsOneWidget,
      reason: 'stale timer cleared a newer confirmation',
    );
    await tester.pump(const Duration(milliseconds: 200));
    expect(find.text('Copy'), findsOneWidget);
  });

  testWidgets('confirmation and chevron icons follow theme scaling', (
    tester,
  ) async {
    _mockClipboard(tester);
    await tester.pumpWidget(
      _frame(
        const FileDiffViewer(files: <FileDiff>[_patch]),
        data: const ShadcnThemeData(scaling: 2),
      ),
    );
    await tester.tap(find.text('Copy'));
    await tester.pump();
    final Icon confirm = tester.widget<Icon>(
      find.descendant(of: find.byType(Button), matching: find.byType(Icon)),
    );
    expect(confirm.size, 28);
    final Icon chevron = tester.widget<Icon>(
      find.byIcon(RadixIcons.chevronRight),
    );
    expect(chevron.size, 28);
    // Let the copy-feedback timer elapse so no timer outlives the test.
    await tester.pump(const Duration(milliseconds: 1500));
    expect(find.text('Copy'), findsOneWidget);
  });

  testWidgets('RTL keeps code rows LTR with a directional gutter', (
    tester,
  ) async {
    await tester.pumpWidget(
      _frame(
        const FileDiffViewer(files: <FileDiff>[_patch]),
        direction: TextDirection.rtl,
      ),
    );
    await tester.pump();
    expect(tester.takeException(), isNull);
    // Every code row forces LTR order even under an RTL ancestor.
    expect(
      find.descendant(
        of: find.byType(FileDiffViewer),
        matching: find.byWidgetPredicate(
          (Widget widget) =>
              widget is Directionality &&
              widget.textDirection == TextDirection.ltr,
        ),
      ),
      findsWidgets,
    );
    // The gutter divider is directional, never a physical right border.
    expect(
      find.descendant(
        of: find.byType(FileDiffViewer),
        matching: find.byWidgetPredicate(
          (Widget widget) =>
              widget is Container &&
              widget.decoration is BoxDecoration &&
              (widget.decoration! as BoxDecoration).border is BorderDirectional,
        ),
      ),
      findsWidgets,
    );
  });
}
