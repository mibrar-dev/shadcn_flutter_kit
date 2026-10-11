// QA for `border_loading` previews (P7-Q1).
//
// Regression cover for: the frozen loop animation (painter hoisted out of
// the AnimatedBuilder), the mislabelled Progress example, and mode switches.

import 'package:flutter/widgets.dart';
import 'package:flutter_shadcn_kit/registry/components/border_loading/border_loading.dart';
import 'package:flutter_shadcn_kit/registry/components/border_loading/preview.dart';
import 'package:flutter_shadcn_kit/registry/theme/color_tokens.dart';
import 'package:flutter_shadcn_kit/registry/theme/theme.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _frame(
  Widget child, {
  ShadcnThemeData data = const ShadcnThemeData(),
  double? width,
}) {
  return ShadcnTheme(
    data: data,
    child: Directionality(
      textDirection: TextDirection.ltr,
      child: Center(
        child: width == null ? child : SizedBox(width: width, child: child),
      ),
    ),
  );
}

void main() {
  testWidgets('every preview pumps light + dark with no exception', (
    tester,
  ) async {
    for (final preview in borderLoadingPreviews) {
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
        // No pumpAndSettle: the sweep loop never settles by design.
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 300));
        expect(
          tester.takeException(),
          isNull,
          reason: '${preview.name} light/dark',
        );
      }
    }
  });

  testWidgets('sweep animation rebuilds the painter every tick', (
    tester,
  ) async {
    await tester.pumpWidget(
      _frame(const BorderLoading(child: SizedBox(width: 120, height: 48))),
    );
    await tester.pump();
    final Object? first = tester
        .widget<CustomPaint>(find.byType(CustomPaint).first)
        .painter;
    await tester.pump(const Duration(milliseconds: 200));
    final Object? second = tester
        .widget<CustomPaint>(find.byType(CustomPaint).first)
        .painter;
    expect(identical(first, second), isFalse);
  });

  testWidgets('progress mode paints a static 60% arc', (tester) async {
    await tester.pumpWidget(
      _frame(
        const BorderLoading(
          mode: BorderLoadingMode.progress,
          progress: 0.6,
          child: SizedBox(width: 120, height: 48),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byType(CustomPaint), findsWidgets);
    expect(tester.takeException(), isNull);
  });

  testWidgets('switching from sweep to progress stops the loop', (
    tester,
  ) async {
    await tester.pumpWidget(
      _frame(const BorderLoading(child: SizedBox(width: 120, height: 48))),
    );
    await tester.pump();
    await tester.pumpWidget(
      _frame(
        const BorderLoading(
          mode: BorderLoadingMode.progress,
          progress: 0.5,
          child: SizedBox(width: 120, height: 48),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });
}
