// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../color.dart';

/// A non-directional gradient angle that uses standard [Alignment].
///
/// Unlike [DirectionalGradientAngle], this class uses non-directional [Alignment]
/// and is not affected by text direction. The angle is specified in radians.
///
/// Example:
/// ```dart
/// const angle = GradientAngle(pi / 4); // 45 degrees
/// final begin = angle.begin;
/// final end = angle.end;
/// ```
class GradientAngle extends GradientAngleGeometry {
  @override
  /// The angle of the gradient in radians.
  final double angle;

  /// Creates a [GradientAngle] with the specified [angle] in radians.
  const GradientAngle(this.angle);

  @override
  /// The beginning alignment calculated from the angle.
  AlignmentGeometry get begin {
    final x = 0.5 + 0.5 * cos(angle);
    final y = 0.5 + 0.5 * sin(angle);
    return Alignment(x * 2 - 1, y * 2 - 1);
  }

  @override
  /// The ending alignment calculated from the angle.
  AlignmentGeometry get end {
    final x = 0.5 + 0.5 * cos(angle + pi);
    final y = 0.5 + 0.5 * sin(angle + pi);
    return Alignment(x * 2 - 1, y * 2 - 1);
  }
}
