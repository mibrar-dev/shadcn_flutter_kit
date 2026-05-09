// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../text_animate.dart';

/// Combines multiple effect adapters into a single effect.
@immutable
class CombinedEffect extends StreamingTextEffectAdapter
    with ComposableStreamingTextEffect {
  const CombinedEffect(this.effects);

  final List<StreamingTextEffectAdapter> effects;

  @override
  Duration get settleDuration {
    var maxDuration = Duration.zero;
    for (final effect in effects) {
      if (effect.settleDuration > maxDuration) {
        maxDuration = effect.settleDuration;
      }
    }
    return maxDuration;
  }

  @override
  InlineSpan buildSpan({
    required String char,
    required int index,
    required Duration age,
    required TextStyle baseStyle,
  }) {
    if (effects.isEmpty) {
      return TextSpan(text: char, style: baseStyle);
    }
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
    var current = child;
    for (final effect in effects) {
      if (effect is ComposableStreamingTextEffect) {
        current = effect.wrap(
          child: current,
          char: char,
          index: index,
          age: age,
          baseStyle: baseStyle,
        );
        continue;
      }
      final span = effect.buildSpan(
        char: char,
        index: index,
        age: age,
        baseStyle: baseStyle,
      );
      current = _spanToWidget(
        span: span,
        fallbackChar: char,
        baseStyle: baseStyle,
      );
    }
    return current;
  }

  /// Compares two text animate values for structural equality.
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! CombinedEffect || other.effects.length != effects.length) {
      return false;
    }
    for (var i = 0; i < effects.length; i++) {
      if (effects[i] != other.effects[i]) return false;
    }
    return true;
  }

  @override
  int get hashCode => Object.hashAll(effects);
}
