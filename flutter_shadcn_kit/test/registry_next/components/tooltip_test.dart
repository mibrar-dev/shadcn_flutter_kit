// Widget tests for the `tooltip` component.
//
// Covers the hover lifecycle, the presented surface, all four precedence legs,
// light and dark tokens, plus four regressions from the old module: the
// duplicate `InstantTooltip`, the ignored app leg, the double-scaled padding
// and the live theme while the overlay is open.

import 'package:flutter/gestures.dart' show PointerDeviceKind;
import 'package:flutter/widgets.dart';
import 'package:flutter_shadcn_kit/registry_next/components/tooltip/tooltip.dart';
import 'package:flutter_shadcn_kit/registry_next/primitives/hover.dart';
import 'package:flutter_shadcn_kit/registry_next/primitives/overlay.dart';
import 'package:flutter_shadcn_kit/registry_next/primitives/overlay_manager.dart';
import 'package:flutter_shadcn_kit/registry_next/primitives/overlay_manager_layer.dart';
import 'package:flutter_shadcn_kit/registry_next/theme/color_tokens.dart';
import 'package:flutter_shadcn_kit/registry_next/theme/theme.dart';
import 'package:flutter_test/flutter_test.dart';

const Color _green = Color(0xFF00FF00);
const Color _blue = Color(0xFF0000FF);

/// Each `_frame` call gets a fresh overlay generation: Flutter reuses an
/// `Overlay`'s state (and therefore its entries) when only the widget is
/// rebuilt, so an unkeyed overlay would silently keep a stale popover entry
/// alive and hide a leak.
int _overlayGeneration = 0;

/// Stable overlay key for the test that switches the theme without rebuilding
/// the overlay: a *new* overlay would take the open popover entry with it.
const Key _stableOverlayKey = Key('stable-overlay');

Widget _frame(
  Widget child, {
  ShadcnThemeData data = const ShadcnThemeData(),
  ValueNotifier<ShadcnThemeData>? theme,
  List<ComponentThemeData> app = const <ComponentThemeData>[],
  TooltipTheme? scoped,
  OverlayHandler? tooltipHandler,
}) {
  Widget body = child;
  if (scoped != null) {
    body = ComponentTheme<TooltipTheme>(data: scoped, child: body);
  }
  Widget overlayHost = Directionality(
    textDirection: TextDirection.ltr,
    child: Overlay(
      // The popover machinery needs a real `Overlay` to insert into.
      key: theme == null
          ? ValueKey<int>(_overlayGeneration++)
          : _stableOverlayKey,
      initialEntries: <OverlayEntry>[OverlayEntry(builder: (context) => body)],
    ),
  );
  Widget wrapped = theme == null
      ? ShadcnTheme(
          data: data,
          child: ComponentThemes(themes: app, child: overlayHost),
        )
      : ValueListenableBuilder<ShadcnThemeData>(
          valueListenable: theme,
          builder: (context, value, _) => ShadcnTheme(
            data: value,
            child: ComponentThemes(themes: app, child: overlayHost),
          ),
        );
  if (tooltipHandler != null) {
    wrapped = OverlayManagerLayer(
      popoverHandler: OverlayHandler.popover,
      tooltipHandler: tooltipHandler,
      menuHandler: OverlayHandler.popover,
      child: wrapped,
    );
  }
  return wrapped;
}

/// A hit-testable anchor: a bare `SizedBox` does not absorb pointer events, so
/// the `Hover` primitive would never see an enter.
class _AnchorBox extends StatelessWidget {
  const _AnchorBox();

  @override
  Widget build(BuildContext context) {
    return Container(width: 20, height: 20, color: const Color(0xFF000001));
  }
}

Tooltip _tooltip(WidgetTester tester) =>
    tester.widget<Tooltip>(find.byType(Tooltip));

BoxDecoration _containerDecoration(WidgetTester tester) =>
    tester
            .widget<Container>(
              find.descendant(
                of: find.byType(TooltipContainer),
                matching: find.byType(Container),
              ),
            )
            .decoration!
        as BoxDecoration;

/// A mouse pointer parked on [finder]'s centre.
Future<TestGesture> _hover(
  WidgetTester tester,
  Finder finder, {
  int frames = 4,
}) async {
  final TestGesture gesture = await tester.createGesture(
    kind: PointerDeviceKind.mouse,
  );
  await gesture.addPointer(location: Offset.zero);
  addTearDown(gesture.removePointer);
  await tester.pump();
  await gesture.moveTo(tester.getCenter(finder));
  // One pump fires the (possibly zero) `Hover` timer; the popover animation
  // then needs a few frames before the content is in the tree.
  for (var i = 0; i < frames; i++) {
    await tester.pump(const Duration(milliseconds: 50));
  }
  return gesture;
}

/// Moves the pointer far away from every widget in the tree.
Future<void> _unhover(WidgetTester tester, TestGesture gesture) async {
  await gesture.moveTo(const Offset(5000, 5000));
  await tester.pump();
}

