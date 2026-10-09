import 'package:flutter/widgets.dart';
import 'package:flutter_shadcn_kit/registry/primitives/scroll_metrics.dart';
import 'package:flutter_test/flutter_test.dart';

FixedScrollMetrics metrics({
  double pixels = 0,
  double min = 0,
  double max = 400,
  double viewport = 100,
  AxisDirection direction = AxisDirection.down,
}) {
  return FixedScrollMetrics(
    minScrollExtent: min,
    maxScrollExtent: max,
    pixels: pixels,
    viewportDimension: viewport,
    axisDirection: direction,
    devicePixelRatio: 1,
  );
}

void main() {
  group('ScrollMetricsSnapshot', () {
    test('reads every field from live scroll metrics', () {
      final snapshot = ScrollMetricsSnapshot.fromMetrics(
        metrics(
          pixels: 120,
          min: 0,
          max: 400,
          viewport: 100,
          direction: AxisDirection.right,
        ),
      );
      expect(snapshot.pixels, 120);
      expect(snapshot.minScrollExtent, 0);
      expect(snapshot.maxScrollExtent, 400);
      expect(snapshot.viewportDimension, 100);
      expect(snapshot.axis, Axis.horizontal);
      expect(snapshot.axisDirection, AxisDirection.right);
      expect(snapshot.reversed, isFalse);
    });

    test('progress runs from 0 at the start to 1 at the end', () {
      expect(metrics(pixels: 0, max: 400).snapshotProgress(), 0);
      expect(metrics(pixels: 100, max: 400).snapshotProgress(), 0.25);
      expect(metrics(pixels: 400, max: 400).snapshotProgress(), 1);
      // A non-scrollable position reports 0, not a division by zero.
      expect(metrics(pixels: 0, max: 0).snapshotProgress(), 0);
    });

    test('progress clamps overscrolled positions', () {
      expect(metrics(pixels: -20, max: 400).snapshotProgress(), 0);
      expect(metrics(pixels: 420, max: 400).snapshotProgress(), 1);
    });

    test('overscrollPixels is signed and zero in range', () {
      expect(metrics(pixels: 200).snapshot.overscrollPixels, 0);
      expect(metrics(pixels: -20).snapshot.overscrollPixels, -20);
      expect(metrics(pixels: 420).snapshot.overscrollPixels, 20);
      expect(metrics(pixels: -20).snapshot.atStart, isTrue);
      expect(metrics(pixels: 420).snapshot.atEnd, isTrue);
      expect(metrics(pixels: 200).snapshot.atStart, isFalse);
      expect(metrics(pixels: 200).snapshot.atEnd, isFalse);
    });

    test('fade fractions match the old fade viewport math', () {
      final snapshot = metrics(pixels: 50, max: 400).snapshot;
      expect(snapshot.leadingFadeFraction(100), 0.5);
      expect(snapshot.trailingFadeFraction(100), 1);
      expect(snapshot.leadingFadeFraction(0), 0);
      expect(
        metrics(pixels: 400, max: 400).snapshot.leadingFadeFraction(100),
        1,
      );
      expect(
        metrics(pixels: 0, max: 400).snapshot.trailingFadeFraction(100),
        1,
      );
    });

    test('overscroll fractions only grow when dragged past an edge', () {
      final idle = metrics(pixels: 200, max: 400).snapshot;
      expect(idle.leadingOverscrollFraction(100), 0);
      expect(idle.trailingOverscrollFraction(100), 0);

      final before = metrics(pixels: -20, max: 400).snapshot;
      expect(before.leadingOverscrollFraction(100), 0.2);
      expect(before.trailingOverscrollFraction(100), 0);

      final after = metrics(pixels: 420, max: 400).snapshot;
      expect(after.leadingOverscrollFraction(100), 0);
      expect(after.trailingOverscrollFraction(100), 0.2);
      expect(after.trailingOverscrollFraction(0), 0);
    });

    test('thumb geometry reflects the visible fraction', () {
      final snapshot = metrics(pixels: 100, max: 400, viewport: 100).snapshot;
      // visible = viewport / (scrollable + viewport) = 100 / 500.
      expect(snapshot.thumbExtent(200, minExtent: 0), closeTo(40, 0.001));
      expect(snapshot.thumbOffset(200, 40), closeTo(40, 0.001));
    });

    test('thumb cannot shrink below the minimum or exceed the track', () {
      final snapshot = metrics(pixels: 100, max: 400, viewport: 100).snapshot;
      expect(snapshot.thumbExtent(200), kMinScrollbarThumbExtent);
      // The minimum is capped at the track length, like Flutter's scrollbar.
      expect(snapshot.thumbExtent(30), 30);
      expect(
        snapshot.thumbExtent(double.infinity, minExtent: 0),
        double.infinity,
      );
    });

    test('a non-scrollable snapshot fills the whole track', () {
      final snapshot = metrics(pixels: 0, max: 0, viewport: 100).snapshot;
      expect(snapshot.canScroll, isFalse);
      expect(snapshot.thumbExtent(200, minExtent: 0), 200);
      expect(snapshot.thumbOffset(200, 200), 0);
    });

    test('reversed axes place the thumb from the far end', () {
      final snapshot = metrics(
        pixels: 100,
        max: 400,
        viewport: 100,
        direction: AxisDirection.up,
      ).snapshot;
      expect(snapshot.reversed, isTrue);
      expect(snapshot.thumbOffset(200, 48), closeTo(114, 0.001));
      expect(
        snapshot.thumbOffset(200, 48, reversed: false),
        closeTo(38, 0.001),
      );
    });

    test('pixelsForThumbOffset inverts thumbOffset', () {
      for (final direction in [AxisDirection.down, AxisDirection.up]) {
        final snapshot = metrics(
          pixels: 100,
          max: 400,
          viewport: 100,
          direction: direction,
        ).snapshot;
        const track = 200.0;
        final thumb = snapshot.thumbExtent(track);
        final offset = snapshot.thumbOffset(track, thumb);
        expect(
          snapshot.pixelsForThumbOffset(
            thumbOffset: offset,
            trackExtent: track,
            thumbExtent: thumb,
          ),
          closeTo(100, 0.001),
        );
      }
    });

    test('equality compares every field', () {
      final a = metrics(pixels: 10).snapshot;
      expect(a, metrics(pixels: 10).snapshot);
      expect(a, isNot(metrics(pixels: 11).snapshot));
      expect(a, isNot(metrics(pixels: 10, viewport: 99).snapshot));
      expect(
        a,
        isNot(metrics(pixels: 10, direction: AxisDirection.up).snapshot),
      );
    });
  });

  group('helpers', () {
    test('clampScrollPixels clamps unless overscroll is allowed', () {
      expect(
        clampScrollPixels(420, minScrollExtent: 0, maxScrollExtent: 400),
        400,
      );
      expect(
        clampScrollPixels(-5, minScrollExtent: 0, maxScrollExtent: 400),
        0,
      );
      expect(
        clampScrollPixels(
          420,
          minScrollExtent: 0,
          maxScrollExtent: 400,
          allowOverscroll: true,
        ),
        420,
      );
      expect(
        clampScrollPixels(
          double.nan,
          minScrollExtent: 12,
          maxScrollExtent: 400,
        ),
        12,
      );
      expect(
        clampScrollPixels(50, minScrollExtent: 100, maxScrollExtent: 50),
        100,
      );
    });

    test('maxScrollExtentFor never goes negative', () {
      expect(maxScrollExtentFor(contentExtent: 500, viewportExtent: 100), 400);
      expect(maxScrollExtentFor(contentExtent: 80, viewportExtent: 100), 0);
    });
  });
}

extension on FixedScrollMetrics {
  ScrollMetricsSnapshot get snapshot => ScrollMetricsSnapshot.fromMetrics(this);

  double snapshotProgress() => snapshot.progress;
}
