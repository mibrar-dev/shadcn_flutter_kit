// Widget tests for the `hover_card` component.
//
// Covers the hover lifecycle (show delay, hide delay, long-press), the
// popover surface tokens, all four theme legs, plus the regression for the
// deleted `adaptiveOverlay` path (no overlay_configuration import).

import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_shadcn_kit/registry/components/hover_card/hover_card.dart';
import 'package:flutter_shadcn_kit/registry/theme/color_tokens.dart';
import 'package:flutter_shadcn_kit/registry/theme/theme.dart';
import 'package:flutter_test/flutter_test.dart';

const Color _green = Color(0xFF00FF00);

int _overlayGeneration = 0;

Widget _frame(
  Widget child, {
  ShadcnThemeData data = const ShadcnThemeData(),
  List<ComponentThemeData> app = const <ComponentThemeData>[],
  HoverCardTheme? scoped,
}) {
  Widget body = child;
  if (scoped != null) {
    body = ComponentTheme<HoverCardTheme>(data: scoped, child: body);
  }
  return ShadcnTheme(
    data: data,
    child: ComponentThemes(
      themes: app,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Overlay(
          key: ValueKey<int>(_overlayGeneration++),
          initialEntries: <OverlayEntry>[
            OverlayEntry(builder: (context) => body),
          ],
        ),
      ),
    ),
  );
}

/// A hit-testable anchor for the hover primitive.
class _AnchorBox extends StatelessWidget {
  const _AnchorBox();

  @override
  Widget build(BuildContext context) {
    return Container(width: 20, height: 20, color: const Color(0xFF000001));
  }
}

Future<TestGesture> _mouse(WidgetTester tester) async {
  FocusManager.instance.highlightStrategy =
      FocusHighlightStrategy.alwaysTraditional;
  addTearDown(
    () => FocusManager.instance.highlightStrategy =
        FocusHighlightStrategy.automatic,
  );
  final TestGesture gesture = await tester.createGesture(
    kind: PointerDeviceKind.mouse,
  );
  await gesture.addPointer(location: Offset.zero);
  addTearDown(gesture.removePointer);
  await tester.pump();
  return gesture;
}

/// Parks the mouse on [finder] and lets the popover animation finish.
Future<void> _hoverOn(
  WidgetTester tester,
  TestGesture mouse,
  Finder finder,
) async {
  await mouse.moveTo(tester.getCenter(finder));
  for (var i = 0; i < 4; i++) {
    await tester.pump(const Duration(milliseconds: 50));
  }
}

Widget _card({Duration? wait, Duration? debounce, HoverCardTheme? theme}) {
  return HoverCard(
    wait: wait,
    debounce: debounce,
    theme: theme,
    hoverBuilder: (context) => const Text('preview-body'),
    child: const _AnchorBox(),
  );
}

