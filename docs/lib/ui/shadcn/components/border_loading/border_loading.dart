// The `border_loading` component: an animated border (sweep gradient,
// tracers, determinate progress or a static ring) painted around the child.
// Widgets-only: one painter replaces the four `_impl` painters, the old
// unbounded controller + `Simulation` timeline is a plain repeating
// controller, and the default palette comes from tokens instead of rainbow hex.

import 'dart:async';
import 'dart:math' as math;
import 'dart:ui' show PathMetric;

import 'package:flutter/foundation.dart' show immutable;
import 'package:flutter/widgets.dart';

import '../../theme/color_tokens.dart';
import '../../theme/theme.dart';
import 'border_loading_style.dart';

export 'border_loading_style.dart';

/// Tracer segment settings for [BorderLoadingMode.tracer].
@immutable
class BorderTracerSpec {
  /// Creates tracer settings for moving dash segments.
  const BorderTracerSpec({
    this.lengthFraction = 0.18,
    this.gapFraction = 0.10,
    this.dashCount = 1,
    this.roundCaps = true,
  }) : assert(dashCount > 0, 'dashCount must be greater than zero');

  /// Segment length as a fraction of the total perimeter.
  final double lengthFraction;

  /// Gap fraction clamping each segment inside its lane.
  final double gapFraction;

  /// Number of equally spaced tracer segments.
  final int dashCount;

  /// Whether segment ends should be rounded.
  final bool roundCaps;
}

/// Wraps [child] and paints a configurable border effect around it:
/// `BorderLoading(mode: BorderLoadingMode.tracer, child: ...)`.
class BorderLoading extends StatefulWidget {
  const BorderLoading({
    super.key,
    required this.child,
    this.strokeWidth,
    this.padding,
    this.borderRadius,
    this.shapeBorder,
    this.mode,
    this.progress = 0.0,
    this.progressStream,
    this.tracer = const BorderTracerSpec(),
    this.spec = const BorderGradientSpec(),
    this.duration,
    this.curve,
    this.backgroundColor,
    this.opacity,
    this.theme,
  }) : assert(strokeWidth == null || strokeWidth >= 0);

  /// The wrapped content.
  final Widget child;

  /// Outline stroke thickness; null uses the theme, then `2`.
  final double? strokeWidth;

  /// Spacing between border and child; null uses `EdgeInsets.all(strokeWidth)`.
  final EdgeInsetsGeometry? padding;

  /// Rounded-rect shape used when [shapeBorder] is null; radius `12` default.
  final BorderRadiusGeometry? borderRadius;

  /// Optional shape override (circle/stadium/custom border).
  final ShapeBorder? shapeBorder;

  /// Rendering mode; null uses the theme, then `sweepGradient`.
  final BorderLoadingMode? mode;

  /// Determinate progress for [BorderLoadingMode.progress].
  final double progress;

  /// Optional progress source; stream values override [progress] (clamped).
  final Stream<double>? progressStream;

  /// Tracer segment configuration.
  final BorderTracerSpec tracer;

  /// Shader spec used by every mode.
  final BorderLoadingSpec spec;

  /// Cycle duration of the looping modes; null uses the theme, then 1200ms.
  final Duration? duration;

  /// Easing of normalized progress; null uses the theme, then linear.
  final Curve? curve;

  /// Fill painted behind the padded child; null uses the theme colour.
  final Color? backgroundColor;

  /// Global stroke opacity; null uses the theme, then `1`.
  final double? opacity;

  /// Widget-leg theme override, merged on top of the other legs.
  final BorderLoadingTheme? theme;

  @override
  State<BorderLoading> createState() => _BorderLoadingState();
}

