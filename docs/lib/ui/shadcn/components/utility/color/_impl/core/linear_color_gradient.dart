// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../color.dart';

/// A linear gradient implementation of [ColorGradient].
///
/// [LinearColorGradient] represents a gradient that transitions linearly between
/// colors along a specified angle. It supports multiple color stops and different
/// tile modes for how the gradient repeats beyond its bounds.
///
/// Example:
/// ```dart
/// final gradient = LinearColorGradient(
///   colors: [
///     ColorStop(color: ColorDerivative.fromColor(Colors.red), position: 0.0),
///     ColorStop(color: ColorDerivative.fromColor(Colors.blue), position: 1.0),
///   ],
///   angle: const GradientAngle(0.0),
/// );
/// ```
class LinearColorGradient extends ColorGradient {
  /// The list of color stops in the gradient.
  final List<ColorStop> colors;

  /// The angle of the gradient.
  final GradientAngleGeometry angle;

  /// How the gradient repeats beyond its bounds.
  final TileMode tileMode;

  /// Creates a [LinearColorGradient] with the specified parameters.
  const LinearColorGradient({
    required this.colors,
    this.angle = const DirectionalGradientAngle(0),
    this.tileMode = TileMode.clamp,
  });

  @override
  /// Creates a `LinearColorGradient` instance.
  LinearColorGradient copyWith({
    List<ColorStop>? colors,
    GradientAngleGeometry? angle,
    TileMode? tileMode,
  }) {
    return LinearColorGradient(
      colors: colors ?? this.colors,
      angle: angle ?? this.angle,
      tileMode: tileMode ?? this.tileMode,
    );
  }

  @override
  /// Executes `changeColorAt` behavior for this component/composite.
  LinearColorGradient changeColorAt(int index, ColorDerivative color) {
    List<ColorStop> newColors = List.from(colors);
    newColors[index] = ColorStop(
      color: color,
      position: newColors[index].position,
    );
    return copyWith(colors: newColors);
  }

  @override
  /// Executes `changePositionAt` behavior for this component/composite.
  LinearColorGradient changePositionAt(int index, double position) {
    List<ColorStop> newColors = List.from(colors);
    newColors[index] = ColorStop(
      color: newColors[index].color,
      position: position,
    );
    return copyWith(colors: newColors);
  }

  @override
  /// Creates a `LinearColorGradient` instance.
  LinearColorGradient changeColorAndPositionAt(
    int index,
    ColorDerivative color,
    double position,
  ) {
    List<ColorStop> newColors = List.from(colors);
    newColors[index] = ColorStop(color: color, position: position);
    return copyWith(colors: newColors);
  }

  @override
  ({LinearColorGradient gradient, int index}) insertColorAt(
    ColorDerivative color,
    Offset position,
    Size size,
    TextDirection textDirection,
  ) {
    Alignment alignBegin = angle.begin.resolve(textDirection);
    Alignment alignEnd = angle.end.resolve(textDirection);

    /// Stores `dx` state/configuration for this implementation.
    final dx = alignEnd.x - alignBegin.x;

    /// Stores `dy` state/configuration for this implementation.
    final dy = alignEnd.y - alignBegin.y;

    /// Stores `lengthSquared` state/configuration for this implementation.
    final lengthSquared = dx * dx + dy * dy;
    final px = (position.dx / size.width) * 2 - 1;
    final py = (position.dy / size.height) * 2 - 1;
    final t =
        ((px - alignBegin.x) * dx + (py - alignBegin.y) * dy) / lengthSquared;
    final pos = t.clamp(0.0, 1.0);
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
  LinearGradient toGradient() {
    return LinearGradient(
      colors: colors.map((e) => e.color.toColor()).toList(),
      stops: colors.map((e) => e.position).toList(),
      tileMode: tileMode,
      begin: angle.begin,
      end: angle.end,
    );
  }
}
