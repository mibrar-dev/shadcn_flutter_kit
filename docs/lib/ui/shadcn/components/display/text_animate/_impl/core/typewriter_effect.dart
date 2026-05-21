// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../text_animate.dart';

/// Typewriter reveal settings for [StreamingText].
@immutable
class TypewriterEffect {
  const TypewriterEffect({this.enabled = true, this.charsPerSecond = 48});

  /// Enables/disables progressive reveal.
  final bool enabled;

  /// Reveal speed for newly appended characters.
  final double charsPerSecond;

  /// Compares two text animate values for structural equality.
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TypewriterEffect &&
        other.enabled == enabled &&
        other.charsPerSecond == charsPerSecond;
  }

  /// State flag that toggles specific text animate behavior.
  @override
  int get hashCode => Object.hash(enabled, charsPerSecond);
}
