// QA for `empty_state` (P7-Q1): behaviour, spacing, robustness.
//
// Regression cover for: the dead widget-leg `iconContainerPadding` /
// `iconContainerBorderRadius` (the size table always won), the dead
// `descriptionMaxWidth` clamp (560 over a 520 block), and custom
// `titleStyle`/`descriptionStyle` dropping the ambient colour.

import 'package:flutter/widgets.dart';
import 'package:flutter_shadcn_kit/registry/components/empty_state/empty_state.dart';
import 'package:flutter_shadcn_kit/registry/components/empty_state/preview.dart';
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
        child: width == null
            ? SizedBox(width: 600, height: 600, child: child)
            : SizedBox(width: width, height: 600, child: child),
      ),
    ),
  );
}

TextStyle _titleStyle(WidgetTester tester, String text) {
  return tester
      .widget<DefaultTextStyle>(
        find
            .ancestor(
              of: find.text(text),
              matching: find.byType(DefaultTextStyle),
            )
            .first,
      )
      .style;
}

void main() {
  testWidgets('every preview pumps light + dark with no exception', (
    tester,
  ) async {
    for (final preview in emptyStatePreviews) {
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

  testWidgets('an explicit icon container padding wins over the size table', (
    tester,
  ) async {
    await tester.pumpWidget(
      _frame(
        const EmptyState(
          theme: EmptyStateTheme(iconContainerPadding: EdgeInsets.all(99)),
        ),
      ),
    );
    final Padding padding = tester.widget<Padding>(
      find.descendant(
        of: find.byKey(emptyStateIconContainerKey),
        matching: find.byType(Padding),
      ),
    );
    expect(padding.padding, const EdgeInsets.all(99));
  });

  testWidgets('an explicit icon container radius wins over the size table', (
    tester,
  ) async {
    await tester.pumpWidget(
      _frame(
        const EmptyState(
          theme: EmptyStateTheme(
            iconContainerBorderRadius: BorderRadius.all(Radius.circular(99)),
          ),
        ),
      ),
    );
    final BoxDecoration decoration =
        tester
                .widget<DecoratedBox>(find.byKey(emptyStateIconContainerKey))
                .decoration
            as BoxDecoration;
    expect(
      decoration.borderRadius,
      const BorderRadius.all(Radius.circular(99)),
    );
  });

  testWidgets('the fullPage description measure fits inside the block', (
    tester,
  ) async {
    const ShadcnThemeData theme = ShadcnThemeData();
    final EmptyStateMetrics metrics = emptyStateMetrics(
      EmptyStateSize.fullPage,
      theme,
    );
    expect(metrics.descriptionMaxWidth, 520);
    expect(metrics.descriptionMaxWidth, lessThanOrEqualTo(metrics.maxWidth));
  });

  testWidgets('a colour-less title override keeps the foreground token', (
    tester,
  ) async {
    await tester.pumpWidget(
      _frame(
        const EmptyState(
          theme: EmptyStateTheme(titleStyle: TextStyle(fontSize: 30)),
        ),
      ),
    );
    final TextStyle style = _titleStyle(tester, 'Nothing here yet');
    expect(style.fontSize, 30);
    expect(style.color, ShadcnColors.lightFallback.foreground);
  });

  testWidgets('a colour-less description override keeps the muted token', (
    tester,
  ) async {
    await tester.pumpWidget(
      _frame(
        const EmptyState(
          theme: EmptyStateTheme(descriptionStyle: TextStyle(fontSize: 30)),
        ),
      ),
    );
    final TextStyle style = _titleStyle(
      tester,
      'Create your first item to get started.',
    );
    expect(style.fontSize, 30);
    expect(style.color, ShadcnColors.lightFallback.mutedForeground);
  });

  testWidgets('default preview fits 375px with no overflow', (tester) async {
    await tester.pumpWidget(
      _frame(Builder(builder: emptyStatePreviews[0].builder), width: 375),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    expect(tester.takeException(), isNull);
  });

  testWidgets('RTL pumps with no exception', (tester) async {
    await tester.pumpWidget(
      _frame(
        Builder(builder: emptyStatePreviews[0].builder),
        direction: TextDirection.rtl,
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    expect(tester.takeException(), isNull);
  });
}
