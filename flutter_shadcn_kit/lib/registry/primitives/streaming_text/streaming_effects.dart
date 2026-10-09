// Animation styles for streaming text: one [TextAnimateEffect] with const
// named constructors per style plus an exhaustive `switch` in [wrap]. The
// whole-subtree path lives in `streaming_block.dart` (same folder).
//
// Effects are data (pilot pattern), so the component theme can hold them as
// const values. All parameters are plain values, never closures.

import 'dart:math' as math;
import 'dart:ui' show ImageFilter;

import 'package:flutter/widgets.dart';

import 'streaming_clock.dart';

/// Animation style of newly revealed units.
enum TextAnimateEffectKind { none, fade, slide, blur, scramble, combined }

/// Per-unit animation applied to newly revealed text.
///
/// [wrap] is the inline-span path (every row baselines its span);
/// [buildSpan] turns a wrapped character into its span. Block content uses
/// `animateStreamingBlock` (`streaming_block.dart`, same folder).
class TextAnimateEffect {
  const TextAnimateEffect._({
    required this.kind,
    this.duration = Duration.zero,
    this.curve = Curves.linear,
    this.offsetY = 0,
    this.maxBlurSigma = 0,
    this.fadeIn = false,
    this.slideUpPx = 0,
    this.scrambleUntil = 1,
    this.characters = '',
    this.effects = const <TextAnimateEffect>[],
  }) : assert(
         kind != TextAnimateEffectKind.blur || maxBlurSigma >= 0,
         'maxBlurSigma must be >= 0',
       ),
       assert(
         kind != TextAnimateEffectKind.scramble ||
             (scrambleUntil > 0 && scrambleUntil <= 1),
         'scrambleUntil must be in (0, 1].',
       );

  /// No animation: units appear settled.
  const TextAnimateEffect.none() : this._(kind: TextAnimateEffectKind.none);

  /// Opacity-only fade-in.
  const TextAnimateEffect.fade({
    Duration duration = const Duration(milliseconds: 240),
    Curve curve = Curves.easeOut,
  }) : this._(
         kind: TextAnimateEffectKind.fade,
         duration: duration,
         curve: curve,
       );

  /// Vertical slide-in, optionally fading while moving into place.
  const TextAnimateEffect.slide({
    Duration duration = const Duration(milliseconds: 280),
    double offsetY = 10,
    bool fadeIn = true,
    Curve curve = Curves.easeOutCubic,
  }) : this._(
         kind: TextAnimateEffectKind.slide,
         duration: duration,
         curve: curve,
         offsetY: offsetY,
         fadeIn: fadeIn,
       );

  /// Blur-to-sharp, with an optional rise.
  const TextAnimateEffect.blur({
    Duration duration = const Duration(milliseconds: 260),
    double maxBlurSigma = 6,
    bool fadeIn = true,
    double slideUpPx = 0,
    Curve curve = Curves.easeOut,
  }) : this._(
         kind: TextAnimateEffectKind.blur,
         duration: duration,
         curve: curve,
         maxBlurSigma: maxBlurSigma,
         fadeIn: fadeIn,
         slideUpPx: slideUpPx,
       );

  /// Scrambles through glyphs before resolving to the final unit.
  const TextAnimateEffect.scramble({
    Duration duration = const Duration(milliseconds: 460),
    double scrambleUntil = 0.74,
    bool fadeIn = true,
    Curve curve = Curves.easeOut,
    String characters =
        'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789@#%&*+=?',
  }) : this._(
         kind: TextAnimateEffectKind.scramble,
         duration: duration,
         curve: curve,
         fadeIn: fadeIn,
         scrambleUntil: scrambleUntil,
         characters: characters,
       );

  /// Runs several effects over the same unit, innermost first.
  const TextAnimateEffect.combined(List<TextAnimateEffect> effects)
    : this._(kind: TextAnimateEffectKind.combined, effects: effects);

