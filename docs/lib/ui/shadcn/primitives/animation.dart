// Small animation helpers: a repeating value builder and a value-mapped
// animation facade over an [AnimationController].
//
// Ported from `shared/utils/_impl/core/repeated_animation_builder.dart`,
// `_impl/state/__repeated_animation_builder_state.dart` and
// `shared/utils/controlled_animation.dart`.

import 'dart:ui' show ImageFilter;

import 'package:flutter/widgets.dart';

/// Builds a widget from a repeating animation value in `start..end`.
typedef RepeatedAnimationWidgetBuilder =
    Widget Function(BuildContext context, double value, Widget? child);

/// Repeats `start -> end` and rebuilds through [builder].
class RepeatedAnimationBuilder extends StatefulWidget {
  /// The value at animation progress 0.
  final double start;

  /// The value at animation progress 1.
  final double end;

  /// Duration of one cycle.
  final Duration duration;

  /// Curve applied to the cycle.
  final Curve curve;

  /// Builds the widget from the current value.
  final RepeatedAnimationWidgetBuilder builder;

  /// Passed through to [builder].
  final Widget? child;

  /// Creates a [RepeatedAnimationBuilder].
  const RepeatedAnimationBuilder({
    super.key,
    required this.start,
    required this.end,
    required this.duration,
    this.curve = Curves.linear,
    required this.builder,
    this.child,
  });

  @override
  State<RepeatedAnimationBuilder> createState() =>
      _RepeatedAnimationBuilderState();
}

class _RepeatedAnimationBuilderState extends State<RepeatedAnimationBuilder>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration)
      ..repeat();
    _animation = CurvedAnimation(parent: _controller, curve: widget.curve);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      child: widget.child,
      builder: (context, child) {
        final value =
            widget.start + (widget.end - widget.start) * _animation.value;
        return widget.builder(context, value, child);
      },
    );
  }
}

/// Maps an [AnimationController]'s progress onto an animated value.
///
/// [forward] animates from the current value to [to] with an optional curve;
/// setting [value] snaps without animating.
class ControlledAnimation extends Animation<double> {
  final AnimationController _controller;
  double _from = 0;
  double _to = 1;
  Curve _curve = Curves.linear;

  /// Creates a controlled animation over [controller].
  ControlledAnimation(this._controller);

  /// Animates from the current value to [to] with [curve].
  TickerFuture forward(double to, [Curve? curve]) {
    _from = value;
    _to = to;
    _curve = curve ?? Curves.linear;
    return _controller.forward(from: 0);
  }

  /// Snaps to [value] without animating.
  set value(double value) {
    _from = value;
    _to = value;
    _curve = Curves.linear;
    _controller.value = 0;
  }

  @override
  void addListener(VoidCallback listener) {
    _controller.addListener(listener);
  }

  @override
  void addStatusListener(AnimationStatusListener listener) {
    _controller.addStatusListener(listener);
  }

  @override
  void removeListener(VoidCallback listener) {
    _controller.removeListener(listener);
  }

  @override
  void removeStatusListener(AnimationStatusListener listener) {
    _controller.removeStatusListener(listener);
  }

  @override
  AnimationStatus get status => _controller.status;

  @override
  double get value =>
      _from + (_to - _from) * _curve.transform(_controller.value);
}

/// Piecewise spring curve ported from the CSS `linear(...)` Sileo profile.
///
/// Used by the `gooey_toast` component's `springEasing` animation style; the
/// stop list is a verbatim transcription of the old
/// `_SileoSpringEasingCurve`.
class SileoSpringCurve extends Curve {
  /// Creates the curve.
  const SileoSpringCurve();

  static const List<double> _stops = <double>[
    0,
    0,
    0.006,
    0.002,
    0.012,
    0.007,
    0.018,
    0.015,
    0.024,
    0.026,
    0.031,
    0.041,
    0.038,
    0.06,
    0.053,
    0.108,
    0.066,
    0.157,
    0.08,
    0.214,
    0.137,
    0.467,
    0.163,
    0.577,
    0.177,
    0.631,
    0.191,
    0.682,
    0.205,
    0.73,
    0.218,
    0.771,
    0.231,
    0.808,
    0.245,
    0.844,
    0.258,
    0.874,
    0.272,
    0.903,
    0.286,
    0.928,
    0.301,
    0.952,
    0.316,
    0.972,
    0.331,
    0.988,
    0.357,
    1.01,
    0.385,
    1.025,
    0.416,
    1.034,
    0.45,
    1.038,
    0.501,
    1.035,
    0.642,
    1.012,
    0.73,
    1.003,
    0.837,
    0.999,
    1,
    1,
  ];

