// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../scaffold.dart';

/// ScaffoldPaddingStorage defines a reusable type for this registry module.
class ScaffoldPaddingStorage {
  /// Top padding value.
  double top;

  /// Left padding value.
  double left;

  /// Right padding value.
  double right;

  /// Bottom padding value.
  double bottom;

  /// Creates a [ScaffoldPaddingStorage].
  ///
  /// Parameters:
  /// - [top] (`double`, required): Top padding.
  /// - [left] (`double`, required): Left padding.
  /// - [right] (`double`, required): Right padding.
  /// - [bottom] (`double`, required): Bottom padding.
  ScaffoldPaddingStorage({
    required this.top,
    required this.left,
    required this.right,
    required this.bottom,
  });
}
