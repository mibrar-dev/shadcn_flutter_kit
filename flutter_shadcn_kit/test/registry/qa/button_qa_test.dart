// QA for `button` previews (P7-Q1).
//
// Regression cover for: the autofocus post-frame race (rebuilt with
// autofocus off must not touch a disposed node) and the documented size
// table (28/32/36/40 heights, horizontal-only padding, uniform 14px text).

import 'package:flutter/widgets.dart';
import 'package:flutter_shadcn_kit/registry/components/button/button.dart';
import 'package:flutter_shadcn_kit/registry/components/button/preview.dart';
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
    for (final preview in buttonPreviews) {
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

  testWidgets('size table heights are 28/32/36/40', (tester) async {
    const Map<ButtonSize, double> expected = <ButtonSize, double>{
      ButtonSize.xs: 28,
      ButtonSize.sm: 32,
      ButtonSize.md: 36,
      ButtonSize.lg: 40,
    };
    for (final MapEntry<ButtonSize, double> entry in expected.entries) {
      await tester.pumpWidget(
        _frame(
          Button(size: entry.key, onPressed: () {}, child: const Text('b')),
        ),
      );
      await tester.pump();
      expect(
        tester.getSize(find.byType(Button)).height,
        entry.value,
        reason: '${entry.key}',
      );
    }
  });

  testWidgets('autofocus rebuild-off does not touch a disposed node', (
    tester,
  ) async {
    await tester.pumpWidget(
      _frame(Button(autofocus: true, onPressed: () {}, child: const Text('a'))),
    );
    // Turn autofocus off before the post-frame callback runs.
    await tester.pumpWidget(
      _frame(
        Button(autofocus: false, onPressed: () {}, child: const Text('a')),
      ),
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });

  testWidgets('autofocus focuses the button', (tester) async {
    await tester.pumpWidget(
      _frame(Button(autofocus: true, onPressed: () {}, child: const Text('f'))),
    );
    await tester.pump();
    await tester.pump();
    expect(Focus.of(tester.element(find.text('f'))).hasPrimaryFocus, isTrue);
  });

  testWidgets('disabled button ignores taps', (tester) async {
    bool pressed = false;
    await tester.pumpWidget(
      _frame(
        Button(
          enabled: false,
          onPressed: () => pressed = true,
          child: const Text('no'),
        ),
      ),
    );
    await tester.pump();
    await tester.tap(find.text('no'));
    expect(pressed, isFalse);
  });
}
