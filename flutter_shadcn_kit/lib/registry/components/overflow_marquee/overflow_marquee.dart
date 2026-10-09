// The `overflow_marquee` component: self-scrolling content with soft edge
// fades. Fixes over the old copy: no Material import (the fade used
// `Colors.white`), the vertical axis measured its overflow on `width`,
// `fadePortion` was ignored by the painter (hardcoded 25px) while documented
// as a 0..1 fraction, every tick rebuilt the subtree, and RTL never reversed
// the scroll.

import 'dart:math' as math;
import 'dart:ui' show BlendMode, Shader;

import 'package:flutter/foundation.dart' show ValueListenable, ValueNotifier;
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';

import '../../primitives/animation.dart';
import 'overflow_marquee_style.dart';

export 'overflow_marquee_style.dart';

/// Identity modulator: multiplying by opaque white leaves content alone.
const Color _kWhite = Color(0xFFFFFFFF);

/// Scrolls [child] along [direction] when it overflows its container and
/// stays still when it fits. The scroll ping-pongs — rest, one run of the
/// overflow, rest, back — with fades at both clipped edges; under reduced
/// motion (`MediaQuery.disableAnimations`) the content holds its position.
class OverflowMarquee extends StatefulWidget {
  /// Creates a marquee.
  const OverflowMarquee({
    super.key,
    required this.child,
    this.direction,
    this.duration,
    this.delayDuration,
    this.step,
    this.fadePortion,
    this.curve,
    this.theme,
  });

  /// Content to scroll.
  final Widget child;

  /// Scroll axis; null uses the theme, then `Axis.horizontal`.
  final Axis? direction;

  /// Time one run of [step] pixels takes; a run scales with the overflow.
  final Duration? duration;

  /// Pause at each end of a run.
  final Duration? delayDuration;

  /// Pixels covered per [duration].
  final double? step;

  /// Fade width per edge as a fraction of the visible extent (`0..0.5`).
  final double? fadePortion;

  /// Easing of each run.
  final Curve? curve;

  /// Widget-leg theme override, merged on top of the other legs.
  final OverflowMarqueeTheme? theme;

  @override
  State<OverflowMarquee> createState() => _OverflowMarqueeState();
}

class _OverflowMarqueeState extends State<OverflowMarquee>
    with SingleTickerProviderStateMixin {
  /// Elapsed scroll time: a notifier, so a tick never rebuilds the subtree.
  late final ValueNotifier<Duration> _elapsed = ValueNotifier<Duration>(
    Duration.zero,
  );

  late final Ticker _ticker;

  @override
  void initState() {
    super.initState();
    _ticker = createTicker((Duration elapsed) => _elapsed.value = elapsed);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final bool reduced =
        MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    if (reduced) {
      _ticker.stop();
      _elapsed.value = Duration.zero;
    } else if (!_ticker.isActive) {
      _ticker.start();
    }
  }

  @override
  void dispose() {
    _ticker.dispose();
    _elapsed.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final MarqueeSurface surface = resolveMarqueeSurface(
      context,
      widgetTheme: widget.theme,
      direction: widget.direction,
      duration: widget.duration,
      delayDuration: widget.delayDuration,
      step: widget.step,
      fadePortion: widget.fadePortion,
      curve: widget.curve,
    );
    return ClipRect(
      child: _MarqueeLayout(
        direction: surface.direction,
        duration: surface.duration,
        delayDuration: surface.delayDuration,
        step: surface.step,
        fadePortion: surface.fadePortion,
        curve: surface.curve,
        elapsed: _elapsed,
        textDirection: Directionality.of(context),
        child: widget.child,
      ),
    );
  }
}

/// Hosts the marquee render object.
class _MarqueeLayout extends SingleChildRenderObjectWidget {
  const _MarqueeLayout({
    required this.direction,
    required this.duration,
    required this.delayDuration,
    required this.step,
    required this.fadePortion,
    required this.curve,
    required this.elapsed,
    required this.textDirection,
    required super.child,
  });

  final Axis direction;
  final Duration duration;
  final Duration delayDuration;
  final double step;
  final double fadePortion;
  final Curve curve;
  final ValueListenable<Duration> elapsed;
  final TextDirection textDirection;

  @override
  _RenderMarquee createRenderObject(BuildContext context) {
    return _RenderMarquee(
      direction: direction,
      duration: duration,
      delayDuration: delayDuration,
      step: step,
      fadePortion: fadePortion,
      curve: curve,
      elapsed: elapsed,
      textDirection: textDirection,
    );
  }

  @override
  void updateRenderObject(BuildContext context, _RenderMarquee renderObject) {
    final bool geometryChanged =
        renderObject.direction != direction ||
        renderObject.step != step ||
        renderObject.duration != duration ||
        renderObject.delayDuration != delayDuration;
    renderObject
      ..direction = direction
      ..duration = duration
      ..delayDuration = delayDuration
      ..step = step
      ..fadePortion = fadePortion
      ..curve = curve
      ..textDirection = textDirection
      ..elapsed = elapsed;
    geometryChanged
        ? renderObject.markNeedsLayout()
        : renderObject.markNeedsPaint();
  }
}

/// Lays the child out at its natural size, clips to the constraints and
/// paints it translated by the scroll offset behind an edge-fade shader.
class _RenderMarquee extends RenderShiftedBox {
  _RenderMarquee({
    required this.direction,
    required this.duration,
    required this.delayDuration,
    required this.step,
    required this.fadePortion,
    required this.curve,
    required TextDirection textDirection,
    required ValueListenable<Duration> elapsed,
  }) : _textDirection = textDirection,
       _elapsed = elapsed,
       super(null);

