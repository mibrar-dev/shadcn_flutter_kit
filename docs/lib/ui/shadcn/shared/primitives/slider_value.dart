// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'dart:ui';

/// Represents a single-thumb or range slider value.
class SliderValue {
  /// Stores `_start` state/configuration for this implementation.
  final double? _start;

  /// Stores `_end` state/configuration for this implementation.
  final double _end;

  /// Creates a `SliderValue.single` instance.
  const SliderValue.single(double value) : _start = null, _end = value;

  /// Creates a `SliderValue.ranged` instance.
  const SliderValue.ranged(double start, double end)
    : _start = start,
      _end = end;

  /// Stores `isRanged` state/configuration for this implementation.
  bool get isRanged => _start != null;

  /// Stores `start` state/configuration for this implementation.
  double get start => _start ?? _end;

  /// Stores `end` state/configuration for this implementation.
  double get end => _end;

  /// Stores `value` state/configuration for this implementation.
  double get value => _end;

  /// Executes `lerp` behavior for this component/composite.
  static SliderValue? lerp(SliderValue? a, SliderValue? b, double t) {
    if (a == null || b == null) return null;
    if (a.isRanged && b.isRanged) {
      return SliderValue.ranged(
        /// Creates a `lerpDouble` instance.
        lerpDouble(a.start, b.start, t)!,

        /// Creates a `lerpDouble` instance.
        lerpDouble(a.end, b.end, t)!,
      );
    } else if (!a.isRanged && !b.isRanged) {
      return SliderValue.single(lerpDouble(a.value, b.value, t)!);
    }
    return null;
  }

  /// Executes `roundToDivisions` behavior for this component/composite.
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
  /// Executes `operator ==` behavior for this component/composite.
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SliderValue && other._start == _start && other._end == _end;
  }

  @override
  int get hashCode => Object.hash(_start, _end);
}
