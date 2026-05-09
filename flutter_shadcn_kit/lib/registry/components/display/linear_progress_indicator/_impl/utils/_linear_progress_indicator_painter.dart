// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../linear_progress_indicator.dart';

/// Custom painter responsible for drawing linear progress indicator-specific visuals.
class _LinearProgressIndicatorPainter extends CustomPainter {
  static final gradientTransform =
      (Matrix4.identity()..scaleByDouble(1.0, 0.5, 1, 1)).storage;

  /// Input parameter used by `_LinearProgressIndicatorPainter` during rendering and behavior handling.
  final double start;

  /// Input parameter used by `_LinearProgressIndicatorPainter` during rendering and behavior handling.
  final double end;

  /// Input parameter used by `_LinearProgressIndicatorPainter` during rendering and behavior handling.
  final double? start2;

  /// Input parameter used by `_LinearProgressIndicatorPainter` during rendering and behavior handling.
  final double? end2;

  /// Color value used by linear progress indicator painting or state styling.
  final Color color;

  /// Color value used by linear progress indicator painting or state styling.
  final Color backgroundColor;

  /// Input parameter used by `_LinearProgressIndicatorPainter` during rendering and behavior handling.
  final bool showSparks;

  /// Color value used by linear progress indicator painting or state styling.
  final Color sparksColor;

  /// Layout/size setting that affects linear progress indicator rendering.
  final double sparksRadius;

  /// Data consumed by `_LinearProgressIndicatorPainter` to render linear progress indicator content.
  final TextDirection textDirection;

  /// Creates `_LinearProgressIndicatorPainter` for configuring or rendering linear progress indicator.
  _LinearProgressIndicatorPainter({
    required this.start,
    required this.end,
    this.start2,
    this.end2,
    required this.color,
    required this.backgroundColor,
    required this.showSparks,
    required this.sparksColor,
    required this.sparksRadius,
    this.textDirection = TextDirection.ltr,
  });

  /// Implements `paint` behavior for linear progress indicator.
  @override
  void paint(Canvas canvas, Size size) {
    var start = this.start;

    var end = this.end;

    var start2 = this.start2;

    var end2 = this.end2;
    if (textDirection == TextDirection.rtl) {
      start = 1 - end;
      end = 1 - this.start;
      if (start2 != null && end2 != null) {
        start2 = 1 - end2;
        end2 = 1 - this.start2!;
      }
    }

    if (start.isNaN) {
      start = 0;
    }
    if (end.isNaN) {
      end = 0;
    }
    if (start2 != null && start2.isNaN) {
      start2 = 0;
    }
    if (end2 != null && end2.isNaN) {
      end2 = 0;
    }

    final paint = Paint()..style = PaintingStyle.fill;

    paint.color = backgroundColor;

    canvas.drawRRect(
      RRect.fromLTRBR(
        0,
        0,
        size.width,
        size.height,

        Radius.circular(size.height / 2),
      ),
      paint,
    );

    paint.color = color;
    var rectValue = Rect.fromLTWH(
      size.width * start,
      0,
      size.width * (end - start),
      size.height,
    );
    canvas.drawRect(rectValue, paint);
    if (start2 != null && end2 != null) {
      rectValue = Rect.fromLTWH(
        size.width * start2,
        0,
        size.width * (end2 - start2),
        size.height,
      );
      canvas.drawRect(rectValue, paint);
    }

    if (showSparks) {
      final gradient = ui.Gradient.radial(
        Offset(size.width * (end - start), size.height / 2),
        sparksRadius,
        [sparksColor, sparksColor.withAlpha(0)],
        [0.0, 1.0],
        ui.TileMode.clamp,
        gradientTransform,
      );
      paint.shader = gradient;

      canvas.drawCircle(
        Offset(size.width * (end - start), size.height / 2),
        sparksRadius,
        paint,
      );
    }
  }

  /// Implements `shouldRepaint` behavior for linear progress indicator.
  @override
  bool shouldRepaint(covariant _LinearProgressIndicatorPainter oldDelegate) {
    return oldDelegate.start != start ||
        oldDelegate.end != end ||
        oldDelegate.color != color ||
        oldDelegate.backgroundColor != backgroundColor ||
        oldDelegate.showSparks != showSparks ||
        oldDelegate.sparksColor != sparksColor ||
        oldDelegate.sparksRadius != sparksRadius ||
        oldDelegate.textDirection != textDirection ||
        oldDelegate.start2 != start2 ||
        oldDelegate.end2 != end2;
  }
}
