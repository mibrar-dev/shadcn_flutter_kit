// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../carousel.dart';

/// Size constraint for the carousel.
abstract class CarouselSizeConstraint {
  /// Creates a carousel size constraint.
  const CarouselSizeConstraint();

  /// Creates a fixed carousel size constraint.
  const factory CarouselSizeConstraint.fixed(double size) =
      CarouselFixedConstraint;

  /// Creates a fractional carousel size constraint.
  const factory CarouselSizeConstraint.fractional(double fraction) =
      CarouselFractionalConstraint;
}

/// Builds a carousel item.
/// The [index] is the index of the item.
typedef CarouselItemBuilder = Widget Function(BuildContext context, int index);
