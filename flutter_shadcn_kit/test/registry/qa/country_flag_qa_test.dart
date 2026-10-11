// QA for `country_flag` previews (P7-Q1): behaviour, spacing, robustness.
//
// Regression cover for: the emoji glyph exposing no accessible name, and
// the README showing `const` generative constructors (which are non-const).

import 'package:flutter/widgets.dart';
import 'package:flutter_shadcn_kit/registry/components/country_flag/country_flag.dart';
import 'package:flutter_shadcn_kit/registry/components/country_flag/preview.dart';
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
    for (final preview in countryFlagPreviews) {
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

  testWidgets('the emoji exposes the resolved country name', (tester) async {
    await tester.pumpWidget(
      _frame(
        Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            CountryFlag.fromCountryCode('US'),
            CountryFlag.fromCurrencyCode('JPY'),
            CountryFlag.fromPhonePrefix('+49'),
          ],
        ),
      ),
    );
    await tester.pump();
    final SemanticsHandle handle = tester.ensureSemantics();
    expect(find.bySemanticsLabel('United States'), findsOneWidget);
    expect(find.bySemanticsLabel('Japan'), findsOneWidget);
    expect(find.bySemanticsLabel('Germany'), findsOneWidget);
    handle.dispose();
    expect(tester.takeException(), isNull);
  });

  testWidgets('unknown codes render an empty box with no semantics', (
    tester,
  ) async {
    await tester.pumpWidget(_frame(CountryFlag.fromCountryCode('XX')));
    await tester.pump();
    final SemanticsHandle handle = tester.ensureSemantics();
    expect(find.bySemanticsLabel('XX'), findsNothing);
    expect(find.bySemanticsLabel(RegExp('.+')), findsNothing);
    handle.dispose();
    expect(tester.takeException(), isNull);
  });

  testWidgets('default preview fits 375px with no overflow', (tester) async {
    await tester.pumpWidget(
      _frame(Builder(builder: countryFlagPreviews[0].builder), width: 375),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    expect(tester.takeException(), isNull);
  });

  testWidgets('RTL pumps with no exception', (tester) async {
    await tester.pumpWidget(
      _frame(
        Builder(builder: countryFlagPreviews[0].builder),
        direction: TextDirection.rtl,
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    expect(tester.takeException(), isNull);
  });
}
