// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../axis.dart';

/// AxisAlignment defines a reusable type for this registry module.
class AxisAlignment extends AxisAlignmentGeometry {
  static const AxisAlignment left = AxisAlignment(-1.0);
  static const AxisAlignment right = AxisAlignment(1.0);
  static const AxisAlignment center = AxisAlignment(0.0);

  /// Stores `direction` state/configuration for this implementation.
  final TextDirection? direction;

  /// Stores `value` state/configuration for this implementation.
  final double value;

  const AxisAlignment._(this.direction, this.value);
  const AxisAlignment(this.value) : direction = null;

  /// Returns the resolved alignment value for the provided [axis].
  double resolveValue(Axis axis) {
    return switch ((direction, axis)) {
      (TextDirection.ltr, Axis.horizontal) => value,
      (TextDirection.rtl, Axis.horizontal) => value * -1,
      _ => value,
    };
  }

  /// Positions a child within a span of [size] using this alignment.
  double alongValue(Axis axis, double size) {
    /// Stores `center` state/configuration for this implementation.
    final center = size / 2;
    return center + resolveValue(axis) * center;
  }

  /// Converts this axis alignment to an [Alignment] using the provided horizontal value.
  Alignment asHorizontalAlignment(AxisAlignment crossAxisAlignment) {
    return Alignment(resolveValue(Axis.horizontal), crossAxisAlignment.value);
  }

  /// Converts this axis alignment to an [Alignment] using the provided vertical value.
  Alignment asVerticalAlignment(AxisAlignment crossAxisAlignment) {
    return Alignment(crossAxisAlignment.value, resolveValue(Axis.vertical));
  }

  @override
  /// Executes `resolve` behavior for this component/composite.
  AxisAlignment resolve(TextDirection textDirection) {
    return AxisAlignment._(textDirection, value);
  }
}

/// Directional axis alignment that resolves relative to text direction.
