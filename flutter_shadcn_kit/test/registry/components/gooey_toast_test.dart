// Widget tests for the `gooey_toast` component.
//
// Covers: rendering, states, anchoring, autopilot, hover/press pause, swipe,
// auto-dismiss, persistence, stack behaviours, the four theme legs, live
// theme changes, small viewports and real sizes. Keyboard behaviour is not
// applicable: a toast is not a focusable control (matching the `toast`
// component), only its action chip is tappable.

import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_shadcn_kit/registry/components/gooey_toast/gooey_toast.dart';
import 'package:flutter_shadcn_kit/registry/foundation/icons/lucide_icons.dart';
import 'package:flutter_shadcn_kit/registry/primitives/gooey/gooey_content.dart';
import 'package:flutter_shadcn_kit/registry/primitives/gooey/gooey_shape.dart';
import 'package:flutter_shadcn_kit/registry/primitives/gooey/gooey_surface.dart';
import 'package:flutter_shadcn_kit/registry/primitives/toast_queue/toast_entry.dart';
import 'package:flutter_shadcn_kit/registry/primitives/toast_queue/toast_placement.dart';
import 'package:flutter_shadcn_kit/registry/theme/color_tokens.dart';
import 'package:flutter_shadcn_kit/registry/theme/theme.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _frame(
  GooeyToastController controller, {
  ShadcnThemeData data = const ShadcnThemeData(),
  List<ComponentThemeData> app = const <ComponentThemeData>[],
  GooeyToastTheme? theme,
  Widget? child,
  Size size = const Size(400, 400),
}) {
  return ShadcnTheme(
    data: data,
    child: ComponentThemes(
      themes: app,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Align(
          alignment: Alignment.topLeft,
          child: SizedBox(
            width: size.width,
            height: size.height,
            child: GooeyToastLayer(
              controller: controller,
              theme: theme,
              child: child ?? const SizedBox.expand(),
            ),
          ),
        ),
      ),
    ),
  );
}

GooeyToastOptions _options({
  String title = 'Saved',
  String? description,
  GooeyToastState state = GooeyToastState.success,
  GooeyToastPosition position = GooeyToastPosition.left,
  GooeyToastExpandDirection direction = GooeyToastExpandDirection.bottom,
  Duration? duration,
  GooeyAutopilot? autopilot = const GooeyAutopilot(),
  GooeyToastAction? action,
  IconData? icon,
  Widget? expandedChild,
  bool persist = false,
}) {
  return GooeyToastOptions(
    title: title,
    description: description,
    state: state,
    position: position,
    expandDirection: direction,
    duration: duration,
    autopilot: autopilot,
    action: action,
    icon: icon,
    expandedChild: expandedChild,
    persistUntilDismissed: persist,
  );
}

Color? _fillColor(WidgetTester tester) {
  return tester
      .widget<GooeyShapeLayer>(find.byType(GooeyShapeLayer).first)
      .color;
}

Size _surfaceSize(WidgetTester tester) =>
    tester.getSize(find.byType(GooeySurface).first);

Future<void> _clear(
  WidgetTester tester,
  GooeyToastController controller,
) async {
  controller.dismissAll();
  for (final entry in controller.entries.toList()) {
    controller.remove(entry.id);
  }
  await tester.pump();
}

