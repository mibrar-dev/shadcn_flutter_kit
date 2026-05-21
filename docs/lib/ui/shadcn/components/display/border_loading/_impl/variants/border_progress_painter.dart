// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../border_loading.dart';

/// Paints only the leading perimeter segment for determinate progress mode.
class _BorderProgressPainter extends CustomPainter {
  /// Creates a determinate progress painter.
  const _BorderProgressPainter({
    required this.progress,
    required this.strokeWidth,
    required this.borderRadius,
    required this.shapeBorder,
    required this.opacity,
    required this.spec,
  });

  /// Determinate progress value in the `0..1` range.
  final double progress;

  /// Stroke thickness for the rendered progress arc.
  final double strokeWidth;

  /// Rounded-rect radius fallback.
  final BorderRadius borderRadius;

  /// Optional custom shape override.
  final ShapeBorder? shapeBorder;

  /// Global opacity multiplier.
  final double opacity;

  /// Shader specification used to generate frame shader.
  final BorderLoadingSpec spec;

  /// Draws the determinate border segment.
  @override
  void paint(Canvas canvas, Size size) {
    // Nothing to paint when there is no size.
    if (size.isEmpty) return;

    // Clamp progress to valid bounds.
    final clampedProgress = progress.clamp(0.0, 1.0).toDouble();
    // Skip drawing for zero progress.
    if (clampedProgress <= 0) return;

    // Deflate so the stroke stays inside painter bounds.
    final halfStroke = strokeWidth / 2;
    final rect = (Offset.zero & size).deflate(halfStroke);

    // Build the full perimeter path.
    final borderPath = _buildOuterPath(
      rect: rect,
      borderRadius: borderRadius,
      shapeBorder: shapeBorder,
    );

    // Measure all path contours.
    final metrics = borderPath.computeMetrics(forceClosed: true).toList();
    if (metrics.isEmpty) return;

    // Compute total perimeter length.
    final totalLength = metrics.fold<double>(
      0,
      (value, metric) => value + metric.length,
    );
    if (totalLength <= 0) return;

    // Convert progress ratio to visible segment length.
    final visibleLength = totalLength * clampedProgress;
    // Extract leading path section from start point.
    final progressPath = _extractLeadingSegment(
      metrics: metrics,
      length: visibleLength,
      totalLength: totalLength,
    );

    // Resolve shader for this frame.
    final shader = spec.createShader(
      bounds: rect,
      progress: clampedProgress,
      path: borderPath,
    );

    // Clamp opacity to valid paint range.
    final effectiveOpacity = opacity.clamp(0.0, 1.0).toDouble();
    // Configure rounded stroke paint.
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..shader = shader
      ..strokeCap = StrokeCap.round;

    // Apply additional alpha as color filter when needed.
    if (effectiveOpacity < 1.0) {
      paint.colorFilter = ColorFilter.mode(
        const Color(0xFFFFFFFF).withValues(alpha: effectiveOpacity),
        BlendMode.modulate,
      );
    }

    // Draw determinate segment.
    canvas.drawPath(progressPath, paint);
  }

  /// Extracts the first [length] points of the multi-contour border path.
  Path _extractLeadingSegment({
    required List<PathMetric> metrics,
    required double length,
    required double totalLength,
  }) {
    final path = Path();
    // Nothing to extract when empty metrics or zero length.
    if (length <= 0 || metrics.isEmpty) return path;

    // Return full path when requested length reaches total perimeter.
    if (length >= totalLength) {
      for (final metric in metrics) {
        path.addPath(metric.extractPath(0, metric.length), Offset.zero);
      }
      return path;
    }

    // Walk contours in order and consume until requested length is satisfied.
    var remaining = length;
    for (final metric in metrics) {
      if (remaining <= 0) break;

      final slice = math.min(metric.length, remaining);
      if (slice > 0) {
        path.addPath(metric.extractPath(0, slice), Offset.zero);
        remaining -= slice;
      }
    }

    return path;
  }

  /// Repaints whenever visual inputs change.
  @override
  bool shouldRepaint(covariant _BorderProgressPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.borderRadius != borderRadius ||
        oldDelegate.shapeBorder != shapeBorder ||
        oldDelegate.opacity != opacity ||
        oldDelegate.spec != spec;
  }
}
