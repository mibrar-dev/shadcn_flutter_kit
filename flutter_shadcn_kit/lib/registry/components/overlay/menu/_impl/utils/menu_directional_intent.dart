// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../menu.dart';

/// DirectionalMenuFocusIntent defines a reusable type for this registry module.
class DirectionalMenuFocusIntent extends Intent {
  /// Direction of focus traversal.
  final TraversalDirection direction;

  /// Creates a directional menu focus intent.
  ///
  /// Parameters:
  /// - [direction] (TraversalDirection, required): Traversal direction
  const DirectionalMenuFocusIntent(this.direction);
}
