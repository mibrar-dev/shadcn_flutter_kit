// QA for `color_field` previews (P7-Q1): behaviour, spacing, robustness.
//
// Regression cover for: the paint surface exposing no semantics (screen
// readers announced nothing for the gradient area).

import 'package:flutter/widgets.dart';
import 'package:flutter_shadcn_kit/registry/components/color_field/color_field.dart';
import 'package:flutter_shadcn_kit/registry/components/color_field/preview.dart';
import 'package:flutter_shadcn_kit/registry/theme/color_tokens.dart';
import 'package:flutter_shadcn_kit/registry/theme/theme.dart';
import 'package:flutter_test/flutter_test.dart';

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
    for (final preview in colorFieldPreviews) {
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

  testWidgets('semantics expose the colour value (display-only)', (
    tester,
  ) async {
    await tester.pumpWidget(
      _frame(
        const SizedBox(
          width: 240,
          height: 140,
          child: ColorField(
            color: Color(0xFF2563EB),
            saturationAxis: ColorFieldAxis.horizontal,
            valueAxis: ColorFieldAxis.vertical,
          ),
        ),
      ),
    );
    await tester.pump();
    final SemanticsHandle handle = tester.ensureSemantics();
    final Finder field = find.bySemanticsLabel('HSV color field');
    expect(field, findsOneWidget);
    expect(
      tester.getSemantics(field).value,
      '#FF2563EB',
      reason: 'the painted colour as a semantic value',
    );
    handle.dispose();
    expect(tester.takeException(), isNull);
  });

  testWidgets('translucent colours report their alpha channel', (tester) async {
    await tester.pumpWidget(
      _frame(
        const SizedBox(
          width: 240,
          height: 24,
          child: ColorField(
            color: Color(0x8022C55E),
            alphaAxis: ColorFieldAxis.horizontal,
          ),
        ),
      ),
    );
    await tester.pump();
    final SemanticsHandle handle = tester.ensureSemantics();
    final Finder field = find.bySemanticsLabel('HSV color field');
    expect(field, findsOneWidget);
    expect(tester.getSemantics(field).value, '#8022C55E');
    handle.dispose();
    expect(tester.takeException(), isNull);
  });

  testWidgets('default preview fits 375px with no overflow', (tester) async {
    await tester.pumpWidget(
      _frame(Builder(builder: colorFieldPreviews[0].builder), width: 375),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    expect(tester.takeException(), isNull);
  });

  testWidgets('RTL pumps with no exception', (tester) async {
    await tester.pumpWidget(
      _frame(
        Builder(builder: colorFieldPreviews[0].builder),
        direction: TextDirection.rtl,
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    expect(tester.takeException(), isNull);
  });
}
