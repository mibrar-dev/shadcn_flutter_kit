// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../drawer_container.dart';

/// A cross-axis size for a drawer/sheet container, resolved against the
/// available cross-axis extent (upstream parity with `shadcn_flutter`).
///
/// Used by [DrawerContainer]/[SheetContainer] to size the sheet so it
/// doesn't stretch edge-to-edge.
///
/// Supports arithmetic: `AxisSize.fraction(0.5) + AxisSize.fixed(40)`,
/// `AxisSize.fixed(400) * 0.5`, etc.
abstract class AxisSize {
  /// Const constructor for subclasses.
  const AxisSize();

  /// A fixed number of logical pixels.
  const factory AxisSize.fixed(double size) = FixedAxisSize;

  /// A [fraction] (0..1) of the available cross-axis extent.
  const factory AxisSize.fraction(double fraction) = FractionAxisSize;

  /// Resolves this size against the [available] cross-axis extent.
  double resolve(double available);

  /// Sum of two sizes.
  AxisSize operator +(AxisSize other) => AdditiveAxisSize(this, other);

  /// Difference of two sizes.
  AxisSize operator -(AxisSize other) => SubtractedAxisSize(this, other);

  /// Scales this size by [factor].
  AxisSize operator *(double factor) => MultipliedAxisSize(this, factor);

  /// Divides this size by [factor].
  AxisSize operator /(double factor) => DividedAxisSize(this, factor);
}

/// An [AxisSize] of a fixed number of logical pixels (upstream parity).
class FixedAxisSize extends AxisSize {
  /// The size in logical pixels.
  final double size;

  /// Creates a fixed axis size.
  const FixedAxisSize(this.size);

  @override
  double resolve(double available) => size;
}

/// An [AxisSize] that is a fraction of the available extent (upstream parity).
class FractionAxisSize extends AxisSize {
  /// The fraction (0..1) of the available extent.
  final double fraction;

  /// Creates a fractional axis size.
  const FractionAxisSize(this.fraction);

  @override
  double resolve(double available) => available * fraction;
}

/// Sum of two [AxisSize]s (upstream parity).
class AdditiveAxisSize extends AxisSize {
  /// The left operand.
  final AxisSize a;

  /// The right operand.
  final AxisSize b;

  /// Creates an additive axis size.
  const AdditiveAxisSize(this.a, this.b);

  @override
  double resolve(double available) =>
      a.resolve(available) + b.resolve(available);
}

/// Difference of two [AxisSize]s (upstream parity).
class SubtractedAxisSize extends AxisSize {
  /// The left operand.
  final AxisSize a;

  /// The right operand.
  final AxisSize b;

  /// Creates a subtracted axis size.
  const SubtractedAxisSize(this.a, this.b);

  @override
  double resolve(double available) =>
      a.resolve(available) - b.resolve(available);
}

/// An [AxisSize] scaled by a scalar factor (upstream parity).
class MultipliedAxisSize extends AxisSize {
  /// The operand.
  final AxisSize size;

  /// The scalar factor.
  final double factor;

  /// Creates a multiplied axis size.
  const MultipliedAxisSize(this.size, this.factor);

  @override
  double resolve(double available) => size.resolve(available) * factor;
}

/// An [AxisSize] divided by a scalar factor (upstream parity).
class DividedAxisSize extends AxisSize {
  /// The operand.
  final AxisSize size;

  /// The scalar divisor.
  final double factor;

  /// Creates a divided axis size.
  const DividedAxisSize(this.size, this.factor);

  @override
  double resolve(double available) => size.resolve(available) / factor;
}
