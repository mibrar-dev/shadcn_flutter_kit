// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../divider.dart';

/// Paints a horizontal line for the divider.
class DividerPainter extends CustomPainter {
  /// Color value used by divider painting or state styling.
  final Color color;

  /// Input parameter used by `DividerPainter` during rendering and behavior handling.
  final double thickness;

  /// Input parameter used by `DividerPainter` during rendering and behavior handling.
  final double indent;

  /// Input parameter used by `DividerPainter` during rendering and behavior handling.
  final double endIndent;

  /// Creates `DividerPainter` for configuring or rendering divider.
  DividerPainter({
    required this.color,
    required this.thickness,
    required this.indent,
    required this.endIndent,
  });

  /// Implements `paint` behavior for divider.
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = thickness
      ..strokeCap = StrokeCap.square;
    final start = Offset(indent, size.height / 2);
    final end = Offset(size.width - endIndent, size.height / 2);
    canvas.drawLine(start, end, paint);
  }

  /// Implements `shouldRepaint` behavior for divider.
  @override
  bool shouldRepaint(covariant DividerPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.thickness != thickness ||
        oldDelegate.indent != indent ||
        oldDelegate.endIndent != endIndent;
  }
}