class _BorderLoadingState extends State<BorderLoading>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  StreamSubscription<double>? _progressSubscription;
  double? _streamProgress;

  /// Loop modes drive the controller; the others paint a fixed frame.
  bool _looping = true;

  double get _effectiveProgress =>
      (_streamProgress ?? widget.progress).clamp(0.0, 1.0).toDouble();

  /// Whether [mode] animates.
  bool _isLooping(BorderLoadingMode? mode) =>
      mode == BorderLoadingMode.sweepGradient ||
      mode == BorderLoadingMode.tracer;

  @override
  void initState() {
    super.initState();
    _looping = _isLooping(widget.mode);
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration ?? const Duration(milliseconds: 1200),
    );
    _bindProgressStream();
  }

  @override
  void didUpdateWidget(covariant BorderLoading oldWidget) {
    super.didUpdateWidget(oldWidget);
    _sync(duration: widget.duration);
    if (oldWidget.progressStream != widget.progressStream) {
      _bindProgressStream();
    }
  }

  @override
  void dispose() {
    _progressSubscription?.cancel();
    _controller.dispose();
    super.dispose();
  }

  /// Keeps the controller's period and running state in line with the
  /// resolved duration and mode; a stopped controller never ticks, so the
  /// fixed modes do not rebuild.
  void _sync({Duration? duration, bool? looping}) {
    if (duration != null && _controller.duration != duration) {
      _controller.duration = duration;
      if (_controller.isAnimating) {
        _controller.stop();
      }
    }
    _looping = looping ?? _looping;
    if (_looping) {
      if (!_controller.isAnimating) _controller.repeat();
    } else if (_controller.isAnimating) {
      _controller.stop();
      _controller.value = 0;
    }
  }

  void _bindProgressStream() {
    _progressSubscription?.cancel();
    _progressSubscription = null;
    final Stream<double>? stream = widget.progressStream;
    if (stream == null) {
      _streamProgress = null;
      return;
    }
    _streamProgress = widget.progress.clamp(0.0, 1.0).toDouble();
    _progressSubscription = stream.listen((double value) {
      final double next = value.clamp(0.0, 1.0).toDouble();
      if (next == _streamProgress || !mounted) return;
      setState(() => _streamProgress = next);
    }, onError: (Object _) {});
  }

  @override
  Widget build(BuildContext context) {
    final BorderLoadingTheme style = resolveBorderLoadingStyle(
      context,
      widgetTheme: widget.theme,
      mode: widget.mode,
      strokeWidth: widget.strokeWidth,
      padding: widget.padding,
      borderRadius: widget.borderRadius,
      backgroundColor: widget.backgroundColor,
      duration: widget.duration,
      curve: widget.curve,
      opacity: widget.opacity,
    );
    _sync(duration: style.duration, looping: _isLooping(style.mode));
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    final BorderRadiusGeometry? geometry = style.borderRadius;
    final BorderRadius radius = geometry is BorderRadius
        ? geometry
        : geometry?.resolve(Directionality.of(context)) ?? BorderRadius.zero;
    final List<ThemedColor>? customColors = switch (widget.spec) {
      BorderGradientSpec spec => spec.colors,
      _ => null,
    };
    final List<Color> gradientColors =
        (customColors ?? borderLoadingGradientColors)
            .map((ThemedColor color) => color.resolve(theme.colors))
            .toList(growable: false);

    Widget content = Padding(padding: style.padding!, child: widget.child);
    if (style.backgroundColor != null) {
      content = DecoratedBox(
        decoration: ShapeDecoration(
          color: style.backgroundColor!.resolve(theme.colors),
          shape: _shape(style, radius),
        ),
        child: content,
      );
    }
    if (style.strokeWidth! == 0) return content;

    final _BorderPainter painter = _BorderPainter(
      style: style,
      shape: _shape(style, radius),
      spec: widget.spec,
      tracer: widget.tracer,
      colors: gradientColors,
      progress: style.curve!.transform(
        (_looping ? _controller.value : _effectiveProgress)
            .clamp(0.0, 1.0)
            .toDouble(),
      ),
    );
    final Widget frame = Positioned.fill(
      child: IgnorePointer(
        child: RepaintBoundary(child: CustomPaint(painter: painter)),
      ),
    );
    return RepaintBoundary(
      child: Stack(
        clipBehavior: Clip.none,
        children: <Widget>[
          content,
          AnimatedBuilder(
            animation: _controller,
            builder: (BuildContext context, Widget? child) => frame,
          ),
        ],
      ),
    );
  }

  ShapeBorder _shape(BorderLoadingTheme style, BorderRadius radius) =>
      widget.shapeBorder ?? RoundedRectangleBorder(borderRadius: radius);
}

