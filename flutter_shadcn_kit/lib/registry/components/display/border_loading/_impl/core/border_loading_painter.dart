// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../border_loading.dart';

/// Paints a full border stroke for sweep/static modes.
class _BorderLoadingPainter extends CustomPainter {
  /// Creates a painter for full-outline rendering.
  const _BorderLoadingPainter({
    required this.progress,
    required this.strokeWidth,
    required this.borderRadius,
    required this.shapeBorder,
    required this.opacity,
    required this.spec,
  });

  /// Normalized animation progress in the `0..1` range.
  final double progress;

  /// Stroke thickness for the rendered border.
  final double strokeWidth;

  /// Rounded-rect radius fallback.
  final BorderRadius borderRadius;

  /// Optional custom shape override.
  final ShapeBorder? shapeBorder;

  /// Global opacity multiplier.
  final double opacity;

  /// Shader specification used to generate frame shader.
  final BorderLoadingSpec spec;

  /// Draws the full border path.
  @override
  void paint(Canvas canvas, Size size) {
    // Nothing to paint when there is no size.
    if (size.isEmpty) return;

    // Deflate so the stroke stays inside painter bounds.
    final halfStroke = strokeWidth / 2;
    final rect = (Offset.zero & size).deflate(halfStroke);

    // Build the shape perimeter path.
    final path = _buildOuterPath(
      rect: rect,
      borderRadius: borderRadius,
      shapeBorder: shapeBorder,
    );

    // Resolve shader for this frame.
    final shader = spec.createShader(
      bounds: rect,
      progress: progress,
      path: path,
    );

    // Clamp opacity to valid paint range.
    final effectiveOpacity = opacity.clamp(0.0, 1.0).toDouble();

    // Configure stroke paint with shader.
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..shader = shader;

    // Apply additional alpha as color filter when needed.
    if (effectiveOpacity < 1.0) {
      paint.colorFilter = ColorFilter.mode(
        const Color(0xFFFFFFFF).withValues(alpha: effectiveOpacity),
        BlendMode.modulate,
      );
    }

    // Draw final full border stroke.
    canvas.drawPath(path, paint);
  }

  /// Repaints whenever visual inputs change.
  @override
  bool shouldRepaint(covariant _BorderLoadingPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.borderRadius != borderRadius ||
        oldDelegate.shapeBorder != shapeBorder ||
        oldDelegate.opacity != opacity ||
        oldDelegate.spec != spec;
  }
}
