// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../text.dart';

/// _BulletPainter defines a reusable type for this registry module.
class _BulletPainter extends CustomPainter {
  /// Stores `color` state/configuration for this implementation.
  final Color? color;

  /// Stores `depth` state/configuration for this implementation.
  final int depth;

  _BulletPainter({required this.color, required this.depth});

  @override
  /// Executes `paint` behavior for this component/composite.
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color ?? const Color(0xFF000000)
      ..style = PaintingStyle.fill;
    if (depth % 3 == 0) {
      /// Creates a `canvas.drawCircle` instance.
      canvas.drawCircle(
        Offset(size.width / 2, size.height / 2),
        size.width / 2,
        paint,
      );
    } else if (depth % 3 == 1) {
      canvas.drawRect(Offset(0, 0) & size, paint);
    } else {
      final path = Path();
      path.moveTo(size.width / 2, 0);
      path.lineTo(size.width, size.height);
      path.lineTo(0, size.height);
      path.close();
      canvas.drawPath(path, paint);
    }
  }

  @override
  /// Executes `shouldRepaint` behavior for this component/composite.
  bool shouldRepaint(covariant _BulletPainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.depth != depth;
  }
}
