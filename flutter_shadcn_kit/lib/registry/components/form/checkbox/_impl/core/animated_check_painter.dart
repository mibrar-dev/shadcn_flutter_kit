// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../checkbox.dart';

/// Custom painter for drawing animated checkmarks in checkboxes.
///
/// Renders a smooth checkmark animation that draws progressively from left to right
/// in two stroke segments. The animation provides visual feedback when transitioning
/// to the checked state, creating a satisfying user experience.
///
/// The checkmark is drawn as two connected line segments: a shorter diagonal line
/// from bottom-left toward center, and a longer diagonal line from center to top-right.
/// The [progress] parameter controls how much of the checkmark is visible.
///
/// Used internally by [Checkbox] - not typically instantiated directly by consumers.
class AnimatedCheckPainter extends CustomPainter {
  /// Animation progress from 0.0 to 1.0 controlling checkmark visibility.
  ///
  /// At 0.0, no checkmark is visible. At 1.0, the complete checkmark is drawn.
  /// Values between 0.0 and 1.0 show partial drawing progress with smooth transitions.
  final double progress;

  /// Color used to draw the checkmark strokes.
  ///
  /// Typically the primary foreground color to provide contrast against
  /// the checkbox's active background color.
  final Color color;

  /// Width of the checkmark stroke lines in logical pixels.
  ///
  /// Controls the thickness of the drawn checkmark. Usually scaled with
  /// the theme's scaling factor for consistent appearance across screen densities.
  final double strokeWidth;

  /// Creates an [AnimatedCheckPainter].
  ///
  /// All parameters are required as they directly control the checkmark appearance
  /// and animation state. The painter should be recreated when any parameter changes.
  ///
  /// Parameters:
  /// - [progress] (double, required): animation progress 0.0-1.0
  /// - [color] (Color, required): checkmark stroke color
  /// - [strokeWidth] (double, required): stroke thickness in logical pixels
  ///
  /// Example usage within CustomPaint:
  /// ```dart
  /// CustomPaint(
  ///   painter: AnimatedCheckPainter(
  ///     progress: animationValue,
  ///     color: theme.primaryForeground,
  ///     strokeWidth: 2.0,
  ///   ),
  /// )
  /// ```
  AnimatedCheckPainter({
    required this.progress,
    required this.color,
    required this.strokeWidth,
  });

  /// Performs `paint` logic for this form component.
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    final path = Path();
    Offset firstStrokeStart = Offset(0, size.height * 0.5);
    Offset firstStrokeEnd = Offset(size.width * 0.35, size.height);
    Offset secondStrokeStart = firstStrokeEnd;
    Offset secondStrokeEnd = Offset(size.width, 0);
    double firstStrokeLength =
        (firstStrokeEnd - firstStrokeStart).distanceSquared;
    double secondStrokeLength =
        (secondStrokeEnd - secondStrokeStart).distanceSquared;
    double totalLength = firstStrokeLength + secondStrokeLength;

    double normalizedFirstStrokeLength = firstStrokeLength / totalLength;
    double normalizedSecondStrokeLength = secondStrokeLength / totalLength;

    double firstStrokeProgress =
        progress.clamp(0.0, normalizedFirstStrokeLength) /
        normalizedFirstStrokeLength;
    double secondStrokeProgress =
        (progress - normalizedFirstStrokeLength).clamp(
          0.0,
          normalizedSecondStrokeLength,
        ) /
        normalizedSecondStrokeLength;
    if (firstStrokeProgress <= 0) {
      return;
    }
    Offset currentPoint = Offset.lerp(
      firstStrokeStart,
      firstStrokeEnd,
      firstStrokeProgress,
    )!;
    path.moveTo(firstStrokeStart.dx, firstStrokeStart.dy);
    path.lineTo(currentPoint.dx, currentPoint.dy);
    if (secondStrokeProgress <= 0) {
      canvas.drawPath(path, paint);
      return;
    }
    Offset secondPoint = Offset.lerp(
      secondStrokeStart,
      secondStrokeEnd,
      secondStrokeProgress,
    )!;
    path.lineTo(secondPoint.dx, secondPoint.dy);
    canvas.drawPath(path, paint);
  }

  /// Performs `shouldRepaint` logic for this form component.
  @override
  bool shouldRepaint(covariant AnimatedCheckPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.color != color ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}
