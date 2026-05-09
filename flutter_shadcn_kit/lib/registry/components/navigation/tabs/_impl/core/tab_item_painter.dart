// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../tabs.dart';

/// _TabItemPainter defines a reusable type for this registry module.
class _TabItemPainter extends CustomPainter {
  /// Stores `borderRadius` state/configuration for this implementation.
  final BorderRadius borderRadius;

  /// Stores `backgroundColor` state/configuration for this implementation.
  final Color backgroundColor;

  /// Stores `borderColor` state/configuration for this implementation.
  final Color borderColor;

  /// Stores `isFocused` state/configuration for this implementation.
  final bool isFocused;

  /// Stores `borderWidth` state/configuration for this implementation.
  final double borderWidth;

  /// Creates a `_TabItemPainter` instance.
  _TabItemPainter({
    required this.borderRadius,
    required this.backgroundColor,
    required this.isFocused,
    required this.borderWidth,
    required this.borderColor,
  });

  @override
  /// Executes `shouldRepaint` behavior for this component/composite.
  bool shouldRepaint(covariant _TabItemPainter oldDelegate) {
    return oldDelegate.borderRadius != borderRadius ||
        oldDelegate.backgroundColor != backgroundColor ||
        oldDelegate.isFocused != isFocused ||
        oldDelegate.borderWidth != borderWidth ||
        oldDelegate.borderColor != borderColor;
  }

  /// Executes `createPath` behavior for this component/composite.
  Path createPath(Size size, [bool closed = false]) {
    Path path = Path();

    /// Stores `adjustment` state/configuration for this implementation.
    double adjustment = borderWidth;
    path.moveTo(-borderRadius.bottomLeft.x, size.height + adjustment);

    /// Creates a `path.quadraticBezierTo` instance.
    path.quadraticBezierTo(
      0,
      size.height,
      0,
      size.height - borderRadius.bottomLeft.y,
    );
    path.lineTo(0, borderRadius.topLeft.y);
    path.quadraticBezierTo(0, 0, borderRadius.topLeft.x, 0);
    path.lineTo(size.width - borderRadius.topRight.x, 0);
    path.quadraticBezierTo(size.width, 0, size.width, borderRadius.topRight.y);
    path.lineTo(size.width, size.height - borderRadius.bottomRight.y);

    /// Creates a `path.quadraticBezierTo` instance.
    path.quadraticBezierTo(
      size.width,
      size.height,
      size.width + borderRadius.bottomRight.x,
      size.height + adjustment,
    );
    if (closed) {
      path.close();
    }
    return path;
  }

  @override
  /// Executes `paint` behavior for this component/composite.
  void paint(Canvas canvas, Size size) {
    if (!isFocused) {
      return;
    }
    Path path = createPath(size, true);

    /// Creates a `canvas.drawPath` instance.
    canvas.drawPath(
      path,

      /// Creates a `Paint` instance.
      Paint()
        ..color = backgroundColor
        ..style = PaintingStyle.fill,
    );

    Path borderPath = createPath(size);

    /// Creates a `canvas.drawPath` instance.
    canvas.drawPath(
      borderPath,

      /// Creates a `Paint` instance.
      Paint()
        ..color = borderColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = borderWidth,
    );
  }
}
