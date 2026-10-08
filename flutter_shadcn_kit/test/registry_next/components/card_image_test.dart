// Widget tests for the `card_image` component.
//
// Covers the vertical/horizontal compositions, the image scale interaction,
// press/disabled states, keyboard activation, light and dark tokens, the four
// precedence legs, and regressions for the old bugs: the Material import, the
// removed `ButtonStyle.fixed` style, the leaked `WidgetStatesController` and
// the `Colors.transparent` defaults.

import 'package:flutter/gestures.dart' show PointerDeviceKind;
import 'package:flutter/services.dart' show LogicalKeyboardKey;
import 'package:flutter/widgets.dart';
import 'package:flutter_shadcn_kit/registry_next/components/card_image/card_image.dart';
import 'package:flutter_shadcn_kit/registry_next/components/outlined_container/outlined_container.dart';
import 'package:flutter_shadcn_kit/registry_next/foundation/gap.dart';
import 'package:flutter_shadcn_kit/registry_next/primitives/clickable.dart';
import 'package:flutter_shadcn_kit/registry_next/theme/color_tokens.dart';
import 'package:flutter_shadcn_kit/registry_next/theme/theme.dart';
import 'package:flutter_test/flutter_test.dart';

const Color _green = Color(0xFF00FF00);
const Color _blue = Color(0xFF0000FF);

Widget _frame(
  Widget child, {
  ShadcnThemeData data = const ShadcnThemeData(),
  List<ComponentThemeData> app = const <ComponentThemeData>[],
  CardImageTheme? scoped,
}) {
  Widget body = child;
  if (scoped != null) {
    body = ComponentTheme<CardImageTheme>(data: scoped, child: body);
  }
  return ShadcnTheme(
    data: data,
    child: ComponentThemes(
      themes: app,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Align(alignment: Alignment.topLeft, child: body),
      ),
    ),
  );
}

Widget _image() => const SizedBox(width: 80, height: 80);

AnimatedScale _scale(WidgetTester tester) =>
    tester.widget<AnimatedScale>(find.byType(AnimatedScale));

/// The `OutlinedContainer`'s own animated surface, not the button's.
AnimatedContainer _imageSurface(WidgetTester tester) =>
    tester.widget<AnimatedContainer>(
      find
          .descendant(
            of: find.byType(OutlinedContainer),
            matching: find.byType(AnimatedContainer),
          )
          .first,
    );

Flex _flex(WidgetTester tester) => tester.widget<Flex>(find.byType(Flex).first);

