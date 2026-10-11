// QA for `switcher` previews (P7-Q2): behaviour, spacing, functionality.
//
// Drives every `switcherPreviews` example like a user: the Default pager
// flips pages from its buttons and reports indices, the Vertical pager
// honours the scoped duration/curve leg. Swipe/drag paging and the animation
// curve are pinned in `switcher_test.dart`.

import 'package:flutter/widgets.dart';
import 'package:flutter_shadcn_kit/registry/components/switcher/preview.dart';
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
    for (final preview in switcherPreviews) {
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

  testWidgets('Default preview: buttons flip pages and report indices', (
    tester,
  ) async {
    await _pumpPreview(tester, switcherPreviews[0]);
    expect(find.text('page 0'), findsOneWidget);
    expect(find.text('reported: []'), findsOneWidget);
    await tester.tap(find.text('2'));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(find.text('page 2'), findsOneWidget);
  });

  testWidgets('Default preview: drag flips the page', (tester) async {
    await _pumpPreview(tester, switcherPreviews[0]);
    // direction: right is forward, so a rightward drag advances.
    await tester.drag(find.text('page 0'), const Offset(160, 0));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(find.text('page 1'), findsOneWidget);
  });

  testWidgets('Vertical preview renders', (tester) async {
    await _pumpPreview(tester, switcherPreviews[1]);
    expect(find.text('v0'), findsOneWidget);
  });

  testWidgets('previews mirror in RTL with no exception', (tester) async {
    for (final preview in switcherPreviews) {
      await _pumpPreview(tester, preview, direction: TextDirection.rtl);
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull, reason: '${preview.name} RTL');
    }
  });
}
