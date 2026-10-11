// QA for `stepper` previews (P7-Q2): behaviour, spacing, functionality.
//
// Drives every `stepperPreviews` example like a user: the Default and
// Vertical steppers advance on step tap, the Sizes example renders all three
// indicator sizes, and the Failed-step example flags step 0. Indicator
// metrics (28/32/36) and density scaling are pinned in `stepper_test.dart`.

import 'package:flutter/widgets.dart';
import 'package:flutter_shadcn_kit/registry/components/stepper/preview.dart';
import 'package:flutter_shadcn_kit/registry/components/stepper/stepper.dart';
import 'package:flutter_shadcn_kit/registry/foundation/component_preview.dart';
import 'package:flutter_shadcn_kit/registry/theme/color_tokens.dart';
import 'package:flutter_shadcn_kit/registry/theme/density.dart';
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
    for (final preview in stepperPreviews) {
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

  testWidgets('Default preview: tapping a step advances the stepper', (
    tester,
  ) async {
    await _pumpPreview(tester, stepperPreviews[0]);
    expect(find.text('Account'), findsOneWidget);
    // The indicator ring is the tap target (titles are labels by design).
    await tester.tap(find.byType(StepperIndicator).at(2));
    await tester.pump();
    expect(tester.takeException(), isNull);
    // Content of the now-current step shows.
    expect(find.text('Card, invoice'), findsOneWidget);
  });

  testWidgets('Vertical preview: tapping a step advances', (tester) async {
    await _pumpPreview(tester, stepperPreviews[1]);
    await tester.tap(find.byType(StepperIndicator).at(0));
    await tester.pump();
    expect(tester.takeException(), isNull);
    expect(find.text('Email, password'), findsOneWidget);
  });

  testWidgets('Sizes preview renders all three indicator sizes', (
    tester,
  ) async {
    await _pumpPreview(tester, stepperPreviews[2]);
    expect(find.text('sm (36.0px)'), findsOneWidget);
    expect(find.text('md (40.0px)'), findsOneWidget);
    expect(find.text('lg (44.0px)'), findsOneWidget);
  });

  testWidgets('Failed step preview flags the first step', (tester) async {
    await _pumpPreview(tester, stepperPreviews[3]);
    expect(find.text('Account'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('previews mirror in RTL with no exception', (tester) async {
    for (final preview in stepperPreviews) {
      await _pumpPreview(tester, preview, direction: TextDirection.rtl);
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull, reason: '${preview.name} RTL');
    }
  });

  double contentPadTop(WidgetTester tester, String label) {
    final Padding padding = tester.widget<Padding>(
      find.ancestor(of: find.text(label), matching: find.byType(Padding)).first,
    );
    return padding.padding.resolve(TextDirection.ltr).top;
  }

  Future<void> pumpContent(
    WidgetTester tester, {
    Density density = Density.defaultDensity,
  }) {
    return tester.pumpWidget(
      ShadcnTheme(
        data: ShadcnThemeData(density: density),
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: Center(
            child: Stepper(
              currentStep: 1,
              onStepChanged: (_) {},
              steps: const <StepperStep>[
                StepperStep(title: Text('a'), content: Text('body-a')),
                StepperStep(title: Text('b'), content: Text('body-b')),
              ],
            ),
          ),
        ),
      ),
    );
  }

  testWidgets('content padding scales with density (P7-Q2)', (tester) async {
    await pumpContent(tester, density: Density.defaultDensity);
    expect(contentPadTop(tester, 'body-b'), 8);
    await pumpContent(tester, density: Density.compactDensity);
    expect(contentPadTop(tester, 'body-b'), 4);
    await pumpContent(tester, density: Density.spaciousDensity);
    expect(contentPadTop(tester, 'body-b'), 10);
    expect(tester.takeException(), isNull);
  });

  testWidgets('vertical content indent mirrors in RTL (P7-Q2)', (tester) async {
    Future<EdgeInsets> indent(TextDirection direction) async {
      await tester.pumpWidget(
        ShadcnTheme(
          data: const ShadcnThemeData(),
          child: Directionality(
            textDirection: direction,
            child: Center(
              child: Stepper(
                currentStep: 0,
                onStepChanged: (_) {},
                direction: Axis.vertical,
                steps: const <StepperStep>[
                  StepperStep(title: Text('a'), content: Text('vert-a')),
                  StepperStep(title: Text('b'), content: Text('vert-b')),
                ],
              ),
            ),
          ),
        ),
      );
      final Padding padding = tester.widget<Padding>(
        find
            .ancestor(of: find.text('vert-a'), matching: find.byType(Padding))
            .first,
      );
      return padding.padding.resolve(direction);
    }

    final EdgeInsets ltr = await indent(TextDirection.ltr);
    expect(ltr.left, greaterThan(0));
    expect(ltr.right, 0);
    final EdgeInsets rtl = await indent(TextDirection.rtl);
    expect(rtl.right, greaterThan(0));
    expect(rtl.left, 0);
    expect(rtl.right, ltr.left);
    expect(tester.takeException(), isNull);
  });
}
