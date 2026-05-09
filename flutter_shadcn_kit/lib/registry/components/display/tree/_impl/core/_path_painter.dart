// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../tree.dart';

/// Custom painter responsible for drawing tree-specific visuals.
class _PathPainter extends CustomPainter {
  /// Color value used by tree painting or state styling.
  final Color color;

  /// Input parameter used by `_PathPainter` during rendering and behavior handling.
  final bool top;

  /// Input parameter used by `_PathPainter` during rendering and behavior handling.
  final bool right;

  /// Input parameter used by `_PathPainter` during rendering and behavior handling.
  final bool bottom;

  /// Input parameter used by `_PathPainter` during rendering and behavior handling.
  final bool left;

  /// Creates `_PathPainter` for configuring or rendering tree.
  _PathPainter({
    required this.color,
    this.top = false,
    this.right = false,
    this.bottom = false,
    this.left = false,
  });

  /// Implements `paint` behavior for tree.
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..strokeCap = StrokeCap.round;
    final path = Path();

    final halfWidth = size.width / 2;

    final halfHeight = size.height / 2;
    if (top) {
      path.moveTo(halfWidth, 0);
      path.lineTo(halfWidth, halfHeight);
    }
    if (right) {
      path.moveTo(halfWidth, halfHeight);
      path.lineTo(size.width, halfHeight);
    }
    if (bottom) {
      path.moveTo(halfWidth, halfHeight);
      path.lineTo(halfWidth, size.height);
    }
    if (left) {
      path.moveTo(halfWidth, halfHeight);
      path.lineTo(0, halfHeight);
    }
    canvas.drawPath(path, paint);
  }

  /// Implements `shouldRepaint` behavior for tree.
  @override
  bool shouldRepaint(covariant _PathPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.top != top ||
        oldDelegate.right != right ||
        oldDelegate.bottom != bottom;
  }
}
