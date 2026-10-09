// Widget tests for the `pinned_sheet` component.
//
// Covers: closed/initial stages, controller open/close/jump/animate, drag +
// snap to the nearest stage, the modal barrier (alpha multiplies, tap
// dismisses), peek stages (handle width on horizontal sheets), RTL
// start/end resolution, the unbounded-then-bounded settle, rapid
// open/close (cancelled-animation regression) and the `SheetStage` algebra.

import 'package:flutter/widgets.dart';
import 'package:flutter_shadcn_kit/registry/components/drawer_container/drawer_container.dart';
import 'package:flutter_shadcn_kit/registry/components/pinned_sheet/pinned_sheet.dart';
import 'package:flutter_shadcn_kit/registry/foundation/data.dart';
import 'package:flutter_shadcn_kit/registry/theme/color_tokens.dart';
import 'package:flutter_shadcn_kit/registry/theme/theme.dart';
import 'package:flutter_test/flutter_test.dart';

const List<SheetStage> _two = <SheetStage>[
  SheetStage.closed(),
  SheetStage.expanded(),
];

Future<void> _pump(WidgetTester tester, Widget child) {
  return tester.pumpWidget(
    ShadcnTheme(
      data: const ShadcnThemeData(),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Center(child: SizedBox(width: 300, height: 600, child: child)),
      ),
    ),
  );
}

