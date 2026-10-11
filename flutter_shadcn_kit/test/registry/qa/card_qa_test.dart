// QA for `card` previews (P7-Q1).
//
// Regression cover for: the dead `CardTheme.foreground` leg (now drives
// `CardTitle`) and the README overclaim about content inheritance.

import 'package:flutter/widgets.dart';
import 'package:flutter_shadcn_kit/registry/components/card/card.dart';
import 'package:flutter_shadcn_kit/registry/components/card/preview.dart';
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
    for (final preview in cardPreviews) {
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

  testWidgets('scoped foreground leg reaches the title', (tester) async {
    const Color custom = Color(0xFF123456);
    await tester.pumpWidget(
      _frame(
        const ComponentTheme<CardTheme>(
          data: CardTheme(foreground: ThemedColor.value(custom)),
          child: Card(child: CardTitle(child: Text('t'))),
        ),
      ),
    );
    await tester.pump();
    final DefaultTextStyle text = tester.widget<DefaultTextStyle>(
      find
          .descendant(
            of: find.byType(CardTitle),
            matching: find.byType(DefaultTextStyle),
          )
          .first,
    );
    expect(text.style.color, custom);
  });

  testWidgets('title falls back to cardForeground without overrides', (
    tester,
  ) async {
    await tester.pumpWidget(
      _frame(const Card(child: CardTitle(child: Text('t')))),
    );
    await tester.pump();
    final DefaultTextStyle text = tester.widget<DefaultTextStyle>(
      find
          .descendant(
            of: find.byType(CardTitle),
            matching: find.byType(DefaultTextStyle),
          )
          .first,
    );
    expect(text.style.color, ShadcnColors.lightFallback.cardForeground);
  });

  testWidgets('card padding is p-6 at default density', (tester) async {
    await tester.pumpWidget(_frame(const Card(child: Text('x'))));
    await tester.pump();
    final Padding padding = tester.widget<Padding>(
      find
          .descendant(of: find.byType(Card), matching: find.byType(Padding))
          .first,
    );
    final EdgeInsets resolved = padding.padding.resolve(TextDirection.ltr);
    expect(resolved.left, 24);
    expect(resolved.top, 24);
  });
}
