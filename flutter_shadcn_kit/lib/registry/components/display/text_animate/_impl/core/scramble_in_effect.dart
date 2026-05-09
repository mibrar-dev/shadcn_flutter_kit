// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../text_animate.dart';

/// Scrambles newly revealed text before settling into final glyphs.
@immutable
class ScrambleInEffect extends StreamingTextEffectAdapter
    with ComposableStreamingTextEffect {
  const ScrambleInEffect({
    this.duration = const Duration(milliseconds: 460),
    this.scrambleUntil = 0.74,
    this.fadeIn = true,
    this.curve = Curves.easeOut,
    this.characters =
        'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789@#%&*+=?',
  }) : assert(
         scrambleUntil > 0 && scrambleUntil <= 1,
         'scrambleUntil must be in (0, 1].',
       );

  final Duration duration;

  final double scrambleUntil;

  final bool fadeIn;

  final Curve curve;

  final String characters;

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
    final showScramble = char.trim().isNotEmpty && t < scrambleUntil;

    final targetOpacity = fadeIn ? t.clamp(0.0, 1.0) : 1.0;
    final scrambleOpacity = showScramble
        ? (1 - (t / scrambleUntil)).clamp(0.0, 1.0)
        : 0.0;

    final displayedChar = showScramble
        ? _scrambledCharacter(char: char, index: index, age: age)
        : char;

    Widget current = Opacity(opacity: targetOpacity, child: child);

    if (showScramble) {
      current = Stack(
        clipBehavior: Clip.none,
        children: [
          current,

          Opacity(
            opacity: scrambleOpacity,
            child: Text(displayedChar, style: baseStyle),
          ),
        ],
      );
    }

    return Baseline(
      baseline: baseline,
      baselineType: TextBaseline.alphabetic,
      child: current,
    );
  }

  String _scrambledCharacter({
    required String char,
    required int index,
    required Duration age,
  }) {
    if (characters.isEmpty) {
      return char;
    }

    final glyphs = characters.runes.toList(growable: false);
    final frameStepMs = math.max(1, duration.inMilliseconds ~/ 14);

    final frame = age.inMilliseconds ~/ frameStepMs;

    final code = char.runes.isEmpty ? 0 : char.runes.first;

    var seed = index * 73856093;
    seed ^= frame * 19349663;
    seed ^= code * 83492791;

    final value = seed.abs() % glyphs.length;
    return String.fromCharCode(glyphs[value]);
  }

  /// Compares two text animate values for structural equality.
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ScrambleInEffect &&
        other.duration == duration &&
        other.scrambleUntil == scrambleUntil &&
        other.fadeIn == fadeIn &&
        other.curve == curve &&
        other.characters == characters;
  }

  @override
  int get hashCode =>
      Object.hash(duration, scrambleUntil, fadeIn, curve, characters);
}
