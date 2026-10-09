// Widget tests for the `card` component.
//
// Covers the surface tokens, the shadcn slot composition, clipping, the sheet
// overlay branch, dark tokens and the four theme-precedence legs. The
// regression tests pin the two deletions the batch asked for: `CardButton` is
// gone (a pressable card is `Card(child: Clickable(...))`) and the old
// `filled` switch — which silently painted the *border* token as the fill — no
// longer exists, so the fill is always the `card` token unless overridden.

import 'package:flutter/widgets.dart';
import 'package:flutter_shadcn_kit/registry/components/card/card.dart';
import 'package:flutter_shadcn_kit/registry/foundation/data.dart';
import 'package:flutter_shadcn_kit/registry/primitives/clickable.dart';
import 'package:flutter_shadcn_kit/registry/primitives/sheet_overlay.dart';
import 'package:flutter_shadcn_kit/registry/theme/color_tokens.dart';
import 'package:flutter_shadcn_kit/registry/theme/theme.dart';
import 'package:flutter_test/flutter_test.dart';

const Color _green = Color(0xFF00FF00);
const Color _blue = Color(0xFF0000FF);

Widget _frame({
  required Widget child,
  ShadcnThemeData data = const ShadcnThemeData(),
  List<ComponentThemeData> app = const <ComponentThemeData>[],
  CardTheme? scopedTheme,
  bool inSheetOverlay = false,
}) {
  Widget body = child;
  if (scopedTheme != null) {
    body = ComponentTheme<CardTheme>(data: scopedTheme, child: body);
  }
  if (inSheetOverlay) {
    body = Data<SheetOverlayMarker>.inherit(
      data: const SheetOverlayMarker(),
      child: body,
    );
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

BoxDecoration _decoration(WidgetTester tester) {
  return tester
          .widget<DecoratedBox>(
            find.descendant(
              of: find.byType(Card),
              matching: find.byType(DecoratedBox),
            ),
          )
          .decoration
      as BoxDecoration;
}

void main() {
  group('surface', () {
    testWidgets('uses card / cardForeground / border tokens', (tester) async {
      final ShadcnColors colors = ShadcnColors.lightFallback;
      await tester.pumpWidget(_frame(child: const Card(child: Text('Body'))));
      final BoxDecoration decoration = _decoration(tester);
      expect(decoration.color, colors.card);
      expect(decoration.border, Border.all(color: colors.border, width: 1));
      expect(decoration.boxShadow, isNotNull);
    });

    testWidgets('corner radius resolves the ambient radiusXl', (tester) async {
      await tester.pumpWidget(_frame(child: const Card(child: Text('Body'))));
      final ShadcnThemeData theme = ShadcnTheme.of(
        tester.element(find.byType(Card)),
      );
      expect(_decoration(tester).borderRadius, theme.borderRadiusXl);
    });

    testWidgets('padding defaults to 24', (tester) async {
      await tester.pumpWidget(_frame(child: const Card(child: Text('Body'))));
      final Padding padding = tester.widget<Padding>(
        find.descendant(of: find.byType(Card), matching: find.byType(Padding)),
      );
      expect(padding.padding, cardDefaultPadding);
    });

    testWidgets('widget overrides win over the theme', (tester) async {
      await tester.pumpWidget(
        _frame(
          child: const Card(
            padding: EdgeInsets.all(4),
            background: ThemedColor.value(_green),
            borderWidth: 0,
            shadows: <BoxShadow>[],
            child: Text('Body'),
          ),
        ),
      );
      final BoxDecoration decoration = _decoration(tester);
      expect(decoration.color, _green);
      expect(decoration.border, isNull);
      expect(decoration.boxShadow, isNull);
      final Padding padding = tester.widget<Padding>(
        find.descendant(of: find.byType(Card), matching: find.byType(Padding)),
      );
      expect(padding.padding, const EdgeInsets.all(4));
    });

    testWidgets('clipBehavior none does not clip', (tester) async {
      await tester.pumpWidget(_frame(child: const Card(child: Text('Body'))));
      expect(find.byType(ClipRRect), findsNothing);
    });

    testWidgets('clipBehavior antiAlias clips to the radius', (tester) async {
      await tester.pumpWidget(
        _frame(
          child: const Card(clipBehavior: Clip.antiAlias, child: Text('Body')),
        ),
      );
      expect(find.byType(ClipRRect), findsOneWidget);
    });
  });

  group('slots', () {
    testWidgets('renders the shadcn header/title/description composition', (
      tester,
    ) async {
      await tester.pumpWidget(
        _frame(
          child: const Card(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                CardHeader(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      CardTitle(child: Text('Title')),
                      CardDescription(child: Text('Description')),
                    ],
                  ),
                ),
                CardContent(child: Text('Content')),
                CardFooter(child: Text('Footer')),
              ],
            ),
          ),
        ),
      );
      expect(find.text('Title'), findsOneWidget);
      expect(find.text('Description'), findsOneWidget);
      expect(find.text('Content'), findsOneWidget);
      expect(find.text('Footer'), findsOneWidget);
    });

    testWidgets('title uses cardForeground, description mutedForeground', (
      tester,
    ) async {
      await tester.pumpWidget(
        _frame(
          child: const Card(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                CardTitle(child: Text('Title')),
                CardDescription(child: Text('Description')),
              ],
            ),
          ),
        ),
      );
      TextStyle styleOf(String text) => tester
          .widgetList<DefaultTextStyle>(
            find.ancestor(
              of: find.text(text),
              matching: find.byType(DefaultTextStyle),
            ),
          )
          .first
          .style;
      final ShadcnColors colors = ShadcnColors.lightFallback;
      expect(styleOf('Title').color, colors.cardForeground);
      expect(styleOf('Title').fontWeight, FontWeight.w600);
      expect(styleOf('Description').color, colors.mutedForeground);
    });

    testWidgets('CardFooter aligns to the end by default', (tester) async {
      await tester.pumpWidget(
        _frame(
          child: const Card(child: CardFooter(child: Text('Footer'))),
        ),
      );
      expect(
        tester
            .widget<Row>(
              find.descendant(
                of: find.byType(CardFooter),
                matching: find.byType(Row),
              ),
            )
            .mainAxisAlignment,
        MainAxisAlignment.end,
      );
    });
  });

  group('sheet overlay', () {
    testWidgets('renders padding only inside a sheet overlay', (tester) async {
      await tester.pumpWidget(
        _frame(inSheetOverlay: true, child: const Card(child: Text('Body'))),
      );
      expect(
        find.descendant(
          of: find.byType(Card),
          matching: find.byType(DecoratedBox),
        ),
        findsNothing,
      );
      expect(find.text('Body'), findsOneWidget);
    });

    testWidgets('renders the full surface outside a sheet overlay', (
      tester,
    ) async {
      await tester.pumpWidget(_frame(child: const Card(child: Text('Body'))));
      expect(
        find.descendant(
          of: find.byType(Card),
          matching: find.byType(DecoratedBox),
        ),
        findsOneWidget,
      );
    });
  });

  group('interaction', () {
    testWidgets('regression: a pressable card is Card + Clickable', (
      tester,
    ) async {
      int taps = 0;
      await tester.pumpWidget(
        _frame(
          child: Card(
            child: Clickable(onPressed: () => taps++, child: const Text('Tap')),
          ),
        ),
      );
      await tester.tap(find.text('Tap'));
      expect(taps, 1);
    });
  });

  group('theme precedence', () {
    testWidgets('app leg overrides the defaults', (tester) async {
      await tester.pumpWidget(
        _frame(
          app: const <ComponentThemeData>[
            CardTheme(background: ThemedColor.value(_green)),
          ],
          child: const Card(child: Text('Body')),
        ),
      );
      expect(_decoration(tester).color, _green);
    });

    testWidgets('scoped leg overrides the app leg', (tester) async {
      await tester.pumpWidget(
        _frame(
          app: const <ComponentThemeData>[
            CardTheme(background: ThemedColor.value(_green)),
          ],
          scopedTheme: const CardTheme(background: ThemedColor.value(_blue)),
          child: const Card(child: Text('Body')),
        ),
      );
      expect(_decoration(tester).color, _blue);
    });

    testWidgets('widget leg overrides the scoped leg', (tester) async {
      await tester.pumpWidget(
        _frame(
          scopedTheme: const CardTheme(background: ThemedColor.value(_green)),
          child: const Card(
            theme: CardTheme(background: ThemedColor.value(_blue)),
            child: Text('Body'),
          ),
        ),
      );
      expect(_decoration(tester).color, _blue);
    });

    testWidgets('a leg setting only padding keeps the token fill', (
      tester,
    ) async {
      await tester.pumpWidget(
        _frame(
          scopedTheme: const CardTheme(padding: EdgeInsets.all(4)),
          child: const Card(child: Text('Body')),
        ),
      );
      expect(_decoration(tester).color, ShadcnColors.lightFallback.card);
      final Padding padding = tester.widget<Padding>(
        find.descendant(of: find.byType(Card), matching: find.byType(Padding)),
      );
      expect(padding.padding, const EdgeInsets.all(4));
    });
  });

  group('tokens', () {
    testWidgets('dark palette drives the same slots', (tester) async {
      const ShadcnColors dark = ShadcnColors.darkFallback;
      await tester.pumpWidget(
        _frame(
          data: const ShadcnThemeData(colors: dark),
          child: const Card(child: Text('Body')),
        ),
      );
      final BoxDecoration decoration = _decoration(tester);
      expect(decoration.color, dark.card);
      expect(decoration.border, Border.all(color: dark.border, width: 1));
    });

    testWidgets('alpha multiplies the token alpha', (tester) async {
      const ShadcnColors dark = ShadcnColors.darkFallback;
      await tester.pumpWidget(
        _frame(
          data: const ShadcnThemeData(colors: dark),
          child: const Card(
            background: ThemedColor.ref(ColorRef.card, alpha: 0.5),
            child: Text('Body'),
          ),
        ),
      );
      expect(_decoration(tester).color!.a, closeTo(dark.card.a * 0.5, 0.001));
    });
  });
}
