// Metaball ("gooey") silhouette geometry, painting and compositing.
//
// Ported from the custom renderer in the old
// `overlay/gooey_toast/_impl/core/gooey_toast_widget.dart` (`_GooeyLayer`,
// `_GooeyShapeStack`, `_GooeyShapeClipper`, `_GooeyPainter` and the three
// `_buildGooey*Path` helpers) with Material and the old preset registry gone.
// Used by `gooey_surface.dart` and, through it, by the `gooey_toast`
// component.

import 'dart:ui';

import 'package:flutter/widgets.dart';

/// Silhouette of one gooey surface: a compact pill plus an expanding body.
///
/// [pillHeight] is the *content* height of the pill; callers inflate
/// [pillScaleY] while the body is closed so the blur head-room is compressed
/// away until the toast opens.
@immutable
class GooeyShapeGeometry {
  /// Creates a geometry snapshot.
  const GooeyShapeGeometry({
    this.roundness = 18,
    this.pillX = 0,
    this.pillWidth = 350,
    this.pillHeight = 40,
    this.pillScaleY = 1,
    this.bodyHeight = 0,
    this.bodyScaleY = 0,
  });

  /// Corner roundness of pill, body and shoulder blobs.
  final double roundness;

  /// Left edge of the compact pill inside the surface canvas.
  final double pillX;

  /// Width of the compact pill.
  final double pillWidth;

  /// Content height of the compact pill.
  final double pillHeight;

  /// Vertical scale applied to the pill while the body is closed.
  final double pillScaleY;

  /// Height of the expanded body; `0` keeps the surface closed.
  final double bodyHeight;

  /// Opening progress of the expanded body (`0..1`).
  final double bodyScaleY;

  /// The pill rectangle alone; this is the painted surface when closed.
  Path buildPillPath() {
    return Path()..addRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(pillX, 0, pillWidth, pillHeight * pillScaleY),
        Radius.circular(roundness),
      ),
    );
  }

  /// The expanding body blob, or an empty path when the body is closed.
  Path buildBodyPath(Size size) {
    if (bodyHeight <= 0 || bodyScaleY <= 0.04) {
      return Path();
    }
    const seamOverlap = 4.0;
    final normalized = ((bodyScaleY - 0.04) / 0.96).clamp(0.0, 1.0).toDouble();
    final t = Curves.easeInOutCubicEmphasized.transform(normalized);
    final morphWidth = (lerpDouble(pillWidth, size.width, t) ?? size.width)
        .clamp(0.0, size.width)
        .toDouble();
    final maxLeft = (size.width - morphWidth).clamp(0.0, size.width).toDouble();
    final morphLeft = (lerpDouble(pillX, 0.0, t) ?? 0.0)
        .clamp(0.0, maxLeft)
        .toDouble();
    final path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(morphLeft, 0, morphWidth, bodyHeight + seamOverlap),
          Radius.circular(roundness),
        ),
      );
    final transform = Matrix4.identity()
      ..translateByDouble(0.0, pillHeight - seamOverlap, 0.0, 1.0)
      ..scaleByDouble(1.0, bodyScaleY, 1.0, 1.0);
    return path.transform(transform.storage);
  }

  /// The shoulder ovals that blend pill and body into one silhouette.
  Path buildShoulderPath(Size size) {
    if (bodyScaleY <= 0.04) {
      return Path();
    }
    const seamOverlap = 4.0;
    final t = bodyScaleY.clamp(0.0, 1.0).toDouble();
    final blendRadius = ((roundness * 0.62) * t).clamp(0.0, 24.0).toDouble();
    if (blendRadius <= 0) {
      return Path();
    }
    final inset = (blendRadius * 0.24).clamp(0.0, pillWidth / 2).toDouble();
    final blendY = (pillHeight - seamOverlap) + blendRadius * 0.35;
    final leftCenter = Offset(
      (pillX + inset).clamp(0.0, size.width).toDouble(),
      blendY,
    );
    final rightCenter = Offset(
      (pillX + pillWidth - inset).clamp(0.0, size.width).toDouble(),
      blendY,
    );
    return Path()
      ..addOval(Rect.fromCircle(center: leftCenter, radius: blendRadius))
      ..addOval(Rect.fromCircle(center: rightCenter, radius: blendRadius));
  }

  /// Full silhouette used by the backdrop clip: pill + body + shoulders.
  Path buildPath(Size size) {
    final path = Path()..addPath(buildPillPath(), Offset.zero);
    path
      ..addPath(buildBodyPath(size), Offset.zero)
      ..addPath(buildShoulderPath(size), Offset.zero);
    return path;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is GooeyShapeGeometry &&
        other.roundness == roundness &&
        other.pillX == pillX &&
        other.pillWidth == pillWidth &&
        other.pillHeight == pillHeight &&
        other.pillScaleY == pillScaleY &&
        other.bodyHeight == bodyHeight &&
        other.bodyScaleY == bodyScaleY;
  }

  @override
  int get hashCode => Object.hash(
    roundness,
    pillX,
    pillWidth,
    pillHeight,
    pillScaleY,
    bodyHeight,
    bodyScaleY,
  );
}

