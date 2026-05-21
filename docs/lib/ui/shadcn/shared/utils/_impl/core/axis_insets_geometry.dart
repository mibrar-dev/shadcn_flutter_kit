// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../axis.dart';

/// Base class for axis-based insets.
///
/// This allows defining insets along a single axis (start/end) which can be
/// resolved to concrete values based on [TextDirection].
abstract class AxisInsetsGeometry {
  /// Creates an [AxisInsetsGeometry].
  const AxisInsetsGeometry();

  /// Resolves the insets to a concrete [AxisInsets] based on the text direction.
  ///
  /// Parameters:
  /// - [textDirection] (`TextDirection`, required): The text direction to resolve against.
  ///
  /// Returns:
  /// An [AxisInsets] with resolved start/end values.
  AxisInsets resolve(TextDirection textDirection);
}
