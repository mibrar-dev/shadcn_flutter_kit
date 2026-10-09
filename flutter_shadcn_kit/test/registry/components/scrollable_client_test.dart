// Widget tests for the `scrollable_client` component.
//
// Covers the builder contract (offset + viewport size), drag scrolling, the
// four theme-precedence legs through the observable `overscroll` behaviour,
// and the old regression: a content child smaller than the viewport produced
// a negative clamp that pushed the child out of the viewport.

import 'package:flutter/widgets.dart';
import 'package:flutter_shadcn_kit/registry/components/scrollable_client/scrollable_client.dart';
import 'package:flutter_shadcn_kit/registry/theme/theme.dart';
import 'package:flutter_test/flutter_test.dart';

const Size _viewportSize = Size(300, 200);

Widget _frame({
  required Widget client,
  List<ComponentThemeData> app = const <ComponentThemeData>[],
  ScrollableClientTheme? scoped,
}) {
  Widget body = client;
  if (scoped != null) {
    body = ComponentTheme<ScrollableClientTheme>(data: scoped, child: body);
  }
  return ShadcnTheme(
    data: const ShadcnThemeData(),
    child: ComponentThemes(
      themes: app,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Center(
          child: SizedBox(
            width: _viewportSize.width,
            height: _viewportSize.height,
            child: body,
          ),
        ),
      ),
    ),
  );
}

void main() {
  testWidgets('builder receives the initial offset and viewport size', (
    tester,
  ) async {
    Offset? lastOffset;
    Size? lastViewport;
    await tester.pumpWidget(
      _frame(
        client: ScrollableClient(
          builder: (context, offset, viewportSize, child) {
            lastOffset = offset;
            lastViewport = viewportSize;
            return child!;
          },
          child: const SizedBox(width: 640, height: 420),
        ),
      ),
    );

    expect(lastOffset, Offset.zero);
    expect(lastViewport, _viewportSize);
  });

  testWidgets('drag scrolling updates the offset the builder sees', (
    tester,
  ) async {
    Offset? lastOffset;
    await tester.pumpWidget(
      _frame(
        client: ScrollableClient(
          builder: (context, offset, viewportSize, child) {
            lastOffset = offset;
            return child!;
          },
          child: const SizedBox(width: 640, height: 420),
        ),
      ),
    );

    await tester.drag(find.byType(ScrollableClient), const Offset(0, -80));
    await tester.pump();
    expect(lastOffset!.dy, greaterThan(0));
  });

  testWidgets('defaults clamp the offset at the content edges', (tester) async {
    final ScrollController controller = ScrollController();
    addTearDown(controller.dispose);
    final GlobalKey childKey = GlobalKey();
    await tester.pumpWidget(
      _frame(
        client: ScrollableClient(
          verticalDetails: ScrollableDetails.vertical(controller: controller),
          builder: (context, offset, viewportSize, child) => child!,
          child: SizedBox(key: childKey, width: 640, height: 420),
        ),
      ),
    );

    final Offset origin = tester.getTopLeft(find.byType(ScrollableClient));
    expect(tester.getTopLeft(find.byKey(childKey)), origin);

    controller.jumpTo(-20);
    await tester.pump();
    expect(tester.getTopLeft(find.byKey(childKey)), origin);
  });

  testWidgets('all four theme legs drive the overscroll behaviour', (
    tester,
  ) async {
    Future<void> expectShift(
      WidgetTester tester, {
      required bool shifted,
      List<ComponentThemeData> app = const <ComponentThemeData>[],
      ScrollableClientTheme? scoped,
      ScrollableClientTheme? widgetTheme,
    }) async {
      final ScrollController controller = ScrollController();
      addTearDown(controller.dispose);
      final GlobalKey childKey = GlobalKey();
      await tester.pumpWidget(
        _frame(
          app: app,
          scoped: scoped,
          client: ScrollableClient(
            verticalDetails: ScrollableDetails.vertical(controller: controller),
            theme: widgetTheme,
            builder: (context, offset, viewportSize, child) => child!,
            child: SizedBox(key: childKey, width: 640, height: 420),
          ),
        ),
      );
      final Offset origin = tester.getTopLeft(find.byType(ScrollableClient));
      controller.jumpTo(-20);
      await tester.pump();
      final Offset current = tester.getTopLeft(find.byKey(childKey));
      expect(current.dy - origin.dy, shifted ? 20 : 0);
    }

    // Defaults (false): clamped.
    await expectShift(tester, shifted: false);
    // App leg (true): shifted.
    await expectShift(
      tester,
      shifted: true,
      app: <ComponentThemeData>[const ScrollableClientTheme(overscroll: true)],
    );
    // Scoped leg (false) overrides the app leg.
    await expectShift(
      tester,
      shifted: false,
      app: <ComponentThemeData>[const ScrollableClientTheme(overscroll: true)],
      scoped: const ScrollableClientTheme(overscroll: false),
    );
    // Widget leg (true) overrides the scoped leg.
    await expectShift(
      tester,
      shifted: true,
      app: <ComponentThemeData>[const ScrollableClientTheme(overscroll: true)],
      scoped: const ScrollableClientTheme(overscroll: false),
      widgetTheme: const ScrollableClientTheme(overscroll: true),
    );
  });

  testWidgets('regression: content smaller than the viewport stays put', (
    tester,
  ) async {
    final ScrollController controller = ScrollController();
    addTearDown(controller.dispose);
    final GlobalKey childKey = GlobalKey();
    await tester.pumpWidget(
      _frame(
        client: ScrollableClient(
          verticalDetails: ScrollableDetails.vertical(controller: controller),
          builder: (context, offset, viewportSize, child) => child!,
          child: SizedBox(key: childKey, width: 100, height: 80),
        ),
      ),
    );

    final Offset origin = tester.getTopLeft(find.byType(ScrollableClient));
    // The old clamp produced max = content - viewport = -120 and pushed the
    // child 120 px down when the offset was non-zero.
    controller.jumpTo(50);
    await tester.pump();
    expect(tester.getTopLeft(find.byKey(childKey)), origin);
  });

  testWidgets('regression: swapping the child rebuilds the viewport', (
    tester,
  ) async {
    // The old ScrollableClientViewport only overrode createRenderObject, so
    // the render object kept its first delegate and never rebuilt the child.
    Widget build(GlobalKey childKey) {
      return _frame(
        client: ScrollableClient(
          builder: (context, offset, viewportSize, child) => child!,
          child: SizedBox(key: childKey, width: 640, height: 420),
        ),
      );
    }

    final GlobalKey firstKey = GlobalKey();
    await tester.pumpWidget(build(firstKey));
    expect(find.byKey(firstKey), findsOneWidget);

    final GlobalKey secondKey = GlobalKey();
    await tester.pumpWidget(build(secondKey));
    expect(find.byKey(secondKey), findsOneWidget);
    expect(find.byKey(firstKey), findsNothing);
  });
}
