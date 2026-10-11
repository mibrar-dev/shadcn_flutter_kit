// QA for `badge` previews (P7-Q1).
//
// Regression cover for: the dead `autofocus` prop (now focuses a pressable
// badge) and unscaled icon/dot metrics.

import 'package:flutter/widgets.dart';
import 'package:flutter_shadcn_kit/registry/components/badge/badge.dart';
import 'package:flutter_shadcn_kit/registry/components/badge/preview.dart';
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
    for (final preview in badgePreviews) {
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

  testWidgets('autofocus focuses a pressable badge', (tester) async {
    await tester.pumpWidget(
      _frame(
        Badge(autofocus: true, onPressed: () {}, child: const Text('new')),
      ),
    );
    await tester.pump();
    await tester.pump();
    final Element element = tester.element(find.text('new'));
    expect(Focus.of(element).hasPrimaryFocus, isTrue);
  });

  testWidgets('static badge stays out of the focus tree', (tester) async {
    await tester.pumpWidget(_frame(const Badge(child: Text('plain'))));
    await tester.pump();
    expect(find.byType(Clickable), findsNothing);
  });

  testWidgets('dot scales with ambient scaling', (tester) async {
    await tester.pumpWidget(
      _frame(
        Badge(showAsDot: true, onPressed: () {}, child: const Text('x')),
        data: const ShadcnThemeData(scaling: 2),
      ),
    );
    await tester.pump();
    expect(
      tester.getSize(
        find
            .descendant(of: find.byType(Badge), matching: find.byType(SizedBox))
            .first,
      ),
      const Size(20, 20),
    );
  });

  testWidgets('disabled-look pressable badge still activates by tap', (
    tester,
  ) async {
    bool pressed = false;
    await tester.pumpWidget(
      _frame(Badge(onPressed: () => pressed = true, child: const Text('go'))),
    );
    await tester.pump();
    await tester.tap(find.text('go'));
    expect(pressed, isTrue);
  });
}
