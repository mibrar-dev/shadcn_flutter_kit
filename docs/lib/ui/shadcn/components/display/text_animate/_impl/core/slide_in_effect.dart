// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../text_animate.dart';

/// Vertical slide-in effect, optionally fading while moving into place.
@immutable
class SlideInEffect extends StreamingTextEffectAdapter
    with ComposableStreamingTextEffect {
  const SlideInEffect({
    this.duration = const Duration(milliseconds: 280),
    this.offsetY = 10,
    this.fadeIn = true,
    this.curve = Curves.easeOutCubic,
  });

  final Duration duration;

  final double offsetY;

  final bool fadeIn;

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
    final baseline = (baseStyle.fontSize ?? 14) * (baseStyle.height ?? 1.2);

    Widget current = Transform.translate(
      offset: Offset(0, offsetY * (1 - t)),
      child: child,
    );

    if (fadeIn) {
      current = Opacity(opacity: t.clamp(0.0, 1.0), child: current);
    }

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
    return other is SlideInEffect &&
        other.duration == duration &&
        other.offsetY == offsetY &&
        other.fadeIn == fadeIn &&
        other.curve == curve;
  }

  @override
  int get hashCode => Object.hash(duration, offsetY, fadeIn, curve);
}
