// Value-shaping helpers for the `slider` component: range drag math and
// keyboard step computations. Pure functions over [SliderSnap] so the widget
// file stays small and the rules are unit-testable without a build context.

import 'dart:math' as math;

import 'slider_logic.dart';

/// Applies a dragged/key-adjusted value to one range thumb.
///
/// [allowSwap] false clamps the dragged thumb at `other +/- minRange`; true
/// lets the pair cross, expanding only enough to satisfy [minRange].
(double, double) sliderDraggedRange({
  required double v,
  required int thumbIndex,
  required double start,
  required double end,
  required double min,
  required double max,
  required double minRange,
  required bool allowSwap,
}) {
  final other = thumbIndex == 0 ? end : start;
  if (allowSwap) {
    var lo = math.min(v, other);
    var hi = math.max(v, other);
    if (hi - lo < minRange) {
      if (v <= other) {
        lo = (hi - minRange).clamp(min, max);
      } else {
        hi = (lo + minRange).clamp(min, max);
      }
    }
    return (lo, hi);
  }
  if (thumbIndex == 0) {
    return (v.clamp(min, other - minRange), other);
  }
  return (other, v.clamp(other + minRange, max));
}

/// One keyboard step from [current] along [snap]'s quantization.
double sliderStep({
  required SliderSnap snap,
  required double current,
  required int direction,
  required double min,
  required double max,
}) {
  final domain = max - min;
  return switch (snap) {
    SliderSnapNone() => (current + direction * domain / 100).clamp(min, max),
    SliderSnapSteps(:final steps) => snap.apply(
      current + direction * domain / steps,
      min,
      max,
    ),
    SliderSnapValues(:final values) => _stepThroughValues(
      values,
      current,
      direction,
    ),
  };
}

double _stepThroughValues(List<double> values, double current, int direction) {
  if (values.isEmpty) {
    return current;
  }
  final sorted = values.toList()..sort();
  if (direction > 0) {
    for (final v in sorted) {
      if (v > current) {
        return v;
      }
    }
    return sorted.last;
  }
  for (final v in sorted.reversed) {
    if (v < current) {
      return v;
    }
  }
  return sorted.first;
}

/// Ten [sliderStep]s in the same direction (PageUp/PageDown).
double sliderPageStep({
  required SliderSnap snap,
  required double current,
  required int direction,
  required double min,
  required double max,
}) {
  var next = current;
  for (var i = 0; i < 10; i++) {
    next = sliderStep(
      snap: snap,
      current: next,
      direction: direction,
      min: min,
      max: max,
    );
  }
  return next;
}