  @override
  double transformInternal(double t) {
    if (t <= 0) {
      return _stops[1];
    }
    if (t >= 1) {
      return _stops.last;
    }
    for (var i = 2; i < _stops.length; i += 2) {
      if (t <= _stops[i]) {
        final double x0 = _stops[i - 2];
        final double y0 = _stops[i - 1];
        final double x1 = _stops[i];
        final double y1 = _stops[i + 1];
        final double span = x1 - x0;
        if (span <= 0) {
          return y1;
        }
        return y0 + (y1 - y0) * ((t - x0) / span);
      }
    }
    return _stops.last;
  }
}

/// Normalized ping-pong position for a looping scroll: rest at [rest], one
/// run of [run], rest again, then the mirrored way back.
///
/// [elapsed] is unbounded running time; [curve] eases each run. Used by the
/// `overflow_marquee` component for its forward/back ticker.
double pingPongProgress({
  required Duration elapsed,
  required Duration run,
  required Duration rest,
  required Curve curve,
}) {
  if (run <= Duration.zero) {
    return 0;
  }
  final int runUs = run.inMicroseconds;
  final int restUs = rest.inMicroseconds;
  final int phase = restUs + runUs;
  int t = elapsed.inMicroseconds % (2 * phase);
  final bool reverse = t > phase;
  if (reverse) {
    t -= phase;
  }
  if (t < restUs) {
    return reverse ? 1 : 0;
  }
  final double progress = ((t - restUs) / runUs).clamp(0.0, 1.0).toDouble();
  final double eased = curve.transform(progress);
  return reverse ? 1 - eased : eased;
}

/// The starting transform of an [AnimatedStyleTransition].
///
/// A zero/one value is a no-op: the transition only installs the transform
/// layers it needs, so a plain cross-fade allocates no extra render objects.
class AnimatedTransitionStyle {
  /// Creates a transition style.
  const AnimatedTransitionStyle({
    this.beginOffset = Offset.zero,
    this.beginScale = 1,
    this.beginRotation = 0,
    this.beginBlur = 0,
  });

  /// Translation at progress 0, in logical pixels; the child settles at
  /// [Offset.zero].
  final Offset beginOffset;

  /// Scale at progress 0; the child settles at 1.
  final double beginScale;

  /// Rotation at progress 0, in radians; the child settles at 0.
  final double beginRotation;

  /// Blur sigma at progress 0; the child settles at 0 (no blur).
  final double beginBlur;

  @override
  bool operator ==(Object other) {
    return other is AnimatedTransitionStyle &&
        other.beginOffset == beginOffset &&
        other.beginScale == beginScale &&
        other.beginRotation == beginRotation &&
        other.beginBlur == beginBlur;
  }

  @override
  int get hashCode =>
      Object.hash(beginOffset, beginScale, beginRotation, beginBlur);
}

/// Fades [child] in and transforms it from [style] to rest, driven by
/// [animation] and eased by [curve].
///
/// Used by carousel-style components: one transition widget covers the fade,
/// slide, scale, rotate and blur combinations without a per-style class.
class AnimatedStyleTransition extends StatelessWidget {
  /// Creates a style transition.
  const AnimatedStyleTransition({
    super.key,
    required this.animation,
    this.curve = Curves.easeOut,
    this.style = const AnimatedTransitionStyle(),
    required this.child,
  });

  /// Drives the transition; 0 is the start, 1 is at rest.
  final Animation<double> animation;

  /// Easing applied to [animation].
  final Curve curve;

  /// The starting transform.
  final AnimatedTransitionStyle style;

  /// The child that settles into place.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final Animation<double> curved = CurvedAnimation(
      parent: animation,
      curve: curve,
    );
    return FadeTransition(
      opacity: curved,
      child: AnimatedBuilder(
        animation: curved,
        child: child,
        builder: (BuildContext context, Widget? child) {
          final double t = 1 - curved.value;
          Widget result = child!;
          if (style.beginBlur > 0) {
            final double sigma = style.beginBlur * t;
            result = ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: sigma, sigmaY: sigma),
              child: result,
            );
          }
          if (style.beginRotation != 0) {
            result = Transform.rotate(
              angle: style.beginRotation * t,
              child: result,
            );
          }
          if (style.beginScale != 1) {
            result = Transform.scale(
              scale: 1 + (style.beginScale - 1) * t,
              child: result,
            );
          }
          if (style.beginOffset != Offset.zero) {
            result = Transform.translate(
              offset: style.beginOffset * t,
              child: result,
            );
          }
          return result;
        },
      ),
    );
  }
}
