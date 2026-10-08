// Pixel-sampling machinery shared by overlay tools (the `eye_dropper`
// component today; any future pixel/colour picker): capture a
// `RepaintBoundary` into a `ui.Image` plus its ARGB colour buffer, sample a
// grid of pixels around a position, and paint that grid as a magnified
// preview.
//
// Moved down from `components/eye_dropper/eye_dropper.dart` (P4-B23): the
// component's file measured 605 lines, over the ~400 budget, and this block is
// screen-pixel machinery, not eye-dropper UX.

import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

/// A magnified grid of sampled pixels.
class ScreenSample {
  /// Creates a sample.
  const ScreenSample(this.colors, this.size, this.pickedColor);

  /// The size of the sampled grid, in source pixels.
  final Size size;

  /// The sampled grid, stored row by row.
  final List<Color> colors;

  /// The colour at the centre of the grid.
  final Color pickedColor;

  /// The colour at [position], clamped to the grid.
  Color operator [](Offset position) {
    final int width = size.width.floor();
    final int height = size.height.floor();
    if (width <= 0 || height <= 0 || colors.isEmpty) {
      return pickedColor;
    }
    final int x = position.dx.floor().clamp(0, width - 1);
    final int y = position.dy.floor().clamp(0, height - 1);
    final int index = y * width + x;
    return colors[index.clamp(0, colors.length - 1)];
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is ScreenSample &&
        other.size == size &&
        other.pickedColor == pickedColor &&
        listEquals(other.colors, colors);
  }

  @override
  int get hashCode => Object.hash(size, pickedColor, Object.hashAll(colors));
}

/// A frozen capture of a render boundary: the decoded image plus its colors.
///
/// Call [dispose] when the capture is no longer needed; it releases the
/// underlying [image].
class ScreenCapture {
  /// Creates a capture from an already-decoded image and colour buffer.
  const ScreenCapture({
    required this.image,
    required this.colors,
    required this.size,
  });

  /// The decoded screenshot, for `RawImage`/`CustomPaint`.
  final ui.Image image;

  /// The same pixels, row by row in ARGB order.
  final List<Color> colors;

  /// The size of the capture, in source pixels.
  final Size size;

  /// The colour at the source pixel `(x, y)`.
  Color colorAt(int x, int y) => colors[y * size.width.floor() + x];

  /// Samples a [gridSize] grid of pixels centred on [position].
  ///
  /// Pixels outside the capture become fully transparent and the grid is
  /// capped at 512x512 so a degenerate zoom cannot allocate unboundedly.
  ScreenSample sample(Offset position, Size gridSize) {
    final int width = gridSize.width.floor().clamp(1, 512);
    final int height = gridSize.height.floor().clamp(1, 512);
    final int originX = width ~/ 2;
    final int originY = height ~/ 2;
    final List<Color> sampled = <Color>[];
    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        final Offset source = position.translate(
          (x - originX).toDouble(),
          (y - originY).toDouble(),
        );
        if (source.dx < 0 ||
            source.dy < 0 ||
            source.dx >= size.width ||
            source.dy >= size.height) {
          sampled.add(const Color(0x00000000));
        } else {
          sampled.add(colorAt(source.dx.floor(), source.dy.floor()));
        }
      }
    }
    final int pickedX = position.dx.floor().clamp(0, size.width.floor() - 1);
    final int pickedY = position.dy.floor().clamp(0, size.height.floor() - 1);
    return ScreenSample(
      sampled,
      Size(width.toDouble(), height.toDouble()),
      colorAt(pickedX, pickedY),
    );
  }

  /// Releases the decoded image.
  void dispose() {
    image.dispose();
  }
}

