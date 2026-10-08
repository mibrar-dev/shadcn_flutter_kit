// Widget tests for the `toast` component.
//
// Covers: rendering through a controller and through `showToast`, auto-dismiss,
// pause/resume, the close button, swipe-to-dismiss, placement, the four theme
// legs and the multi-toast slot pause policy.

import 'package:flutter/widgets.dart';
import 'package:flutter_shadcn_kit/registry_next/components/toast/toast.dart';
import 'package:flutter_shadcn_kit/registry_next/primitives/toast_queue/toast_entry.dart';
import 'package:flutter_shadcn_kit/registry_next/primitives/toast_queue/toast_queue.dart';
import 'package:flutter_shadcn_kit/registry_next/theme/color_tokens.dart';
import 'package:flutter_shadcn_kit/registry_next/theme/theme.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _frame(
  ToastController controller, {
  ShadcnThemeData data = const ShadcnThemeData(),
  List<ComponentThemeData> app = const <ComponentThemeData>[],
  Widget? child,
}) {
  return ShadcnTheme(
    data: data,
    child: ComponentThemes(
      themes: app,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: SizedBox(
          width: 400,
          height: 400,
          child: ToastLayer(
            controller: controller,
            child: child ?? const SizedBox.expand(),
          ),
        ),
      ),
    ),
  );
}

Color? _cardColor(WidgetTester tester) {
  final DecoratedBox box = tester.widget<DecoratedBox>(
    find
        .descendant(
          of: find.byType(ToastLayer),
          matching: find.byType(DecoratedBox),
        )
        .first,
  );
  return (box.decoration as BoxDecoration).color;
}

/// Clears the queue (exit phase + removal) before the test ends.
Future<void> _clear(WidgetTester tester, ToastController controller) async {
  controller.dismissAll();
  for (final entry in controller.entries.toList()) {
    controller.remove(entry.id);
  }
  await tester.pump();
}

