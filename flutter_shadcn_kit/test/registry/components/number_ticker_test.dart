// Widget tests for the `number_ticker` component.
//
// Covers the formatter and builder variants, value animation, the flip-clock
// pieces and the four theme-precedence legs. Regression tests cover the
// retired pieces: the app-wide theme leg (ignored by the old two-leg read)
// and the `material.dart` import in the flipper mask.

import 'package:flutter/widgets.dart';
import 'package:flutter_shadcn_kit/registry/components/number_ticker/number_ticker.dart';
import 'package:flutter_shadcn_kit/registry/theme/theme.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart' as intl;

Widget _frame({
  required Widget child,
  ShadcnThemeData data = const ShadcnThemeData(),
  List<ComponentThemeData> app = const <ComponentThemeData>[],
  NumberTickerTheme? scoped,
}) {
  Widget body = child;
  if (scoped != null) {
    body = ComponentTheme<NumberTickerTheme>(data: scoped, child: body);
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
  group('formatter variant', () {
    testWidgets('shows the formatted target after settling', (tester) async {
      await tester.pumpWidget(
        _frame(
          child: NumberTicker(
            number: 42,
            duration: Duration.zero,
            formatter: (value) => value.toStringAsFixed(0),
          ),
        ),
      );
      await tester.pump();
      expect(find.text('42'), findsOneWidget);
    });

    testWidgets('animates from the initial number', (tester) async {
      await tester.pumpWidget(
        _frame(
          child: NumberTicker(
            initialNumber: 0,
            number: 100,
            duration: const Duration(milliseconds: 200),
            formatter: (value) => value.toStringAsFixed(0),
          ),
        ),
      );
      await tester.pump();
      expect(find.text('100'), findsNothing);
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.text('100'), findsOneWidget);
    });

    testWidgets('follows target changes', (tester) async {
      await tester.pumpWidget(
        _frame(
          child: NumberTicker(
            number: 10,
            duration: Duration.zero,
            formatter: (value) => 'n=${value.toStringAsFixed(0)}',
          ),
        ),
      );
      await tester.pump();
      expect(find.text('n=10'), findsOneWidget);
      await tester.pumpWidget(
        _frame(
          child: NumberTicker(
            number: 20,
            duration: Duration.zero,
            formatter: (value) => 'n=${value.toStringAsFixed(0)}',
          ),
        ),
      );
      await tester.pump();
      expect(find.text('n=20'), findsOneWidget);
    });

    testWidgets('intl compact formatter integrates', (tester) async {
      await tester.pumpWidget(
        _frame(
          child: NumberTicker(
            number: 1500,
            duration: Duration.zero,
            formatter: (value) => intl.NumberFormat.compact().format(value),
          ),
        ),
      );
      await tester.pump();
      expect(find.text('1.5K'), findsOneWidget);
    });
  });

  group('builder variant', () {
    testWidgets('builds custom content with the animated value', (
      tester,
    ) async {
      await tester.pumpWidget(
        _frame(
          child: NumberTicker.builder(
            number: 7,
            duration: Duration.zero,
            builder: (context, value, _) =>
                Text('score ${value.toStringAsFixed(0)}'),
          ),
        ),
      );
      await tester.pump();
      expect(find.text('score 7'), findsOneWidget);
    });

    testWidgets('passes the child through', (tester) async {
      await tester.pumpWidget(
        _frame(
          child: NumberTicker.builder(
            number: 7,
            duration: Duration.zero,
            child: const Text('static'),
            builder: (context, value, child) => Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[Text('$value'), child!],
            ),
          ),
        ),
      );
      await tester.pump();
      expect(find.text('static'), findsOneWidget);
    });
  });

  group('flip clock', () {
    testWidgets('text flipper renders every character', (tester) async {
      await tester.pumpWidget(
        _frame(
          child: const TextFlipper(
            charset: FlipperCharset.numbers,
            text: '123',
            duration: Duration.zero,
          ),
        ),
      );
      await tester.pump();
      expect(find.byType(FlipperCharacter), findsNWidgets(3));
    });

    testWidgets('charset concatenation and equality', (tester) async {
      expect(
        FlipperCharset.numbers + FlipperCharset.uppercase,
        FlipperCharset('0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ'),
      );
      expect(FlipperCharset.numbers, isNot(FlipperCharset.symbols));
    });
  });

  group('theme precedence', () {
    testWidgets('widget > scoped > app > defaults', (tester) async {
      NumberTickerTheme resolve(
        BuildContext context,
        NumberTickerTheme? widget,
      ) {
        return resolveComponentStyle<NumberTickerTheme, NumberTickerTheme>(
          context,
          widget: widget,
          select: (t) => t,
          defaults: numberTickerDefaults,
        );
      }

      NumberTickerTheme? seen;
      Future<void> pump({
        NumberTickerTheme? widget,
        NumberTickerTheme? scoped,
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

      const Duration d500 = Duration(milliseconds: 500);
      await pump();
      expect(seen!.duration, d500);
      await pump(
        app: const <ComponentThemeData>[
          NumberTickerTheme(duration: Duration(milliseconds: 100)),
        ],
      );
      expect(seen!.duration, const Duration(milliseconds: 100));
      await pump(
        scoped: const NumberTickerTheme(duration: Duration(milliseconds: 200)),
        app: const <ComponentThemeData>[
          NumberTickerTheme(duration: Duration(milliseconds: 100)),
        ],
      );
      expect(seen!.duration, const Duration(milliseconds: 200));
      await pump(
        widget: const NumberTickerTheme(duration: Duration(milliseconds: 300)),
        scoped: const NumberTickerTheme(duration: Duration(milliseconds: 200)),
        app: const <ComponentThemeData>[
          NumberTickerTheme(duration: Duration(milliseconds: 100)),
        ],
      );
      expect(seen!.duration, const Duration(milliseconds: 300));
    });

    testWidgets('widget style reaches the text', (tester) async {
      const TextStyle style = TextStyle(fontSize: 31);
      await tester.pumpWidget(
        _frame(
          child: NumberTicker(
            number: 5,
            duration: Duration.zero,
            style: style,
            formatter: (value) => 'x',
          ),
        ),
      );
      await tester.pump();
      expect(tester.widget<Text>(find.text('x')).style?.fontSize, 31);
    });
  });
}
