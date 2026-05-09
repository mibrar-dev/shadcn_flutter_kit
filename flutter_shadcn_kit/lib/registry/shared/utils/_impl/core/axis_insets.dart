// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../axis.dart';

/// Insets along an axis with support for directionality.
class AxisInsets extends AxisInsetsGeometry {
  /// The text direction, if any.
  final TextDirection? direction;

  /// The start value.
  final double start;

  /// The end value.
  final double end;

  /// Creates an [AxisInsets].
  ///
  /// Parameters:
  /// - [start] (`double`, required): The start value.
  /// - [end] (`double`, required): The end value.
  const AxisInsets({required this.start, required this.end}) : direction = null;
  const AxisInsets._(this.start, this.end, this.direction);

  /// Resolves the start and end values for a specific axis.
  ///
  /// Parameters:
  /// - [axis] (`Axis`, required): The axis to resolve for.
  ///
  /// Returns:
  /// A record containing the start and end values.
  ({double start, double end}) resolveValue(Axis axis) {
    return switch ((direction, axis)) {
      (TextDirection.ltr, Axis.horizontal) => (start: start, end: end),
      (TextDirection.rtl, Axis.horizontal) => (start: end, end: start),
      _ => (start: start, end: end),
    };
  }

  @override
  /// Creates a `AxisInsets` instance.
  AxisInsets resolve(TextDirection textDirection) {
    return AxisInsets._(start, end, textDirection);
  }
}
