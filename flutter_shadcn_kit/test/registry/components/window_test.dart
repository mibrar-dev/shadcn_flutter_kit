// Widget tests for the `window` component.
//
// Covers the chrome metrics, controller-driven bounds/maximize, the default
// actions (minimize / maximize / close), title-bar drag, edge resize with
// constraint clamping, the theme legs, dark tokens and the old-bug
// regressions: `WindowActions` on a detached handle, ghost entries when close
// raced the exit animation, and the resize engine clamping.

import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_shadcn_kit/registry/components/card/card.dart';
import 'package:flutter_shadcn_kit/registry/components/patch/patch.dart';
import 'package:flutter_shadcn_kit/registry/components/window/window.dart';
import 'package:flutter_shadcn_kit/registry/foundation/icons/lucide_icons.dart';
import 'package:flutter_shadcn_kit/registry/theme/color_tokens.dart';
import 'package:flutter_shadcn_kit/registry/theme/theme.dart';
import 'package:flutter_test/flutter_test.dart';

const Color _green = Color(0xFF00FF00);

Widget _frame({
  required Widget child,
  ShadcnThemeData data = const ShadcnThemeData(),
  List<ComponentThemeData> app = const <ComponentThemeData>[],
  WindowTheme? scoped,
}) {
  Widget body = child;
  if (scoped != null) {
    body = ComponentTheme<WindowTheme>(data: scoped, child: body);
  }
  return ShadcnTheme(
    data: data,
    child: ComponentThemes(
      themes: app,
      child: Directionality(textDirection: TextDirection.ltr, child: body),
    ),
  );
}

Widget _stage(
  WindowController controller, {
  WindowTheme? theme,
  Size size = const Size(400, 300),
  bool withContent = true,
}) {
  return Align(
    alignment: Alignment.topLeft,
    child: SizedBox(
      width: size.width,
      height: size.height,
      child: WindowNavigator(
        initialWindows: <Window>[
          Window(
            controller: controller,
            theme: theme,
            title: const Text('Notes'),
            content: withContent
                ? const Padding(padding: EdgeInsets.all(8), child: Text('body'))
                : null,
          ),
        ],
      ),
    ),
  );
}

WindowController _controller() =>
    WindowController(bounds: const Rect.fromLTWH(20, 30, 200, 150));

BoxDecoration _cardDecoration(WidgetTester tester) {
  final DecoratedBox box = tester.widget<DecoratedBox>(
    find
        .descendant(of: find.byType(Card), matching: find.byType(DecoratedBox))
        .first,
  );
  return box.decoration as BoxDecoration;
}

Future<void> _dragBy(
  WidgetTester tester,
  Finder target,
  Offset delta, {
  Offset from = Offset.zero,
}) async {
  final TestGesture gesture = await tester.startGesture(
    tester.getCenter(target) + from,
    kind: PointerDeviceKind.mouse,
  );
  await gesture.moveBy(const Offset(4, 4));
  await tester.pump();
  await gesture.moveBy(delta);
  await tester.pump();
  await gesture.up();
  await tester.pump();
}

