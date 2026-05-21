// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../linear_progress_indicator.dart';

/// Internal helper class used by the linear progress indicator component implementation.
class _LinearProgressIndicatorProperties {
  /// Input parameter used by `_LinearProgressIndicatorProperties` during rendering and behavior handling.
  final double start;

  /// Input parameter used by `_LinearProgressIndicatorProperties` during rendering and behavior handling.
  final double end;

  /// Input parameter used by `_LinearProgressIndicatorProperties` during rendering and behavior handling.
  final double? start2;

  /// Input parameter used by `_LinearProgressIndicatorProperties` during rendering and behavior handling.
  final double? end2;

  /// Color value used by linear progress indicator painting or state styling.
  final Color color;

  /// Color value used by linear progress indicator painting or state styling.
  final Color backgroundColor;

  /// Input parameter used by `_LinearProgressIndicatorProperties` during rendering and behavior handling.
  final bool showSparks;

  /// Color value used by linear progress indicator painting or state styling.
  final Color sparksColor;

  /// Layout/size setting that affects linear progress indicator rendering.
  final double sparksRadius;

  /// Data consumed by `_LinearProgressIndicatorProperties` to render linear progress indicator content.
  final TextDirection textDirection;

  /// Creates `_LinearProgressIndicatorProperties` for configuring or rendering linear progress indicator.
  const _LinearProgressIndicatorProperties({
    required this.start,
    required this.end,
    this.start2,
    this.end2,
    required this.color,
    required this.backgroundColor,
    required this.showSparks,
    required this.sparksColor,
    required this.sparksRadius,
    required this.textDirection,
  });

  static _LinearProgressIndicatorProperties lerp(
    _LinearProgressIndicatorProperties? a,
    _LinearProgressIndicatorProperties? b,
    double t,
  ) {
    final start = a ?? b;

    final end = b ?? a;
    assert(start != null && end != null);
    return _LinearProgressIndicatorProperties(
      start: _lerpDouble(start!.start, end!.start, t)!,
      end: _lerpDouble(start.end, end.end, t)!,
      start2: _lerpDouble(start.start2, end.start2, t),
      end2: _lerpDouble(start.end2, end.end2, t),
      color: Color.lerp(start.color, end.color, t)!,
      backgroundColor: Color.lerp(
        start.backgroundColor,
        end.backgroundColor,
        t,
      )!,
      showSparks: end.showSparks,
      sparksColor: Color.lerp(start.sparksColor, end.sparksColor, t)!,
      sparksRadius: _lerpDouble(start.sparksRadius, end.sparksRadius, t)!,
      textDirection: end.textDirection,
    );
  }
}

/// Implements `_lerpDouble` behavior for linear progress indicator.
double? _lerpDouble(double? a, double? b, double t) {
  if (a == null && b == null) {
    return null;
  }
  if (a!.isNaN || b!.isNaN) {
    return double.nan;
  }
  return a + (b - a) * t;
}
