// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../text_animate.dart';

/// Blur -> settle effect for newly revealed characters.
@immutable
class BlurInEffect extends StreamingTextEffectAdapter
    with ComposableStreamingTextEffect {
  const BlurInEffect({
    this.duration = const Duration(milliseconds: 260),
    this.maxBlurSigma = 6,
    this.fadeIn = true,
    this.slideUpPx = 0,
    this.curve = Curves.easeOut,
  }) : assert(maxBlurSigma >= 0, 'maxBlurSigma must be >= 0');

  final Duration duration;

  final double maxBlurSigma;

  final bool fadeIn;

  final double slideUpPx;

  final Curve curve;

  @override
  Duration get settleDuration => duration;

  @override
  InlineSpan buildSpan({
    required String char,
    required int index,
    required Duration age,
    required TextStyle baseStyle,
  }) {
    if (char == '\n') {
      return TextSpan(text: char, style: baseStyle);
    }
    final child = wrap(
      child: Text(char, style: baseStyle),
      char: char,
      index: index,
      age: age,
      baseStyle: baseStyle,
    );
    return _buildCharacterWidgetSpan(child: child);
  }

  @override
  Widget wrap({
    required Widget child,
    required String char,
    required int index,
    required Duration age,
    required TextStyle baseStyle,
  }) {
    final t = _normalizedProgress(age: age, duration: duration, curve: curve);
    final sigma = math.pow(1 - t, 1.15).toDouble() * maxBlurSigma;
    final blurOpacity = (1 - t).clamp(0.0, 1.0);
    final sharpOpacity = fadeIn ? t.clamp(0.0, 1.0) : 1.0;
    final dy = slideUpPx * (1 - t);

    final sharpLayer = Opacity(opacity: sharpOpacity, child: child);

    Widget blurredLayer = child;
    if (sigma > 0.01) {
      blurredLayer = ImageFiltered(
        imageFilter: ImageFilter.blur(sigmaX: sigma, sigmaY: sigma),
        child: blurredLayer,
      );
    }
    blurredLayer = Opacity(opacity: blurOpacity, child: blurredLayer);

    var current = blurOpacity > 0.001
        ? Stack(clipBehavior: Clip.none, children: [sharpLayer, blurredLayer])
        : sharpLayer;

    if (slideUpPx != 0) {
      current = Transform.translate(offset: Offset(0, -dy), child: current);
    }

    final baseline = (baseStyle.fontSize ?? 14) * (baseStyle.height ?? 1.2);
    return Baseline(
      baseline: baseline,
      baselineType: TextBaseline.alphabetic,
      child: current,
    );
  }

  /// Compares two text animate values for structural equality.
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is BlurInEffect &&
        other.duration == duration &&
        other.maxBlurSigma == maxBlurSigma &&
        other.fadeIn == fadeIn &&
        other.slideUpPx == slideUpPx &&
        other.curve == curve;
  }

  @override
  int get hashCode =>
      Object.hash(duration, maxBlurSigma, fadeIn, slideUpPx, curve);
}
