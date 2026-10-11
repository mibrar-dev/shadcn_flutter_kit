// QA for `tree` previews (P7-Q2): behaviour, spacing, functionality.
//
// Drives every `treePreviews` example like a user. The preview trees are
// uncontrolled (no selection/expand callbacks), so taps must be safe no-ops
// that throw nothing; full controlled behaviour (expand/collapse, selection,
// keyboard, branch lines) is pinned in `tree_test.dart`.

import 'package:flutter/widgets.dart';
import 'package:flutter_shadcn_kit/registry/components/tree/preview.dart';
import 'package:flutter_shadcn_kit/registry/foundation/component_preview.dart';
import 'package:flutter_shadcn_kit/registry/theme/color_tokens.dart';
import 'package:flutter_shadcn_kit/registry/theme/theme.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _frame(
  Widget child, {
  ShadcnThemeData data = const ShadcnThemeData(),
  TextDirection direction = TextDirection.ltr,
  double width = 360,
}) {
  return ShadcnTheme(
    data: data,
    child: Directionality(
      textDirection: direction,
      child: Center(
        child: SizedBox(width: width, child: child),
      ),
    ),
  );
}

Future<void> _pumpPreview(
  WidgetTester tester,
  ComponentPreview preview, {
  ShadcnThemeData data = const ShadcnThemeData(),
  TextDirection direction = TextDirection.ltr,
  double width = 360,
}) async {
  await tester.pumpWidget(
    _frame(
      Builder(builder: preview.builder),
      data: data,
      direction: direction,
      width: width,
    ),
  );
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 16));
  expect(
    tester.takeException(),
    isNull,
    reason: 'preview "${preview.name}" threw',
  );
}

void main() {
  testWidgets('every preview pumps light + dark with no exception', (
    tester,
  ) async {
    for (final preview in treePreviews) {
      for (final colors in <ShadcnColors>[
        ShadcnColors.lightFallback,
        ShadcnColors.darkFallback,
      ]) {
        await tester.pumpWidget(
          _frame(
            Builder(builder: preview.builder),
            data: ShadcnThemeData(colors: colors),
          ),
        );
        await tester.pumpAndSettle();
        expect(
          tester.takeException(),
          isNull,
          reason: '${preview.name} light/dark',
        );
      }
    }
  });

  testWidgets('Default preview: expanded subtree and selection render', (
    tester,
  ) async {
    await _pumpPreview(tester, treePreviews[0]);
    expect(find.text('Documents'), findsOneWidget);
    expect(find.text('report.pdf'), findsOneWidget);
    expect(find.text('notes.md'), findsOneWidget);
    // `archive` starts collapsed, so its child stays hidden.
    expect(find.text('archive'), findsOneWidget);
    expect(find.text('2024.zip'), findsNothing);
    expect(find.text('Pictures'), findsOneWidget);
  });

  testWidgets('Default preview: taps are safe no-ops without callbacks', (
    tester,
  ) async {
    await _pumpPreview(tester, treePreviews[0]);
    await tester.tap(find.text('notes.md'));
    await tester.pump();
    await tester.tap(find.text('Documents'));
    await tester.pump();
    expect(tester.takeException(), isNull);
    // Uncontrolled: nothing collapses away.
    expect(find.text('report.pdf'), findsOneWidget);
  });

  testWidgets('Collapsed preview hides children', (tester) async {
    await _pumpPreview(tester, treePreviews[3]);
    expect(find.text('Documents'), findsOneWidget);
    expect(find.text('report.pdf'), findsNothing);
  });

  testWidgets('Line guides and No guides previews render', (tester) async {
    await _pumpPreview(tester, treePreviews[1]);
    expect(find.text('Documents'), findsOneWidget);
    await _pumpPreview(tester, treePreviews[2]);
    expect(find.text('Documents'), findsOneWidget);
  });

  testWidgets('previews mirror in RTL with no exception', (tester) async {
    for (final preview in treePreviews) {
      await _pumpPreview(tester, preview, direction: TextDirection.rtl);
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull, reason: '${preview.name} RTL');
    }
  });
}
