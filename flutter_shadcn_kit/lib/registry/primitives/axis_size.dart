// Cross-axis size algebra for drawer/sheet containers, extracted from the
// `drawer_container` component so its files stay within the layout budget.
// Reusable by any edge-anchored panel that sizes itself along the cross axis
// (drawer_container, pinned_sheet).

/// A cross-axis size for an edge-anchored panel, resolved against the
/// available cross-axis extent.
///
/// Supports arithmetic: `AxisSize.fraction(0.5) + AxisSize.fixed(40)`.
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

/// A fixed number of logical pixels.
class FixedAxisSize extends AxisSize {
  /// Creates a fixed axis size.
  const FixedAxisSize(this.size);

  /// The size in logical pixels.
  final double size;

  @override
  double resolve(double available) => size;
}

/// A fraction (0..1) of the available extent.
class FractionAxisSize extends AxisSize {
  /// Creates a fractional axis size.
  const FractionAxisSize(this.fraction);

  /// The fraction of the available extent.
  final double fraction;

  @override
  double resolve(double available) => available * fraction;
}

/// Sum of two [AxisSize]s.
class AdditiveAxisSize extends AxisSize {
  /// Creates an additive axis size.
  const AdditiveAxisSize(this.a, this.b);

  /// The left operand.
  final AxisSize a;

  /// The right operand.
  final AxisSize b;

  @override
  double resolve(double available) =>
      a.resolve(available) + b.resolve(available);
}

/// Difference of two [AxisSize]s.
class SubtractedAxisSize extends AxisSize {
  /// Creates a subtracted axis size.
  const SubtractedAxisSize(this.a, this.b);

  /// The left operand.
  final AxisSize a;

  /// The right operand.
  final AxisSize b;

  @override
  double resolve(double available) =>
      a.resolve(available) - b.resolve(available);
}

/// An [AxisSize] scaled by a scalar factor.
class MultipliedAxisSize extends AxisSize {
  /// Creates a multiplied axis size.
  const MultipliedAxisSize(this.size, this.factor);

  /// The operand.
  final AxisSize size;

  /// The scalar factor.
  final double factor;

  @override
  double resolve(double available) => size.resolve(available) * factor;
}

/// An [AxisSize] divided by a scalar factor.
class DividedAxisSize extends AxisSize {
  /// Creates a divided axis size.
  const DividedAxisSize(this.size, this.factor);

  /// The operand.
  final AxisSize size;

  /// The scalar divisor.
  final double factor;

  @override
  double resolve(double available) => size.resolve(available) / factor;
}
