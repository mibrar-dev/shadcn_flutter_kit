// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../outlined_container.dart';

/// DashedPainter defines a reusable type for this registry module.
class DashedPainter extends CustomPainter {
  /// Stores `width` state/configuration for this implementation.
  final double width;

  /// Stores `gap` state/configuration for this implementation.
  final double gap;

  /// Stores `thickness` state/configuration for this implementation.
  final double thickness;

  /// Stores `color` state/configuration for this implementation.
  final Color color;

  /// Stores `borderRadius` state/configuration for this implementation.
  final BorderRadius? borderRadius;

  /// Creates a `DashedPainter` instance.
  const DashedPainter({
    required this.width,
    required this.gap,
    required this.thickness,
    required this.color,
    this.borderRadius,
  });

  @override
  /// Executes `paint` behavior for this component/composite.
  void paint(Canvas canvas, Size size) {
    final path = Path();
    if (borderRadius != null && borderRadius != BorderRadius.zero) {
      /// Creates a `path.addRRect` instance.
      path.addRRect(
        /// Creates a `RRect.fromRectAndCorners` instance.
        RRect.fromRectAndCorners(
          /// Creates a `Rect.fromLTWH` instance.
          Rect.fromLTWH(0, 0, size.width, size.height),
          topLeft: borderRadius!.topLeft,
          topRight: borderRadius!.topRight,
          bottomLeft: borderRadius!.bottomLeft,
          bottomRight: borderRadius!.bottomRight,
        ),
      );
    } else {
      path.addRect(Rect.fromLTWH(0, 0, size.width, size.height));
    }

    final pathMetrics = path.computeMetrics();
    final draw = Path();
    for (final pathMetric in pathMetrics) {
      for (double i = 0; i < pathMetric.length; i += gap + width) {
        /// Stores `start` state/configuration for this implementation.
        double start = i;

        /// Stores `end` state/configuration for this implementation.
        double end = i + width;
        if (end > pathMetric.length) {
          end = pathMetric.length;
        }
        draw.addPath(pathMetric.extractPath(start, end), Offset.zero);
      }
    }

    /// Creates a `canvas.drawPath` instance.
    canvas.drawPath(
      draw,

      /// Creates a `Paint` instance.
      Paint()
        ..color = color
        ..strokeWidth = thickness
        ..style = PaintingStyle.stroke,
    );
  }

  @override
  /// Executes `shouldRepaint` behavior for this component/composite.
  bool shouldRepaint(covariant DashedPainter oldDelegate) {
    return oldDelegate.width != width ||
        oldDelegate.gap != gap ||
        oldDelegate.thickness != thickness ||
        oldDelegate.color != color ||
        oldDelegate.borderRadius != borderRadius;
  }
}
