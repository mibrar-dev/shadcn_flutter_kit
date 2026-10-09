// Whole-subtree variant of the streaming animation styles: the same
// progress math as the inline-span path, without the baseline wrapper
// (a `Baseline` around a tall column squashes it to one line height).
//
// Used by the streaming markdown tail. The blur row uses a single fading
// filtered layer here; the span path crossfades sharp over blurred instead.

import 'dart:math' as math;
import 'dart:ui' show ImageFilter;

import 'package:flutter/widgets.dart';

import 'streaming_clock.dart';
import 'streaming_effects.dart';

/// Animates block [child] with [effect] at reveal [age].
Widget animateStreamingBlock({
  required TextAnimateEffect effect,
  required Widget child,
  required Duration age,
}) {
  if (effect.kind == TextAnimateEffectKind.combined) {
    var current = child;
    for (final inner in effect.effects) {
      current = animateStreamingBlock(effect: inner, child: current, age: age);
    }
    return current;
  }
  final t = streamingProgress(
    age: age,
    duration: effect.duration,
    curve: effect.curve,
  );
  final double opacity =
      effect.fadeIn || effect.kind == TextAnimateEffectKind.fade
      ? t.clamp(0.0, 1.0)
      : 1;
  Widget current = child;
  if (effect.kind == TextAnimateEffectKind.blur) {
    final sigma = math.pow(1 - t, 1.15).toDouble() * effect.maxBlurSigma;
    if (sigma > 0.01) {
      current = ImageFiltered(
        imageFilter: ImageFilter.blur(sigmaX: sigma, sigmaY: sigma),
        child: current,
      );
    }
  }
  final double rise = switch (effect.kind) {
    TextAnimateEffectKind.slide => effect.offsetY * (1 - t),
    TextAnimateEffectKind.blur => effect.slideUpPx * (1 - t),
    _ => 0,
  };
  if (rise != 0) {
    current = Transform.translate(offset: Offset(0, rise), child: current);
  }
  if (opacity != 1) current = Opacity(opacity: opacity, child: current);
  return current;
}
