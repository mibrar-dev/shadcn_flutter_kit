// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../text_animate.dart';

/// Opacity-only fade-in effect for newly revealed text units.
@immutable
class FadeInEffect extends StreamingTextEffectAdapter
    with ComposableStreamingTextEffect {
  const FadeInEffect({
    this.duration = const Duration(milliseconds: 240),
    this.curve = Curves.easeOut,
  });

  final Duration duration;

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

    return Baseline(
      baseline: baseline,
      baselineType: TextBaseline.alphabetic,
      child: Opacity(opacity: t.clamp(0.0, 1.0), child: child),
    );
  }

  /// Compares two text animate values for structural equality.
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FadeInEffect &&
        other.duration == duration &&
        other.curve == curve;
  }

  @override
  int get hashCode => Object.hash(duration, curve);
}
