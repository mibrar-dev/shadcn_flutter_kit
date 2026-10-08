// Geometry and value logic for the `slider` component: snapping strategies,
// step marks, thumb placement and pointer value mapping.
//
// Widgets-only: no Material/Cupertino, no paint code (the painter lives in
// `slider.dart`). Extracted from the old `_impl/core/shad_slider_logic.dart`
// and `shad_slider_models.dart`; the old `Semantics`-less,
// Material-importing code and the `ShadRangeValue` model (replaced by the
// shared `SliderValue` primitive) are gone.

import 'dart:math' as math;

import 'package:flutter/widgets.dart';

/// How tap/drag output values are quantized.
sealed class SliderSnap {
  const SliderSnap();

  /// Continuous values; clamped only.
  const factory SliderSnap.none() = SliderSnapNone;

  /// Evenly spaced intervals across `[min, max]`.
  const factory SliderSnap.steps(int steps) = SliderSnapSteps;

  /// Nearest entry of an explicit value list.
  const factory SliderSnap.values(List<double> values) = SliderSnapValues;

  /// Quantizes [v] for [min]..[max].
  double apply(double v, double min, double max) {
    return switch (this) {
      SliderSnapNone() => v.clamp(min, max),
      SliderSnapSteps(:final steps) => _applySteps(v, min, max, steps),
      SliderSnapValues(:final values) => _applyValues(v, min, max, values),
    };
  }

  /// Marks to paint for this snap strategy.
  List<SliderMark> marks(double min, double max) {
    return switch (this) {
      SliderSnapNone() => const <SliderMark>[],
      SliderSnapSteps(:final steps) => List<SliderMark>.generate(steps + 1, (
        i,
      ) {
        final t = i / steps;
        return SliderMark(value: min + (max - min) * t, t: t);
      }),
      SliderSnapValues(:final values) => (values.toList()..sort()).map((v) {
        final t = max == min ? 0.0 : ((v - min) / (max - min)).clamp(0.0, 1.0);
        return SliderMark(value: v, t: t);
      }).toList(),
    };
  }

  static double _applySteps(double v, double min, double max, int steps) {
    if ((max - min).abs() < 1e-9) {
      return min;
    }
    final t = ((v - min) / (max - min)).clamp(0.0, 1.0);
    final qt = (t * steps).round() / steps;
    return (min + (max - min) * qt).clamp(min, max);
  }

  static double _applyValues(
    double v,
    double min,
    double max,
    List<double> values,
  ) {
    if (values.isEmpty) {
      return v.clamp(min, max);
    }
    var best = values.first;
    var bestDistance = (v - best).abs();
    for (final candidate in values.skip(1)) {
      final distance = (v - candidate).abs();
      if (distance < bestDistance) {
        bestDistance = distance;
        best = candidate;
      }
    }
    return best.clamp(min, max);
  }
}

/// Continuous snapping (clamp only).
class SliderSnapNone extends SliderSnap {
  /// Creates a no-snap strategy.
  const SliderSnapNone();
}

/// Evenly spaced snapping.
class SliderSnapSteps extends SliderSnap {
  /// Creates a step strategy; [steps] must be positive.
  const SliderSnapSteps(this.steps) : assert(steps > 0);

  /// Number of intervals across the domain.
  final int steps;
}

/// Nearest-value snapping.
class SliderSnapValues extends SliderSnap {
  /// Creates a value-list strategy.
  const SliderSnapValues(this.values);

  /// Candidate values; an empty list falls back to clamping.
  final List<double> values;
}

/// One paintable mark on the track.
class SliderMark {
  /// Creates a mark; [t] is the normalized `0..1` position.
  const SliderMark({required this.value, required this.t});

  /// Value at this mark.
  final double value;

  /// Normalized position in `[0, 1]`.
  final double t;
}

/// Placement of a single thumb inside the slider canvas.
class SliderThumb {
  /// Creates a thumb placement.
  const SliderThumb({
    required this.index,
    required this.value,
    required this.t,
    required this.center,
    required this.size,
    required this.active,
    required this.enabled,
  });

  /// Thumb index (`0` = single value or range start, `1` = range end).
  final int index;

  /// Resolved value at this thumb.
  final double value;

  /// Normalized position in `[0, 1]`.
  final double t;

  /// Center in canvas coordinates.
  final Offset center;

  /// Layout size of the thumb.
  final Size size;

  /// Whether this thumb is being dragged.
  final bool active;

  /// Whether interaction is enabled.
  final bool enabled;
}

/// Immutable snapshot of the geometry derived from config + value.
class SliderView {
  /// Creates a geometry snapshot.
  const SliderView({
    required this.min,
    required this.max,
    required this.enabled,
    required this.isRange,
    required this.textDirection,
    required this.trackRect,
    required this.trackRadius,
    required this.thumbInset,
    required this.thumbs,
    required this.marks,
    this.activeThumb,
    this.value,
    this.rangeStart,
    this.rangeEnd,
    this.activeRect,
    this.fillRect,
  });

  /// Domain minimum.
  final double min;

  /// Domain maximum.
  final double max;

  /// Interaction enabled.
  final bool enabled;

  /// Whether this is a two-thumb slider.
  final bool isRange;

  /// Resolved text direction.
  final TextDirection textDirection;

  /// Track bounds in canvas coordinates.
  final Rect trackRect;

  /// Track corner radius (already clamped).
  final double trackRadius;

  /// Effective horizontal inset of thumb centers.
  final double thumbInset;

  /// Thumb placements.
  final List<SliderThumb> thumbs;

  /// Snap marks to paint.
  final List<SliderMark> marks;

  /// Index of the active thumb, if any.
  final int? activeThumb;

