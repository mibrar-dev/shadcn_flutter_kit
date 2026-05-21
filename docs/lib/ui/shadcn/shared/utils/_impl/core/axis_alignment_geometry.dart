// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../axis.dart';

/// AxisAlignmentGeometry defines a reusable type for this registry module.
abstract class AxisAlignmentGeometry {
  /// Creates an [AxisAlignmentGeometry].
  const AxisAlignmentGeometry();

  /// Resolves this alignment to a concrete [AxisAlignment] for a specific direction.
  AxisAlignment resolve(TextDirection textDirection);
}

/// Alignment along a single axis, compatible with [AxisAlignmentGeometry].
