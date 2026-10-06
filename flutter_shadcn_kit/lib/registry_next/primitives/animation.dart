// Small animation helpers: a repeating value builder and a value-mapped
// animation facade over an [AnimationController].
//
// Ported from `shared/utils/_impl/core/repeated_animation_builder.dart`,
// `_impl/state/__repeated_animation_builder_state.dart` and
// `shared/utils/controlled_animation.dart`.

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
