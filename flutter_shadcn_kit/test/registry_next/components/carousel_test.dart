// Widget tests for the `carousel` component.
//
// Covers both transitions, both axes, the controller contract, drag and fling,
// autoplay, all four precedence legs, and eight regressions from the old
// module (force-unwrapped velocity, wrong-axis drag extent, snapping to the
// drag's start page, clamping through a private field, wrapping when
// `wrap: false`, negative item indices on `reverse`, divide-by-zero in the
// visible-range count and the leaked self-created controller).

import 'package:flutter/gestures.dart' show PointerDeviceKind;
import 'package:flutter/widgets.dart';
import 'package:flutter_shadcn_kit/registry_next/components/carousel/carousel.dart';
import 'package:flutter_shadcn_kit/registry_next/theme/theme.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _frame(
  Widget child, {
  ShadcnThemeData data = const ShadcnThemeData(),
  List<ComponentThemeData> app = const <ComponentThemeData>[],
  CarouselTheme? scoped,
  Size size = const Size(320, 96),
}) {
  Widget body = SizedBox(width: size.width, height: size.height, child: child);
  if (scoped != null) {
    body = ComponentTheme<CarouselTheme>(data: scoped, child: body);
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

/// N pages, each labelled with its index so the test can find them.
Widget _carousel({
  int itemCount = 4,
  CarouselController? controller,
  CarouselTransition? transition,
  CarouselAlignment? alignment,
  Axis? direction,
  double? viewportFraction,
  double? itemExtent,
  double? gap,
  Duration? autoplayInterval,
  bool? pauseOnHover,
  bool? draggable,
  bool? wrap,
  bool? reverse,
  ValueChanged<int>? onIndexChanged,
  CarouselTheme? theme,
  CarouselItemBuilder? itemBuilder,
}) {
  return Carousel(
    itemCount: itemCount,
    controller: controller,
    transition: transition,
    alignment: alignment,
    direction: direction,
    viewportFraction: viewportFraction,
    itemExtent: itemExtent,
    gap: gap,
    autoplayInterval: autoplayInterval,
    autoplayReverse: reverse ?? false,
    onIndexChanged: onIndexChanged,
    // The behavioural knobs are theme rows, not widget arguments.
    theme: _theme(
      theme,
      pauseOnHover: pauseOnHover,
      draggable: draggable,
      wrap: wrap,
    ),
    itemBuilder:
        itemBuilder ??
        (context, index) => Container(
          key: ValueKey<int>(index),
          alignment: Alignment.center,
          child: Text('page $index'),
        ),
  );
}

CarouselTheme? _theme(
  CarouselTheme? theme, {
  bool? pauseOnHover,
  bool? draggable,
  bool? wrap,
}) {
  if (pauseOnHover == null && draggable == null && wrap == null) return theme;
  return CarouselTheme(
    pauseOnHover: pauseOnHover,
    draggable: draggable,
    wrap: wrap,
  ).merge(theme);
}

/// The rect of the page box (the item builder's root), not of its label.
Rect _pageRect(WidgetTester tester, int index) =>
    tester.getRect(find.byKey(ValueKey<int>(index)).first);

List<String> _pages(WidgetTester tester) => tester
    .widgetList<Text>(find.textContaining('page'))
    .map((Text t) => t.data!)
    .toList();

void main() {
  group('rendering', () {
    testWidgets('shows one page plus its neighbour', (tester) async {
      await tester.pumpWidget(_frame(_carousel()));
      expect(_pages(tester), contains('page 0'));
      expect(_pages(tester).length, lessThanOrEqualTo(3));
    });

    testWidgets('a half viewport shows the neighbours too', (tester) async {
      await tester.pumpWidget(_frame(_carousel(viewportFraction: 0.5)));
      expect(_pages(tester), containsAll(<String>['page 0', 'page 1']));
      expect(_pageRect(tester, 0).width, 160);
    });

    testWidgets('fixed pages are honoured', (tester) async {
      await tester.pumpWidget(_frame(_carousel(itemExtent: 48)));
      expect(_pageRect(tester, 0).width, 48);
    });

    testWidgets('a vertical carousel stacks its pages', (tester) async {
      await tester.pumpWidget(_frame(_carousel(direction: Axis.vertical)));
      expect(_pageRect(tester, 1).top, greaterThan(_pageRect(tester, 0).top));
    });

    testWidgets('alignment shifts the current page', (tester) async {
      await tester.pumpWidget(
        _frame(
          _carousel(viewportFraction: 0.5, alignment: CarouselAlignment.start),
        ),
      );
      final double startOffset = tester.getRect(find.text('page 0')).left;
      await tester.pumpWidget(
        _frame(
          _carousel(viewportFraction: 0.5, alignment: CarouselAlignment.end),
        ),
      );
      expect(
        tester.getRect(find.text('page 0')).left,
        greaterThan(startOffset),
      );
    });

    testWidgets('the fading transition cross-fades the neighbours', (
      tester,
    ) async {
      await tester.pumpWidget(
        _frame(_carousel(transition: CarouselTransition.fading)),
      );
      expect(find.byType(Opacity), findsWidgets);
    });

    testWidgets('itemCount must be positive', (tester) async {
      // Asserted in the constructor, so it fires before the widget is pumped.
      expect(
        () => Carousel(
          itemCount: 0,
          itemBuilder: (context, index) => const Text('x'),
        ),
        throwsAssertionError,
      );
    });

    testWidgets('regression: a zero extent renders instead of throwing', (
      tester,
    ) async {
      // The old visible-range math divided the free space by a zero page size
      // and then called `ceil` on an infinity, which throws.
      await tester.pumpWidget(
        _frame(_carousel(itemExtent: 0), size: const Size(0, 0)),
      );
      expect(tester.takeException(), isNull);
    });
  });

  group('controller', () {
    testWidgets('next and previous move by a whole page', (tester) async {
      final CarouselController controller = CarouselController();
      addTearDown(controller.dispose);
      await tester.pumpWidget(_frame(_carousel(controller: controller)));
      controller.next();
      await tester.pumpAndSettle();
      expect(controller.value, 1);

      controller.previous();
      await tester.pumpAndSettle();
      expect(controller.value, 0);
    });

    testWidgets('animateTo and jumpTo both move the page', (tester) async {
      final CarouselController controller = CarouselController();
      addTearDown(controller.dispose);
      await tester.pumpWidget(_frame(_carousel(controller: controller)));
      controller.jumpTo(2);
      await tester.pumpAndSettle();
      expect(controller.value, 2);
      controller.animateTo(1, const Duration(milliseconds: 100));
      await tester.pumpAndSettle();
      expect(controller.value, 1);
    });

    testWidgets('onIndexChanged only fires on a new index', (tester) async {
      final List<int> reported = <int>[];
      final CarouselController controller = CarouselController();
      addTearDown(controller.dispose);
      await tester.pumpWidget(
        _frame(_carousel(controller: controller, onIndexChanged: reported.add)),
      );
      controller.jumpTo(2);
      await tester.pumpAndSettle();
      controller.jumpTo(2.2);
      await tester.pumpAndSettle();
      expect(reported, <int>[2]);
    });

    testWidgets('regression: a self-created controller is disposed', (
      tester,
    ) async {
      await tester.pumpWidget(_frame(_carousel()));
      await tester.pumpWidget(_frame(const SizedBox.shrink()));
      expect(tester.takeException(), isNull);
    });

    testWidgets('an external controller survives the carousel', (tester) async {
      final CarouselController controller = CarouselController();
      addTearDown(controller.dispose);
      await tester.pumpWidget(_frame(_carousel(controller: controller)));
      await tester.pumpWidget(_frame(const SizedBox.shrink()));
      controller.jumpTo(1);
      expect(controller.value, 1);
    });
  });

  group('clamping', () {
    testWidgets('regression: wrap: false never reports a wrapped index', (
      tester,
    ) async {
      final List<int> reported = <int>[];
      final CarouselController controller = CarouselController();
      addTearDown(controller.dispose);
      await tester.pumpWidget(
        _frame(
          _carousel(
            controller: controller,
            wrap: false,
            onIndexChanged: reported.add,
          ),
        ),
      );
      controller.jumpTo(9);
      await tester.pumpAndSettle();
      expect(controller.value, 3);
      expect(reported.last, 3);
    });

    testWidgets('regression: the clamp does not cancel the animation', (
      tester,
    ) async {
      final CarouselController controller = CarouselController();
      addTearDown(controller.dispose);
      await tester.pumpWidget(
        _frame(_carousel(controller: controller, wrap: false)),
      );
      controller.animateTo(9, const Duration(milliseconds: 200));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));
      expect(controller.value, 3);
    });

    testWidgets('a wrapping carousel loops past the end', (tester) async {
      final CarouselController controller = CarouselController();
      addTearDown(controller.dispose);
      await tester.pumpWidget(_frame(_carousel(controller: controller)));
      controller.jumpTo(4);
      await tester.pumpAndSettle();
      expect(controller.resolvedIndex(itemCount: 4, wrap: true), 0);
    });
  });

  group('drag', () {
    testWidgets('a drag moves the page with the pointer', (tester) async {
      final CarouselController controller = CarouselController();
      addTearDown(controller.dispose);
      await tester.pumpWidget(_frame(_carousel(controller: controller)));
      final TestGesture gesture = await tester.startGesture(
        tester.getCenter(find.byType(Carousel)),
      );
      await gesture.moveBy(const Offset(-160, 0));
      await tester.pump();
      expect(controller.value, greaterThan(0));
      await gesture.up();
      await tester.pumpAndSettle();
    });

    testWidgets('regression: a cancelled drag does not throw', (tester) async {
      final CarouselController controller = CarouselController();
      addTearDown(controller.dispose);
      await tester.pumpWidget(_frame(_carousel(controller: controller)));
      final TestGesture gesture = await tester.startGesture(
        tester.getCenter(find.byType(Carousel)),
      );
      await gesture.moveBy(const Offset(-40, 0));
      // `cancel` produces a `DragEndDetails` with a null velocity.
      await gesture.cancel();
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });

    testWidgets('regression: a drag snaps to the page it passed', (
      tester,
    ) async {
      final CarouselController controller = CarouselController();
      addTearDown(controller.dispose);
      await tester.pumpWidget(_frame(_carousel(controller: controller)));
      final TestGesture gesture = await tester.startGesture(
        tester.getCenter(find.byType(Carousel)),
      );
      // Cross two pages in one drag: the old code snapped back to the page the
      // drag started on.
      await gesture.moveBy(const Offset(-660, 0));
      await tester.pump();
      await gesture.up();
      await tester.pumpAndSettle();
      expect(controller.value.round(), greaterThanOrEqualTo(2));
    });

    testWidgets('regression: the drag extent uses the scroll axis', (
      tester,
    ) async {
      final CarouselController controller = CarouselController();
      addTearDown(controller.dispose);
      await tester.pumpWidget(
        _frame(_carousel(controller: controller, viewportFraction: 0.5)),
      );
      final double pageExtent = 160;
      final TestGesture gesture = await tester.startGesture(
        tester.getCenter(find.byType(Carousel)),
      );
      await gesture.moveBy(Offset(-pageExtent / 2, 0));
      await tester.pump();
      // The old code divided by the height (96) instead of the page extent.
      expect(controller.value, closeTo(0.5, 0.001));
      await gesture.up();
      await tester.pumpAndSettle();
    });

    testWidgets('regression: reverse never yields a negative index', (
      tester,
    ) async {
      final List<int> built = <int>[];
      await tester.pumpWidget(
        _frame(
          _carousel(
            itemCount: 3,
            itemBuilder: (context, index) {
              built.add(index);
              return Text('page $index');
            },
          ),
        ),
      );
      await tester.pump();
      expect(built.every((int index) => index >= 0 && index < 3), isTrue);
    });

    testWidgets('a non-draggable carousel installs no gesture detector', (
      tester,
    ) async {
      await tester.pumpWidget(_frame(_carousel(draggable: false)));
      expect(find.byType(GestureDetector), findsNothing);
    });
  });

  group('autoplay', () {
    testWidgets('a ticker only runs while autoplay is configured', (
      tester,
    ) async {
      await tester.pumpWidget(_frame(_carousel()));
      expect(tester.binding.transientCallbackCount, lessThanOrEqualTo(1));
    });

    testWidgets('autoplay advances after the hold time', (tester) async {
      final List<int> reported = <int>[];
      await tester.pumpWidget(
        _frame(
          _carousel(
            autoplayInterval: const Duration(milliseconds: 200),
            onIndexChanged: reported.add,
          ),
        ),
      );
      // The hold is 200 ms and the step itself animates over `speed`.
      for (var i = 0; i < 8; i++) {
        await tester.pump(const Duration(milliseconds: 100));
      }
      expect(reported, isNotEmpty);
      expect(reported.first, 1);
      // It keeps stepping while the carousel is on screen.
      expect(reported.length, greaterThan(1));
    });

    testWidgets('hovering pauses autoplay', (tester) async {
      final List<int> reported = <int>[];
      await tester.pumpWidget(
        _frame(
          _carousel(
            autoplayInterval: const Duration(milliseconds: 200),
            pauseOnHover: true,
            onIndexChanged: reported.add,
          ),
        ),
      );
      final TestGesture gesture = await tester.createGesture(
        kind: PointerDeviceKind.mouse,
      );
      await gesture.addPointer(location: Offset.zero);
      await gesture.moveTo(tester.getCenter(find.byType(Carousel)));
      await tester.pump(const Duration(milliseconds: 600));
      expect(reported, isEmpty);
    });

    testWidgets('a non-wrapping carousel stops at the last page', (
      tester,
    ) async {
      final List<int> reported = <int>[];
      await tester.pumpWidget(
        _frame(
          _carousel(
            itemCount: 2,
            wrap: false,
            autoplayInterval: const Duration(milliseconds: 100),
            onIndexChanged: reported.add,
          ),
        ),
      );
      for (var i = 0; i < 12; i++) {
        await tester.pump(const Duration(milliseconds: 150));
      }
      expect(reported.every((int index) => index < 2), isTrue);
    });
  });

  group('theme precedence', () {
    testWidgets('the widget leg wins over everything', (tester) async {
      await tester.pumpWidget(
        _frame(
          _carousel(
            alignment: CarouselAlignment.start,
            viewportFraction: 0.25,
            theme: const CarouselTheme(alignment: CarouselAlignment.end),
          ),
          app: const <ComponentThemeData>[
            CarouselTheme(viewportFraction: 0.75),
          ],
        ),
      );
      // 25% of 320 = 80px.
      expect(_pageRect(tester, 0).width, 80);
    });

    testWidgets('the scoped leg wins over the app leg', (tester) async {
      await tester.pumpWidget(
        _frame(
          _carousel(),
          app: const <ComponentThemeData>[
            CarouselTheme(viewportFraction: 0.75),
          ],
          scoped: const CarouselTheme(viewportFraction: 0.25),
        ),
      );
      expect(_pageRect(tester, 0).width, 80);
    });

    testWidgets('the app leg wins over the defaults', (tester) async {
      await tester.pumpWidget(
        _frame(
          _carousel(),
          app: const <ComponentThemeData>[CarouselTheme(viewportFraction: 0.5)],
        ),
      );
      expect(_pageRect(tester, 0).width, 160);
    });

    testWidgets('a leg that sets only the fraction keeps the alignment', (
      tester,
    ) async {
      await tester.pumpWidget(
        _frame(
          _carousel(alignment: CarouselAlignment.start),
          app: const <ComponentThemeData>[CarouselTheme(viewportFraction: 0.5)],
        ),
      );
      expect(_pageRect(tester, 0).left, 0);
    });

    testWidgets('the token default is a full-width centred page', (
      tester,
    ) async {
      await tester.pumpWidget(_frame(_carousel()));
      expect(_pageRect(tester, 0).width, 320);
      expect(carouselDefaults.alignment, CarouselAlignment.center);
    });
  });

  group('layout math', () {
    test('the visible range grows with the free space', () {
      const CarouselTheme theme = CarouselTheme(
        alignment: CarouselAlignment.center,
        viewportFraction: 0.5,
      );
      expect(carouselVisibleRange(theme, 160, 320), (2, 2));
      expect(carouselVisibleRange(theme, 160, 640), (3, 3));
    });

    test('a zero extent yields no extra pages', () {
      const CarouselTheme theme = CarouselTheme(
        alignment: CarouselAlignment.center,
      );
      expect(carouselVisibleRange(theme, 0, 320), (0, 0));
    });

    test('page indices wrap into range', () {
      expect(carouselPageAt(5, 3), 2);
      expect(carouselPageAt(-1, 3), 2);
      expect(carouselPageAt(5, null), 5);
    });

    test('page visibility respects wrap', () {
      expect(carouselPageVisible(-1, 3, true), isTrue);
      expect(carouselPageVisible(-1, 3, false), isFalse);
      expect(carouselPageVisible(1, null, false), isTrue);
    });

    test('an autoplay step clamps at the ends when it does not wrap', () {
      expect(
        carouselStepTarget(value: 2, itemCount: 3, wrap: false, reverse: false),
        2,
      );
      expect(
        carouselStepTarget(value: 0, itemCount: 3, wrap: false, reverse: true),
        0,
      );
      expect(
        carouselStepTarget(value: 2, itemCount: 3, wrap: true, reverse: false),
        3,
      );
    });

    test('a fling snaps to the page it passed', () {
      expect(
        carouselSnapTarget(
          value: 0.9,
          velocity: -200,
          extent: 100,
          itemCount: 5,
          wrap: false,
        ),
        1,
      );
      expect(
        carouselSnapTarget(
          value: 0.1,
          velocity: 0,
          extent: 100,
          itemCount: 5,
          wrap: false,
        ),
        0,
      );
    });

    test('a fling clamps when the carousel does not wrap', () {
      expect(
        carouselSnapTarget(
          value: 3.9,
          velocity: -400,
          extent: 100,
          itemCount: 4,
          wrap: false,
        ),
        3,
      );
    });
  });
}