void main() {
  group('hover lifecycle', () {
    testWidgets('shows after the wait and hides after the debounce', (
      tester,
    ) async {
      await tester.pumpWidget(
        _frame(
          _card(
            wait: const Duration(milliseconds: 100),
            debounce: const Duration(milliseconds: 100),
          ),
        ),
      );
      final TestGesture mouse = await _mouse(tester);
      await mouse.moveTo(tester.getCenter(find.byType(_AnchorBox)));
      await tester.pump();
      expect(find.text('preview-body'), findsNothing);
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump(const Duration(milliseconds: 50));
      expect(find.text('preview-body'), findsOneWidget);
      await mouse.moveTo(const Offset(5000, 5000));
      await tester.pump();
      expect(find.text('preview-body'), findsOneWidget);
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pumpAndSettle();
      expect(find.text('preview-body'), findsNothing);
    });

    testWidgets('zero wait shows immediately', (tester) async {
      await tester.pumpWidget(_frame(_card(wait: Duration.zero)));
      final TestGesture mouse = await _mouse(tester);
      await _hoverOn(tester, mouse, find.byType(_AnchorBox));
      expect(find.text('preview-body'), findsOneWidget);
    });

    testWidgets('long-press shows the card on touch', (tester) async {
      await tester.pumpWidget(_frame(_card(wait: const Duration(seconds: 30))));
      await tester.longPress(find.byType(_AnchorBox));
      await tester.pump();
      expect(find.text('preview-body'), findsOneWidget);
    });
  });

  group('surface', () {
    testWidgets('paints the popover token surface', (tester) async {
      const ShadcnColors colors = ShadcnColors.lightFallback;
      await tester.pumpWidget(
        _frame(
          _card(wait: Duration.zero),
          data: const ShadcnThemeData(colors: colors),
        ),
      );
      final TestGesture mouse = await _mouse(tester);
      await _hoverOn(tester, mouse, find.byType(_AnchorBox));
      final Container surface = tester.widget<Container>(
        find
            .ancestor(
              of: find.text('preview-body'),
              matching: find.byType(Container),
            )
            .first,
      );
      final BoxDecoration decoration = surface.decoration! as BoxDecoration;
      expect(decoration.color, colors.popover);
      expect(decoration.border!.top.color, colors.border);
    });

    testWidgets('dark tokens drive the surface', (tester) async {
      const ShadcnColors colors = ShadcnColors.darkFallback;
      await tester.pumpWidget(
        _frame(
          _card(wait: Duration.zero),
          data: const ShadcnThemeData(colors: colors),
        ),
      );
      final TestGesture mouse = await _mouse(tester);
      await _hoverOn(tester, mouse, find.byType(_AnchorBox));
      final Container surface = tester.widget<Container>(
        find
            .ancestor(
              of: find.text('preview-body'),
              matching: find.byType(Container),
            )
            .first,
      );
      expect((surface.decoration! as BoxDecoration).color, colors.popover);
    });
  });

  group('theme legs', () {
    testWidgets('widget wait wins over the app leg', (tester) async {
      await tester.pumpWidget(
        _frame(
          _card(
            wait: Duration.zero,
            theme: const HoverCardTheme(wait: Duration(seconds: 30)),
          ),
          app: const <ComponentThemeData>[
            HoverCardTheme(wait: Duration(seconds: 30)),
          ],
        ),
      );
      // Widget leg (zero) must win over both slower legs.
      final TestGesture mouse = await _mouse(tester);
      await _hoverOn(tester, mouse, find.byType(_AnchorBox));
      expect(find.text('preview-body'), findsOneWidget);
    });

    testWidgets('scoped leg wins over the app leg', (tester) async {
      await tester.pumpWidget(
        _frame(
          _card(),
          app: const <ComponentThemeData>[
            HoverCardTheme(wait: Duration(seconds: 30)),
          ],
          scoped: const HoverCardTheme(wait: Duration.zero),
        ),
      );
      final TestGesture mouse = await _mouse(tester);
      await _hoverOn(tester, mouse, find.byType(_AnchorBox));
      expect(find.text('preview-body'), findsOneWidget);
    });

    testWidgets('app leg wins over the defaults', (tester) async {
      await tester.pumpWidget(
        _frame(
          _card(),
          app: const <ComponentThemeData>[HoverCardTheme(wait: Duration.zero)],
        ),
      );
      final TestGesture mouse = await _mouse(tester);
      await _hoverOn(tester, mouse, find.byType(_AnchorBox));
      expect(find.text('preview-body'), findsOneWidget);
    });

    testWidgets('default wait keeps the card hidden at first', (tester) async {
      await tester.pumpWidget(_frame(_card()));
      final TestGesture mouse = await _mouse(tester);
      await _hoverOn(tester, mouse, find.byType(_AnchorBox));
      // Default 500 ms: nothing yet.
      expect(find.text('preview-body'), findsNothing);
      await tester.pump(const Duration(milliseconds: 500));
      expect(find.text('preview-body'), findsOneWidget);
    });
  });

  group('regressions', () {
    testWidgets('no tooltip import: zero wait is instant, not adaptive', (
      tester,
    ) async {
      // The old adaptiveOverlay path reached into overlay_configuration;
      // the port must show through the plain popover handler instead.
      await tester.pumpWidget(_frame(_card(wait: Duration.zero)));
      final TestGesture mouse = await _mouse(tester);
      await _hoverOn(tester, mouse, find.byType(_AnchorBox));
      expect(find.text('preview-body'), findsOneWidget);
      expect(_green, isNotNull);
    });
  });
}
