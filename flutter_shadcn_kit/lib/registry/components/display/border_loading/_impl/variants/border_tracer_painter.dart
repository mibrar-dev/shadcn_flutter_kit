// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../border_loading.dart';

/// Paints moving dash-like perimeter segments for tracer mode.
class _BorderTracerPainter extends CustomPainter {
  /// Creates a tracer painter.
  const _BorderTracerPainter({
    required this.progress,
    required this.strokeWidth,
    required this.borderRadius,
    required this.shapeBorder,
    required this.opacity,
    required this.spec,
    required this.tracer,
  });

  /// Normalized animation progress in the `0..1` range.
  final double progress;

  /// Stroke thickness for tracer segments.
  final double strokeWidth;

  /// Rounded-rect radius fallback.
  final BorderRadius borderRadius;

  /// Optional custom shape override.
  final ShapeBorder? shapeBorder;

  /// Global opacity multiplier.
  final double opacity;

  /// Shader specification used to generate frame shader.
  final BorderLoadingSpec spec;

  /// Tracer segment behavior options.
  final BorderTracerSpec tracer;

  /// Draws moving perimeter segments.
  @override
  void paint(Canvas canvas, Size size) {
    // Nothing to paint when there is no size.
    if (size.isEmpty) return;

    // Deflate so the stroke stays inside painter bounds.
    final halfStroke = strokeWidth / 2;
    final rect = (Offset.zero & size).deflate(halfStroke);

    // Build the full perimeter path.
    final borderPath = _buildOuterPath(
      rect: rect,
      borderRadius: borderRadius,
      shapeBorder: shapeBorder,
    );

    // Measure all contours for segment extraction.
    final metrics = borderPath.computeMetrics(forceClosed: true).toList();
    if (metrics.isEmpty) return;

    // Compute total perimeter length.
    final totalLength = metrics.fold<double>(
      0,
      (value, metric) => value + metric.length,
    );
    if (totalLength <= 0) return;

    // Clamp dash count to a safe range.
    final dashCount = tracer.dashCount.clamp(1, 64);
    // Clamp gap fraction to prevent negative segment lanes.
    final gap = tracer.gapFraction.clamp(0.0, 0.95).toDouble();
    // Convert requested relative length to absolute length.
    final rawLength =
        tracer.lengthFraction.clamp(0.0, 1.0).toDouble() * totalLength;
    // Segment lane spacing for evenly distributed dashes.
    final stride = totalLength / dashCount;
    // Maximum segment length inside each lane.
    final maxLength = stride * (1.0 - gap);
    // Final segment length honoring lane gap.
    final segmentLength = math.min(rawLength, maxLength);
    if (segmentLength <= 0) return;

    // Resolve shader for this frame.
    final shader = spec.createShader(
      bounds: rect,
      progress: progress,
      path: borderPath,
    );

    // Clamp opacity to valid paint range.
    final effectiveOpacity = opacity.clamp(0.0, 1.0).toDouble();

    // Configure tracer stroke paint.
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..shader = shader
      ..strokeCap = tracer.roundCaps ? StrokeCap.round : StrokeCap.butt;

    // Apply additional alpha as color filter when needed.
    if (effectiveOpacity < 1.0) {
      paint.colorFilter = ColorFilter.mode(
        const Color(0xFFFFFFFF).withValues(alpha: effectiveOpacity),
        BlendMode.modulate,
      );
    }

    // Normalize progress and draw each segment with phase offset.
    final normalizedProgress = progress % 1.0;
    for (var i = 0; i < dashCount; i++) {
      final start =
          (normalizedProgress * totalLength + (i * stride)) % totalLength;
      final segment = _extractWrappedSegment(
        metrics: metrics,
        startOffset: start,
        length: segmentLength,
        totalLength: totalLength,
      );
      canvas.drawPath(segment, paint);
    }
  }

  /// Extracts a segment that can wrap across contour boundaries.
  Path _extractWrappedSegment({
    required List<PathMetric> metrics,
    required double startOffset,
    required double length,
    required double totalLength,
  }) {
    final path = Path();
    // Nothing to extract for invalid input.
    if (metrics.isEmpty || length <= 0) return path;

    // Fast path: requested length covers the full perimeter.
    if (length >= totalLength) {
      for (final metric in metrics) {
        path.addPath(metric.extractPath(0, metric.length), Offset.zero);
      }
      return path;
    }

    // Consume chunk by chunk until requested length is satisfied.
    var remaining = length;

    var cursor = startOffset % totalLength;

    while (remaining > 0) {
      final consumed = _appendSegmentChunk(
        metrics: metrics,
        startOffset: cursor,
        maxLength: remaining,
        outPath: path,
      );
      if (consumed <= 0) {
        break;
      }
      remaining -= consumed;
      cursor = (cursor + consumed) % totalLength;
    }

    return path;
  }

  /// Appends one contiguous chunk starting at [startOffset].
  double _appendSegmentChunk({
    required List<PathMetric> metrics,
    required double startOffset,
    required double maxLength,
    required Path outPath,
  }) {
    // Nothing to append for non-positive length.
    if (maxLength <= 0) return 0;

    // Locate the contour that contains the start offset.
    var traversed = 0.0;

    var startMetricIndex = 0;
    for (var i = 0; i < metrics.length; i++) {
      final metricLength = metrics[i].length;
      if (startOffset <= traversed + metricLength) {
        startMetricIndex = i;
        break;
      }
      traversed += metricLength;
    }

    // Convert global offset to local contour offset.
    var consumed = 0.0;

    var localStart = startOffset - traversed;

    // Append across contours until chunk capacity is consumed.
    for (var step = 0; step < metrics.length && consumed < maxLength; step++) {
      final metric = metrics[(startMetricIndex + step) % metrics.length];

      final start = step == 0 ? localStart : 0.0;

      final available = metric.length - start;
      if (available <= 0) {
        localStart = 0;
        continue;
      }

      final amount = math.min(available, maxLength - consumed);
      outPath.addPath(metric.extractPath(start, start + amount), Offset.zero);
      consumed += amount;
      localStart = 0;
    }

    return consumed;
  }

  /// Repaints whenever visual inputs change.
  @override
  bool shouldRepaint(covariant _BorderTracerPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.borderRadius != borderRadius ||
        oldDelegate.shapeBorder != shapeBorder ||
        oldDelegate.opacity != opacity ||
        oldDelegate.spec != spec ||
        oldDelegate.tracer.lengthFraction != tracer.lengthFraction ||
        oldDelegate.tracer.gapFraction != tracer.gapFraction ||
        oldDelegate.tracer.dashCount != tracer.dashCount ||
        oldDelegate.tracer.roundCaps != tracer.roundCaps;
  }
}