void main() {
  group('hover lifecycle', () {
    testWidgets('does not present before the wait duration', (tester) async {
      await tester.pumpWidget(
        _frame(
          Tooltip(
            waitDuration: const Duration(milliseconds: 200),
            child: const _AnchorBox(),
            tooltip: (context) => const Text('hi'),
          ),
        ),
      );
      await _hover(tester, find.byType(Tooltip), frames: 1);
      expect(find.byType(TooltipContainer), findsNothing);
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump(const Duration(milliseconds: 50));
      expect(find.byType(TooltipContainer), findsOneWidget);
    });

    testWidgets('presents on hover and closes on leave', (tester) async {
      await tester.pumpWidget(
        _frame(
          Tooltip(
            waitDuration: Duration.zero,
            child: const _AnchorBox(),
            tooltip: (context) => const Text('hi'),
          ),
        ),
      );
      final TestGesture gesture = await _hover(tester, find.byType(Tooltip));
      expect(find.byType(TooltipContainer), findsOneWidget);

      await _unhover(tester, gesture);
      // The leave is debounced by `minDuration + showDuration` and the popover
      // animates out afterwards.
      for (var i = 0; i < 10; i++) {
        await tester.pump(const Duration(milliseconds: 50));
      }
      expect(find.byType(TooltipContainer), findsNothing);
    });

    testWidgets('a zero wait duration presents immediately', (tester) async {
      await tester.pumpWidget(
        _frame(
          Tooltip(
            waitDuration: Duration.zero,
            child: const _AnchorBox(),
            tooltip: (context) => const Text('hi'),
          ),
        ),
      );
      await _hover(tester, find.byType(Tooltip));
      expect(find.byType(TooltipContainer), findsOneWidget);
    });

    testWidgets('drives the Hover primitive', (tester) async {
      await tester.pumpWidget(
        _frame(
          Tooltip(
            waitDuration: const Duration(milliseconds: 250),
            showDuration: const Duration(milliseconds: 400),
            minDuration: const Duration(milliseconds: 50),
            child: const _AnchorBox(),
            tooltip: (context) => const Text('hi'),
          ),
        ),
      );
      final Hover hover = tester.widget<Hover>(find.byType(Hover));
      expect(hover.waitDuration, const Duration(milliseconds: 250));
      expect(hover.showDuration, const Duration(milliseconds: 400));
      expect(hover.minDuration, const Duration(milliseconds: 50));
      expect(_tooltip(tester).waitDuration, const Duration(milliseconds: 250));
    });

    testWidgets('disposing while open leaves no overlay', (tester) async {
      await tester.pumpWidget(
        _frame(
          Tooltip(
            waitDuration: Duration.zero,
            child: const _AnchorBox(),
            tooltip: (context) => const Text('hi'),
          ),
        ),
      );
      await _hover(tester, find.byType(Tooltip));
      expect(find.byType(TooltipContainer), findsOneWidget);

      // Dispose the anchor while the overlay is open.
      await tester.pumpWidget(_frame(const SizedBox.shrink()));
      for (var i = 0; i < 10; i++) {
        await tester.pump(const Duration(milliseconds: 50));
      }
      expect(find.byType(TooltipContainer), findsNothing);
      expect(tester.takeException(), isNull);
    });
  });

  group('surface', () {
    testWidgets('paints the primary token by default', (tester) async {
      await tester.pumpWidget(
        _frame(const TooltipContainer(child: Text('hi'))),
      );
      final ShadcnColors colors = const ShadcnThemeData().colors;
      expect(_containerDecoration(tester).color, colors.primary);
    });

    testWidgets('wraps the content in a DefaultTextStyle', (tester) async {
      await tester.pumpWidget(
        _frame(const TooltipContainer(child: Text('hi'))),
      );
      final DefaultTextStyle style = tester.widget<DefaultTextStyle>(
        find.byType(DefaultTextStyle),
      );
      expect(style.style.fontSize, 12);
      expect(
        style.style.color,
        const ShadcnThemeData().colors.primaryForeground,
      );
    });

    testWidgets('regression: a caller padding is applied once', (tester) async {
      // The old container multiplied the *resolved* padding by scaling, so a
      // caller-provided padding was silently inflated.
      await tester.pumpWidget(
        _frame(
          const TooltipContainer(
            padding: EdgeInsets.all(20),
            child: Text('hi'),
          ),
          data: const ShadcnThemeData(scaling: 4),
        ),
      );
      final Padding padding = tester.widget<Padding>(
        find.descendant(
          of: find.byType(Container),
          matching: find.byType(Padding),
        ),
      );
      expect(padding.padding, const EdgeInsets.all(20));
    });

    testWidgets('regression: the app leg reaches the surface', (tester) async {
      // The old container read only `theme ?? ComponentTheme.maybeOf`, so an
      // app-wide `TooltipTheme` never applied.
      await tester.pumpWidget(
        _frame(
          const TooltipContainer(child: Text('hi')),
          app: const <ComponentThemeData>[
            TooltipTheme(background: ThemedColor.value(_green)),
          ],
        ),
      );
      expect(_containerDecoration(tester).color, _green);
    });
  });

  group('tokens', () {
    for (final (String name, ShadcnColors colors) in <(String, ShadcnColors)>[
      ('light', ShadcnColors.lightFallback),
      ('dark', ShadcnColors.darkFallback),
    ]) {
      testWidgets('$name tokens drive the surface', (tester) async {
        await tester.pumpWidget(
          _frame(
            const TooltipContainer(child: Text('hi')),
            data: ShadcnThemeData(colors: colors),
          ),
        );
        expect(_containerDecoration(tester).color, colors.primary);
        final DefaultTextStyle style = tester.widget<DefaultTextStyle>(
          find.byType(DefaultTextStyle),
        );
        expect(style.style.color, colors.primaryForeground);
      });
    }
  });

  group('theme precedence', () {
    testWidgets('the widget leg wins over everything', (tester) async {
      await tester.pumpWidget(
        _frame(
          const TooltipContainer(
            theme: TooltipTheme(background: ThemedColor.value(_green)),
            child: Text('hi'),
          ),
          app: const <ComponentThemeData>[
            TooltipTheme(background: ThemedColor.value(_blue)),
          ],
          scoped: const TooltipTheme(
            background: ThemedColor.value(Color(0xFF123456)),
          ),
        ),
      );
      expect(_containerDecoration(tester).color, _green);
    });

    testWidgets('the scoped leg wins over the app leg', (tester) async {
      await tester.pumpWidget(
        _frame(
          const TooltipContainer(child: Text('hi')),
          app: const <ComponentThemeData>[
            TooltipTheme(background: ThemedColor.value(_blue)),
          ],
          scoped: const TooltipTheme(background: ThemedColor.value(_green)),
        ),
      );
      expect(_containerDecoration(tester).color, _green);
    });

    testWidgets('the app leg wins over the defaults', (tester) async {
      await tester.pumpWidget(
        _frame(
          const TooltipContainer(child: Text('hi')),
          app: const <ComponentThemeData>[
            TooltipTheme(background: ThemedColor.value(_green)),
          ],
        ),
      );
      expect(_containerDecoration(tester).color, _green);
    });

    testWidgets('a leg that sets only the fill keeps the default text', (
      tester,
    ) async {
      await tester.pumpWidget(
        _frame(
          const TooltipContainer(child: Text('hi')),
          app: const <ComponentThemeData>[
            TooltipTheme(background: ThemedColor.value(_green)),
          ],
        ),
      );
      final DefaultTextStyle style = tester.widget<DefaultTextStyle>(
        find.byType(DefaultTextStyle),
      );
      expect(style.style.fontSize, 12);
    });
  });

  group('overlay handler', () {
    testWidgets('routes the presentation to the tooltip handler', (
      tester,
    ) async {
      await tester.pumpWidget(
        _frame(
          Tooltip(
            waitDuration: Duration.zero,
            child: const _AnchorBox(),
            tooltip: (context) => const Text('hi'),
          ),
          tooltipHandler: OverlayHandler.popover,
        ),
      );
      await _hover(tester, find.byType(Tooltip));
      expect(find.byType(TooltipContainer), findsOneWidget);
    });

    testWidgets('regression: the theme stays live while open', (tester) async {
      // The overlay must capture the theme at show time and re-resolve it, so
      // a light -> dark switch repaints an open tooltip. A hand-rolled handler
      // (the old `FixedTooltipOverlayHandler`) can easily forget to.
      final ValueNotifier<ShadcnThemeData> switcher =
          ValueNotifier<ShadcnThemeData>(
            const ShadcnThemeData(colors: ShadcnColors.lightFallback),
          );
      addTearDown(switcher.dispose);
      await tester.pumpWidget(
        _frame(
          Tooltip(
            waitDuration: Duration.zero,
            child: const _AnchorBox(),
            tooltip: (context) => const Text('hi'),
          ),
          theme: switcher,
        ),
      );
      await _hover(tester, find.byType(Tooltip));
      expect(find.byType(TooltipContainer), findsOneWidget);
      expect(
        _containerDecoration(tester).color,
        ShadcnColors.lightFallback.primary,
      );

      // Switch the tokens without rebuilding the overlay: the captured theme
      // must re-resolve into the open popover.
      switcher.value = const ShadcnThemeData(colors: ShadcnColors.darkFallback);
      await tester.pump();
      await tester.pump();
      expect(find.byType(TooltipContainer), findsOneWidget);
      expect(
        _containerDecoration(tester).color,
        ShadcnColors.darkFallback.primary,
      );
    });
  });
}
