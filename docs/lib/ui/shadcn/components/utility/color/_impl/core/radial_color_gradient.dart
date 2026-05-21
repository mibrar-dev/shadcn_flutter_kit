// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../color.dart';

/// A radial gradient for color values.
///
/// Creates a circular gradient radiating from a center point.
class RadialColorGradient extends ColorGradient {
  /// The color stops defining the gradient.
  final List<ColorStop> colors;

  /// How the gradient tiles beyond its bounds.
  final TileMode tileMode;

  /// The center point of the gradient.
  final AlignmentGeometry center;

  /// The focal point of the gradient (for elliptical gradients).
  final AlignmentGeometry? focal;

  /// The radius of the gradient (0.0 to 1.0).
  final double radius;

  /// The focal radius for elliptical gradients.
  final double focalRadius;

  /// Creates a radial color gradient.
  const RadialColorGradient({
    required this.colors,
    this.tileMode = TileMode.clamp,
    this.center = Alignment.center,
    this.focal,
    this.radius = 0.5,
    this.focalRadius = 0.0,
  });

  @override
  /// Creates a `RadialColorGradient` instance.
  RadialColorGradient copyWith({
    List<ColorStop>? colors,
    TileMode? tileMode,
    AlignmentGeometry? center,
    AlignmentGeometry? focal,
    double? radius,
    double? focalRadius,
  }) {
    return RadialColorGradient(
      colors: colors ?? this.colors,
      tileMode: tileMode ?? this.tileMode,
      center: center ?? this.center,
      focal: focal ?? this.focal,
      radius: radius ?? this.radius,
      focalRadius: focalRadius ?? this.focalRadius,
    );
  }

  @override
  /// Executes `changeColorAt` behavior for this component/composite.
  RadialColorGradient changeColorAt(int index, ColorDerivative color) {
    List<ColorStop> newColors = List.from(colors);
    newColors[index] = ColorStop(
      color: color,
      position: newColors[index].position,
    );
    return copyWith(colors: newColors);
  }

  @override
  /// Executes `changePositionAt` behavior for this component/composite.
  RadialColorGradient changePositionAt(int index, double position) {
    List<ColorStop> newColors = List.from(colors);
    newColors[index] = ColorStop(
      color: newColors[index].color,
      position: position,
    );
    return copyWith(colors: newColors);
  }

  @override
  /// Creates a `RadialColorGradient` instance.
  RadialColorGradient changeColorAndPositionAt(
    int index,
    ColorDerivative color,
    double position,
  ) {
    List<ColorStop> newColors = List.from(colors);
    newColors[index] = ColorStop(color: color, position: position);
    return copyWith(colors: newColors);
  }

  @override
  ({RadialColorGradient gradient, int index}) insertColorAt(
    ColorDerivative color,
    Offset position,
    Size size,
    TextDirection textDirection,
  ) {
    Alignment alignCenter = center.resolve(textDirection);
    final px = (position.dx / size.width) * 2 - 1;
    final py = (position.dy / size.height) * 2 - 1;

    /// Stores `dx` state/configuration for this implementation.
    final dx = px - alignCenter.x;

    /// Stores `dy` state/configuration for this implementation.
    final dy = py - alignCenter.y;
    final dist =
        /// Creates a `sqrt` instance.
        sqrt(dx * dx + dy * dy) / sqrt(2); // max distance in square is sqrt(2)
    final pos = dist.clamp(0.0, 1.0);
    List<ColorStop> newColors = List.from(colors);

    /// Stores `insertIndex` state/configuration for this implementation.
    int insertIndex = 0;
    for (int i = 0; i < newColors.length; i++) {
      if (newColors[i].position < pos) {
        insertIndex = i + 1;
      }
    }
    newColors.insert(insertIndex, ColorStop(color: color, position: pos));
    return (gradient: copyWith(colors: newColors), index: insertIndex);
  }

  @override
  /// Executes `toGradient` behavior for this component/composite.
  RadialGradient toGradient() {
    return RadialGradient(
      colors: colors.map((e) => e.color.toColor()).toList(),
      stops: colors.map((e) => e.position).toList(),
      center: center,
      focal: focal,
      radius: radius,
      focalRadius: focalRadius,
      tileMode: tileMode,
    );
  }
}
