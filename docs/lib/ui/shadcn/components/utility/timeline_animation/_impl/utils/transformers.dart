// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../timeline_animation.dart';

/// Transformers defines a reusable type for this registry module.
class Transformers {
  const Transformers._();

  /// Executes `typeInt` behavior for this component/composite.
  static int? typeInt(int? a, int? b, double t) {
    if (a == null || b == null) return null;
    return (a + (b - a) * t).round();
  }

  /// Executes `typeDouble` behavior for this component/composite.
  static double? typeDouble(double? a, double? b, double t) {
    if (a == null || b == null) return null;
    return lerpDouble(a, b, t);
  }

  /// Executes `typeColor` behavior for this component/composite.
  static Color? typeColor(Color? a, Color? b, double t) {
    return Color.lerp(a, b, t);
  }

  /// Executes `typeOffset` behavior for this component/composite.
  static Offset? typeOffset(Offset? a, Offset? b, double t) {
    return Offset.lerp(a, b, t);
  }

  /// Executes `typeSize` behavior for this component/composite.
  static Size? typeSize(Size? a, Size? b, double t) {
    return Size.lerp(a, b, t);
  }

  /// Executes `typeRect` behavior for this component/composite.
  static Rect? typeRect(Rect? a, Rect? b, double t) {
    return Rect.lerp(a, b, t);
  }
}

/// Defines a segment in a timeline animation.
