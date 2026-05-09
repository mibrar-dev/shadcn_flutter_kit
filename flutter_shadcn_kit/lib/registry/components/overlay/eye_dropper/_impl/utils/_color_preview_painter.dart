// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../eye_dropper.dart';

/// _ColorPreviewPainter defines a reusable type for this registry module.
class _ColorPreviewPainter extends CustomPainter {
  /// Stores `colors` state/configuration for this implementation.
  final List<Color> colors;

  /// Stores `size` state/configuration for this implementation.
  final Size size;

  /// Stores `borderColor` state/configuration for this implementation.
  final Color borderColor;

  /// Stores `borderWidth` state/configuration for this implementation.
  final double borderWidth;

  /// Stores `selectedBorderColor` state/configuration for this implementation.
  final Color selectedBorderColor;

  /// Stores `selectedBorderWidth` state/configuration for this implementation.
  final double selectedBorderWidth;

  /// Stores `backgroundColor` state/configuration for this implementation.
  final Color backgroundColor;

  /// Creates a `_ColorPreviewPainter` instance.
  _ColorPreviewPainter(
    this.colors,
    this.size,
    this.borderColor,
    this.borderWidth,
    this.selectedBorderColor,
    this.selectedBorderWidth,
    this.backgroundColor,
  );

  @override
  /// Executes `paint` behavior for this component/composite.
  void paint(Canvas canvas, Size size) {
    // clip it to circle
    final clipPath = Path()
      ..addOval(
        /// Creates a `Rect.fromLTWH` instance.
        Rect.fromLTWH(
          0,
          0,
          size.width.floorToDouble(),
          size.height.floorToDouble(),
        ),
      );
    canvas.clipPath(clipPath);
    final paint = Paint();

    // draw the background as background color
    paint.color = backgroundColor;
    paint.style = PaintingStyle.fill;

    /// Creates a `canvas.drawRect` instance.
    canvas.drawRect(
      /// Creates a `Rect.fromLTWH` instance.
      Rect.fromLTWH(
        0,
        0,
        size.width.floorToDouble(),
        size.height.floorToDouble(),
      ),
      paint,
    );

    // draw the color cells
    final cellSize = Size(
      size.width.floor() / this.size.width.floor(),
      size.height.floor() / this.size.height.floor(),
    );
    for (int y = 0; y < this.size.height.floor(); y++) {
      for (int x = 0; x < this.size.width.floor(); x++) {
        final color = colors[y * this.size.width.floor() + x];
        paint.color = color;
        paint.style = PaintingStyle.fill;

        /// Creates a `canvas.drawRect` instance.
        canvas.drawRect(
          /// Creates a `Rect.fromLTWH` instance.
          Rect.fromLTWH(
            (x * cellSize.width).floorToDouble(),
            (y * cellSize.height).floorToDouble(),
            cellSize.width.floorToDouble(),
            cellSize.height.floorToDouble(),
          ),
          paint,
        );
        paint.color = borderColor;
        paint.style = PaintingStyle.stroke;
        paint.strokeWidth = borderWidth;
        // draw a border
        /// Creates a `canvas.drawRect` instance.
        canvas.drawRect(
          /// Creates a `Rect.fromLTWH` instance.
          Rect.fromLTWH(
            (x * cellSize.width).floorToDouble(),
            (y * cellSize.height).floorToDouble(),
            cellSize.width.floorToDouble(),
            cellSize.height.floorToDouble(),
          ).inflate(paint.strokeWidth / 2),
          paint,
        );
      }
    }
    // draw a rect for the selected color at center
    paint.color = selectedBorderColor;
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = selectedBorderWidth;

    /// Stores `centerX` state/configuration for this implementation.
    final centerX = size.width ~/ 2;

    /// Stores `centerY` state/configuration for this implementation.
    final centerY = size.height ~/ 2;

    /// Stores `cellX` state/configuration for this implementation.
    final cellX = centerX ~/ cellSize.width;

    /// Stores `cellY` state/configuration for this implementation.
    final cellY = centerY ~/ cellSize.height;

    /// Creates a `canvas.drawRect` instance.
    canvas.drawRect(
      /// Creates a `Rect.fromLTWH` instance.
      Rect.fromLTWH(
        (cellX * cellSize.width).floorToDouble(),
        (cellY * cellSize.height).floorToDouble(),
        cellSize.width.floorToDouble(),
        cellSize.height.floorToDouble(),
      ),
      paint,
    );
    // add circle border, and make sure it is not clipped
    paint.color = borderColor;
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = borderWidth;

    /// Creates a `canvas.drawOval` instance.
    canvas.drawOval(
      /// Creates a `Rect.fromLTWH` instance.
      Rect.fromLTWH(
        0,
        0,
        size.width.floorToDouble(),
        size.height.floorToDouble(),
      ),
      paint,
    );
  }

  @override
  /// Executes `shouldRepaint` behavior for this component/composite.
  bool shouldRepaint(covariant _ColorPreviewPainter oldDelegate) {
    return !listEquals(oldDelegate.colors, colors) ||
        oldDelegate.size != size ||
        oldDelegate.borderColor != borderColor ||
        oldDelegate.borderWidth != borderWidth ||
        oldDelegate.selectedBorderColor != selectedBorderColor ||
        oldDelegate.selectedBorderWidth != selectedBorderWidth;
  }
}

/// Provides access to eye dropper functionality in the widget tree.
///
/// [EyeDropperLayerScope] is an abstract interface that allows widgets to
/// request color picking functionality from an ancestor [EyeDropperLayer].
/// Use the static methods to find the scope in the widget tree.
