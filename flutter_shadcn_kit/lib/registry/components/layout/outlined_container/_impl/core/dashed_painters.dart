// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../outlined_container.dart';

/// DashedLinePainter defines a reusable type for this registry module.
class DashedLinePainter extends CustomPainter {
  /// Stores `width` state/configuration for this implementation.
  final double width;

  /// Stores `gap` state/configuration for this implementation.
  final double gap;

  /// Stores `thickness` state/configuration for this implementation.
  final double thickness;

  /// Stores `color` state/configuration for this implementation.
  final Color color;

  /// Creates a `DashedLinePainter` instance.
  const DashedLinePainter({
    required this.width,
    required this.gap,
    required this.thickness,
    required this.color,
  });

  @override
  /// Executes `paint` behavior for this component/composite.
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0);
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
  bool shouldRepaint(covariant DashedLinePainter oldDelegate) {
    return oldDelegate.width != width ||
        oldDelegate.gap != gap ||
        oldDelegate.thickness != thickness ||
        oldDelegate.color != color;
  }
}
