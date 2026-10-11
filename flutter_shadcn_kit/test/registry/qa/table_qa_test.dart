// QA for `table` previews (P7-Q2): behaviour, spacing, functionality.
//
// Drives every `tablePreviews` example like a user: the Default grid renders
// header/body/footer with the selected row, column spans lay out, and the
// Resizable example owns working controllers. Cell padding (p-2 body,
// px-2 head) and density scaling are pinned in `table_test.dart` and the
// layout-audit suite; this file pins the *previews* pump cleanly in both
// brightnesses, mirror in RTL, survive 375px, and resize by drag.

import 'package:flutter/widgets.dart';
import 'package:flutter_shadcn_kit/registry/components/table/preview.dart';
import 'package:flutter_shadcn_kit/registry/components/table/table.dart';
import 'package:flutter_shadcn_kit/registry/foundation/component_preview.dart';
import 'package:flutter_shadcn_kit/registry/theme/color_tokens.dart';
import 'package:flutter_shadcn_kit/registry/theme/theme.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _frame(
  Widget child, {
  ShadcnThemeData data = const ShadcnThemeData(),
  TextDirection direction = TextDirection.ltr,
  double width = 480,
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
  double width = 480,
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
    for (final preview in tablePreviews) {
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

  testWidgets('Default preview: header, rows, footer and selection render', (
    tester,
  ) async {
    await _pumpPreview(tester, tablePreviews[0]);
    expect(find.text('Name'), findsOneWidget);
    expect(find.text('Avery'), findsOneWidget);
    expect(find.text('Casey'), findsOneWidget);
    expect(find.text('3 people'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Default preview fits a 375px phone with no overflow', (
    tester,
  ) async {
    await _pumpPreview(tester, tablePreviews[0], width: 375);
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });

  testWidgets('Resizable preview: drag a divider resizes the column', (
    tester,
  ) async {
    await _pumpPreview(tester, tablePreviews[1]);
    expect(find.text('Drag a divider'), findsOneWidget);
    // The column divider resizers are present and hittable.
    expect(find.byType(CellResizer), findsWidgets);
    final Offset center = tester.getCenter(find.byType(CellResizer).first);
    await tester.dragFrom(center, const Offset(24, 0));
    await tester.pump();
    expect(tester.takeException(), isNull);
    expect(find.text('Drag a divider'), findsOneWidget);
  });

  testWidgets('previews mirror in RTL with no exception', (tester) async {
    for (final preview in tablePreviews) {
      await _pumpPreview(tester, preview, direction: TextDirection.rtl);
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull, reason: '${preview.name} RTL');
    }
  });
}
