// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../carousel.dart';

/// Internal helper class used by the carousel component implementation.
class _PlacedCarouselItem {
  /// Input parameter used by `_PlacedCarouselItem` during rendering and behavior handling.
  final int relativeIndex;

  /// Child content displayed inside the carousel widget.
  final Widget child;

  /// Input parameter used by `_PlacedCarouselItem` during rendering and behavior handling.
  final double position;

  /// Creates `_PlacedCarouselItem._` for configuring or rendering carousel.
  const _PlacedCarouselItem._({
    required this.relativeIndex,
    required this.child,
    required this.position,
  });
}
