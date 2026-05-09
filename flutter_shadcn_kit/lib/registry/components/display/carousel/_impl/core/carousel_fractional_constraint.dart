// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../carousel.dart';

/// A fractional carousel size constraint.
class CarouselFractionalConstraint extends CarouselSizeConstraint {
  /// The fraction of the constraint.
  final double fraction;

  /// Creates a fractional carousel size constraint.
  const CarouselFractionalConstraint(this.fraction)
    : assert(fraction > 0, 'fraction must be greater than 0');
}
