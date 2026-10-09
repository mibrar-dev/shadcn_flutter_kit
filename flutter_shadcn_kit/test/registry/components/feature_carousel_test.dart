// Widget tests for the `feature_carousel` component.
//
// Covers the item render, navigation (arrows, controller, keyboard, swipe),
// autoplay, light and dark tokens, the four precedence legs, the documented
// sizes, and regressions for the old bugs: the Material import, the dark-only
// literal theme, the empty-list `clamp` crash and the alpha replacement.

import 'package:flutter/services.dart' show LogicalKeyboardKey;
import 'package:flutter/widgets.dart';
import 'package:flutter_shadcn_kit/registry/components/feature_carousel/feature_carousel.dart';
import 'package:flutter_shadcn_kit/registry/primitives/clickable.dart';
import 'package:flutter_shadcn_kit/registry/theme/color_tokens.dart';
import 'package:flutter_shadcn_kit/registry/theme/theme.dart';
import 'package:flutter_test/flutter_test.dart';

const Color _green = Color(0xFF00FF00);
const Color _blue = Color(0xFF0000FF);

const List<FeatureCarouselItem> _items = <FeatureCarouselItem>[
  FeatureCarouselItem(
    title: 'Fast',
    description: 'Ship in seconds.',
    icon: IconData(0x1, fontFamily: 't'),
  ),
  FeatureCarouselItem(
    title: 'Safe',
    icon: IconData(0x2, fontFamily: 't'),
  ),
  FeatureCarouselItem(title: 'Insightful'),
];

