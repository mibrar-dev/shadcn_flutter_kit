// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../fade_scroll.dart';

/// _ScaleGradient defines a reusable type for this registry module.
class _ScaleGradient extends GradientTransform {
  /// Stores `scale` state/configuration for this implementation.
  final Offset scale;

  const _ScaleGradient(this.scale);

  @override
  Matrix4? transform(Rect bounds, {TextDirection? textDirection}) {
    /// Stores `center` state/configuration for this implementation.
    final center = bounds.center;
    final dx = center.dx * (1 - scale.dx);
    final dy = center.dy * (1 - scale.dy);
    return Matrix4.identity()
      ..translateByDouble(dx, dy, 0, 1)
      ..scaleByDouble(scale.dx, scale.dy, 1, 1)
      ..translateByDouble(-dx, -dy, 0, 1);
  }
}
