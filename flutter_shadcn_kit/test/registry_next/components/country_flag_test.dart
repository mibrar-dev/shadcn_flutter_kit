// Widget tests for the `country_flag` component.
//
// Covers the code/currency/prefix lookups, unknown-code boxes, sizes,
// shapes, custom builders and the four theme-precedence legs. Regression
// tests cover the retired `phonecodes` package: lookups run against the
// `countries` primitive table and the emoji derives from the ISO code.

import 'package:flutter/widgets.dart';
import 'package:flutter_shadcn_kit/registry_next/components/country_flag/country_flag.dart';
import 'package:flutter_shadcn_kit/registry_next/primitives/countries.dart';
import 'package:flutter_shadcn_kit/registry_next/primitives/phone_number.dart';
import 'package:flutter_shadcn_kit/registry_next/theme/theme.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _frame({
  required Widget child,
  ShadcnThemeData data = const ShadcnThemeData(),
  List<ComponentThemeData> app = const <ComponentThemeData>[],
  CountryFlagTheme? scoped,
}) {
  Widget body = child;
  if (scoped != null) {
    body = ComponentTheme<CountryFlagTheme>(data: scoped, child: body);
  }
  return ShadcnTheme(
    data: data,
    child: ComponentThemes(
      themes: app,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Center(child: body),
      ),
    ),
  );
}

void main() {
  group('lookups', () {
    testWidgets('code lookup renders the flag emoji', (tester) async {
      await tester.pumpWidget(_frame(child: CountryFlag.fromCountryCode('US')));
      expect(find.text(flagEmojiForCode('US')), findsOneWidget);
      expect(flagEmojiForCode('US'), isNotEmpty);
    });

    testWidgets('lookups are case-insensitive', (tester) async {
      await tester.pumpWidget(_frame(child: CountryFlag.fromCountryCode('us')));
      expect(find.text(flagEmojiForCode('US')), findsOneWidget);
    });

    testWidgets('currency lookup finds the country', (tester) async {
      await tester.pumpWidget(
        _frame(child: CountryFlag.fromCurrencyCode('JPY')),
      );
      expect(find.text(flagEmojiForCode('JP')), findsOneWidget);
    });

    testWidgets('dial prefix lookup works with and without plus', (
      tester,
    ) async {
      await tester.pumpWidget(
        _frame(child: CountryFlag.fromPhonePrefix('+81')),
      );
      expect(find.text(flagEmojiForCode('JP')), findsOneWidget);
      await tester.pumpWidget(_frame(child: CountryFlag.fromPhonePrefix('81')));
      expect(find.text(flagEmojiForCode('JP')), findsOneWidget);
    });

    testWidgets('unknown codes render an empty sized box', (tester) async {
      await tester.pumpWidget(_frame(child: CountryFlag.fromCountryCode('XX')));
      expect(find.byType(Text), findsNothing);
      expect(tester.getSize(find.byType(SizedBox)), const Size(24, 18));
    });

    testWidgets('direct country ctor', (tester) async {
      await tester.pumpWidget(
        _frame(
          child: const CountryFlag(Country(dialCode: '+49', code: 'DE')),
        ),
      );
      expect(find.text(flagEmojiForCode('DE')), findsOneWidget);
    });
  });

  group('sizing and shape', () {
    testWidgets('widget size overrides the theme', (tester) async {
      await tester.pumpWidget(
        _frame(child: CountryFlag.fromCountryCode('FR', width: 36, height: 27)),
      );
      expect(tester.getSize(find.byType(SizedBox).first), const Size(36, 27));
    });

    testWidgets('shape clips the flag', (tester) async {
      await tester.pumpWidget(
        _frame(
          child: CountryFlag.fromCountryCode(
            'IT',
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
          ),
        ),
      );
      expect(find.byType(ClipPath), findsOneWidget);
    });

    testWidgets('no clip without a shape', (tester) async {
      await tester.pumpWidget(_frame(child: CountryFlag.fromCountryCode('IT')));
      expect(find.byType(ClipPath), findsNothing);
    });

    testWidgets('custom builder replaces the emoji', (tester) async {
      await tester.pumpWidget(
        _frame(
          scoped: CountryFlagTheme(
            builder: (context, details) => Text('flag:${details.countryCode}'),
          ),
          child: CountryFlag.fromCountryCode('US'),
        ),
      );
      expect(find.text('flag:US'), findsOneWidget);
    });
  });

  group('theme precedence', () {
    testWidgets('widget > scoped > app > defaults', (tester) async {
      CountryFlagTheme resolve(BuildContext context, CountryFlagTheme? widget) {
        return resolveComponentStyle<CountryFlagTheme, CountryFlagTheme>(
          context,
          widget: widget,
          select: (t) => t,
          defaults: countryFlagDefaults,
        );
      }

      CountryFlagTheme? seen;
      Future<void> pump({
        CountryFlagTheme? widget,
        CountryFlagTheme? scoped,
        List<ComponentThemeData> app = const <ComponentThemeData>[],
      }) async {
        await tester.pumpWidget(
          _frame(
            app: app,
            scoped: scoped,
            child: Builder(
              builder: (context) {
                seen = resolve(context, widget);
                return const SizedBox();
              },
            ),
          ),
        );
      }

      await pump();
      expect(seen!.width, 24);
      await pump(app: const <ComponentThemeData>[CountryFlagTheme(width: 20)]);
      expect(seen!.width, 20);
      await pump(
        scoped: const CountryFlagTheme(width: 22),
        app: const <ComponentThemeData>[CountryFlagTheme(width: 20)],
      );
      expect(seen!.width, 22);
      await pump(
        widget: const CountryFlagTheme(width: 26),
        scoped: const CountryFlagTheme(width: 22),
        app: const <ComponentThemeData>[CountryFlagTheme(width: 20)],
      );
      expect(seen!.width, 26);
    });
  });

  group('regressions', () {
    test('flag emoji derives from the ISO code', () {
      expect(flagEmojiForCode('US'), '\u{1F1FA}\u{1F1F8}');
      expect(flagEmojiForCode('us'), '\u{1F1FA}\u{1F1F8}');
      expect(flagEmojiForCode('X'), isEmpty);
      expect(flagEmojiForCode('1A'), isEmpty);
    });

    test('table lookups hit real rows', () {
      expect(countryInfoForCode('DE')?.dialCode, '+49');
      expect(countryInfoForCurrency('JPY')?.code, 'JP');
      expect(countryInfoForDialCode('+49')?.code, 'DE');
      expect(countryInfoForCode('XX'), isNull);
    });
  });
}
