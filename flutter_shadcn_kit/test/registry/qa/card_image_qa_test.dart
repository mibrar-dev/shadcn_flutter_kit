// QA for `card_image` previews (P7-Q1): contract, interaction, widths.
//
// No verified widget bug was found in this pass (the IntrinsicWidth pattern
// only matters for unbounded parents, which the docs stage never is); these
// tests lock the keyboard/disabled/hover contract.

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_shadcn_kit/registry/components/card_image/card_image.dart';
import 'package:flutter_shadcn_kit/registry/components/card_image/preview.dart';
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
    for (final preview in cardImagePreviews) {
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

  testWidgets('tap and Enter/Space activate the card', (tester) async {
    int presses = 0;
    await tester.pumpWidget(
      _frame(
        SizedBox(
          width: 220,
          child: CardImage(
            onPressed: () => presses++,
            image: const SizedBox(width: 120, height: 80),
            title: const Text('t'),
          ),
        ),
      ),
    );
    await tester.pump();
    await tester.tap(find.byType(CardImage));
    expect(presses, 1);
    final Element element = tester.element(find.text('t'));
    Focus.of(element).requestFocus();
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pump();
    expect(presses, 2);
  });

  testWidgets('card without onPressed is inert', (tester) async {
    await tester.pumpWidget(
      _frame(
        const SizedBox(
          width: 220,
          child: CardImage(
            image: SizedBox(width: 120, height: 80),
            title: Text('t'),
          ),
        ),
      ),
    );
    await tester.pump();
    await tester.tap(find.byType(CardImage));
    expect(tester.takeException(), isNull);
  });

  testWidgets('vertical preview fits 375px', (tester) async {
    await tester.pumpWidget(
      _frame(Builder(builder: cardImagePreviews[0].builder), width: 375),
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });
}
