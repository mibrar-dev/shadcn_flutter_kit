import 'package:flutter/material.dart';
import 'package:flutter_shadcn_kit/flutter_shadcn_kit.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Future<(GooeyToastController, BuildContext)> pumpToastHost(
    WidgetTester tester, {
    GooeyToastController? controller,
  }) async {
    final resolvedController = controller ?? GooeyToastController();
    late BuildContext capturedContext;
    await tester.pumpWidget(
      ShadcnApp(
        home: Overlay(
          initialEntries: [
            OverlayEntry(
              builder: (context) => Builder(
                builder: (context) {
                  capturedContext = context;
                  return const Center(child: Text('host'));
                },
              ),
            ),
          ],
        ),
      ),
    );
    await tester.pumpAndSettle();
    return (resolvedController, capturedContext);
  }

  testWidgets('limits visible toasts by maxVisibleCount', (tester) async {
    final (controller, context) = await pumpToastHost(tester);

    for (final title in ['first', 'second', 'third']) {
      controller.show(
        context: context,
        title: title,
        persistUntilDismissed: true,
        maxVisibleCount: 2,
        enableGooeyBlur: false,
      );
    }
    await tester.pump();

    expect(find.text('third'), findsOneWidget);
    expect(find.text('second'), findsOneWidget);
    expect(find.text('first'), findsNothing);
  });

  testWidgets('uses overlapStackOffset when overlap stacking is enabled', (
    tester,
  ) async {
    final (controller, context) = await pumpToastHost(tester);

    controller.show(
      context: context,
      title: 'first',
      persistUntilDismissed: true,
      overlapStackWhenMultiple: true,
      overlapStackOffset: 4,
      enableGooeyBlur: false,
    );
    controller.show(
      context: context,
      title: 'second',
      persistUntilDismissed: true,
      overlapStackWhenMultiple: true,
      overlapStackOffset: 4,
      enableGooeyBlur: false,
    );
    await tester.pumpAndSettle();

    final firstTop = tester.getTopLeft(find.text('first')).dy;
    final secondTop = tester.getTopLeft(find.text('second')).dy;

    expect((firstTop - secondTop).abs(), closeTo(4, 0.5));
  });

  testWidgets('can dismiss a whole visible stack from a swipe', (tester) async {
    final (controller, context) = await pumpToastHost(tester);

    controller.show(
      context: context,
      title: 'first',
      persistUntilDismissed: true,
      dismissWholeStackWhenMultiple: true,
      dismissDirections: {GooeyToastSwipeDirection.right},
      enableGooeyBlur: false,
    );
    controller.show(
      context: context,
      title: 'second',
      persistUntilDismissed: true,
      dismissWholeStackWhenMultiple: true,
      dismissDirections: {GooeyToastSwipeDirection.right},
      enableGooeyBlur: false,
    );
    await tester.pump();

    await tester.drag(find.text('second'), const Offset(90, 0));
    await tester.pump();

    expect(controller.activeToasts, isEmpty);
    expect(find.text('first'), findsNothing);
    expect(find.text('second'), findsNothing);
  });

  testWidgets('pauses auto-dismiss while multiple toasts share a region', (
    tester,
  ) async {
    final (controller, context) = await pumpToastHost(tester);

    controller.show(
      context: context,
      id: 'first',
      title: 'first',
      duration: const Duration(milliseconds: 120),
      pauseAutoDismissWhenMultiple: true,
      enableGooeyBlur: false,
    );
    await tester.pump(const Duration(milliseconds: 60));
    controller.show(
      context: context,
      id: 'second',
      title: 'second',
      duration: const Duration(milliseconds: 600),
      pauseAutoDismissWhenMultiple: true,
      enableGooeyBlur: false,
    );
    await tester.pump(const Duration(milliseconds: 240));

    expect(controller.containsToast('first'), isTrue);
    expect(controller.containsToast('second'), isTrue);

    controller.dismiss('second');
    await tester.pump(const Duration(milliseconds: 150));

    expect(controller.containsToast('first'), isFalse);
  });
}