/// Clips the backdrop blur to the gooey silhouette.
class GooeyShapeClipper extends CustomClipper<Path> {
  /// Creates a clipper over [geometry].
  const GooeyShapeClipper(this.geometry);

  /// Silhouette to clip to.
  final GooeyShapeGeometry geometry;

  @override
  Path getClip(Size size) => geometry.buildPath(size);

  @override
  bool shouldReclip(GooeyShapeClipper oldClipper) =>
      oldClipper.geometry != geometry;
}

/// Paints the pill and the expanding body.
class GooeyShapePainter extends CustomPainter {
  /// Creates a painter for [geometry] in [color].
  const GooeyShapePainter({required this.color, required this.geometry});

  /// Opaque surface colour; per-frame alpha is carried by the layer.
  final Color color;

  /// Silhouette to paint.
  final GooeyShapeGeometry geometry;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..isAntiAlias = true;
    canvas.drawPath(geometry.buildPillPath(), paint);

    if (geometry.bodyHeight > 0 && geometry.bodyScaleY > 0) {
      final bodyAlpha = geometry.bodyScaleY.clamp(0.0, 1.0).toDouble();
      final bodyPaint = Paint()
        ..color = color.withValues(alpha: (color.a * bodyAlpha).clamp(0.0, 1.0))
        ..isAntiAlias = true;
      canvas.drawPath(geometry.buildBodyPath(size), bodyPaint);
    }
  }

  @override
  bool shouldRepaint(GooeyShapePainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.geometry != geometry;
}

/// Paints the gooey-blurred silhouette plus the crisp shape, fading the
/// composited group uniformly.
///
/// The blur/threshold pass must composite opaque: with a translucent paint
/// colour the threshold erodes the silhouette, leaving a band that only the
/// crisp layer covers — visible as a grey rim on dark backgrounds. Callers
/// pass an opaque [shape] colour and the desired [fillAlpha].
class _GooeyShapeStack extends StatelessWidget {
  const _GooeyShapeStack({
    required this.fillAlpha,
    required this.shape,
    required this.enableGooeyBlur,
    required this.blur,
  });

  final double fillAlpha;
  final Widget shape;
  final bool enableGooeyBlur;
  final double blur;

  @override
  Widget build(BuildContext context) {
    final Widget gooey;
    if (enableGooeyBlur && blur > 0) {
      gooey = Stack(
        clipBehavior: Clip.none,
        children: <Widget>[
          ColorFiltered(
            colorFilter: const ColorFilter.matrix(<double>[
              1,
              0,
              0,
              0,
              0,
              0,
              1,
              0,
              0,
              0,
              0,
              0,
              1,
              0,
              0,
              0,
              0,
              0,
              20,
              -2550,
            ]),
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
              child: shape,
            ),
          ),
          shape,
        ],
      );
    } else {
      gooey = shape;
    }
    if (fillAlpha >= 1.0) {
      return gooey;
    }
    return Opacity(opacity: fillAlpha.clamp(0.0, 1.0), child: gooey);
  }
}

/// One gooey surface layer: optional backdrop blur behind the composited
/// shape layers.
class GooeyShapeLayer extends StatelessWidget {
  /// Creates a shape layer.
  const GooeyShapeLayer({
    super.key,
    required this.width,
    required this.height,
    required this.geometry,
    required this.color,
    this.fillAlpha = 1,
    this.blur = 0,
    this.surfaceBlur = 0,
    this.enableGooeyBlur = true,
  });

  /// Canvas width.
  final double width;

  /// Canvas height.
  final double height;

  /// Silhouette geometry for the current animation frame.
  final GooeyShapeGeometry geometry;

  /// Opaque surface colour.
  final Color color;

  /// Whole-layer opacity; `1` paints fully opaque.
  final double fillAlpha;

  /// Blur sigma of the metaball pass; `0` skips it.
  final double blur;

  /// Backdrop blur sigma clipped to the silhouette; `0` skips it.
  final double surfaceBlur;

  /// Whether the metaball pass runs at all.
  final bool enableGooeyBlur;

  @override
  Widget build(BuildContext context) {
    final shape = RepaintBoundary(
      child: CustomPaint(
        size: Size(width, height),
        painter: GooeyShapePainter(color: color, geometry: geometry),
      ),
    );
    return SizedBox(
      width: width,
      height: height,
      child: Stack(
        clipBehavior: Clip.none,
        children: <Widget>[
          if (surfaceBlur > 0)
            ClipPath(
              clipper: GooeyShapeClipper(geometry),
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: surfaceBlur,
                  sigmaY: surfaceBlur,
                ),
                child: const SizedBox.expand(),
              ),
            ),
          _GooeyShapeStack(
            fillAlpha: fillAlpha,
            shape: shape,
            enableGooeyBlur: enableGooeyBlur,
            blur: blur,
          ),
        ],
      ),
    );
  }
}