/// Captures the [RepaintBoundary] of the context behind [boundaryKey].
///
/// Returns null when the boundary is absent or not paint-ready. The caller
/// owns the returned capture and must [ScreenCapture.dispose] it.
Future<ScreenCapture?> captureRenderBoundary(
  GlobalKey boundaryKey, {
  double pixelRatio = 1,
}) async {
  final BuildContext? context = boundaryKey.currentContext;
  if (context == null) {
    return null;
  }
  final RenderObject? renderObject = context.findRenderObject();
  if (renderObject is! RenderRepaintBoundary) {
    return null;
  }
  final ui.Image image = await renderObject.toImage(pixelRatio: pixelRatio);
  final ByteData? data = await image.toByteData(
    format: ui.ImageByteFormat.rawRgba,
  );
  if (data == null) {
    image.dispose();
    return null;
  }
  final List<Color> colors = <Color>[];
  for (int i = 0; i < data.lengthInBytes; i += 4) {
    colors.add(
      Color.fromARGB(
        data.getUint8(i + 3),
        data.getUint8(i),
        data.getUint8(i + 1),
        data.getUint8(i + 2),
      ),
    );
  }
  return ScreenCapture(
    image: image,
    colors: colors,
    size: Size(image.width.toDouble(), image.height.toDouble()),
  );
}

/// Paints an [ScreenSample]-shaped grid of colours as a circular magnified
/// preview, with a highlight around the centre cell.
class PixelGridPainter extends CustomPainter {
  /// Creates a magnified-grid painter.
  const PixelGridPainter({
    required this.colors,
    required this.gridSize,
    required this.borderColor,
    required this.borderWidth,
    required this.selectedBorderColor,
    required this.selectedBorderWidth,
    required this.backgroundColor,
  });

  /// The grid colours, row by row.
  final List<Color> colors;

  /// The grid size, in cells.
  final Size gridSize;

  /// Outer ring colour.
  final Color borderColor;

  /// Outer ring width.
  final double borderWidth;

  /// Centre-cell highlight colour.
  final Color selectedBorderColor;

  /// Centre-cell highlight width.
  final double selectedBorderWidth;

  /// Backing colour drawn behind the cells.
  final Color backgroundColor;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.clipPath(
      Path()..addOval(Rect.fromLTWH(0, 0, size.width, size.height)),
    );
    final Paint paint = Paint()..style = PaintingStyle.fill;
    paint.color = backgroundColor;
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);
    final int columns = gridSize.width.floor();
    final int rows = gridSize.height.floor();
    if (columns <= 0 || rows <= 0 || colors.length < columns * rows) {
      canvas.restore();
      return;
    }
    final Size cell = Size(size.width / columns, size.height / rows);
    for (int y = 0; y < rows; y++) {
      for (int x = 0; x < columns; x++) {
        final Rect rect = Rect.fromLTWH(
          x * cell.width,
          y * cell.height,
          cell.width,
          cell.height,
        );
        paint
          ..color = colors[y * columns + x]
          ..style = PaintingStyle.fill;
        canvas.drawRect(rect, paint);
        paint
          ..color = borderColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = borderWidth;
        canvas.drawRect(rect.deflate(borderWidth / 2), paint);
      }
    }
    // Highlight the centre cell (the same `~/ 2` origin as
    // [ScreenCapture.sample]).
    paint
      ..color = selectedBorderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = selectedBorderWidth;
    canvas.drawRect(
      Rect.fromLTWH(
        (columns ~/ 2) * cell.width,
        (rows ~/ 2) * cell.height,
        cell.width,
        cell.height,
      ),
      paint,
    );
    paint
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth;
    canvas.drawOval(Rect.fromLTWH(0, 0, size.width, size.height), paint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant PixelGridPainter oldDelegate) =>
      !listEquals(oldDelegate.colors, colors) ||
      oldDelegate.gridSize != gridSize ||
      oldDelegate.borderColor != borderColor ||
      oldDelegate.borderWidth != borderWidth ||
      oldDelegate.selectedBorderColor != selectedBorderColor ||
      oldDelegate.selectedBorderWidth != selectedBorderWidth ||
      oldDelegate.backgroundColor != backgroundColor;
}
