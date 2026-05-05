import 'package:flutter/widgets.dart';

T tweenValue<T>(T begin, T end, double t) {
/// Stores `beginValue` state/configuration for this implementation.
  dynamic beginValue = begin;
/// Stores `endValue` state/configuration for this implementation.
  dynamic endValue = end;
  return (beginValue + (endValue - beginValue) * t) as T;
}

/// A tween for animating between two [IconThemeData] values.
class IconThemeDataTween extends Tween<IconThemeData> {
  /// Creates an [IconThemeDataTween].
  IconThemeDataTween({super.begin, super.end});

  @override
/// Executes `lerp` behavior for this component/composite.
  IconThemeData lerp(double t) => IconThemeData.lerp(begin, end, t);
}
