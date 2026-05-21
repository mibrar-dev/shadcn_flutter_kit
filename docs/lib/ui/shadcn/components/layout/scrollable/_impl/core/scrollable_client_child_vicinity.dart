// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../scrollable.dart';

/// _ScrollableClientChildVicinity defines a reusable type for this registry module.
class _ScrollableClientChildVicinity extends ChildVicinity {
  /// Stores `viewportSize` state/configuration for this implementation.
  final Size viewportSize;

  /// Creates a `_ScrollableClientChildVicinity` instance.
  const _ScrollableClientChildVicinity({
    required this.viewportSize,
    required super.xIndex,
    required super.yIndex,
  });
}
