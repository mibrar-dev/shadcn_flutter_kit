// QA for `chip` previews (P7-Q1).
//
// Regression cover for: the dead `autofocus` on Chip and ChipButton (now
// honoured through an owned focus node).

import 'package:flutter/widgets.dart';
import 'package:flutter_shadcn_kit/registry/components/chip/chip.dart';
import 'package:flutter_shadcn_kit/registry/components/chip/preview.dart';
import 'package:flutter_shadcn_kit/registry/primitives/clickable.dart';
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
    for (final preview in chipPreviews) {
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

  testWidgets('autofocus focuses a pressable chip', (tester) async {
    await tester.pumpWidget(
      _frame(Chip(autofocus: true, onPressed: () {}, child: const Text('c'))),
    );
    await tester.pump();
    await tester.pump();
    expect(Focus.of(tester.element(find.text('c'))).hasPrimaryFocus, isTrue);
  });

  testWidgets('autofocus focuses a chip button', (tester) async {
    await tester.pumpWidget(
      _frame(
        ChipButton(autofocus: true, onPressed: () {}, child: const Text('x')),
      ),
    );
    await tester.pump();
    await tester.pump();
    expect(Focus.of(tester.element(find.text('x'))).hasPrimaryFocus, isTrue);
  });

  testWidgets('pressable preview counts taps', (tester) async {
    await tester.pumpWidget(_frame(Builder(builder: chipPreviews[1].builder)));
    await tester.pumpAndSettle();
    expect(find.text('pressed 0'), findsOneWidget);
    await tester.tap(find.byType(Chip).first);
    await tester.pump();
    expect(find.text('pressed 1'), findsOneWidget);
  });

  testWidgets('static chip builds no Clickable', (tester) async {
    await tester.pumpWidget(_frame(const Chip(child: Text('s'))));
    await tester.pump();
    expect(find.byType(Clickable), findsNothing);
  });
}