  final TextAnimateEffectKind kind;
  final Duration duration;
  final Curve curve;

  /// Slide distance in logical pixels (slide).
  final double offsetY;

  /// Starting blur sigma (blur).
  final double maxBlurSigma;

  /// Fade from transparent while settling (slide/blur/scramble).
  final bool fadeIn;

  /// Rise in logical pixels while settling (blur).
  final double slideUpPx;

  /// Fraction of the duration showing scramble glyphs (scramble).
  final double scrambleUntil;

  /// Glyph pool for the scramble phase (scramble).
  final String characters;

  /// Inner effects, applied innermost first (combined).
  final List<TextAnimateEffect> effects;

  /// Time until one unit reads as settled (longest inner, if combined).
  Duration get settleDuration {
    if (kind != TextAnimateEffectKind.combined) return duration;
    var longest = Duration.zero;
    for (final effect in effects) {
      if (effect.settleDuration > longest) longest = effect.settleDuration;
    }
    return longest;
  }

  /// Wraps [child] with the effect at reveal [age] (inline-span path).
  Widget wrap({
    required Widget child,
    required String char,
    required int index,
    required Duration age,
    required TextStyle baseStyle,
  }) {
    return switch (kind) {
      TextAnimateEffectKind.none => child,
      TextAnimateEffectKind.fade => _onBaseline(
        child: _fade(child: child, age: age),
        baseStyle: baseStyle,
      ),
      TextAnimateEffectKind.slide => _onBaseline(
        child: _slide(child: child, age: age),
        baseStyle: baseStyle,
      ),
      TextAnimateEffectKind.blur => _blur(
        child: child,
        age: age,
        baseStyle: baseStyle,
      ),
      TextAnimateEffectKind.scramble => _scramble(
        child: child,
        char: char,
        index: index,
        age: age,
        baseStyle: baseStyle,
      ),
      TextAnimateEffectKind.combined => _combined(
        child: child,
        char: char,
        index: index,
        age: age,
        baseStyle: baseStyle,
      ),
    };
  }

  Widget _fade({required Widget child, required Duration age}) {
    final t = streamingProgress(age: age, duration: duration, curve: curve);
    return Opacity(opacity: t.clamp(0.0, 1.0), child: child);
  }

  Widget _slide({required Widget child, required Duration age}) {
    final t = streamingProgress(age: age, duration: duration, curve: curve);
    Widget current = Transform.translate(
      offset: Offset(0, offsetY * (1 - t)),
      child: child,
    );
    if (fadeIn) {
      current = Opacity(opacity: t.clamp(0.0, 1.0), child: current);
    }
    return current;
  }

  Widget _blur({
    required Widget child,
    required Duration age,
    required TextStyle baseStyle,
  }) {
    final t = streamingProgress(age: age, duration: duration, curve: curve);
    final sigma = math.pow(1 - t, 1.15).toDouble() * maxBlurSigma;
    Widget blurred = child;
    if (sigma > 0.01) {
      blurred = ImageFiltered(
        imageFilter: ImageFilter.blur(sigmaX: sigma, sigmaY: sigma),
        child: blurred,
      );
    }
    // Sharp layer fades in while the blurred layer fades out; without
    // `fadeIn` the sharp text is opaque from the first frame. The blurred
    // layer leaves the tree once settled so no filter stays mounted.
    final sharp = Opacity(
      opacity: fadeIn ? t.clamp(0.0, 1.0) : 1,
      child: child,
    );
    Widget current = (1 - t).clamp(0.0, 1.0) > 0.001
        ? Stack(
            clipBehavior: Clip.none,
            children: <Widget>[
              sharp,
              Opacity(opacity: (1 - t).clamp(0.0, 1.0), child: blurred),
            ],
          )
        : sharp;
    if (slideUpPx != 0) {
      current = Transform.translate(
        offset: Offset(0, -slideUpPx * (1 - t)),
        child: current,
      );
    }
    return _onBaseline(child: current, baseStyle: baseStyle);
  }

