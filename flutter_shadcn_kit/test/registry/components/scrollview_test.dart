// Widget tests for the `scrollview` component.
//
// Covers the enabled/disabled surface, the middle-button autoscroll gesture
// and the two old regressions: a release without movement left the ticker
// running, and disabling the widget mid-drag kept the cursor overlay.

import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_shadcn_kit/registry/components/scrollview/scrollview.dart';
import 'package:flutter_shadcn_kit/registry/theme/theme.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _frame({required Widget child, bool enabled = true}) {
  return ShadcnTheme(
    data: const ShadcnThemeData(),
    child: Directionality(
      textDirection: TextDirection.ltr,
      child: Center(
        child: SizedBox(
          width: 300,
          height: 200,
          child: ScrollViewInterceptor(enabled: enabled, child: child),
        ),
      ),
    ),
  );
}

Widget _list(ScrollController controller) {
  return ListView.builder(
    controller: controller,
    itemCount: 60,
    itemBuilder: (context, index) =>
        SizedBox(height: 24, child: Text('row $index')),
  );
}

Finder _scrollCursor() => find.byWidgetPredicate(
  (Widget widget) =>
      widget is MouseRegion && widget.cursor == SystemMouseCursors.allScroll,
);

void main() {
  testWidgets('renders the child while enabled', (tester) async {
    await tester.pumpWidget(_frame(child: const Text('content')));
    expect(find.text('content'), findsOneWidget);
    expect(find.byType(Listener), findsOneWidget);
  });

  testWidgets('disabled passes the child through untouched', (tester) async {
    await tester.pumpWidget(
      _frame(child: const Text('content'), enabled: false),
    );
    expect(find.text('content'), findsOneWidget);
    expect(find.byType(Stack), findsNothing);
    expect(find.byType(Listener), findsNothing);
  });

  testWidgets('middle-button drag scrolls the list', (tester) async {
    final ScrollController controller = ScrollController();
    addTearDown(controller.dispose);
    await tester.pumpWidget(_frame(child: _list(controller)));

    final Offset center = tester.getCenter(find.byType(ListView));
    final TestGesture gesture = await tester.createGesture(
      kind: PointerDeviceKind.mouse,
      buttons: kMiddleMouseButton,
    );
    await gesture.addPointer(location: center);
    addTearDown(gesture.removePointer);
    await gesture.down(center);
    await gesture.moveBy(const Offset(0, 200));
    for (int frame = 0; frame < 4; frame++) {
      await tester.pump(const Duration(milliseconds: 16));
    }
    expect(controller.offset, greaterThan(0));
    expect(_scrollCursor(), findsOneWidget);

    await gesture.up();
    await tester.pump();
    expect(_scrollCursor(), findsNothing);
  });

  testWidgets('regression: release without movement ends the drag', (
    tester,
  ) async {
    final ScrollController controller = ScrollController();
    addTearDown(controller.dispose);
    await tester.pumpWidget(_frame(child: _list(controller)));

    final Offset center = tester.getCenter(find.byType(ListView));
    final TestGesture gesture = await tester.createGesture(
      kind: PointerDeviceKind.mouse,
      buttons: kMiddleMouseButton,
    );
    await gesture.addPointer(location: center);
    addTearDown(gesture.removePointer);
    await gesture.down(center);
    await tester.pump(const Duration(milliseconds: 16));
    expect(_scrollCursor(), findsOneWidget);

    await gesture.up();
    await tester.pump();
    expect(_scrollCursor(), findsNothing);
    // The old code kept the ticker running here, so later frames kept
    // dispatching scroll events at the anchor.
    await tester.pump(const Duration(milliseconds: 32));
    await tester.pump(const Duration(milliseconds: 32));
    expect(controller.offset, 0);
  });

  testWidgets('regression: disabling mid-drag ends the drag', (tester) async {
    final ScrollController controller = ScrollController();
    addTearDown(controller.dispose);
    await tester.pumpWidget(_frame(child: _list(controller)));

    final Offset center = tester.getCenter(find.byType(ListView));
    final TestGesture gesture = await tester.createGesture(
      kind: PointerDeviceKind.mouse,
      buttons: kMiddleMouseButton,
    );
    await gesture.addPointer(location: center);
    addTearDown(gesture.removePointer);
    await gesture.down(center);
    await tester.pump(const Duration(milliseconds: 16));
    expect(_scrollCursor(), findsOneWidget);

    await tester.pumpWidget(_frame(child: _list(controller), enabled: false));
    await tester.pump();
    expect(_scrollCursor(), findsNothing);

    await gesture.up();
    await tester.pump();
  });

  testWidgets('primary-button drag does not activate autoscroll', (
    tester,
  ) async {
    final ScrollController controller = ScrollController();
    addTearDown(controller.dispose);
    await tester.pumpWidget(_frame(child: _list(controller)));

    final Offset center = tester.getCenter(find.byType(ListView));
    final TestGesture gesture = await tester.createGesture(
      kind: PointerDeviceKind.mouse,
    );
    await gesture.addPointer(location: center);
    addTearDown(gesture.removePointer);
    await gesture.down(center);
    await gesture.moveBy(const Offset(0, 120));
    await tester.pump(const Duration(milliseconds: 16));
    expect(_scrollCursor(), findsNothing);

    await gesture.up();
    await tester.pump();
  });
}
