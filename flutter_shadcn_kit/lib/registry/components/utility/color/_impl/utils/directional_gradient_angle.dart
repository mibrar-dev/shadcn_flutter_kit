// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../color.dart';

/// A directional gradient angle that is aware of text direction.
///
/// [DirectionalGradientAngle] uses [AlignmentDirectional] for its alignments,
/// making it responsive to the text direction (LTR or RTL). The angle is specified
/// in radians and determines the direction of the gradient.
///
/// Example:
/// ```dart
/// const angle = DirectionalGradientAngle(0.0); // 0 radians (horizontal)
/// final begin = angle.begin; // Start alignment
/// final end = angle.end;     // End alignment
/// ```
class DirectionalGradientAngle extends GradientAngleGeometry {
  @override
  /// The angle of the gradient in radians.
  final double angle;

  /// Creates a [DirectionalGradientAngle] with the specified [angle] in radians.
  const DirectionalGradientAngle(this.angle);

  @override
  /// The beginning alignment calculated from the angle.
  AlignmentGeometry get begin {
    final x = 0.5 + 0.5 * cos(angle);
    final y = 0.5 + 0.5 * sin(angle);
    return AlignmentDirectional(x * 2 - 1, y * 2 - 1);
  }

  @override
  /// The ending alignment calculated from the angle.
  AlignmentGeometry get end {
    final x = 0.5 + 0.5 * cos(angle + pi);
    final y = 0.5 + 0.5 * sin(angle + pi);
    return AlignmentDirectional(x * 2 - 1, y * 2 - 1);
  }
}
