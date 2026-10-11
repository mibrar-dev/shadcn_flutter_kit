// Widget and unit tests for `primitives/gooey/`: shape geometry and painting,
// the expandable surface, the swipe wrapper, the anchored stack and the
// content pieces.

import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_shadcn_kit/registry/primitives/gooey/gooey_content.dart';
import 'package:flutter_shadcn_kit/registry/primitives/gooey/gooey_frame.dart';
import 'package:flutter_shadcn_kit/registry/primitives/gooey/gooey_shape.dart';
import 'package:flutter_shadcn_kit/registry/primitives/gooey/gooey_stack.dart';
import 'package:flutter_shadcn_kit/registry/primitives/gooey/gooey_surface.dart';
import 'package:flutter_shadcn_kit/registry/primitives/gooey/gooey_swipe.dart';
import 'package:flutter_shadcn_kit/registry/primitives/toast_queue/toast_entry.dart';
import 'package:flutter_shadcn_kit/registry/primitives/toast_queue/toast_placement.dart';
import 'package:flutter_shadcn_kit/registry/primitives/toast_queue/toast_queue.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _surfaceFrame({
  String title = 'Saved',
  String? description,
  Duration? expandDelay,
  Duration? collapseDelay,
  bool expandable = true,
  Object morphKey = 'a',
  GooeySurfaceBodyAnimation bodyAnimation = GooeySurfaceBodyAnimation.fade,
  ValueChanged<bool>? onExpansionChanged,
  ValueChanged<bool>? onInteractionChanged,
}) {
  return Directionality(
    textDirection: TextDirection.ltr,
    child: Align(
      alignment: Alignment.topLeft,
      child: GooeySurface(
        title: title,
        titleStyle: const TextStyle(fontSize: 13.2),
        morphKey: morphKey,
        description: description,
        expandable: expandable,
        expandDelay: expandDelay,
        collapseDelay: collapseDelay,
        bodyAnimation: bodyAnimation,
        onExpansionChanged: onExpansionChanged,
        onInteractionChanged: onInteractionChanged,
      ),
    ),
  );
}

Size _surfaceSize(WidgetTester tester) =>
    tester.getSize(find.byType(GooeySurface).first);

