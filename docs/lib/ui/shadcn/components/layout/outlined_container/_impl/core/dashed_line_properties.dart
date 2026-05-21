// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../outlined_container.dart';

/// DashedLineProperties defines a reusable type for this registry module.
class DashedLineProperties {
  /// Stores `width` state/configuration for this implementation.
  final double width;

  /// Stores `gap` state/configuration for this implementation.
  final double gap;

  /// Stores `thickness` state/configuration for this implementation.
  final double thickness;

  /// Stores `color` state/configuration for this implementation.
  final Color color;

  /// Creates a `DashedLineProperties` instance.
  const DashedLineProperties({
    required this.width,
    required this.gap,
    required this.thickness,
    required this.color,
  });

  static DashedLineProperties lerp(
    DashedLineProperties a,
    DashedLineProperties b,
    double t,
  ) {
    return DashedLineProperties(
      width: lerpDouble(a.width, b.width, t)!,
      gap: lerpDouble(a.gap, b.gap, t)!,
      thickness: lerpDouble(a.thickness, b.thickness, t)!,
      color: Color.lerp(a.color, b.color, t)!,
    );
  }
}
