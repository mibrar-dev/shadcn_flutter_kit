// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../border_loading.dart';

/// Mathematical constant for one full rotation in radians.
const double _kTau = math.pi * 2;

/// Ensures gradient input always has at least two colors.
List<Color> _safeGradientColors(List<Color> colors) {
  // Empty gradients fallback to transparent -> white.
  if (colors.isEmpty) {
    return const [Color(0x00000000), Color(0xFFFFFFFF)];
  }
  // Single-color gradients are duplicated for valid interpolation.
  if (colors.length == 1) {
    return [colors.first, colors.first];
  }
  // Already valid.
  return colors;
}

/// Dispatches shader creation to the active [BorderGradientType].
Shader _createGradientShader({
  required BorderGradientSpec spec,
  required Rect bounds,
  required double progress,
}) {
  return switch (spec.type) {
    BorderGradientType.linear => _buildLinearShader(
      spec: spec,
      bounds: bounds,
      progress: progress,
    ),
    BorderGradientType.radial => _buildRadialShader(
      spec: spec,
      bounds: bounds,
      progress: progress,
    ),
    BorderGradientType.sweep => _buildSweepShader(
      spec: spec,
      bounds: bounds,
      progress: progress,
    ),
  };
}

/// Builds a sweep shader with optional rotational animation.
Shader _buildSweepShader({
  required BorderGradientSpec spec,
  required Rect bounds,
  required double progress,
}) {
  // Compute visible sweep after subtracting gap.
  final sweep = (1.0 - spec.gap).clamp(0.0, 1.0);
  // Convert normalized progress into radians when enabled.
  final rotation = spec.rotateWithProgress ? _kTau * progress : 0.0;
  // Base sweep range starts at configured start angle.
  final startAngle = spec.startAngle;
  final endAngle = startAngle + (_kTau * sweep);

  return SweepGradient(
    startAngle: startAngle,
    endAngle: endAngle,
    colors: _safeGradientColors(spec.colors),
    stops: spec.stops,
    // Rotation is applied as a transform for seamless looping.
    transform: GradientRotation(rotation),
  ).createShader(bounds);
}

/// Builds a linear shader with optional alignment drift animation.
Shader _buildLinearShader({
  required BorderGradientSpec spec,
  required Rect bounds,
  required double progress,
}) {
  // Start with configured endpoints.
  var begin = spec.begin;

  var end = spec.end;

  // Optionally add a subtle sinusoidal drift.
  if (spec.shiftWithProgress) {
    final wiggle = math.sin(progress * _kTau) * 0.08;
    begin = Alignment(begin.x + wiggle, begin.y - wiggle);
    end = Alignment(end.x - wiggle, end.y + wiggle);
  }

  return LinearGradient(
    begin: begin,
    end: end,
    colors: _safeGradientColors(spec.colors),
    stops: spec.stops,
  ).createShader(bounds);
}

/// Builds a radial shader with optional pulsing radius animation.
Shader _buildRadialShader({
  required BorderGradientSpec spec,
  required Rect bounds,
  required double progress,
}) {
  // Start with configured radius.
  var radius = spec.radius;
  // Optionally pulse radius using a sinusoid.
  if (spec.pulseWithProgress) {
    radius = (spec.radius + 0.08 * math.sin(progress * _kTau)).clamp(0.0, 2.0);
  }

  return RadialGradient(
    center: spec.center,
    radius: radius,
    colors: _safeGradientColors(spec.colors),
    stops: spec.stops,
  ).createShader(bounds);
}
