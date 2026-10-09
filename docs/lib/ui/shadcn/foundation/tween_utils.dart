// Tween/lerp helpers. The old `shared/utils/tween_utils.dart` only needs
// Flutter's animation primitives, so it lives in the zero-dependency layer
// (P2-E1 decision; the audit had provisionally marked it `theme`).

import 'package:flutter/widgets.dart';

/// Interpolates `begin -> end` at [t] for `num`-like values.
T tweenValue<T>(T begin, T end, double t) {
  final dynamic beginValue = begin;
  final dynamic endValue = end;
  return (beginValue + (endValue - beginValue) * t) as T;
}

/// A tween between two [IconThemeData] values.
class IconThemeDataTween extends Tween<IconThemeData> {
  /// Creates an [IconThemeDataTween].
  IconThemeDataTween({super.begin, super.end});

  @override
  IconThemeData lerp(double t) => IconThemeData.lerp(begin, end, t);
}
