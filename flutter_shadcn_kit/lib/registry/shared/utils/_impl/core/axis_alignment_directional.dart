// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../axis.dart';

/// AxisAlignmentDirectional defines a reusable type for this registry module.
class AxisAlignmentDirectional extends AxisAlignmentGeometry {
  static const AxisAlignmentDirectional start = AxisAlignmentDirectional(-1.0);
  static const AxisAlignmentDirectional end = AxisAlignmentDirectional(1.0);
  static const AxisAlignmentDirectional center = AxisAlignmentDirectional(0.0);

  /// Stores `value` state/configuration for this implementation.
  final double value;

  const AxisAlignmentDirectional(this.value);

  @override
  /// Executes `resolve` behavior for this component/composite.
  AxisAlignment resolve(TextDirection textDirection) {
    return AxisAlignment._(textDirection, value);
  }
}
