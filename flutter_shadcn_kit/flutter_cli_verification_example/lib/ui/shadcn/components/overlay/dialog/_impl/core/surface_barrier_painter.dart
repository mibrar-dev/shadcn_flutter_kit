part of '../../dialog.dart';

/// SurfaceBarrierPainter defines a reusable type for this registry module.
class SurfaceBarrierPainter extends CustomPainter {
  /// Large size constant for creating screen-filling effects.
  static const double bigSize = 1000000;

  /// Large screen size for painting operations.
  static const bigScreen = Size(bigSize, bigSize);

  /// Large offset to center the big screen.
  static const bigOffset = Offset(-bigSize / 2, -bigSize / 2);

  /// Whether to clip a cutout area in the barrier.
  final bool clip;

  /// Border radius for the cutout area.
  final BorderRadius borderRadius;

  /// Color of the barrier.
  final Color barrierColor;

  /// Padding around the cutout area.
  final EdgeInsets padding;

  /// Creates a [SurfaceBarrierPainter].
  ///
  /// Parameters:
  /// - [clip] (bool, required): whether to create a cutout in the barrier
  /// - [borderRadius] (BorderRadius, required): radius for the cutout corners
  /// - [barrierColor] (Color, required): color of the barrier
  /// - [padding] (EdgeInsets, default: EdgeInsets.zero): padding around cutout
  ///
  /// Example:
  /// ```dart
  /// SurfaceBarrierPainter(
  ///   clip: true,
  ///   borderRadius: BorderRadius.circular(12),
  ///   barrierColor: Colors.black54,
  /// )
  /// ```
  SurfaceBarrierPainter({
    required this.clip,
    required this.borderRadius,
    required this.barrierColor,
    this.padding = EdgeInsets.zero,
  });

  /// Applies padding to a rectangle by shrinking it inward.
  ///
  /// Reduces the rectangle size by the specified padding amounts
  /// on all sides.
  ///
  /// Returns:
  /// A new [Rect] with padding applied.
  Rect _padRect(Rect rect) {
    return Rect.fromLTRB(
      rect.left + padding.left,
      rect.top + padding.top,
      rect.right - padding.right,
      rect.bottom - padding.bottom,
    );
  }

  @override
/// Executes `paint` behavior for this component/composite.
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = barrierColor
      ..blendMode = BlendMode.srcOver
      ..style = PaintingStyle.fill;
    if (clip) {
      var rect = (Offset.zero & size);
      rect = _padRect(rect);
      Path path = Path()
        ..addRect(bigOffset & bigScreen)
        ..addRRect(
/// Creates a `RRect.fromRectAndCorners` instance.
          RRect.fromRectAndCorners(
            rect,
            topLeft: borderRadius.topLeft,
            topRight: borderRadius.topRight,
            bottomLeft: borderRadius.bottomLeft,
            bottomRight: borderRadius.bottomRight,
          ),
        );
      path.fillType = PathFillType.evenOdd;
      canvas.clipPath(path);
    }
    canvas.drawRect(bigOffset & bigScreen, paint);
  }

  @override
/// Executes `shouldRepaint` behavior for this component/composite.
  bool shouldRepaint(covariant SurfaceBarrierPainter oldDelegate) {
    return oldDelegate.borderRadius != borderRadius ||
        oldDelegate.barrierColor != barrierColor ||
        oldDelegate.padding != padding ||
        oldDelegate.clip != clip;
  }
}

/// Custom route implementation for shadcn_flutter dialogs.
///
/// Extends [RawDialogRoute] to provide consistent dialog behavior with
/// proper theme inheritance, data capture, and transition animations.
/// Handles both standard and full-screen dialog presentations.
///
/// Features:
/// - Theme and data inheritance across navigation boundaries
/// - Configurable alignment and positioning
/// - Full-screen mode support
/// - Custom transition animations
/// - Safe area integration
///
/// This class is typically not used directly - use [showDialog] instead.
