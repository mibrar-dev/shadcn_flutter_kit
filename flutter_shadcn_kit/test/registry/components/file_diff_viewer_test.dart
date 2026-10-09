// Widget and unit tests for the `file_diff_viewer` component.
//
// Covers: the token surface in light + dark, the four theme legs, unified vs
// split gutter rendering, hunk collapse/expansion, the copy action (clipboard
// payload + confirmation), `toPatch()` output, sizes and RTL.

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_shadcn_kit/registry/components/file_diff_viewer/file_diff_viewer.dart';
import 'package:flutter_shadcn_kit/registry/theme/color_tokens.dart';
import 'package:flutter_shadcn_kit/registry/theme/theme.dart';
import 'package:flutter_test/flutter_test.dart';

const Color _red = Color(0xFFFF0000);
const Color _green = Color(0xFF00FF00);
const Color _blue = Color(0xFF0000FF);

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

Widget _frame({
  ShadcnThemeData data = const ShadcnThemeData(),
  List<ComponentThemeData> app = const <ComponentThemeData>[],
  TextDirection textDirection = TextDirection.ltr,
  required Widget child,
}) {
  return ShadcnTheme(
    data: data,
    child: ComponentThemes(
      themes: app,
      child: Directionality(
        textDirection: textDirection,
        // The selection region needs an Overlay ancestor, as in real apps.
        child: Navigator(
          onGenerateRoute: (RouteSettings settings) => PageRouteBuilder<void>(
            settings: settings,
            pageBuilder: (BuildContext context, _, _) =>
                Center(child: SizedBox(width: 760, child: child)),
          ),
        ),
      ),
    ),
  );
}

FileDiffSurface _surface(WidgetTester tester) {
  return resolveFileDiffSurface(
    tester.element(find.byType(FileDiffViewer)),
    widgetTheme: tester
        .widget<FileDiffViewer>(find.byType(FileDiffViewer))
        .theme,
  );
}

bool _isGutter(Widget widget) {
  return widget is Container &&
      widget.constraints != null &&
      widget.constraints!.minWidth == 52;
}

/// The 1px vertical rule between the two sides of a split row.
bool _isSplitDivider(Widget widget) {
  return widget is Container &&
      widget.constraints != null &&
      widget.constraints!.minWidth == 1 &&
      widget.constraints!.maxWidth == 1;
}