  /// Single-mode value (null in range mode).
  final double? value;

  /// Range start (range mode only).
  final double? rangeStart;

  /// Range end (range mode only).
  final double? rangeEnd;

  /// Fill rect between range thumbs (range mode only).
  final Rect? activeRect;

  /// Fill rect from start to the single thumb (single mode only).
  final Rect? fillRect;
}

/// Builds [SliderView] snapshots and maps pointer positions back to values.
class SliderLogic {
  /// Normalized `0..1` for [value] over `[min, max]`, clamped.
  static double tForValue(double value, double min, double max) {
    final range = max - min;
    if (range == 0) {
      return 0;
    }
    return ((value - min) / range).clamp(0.0, 1.0);
  }

  /// Value for a normalized [t] over `[min, max]`.
  static double valueForT(double t, double min, double max) =>
      min + (max - min) * t;

  /// Builds a geometry snapshot.
  ///
  /// [thumbEdgeOffsetPx] pushes thumb centers inward (positive) / outward
  /// (negative) relative to the inside track edge; the default `0.5 *
  /// thumbSize.width`-clamped inset keeps thumbs fully on the track.
  SliderView buildView({
    required double min,
    required double max,
    required SliderSnap snap,
    required bool enabled,
    required Rect trackRect,
    required double trackRadius,
    required double thumbInset,
    required bool dragging,
    required int? activeThumb,
    required Size thumbSize,
    required TextDirection textDirection,
    required double? value,
    required double? rangeStart,
    required double? rangeEnd,
  }) {
    final isRange = rangeStart != null && rangeEnd != null;
    final double? start = rangeStart;
    final double? end = rangeEnd;
    final baseInset = math.max(thumbInset, thumbSize.width / 2);
    final inset = baseInset.clamp(0.0, trackRect.width / 2);
    final minX = trackRect.left + inset;
    final maxX = trackRect.right - inset;
    final usable = math.max(0.0, maxX - minX);

    double xForT(double t) => textDirection == TextDirection.rtl
        ? maxX - usable * t
        : minX + usable * t;

    final thumbs = <SliderThumb>[];
    if (!isRange) {
      final v = (value ?? min).clamp(min, max);
      final t = tForValue(v, min, max);
      thumbs.add(
        SliderThumb(
          index: 0,
          value: v,
          t: t,
          center: Offset(xForT(t), trackRect.center.dy),
          size: thumbSize,
          active: (activeThumb ?? 0) == 0 && dragging,
          enabled: enabled,
        ),
      );
    } else {
      final lo = math.min(rangeStart, rangeEnd);
      final hi = math.max(rangeStart, rangeEnd);
      final t0 = tForValue(lo, min, max);
      final t1 = tForValue(hi, min, max);
      thumbs.add(
        SliderThumb(
          index: 0,
          value: lo,
          t: t0,
          center: Offset(xForT(t0), trackRect.center.dy),
          size: thumbSize,
          active: activeThumb == 0 && dragging,
          enabled: enabled,
        ),
      );
      thumbs.add(
        SliderThumb(
          index: 1,
          value: hi,
          t: t1,
          center: Offset(xForT(t1), trackRect.center.dy),
          size: thumbSize,
          active: activeThumb == 1 && dragging,
          enabled: enabled,
        ),
      );
    }

    final trackTop = trackRect.top;
    final trackHeight = trackRect.height;
    Rect? fillRect;
    Rect? activeRect;
    if (!isRange) {
      final endX = thumbs.first.center.dx;
      final startX = textDirection == TextDirection.rtl ? endX : trackRect.left;
      final stopX = textDirection == TextDirection.rtl ? trackRect.right : endX;
      fillRect = Rect.fromLTRB(
        math.min(startX, stopX),
        trackTop,
        math.max(startX, stopX),
        trackTop + trackHeight,
      );
    } else {
      final x0 = thumbs[0].center.dx;
      final x1 = thumbs[1].center.dx;
      activeRect = Rect.fromLTRB(
        math.min(x0, x1),
        trackTop,
        math.max(x0, x1),
        trackTop + trackHeight,
      );
    }

    return SliderView(
      min: min,
      max: max,
      enabled: enabled,
      isRange: isRange,
      textDirection: textDirection,
      trackRect: trackRect,
      trackRadius: trackRadius,
      thumbInset: inset,
      thumbs: thumbs,
      marks: snap.marks(min, max),
      activeThumb: activeThumb,
      value: isRange ? null : (value ?? min).clamp(min, max),
      rangeStart: (start != null && end != null) ? math.min(start, end) : null,
      rangeEnd: (start != null && end != null) ? math.max(start, end) : null,
      activeRect: activeRect,
      fillRect: fillRect,
    );
  }

  /// Index of the thumb nearest to [dx] (always `0` for single sliders).
  int pickActiveThumb(SliderView view, double dx) {
    if (!view.isRange) {
      return 0;
    }
    final d0 = (dx - view.thumbs[0].center.dx).abs();
    final d1 = (dx - view.thumbs[1].center.dx).abs();
    return d0 <= d1 ? 0 : 1;
  }

  /// Maps a pointer x position to a clamped, snapped value.
  double valueFromDx(SliderView view, SliderSnap snap, double dx) {
    final inset = view.thumbInset;
    final usable = math.max(0.0, view.trackRect.width - inset * 2);
    final x = view.textDirection == TextDirection.rtl
        ? (view.trackRect.width - dx)
        : dx;
    final t = usable == 0 ? 0.0 : ((x - inset) / usable).clamp(0.0, 1.0);
    final raw = valueForT(t, view.min, view.max);
    return snap.apply(raw, view.min, view.max);
  }
}