/// Paints the border for one frame: the whole outline (sweep/static), the
/// leading segment (progress) or travelling dashes (tracer).
class _BorderPainter extends CustomPainter {
  const _BorderPainter({
    required this.style,
    required this.shape,
    required this.spec,
    required this.tracer,
    required this.colors,
    required this.progress,
  });

  /// Resolved style (stroke, opacity, mode).
  final BorderLoadingTheme style;

  /// Outline shape (its radius is part of `ShapeBorder` equality).
  final ShapeBorder shape;

  /// Shader specification and tracer settings.
  final BorderLoadingSpec spec;
  final BorderTracerSpec tracer;

  /// Resolved gradient colours and this frame's curve-applied progress.
  final List<Color> colors;
  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty || style.strokeWidth! <= 0) return;
    final double stroke = style.strokeWidth!;
    final Rect rect = (Offset.zero & size).deflate(stroke / 2);
    final Path path = shape.getOuterPath(rect);
    final List<PathMetric> metrics = path
        .computeMetrics(forceClosed: true)
        .toList(growable: false);
    final double total = metrics.fold<double>(
      0,
      (double sum, PathMetric metric) => sum + metric.length,
    );
    if (total <= 0) return;

    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..shader = spec.createShader(
        bounds: rect,
        progress: progress,
        colors: colors,
      );
    if (style.opacity! < 1) {
      paint.colorFilter = ColorFilter.mode(
        Color(0xFFFFFFFF).withValues(alpha: style.opacity!),
        BlendMode.modulate,
      );
    }

    switch (style.mode!) {
      case BorderLoadingMode.staticBorder:
      case BorderLoadingMode.sweepGradient:
        canvas.drawPath(path, paint);
      case BorderLoadingMode.progress:
        if (progress <= 0) return;
        paint.strokeCap = StrokeCap.round;
        canvas.drawPath(_slice(metrics, 0, total * progress, false), paint);
      case BorderLoadingMode.tracer:
        paint.strokeCap = tracer.roundCaps ? StrokeCap.round : StrokeCap.butt;
        final int dashes = tracer.dashCount.clamp(1, 64);
        final double gap = tracer.gapFraction.clamp(0.0, 0.95).toDouble();
        final double stride = total / dashes;
        final double segment = math.min(
          tracer.lengthFraction.clamp(0.0, 1.0).toDouble() * total,
          stride * (1 - gap),
        );
        if (segment <= 0) return;
        final double phase = (progress % 1.0) * total;
        for (int i = 0; i < dashes; i++) {
          canvas.drawPath(
            _slice(metrics, phase + i * stride, segment, true),
            paint,
          );
        }
    }
  }

  /// Extracts `length` of perimeter from `start`; [wrap] allows a wrap-around.
  Path _slice(
    List<PathMetric> metrics,
    double start,
    double length,
    bool wrap,
  ) {
    final Path out = Path();
    final double total = metrics.fold<double>(
      0,
      (double sum, PathMetric metric) => sum + metric.length,
    );
    if (length <= 0 || total <= 0) return out;
    double remaining = math.min(length, total);
    double cursor = start % total;
    for (int guard = 0; remaining > 0 && guard <= metrics.length; guard++) {
      double traversed = 0;
      int index = 0;
      for (int i = 0; i < metrics.length; i++) {
        if (cursor <= traversed + metrics[i].length) {
          index = i;
          break;
        }
        traversed += metrics[i].length;
      }
      final double local = cursor - traversed;
      final double available = metrics[index].length - local;
      if (available <= 0) break;
      final double take = math.min(available, remaining);
      out.addPath(metrics[index].extractPath(local, local + take), Offset.zero);
      remaining -= take;
      if (!wrap && cursor + take >= total) break;
      cursor = wrap ? (cursor + take) % total : cursor + take;
    }
    return out;
  }

  @override
  bool shouldRepaint(covariant _BorderPainter oldDelegate) =>
      oldDelegate.progress != progress ||
      oldDelegate.style != style ||
      oldDelegate.shape != shape ||
      oldDelegate.spec != spec ||
      oldDelegate.tracer != tracer ||
      !identical(oldDelegate.colors, colors);
}