void main() {
  const ShadcnColors colors = ShadcnColors.lightFallback;

  testWidgets('renders only the child when there are no toasts', (
    tester,
  ) async {
    final controller = ToastController();
    addTearDown(controller.dispose);
    await tester.pumpWidget(_frame(controller));
    expect(find.byType(Stack), findsNothing);
  });

  testWidgets('a controller toast renders a card', (tester) async {
    final controller = ToastController();
    addTearDown(controller.dispose);
    await tester.pumpWidget(_frame(controller));
    controller.showToast(builder: (context) => const Text('Saved'));
    await tester.pump();
    expect(find.text('Saved'), findsOneWidget);
    await _clear(tester, controller);
  });

  testWidgets('showToast resolves the nearest layer', (tester) async {
    final controller = ToastController();
    addTearDown(controller.dispose);
    late BuildContext context;
    await tester.pumpWidget(
      _frame(
        controller,
        child: Builder(
          builder: (BuildContext ctx) {
            context = ctx;
            return const SizedBox.expand();
          },
        ),
      ),
    );
    showToast(context, builder: (context) => const Text('Via context'));
    await tester.pump();
    expect(find.text('Via context'), findsOneWidget);
    expect(toastControllerOf(context), controller);
    await _clear(tester, controller);
  });

  testWidgets('auto-dismisses after the duration', (tester) async {
    final controller = ToastController();
    addTearDown(controller.dispose);
    await tester.pumpWidget(_frame(controller));
    controller.showToast(
      builder: (context) => const Text('Gone'),
      duration: const Duration(milliseconds: 100),
    );
    await tester.pump();
    expect(find.text('Gone'), findsOneWidget);
    await tester.pump(const Duration(milliseconds: 120));
    await tester.pumpAndSettle();
    expect(find.text('Gone'), findsNothing);
  });

  testWidgets('interaction pauses and resumes the countdown', (tester) async {
    final controller = ToastController();
    addTearDown(controller.dispose);
    await tester.pumpWidget(_frame(controller));
    final id = controller.showToast(
      builder: (context) => const Text('Held'),
      duration: const Duration(milliseconds: 100),
    );
    await tester.pump();
    controller.setInteracting(id, true);
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('Held'), findsOneWidget);
    controller.setInteracting(id, false);
    await tester.pump(const Duration(milliseconds: 120));
    await tester.pumpAndSettle();
    expect(find.text('Held'), findsNothing);
  });

  testWidgets('the close button dismisses the toast', (tester) async {
    final controller = ToastController();
    addTearDown(controller.dispose);
    await tester.pumpWidget(_frame(controller));
    controller.showToast(builder: (context) => const Text('Closable'));
    await tester.pump();
    await tester.tap(find.byType(Icon).first);
    await tester.pumpAndSettle();
    expect(find.text('Closable'), findsNothing);
  });

  testWidgets('a horizontal swipe dismisses a trailing toast', (tester) async {
    final controller = ToastController();
    addTearDown(controller.dispose);
    await tester.pumpWidget(_frame(controller));
    controller.showToast(
      placement: ToastPlacement.bottomTrailing,
      builder: (context) => const Text('Swipe me'),
    );
    await tester.pump();
    await tester.drag(find.text('Swipe me'), const Offset(200, 0));
    await tester.pumpAndSettle();
    expect(find.text('Swipe me'), findsNothing);
  });

  testWidgets('placement anchors the stack to the requested edge', (
    tester,
  ) async {
    final controller = ToastController();
    addTearDown(controller.dispose);
    await tester.pumpWidget(_frame(controller));
    controller.showToast(
      placement: ToastPlacement.topCenter,
      builder: (context) => const Text('Top'),
    );
    await tester.pump();
    final Positioned positioned = tester.widget<Positioned>(
      find
          .descendant(
            of: find.byType(ToastLayer),
            matching: find.byType(Positioned),
          )
          .first,
    );
    expect(positioned.top, isNotNull);
    expect(positioned.bottom, 0);
    await _clear(tester, controller);
  });

  testWidgets('two toasts in a slot pause the older one', (tester) async {
    final controller = ToastController(singlePerSlot: false);
    addTearDown(controller.dispose);
    await tester.pumpWidget(_frame(controller));
    controller.showToast(
      placement: ToastPlacement.bottomTrailing,
      builder: (context) => const Text('Older'),
    );
    controller.showToast(
      placement: ToastPlacement.bottomTrailing,
      builder: (context) => const Text('Newer'),
    );
    await tester.pump();
    final List<ToastEntry<ToastBuilder>> live = controller.entriesIn(
      const ToastSlot(ToastPlacement.bottomTrailing),
    );
    expect(live, hasLength(2));
    expect(live.last.isPaused, isTrue);
    expect(live.first.isPaused, isFalse);
    await _clear(tester, controller);
  });

  testWidgets('theme precedence: defaults < app < scoped < widget', (
    tester,
  ) async {
    const red = Color(0xFFFF0000);
    const green = Color(0xFF00FF00);
    const blue = Color(0xFF0000FF);
    final controller = ToastController();
    addTearDown(controller.dispose);
    controller.showToast(builder: (context) => const Text('Themed'));

    Future<void> pumpWith(ToastTheme? widgetTheme) async {
      await tester.pumpWidget(
        ShadcnTheme(
          data: const ShadcnThemeData(),
          child: ComponentThemes(
            themes: const <ComponentThemeData>[
              ToastTheme(background: ThemedColor.value(red)),
            ],
            child: Directionality(
              textDirection: TextDirection.ltr,
              child: SizedBox(
                width: 400,
                height: 400,
                child: ComponentTheme<ToastTheme>(
                  data: const ToastTheme(background: ThemedColor.value(green)),
                  child: ToastLayer(
                    controller: controller,
                    theme: widgetTheme,
                    child: const SizedBox.expand(),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pump();
    }

    await pumpWith(null);
    expect(_cardColor(tester), green);

    await pumpWith(const ToastTheme(background: ThemedColor.value(blue)));
    expect(_cardColor(tester), blue);
    await _clear(tester, controller);
  });

  testWidgets('dark tokens drive the card', (tester) async {
    const ShadcnThemeData dark = ShadcnThemeData(
      colors: ShadcnColors.darkFallback,
    );
    final controller = ToastController();
    addTearDown(controller.dispose);
    await tester.pumpWidget(_frame(controller, data: dark));
    controller.showToast(builder: (context) => const Text('Dark'));
    await tester.pump();
    expect(_cardColor(tester), dark.colors.popover);
    expect(_cardColor(tester), isNot(colors.popover));
    await _clear(tester, controller);
  });

  testWidgets('a dismissed toast animates out before removal', (tester) async {
    final controller = ToastController();
    addTearDown(controller.dispose);
    await tester.pumpWidget(_frame(controller));
    final String id = controller.showToast(
      builder: (context) => const Text('Leaving'),
    );
    await tester.pump();
    controller.dismiss(id);
    await tester.pump();
    // Still mounted, in its exit phase; the queue has not removed it.
    expect(find.text('Leaving'), findsOneWidget);
    expect(controller.entryOf(id)!.isExiting, isTrue);
    expect(controller.contains(id), isTrue);
    await tester.pump(const Duration(milliseconds: 100));
    expect(
      find.byWidgetPredicate(
        (Widget widget) =>
            widget is FadeTransition && widget.opacity.value < 1.0,
      ),
      findsWidgets,
    );
    await tester.pumpAndSettle();
    expect(find.text('Leaving'), findsNothing);
    expect(controller.contains(id), isFalse);
  });

  testWidgets('remaining toasts animate into their new positions', (
    tester,
  ) async {
    final controller = ToastController(singlePerSlot: false);
    addTearDown(controller.dispose);
    await tester.pumpWidget(_frame(controller));
    controller.showToast(
      placement: ToastPlacement.topLeading,
      builder: (context) => const Text('Older'),
    );
    final String newer = controller.showToast(
      placement: ToastPlacement.topLeading,
      builder: (context) => const Text('Newer'),
    );
    await tester.pump();
    final double before = tester.getTopLeft(find.text('Older')).dy;
    controller.dismiss(newer);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    final double mid = tester.getTopLeft(find.text('Older')).dy;
    await tester.pumpAndSettle();
    final double after = tester.getTopLeft(find.text('Older')).dy;
    // The newer card collapses and pulls the older one towards the edge.
    expect(mid, lessThan(before));
    expect(mid, greaterThan(after));
    expect(after, lessThan(before));
    await _clear(tester, controller);
  });

  testWidgets('disableAnimations removes the toast without animating', (
    tester,
  ) async {
    final controller = ToastController();
    addTearDown(controller.dispose);
    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(disableAnimations: true),
        child: _frame(controller),
      ),
    );
    final String id = controller.showToast(
      builder: (context) => const Text('Gone'),
    );
    await tester.pump();
    controller.dismiss(id);
    await tester.pump();
    await tester.pump();
    expect(find.text('Gone'), findsNothing);
    expect(controller.contains(id), isFalse);
  });
}
