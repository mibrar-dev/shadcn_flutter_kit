import 'package:flutter/widgets.dart';

/// Nesting depth for an unordered list, provided to descendants by the `li`
/// modifier.
class UnorderedListData {
  /// Creates list data at nesting level [depth] (0 = top level).
  const UnorderedListData({this.depth = 0});

  /// The nesting depth, 0 for a top-level list item.
  final int depth;
}

/// The bullet drawn for a list item at [depth].
///
/// The shape cycles every three levels — disc, square, triangle — so nested
/// lists stay visually distinguishable. The fill colour comes from the ambient
/// [DefaultTextStyle].
Widget getBullet(BuildContext context, int depth, double size) {
  return CustomPaint(
    size: Size(size, size),
    painter: _BulletPainter(
      color: DefaultTextStyle.of(context).style.color,
      depth: depth,
    ),
  );
}

/// Paints one list-item bullet; see [getBullet].
class _BulletPainter extends CustomPainter {
  _BulletPainter({required this.color, required this.depth});

  /// Fill colour; falls back to opaque black when the text style has none.
  final Color? color;

  /// Nesting depth, selecting the shape.
  final int depth;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color ?? const Color(0xFF000000)
      ..style = PaintingStyle.fill;
    switch (depth % 3) {
      case 0:
        canvas.drawCircle(
          Offset(size.width / 2, size.height / 2),
          size.width / 2,
          paint,
        );
      case 1:
        canvas.drawRect(Offset.zero & size, paint);
      default:
        final path = Path()
          ..moveTo(size.width / 2, 0)
          ..lineTo(size.width, size.height)
          ..lineTo(0, size.height)
          ..close();
        canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _BulletPainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.depth != depth;
}