void main() {
  const ShadcnColors light = ShadcnColors.lightFallback;
  const ShadcnColors dark = ShadcnColors.darkFallback;

  group('chrome', () {
    testWidgets('renders title/content with the token card', (tester) async {
      final WindowController controller = _controller();
      addTearDown(controller.dispose);
      await tester.pumpWidget(_frame(child: _stage(controller)));
      expect(find.text('Notes'), findsOneWidget);
      expect(find.text('body'), findsOneWidget);
      expect(tester.getSize(find.byType(Window)), const Size(200, 150));
      final BoxDecoration decoration = _cardDecoration(tester);
      expect(decoration.color, light.card);
      expect(decoration.border!.top.color, light.border);
    });

    testWidgets('title bar and content split at 32px', (tester) async {
      final WindowController controller = _controller();
      addTearDown(controller.dispose);
      await tester.pumpWidget(_frame(child: _stage(controller)));
      expect(tester.getSize(find.byType(ClickDetector)), const Size(200, 32));
      expect(tester.getSize(find.text('body')).width, 184);
    });

    testWidgets('controller bounds move and resize the frame', (tester) async {
      final WindowController controller = _controller();
      addTearDown(controller.dispose);
      await tester.pumpWidget(_frame(child: _stage(controller)));
      controller.bounds = const Rect.fromLTWH(0, 0, 300, 200);
      await tester.pumpAndSettle();
      expect(tester.getSize(find.byType(Window)), const Size(300, 200));
    });

    testWidgets('maximized maps a relative rect onto the viewport', (
      tester,
    ) async {
      final WindowController controller = _controller();
      addTearDown(controller.dispose);
      await tester.pumpWidget(_frame(child: _stage(controller)));
      controller.maximized = const Rect.fromLTWH(0, 0, 0.5, 1);
      await tester.pumpAndSettle();
      expect(tester.getSize(find.byType(Window)), const Size(200, 300));
      expect(_cardDecoration(tester).borderRadius, BorderRadius.zero);
    });
  });

  group('actions', () {
    testWidgets('minimize and maximize toggle the controller', (tester) async {
      final WindowController controller = _controller();
      addTearDown(controller.dispose);
      await tester.pumpWidget(_frame(child: _stage(controller)));
      await tester.tap(find.byIcon(LucideIcons.minus));
      await tester.pump();
      expect(controller.minimized, isTrue);
      await tester.tap(find.byIcon(LucideIcons.maximize));
      await tester.pump();
      expect(controller.maximized, const Rect.fromLTWH(0, 0, 1, 1));
    });

    testWidgets('regression: close removes the window after the exit', (
      tester,
    ) async {
      final WindowController controller = _controller();
      addTearDown(controller.dispose);
      await tester.pumpWidget(_frame(child: _stage(controller)));
      await tester.tap(find.byIcon(LucideIcons.x));
      await tester.pumpAndSettle();
      expect(find.byType(Window), findsNothing);
    });

    testWidgets('regression: detached actions do not throw', (tester) async {
      // No WindowHandle in scope: every button renders disabled.
      await tester.pumpWidget(
        _frame(
          child: const SizedBox(width: 200, height: 40, child: WindowActions()),
        ),
      );
      expect(find.byType(WindowActions), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });

  group('gestures', () {
    testWidgets('title-bar drag translates the bounds', (tester) async {
      final WindowController controller = _controller();
      addTearDown(controller.dispose);
      await tester.pumpWidget(_frame(child: _stage(controller)));
      await _dragBy(tester, find.byType(ClickDetector), const Offset(40, 30));
      expect(controller.bounds.left, greaterThan(20));
      expect(controller.bounds.top, greaterThan(30));
      expect(controller.bounds.width, 200);
      expect(controller.bounds.height, 150);
    });

    testWidgets('double click on the title bar maximizes', (tester) async {
      final WindowController controller = _controller();
      addTearDown(controller.dispose);
      await tester.pumpWidget(_frame(child: _stage(controller)));
      await tester.tap(find.byType(ClickDetector));
      await tester.pump(const Duration(milliseconds: 40));
      await tester.tap(find.byType(ClickDetector));
      await tester.pump();
      expect(controller.maximized, const Rect.fromLTWH(0, 0, 1, 1));
    });

    testWidgets('bottom-right resize grows the bounds', (tester) async {
      final WindowController controller = _controller();
      addTearDown(controller.dispose);
      await tester.pumpWidget(_frame(child: _stage(controller)));
      final Offset corner =
          tester.getBottomRight(find.byType(Window)) - const Offset(2, 2);
      final TestGesture gesture = await tester.startGesture(
        corner,
        kind: PointerDeviceKind.mouse,
      );
      await gesture.moveBy(const Offset(10, 10));
      await tester.pump();
      await gesture.moveBy(const Offset(30, 20));
      await tester.pump();
      await gesture.up();
      await tester.pump();
      expect(controller.bounds.width, greaterThan(200));
      expect(controller.bounds.height, greaterThan(150));
    });

    testWidgets('window focus reorders the navigator layers', (tester) async {
      final WindowController first = WindowController(
        bounds: const Rect.fromLTWH(0, 0, 120, 120),
      );
      final WindowController second = WindowController(
        bounds: const Rect.fromLTWH(60, 60, 120, 120),
      );
      addTearDown(first.dispose);
      addTearDown(second.dispose);
      await tester.pumpWidget(
        _frame(
          child: SizedBox(
            width: 400,
            height: 300,
            child: WindowNavigator(
              initialWindows: <Window>[
                Window(controller: first, title: const Text('first')),
                Window(controller: second, title: const Text('second')),
              ],
            ),
          ),
        ),
      );
      await tester.tap(find.text('first'));
      await tester.pump();
      expect(tester.takeException(), isNull);
    });
  });

  group('snap presets', () {
    test('the six presets tile the host', () {
      expect(windowSnapPresets, hasLength(6));
      for (final List<Rect> preset in windowSnapPresets) {
        expect(preset, isNotEmpty);
        double area = 0;
        for (final Rect rect in preset) {
          expect(rect.left, greaterThanOrEqualTo(0));
          expect(rect.top, greaterThanOrEqualTo(0));
          expect(rect.right, lessThanOrEqualTo(1.0001));
          expect(rect.bottom, lessThanOrEqualTo(1.0001));
          area += rect.width * rect.height;
        }
        expect(area, closeTo(1, 0.0001));
      }
    });

    testWidgets('the bar is inactive until a window is dragged', (
      tester,
    ) async {
      final WindowDragController drag = WindowDragController();
      addTearDown(drag.dispose);
      await tester.pumpWidget(
        _frame(
          child: SizedBox(
            width: 400,
            height: 300,
            child: Stack(
              children: <Widget>[
                Positioned.fill(
                  child: ColoredBox(color: const Color(0xFFFFFFFF)),
                ),
                WindowSnapBar(
                  drag: drag,
                  titleBarHeight: 32,
                  viewportSize: const Size(400, 300),
                ),
              ],
            ),
          ),
        ),
      );
      final TestGesture mouse = await tester.createGesture(
        kind: PointerDeviceKind.mouse,
      );
      await mouse.addPointer(location: Offset.zero);
      addTearDown(mouse.removePointer);
      await mouse.moveTo(const Offset(200, 10));
      await tester.pumpAndSettle();
      expect(drag.strategy, isNull);
      expect(drag.window, isNull);
    });

    testWidgets('hovering the top edge targets maximize and reveals presets', (
      tester,
    ) async {
      final WindowDragController drag = WindowDragController();
      addTearDown(drag.dispose);
      await tester.pumpWidget(
        _frame(
          child: SizedBox(
            width: 400,
            height: 300,
            child: Stack(
              children: <Widget>[
                Positioned.fill(
                  child: ColoredBox(color: const Color(0xFFFFFFFF)),
                ),
                WindowSnapBar(
                  drag: drag,
                  titleBarHeight: 32,
                  viewportSize: const Size(400, 300),
                ),
              ],
            ),
          ),
        ),
      );
      final TestGesture mouse = await tester.createGesture(
        kind: PointerDeviceKind.mouse,
      );
      await mouse.addPointer(location: Offset.zero);
      addTearDown(mouse.removePointer);

      drag.start('window');
      await tester.pump();
      await mouse.moveTo(const Offset(200, 10));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));
      expect(drag.strategy?.relativeBounds, const Rect.fromLTWH(0, 0, 1, 1));
      expect(drag.strategy?.shouldMinifyWindow, isFalse);

      final Finder middleThird = find.byKey(
        const ValueKey<String>('windowSnapCell-4-1'),
      );
      expect(middleThird, findsOneWidget);
      await mouse.moveTo(tester.getCenter(middleThird));
      await tester.pump();
      expect(
        drag.strategy?.relativeBounds,
        const Rect.fromLTWH(1 / 3, 0, 1 / 3, 1),
      );
      expect(drag.strategy?.shouldMinifyWindow, isTrue);

      drag.stop();
      await tester.pumpAndSettle();
      expect(drag.strategy, isNull);
    });

    testWidgets('the navigator shows the bar and can hide it', (tester) async {
      final WindowController controller = _controller();
      addTearDown(controller.dispose);
      await tester.pumpWidget(_frame(child: _stage(controller)));
      expect(find.byType(WindowSnapBar), findsOneWidget);

      final WindowController other = _controller();
      addTearDown(other.dispose);
      await tester.pumpWidget(
        _frame(
          child: SizedBox(
            width: 400,
            height: 300,
            child: WindowNavigator(
              showTopSnapBar: false,
              initialWindows: <Window>[Window(controller: other)],
            ),
          ),
        ),
      );
      expect(find.byType(WindowSnapBar), findsNothing);
    });

    testWidgets('dragging to the top edge snaps to full screen', (
      tester,
    ) async {
      final WindowController controller = _controller();
      addTearDown(controller.dispose);
      await tester.pumpWidget(_frame(child: _stage(controller)));
      final TestGesture gesture = await tester.startGesture(
        tester.getCenter(find.byType(ClickDetector)),
        kind: PointerDeviceKind.mouse,
      );
      await gesture.moveBy(const Offset(4, 4));
      await tester.pump();
      await gesture.moveTo(const Offset(200, 8));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));
      await gesture.up();
      await tester.pump();
      expect(controller.maximized, const Rect.fromLTWH(0, 0, 1, 1));
    });
  });

  group('theme precedence', () {
    Future<double> titleBarHeight(
      WidgetTester tester, {
      WindowTheme? app,
      WindowTheme? scoped,
      WindowTheme? widget,
    }) async {
      final WindowController controller = _controller();
      addTearDown(controller.dispose);
      await tester.pumpWidget(
        _frame(
          app: app == null
              ? const <ComponentThemeData>[]
              : <ComponentThemeData>[app],
          scoped: scoped,
          child: _stage(controller, theme: widget),
        ),
      );
      return tester.getSize(find.byType(ClickDetector)).height;
    }

    testWidgets('defaults use the theme metrics', (tester) async {
      expect(await titleBarHeight(tester), 32);
    });

    testWidgets('app leg overrides the defaults', (tester) async {
      expect(
        await titleBarHeight(
          tester,
          app: const WindowTheme(titleBarHeight: 40),
        ),
        40,
      );
    });

    testWidgets('scoped leg overrides the app leg', (tester) async {
      expect(
        await titleBarHeight(
          tester,
          app: const WindowTheme(titleBarHeight: 40),
          scoped: const WindowTheme(titleBarHeight: 44),
        ),
        44,
      );
    });

    testWidgets('widget leg overrides the scoped leg', (tester) async {
      expect(
        await titleBarHeight(
          tester,
          scoped: const WindowTheme(titleBarHeight: 44),
          widget: const WindowTheme(titleBarHeight: 48),
        ),
        48,
      );
    });

    testWidgets('a leg setting only the colour keeps the height', (
      tester,
    ) async {
      expect(
        await titleBarHeight(
          tester,
          scoped: const WindowTheme(titleColor: ThemedColor.value(_green)),
        ),
        32,
      );
    });
  });

  group('tokens and engine', () {
    testWidgets('dark palette drives the chrome', (tester) async {
      final WindowController controller = _controller();
      addTearDown(controller.dispose);
      await tester.pumpWidget(
        _frame(
          data: const ShadcnThemeData(colors: dark),
          child: _stage(controller),
        ),
      );
      final BoxDecoration decoration = _cardDecoration(tester);
      expect(decoration.color, dark.card);
      expect(decoration.border!.top.color, dark.border);
    });

    test('WindowState copyWith and equality', () {
      const WindowState state = WindowState(
        bounds: Rect.fromLTWH(0, 0, 100, 100),
      );
      final WindowState moved = state.copyWith(
        bounds: const Rect.fromLTWH(10, 10, 120, 120),
      );
      expect(moved.bounds, const Rect.fromLTWH(10, 10, 120, 120));
      expect(moved.minimized, isFalse);
      expect(state == moved, isFalse);
      final WindowState maximized = state.withMaximized(
        const Rect.fromLTWH(0, 0, 0.5, 1),
      );
      expect(maximized.maximized, const Rect.fromLTWH(0, 0, 0.5, 1));
      expect(maximized == state, isFalse);
    });

    test('resizeWindow clamps to the constraints', () {
      final WindowState state = WindowState(
        bounds: const Rect.fromLTWH(0, 0, 200, 150),
        constraints: const BoxConstraints(minWidth: 120, minHeight: 80),
      );
      final Rect grown = resizeWindow(
        state,
        WindowResizeEdge.bottomRight,
        const Offset(50, 40),
      );
      expect(grown, const Rect.fromLTRB(0, 0, 250, 190));
      final Rect clamped = resizeWindow(
        state,
        WindowResizeEdge.bottomRight,
        const Offset(-500, -500),
      );
      expect(clamped.width, 120);
      expect(clamped.height, 80);
      final Rect leftGrown = resizeWindow(
        state,
        WindowResizeEdge.left,
        const Offset(-40, 0),
      );
      expect(leftGrown, const Rect.fromLTRB(-40, 0, 200, 150));
    });

    test('drag controller tracks window and strategy', () {
      final WindowDragController drag = WindowDragController();
      addTearDown(drag.dispose);
      expect(drag.window, isNull);
      const WindowSnapStrategy half = WindowSnapStrategy(
        relativeBounds: Rect.fromLTWH(0, 0, 0.5, 1),
        shouldMinifyWindow: false,
      );
      drag
        ..start('window')
        ..hover(half);
      expect(drag.window, 'window');
      expect(drag.strategy, half);
      expect(drag.stop(), half);
      expect(drag.window, isNull);
      expect(drag.strategy, isNull);
    });

    test('defaults table matches the old chrome metrics', () {
      const ShadcnColors colors = ShadcnColors.lightFallback;
      expect(windowDefaults.titleBarHeight, 32);
      expect(windowDefaults.resizeThickness, 8);
      expect(windowDefaults.titleColor?.resolve(colors), colors.foreground);
      expect(windowDefaults.snapOverlayColor?.resolve(colors), colors.card);
    });
  });
}
