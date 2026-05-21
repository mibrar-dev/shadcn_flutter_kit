// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../carousel.dart';

/// A fixed carousel size constraint.
class CarouselFixedConstraint extends CarouselSizeConstraint {
  /// The size of the constraint.
  final double size;

  /// Creates a fixed carousel size constraint.
  const CarouselFixedConstraint(this.size)
    : assert(size > 0, 'size must be greater than 0');
}
