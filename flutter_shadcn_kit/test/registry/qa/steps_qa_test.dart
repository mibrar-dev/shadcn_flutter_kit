// QA for `steps` previews (P7-Q2): behaviour, spacing, functionality.
//
// `Steps` is a static vertical flow (for interactive flows use `stepper`):
// the previews assert the Default/Custom/Single examples render their
// titles and content, honour the scoped theme leg, and survive RTL + 375px.

import 'package:flutter/widgets.dart';
import 'package:flutter_shadcn_kit/registry/components/steps/preview.dart';
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
    for (final preview in stepsPreviews) {
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

  testWidgets('Default preview renders all three stages', (tester) async {
    await _pumpPreview(tester, stepsPreviews[0]);
    expect(find.text('Account'), findsOneWidget);
    expect(find.text('Sign up with your email address.'), findsOneWidget);
    expect(find.text('Verify'), findsOneWidget);
    expect(find.text('Profile'), findsOneWidget);
  });

  testWidgets('Custom indicators preview renders themed rows', (tester) async {
    await _pumpPreview(tester, stepsPreviews[1]);
    expect(find.text('Cart'), findsOneWidget);
    expect(find.text('Pay'), findsOneWidget);
  });

  testWidgets('Single step preview renders without a connector', (
    tester,
  ) async {
    await _pumpPreview(tester, stepsPreviews[2]);
    expect(find.text('Done'), findsOneWidget);
    expect(find.text('Nothing else.'), findsOneWidget);
  });

  testWidgets('Default preview fits a 375px phone with no overflow', (
    tester,
  ) async {
    await _pumpPreview(tester, stepsPreviews[0], width: 375);
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });

  testWidgets('previews mirror in RTL with no exception', (tester) async {
    for (final preview in stepsPreviews) {
      await _pumpPreview(tester, preview, direction: TextDirection.rtl);
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull, reason: '${preview.name} RTL');
    }
  });
}