void main() {
  const ShadcnColors light = ShadcnColors.lightFallback;

  testWidgets('renders only the child when there are no toasts', (
    tester,
  ) async {
    final controller = GooeyToastController();
    addTearDown(controller.dispose);
    await tester.pumpWidget(_frame(controller));
    expect(find.byType(GooeySurface), findsNothing);
  });

  testWidgets('renders a 350x40 pill with a 24x24 state icon', (tester) async {
    final controller = GooeyToastController();
    addTearDown(controller.dispose);
    await tester.pumpWidget(_frame(controller));
    controller.showGooeyToast(_options(title: 'Saved'));
    await tester.pump();
    expect(find.text('Saved'), findsOneWidget);
    expect(_surfaceSize(tester), const Size(350, 40));
    expect(
      tester.getSize(find.byType(GooeyStateIcon).first),
      const Size(24, 24),
    );
    expect(find.byIcon(LucideIcons.check), findsOneWidget);
    await _clear(tester, controller);
  });

  testWidgets('each state renders its icon', (tester) async {
    final controller = GooeyToastController();
    addTearDown(controller.dispose);
    await tester.pumpWidget(_frame(controller));
    const Map<GooeyToastState, IconData> icons = <GooeyToastState, IconData>{
      GooeyToastState.success: LucideIcons.check,
      GooeyToastState.loading: LucideIcons.loaderCircle,
      GooeyToastState.error: LucideIcons.x,
      GooeyToastState.warning: LucideIcons.triangleAlert,
      GooeyToastState.info: LucideIcons.info,
      GooeyToastState.action: LucideIcons.arrowRight,
    };
    for (final MapEntry<GooeyToastState, IconData> entry in icons.entries) {
      final String id = controller.showGooeyToast(
        _options(title: entry.key.name, state: entry.key),
      );
      await tester.pump();
      expect(find.byIcon(entry.value), findsOneWidget, reason: entry.key.name);
      controller.remove(id);
      await tester.pump();
    }
  });

  testWidgets('positions anchor the surface to the requested edge', (
    tester,
  ) async {
    final controller = GooeyToastController();
    addTearDown(controller.dispose);
    await tester.pumpWidget(_frame(controller));
    const Map<GooeyToastPosition, Offset> expected =
        <GooeyToastPosition, Offset>{
          GooeyToastPosition.left: Offset(16, 16),
          GooeyToastPosition.center: Offset(25, 16),
          GooeyToastPosition.right: Offset(34, 16),
        };
    for (final MapEntry<GooeyToastPosition, Offset> entry in expected.entries) {
      final String id = controller.showGooeyToast(
        _options(position: entry.key, title: entry.key.name),
      );
      await tester.pump();
      expect(
        tester.getTopLeft(find.byType(GooeySurface).first),
        entry.value,
        reason: entry.key.name,
      );
      controller.remove(id);
      await tester.pump();
    }
    final String bottomId = controller.showGooeyToast(
      _options(
        position: GooeyToastPosition.right,
        direction: GooeyToastExpandDirection.top,
      ),
    );
    await tester.pump();
    expect(
      tester.getTopLeft(find.byType(GooeySurface).first),
      const Offset(34, 344),
    );
    controller.remove(bottomId);
    await tester.pump();
  });

  testWidgets('autopilot expands then collapses', (tester) async {
    final controller = GooeyToastController();
    addTearDown(controller.dispose);
    await tester.pumpWidget(_frame(controller));
    controller.showGooeyToast(
      _options(description: 'Body copy', duration: const Duration(minutes: 5)),
    );
    await tester.pump();
    expect(_surfaceSize(tester).height, 40);
    await tester.pump(const Duration(milliseconds: 200));
    await tester.pump(const Duration(milliseconds: 700));
    await tester.pump(const Duration(milliseconds: 300));
    expect(_surfaceSize(tester).height, greaterThan(40));
    await tester.pump(const Duration(milliseconds: 3000));
    await tester.pump(const Duration(milliseconds: 700));
    await tester.pump(const Duration(milliseconds: 300));
    expect(_surfaceSize(tester).height, 40);
    await _clear(tester, controller);
  });

  testWidgets('hover expands and pauses the countdown', (tester) async {
    final controller = GooeyToastController();
    addTearDown(controller.dispose);
    await tester.pumpWidget(_frame(controller));
    final String id = controller.showGooeyToast(
      _options(
        description: 'Body copy',
        duration: const Duration(milliseconds: 300),
      ),
    );
    await tester.pump();
    final TestGesture mouse = await tester.createGesture(
      kind: PointerDeviceKind.mouse,
    );
    addTearDown(mouse.removePointer);
    await mouse.addPointer(location: Offset.zero);
    await mouse.moveTo(tester.getCenter(find.byType(GooeySurface).first));
    await tester.pump();
    expect(controller.entryOf(id)!.isPaused, isTrue);
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.text('Saved'), findsOneWidget);
    await mouse.moveTo(const Offset(799, 599));
    await tester.pump();
    expect(controller.entryOf(id)!.isPaused, isFalse);
    await tester.pump(const Duration(milliseconds: 400));
    expect(controller.entryOf(id)!.isExiting, isTrue);
    await tester.pumpAndSettle();
    expect(find.text('Saved'), findsNothing);
  });

  testWidgets('pointer down pauses the countdown', (tester) async {
    final controller = GooeyToastController();
    addTearDown(controller.dispose);
    await tester.pumpWidget(_frame(controller));
    final String id = controller.showGooeyToast(
      _options(duration: const Duration(milliseconds: 300)),
    );
    await tester.pump();
    final TestGesture gesture = await tester.startGesture(
      tester.getCenter(find.byType(GooeySurface).first),
    );
    await tester.pump();
    expect(controller.entryOf(id)!.isPaused, isTrue);
    await gesture.up();
    await tester.pump();
    expect(controller.entryOf(id)!.isPaused, isFalse);
    await _clear(tester, controller);
  });

  testWidgets('swipe dismisses in an allowed direction only', (tester) async {
    final controller = GooeyToastController();
    addTearDown(controller.dispose);
    await tester.pumpWidget(_frame(controller));
    controller.showGooeyToast(
      _options(
        title: 'Swipe me',
        position: GooeyToastPosition.right,
        duration: const Duration(minutes: 5),
      ),
    );
    await tester.pump();
    await tester.drag(find.text('Swipe me'), const Offset(0, 200));
    await tester.pump();
    expect(find.text('Swipe me'), findsOneWidget);
    await tester.drag(find.text('Swipe me'), const Offset(200, 0));
    await tester.pumpAndSettle();
    expect(find.text('Swipe me'), findsNothing);
  });

  testWidgets('auto-dismisses after the duration', (tester) async {
    final controller = GooeyToastController();
    addTearDown(controller.dispose);
    await tester.pumpWidget(_frame(controller));
    controller.showGooeyToast(
      _options(duration: const Duration(milliseconds: 100)),
    );
    await tester.pump();
    expect(find.text('Saved'), findsOneWidget);
    await tester.pump(const Duration(milliseconds: 120));
    await tester.pumpAndSettle();
    expect(find.text('Saved'), findsNothing);
  });

  testWidgets('persistUntilDismissed ignores the countdown', (tester) async {
    final controller = GooeyToastController();
    addTearDown(controller.dispose);
    await tester.pumpWidget(_frame(controller));
    final String id = controller.showGooeyToast(
      _options(duration: const Duration(milliseconds: 100), persist: true),
    );
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('Saved'), findsOneWidget);
    controller.dismiss(id);
    expect(controller.entryOf(id)!.isExiting, isTrue);
    await tester.pumpAndSettle();
    expect(find.text('Saved'), findsNothing);
  });

  testWidgets('a stacked slot pauses the older toast', (tester) async {
    final controller = GooeyToastController();
    addTearDown(controller.dispose);
    await tester.pumpWidget(_frame(controller));
    controller.showGooeyToast(_options(title: 'Older'));
    controller.showGooeyToast(_options(title: 'Newer'));
    await tester.pump();
    final List<ToastEntry<GooeyToastOptions>> live = controller.entriesIn(
      const ToastSlot(ToastPlacement.topLeading),
    );
    expect(live, hasLength(2));
    expect(live.last.isPaused, isTrue);
    expect(live.first.isPaused, isFalse);
    await _clear(tester, controller);
  });

  testWidgets('dismissPrevious replaces the slot', (tester) async {
    final controller = GooeyToastController();
    addTearDown(controller.dispose);
    await tester.pumpWidget(_frame(controller));
    controller.showGooeyToast(_options(title: 'First'));
    controller.showGooeyToast(
      _options(title: 'Second'),
      behavior: GooeyToastNewToastBehavior.dismissPrevious,
    );
    await tester.pump();
    // The replaced toast plays its exit animation before it is removed.
    expect(find.text('First'), findsOneWidget);
    await tester.pump(const Duration(milliseconds: 250));
    await tester.pump();
    expect(
      controller.entriesIn(const ToastSlot(ToastPlacement.topLeading)),
      hasLength(1),
    );
    expect(find.text('Second'), findsOneWidget);
    expect(find.text('First'), findsNothing);
    await _clear(tester, controller);
  });

  testWidgets('transition updates the newest toast in place', (tester) async {
    final controller = GooeyToastController();
    addTearDown(controller.dispose);
    await tester.pumpWidget(_frame(controller));
    controller.showGooeyToast(_options(title: 'First'));
    final String id = controller.showGooeyToast(
      _options(title: 'Second'),
      behavior: GooeyToastNewToastBehavior.transition,
    );
    await tester.pump();
    expect(controller.entries, hasLength(1));
    expect(controller.entryOf(id)!.data.title, 'Second');
    await tester.pump(const Duration(milliseconds: 500));
    expect(find.text('Second'), findsOneWidget);
    await _clear(tester, controller);
  });

  testWidgets('showGooeyToast resolves the nearest layer', (tester) async {
    final controller = GooeyToastController();
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
    showGooeyToast(context, _options(title: 'Via context'));
    await tester.pump();
    expect(find.text('Via context'), findsOneWidget);
    expect(gooeyToastControllerOf(context), controller);
    await _clear(tester, controller);
  });

  testWidgets('theme precedence: defaults < app < tree < widget', (
    tester,
  ) async {
    const Color red = Color(0xFFFF0000);
    const Color green = Color(0xFF00FF00);
    const Color blue = Color(0xFF0000FF);
    final controller = GooeyToastController();
    addTearDown(controller.dispose);
    controller.showGooeyToast(_options());

    Future<void> pumpWith(GooeyToastTheme? widgetTheme) async {
      await tester.pumpWidget(
        ShadcnTheme(
          data: const ShadcnThemeData(),
          child: ComponentThemes(
            themes: const <ComponentThemeData>[
              GooeyToastTheme(fill: ThemedColor.value(red)),
            ],
            child: Directionality(
              textDirection: TextDirection.ltr,
              child: Align(
                alignment: Alignment.topLeft,
                child: SizedBox(
                  width: 400,
                  height: 400,
                  child: ComponentTheme<GooeyToastTheme>(
                    data: const GooeyToastTheme(fill: ThemedColor.value(green)),
                    child: GooeyToastLayer(
                      controller: controller,
                      theme: widgetTheme,
                      child: const SizedBox.expand(),
                    ),
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
    expect(_fillColor(tester), green);
    await pumpWith(const GooeyToastTheme(fill: ThemedColor.value(blue)));
    expect(_fillColor(tester), blue);
    await _clear(tester, controller);
  });

  testWidgets('per-field merge keeps lower legs', (tester) async {
    const Color red = Color(0xFFFF0000);
    final controller = GooeyToastController();
    addTearDown(controller.dispose);
    controller.showGooeyToast(_options());
    await tester.pumpWidget(
      _frame(
        controller,
        app: const <ComponentThemeData>[
          GooeyToastTheme(fill: ThemedColor.value(red), width: 300),
        ],
      ),
    );
    await tester.pump();
    expect(_fillColor(tester), red);
    expect(_surfaceSize(tester).width, 300);
    await _clear(tester, controller);
  });

  testWidgets('token fill follows light and dark presets', (tester) async {
    final controller = GooeyToastController();
    addTearDown(controller.dispose);
    const GooeyToastTheme theme = GooeyToastTheme(
      fill: ThemedColor.ref(ColorRef.popover),
    );
    await tester.pumpWidget(_frame(controller, theme: theme));
    controller.showGooeyToast(_options());
    await tester.pump();
    expect(_fillColor(tester), light.popover);
    await tester.pumpWidget(
      _frame(
        controller,
        data: const ShadcnThemeData(colors: ShadcnColors.darkFallback),
        theme: theme,
      ),
    );
    await tester.pump();
    expect(_fillColor(tester), ShadcnColors.darkFallback.popover);
    await _clear(tester, controller);
  });

  testWidgets('theme changes are live while a toast is visible', (
    tester,
  ) async {
    final controller = GooeyToastController();
    addTearDown(controller.dispose);
    const GooeyToastTheme theme = GooeyToastTheme(
      fill: ThemedColor.ref(ColorRef.primary),
    );
    await tester.pumpWidget(_frame(controller, theme: theme));
    controller.showGooeyToast(_options());
    await tester.pump();
    expect(_fillColor(tester), light.primary);
    await tester.pumpWidget(
      _frame(
        controller,
        data: const ShadcnThemeData(colors: ShadcnColors.darkFallback),
        theme: theme,
      ),
    );
    await tester.pump();
    expect(_fillColor(tester), ShadcnColors.darkFallback.primary);
    await _clear(tester, controller);
  });

  testWidgets('a viewport smaller than the surface does not crash', (
    tester,
  ) async {
    final controller = GooeyToastController();
    addTearDown(controller.dispose);
    await tester.pumpWidget(
      ShadcnTheme(
        data: const ShadcnThemeData(),
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: MediaQuery(
            data: const MediaQueryData(size: Size(200, 200)),
            child: Align(
              alignment: Alignment.topLeft,
              child: SizedBox(
                width: 200,
                height: 200,
                child: GooeyToastLayer(
                  controller: controller,
                  child: const SizedBox.expand(),
                ),
              ),
            ),
          ),
        ),
      ),
    );
    controller.showGooeyToast(
      _options(position: GooeyToastPosition.center, title: 'Tiny'),
    );
    await tester.pump();
    expect(tester.takeException(), isNull);
    expect(find.text('Tiny'), findsOneWidget);
    await _clear(tester, controller);
  });

  testWidgets('the action chip is 28 high when expanded', (tester) async {
    final controller = GooeyToastController();
    addTearDown(controller.dispose);
    await tester.pumpWidget(_frame(controller));
    controller.showGooeyToast(
      _options(
        description: 'With an action',
        duration: const Duration(minutes: 5),
        action: GooeyToastAction(label: 'Reply', onPressed: () {}),
      ),
    );
    await tester.pump(const Duration(milliseconds: 200));
    await tester.pump(const Duration(milliseconds: 700));
    expect(tester.getSize(find.byType(GooeyActionChip).first).height, 28);
    await _clear(tester, controller);
  });

  testWidgets('the loading state never expands', (tester) async {
    final controller = GooeyToastController();
    addTearDown(controller.dispose);
    await tester.pumpWidget(_frame(controller));
    controller.showGooeyToast(
      _options(
        state: GooeyToastState.loading,
        description: 'Working',
        duration: const Duration(minutes: 5),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(seconds: 5));
    expect(_surfaceSize(tester).height, 40);
    await _clear(tester, controller);
  });

  testWidgets('a dismissed toast animates out before removal', (tester) async {
    final controller = GooeyToastController();
    addTearDown(controller.dispose);
    await tester.pumpWidget(_frame(controller));
    final String id = controller.showGooeyToast(_options(title: 'Leaving'));
    await tester.pump();
    controller.dismiss(id);
    await tester.pump();
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

  testWidgets('remaining toasts animate into their new offsets', (
    tester,
  ) async {
    final controller = GooeyToastController();
    addTearDown(controller.dispose);
    await tester.pumpWidget(_frame(controller));
    controller.showGooeyToast(
      _options(title: 'Older', duration: const Duration(minutes: 5)),
    );
    final String newer = controller.showGooeyToast(
      _options(title: 'Newer', duration: const Duration(minutes: 5)),
    );
    await tester.pump();
    final double before = tester.getTopLeft(find.byType(GooeySurface).last).dy;
    controller.dismiss(newer);
    await tester.pump();
    // Let the exit animation finish and the entry be removed.
    await tester.pump(const Duration(milliseconds: 250));
    await tester.pump();
    // Now the remaining surface animates into the freed offset.
    await tester.pump(const Duration(milliseconds: 100));
    final double mid = tester.getTopLeft(find.byType(GooeySurface).first).dy;
    await tester.pumpAndSettle();
    final double after = tester.getTopLeft(find.byType(GooeySurface).first).dy;
    expect(mid, lessThan(before));
    expect(mid, greaterThan(after));
    expect(after, lessThan(before));
    await _clear(tester, controller);
  });

  testWidgets('disableAnimations removes the toast without animating', (
    tester,
  ) async {
    final controller = GooeyToastController();
    addTearDown(controller.dispose);
    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(disableAnimations: true),
        child: _frame(controller),
      ),
    );
    final String id = controller.showGooeyToast(_options());
    await tester.pump();
    controller.dismiss(id);
    await tester.pump();
    await tester.pump();
    expect(find.byType(GooeySurface), findsNothing);
    expect(controller.contains(id), isFalse);
  });
}
