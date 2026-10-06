// Value type for single and range sliders.
//
// Ported from `shared/primitives/slider_value.dart`.

import 'dart:ui';

/// A single-thumb or range slider value.
class SliderValue {
  final double? _start;
  final double _end;

  /// Creates a single-thumb value.
  const SliderValue.single(double value) : _start = null, _end = value;

  /// Creates a ranged value.
  const SliderValue.ranged(double start, double end)
    : _start = start,
      _end = end;

  /// Whether this value has two thumbs.
  bool get isRanged => _start != null;

  /// Range start (equals [end] for single values).
  double get start => _start ?? _end;

  /// Range end (the single value for single-thumb values).
  double get end => _end;

  /// Alias of [end].
  double get value => _end;

  /// Lerps two values; range/single mismatches return null.
  static SliderValue? lerp(SliderValue? a, SliderValue? b, double t) {
    if (a == null || b == null) return null;
    if (a.isRanged && b.isRanged) {
      return SliderValue.ranged(
        lerpDouble(a.start, b.start, t)!,
        lerpDouble(a.end, b.end, t)!,
      );
    } else if (!a.isRanged && !b.isRanged) {
      return SliderValue.single(lerpDouble(a.value, b.value, t)!);
    }
    return null;
  }

  /// Rounds both bounds to [divisions] steps.
  SliderValue roundToDivisions(int divisions) {
    if (!isRanged) {
      return SliderValue.single((_end * divisions).round() / divisions);
    }
    return SliderValue.ranged(
      (_start! * divisions).round() / divisions,
      (_end * divisions).round() / divisions,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SliderValue && other._start == _start && other._end == _end;
  }

  @override
  int get hashCode => Object.hash(_start, _end);
}
