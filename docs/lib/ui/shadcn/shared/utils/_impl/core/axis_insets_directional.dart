// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../axis.dart';

/// Directional insets along an axis.
///
/// These insets are defined as start and end, and resolve to left/right or
/// right/left based on the [TextDirection].
class AxisInsetsDirectional extends AxisInsetsGeometry {
  /// The start value.
  final double start;

  /// The end value.
  final double end;

  /// Creates an [AxisInsetsDirectional].
  ///
  /// Parameters:
  /// - [start] (`double`, required): The start value.
  /// - [end] (`double`, required): The end value.
  const AxisInsetsDirectional({required this.start, required this.end});

  @override
  /// Executes `resolve` behavior for this component/composite.
  AxisInsets resolve(TextDirection textDirection) {
    return AxisInsets._(start, end, textDirection);
  }
}
