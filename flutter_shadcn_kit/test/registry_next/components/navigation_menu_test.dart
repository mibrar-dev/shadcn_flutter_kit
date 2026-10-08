// Widget tests for the `navigation_menu` component.
//
// Covers bar rendering, hover/click popover presentation, content actions,
// Escape dismissal, the content list grid and the four theme-precedence
// legs. Regression tests cover the retired pieces: no `overlay_configuration`
// adaptive path and `Button`-based triggers (no style closures).

import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_shadcn_kit/registry_next/components/button/button.dart';
import 'package:flutter_shadcn_kit/registry_next/components/navigation_menu/navigation_menu.dart';
import 'package:flutter_shadcn_kit/registry_next/components/outlined_container/outlined_container.dart';
import 'package:flutter_shadcn_kit/registry_next/primitives/overlay.dart';
import 'package:flutter_shadcn_kit/registry_next/primitives/overlay_manager_layer.dart';
import 'package:flutter_shadcn_kit/registry_next/theme/theme.dart';
import 'package:flutter_test/flutter_test.dart';

/// Fresh overlay per pump: `Overlay` keeps its initial entries across
/// widget updates, so a stable key would keep showing the first pump's body.
int _overlayGeneration = 0;

Widget _frame({
  required Widget child,
  ShadcnThemeData data = const ShadcnThemeData(),
  List<ComponentThemeData> app = const <ComponentThemeData>[],
  NavigationMenuTheme? scoped,
}) {
  Widget body = child;
  if (scoped != null) {
    body = ComponentTheme<NavigationMenuTheme>(data: scoped, child: body);
  }
  return ShadcnTheme(
    data: data,
    child: ComponentThemes(
      themes: app,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: OverlayManagerLayer(
          popoverHandler: OverlayHandler.popover,
          tooltipHandler: OverlayHandler.popover,
          menuHandler: OverlayHandler.popover,
          child: Overlay(
            // The popover machinery needs a real `Overlay` to insert into.
            key: ValueKey<int>(_overlayGeneration++),
            initialEntries: <OverlayEntry>[
              OverlayEntry(builder: (context) => Center(child: body)),
            ],
          ),
        ),
      ),
    ),
  );
}

NavigationMenu _menu({void Function()? onHome, void Function()? onContent}) {
  return NavigationMenu(
    children: <Widget>[
      NavigationMenuItem(onPressed: onHome, child: const Text('Home')),
      NavigationMenuItem(
        content: NavigationMenuContent(
          title: const Text('Web Apps'),
          content: const Text('Ship in the browser'),
          onPressed: onContent,
        ),
        child: const Text('Products'),
      ),
    ],
  );
}

/// Parks a mouse pointer ready to move; one gesture per test (a second
/// simultaneous pointer confuses enter/exit tracking).
Future<TestGesture> _mouse(WidgetTester tester) async {
  final TestGesture gesture = await tester.createGesture(
    kind: PointerDeviceKind.mouse,
  );
  await gesture.addPointer(location: Offset.zero);
  addTearDown(gesture.removePointer);
  await tester.pump();
  return gesture;
}

/// Moves [gesture] onto [finder]'s centre and lets overlay frames land.
Future<void> _moveTo(
  WidgetTester tester,
  TestGesture gesture,
  Finder finder, {
  int frames = 4,
}) async {
  await gesture.moveTo(tester.getCenter(finder));
  for (var i = 0; i < frames; i++) {
    await tester.pump(const Duration(milliseconds: 50));
  }
}