void main() {
  const ShadcnColors light = ShadcnColors.lightFallback;
  const ShadcnColors dark = ShadcnColors.darkFallback;

  testWidgets('token surface in light and dark', (tester) async {
    await tester.pumpWidget(
      _frame(child: const FileDiffViewer(files: <FileDiff>[_patch])),
    );
    FileDiffSurface surface = _surface(tester);
    expect(surface.background, light.card);
    expect(surface.border, light.border);
    expect(surface.hunkBackground, light.accent);
    expect(surface.addition, light.chart2);
    expect(surface.deletion, light.destructive);
    expect(surface.gutterWidth, 52);
    expect(tester.takeException(), isNull);

    await tester.pumpWidget(const SizedBox());
    await tester.pumpWidget(
      _frame(
        data: const ShadcnThemeData(colors: dark),
        child: const FileDiffViewer(files: <FileDiff>[_patch]),
      ),
    );
    surface = _surface(tester);
    expect(surface.background, dark.card);
    expect(surface.addition, dark.chart2);
    expect(surface.deletion, dark.destructive);
    expect(tester.takeException(), isNull);
  });

  testWidgets('theme precedence: defaults < app < scoped < widget', (
    tester,
  ) async {
    const FileDiffViewerTheme app = FileDiffViewerTheme(
      additionColor: ThemedColor.value(_red),
      borderRadius: BorderRadius.all(Radius.circular(4)),
    );
    const FileDiffViewerTheme scoped = FileDiffViewerTheme(
      additionColor: ThemedColor.value(_green),
      linePadding: EdgeInsets.all(3),
    );
    const FileDiffViewerTheme widgetLeg = FileDiffViewerTheme(
      additionColor: ThemedColor.value(_blue),
    );

    await tester.pumpWidget(
      _frame(
        app: <ComponentThemeData>[app],
        child: const FileDiffViewer(files: <FileDiff>[_patch]),
      ),
    );
    FileDiffSurface surface = _surface(tester);
    expect(surface.addition, _red);
    expect(surface.radius, const BorderRadius.all(Radius.circular(4)));

    await tester.pumpWidget(const SizedBox());
    await tester.pumpWidget(
      _frame(
        app: <ComponentThemeData>[app],
        child: const ComponentTheme<FileDiffViewerTheme>(
          data: scoped,
          child: FileDiffViewer(files: <FileDiff>[_patch]),
        ),
      ),
    );
    surface = _surface(tester);
    expect(surface.addition, _green);
    expect(surface.linePadding, const EdgeInsets.all(3));
    // `scoped` sets no radius, so the app leg survives the merge.
    expect(surface.radius, const BorderRadius.all(Radius.circular(4)));

    await tester.pumpWidget(const SizedBox());
    await tester.pumpWidget(
      _frame(
        app: <ComponentThemeData>[app],
        child: const ComponentTheme<FileDiffViewerTheme>(
          data: scoped,
          child: FileDiffViewer(theme: widgetLeg, files: <FileDiff>[_patch]),
        ),
      ),
    );
    expect(_surface(tester).addition, _blue);
  });

  testWidgets('unified layout shows both gutters per line', (tester) async {
    await tester.pumpWidget(
      _frame(child: const FileDiffViewer(files: <FileDiff>[_patch])),
    );
    expect(find.text('10'), findsWidgets);
    expect(find.text('Widget build() {'), findsOneWidget);
    expect(find.text('+'), findsOneWidget);
    expect(find.text('-'), findsOneWidget);
    expect(find.byWidgetPredicate(_isGutter), findsWidgets);
    // Three lines with a pair of gutters each, and no split divider.
    expect(find.byWidgetPredicate(_isGutter), findsNWidgets(6));
    expect(find.byWidgetPredicate(_isSplitDivider), findsNothing);
  });

  testWidgets('split layout shows one gutter per side', (tester) async {
    await tester.pumpWidget(
      _frame(
        child: const FileDiffViewer(
          layout: FileDiffLayout.split,
          files: <FileDiff>[_patch],
        ),
      ),
    );
    // Three lines x (one gutter per side), each pair split by a divider.
    expect(find.byWidgetPredicate(_isGutter), findsNWidgets(6));
    expect(find.byWidgetPredicate(_isSplitDivider), findsNWidgets(3));
    expect(find.text('return Text(label);'), findsNothing);
    expect(find.text('  return Text(label);'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('collapsed hunks start hidden and expand on header tap', (
    tester,
  ) async {
    await tester.pumpWidget(
      _frame(child: const FileDiffViewer(files: <FileDiff>[_patch])),
    );
    expect(find.text('void hidden() {}'), findsNothing);

    await tester.tap(find.text('@@ -40,1 +41,1 @@'));
    await tester.pump();
    expect(find.text('void hidden() {}'), findsOneWidget);

    // Visible hunks are not tappable: their header has no gesture.
    await tester.tap(find.text('@@ -10,3 +10,4 @@'));
    await tester.pump();
    expect(find.text('void hidden() {}'), findsOneWidget);
  });

  testWidgets('copy action writes the plain-text patch to the clipboard', (
    tester,
  ) async {
    final List<MethodCall> log = <MethodCall>[];
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
      SystemChannels.platform,
      (MethodCall call) async {
        log.add(call);
        return null;
      },
    );
    addTearDown(() {
      tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        SystemChannels.platform,
        null,
      );
    });

    await tester.pumpWidget(
      _frame(child: const FileDiffViewer(files: <FileDiff>[_patch])),
    );
    await tester.tap(find.text('Copy'));
    await tester.pump();
    final List<MethodCall> setData = log
        .where((MethodCall call) => call.method == 'Clipboard.setData')
        .toList();
    expect(setData, hasLength(1));
    final String payload = (setData.single.arguments as Map)['text'] as String;
    expect(payload, contains('--- lib/src/widget.dart'));
    expect(payload, contains('+++ lib/src/widget.dart'));
    expect(payload, contains('@@ -10,3 +10,4 @@'));
    expect(payload, contains('+  return Text(label);'));
    expect(payload, contains('-  return label;'));
    // Confirmation icon replaces the label for a moment...
    expect(find.text('Copy'), findsNothing);
    await tester.pump(const Duration(milliseconds: 1300));
    // ...and the label returns once the feedback delay elapsed.
    expect(find.text('Copy'), findsOneWidget);
  });

  test('toPatch() renders rename, headers and markers', () {
    const FileDiff renamed = FileDiff(
      path: 'b.dart',
      oldPath: 'a.dart',
      hunks: <FileDiffHunk>[
        FileDiffHunk(
          header: '@@ -1,1 +1,1 @@',
          lines: <FileDiffLine>[
            FileDiffLine(type: FileDiffLineType.context, content: 'x'),
          ],
        ),
      ],
    );
    final String patch = renamed.toPatch();
    expect(patch.split('\n'), <String>[
      'rename from a.dart',
      'rename to b.dart',
      '--- a.dart',
      '+++ b.dart',
      '@@ -1,1 +1,1 @@',
      ' x',
      '',
    ]);
    expect(renamed.additions, 0);
    expect(renamed.deletions, 0);
  });

  testWidgets('RTL renders', (tester) async {
    await tester.pumpWidget(
      _frame(
        textDirection: TextDirection.rtl,
        child: const FileDiffViewer(files: <FileDiff>[_patch]),
      ),
    );
    expect(tester.takeException(), isNull);
  });

  test('merge is receiver-wins per field', () {
    const FileDiffViewerTheme base = FileDiffViewerTheme(
      additionColor: ThemedColor.value(_red),
      deletionColor: ThemedColor.value(_green),
    );
    const FileDiffViewerTheme over = FileDiffViewerTheme(
      additionColor: ThemedColor.value(_blue),
    );
    final FileDiffViewerTheme merged = over.merge(base);
    expect(merged.additionColor, const ThemedColor.value(_blue));
    expect(merged.deletionColor, const ThemedColor.value(_green));
  });
}
