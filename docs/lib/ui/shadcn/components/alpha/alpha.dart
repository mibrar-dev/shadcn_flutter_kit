// The `alpha` component: [AlphaPainter], the checkerboard used behind
// translucent colours in pickers/wells. Leaf utility, widgets-only.

import 'package:flutter/widgets.dart';

/// A checkerboard painter used to visualize transparency.
///
/// The pattern is shown behind semi-transparent colors in color pickers or
/// image editors to make the alpha level readable on any background. Wrap in
/// a `CustomPaint` sized to the area being visualized.
class AlphaPainter extends CustomPainter {
  /// Creates a checkerboard painter.
  const AlphaPainter({
    this.primary = checkboardPrimary,
    this.secondary = checkboardSecondary,
    this.squareSize = checkboardSize,
  });

  /// Primary color used in the checkerboard pattern.
  static const Color checkboardPrimary = Color(0xFFE0E0E0);

  /// Secondary color used in the checkerboard pattern.
  static const Color checkboardSecondary = Color(0xFFB0B0B0);

  /// Size of each square in the checkerboard pattern.
  static const double checkboardSize = 8.0;

  /// Fill color of the even squares.
  final Color primary;

  /// Fill color of the odd squares.
  final Color secondary;

  /// Edge length of one square.
  final double squareSize;

  @override
  void paint(Canvas canvas, Size size) {
    if (squareSize <= 0) {
      return;
    }
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..color = primary;
    canvas.drawRect(Offset.zero & size, paint);
    paint.color = secondary;
    var row = 0;
    for (double i = 0; i < size.width; i += squareSize, row++) {
      var col = 0;
      for (double j = 0; j < size.height; j += squareSize, col++) {
        if ((row + col) % 2 == 0) {
          canvas.drawRect(Rect.fromLTWH(i, j, squareSize, squareSize), paint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant AlphaPainter oldDelegate) =>
      oldDelegate.primary != primary ||
      oldDelegate.secondary != secondary ||
      oldDelegate.squareSize != squareSize;
}