  Widget _scramble({
    required Widget child,
    required String char,
    required int index,
    required Duration age,
    required TextStyle baseStyle,
  }) {
    final t = streamingProgress(age: age, duration: duration, curve: curve);
    final showScramble = char.trim().isNotEmpty && t < scrambleUntil;
    Widget current = Opacity(
      opacity: fadeIn ? t.clamp(0.0, 1.0) : 1,
      child: child,
    );
    if (showScramble) {
      current = Stack(
        clipBehavior: Clip.none,
        children: <Widget>[
          current,
          Opacity(
            opacity: (1 - (t / scrambleUntil)).clamp(0.0, 1.0),
            child: Text(
              _scrambledCharacter(char: char, index: index, age: age),
              style: baseStyle,
            ),
          ),
        ],
      );
    }
    return _onBaseline(child: current, baseStyle: baseStyle);
  }

  /// Deterministic scramble frame for a unit at an age (no `Random`, so
  /// frames are stable across rebuilds).
  String _scrambledCharacter({
    required String char,
    required int index,
    required Duration age,
  }) {
    if (characters.isEmpty) return char;
    final glyphs = characters.runes.toList(growable: false);
    final frameStepMs = duration.inMilliseconds ~/ 14;
    final frame = age.inMilliseconds ~/ (frameStepMs < 1 ? 1 : frameStepMs);
    final code = char.runes.isEmpty ? 0 : char.runes.first;
    final seed =
        (index * 73856093 ^ frame * 19349663 ^ code * 83492791) % glyphs.length;
    return String.fromCharCode(glyphs[seed]);
  }

  Widget _combined({
    required Widget child,
    required String char,
    required int index,
    required Duration age,
    required TextStyle baseStyle,
  }) {
    var current = child;
    for (final effect in effects) {
      current = effect.wrap(
        child: current,
        char: char,
        index: index,
        age: age,
        baseStyle: baseStyle,
      );
    }
    return current;
  }

  /// Baselines inline spans so mixed animated/plain text shares one line box.
  Widget _onBaseline({required Widget child, required TextStyle baseStyle}) {
    final baseline = (baseStyle.fontSize ?? 14) * (baseStyle.height ?? 1.2);
    return Baseline(
      baseline: baseline,
      baselineType: TextBaseline.alphabetic,
      child: child,
    );
  }

  /// Inline span for one unit; newlines stay plain spans.
  InlineSpan buildSpan({
    required String char,
    required int index,
    required Duration age,
    required TextStyle baseStyle,
  }) {
    if (char == '\n') return TextSpan(text: char, style: baseStyle);
    return streamingCharacterSpan(
      child: wrap(
        child: Text(char, style: baseStyle),
        char: char,
        index: index,
        age: age,
        baseStyle: baseStyle,
      ),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TextAnimateEffect &&
        other.kind == kind &&
        other.duration == duration &&
        other.curve == curve &&
        other.offsetY == offsetY &&
        other.maxBlurSigma == maxBlurSigma &&
        other.fadeIn == fadeIn &&
        other.slideUpPx == slideUpPx &&
        other.scrambleUntil == scrambleUntil &&
        other.characters == characters &&
        _effectsEqual(other.effects, effects);
  }

  @override
  int get hashCode => Object.hash(
    kind,
    duration,
    curve,
    offsetY,
    maxBlurSigma,
    fadeIn,
    slideUpPx,
    scrambleUntil,
    characters,
    Object.hashAll(effects),
  );
}

/// Element-wise effect equality for the combined row.
bool _effectsEqual(List<TextAnimateEffect> a, List<TextAnimateEffect> b) {
  if (a.length != b.length) return false;
  for (var i = 0; i < a.length; i++) {
    if (a[i] != b[i]) return false;
  }
  return true;
}