  Axis direction;
  Duration duration;
  Duration delayDuration;
  double step;
  double fadePortion;
  Curve curve;
  TextDirection _textDirection;
  ValueListenable<Duration> _elapsed;

  double _overflow = 0;

  set textDirection(TextDirection value) {
    if (value == _textDirection) return;
    _textDirection = value;
    // The scroll offset lives in the child's parent data.
    markNeedsLayout();
  }

  /// Elapsed scroll time; re-subscribes the paint listener on change.
  set elapsed(ValueListenable<Duration> value) {
    if (identical(value, _elapsed)) return;
    if (attached) {
      _elapsed.removeListener(_onTick);
    }
    _elapsed = value;
    if (attached) {
      _elapsed.addListener(_onTick);
    }
    markNeedsPaint();
  }

  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);
    _elapsed.addListener(_onTick);
  }

  @override
  void detach() {
    _elapsed.removeListener(_onTick);
    super.detach();
  }

  void _onTick() {
    // The scroll offset lives in the child's parent data, so a tick relayouts
    // (cheap: this render object is the relayout boundary and the child's
    // constraints do not change). That keeps hit tests, transforms and
    // semantics aligned with what is painted.
    if (_overflow > 0) markNeedsLayout();
  }

  @override
  bool get alwaysNeedsCompositing => child != null;

  @override
  void performLayout() {
    final RenderBox? child = this.child;
    if (child == null) {
      _overflow = 0;
      size = constraints.smallest;
      return;
    }
    child.layout(_childConstraints(constraints), parentUsesSize: true);
    size = constraints.constrain(child.size);
    final double childExtent = direction == Axis.horizontal
        ? child.size.width
        : child.size.height;
    final double ownExtent = direction == Axis.horizontal
        ? size.width
        : size.height;
    _overflow = math.max(0, childExtent - ownExtent);
    (child.parentData! as BoxParentData).offset = _scroll(_progress);
  }

  @override
  Size computeDryLayout(covariant BoxConstraints constraints) {
    final RenderBox? child = this.child;
    return child == null
        ? constraints.smallest
        : constraints.constrain(
            child.getDryLayout(_childConstraints(constraints)),
          );
  }

  /// The child measures along its main axis without any container bound.
  BoxConstraints _childConstraints(BoxConstraints c) =>
      direction == Axis.horizontal
      ? c.copyWith(minWidth: 0, maxWidth: double.infinity)
      : c.copyWith(minHeight: 0, maxHeight: double.infinity);

  @override
  double computeMinIntrinsicWidth(double height) => direction == Axis.vertical
      ? super.computeMinIntrinsicWidth(height)
      : super.computeMinIntrinsicWidth(double.infinity);
  @override
  double computeMaxIntrinsicWidth(double height) => direction == Axis.vertical
      ? super.computeMaxIntrinsicWidth(height)
      : super.computeMaxIntrinsicWidth(double.infinity);
  @override
  double computeMinIntrinsicHeight(double width) => direction == Axis.horizontal
      ? super.computeMinIntrinsicHeight(double.infinity)
      : super.computeMinIntrinsicHeight(width);
  @override
  double computeMaxIntrinsicHeight(double width) => direction == Axis.horizontal
      ? super.computeMaxIntrinsicHeight(double.infinity)
      : super.computeMaxIntrinsicHeight(width);

  /// Normalized scroll position: rest, run forward, rest, run back. A run
  /// covers the whole overflow in `duration` for every `step` pixels.
  double get _progress {
    final int runUs = (duration.inMicroseconds * (_overflow / step)).round();
    if (_overflow <= 0 || runUs <= 0) {
      return 0;
    }
    return pingPongProgress(
      elapsed: _elapsed.value,
      run: Duration(microseconds: runUs),
      rest: delayDuration,
      curve: curve,
    );
  }

  /// Scroll translation for [progress]; RTL starts against the end edge.
  Offset _scroll(double progress) {
    final double extent = _overflow * progress;
    if (direction == Axis.horizontal) {
      final bool rtl = _textDirection == TextDirection.rtl;
      return Offset(rtl ? extent - _overflow : -extent, 0);
    }
    return Offset(0, -extent);
  }

  /// Edge fade over the visible bounds; identity when nothing scrolls.
  Shader _shader(Rect bounds) {
    final double portion = fadePortion.clamp(0.0, 0.5);
    if (_overflow <= 0 || portion <= 0) {
      return const LinearGradient(
        colors: <Color>[_kWhite, _kWhite],
      ).createShader(bounds);
    }
    final (Alignment begin, Alignment end) = direction == Axis.horizontal
        ? (
            AlignmentDirectional.centerStart.resolve(_textDirection),
            AlignmentDirectional.centerEnd.resolve(_textDirection),
          )
        : (Alignment.topCenter, Alignment.bottomCenter);
    return LinearGradient(
      begin: begin,
      end: end,
      colors: const <Color>[
        Color(0x00FFFFFF),
        _kWhite,
        _kWhite,
        Color(0x00FFFFFF),
      ],
      stops: <double>[0, portion, 1 - portion, 1],
    ).createShader(bounds);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final RenderBox? child = this.child;
    if (child == null) return;
    final ShaderMaskLayer fade =
        (layer as ShaderMaskLayer?) ?? ShaderMaskLayer();
    layer = fade;
    fade
      ..shader = _shader(offset & size)
      ..maskRect = offset & size
      ..blendMode = BlendMode.modulate;
    context.pushLayer(fade, _paintChild, offset);
  }

  void _paintChild(PaintingContext context, Offset offset) {
    final RenderBox? child = this.child;
    if (child != null) {
      context.paintChild(
        child,
        offset + (child.parentData! as BoxParentData).offset,
      );
    }
  }
}