void main() {
  group('bar', () {
    testWidgets('renders every entry', (tester) async {
      await tester.pumpWidget(_frame(child: _menu()));
      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Products'), findsOneWidget);
    });

    testWidgets('entries are ghost buttons', (tester) async {
      await tester.pumpWidget(_frame(child: _menu()));
      final Iterable<Button> buttons = tester.widgetList<Button>(
        find.byType(Button),
      );
      expect(buttons.length, 2);
      for (final Button button in buttons) {
        expect(button.variant, ButtonVariant.ghost);
      }
    });

    testWidgets('action entry fires without opening a popover', (tester) async {
      bool pressed = false;
      await tester.pumpWidget(
        _frame(child: _menu(onHome: () => pressed = true)),
      );
      await tester.tap(find.text('Home'));
      await tester.pump(const Duration(milliseconds: 300));
      expect(pressed, isTrue);
    });
  });

  group('popover', () {
    testWidgets('hover opens the content surface', (tester) async {
      await tester.pumpWidget(_frame(child: _menu()));
      final TestGesture mouse = await _mouse(tester);
      await _moveTo(tester, mouse, find.text('Products'));
      expect(find.byType(OutlinedContainer), findsOneWidget);
      expect(find.text('Web Apps'), findsOneWidget);
    });

    testWidgets('hovering the action entry closes the popover', (tester) async {
      await tester.pumpWidget(_frame(child: _menu()));
      final TestGesture mouse = await _mouse(tester);
      await _moveTo(tester, mouse, find.text('Products'));
      expect(find.byType(OutlinedContainer), findsOneWidget);
      await _moveTo(tester, mouse, find.text('Home'), frames: 10);
      expect(find.byType(OutlinedContainer), findsNothing);
    });

    testWidgets('content action fires and closes the menu', (tester) async {
      bool pressed = false;
      await tester.pumpWidget(
        _frame(child: _menu(onContent: () => pressed = true)),
      );
      final TestGesture mouse = await _mouse(tester);
      await _moveTo(tester, mouse, find.text('Products'));
      expect(find.text('Web Apps'), findsOneWidget);
      await tester.tap(find.text('Web Apps'));
      for (var i = 0; i < 5; i++) {
        await tester.pump(const Duration(milliseconds: 200));
      }
      expect(pressed, isTrue);
      expect(find.byType(OutlinedContainer), findsNothing);
    });

    testWidgets('chevron shows on entries with content only', (tester) async {
      await tester.pumpWidget(_frame(child: _menu()));
      expect(
        find.descendant(
          of: find.ancestor(
            of: find.text('Products'),
            matching: find.byType(Button),
          ),
          matching: find.byType(AnimatedRotation),
        ),
        findsOneWidget,
      );
      expect(
        find.descendant(
          of: find.ancestor(
            of: find.text('Home'),
            matching: find.byType(Button),
          ),
          matching: find.byType(AnimatedRotation),
        ),
        findsNothing,
      );
    });
  });

  group('keyboard and disabled', () {
    testWidgets('Escape closes the open popover', (tester) async {
      await tester.pumpWidget(
        _frame(
          child: NavigationMenu(
            children: <Widget>[
              NavigationMenuItem(
                content: const Focus(
                  autofocus: true,
                  child: NavigationMenuContent(title: Text('Panel')),
                ),
                child: const Text('Products'),
              ),
            ],
          ),
        ),
      );
      final TestGesture mouse = await _mouse(tester);
      await _moveTo(tester, mouse, find.text('Products'));
      expect(find.byType(OutlinedContainer), findsOneWidget);
      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.byType(OutlinedContainer), findsNothing);
    });

    testWidgets('entry without action or content is disabled', (tester) async {
      await tester.pumpWidget(
        _frame(
          child: const NavigationMenu(
            children: <Widget>[NavigationMenuItem(child: Text('Plain'))],
          ),
        ),
      );
      final Button button = tester.widget<Button>(find.byType(Button));
      expect(button.onPressed, isNull);
    });
  });

  group('content list', () {
    testWidgets('lays out entries in rows', (tester) async {
      await tester.pumpWidget(
        _frame(
          child: const NavigationMenuContentList(
            crossAxisCount: 2,
            children: <Widget>[
              NavigationMenuContent(title: Text('A')),
              NavigationMenuContent(title: Text('B')),
              NavigationMenuContent(title: Text('C')),
            ],
          ),
        ),
      );
      expect(find.text('A'), findsOneWidget);
      expect(find.text('B'), findsOneWidget);
      expect(find.text('C'), findsOneWidget);
      expect(find.byType(Row), findsWidgets);
    });
  });

  group('theme precedence', () {
    testWidgets('widget > scoped > app > defaults', (tester) async {
      NavigationMenuTheme resolve(
        BuildContext context,
        NavigationMenuTheme? widget,
      ) {
        return resolveComponentStyle<NavigationMenuTheme, NavigationMenuTheme>(
          context,
          widget: widget,
          select: (t) => t,
          defaults: navigationMenuDefaults,
        );
      }

      NavigationMenuTheme? seen;
      Future<void> pump({
        NavigationMenuTheme? widget,
        NavigationMenuTheme? scoped,
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
      expect(seen!.offset, navigationMenuDefaults.offset);
      await pump(
        app: const <ComponentThemeData>[
          NavigationMenuTheme(offset: Offset(0, 1)),
        ],
      );
      expect(seen!.offset, const Offset(0, 1));
      await pump(
        scoped: const NavigationMenuTheme(offset: Offset(0, 2)),
        app: const <ComponentThemeData>[
          NavigationMenuTheme(offset: Offset(0, 1)),
        ],
      );
      expect(seen!.offset, const Offset(0, 2));
      await pump(
        widget: const NavigationMenuTheme(offset: Offset(0, 3)),
        scoped: const NavigationMenuTheme(offset: Offset(0, 2)),
        app: const <ComponentThemeData>[
          NavigationMenuTheme(offset: Offset(0, 1)),
        ],
      );
      expect(seen!.offset, const Offset(0, 3));
    });
  });

  group('regressions', () {
    testWidgets('no adaptive overlay conversion runs', (tester) async {
      await tester.pumpWidget(_frame(child: _menu()));
      final TestGesture mouse = await _mouse(tester);
      await _moveTo(tester, mouse, find.text('Products'));
      expect(find.byType(OutlinedContainer), findsOneWidget);
    });
  });
}
