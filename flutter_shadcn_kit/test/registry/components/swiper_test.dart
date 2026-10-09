// Widget tests for the `swiper` component.
//
// Covers: interactive scrub (partial drag follows the finger), settle by
// position + fling velocity, the drawer/sheet variants, the programmatic
// SwiperController, reduced motion, RTL, the four theme legs, dark tokens and
// the old full-width-drawer bug.

import 'package:flutter/widgets.dart';
import 'package:flutter_shadcn_kit/registry/components/swiper/swiper.dart';
import 'package:flutter_shadcn_kit/registry/primitives/drawer_route/drawer_panel_surface.dart';
import 'package:flutter_shadcn_kit/registry/theme/color_tokens.dart';
import 'package:flutter_shadcn_kit/registry/theme/theme.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> _pumpApp(
  WidgetTester tester, {
  ShadcnThemeData? theme,
  SwiperTheme? appTheme,
  SwiperTheme? scopedTheme,
  SwiperTheme? widgetTheme,
  SwiperController? controller,
  OverlayPosition position = OverlayPosition.left,
  SwiperVariant variant = SwiperVariant.drawer,
  bool enabled = true,
  bool disableAnimations = false,
  TextDirection textDirection = TextDirection.ltr,
}) async {
  Widget page = Swiper(
    position: position,
    variant: variant,
    enabled: enabled,
    controller: controller,
    theme: widgetTheme,
    builder: (BuildContext context) => const Text('Overlay body'),
    child: const SizedBox.expand(),
  );
  if (scopedTheme != null) {
    page = ComponentTheme<SwiperTheme>(data: scopedTheme, child: page);
  }
  Widget app = Directionality(
    textDirection: textDirection,
    child: MediaQuery(
      data: MediaQueryData(disableAnimations: disableAnimations),
      child: Navigator(
        key: UniqueKey(),
        onGenerateRoute: (RouteSettings settings) => PageRouteBuilder<void>(
          settings: settings,
          pageBuilder:
              (
                BuildContext context,
                Animation<double> animation,
                Animation<double> secondaryAnimation,
              ) => page,
        ),
      ),
    ),
  );
  if (appTheme != null) {
    app = ComponentThemes(themes: <ComponentThemeData>[appTheme], child: app);
  }
  await tester.pumpWidget(
    ShadcnTheme(data: theme ?? const ShadcnThemeData(), child: app),
  );
}

Finder get _panel => find.byType(DrawerPanelSurface);

Rect _panelRect(WidgetTester tester) => tester.getRect(_panel);

Color? _panelColor(WidgetTester tester) {
  final DecoratedBox box = tester.widget<DecoratedBox>(
    find.descendant(of: _panel, matching: find.byType(DecoratedBox)).first,
  );
  return (box.decoration as BoxDecoration).color;
}

/// Drags by [offset] in several steps and returns the live gesture. Timestamps
/// advance so the release velocity is meaningful.
Future<TestGesture> _startDrag(WidgetTester tester, Offset offset) async {
  final TestGesture gesture = await tester.startGesture(
    tester.getCenter(find.byType(Swiper)),
  );
  const int steps = 10;
  final Offset step = offset / steps.toDouble();
  for (int i = 0; i < steps; i++) {
    await gesture.moveBy(step, timeStamp: Duration(milliseconds: 16 * (i + 1)));
    await tester.pump(const Duration(milliseconds: 16));
  }
  return gesture;
}

/// A full drag-and-release; the release velocity is high.
Future<void> _drag(WidgetTester tester, Offset offset) async {
  final TestGesture gesture = await _startDrag(tester, offset);
  await gesture.up(timeStamp: const Duration(milliseconds: 176));
  await tester.pumpAndSettle();
}

/// Releases after a pause, so the fling velocity is ~0.
Future<void> _releaseSlowly(WidgetTester tester, TestGesture gesture) async {
  await tester.pump(const Duration(milliseconds: 400));
  await gesture.up(timeStamp: const Duration(milliseconds: 600));
  await tester.pumpAndSettle();
}