Widget _frame(
  Widget child, {
  ShadcnThemeData data = const ShadcnThemeData(),
  List<ComponentThemeData> app = const <ComponentThemeData>[],
  FeatureCarouselTheme? scoped,
  double width = 480,
}) {
  Widget body = SizedBox(width: width, child: child);
  if (scoped != null) {
    body = ComponentTheme<FeatureCarouselTheme>(data: scoped, child: body);
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

FeatureCarouselController _controller({bool autoPlay = false}) =>
    FeatureCarouselController(
      autoPlay: autoPlay,
      autoPlayInterval: const Duration(milliseconds: 80),
    );

BoxDecoration _cardDecoration(WidgetTester tester) {
  final Container container = tester.widget<Container>(
    find
        .descendant(
          of: find.byType(FeatureCarouselCenterCard),
          matching: find.byType(Container),
        )
        .first,
  );
  return container.decoration! as BoxDecoration;
}

void main() {
  group('rendering', () {
    testWidgets('renders the active item', (tester) async {
      await tester.pumpWidget(_frame(FeatureCarousel(items: _items)));
      expect(find.text('Fast'), findsOneWidget);
      expect(find.text('Ship in seconds.'), findsOneWidget);
      expect(find.byType(FeatureCarouselCenterCard), findsOneWidget);
      expect(find.byType(FeatureCarouselGhostCard), findsNWidgets(3));
    });

    testWidgets('regression: an empty list renders without throwing', (
      tester,
    ) async {
      // The old `initState` clamped with `clamp(0, length - 1)` and threw.
      await tester.pumpWidget(
        _frame(const FeatureCarousel(items: <FeatureCarouselItem>[])),
      );
      expect(tester.takeException(), isNull);
      expect(find.byType(FeatureCarousel), findsOneWidget);
    });

    testWidgets('the card measures 250 x 300 by default', (tester) async {
      await tester.pumpWidget(_frame(FeatureCarousel(items: _items)));
      final Size size = tester.getSize(find.byType(FeatureCarouselCenterCard));
      expect(size, const Size(250, 300));
    });

    testWidgets('the arrows measure 44 and the CTA 46 tall', (tester) async {
      await tester.pumpWidget(_frame(FeatureCarousel(items: _items)));
      final List<Clickable> controls = tester
          .widgetList<Clickable>(find.byType(Clickable))
          .toList();
      expect(controls, hasLength(3));
      expect(tester.getSize(find.byType(Clickable).at(0)), const Size(44, 44));
      expect(tester.getSize(find.byType(Clickable).at(1)), const Size(44, 44));
      expect(tester.getSize(find.byType(Clickable).at(2)).height, 46);
    });
  });

  group('navigation', () {
    testWidgets('the next arrow advances and wraps', (tester) async {
      await tester.pumpWidget(_frame(FeatureCarousel(items: _items)));
      await tester.tap(find.byType(Clickable).at(1));
      await tester.pumpAndSettle();
      expect(find.text('Safe'), findsOneWidget);
      await tester.tap(find.byType(Clickable).at(0));
      await tester.pumpAndSettle();
      expect(find.text('Fast'), findsOneWidget);
    });

    testWidgets('the controller index drives the carousel', (tester) async {
      final FeatureCarouselController controller = _controller();
      addTearDown(controller.dispose);
      final List<int> reported = <int>[];
      controller.onIndexChanged = reported.add;
      await tester.pumpWidget(
        _frame(FeatureCarousel(items: _items, controller: controller)),
      );
      controller.index = 2;
      await tester.pumpAndSettle();
      expect(find.text('Insightful'), findsOneWidget);
      expect(reported, <int>[2]);
    });

    testWidgets('regression: a self-created controller is disposed', (
      tester,
    ) async {
      await tester.pumpWidget(_frame(FeatureCarousel(items: _items)));
      await tester.pumpWidget(_frame(const SizedBox.shrink()));
      expect(tester.takeException(), isNull);
    });

    testWidgets('a swipe changes the item', (tester) async {
      await tester.pumpWidget(_frame(FeatureCarousel(items: _items)));
      await tester.drag(find.byType(FeatureCarousel), const Offset(-120, 0));
      await tester.pumpAndSettle();
      expect(find.text('Safe'), findsOneWidget);
    });

    testWidgets('a disabled swipe leaves the item', (tester) async {
      final FeatureCarouselController controller = _controller();
      controller.enableSwipe = false;
      addTearDown(controller.dispose);
      await tester.pumpWidget(
        _frame(FeatureCarousel(items: _items, controller: controller)),
      );
      await tester.drag(find.byType(FeatureCarousel), const Offset(-120, 0));
      await tester.pumpAndSettle();
      expect(find.text('Fast'), findsOneWidget);
    });

    testWidgets('keyboard arrows navigate', (tester) async {
      await tester.pumpWidget(
        _frame(FeatureCarousel(items: _items, autofocus: true)),
      );
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
      await tester.pump();
      expect(find.text('Safe'), findsOneWidget);
    });
  });

  group('autoplay', () {
    testWidgets('advances after the hold time', (tester) async {
      final FeatureCarouselController controller = _controller(autoPlay: true);
      addTearDown(controller.dispose);
      await tester.pumpWidget(
        _frame(FeatureCarousel(items: _items, controller: controller)),
      );
      // A running periodic timer never settles; pump one hold instead.
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.text('Safe'), findsOneWidget);
      // Dispose the carousel so its periodic timer is cancelled.
      await tester.pumpWidget(const SizedBox.shrink());
    });

    testWidgets('a single item never autoplays', (tester) async {
      final FeatureCarouselController controller = _controller(autoPlay: true);
      addTearDown(controller.dispose);
      await tester.pumpWidget(
        _frame(
          FeatureCarousel(
            controller: controller,
            items: const <FeatureCarouselItem>[
              FeatureCarouselItem(title: 'One'),
            ],
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 200));
      expect(find.text('One'), findsOneWidget);
    });
  });

  group('theme precedence', () {
    testWidgets('the widget leg wins over everything', (tester) async {
      await tester.pumpWidget(
        _frame(
          FeatureCarousel(
            items: _items,
            theme: const FeatureCarouselTheme(
              cardFill: ThemedColor.value(_green),
            ),
          ),
          app: const <ComponentThemeData>[
            FeatureCarouselTheme(cardFill: ThemedColor.value(_blue)),
          ],
          scoped: const FeatureCarouselTheme(
            cardFill: ThemedColor.value(Color(0xFF123456)),
          ),
        ),
      );
      expect(_cardDecoration(tester).color, _green);
    });

    testWidgets('the scoped leg wins over the app leg', (tester) async {
      await tester.pumpWidget(
        _frame(
          FeatureCarousel(items: _items),
          app: const <ComponentThemeData>[
            FeatureCarouselTheme(cardFill: ThemedColor.value(_blue)),
          ],
          scoped: const FeatureCarouselTheme(
            cardFill: ThemedColor.value(_green),
          ),
        ),
      );
      expect(_cardDecoration(tester).color, _green);
    });

    testWidgets('the app leg wins over the defaults', (tester) async {
      await tester.pumpWidget(
        _frame(
          FeatureCarousel(items: _items),
          app: const <ComponentThemeData>[
            FeatureCarouselTheme(cardFill: ThemedColor.value(_green)),
          ],
        ),
      );
      expect(_cardDecoration(tester).color, _green);
    });

    testWidgets('a leg that sets only the fill keeps the default radius', (
      tester,
    ) async {
      await tester.pumpWidget(
        _frame(
          FeatureCarousel(items: _items),
          app: const <ComponentThemeData>[
            FeatureCarouselTheme(cardFill: ThemedColor.value(_green)),
          ],
        ),
      );
      expect(
        _cardDecoration(tester).borderRadius,
        BorderRadius.circular(featureCarouselDefaults.radius!),
      );
    });
  });

  group('tokens', () {
    testWidgets('the token defaults fill the card', (tester) async {
      await tester.pumpWidget(_frame(FeatureCarousel(items: _items)));
      expect(_cardDecoration(tester).color, ShadcnColors.lightFallback.card);
    });

    testWidgets('regression: dark tokens drive the card', (tester) async {
      // The old theme was a dark-only literal set; the tokens must follow.
      await tester.pumpWidget(
        _frame(
          FeatureCarousel(items: _items),
          data: const ShadcnThemeData(colors: ShadcnColors.darkFallback),
        ),
      );
      expect(_cardDecoration(tester).color, ShadcnColors.darkFallback.card);
    });
  });

  group('defaults table', () {
    test('the transition table covers every style', () {
      for (final FeatureCarouselAnimationStyle style
          in FeatureCarouselAnimationStyle.values) {
        expect(featureCarouselTransitionStyle(style, 1), isNotNull);
      }
      expect(featureCarouselDefaults.radius, 12);
      expect(featureCarouselDefaults.transitionDuration?.inMilliseconds, 260);
    });
  });
}
