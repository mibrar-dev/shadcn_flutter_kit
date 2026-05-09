// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:flutter/widgets.dart';

/// A simple checkerboard painter used to visualize transparency.
///
/// The pattern is typically shown behind semi-transparent colors in color
/// pickers or image editors to make the alpha level readable against various
/// backgrounds.
class AlphaPainter extends CustomPainter {
  /// Primary color used in the checkerboard pattern.
  static const Color checkboardPrimary = Color(0xFFE0E0E0);

  /// Secondary color used in the checkerboard pattern.
  static const Color checkboardSecondary = Color(0xFFB0B0B0);

  /// Size of each square in the checkerboard pattern.
  static const double checkboardSize = 8.0;

  @override
  /// Executes `paint` behavior for this component/composite.
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..color = checkboardPrimary;
    canvas.drawRect(Offset.zero & size, paint);
    paint.color = checkboardSecondary;
    for (var i = 0.0; i < size.width; i += checkboardSize) {
      for (var j = 0.0; j < size.height; j += checkboardSize) {
        final row = (i / checkboardSize).floor();
        final col = (j / checkboardSize).floor();
        if ((row + col) % 2 == 0) {
          /// Creates a `canvas.drawRect` instance.
          canvas.drawRect(
            /// Creates a `Rect.fromLTWH` instance.
            Rect.fromLTWH(i, j, checkboardSize, checkboardSize),
            paint,
          );
        }
      }
    }
  }

  @override
  /// Executes `shouldRepaint` behavior for this component/composite.
  bool shouldRepaint(covariant AlphaPainter oldDelegate) => false;
}
