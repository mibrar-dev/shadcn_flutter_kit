// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../text_animate.dart';

/// Base adapter for per-character text effects in [StreamingText].
abstract class StreamingTextEffectAdapter {
  const StreamingTextEffectAdapter();

  /// Duration until the effect is fully settled for a character.
  Duration get settleDuration;

  /// Builds an inline span for a character at a given reveal age.
  InlineSpan buildSpan({
    required String char,
    required int index,
    required Duration age,
    required TextStyle baseStyle,
  }) {
    if (char == '\n') {
      return TextSpan(text: char, style: baseStyle);
    }
    return _buildCharacterWidgetSpan(child: Text(char, style: baseStyle));
  }
}

/// Marker for effect adapters that can compose by wrapping an existing child.
mixin ComposableStreamingTextEffect on StreamingTextEffectAdapter {
  Widget wrap({
    required Widget child,
    required String char,
    required int index,
    required Duration age,
    required TextStyle baseStyle,
  });
}

/// No-op effect that renders plain text spans.
@immutable
class NoEffect extends StreamingTextEffectAdapter
    with ComposableStreamingTextEffect {
  const NoEffect();

  @override
  Duration get settleDuration => Duration.zero;

  @override
  InlineSpan buildSpan({
    required String char,
    required int index,
    required Duration age,
    required TextStyle baseStyle,
  }) {
    return TextSpan(text: char, style: baseStyle);
  }

  @override
  Widget wrap({
    required Widget child,
    required String char,
    required int index,
    required Duration age,
    required TextStyle baseStyle,
  }) {
    return child;
  }

  /// Compares two text animate values for structural equality.
  @override
  bool operator ==(Object other) => other is NoEffect;

  @override
  int get hashCode => 0;
}