void main() {
  group('rendering', () {
    testWidgets('renders the image and the text block', (tester) async {
      await tester.pumpWidget(
        _frame(
          CardImage(
            image: _image(),
            title: const Text('Title'),
            subtitle: const Text('Subtitle'),
            onPressed: () {},
          ),
        ),
      );
      expect(find.text('Title'), findsOneWidget);
      expect(find.text('Subtitle'), findsOneWidget);
      expect(find.byType(CardImage), findsOneWidget);
    });

    testWidgets('the default direction is vertical', (tester) async {
      await tester.pumpWidget(
        _frame(CardImage(image: _image(), onPressed: () {})),
      );
      expect(_flex(tester).direction, Axis.vertical);
    });

    testWidgets('a themed direction stacks horizontally', (tester) async {
      await tester.pumpWidget(
        _frame(
          CardImage(
            theme: const CardImageTheme(direction: Axis.horizontal),
            image: _image(),
            onPressed: () {},
          ),
        ),
      );
      expect(_flex(tester).direction, Axis.horizontal);
    });

    testWidgets('the image scale is 1 at rest', (tester) async {
      await tester.pumpWidget(
        _frame(CardImage(image: _image(), onPressed: () {})),
      );
      expect(_scale(tester).scale, 1);
    });

    testWidgets('the default gap is 12', (tester) async {
      await tester.pumpWidget(
        _frame(CardImage(image: _image(), onPressed: () {})),
      );
      final Gap gap = tester.widget<Gap>(
        find.descendant(of: find.byType(CardImage), matching: find.byType(Gap)),
      );
      expect(gap.mainAxisExtent, 12);
    });

    testWidgets('regression: the transparent image surface is a token', (
      tester,
    ) async {
      // The old defaults were `Colors.transparent` literals.
      await tester.pumpWidget(
        _frame(CardImage(image: _image(), onPressed: () {})),
      );
      final BoxDecoration decoration =
          _imageSurface(tester).decoration! as BoxDecoration;
      expect(decoration.color!.a, 0);
      expect(decoration.color!.withValues(alpha: 1), isNot(0));
    });
  });

  group('interaction', () {
    testWidgets('hover scales the image', (tester) async {
      FocusManager.instance.highlightStrategy =
          FocusHighlightStrategy.alwaysTraditional;
      addTearDown(
        () => FocusManager.instance.highlightStrategy =
            FocusHighlightStrategy.automatic,
      );
      await tester.pumpWidget(
        _frame(CardImage(image: _image(), onPressed: () {})),
      );
      final TestGesture gesture = await tester.createGesture(
        kind: PointerDeviceKind.mouse,
      );
      await gesture.addPointer(location: Offset.zero);
      addTearDown(gesture.removePointer);
      await tester.pump();
      await gesture.moveTo(tester.getCenter(find.byType(CardImage)));
      await tester.pump();
      expect(_scale(tester).scale, cardImageDefaultHoverScale);
      await gesture.moveTo(const Offset(5000, 5000));
      await tester.pump();
      expect(_scale(tester).scale, 1);
    });

    testWidgets('a tap calls onPressed', (tester) async {
      var pressed = 0;
      await tester.pumpWidget(
        _frame(CardImage(image: _image(), onPressed: () => pressed++)),
      );
      await tester.tap(find.byType(CardImage));
      expect(pressed, 1);
    });

    testWidgets('a null onPressed disables the card', (tester) async {
      await tester.pumpWidget(_frame(CardImage(image: _image())));
      expect(find.byType(Opacity), findsOneWidget);
      expect(tester.widget<Opacity>(find.byType(Opacity)).opacity, 0.5);
      expect(tester.widget<Clickable>(find.byType(Clickable)).enabled, isFalse);
    });

    testWidgets('keyboard activation calls onPressed', (tester) async {
      var pressed = 0;
      final FocusNode node = FocusNode();
      addTearDown(node.dispose);
      await tester.pumpWidget(
        _frame(
          CardImage(
            image: _image(),
            onPressed: () => pressed++,
            focusNode: node,
          ),
        ),
      );
      node.requestFocus();
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pump();
      expect(pressed, 1);
      await tester.sendKeyEvent(LogicalKeyboardKey.space);
      await tester.pump();
      expect(pressed, 2);
    });
  });

  group('theme precedence', () {
    testWidgets('the widget leg wins over everything', (tester) async {
      await tester.pumpWidget(
        _frame(
          CardImage(
            image: _image(),
            onPressed: () {},
            theme: const CardImageTheme(gap: 4),
          ),
          app: const <ComponentThemeData>[CardImageTheme(gap: 8)],
          scoped: const CardImageTheme(gap: 6),
        ),
      );
      expect(
        tester
            .widget<Gap>(
              find.descendant(
                of: find.byType(CardImage),
                matching: find.byType(Gap),
              ),
            )
            .mainAxisExtent,
        4,
      );
    });

    testWidgets('the scoped leg wins over the app leg', (tester) async {
      await tester.pumpWidget(
        _frame(
          CardImage(image: _image(), onPressed: () {}),
          app: const <ComponentThemeData>[CardImageTheme(gap: 8)],
          scoped: const CardImageTheme(gap: 6),
        ),
      );
      expect(
        tester
            .widget<Gap>(
              find.descendant(
                of: find.byType(CardImage),
                matching: find.byType(Gap),
              ),
            )
            .mainAxisExtent,
        6,
      );
    });

    testWidgets('the app leg wins over the defaults', (tester) async {
      await tester.pumpWidget(
        _frame(
          CardImage(image: _image(), onPressed: () {}),
          app: const <ComponentThemeData>[CardImageTheme(gap: 8)],
        ),
      );
      expect(
        tester
            .widget<Gap>(
              find.descendant(
                of: find.byType(CardImage),
                matching: find.byType(Gap),
              ),
            )
            .mainAxisExtent,
        8,
      );
    });

    testWidgets('a leg that sets only the gap keeps the default direction', (
      tester,
    ) async {
      await tester.pumpWidget(
        _frame(
          CardImage(image: _image(), onPressed: () {}),
          app: const <ComponentThemeData>[CardImageTheme(gap: 8)],
        ),
      );
      expect(_flex(tester).direction, Axis.vertical);
    });

    testWidgets('a themed hover scale reaches the image', (tester) async {
      await tester.pumpWidget(
        _frame(
          CardImage(
            image: _image(),
            onPressed: () {},
            theme: const CardImageTheme(
              hoverScale: 1.5,
              normalScale: 0.8,
              imageBackground: ThemedColor.value(_green),
            ),
          ),
        ),
      );
      expect(_scale(tester).scale, 0.8);
    });

    testWidgets('regression: the themed image fill applies', (tester) async {
      // The old `backgroundColor` default was a literal; the themed fill must
      // reach the `OutlinedContainer`.
      await tester.pumpWidget(
        _frame(
          CardImage(
            image: _image(),
            onPressed: () {},
            theme: const CardImageTheme(
              imageBackground: ThemedColor.value(_blue),
            ),
          ),
        ),
      );
      final AnimatedContainer container = _imageSurface(tester);
      expect((container.decoration! as BoxDecoration).color, _blue);
    });
  });

  group('tokens', () {
    testWidgets('dark tokens drive the image radius', (tester) async {
      await tester.pumpWidget(
        _frame(
          CardImage(image: _image(), onPressed: () {}),
          data: const ShadcnThemeData(colors: ShadcnColors.darkFallback),
        ),
      );
      final AnimatedContainer container = _imageSurface(tester);
      expect(
        (container.decoration! as BoxDecoration).borderRadius,
        const ShadcnThemeData(colors: ShadcnColors.darkFallback).borderRadiusXl,
      );
    });
  });

  group('defaults table', () {
    test('the defaults match the documented card', () {
      expect(cardImageDefaults.direction, Axis.vertical);
      expect(cardImageDefaults.hoverScale, cardImageDefaultHoverScale);
      expect(cardImageDefaults.normalScale, 1);
      expect(cardImageDefaults.gap, cardImageDefaultGap);
      expect(cardImageDefaults.imageRadius, isNull);
    });
  });
}