void main() {
  group('GooeyShapeGeometry', () {
    test('pill path bounds follow the geometry', () {
      const GooeyShapeGeometry geometry = GooeyShapeGeometry(
        roundness: 12,
        pillX: 20,
        pillWidth: 200,
        pillHeight: 40,
      );
      expect(
        geometry.buildPillPath().getBounds(),
        const Rect.fromLTWH(20, 0, 200, 40),
      );
    });

    test('body and shoulder paths stay empty while closed', () {
      const GooeyShapeGeometry closed = GooeyShapeGeometry();
      expect(closed.buildBodyPath(const Size(350, 40)).getBounds(), Rect.zero);
      expect(
        closed.buildShoulderPath(const Size(350, 40)).getBounds(),
        Rect.zero,
      );
      expect(
        closed.buildPath(const Size(350, 40)).getBounds(),
        closed.buildPillPath().getBounds(),
      );
    });

    test('body path grows when open and equals the full silhouette', () {
      const GooeyShapeGeometry open = GooeyShapeGeometry(
        bodyHeight: 80,
        bodyScaleY: 1,
      );
      final Rect body = open.buildBodyPath(const Size(350, 120)).getBounds();
      expect(body.height, greaterThan(80));
      expect(
        open.buildShoulderPath(const Size(350, 120)).getBounds(),
        isNot(Rect.zero),
      );
      expect(
        open.buildPath(const Size(350, 120)).getBounds().height,
        greaterThan(open.buildPillPath().getBounds().height),
      );
    });

    test('equality and painting decisions follow the fields', () {
      const GooeyShapeGeometry a = GooeyShapeGeometry(roundness: 12);
      const GooeyShapeGeometry b = GooeyShapeGeometry(roundness: 12);
      const GooeyShapeGeometry c = GooeyShapeGeometry(roundness: 13);
      expect(a, b);
      expect(a.hashCode, b.hashCode);
      expect(a, isNot(c));
      const GooeyShapePainter painter = GooeyShapePainter(
        color: Color(0xFF000000),
        geometry: a,
      );
      expect(
        painter.shouldRepaint(
          const GooeyShapePainter(color: Color(0xFF000000), geometry: b),
        ),
        isFalse,
      );
      expect(
        painter.shouldRepaint(
          const GooeyShapePainter(color: Color(0xFFFFFFFF), geometry: a),
        ),
        isTrue,
      );
      const GooeyShapeClipper clipper = GooeyShapeClipper(a);
      expect(clipper.shouldReclip(const GooeyShapeClipper(b)), isFalse);
      expect(clipper.shouldReclip(const GooeyShapeClipper(c)), isTrue);
    });
  });

  group('GooeySurface', () {
    testWidgets('without a body the surface never expands', (tester) async {
      await tester.pumpWidget(
        _surfaceFrame(expandDelay: const Duration(milliseconds: 50)),
      );
      await tester.pump(const Duration(milliseconds: 200));
      expect(_surfaceSize(tester).height, kGooeySurfacePillHeight);
    });

    testWidgets('expandable false keeps the pill shut', (tester) async {
      await tester.pumpWidget(
        _surfaceFrame(
          description: 'Body',
          expandable: false,
          expandDelay: const Duration(milliseconds: 50),
        ),
      );
      await tester.pump(const Duration(milliseconds: 500));
      expect(_surfaceSize(tester).height, kGooeySurfacePillHeight);
    });

    testWidgets('autopilot expands and collapses with explicit delays', (
      tester,
    ) async {
      final List<bool> phases = <bool>[];
      await tester.pumpWidget(
        _surfaceFrame(
          description: 'Body',
          expandDelay: const Duration(milliseconds: 50),
          collapseDelay: const Duration(milliseconds: 2000),
          onExpansionChanged: phases.add,
        ),
      );
      await tester.pump(const Duration(milliseconds: 60));
      await tester.pump(const Duration(milliseconds: 700));
      await tester.pump(const Duration(milliseconds: 300));
      expect(_surfaceSize(tester).height, greaterThan(kGooeySurfacePillHeight));
      expect(phases, contains(true));
      await tester.pump(const Duration(milliseconds: 1000));
      await tester.pump(const Duration(milliseconds: 700));
      await tester.pump(const Duration(milliseconds: 300));
      expect(_surfaceSize(tester).height, kGooeySurfacePillHeight);
      expect(phases.last, isFalse);
    });

    testWidgets('hover expands and reports interaction', (tester) async {
      final List<bool> interactions = <bool>[];
      await tester.pumpWidget(
        _surfaceFrame(
          description: 'Body',
          onInteractionChanged: interactions.add,
        ),
      );
      final TestGesture mouse = await tester.createGesture(
        kind: PointerDeviceKind.mouse,
      );
      addTearDown(mouse.removePointer);
      await mouse.addPointer(location: Offset.zero);
      await mouse.moveTo(tester.getCenter(find.byType(GooeySurface).first));
      await tester.pump();
      expect(interactions, <bool>[true]);
      await tester.pump(const Duration(milliseconds: 700));
      await tester.pump(const Duration(milliseconds: 300));
      expect(_surfaceSize(tester).height, greaterThan(kGooeySurfacePillHeight));
      await mouse.moveTo(const Offset(799, 599));
      await tester.pump();
      expect(interactions, <bool>[true, false]);
    });

    testWidgets('tapping the pill toggles the body', (tester) async {
      await tester.pumpWidget(_surfaceFrame(description: 'Body'));
      await tester.tap(find.byType(GooeySurfacePill).first);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 700));
      await tester.pump(const Duration(milliseconds: 300));
      expect(_surfaceSize(tester).height, greaterThan(kGooeySurfacePillHeight));
      await tester.tap(find.byType(GooeySurfacePill).first);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 700));
      await tester.pump(const Duration(milliseconds: 300));
      expect(_surfaceSize(tester).height, kGooeySurfacePillHeight);
    });

    testWidgets('the instant body profile snaps content in', (tester) async {
      await tester.pumpWidget(
        _surfaceFrame(
          description: 'Body',
          bodyAnimation: GooeySurfaceBodyAnimation.none,
          expandDelay: Duration.zero,
        ),
      );
      await tester.pump(const Duration(milliseconds: 1));
      await tester.pump(const Duration(milliseconds: 700));
      await tester.pump(const Duration(milliseconds: 300));
      expect(_surfaceSize(tester).height, greaterThan(kGooeySurfacePillHeight));
    });

    testWidgets('a new morph key animates the compact content', (tester) async {
      await tester.pumpWidget(_surfaceFrame(title: 'One', morphKey: 'one'));
      await tester.pumpWidget(_surfaceFrame(title: 'Two', morphKey: 'two'));
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.text('One'), findsOneWidget);
      expect(find.text('Two'), findsOneWidget);
      await tester.pump(const Duration(milliseconds: 500));
      expect(find.text('One'), findsNothing);
      expect(find.text('Two'), findsOneWidget);
    });
  });

  group('content pieces', () {
    test('pill width grows with the title and clamps to the bounds', () {
      const TextStyle style = TextStyle(fontSize: 13.2);
      final double tiny = GooeySurfacePill.measureWidth(
        title: 'A',
        style: style,
        direction: TextDirection.ltr,
        pillHeight: kGooeySurfacePillHeight,
        maxWidth: 350,
      );
      final double wide = GooeySurfacePill.measureWidth(
        title: 'A much longer toast title',
        style: style,
        direction: TextDirection.ltr,
        pillHeight: kGooeySurfacePillHeight,
        maxWidth: 350,
      );
      expect(tiny, greaterThanOrEqualTo(kGooeySurfacePillHeight));
      expect(wide, greaterThan(tiny));
      expect(wide, lessThanOrEqualTo(350));
    });

    testWidgets('pill width uses the ambient style (family/letterSpacing)', (
      tester,
    ) async {
      await tester.pumpWidget(_surfaceFrame(title: 'Saved'));
      final double plain = tester
          .widget<GooeySurfacePill>(find.byType(GooeySurfacePill))
          .width;

      await tester.pumpWidget(
        DefaultTextStyle(
          style: const TextStyle(
            fontFamily: 'CustomTestFont',
            letterSpacing: 4,
          ),
          child: _surfaceFrame(title: 'Saved'),
        ),
      );
      final GooeySurfacePill pill = tester.widget<GooeySurfacePill>(
        find.byType(GooeySurfacePill),
      );
      // The measured width must include the ambient family/spacing the pill
      // paints with, not just the theme style.
      expect(pill.titleStyle.fontFamily, 'CustomTestFont');
      expect(pill.width, greaterThan(plain));
    });

    testWidgets('state icon is a 24x24 bubble and spins when loading', (
      tester,
    ) async {
      await tester.pumpWidget(
        const Directionality(
          textDirection: TextDirection.ltr,
          child: Center(
            child: GooeyStateIcon(
              icon: IconData(0x1),
              color: Color(0xFF63C65E),
            ),
          ),
        ),
      );
      expect(tester.getSize(find.byType(GooeyStateIcon)), const Size(24, 24));
      await tester.pumpWidget(
        const Directionality(
          textDirection: TextDirection.ltr,
          child: Center(
            child: GooeyStateIcon(
              icon: IconData(0x1),
              color: Color(0xFF63C65E),
              loading: true,
            ),
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 100));
      expect(
        find.descendant(
          of: find.byType(GooeyStateIcon),
          matching: find.byType(Transform),
        ),
        findsOneWidget,
      );
    });

    testWidgets('action chip is 28 high and taps', (tester) async {
      var taps = 0;
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: Center(
            child: GooeyActionChip(
              label: 'Reply',
              color: const Color(0xFF63C65E),
              onPressed: () => taps += 1,
            ),
          ),
        ),
      );
      expect(tester.getSize(find.byType(GooeyActionChip)).height, 28);
      await tester.tap(find.byType(GooeyActionChip));
      expect(taps, 1);
    });
  });

  group('GooeySwipe', () {
    Widget frame(
      Set<ToastSwipeDirection> directions,
      VoidCallback onDismissed, {
      double threshold = 72,
    }) {
      return Directionality(
        textDirection: TextDirection.ltr,
        child: Center(
          child: GooeySwipe(
            directions: directions,
            onDismissed: onDismissed,
            threshold: threshold,
            child: const SizedBox(width: 100, height: 40),
          ),
        ),
      );
    }

    testWidgets('dismisses past the threshold in an allowed direction', (
      tester,
    ) async {
      var dismissed = 0;
      await tester.pumpWidget(
        frame(const <ToastSwipeDirection>{ToastSwipeDirection.right}, () {
          dismissed += 1;
        }),
      );
      await tester.drag(find.byType(GooeySwipe), const Offset(120, 0));
      await tester.pumpAndSettle();
      expect(dismissed, 1);
    });

    testWidgets('keeps the surface below the threshold', (tester) async {
      var dismissed = 0;
      await tester.pumpWidget(
        frame(const <ToastSwipeDirection>{ToastSwipeDirection.right}, () {
          dismissed += 1;
        }, threshold: 200),
      );
      await tester.drag(find.byType(GooeySwipe), const Offset(120, 0));
      await tester.pumpAndSettle();
      expect(dismissed, 0);
    });

    testWidgets('ignores a disallowed direction', (tester) async {
      var dismissed = 0;
      await tester.pumpWidget(
        frame(const <ToastSwipeDirection>{ToastSwipeDirection.up}, () {
          dismissed += 1;
        }),
      );
      await tester.drag(find.byType(GooeySwipe), const Offset(200, 0));
      await tester.pumpAndSettle();
      expect(dismissed, 0);
    });
  });

  group('GooeyStack', () {
    Widget frame(ToastQueue<String> queue) {
      return Directionality(
        textDirection: TextDirection.ltr,
        child: Align(
          alignment: Alignment.topLeft,
          child: SizedBox(
            width: 400,
            height: 400,
            child: GooeyStack<String>(
              queue: queue,
              anchorInset: 16,
              gap: 8,
              child: const SizedBox.expand(),
              builder:
                  (BuildContext context, ToastEntry<String> entry, int index) =>
                      SizedBox(
                        key: ValueKey<String>('item-${entry.id}'),
                        width: 100,
                        height: 20,
                        child: Text(entry.data),
                      ),
            ),
          ),
        ),
      );
    }

    testWidgets('renders only the child when the queue is empty', (
      tester,
    ) async {
      final queue = ToastQueue<String>();
      addTearDown(queue.dispose);
      await tester.pumpWidget(frame(queue));
      expect(find.byType(Text), findsNothing);
    });

    testWidgets('anchors entries and stacks with the gap', (tester) async {
      final queue = ToastQueue<String>(
        defaultDuration: const Duration(minutes: 5),
        singlePerSlot: false,
      );
      addTearDown(queue.dispose);
      await tester.pumpWidget(frame(queue));
      final ToastEntry<String> first = queue.show(
        placement: ToastPlacement.topLeading,
        data: 'A',
      );
      final ToastEntry<String> second = queue.show(
        placement: ToastPlacement.topLeading,
        data: 'B',
      );
      await tester.pump();
      // The first entry animates into its new offset.
      await tester.pump(const Duration(milliseconds: 250));
      expect(
        tester.getTopLeft(find.byKey(ValueKey<String>('item-${second.id}'))),
        const Offset(16, 16),
      );
      expect(
        tester.getTopLeft(find.byKey(ValueKey<String>('item-${first.id}'))),
        const Offset(16, 24),
      );
      final ToastEntry<String> bottom = queue.show(
        placement: ToastPlacement.bottomTrailing,
        data: 'C',
      );
      await tester.pump();
      expect(
        tester.getTopLeft(find.byKey(ValueKey<String>('item-${bottom.id}'))),
        const Offset(284, 364),
      );
      queue.remove(second.id);
      queue.remove(first.id);
      queue.remove(bottom.id);
      await tester.pump();
    });

    testWidgets('pauses the older toast of a stacked slot and resumes it', (
      tester,
    ) async {
      final queue = ToastQueue<String>(
        defaultDuration: const Duration(minutes: 5),
        singlePerSlot: false,
      );
      addTearDown(queue.dispose);
      await tester.pumpWidget(frame(queue));
      final ToastEntry<String> older = queue.show(
        placement: ToastPlacement.topLeading,
        data: 'A',
      );
      final ToastEntry<String> newer = queue.show(
        placement: ToastPlacement.topLeading,
        data: 'B',
      );
      await tester.pump();
      expect(older.isPaused, isTrue);
      expect(newer.isPaused, isFalse);
      queue.dismiss(newer.id);
      await tester.pump();
      expect(older.isPaused, isFalse);
      queue.remove(newer.id);
      queue.remove(older.id);
      await tester.pump();
    });
  });
}
