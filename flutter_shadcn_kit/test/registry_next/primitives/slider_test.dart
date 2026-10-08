// Unit and smoke tests for `primitives/slider`: value mapping, snapping,
// marks, range thumb math and the generic painter. The component-level
// theme/widget tests live in `test/registry_next/components/slider_test.dart`.

import 'package:flutter/widgets.dart';
import 'package:flutter_shadcn_kit/registry_next/primitives/slider/slider.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final logic = SliderLogic();

  group('SliderSnap', () {
    test('none clamps only', () {
      expect(const SliderSnap.none().apply(1.5, 0, 1), 1);
      expect(const SliderSnap.none().apply(0.5, 0, 1), 0.5);
    });

    test('steps quantizes and collapses a zero-width domain', () {
      expect(const SliderSnap.steps(4).apply(0.6, 0, 1), closeTo(0.5, 1e-9));
      expect(const SliderSnap.steps(3).apply(5, 2, 2), 2);
    });

    test('values picks the nearest entry, empty falls back to clamp', () {
      const snap = SliderSnap.values([0.1, 0.5, 0.9]);
      expect(snap.apply(0.8, 0, 1), 0.9);
      expect(const SliderSnap.values([]).apply(0.7, 0, 1), 0.7);
    });

    test('marks follow the snap strategy', () {
      expect(const SliderSnap.none().marks(0, 1), isEmpty);
      expect(const SliderSnap.steps(4).marks(0, 1).length, 5);
      final marks = const SliderSnap.values([0.9, 0.1]).marks(0, 1);
      expect(marks.length, 2);
      expect(marks.first.t, lessThan(marks.last.t));
    });
  });

  group('SliderLogic', () {
    SliderView build({double? value, double? start, double? end}) {
      return logic.buildView(
        min: 0,
        max: 100,
        snap: const SliderSnap.none(),
        enabled: true,
        trackRect: const Rect.fromLTWH(0, 0, 200, 4),
        trackRadius: 2,
        thumbInset: 8,
        dragging: false,
        activeThumb: null,
        thumbSize: const Size(16, 16),
        textDirection: TextDirection.ltr,
        value: value,
        rangeStart: start,
        rangeEnd: end,
      );
    }

    test('single thumb placement matches value', () {
      final view = build(value: 50);
      expect(view.isRange, isFalse);
      expect(view.thumbs.single.t, 0.5);
      expect(view.fillRect, isNotNull);
    });

    test('range thumbs and active rect', () {
      final view = build(start: 25, end: 75);
      expect(view.thumbs.length, 2);
      expect(view.activeRect, isNotNull);
      expect(view.rangeStart, 25);
      expect(view.rangeEnd, 75);
    });

    test('valueFromDx inverts the thumb position mapping', () {
      final view = build(value: 80);
      final dx = view.thumbs.single.center.dx;
      expect(
        logic.valueFromDx(view, const SliderSnap.none(), dx),
        closeTo(80, 1e-6),
      );
    });

    test('pickActiveThumb returns the nearest thumb', () {
      final view = build(start: 25, end: 75);
      expect(logic.pickActiveThumb(view, view.thumbs[1].center.dx), 1);
      expect(logic.pickActiveThumb(view, view.thumbs[0].center.dx), 0);
      expect(logic.pickActiveThumb(build(value: 1), 0), 0);
    });
  });

  group('sliderDraggedRange', () {
    test('clamps at the other thumb without allowSwap', () {
      final (lo, hi) = sliderDraggedRange(
        v: 90,
        thumbIndex: 0,
        start: 40,
        end: 60,
        min: 0,
        max: 100,
        minRange: 10,
        allowSwap: false,
      );
      expect(lo, 50); // end - minRange
      expect(hi, 60);
    });

    test('allowSwap crosses and keeps the pair ordered', () {
      final (lo, hi) = sliderDraggedRange(
        v: 80,
        thumbIndex: 0,
        start: 40,
        end: 60,
        min: 0,
        max: 100,
        minRange: 10,
        allowSwap: true,
      );
      expect(lo, 60);
      expect(hi, 80);
    });

    test('minRange expands the dragged side', () {
      final (lo, hi) = sliderDraggedRange(
        v: 58,
        thumbIndex: 1,
        start: 50,
        end: 60,
        min: 0,
        max: 100,
        minRange: 20,
        allowSwap: false,
      );
      expect(lo, 50);
      expect(hi, 70);
    });
  });

  group('sliderStep', () {
    test('none steps by 1% of the domain', () {
      expect(
        sliderStep(
          snap: const SliderSnap.none(),
          current: 0.5,
          direction: 1,
          min: 0,
          max: 1,
        ),
        closeTo(0.51, 1e-9),
      );
    });

    test('steps jumps one interval', () {
      expect(
        sliderStep(
          snap: const SliderSnap.steps(4),
          current: 0.5,
          direction: -1,
          min: 0,
          max: 1,
        ),
        closeTo(0.25, 1e-9),
      );
    });

    test('values walks the entry list', () {
      expect(
        sliderStep(
          snap: const SliderSnap.values([0.2, 0.5, 0.8]),
          current: 0.5,
          direction: 1,
          min: 0,
          max: 1,
        ),
        0.8,
      );
      expect(
        sliderStep(
          snap: const SliderSnap.values([0.2, 0.5, 0.8]),
          current: 0.8,
          direction: 1,
          min: 0,
          max: 1,
        ),
        0.8,
      );
    });
  });

  group('SliderPainter', () {
    testWidgets('paints a slider from plain colours without components', (
      tester,
    ) async {
      final view = SliderLogic().buildView(
        min: 0,
        max: 1,
        snap: const SliderSnap.steps(4),
        enabled: true,
        trackRect: const Rect.fromLTWH(0, 6, 200, 4),
        trackRadius: 2,
        thumbInset: 8,
        dragging: false,
        activeThumb: null,
        thumbSize: const Size(16, 16),
        textDirection: TextDirection.ltr,
        value: 0.5,
        rangeStart: null,
        rangeEnd: null,
      );
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: Center(
            child: SizedBox(
              width: 200,
              height: 28,
              child: CustomPaint(
                painter: SliderPainter(
                  view: view,
                  marksStyle: SliderMarksStyle.dots,
                  thumbShape: SliderThumbShape.circle,
                  trackColor: const Color(0xFFCCCCCC),
                  fillColor: const Color(0xFF111111),
                  thumbColor: const Color(0xFFFFFFFF),
                  thumbBorderColor: const Color(0xFF111111),
                  markColor: const Color(0xFF999999),
                  focused: true,
                  ringColor: const Color(0xFF3333FF),
                ),
              ),
            ),
          ),
        ),
      );
      expect(tester.takeException(), isNull);
      expect(find.byType(CustomPaint), findsOneWidget);
    });
  });
}