void main() {
  testWidgets('closed by default', (WidgetTester tester) async {
    final SheetController controller = SheetController();
    addTearDown(controller.dispose);
    await _pump(
      tester,
      PinnedSheet(controller: controller, child: const SizedBox()),
    );
    expect(controller.isAttached, isTrue);
    expect(controller.offset, 0);
    expect(controller.fraction, 0);
    expect(controller.isOpen, isFalse);
  });

  testWidgets('initial stage applies on the first frame', (
    WidgetTester tester,
  ) async {
    final SheetController controller = SheetController();
    addTearDown(controller.dispose);
    await _pump(
      tester,
      PinnedSheet(
        controller: controller,
        initialStage: const SheetStage.fraction(0.4),
        stages: const <SheetStage>[
          SheetStage.closed(),
          SheetStage.fraction(0.4),
          SheetStage.expanded(),
        ],
        child: const SizedBox(),
      ),
    );
    expect(controller.offset, 240);
    expect(controller.fraction, 0.4);
  });

  testWidgets('controller open, close, jump and animate', (
    WidgetTester tester,
  ) async {
    final SheetController controller = SheetController();
    addTearDown(controller.dispose);
    await _pump(
      tester,
      PinnedSheet(controller: controller, child: const SizedBox()),
    );
    // Never await controller futures directly: the animation only progresses
    // while the tester pumps.
    controller.open();
    await tester.pumpAndSettle();
    expect(controller.offset, 600);
    controller.close();
    await tester.pumpAndSettle();
    expect(controller.offset, 0);
    controller.jumpTo(const SheetStage.fixed(100));
    await tester.pump();
    expect(controller.offset, 100);
    controller.animateTo(
      const SheetStage.fraction(0.5),
      duration: const Duration(milliseconds: 100),
    );
    await tester.pumpAndSettle();
    expect(controller.offset, 300);
  });

  testWidgets('rapid open then close settles closed without async errors', (
    WidgetTester tester,
  ) async {
    final SheetController controller = SheetController();
    addTearDown(controller.dispose);
    await _pump(
      tester,
      PinnedSheet(controller: controller, child: const SizedBox()),
    );
    controller.open();
    controller.close();
    await tester.pumpAndSettle();
    expect(controller.fraction, 0);
  });

  testWidgets('drag snaps to the nearest stage', (WidgetTester tester) async {
    final SheetController controller = SheetController();
    addTearDown(controller.dispose);
    await _pump(
      tester,
      PinnedSheet(
        controller: controller,
        initialStage: const SheetStage.fraction(0.4),
        stages: _two,
        child: const SizedBox(width: 300, height: 100),
      ),
    );
    expect(controller.offset, 240);
    // Short drag up stays under halfway: snaps back to closed.
    await tester.drag(find.byType(PinnedSheet), const Offset(0, -50));
    await tester.pumpAndSettle();
    expect(controller.offset, 0);
    // Long drag up passes halfway: snaps to expanded.
    await tester.drag(find.byType(PinnedSheet), const Offset(0, -400));
    await tester.pumpAndSettle();
    expect(controller.offset, 600);
  });

  testWidgets('slide transform tracks the fraction', (
    WidgetTester tester,
  ) async {
    final SheetController controller = SheetController();
    addTearDown(controller.dispose);
    await _pump(
      tester,
      PinnedSheet(controller: controller, child: const SizedBox()),
    );
    controller.jumpTo(const SheetStage.fraction(0.5));
    await tester.pump();
    final Transform slide = tester.widget<Transform>(
      find.byType(Transform).first,
    );
    expect(slide.transform.storage[12], 0);
    expect(slide.transform.storage[13], 300);
  });

  testWidgets('modal barrier alpha multiplies and tap dismisses', (
    WidgetTester tester,
  ) async {
    final SheetController controller = SheetController();
    addTearDown(controller.dispose);
    await _pump(
      tester,
      PinnedSheet(
        controller: controller,
        modal: true,
        barrierColor: const ThemedColor.value(Color(0xFFFF0000)),
        child: const SizedBox(width: 300, height: 100),
      ),
    );
    expect(find.byType(ColoredBox), findsNothing);
    controller.jumpTo(const SheetStage.fraction(0.5));
    await tester.pump();
    final ColoredBox barrier = tester.widget<ColoredBox>(
      find.byType(ColoredBox),
    );
    expect(barrier.color, const Color(0xFFFF0000).withValues(alpha: 0.5));
    controller.open();
    await tester.pumpAndSettle();
    await tester.tap(find.byType(ColoredBox));
    await tester.pumpAndSettle();
    expect(controller.fraction, 0);
  });

  testWidgets('peek uses the default handle extent', (
    WidgetTester tester,
  ) async {
    final SheetController controller = SheetController();
    addTearDown(controller.dispose);
    await _pump(
      tester,
      PinnedSheet(
        key: const ValueKey<String>('vertical'),
        controller: controller,
        initialStage: const SheetStage.peekDragHandle(),
        stages: const <SheetStage>[
          SheetStage.peekDragHandle(),
          SheetStage.expanded(),
        ],
        child: const SizedBox(),
      ),
    );
    expect(controller.offset, 16);
  });

  testWidgets('peek on horizontal sheets uses the handle width', (
    WidgetTester tester,
  ) async {
    final SheetController controller = SheetController();
    addTearDown(controller.dispose);
    await _pump(
      tester,
      PinnedSheet(
        key: const ValueKey<String>('horizontal'),
        position: OverlayPosition.left,
        controller: controller,
        dragHandleSize: const Size(20, 8),
        initialStage: const SheetStage.peekDragHandle(),
        stages: const <SheetStage>[
          SheetStage.peekDragHandle(),
          SheetStage.expanded(),
        ],
        child: const SizedBox(),
      ),
    );
    expect(controller.offset, 20);
  });

  testWidgets('zero extent then bounded still settles the initial stage', (
    WidgetTester tester,
  ) async {
    final SheetController controller = SheetController();
    addTearDown(controller.dispose);
    Widget sheet(double height) => ShadcnTheme(
      data: const ShadcnThemeData(),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Center(
          child: SizedBox(
            width: 300,
            height: height,
            child: PinnedSheet(
              controller: controller,
              initialStage: const SheetStage.fraction(0.4),
              stages: _two,
              child: const SizedBox(),
            ),
          ),
        ),
      ),
    );
    // Fully unbounded height cannot lay out (Positioned.fill needs bounds);
    // zero extent is the collapsible-parent case: stay hidden, unsettled.
    await tester.pumpWidget(sheet(0));
    expect(controller.offset, 0);
    await tester.pumpWidget(sheet(600));
    expect(controller.offset, 240);
  });

  testWidgets('start resolves left in ltr and right in rtl', (
    WidgetTester tester,
  ) async {
    OverlayPosition? captured;
    Widget probe() => PinnedSheet(
      position: OverlayPosition.start,
      child: DrawerContainer(
        child: Builder(
          builder: (BuildContext context) {
            captured = Data.maybeOf<DrawerContainerData>(context)?.position;
            return const SizedBox();
          },
        ),
      ),
    );
    await _pump(tester, probe());
    expect(captured, OverlayPosition.left);
    await tester.pumpWidget(
      ShadcnTheme(
        data: const ShadcnThemeData(),
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Center(
            child: SizedBox(width: 300, height: 600, child: probe()),
          ),
        ),
      ),
    );
    expect(captured, OverlayPosition.right);
  });

  test('stage algebra resolves against the resolution', () {
    const SheetStageResolution vertical = SheetStageResolution(
      size: Size(300, 600),
      position: OverlayPosition.bottom,
      dragHandleExtent: 16,
    );
    expect(const SheetStage.closed().resolveDragOffset(vertical), 0);
    expect(const SheetStage.expanded().resolveDragOffset(vertical), 600);
    expect(const SheetStage.fixed(100).resolveDragOffset(vertical), 100);
    expect(const SheetStage.fraction(0.5).resolveDragOffset(vertical), 300);
    expect(const SheetStage.peekDragHandle().resolveDragOffset(vertical), 16);
    expect(
      (const SheetStage.expanded() * 0.9).resolveDragOffset(vertical),
      540,
    );
    expect(
      (const SheetStage.expanded() - const SheetStage.fixed(100))
          .resolveDragOffset(vertical),
      500,
    );
    expect(const SheetStage.closed().resolveBackdropTransform(vertical), 0);
    expect(const SheetStage.expanded().resolveBackdropTransform(vertical), 1);
  });

  testWidgets('live stage equals the matching static stage', (
    WidgetTester tester,
  ) async {
    final SheetController controller = SheetController();
    addTearDown(controller.dispose);
    await _pump(
      tester,
      PinnedSheet(controller: controller, child: const SizedBox()),
    );
    controller.jumpTo(const SheetStage.fraction(0.4));
    await tester.pump();
    expect(controller.stage, const SheetStage.fraction(0.4));
    expect(controller.stage == const SheetStage.expanded(), isFalse);
  });
}
