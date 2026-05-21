// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../window.dart';

/// WindowSnapStrategy defines a reusable type for this registry module.
class WindowSnapStrategy {
  /// Relative bounds where the window should snap, in screen-relative coordinates.
  ///
  /// Values range from 0.0 to 1.0, representing proportions of the screen.
  /// For example, `Rect.fromLTWH(0, 0, 0.5, 1)` represents the left half
  /// of the screen (0% to 50% horizontally, full height).
  final Rect relativeBounds;

  /// Whether the window should be minimized during the snap operation.
  ///
  /// When `true`, the window will minimize before snapping to the target
  /// position. When `false`, the window immediately snaps without minimizing.
  ///
  /// Defaults to `true`.
  final bool shouldMinifyWindow;

  /// Creates a window snap strategy with the specified bounds and behavior.
  ///
  /// Parameters:
  /// - [relativeBounds]: Target screen region (required, in 0.0-1.0 coordinates)
  /// - [shouldMinifyWindow]: Whether to minimize during snap (defaults to `true`)
  const WindowSnapStrategy({
    required this.relativeBounds,
    this.shouldMinifyWindow = true,
  });
}
