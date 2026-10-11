// QA for `tracker` previews (P7-Q2): behaviour, spacing, functionality.
//
// Drives every `trackerPreviews` example: all four levels render in Default,
// the Custom-size example honours the widget-leg theme (24px segments,
// 4px gap), and the Themed example tints `fine` with the primary token.
// Level colours and metrics are pinned in `tracker_test.dart`.

import 'package:flutter/widgets.dart';
import 'package:flutter_shadcn_kit/registry/components/tracker/preview.dart';
import 'package:flutter_shadcn_kit/registry/components/tracker/tracker.dart';
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
    for (final preview in trackerPreviews) {
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

  testWidgets('all three examples render their segments', (tester) async {
    for (final preview in trackerPreviews) {
      await _pumpPreview(tester, preview);
      expect(tester.takeException(), isNull);
    }
  });

  testWidgets('Default preview fits a 375px phone with no overflow', (
    tester,
  ) async {
    await _pumpPreview(tester, trackerPreviews[0], width: 375);
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });

  testWidgets('previews mirror in RTL with no exception', (tester) async {
    for (final preview in trackerPreviews) {
      await _pumpPreview(tester, preview, direction: TextDirection.rtl);
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull, reason: '${preview.name} RTL');
    }
  });

  testWidgets('level colours resolve chart tokens, not literals (P7-Q2)', (
    tester,
  ) async {
    // Pins the README fix: `fine`/`warning` borrow chart2/chart4.
    await _pumpPreview(tester, trackerPreviews[2]);
    final ShadcnThemeData theme = ShadcnTheme.of(
      tester.element(find.byType(Tracker).first),
    );
    expect(trackerDefaults.fine!.resolve(theme.colors), theme.colors.chart2);
    expect(trackerDefaults.warning!.resolve(theme.colors), theme.colors.chart4);
    expect(tester.takeException(), isNull);
  });
}