void main() {
  group('variant defaults', () {
    test('drawer keeps its width and drags; sheet expands', () {
      final SwiperTheme drawer = swiperDefaults(SwiperVariant.drawer);
      expect(drawer.expands, isFalse);
      expect(drawer.draggable, isTrue);
      expect(drawer.barrierDismissible, isTrue);
      expect(drawer.threshold, 0.5);

      final SwiperTheme sheet = swiperDefaults(SwiperVariant.sheet);
      expect(sheet.expands, isTrue);
      expect(sheet.draggable, isFalse);
    });

    test('merge keeps the receiver and fills the rest', () {
      const SwiperTheme receiver = SwiperTheme(maxSize: 260);
      const SwiperTheme fallback = SwiperTheme(maxSize: 200, threshold: 0.4);
      final SwiperTheme merged = receiver.merge(fallback);
      expect(merged.maxSize, 260);
      expect(merged.threshold, 0.4);
    });

    test('lerp interpolates numbers and steps flags', () {
      final SwiperTheme lerped = SwiperTheme.lerp(
        const SwiperTheme(maxSize: 0, threshold: 0),
        const SwiperTheme(maxSize: 200, threshold: 1),
        0.5,
      );
      expect(lerped.maxSize, 100);
      expect(lerped.threshold, 0.5);
    });
  });

  group('interactive scrub', () {
    testWidgets('a partial drag shows a partial extent', (tester) async {
      final SwiperController controller = SwiperController();
      addTearDown(controller.dispose);
      await _pumpApp(tester, controller: controller);

      final TestGesture gesture = await _startDrag(
        tester,
        const Offset(220, 0),
      );
      // ~220 of the 320 px panel: over half open.
      expect(controller.progress, greaterThan(0.5));
      expect(controller.progress, lessThan(0.8));
      final Rect panel = _panelRect(tester);
      expect(panel.width, 320);
      expect(panel.left, lessThan(0));
      expect(panel.right, greaterThan(0));
      expect(panel.right, lessThan(320));

      await _releaseSlowly(tester, gesture);
      expect(controller.progress, 1.0);
    });

    testWidgets('releasing past half settles open', (tester) async {
      await _pumpApp(tester);
      final TestGesture gesture = await _startDrag(
        tester,
        const Offset(240, 0),
      );
      await _releaseSlowly(tester, gesture);
      expect(_panel, findsOneWidget);
      expect(_panelRect(tester).left, 0);
    });

    testWidgets('a slow short drag settles closed', (tester) async {
      await _pumpApp(tester);
      final TestGesture gesture = await _startDrag(
        tester,
        const Offset(100, 0),
      );
      await _releaseSlowly(tester, gesture);
      expect(_panel, findsNothing);
    });

    testWidgets('a fast fling opens below the distance threshold', (
      tester,
    ) async {
      await _pumpApp(tester);
      // 80 px is well below half, but the release velocity is high.
      await _drag(tester, const Offset(80, 0));
      expect(_panel, findsOneWidget);
    });

    testWidgets('swiping the wrong way does not open', (tester) async {
      await _pumpApp(tester);
      await _drag(tester, const Offset(-300, 0));
      expect(_panel, findsNothing);
    });

    testWidgets('enabled: false disables the swipe', (tester) async {
      await _pumpApp(tester, enabled: false);
      await _drag(tester, const Offset(300, 0));
      expect(_panel, findsNothing);
    });

    testWidgets('a sheet opens upwards', (tester) async {
      await _pumpApp(
        tester,
        position: OverlayPosition.bottom,
        variant: SwiperVariant.sheet,
      );
      final TestGesture gesture = await _startDrag(
        tester,
        const Offset(0, -400),
      );
      await _releaseSlowly(tester, gesture);
      expect(_panel, findsOneWidget);
    });

    testWidgets('RTL start resolves to the right edge', (tester) async {
      await _pumpApp(
        tester,
        position: OverlayPosition.start,
        textDirection: TextDirection.rtl,
      );
      await _drag(tester, const Offset(-300, 0));
      expect(_panel, findsOneWidget);
    });

    testWidgets('a wrong-direction drag does not poison the next swipe', (
      tester,
    ) async {
      await _pumpApp(tester);
      await _drag(tester, const Offset(-300, 0));
      expect(_panel, findsNothing);
      await _drag(tester, const Offset(300, 0));
      expect(_panel, findsOneWidget);
    });

    testWidgets('tapping the barrier closes the panel', (tester) async {
      await _pumpApp(tester);
      await _drag(tester, const Offset(300, 0));
      expect(_panel, findsOneWidget);
      // The barrier covers the screen; tap near the opposite edge.
      await tester.tapAt(const Offset(700, 300));
      await tester.pumpAndSettle();
      expect(_panel, findsNothing);
    });
  });

  group('controller', () {
    testWidgets('open and close animate the panel', (tester) async {
      final SwiperController controller = SwiperController();
      addTearDown(controller.dispose);
      await _pumpApp(tester, controller: controller);

      expect(controller.isAttached, isTrue);
      expect(controller.isOpen, isFalse);
      expect(controller.progress, 0);

      controller.open();
      await tester.pumpAndSettle();
      expect(controller.isOpen, isTrue);
      expect(controller.progress, 1.0);
      expect(_panel, findsOneWidget);

      controller.close();
      await tester.pumpAndSettle();
      expect(controller.isOpen, isFalse);
      expect(controller.progress, 0);
      expect(_panel, findsNothing);
    });

    testWidgets('reduced motion settles instantly', (tester) async {
      await _pumpApp(tester, disableAnimations: true);
      final TestGesture gesture = await _startDrag(
        tester,
        const Offset(240, 0),
      );
      await gesture.up(timeStamp: const Duration(milliseconds: 176));
      // A single frame: the panel must already be at rest.
      await tester.pump();
      expect(_panel, findsOneWidget);
      expect(_panelRect(tester).left, 0);
      await tester.pumpAndSettle();
    });
  });

  group('theme resolution', () {
    testWidgets('defaults < app < scoped < widget (maxSize)', (tester) async {
      Future<double> widthWith(SwiperTheme? widgetTheme) async {
        await _pumpApp(
          tester,
          appTheme: const SwiperTheme(maxSize: 200),
          scopedTheme: const SwiperTheme(maxSize: 240),
          widgetTheme: widgetTheme,
        );
        await _drag(tester, const Offset(300, 0));
        return _panelRect(tester).width;
      }

      expect(await widthWith(null), 240);
      expect(await widthWith(const SwiperTheme(maxSize: 260)), 260);
    });

    testWidgets('the default drawer width is 320, not full screen', (
      tester,
    ) async {
      await _pumpApp(tester);
      await _drag(tester, const Offset(300, 0));
      expect(_panelRect(tester).width, 320);
      expect(_panelRect(tester).width, isNot(800));
    });

    testWidgets('dark tokens drive the panel', (tester) async {
      const ShadcnThemeData dark = ShadcnThemeData(
        colors: ShadcnColors.darkFallback,
      );
      await _pumpApp(tester, theme: dark);
      await _drag(tester, const Offset(300, 0));
      expect(_panelColor(tester), dark.colors.background);
    });

    testWidgets('a themed threshold changes what opens', (tester) async {
      await _pumpApp(tester);
      final TestGesture low = await _startDrag(tester, const Offset(100, 0));
      await _releaseSlowly(tester, low);
      expect(_panel, findsNothing);

      await _pumpApp(tester, scopedTheme: const SwiperTheme(threshold: 0.25));
      final TestGesture high = await _startDrag(tester, const Offset(100, 0));
      await _releaseSlowly(tester, high);
      expect(_panel, findsOneWidget);
    });
  });

  test('kSwiperOpenVelocity is 300', () {
    expect(kSwiperOpenVelocity, 300);
  });
}
