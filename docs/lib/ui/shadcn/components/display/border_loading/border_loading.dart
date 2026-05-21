// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'dart:async';
import 'dart:math' as math;
import 'dart:ui' show PathMetric;

import 'package:flutter/painting.dart' show GradientRotation;
import 'package:flutter/physics.dart' show Simulation;
import 'package:flutter/widgets.dart';

// State and animation timeline helpers.
part '_impl/state/border_loading_controller.dart';

// Base full-outline painter.
part '_impl/core/border_loading_painter.dart';

// Determinate and tracer painter variants.
part '_impl/variants/border_progress_painter.dart';
part '_impl/variants/border_tracer_painter.dart';

// Utility helpers shared by all painters.
part '_impl/utils/gradient_adapter.dart';
part '_impl/utils/shape_path.dart';

/// Visual rendering mode for [BorderLoading].
enum BorderLoadingMode {
  /// Rotating border that loops forever.
  sweepGradient,

  /// One or more tracer segments that travel around the outline.
  tracer,

  /// Determinate mode for upload-style progress (`0.0 -> 1.0`).
  progress,

  /// Draws a complete, non-animated border.
  staticBorder,
}

/// Built-in gradient families supported by [BorderGradientSpec].
enum BorderGradientType { sweep, linear, radial }

/// Tracer segment settings when [BorderLoading.mode] is [BorderLoadingMode.tracer].
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

  /// Gap fraction used to clamp each segment inside its lane.
  final double gapFraction;

  /// Number of equally spaced tracer segments.
  final int dashCount;

  /// Whether segment ends should be rounded.
  final bool roundCaps;
}

/// Abstract shader spec for the border effect.
///
/// Extend this class if you need custom shader logic beyond [BorderGradientSpec].
@immutable
abstract class BorderLoadingSpec {
  /// Base constructor for all border shader specs.
  const BorderLoadingSpec();

  /// Creates a frame shader for the given border bounds and animation progress.
  Shader createShader({
    required Rect bounds,
    required double progress,
    required Path path,
  });
}

/// General-purpose border shader spec covering sweep, linear, and radial modes.
@immutable
class BorderGradientSpec extends BorderLoadingSpec {
  /// Creates a built-in gradient configuration with optional animation controls.
  const BorderGradientSpec({
    this.type = BorderGradientType.sweep,
    this.colors = _kDefaultColors,
    this.stops,
    this.gap = 0.22,
    this.rotateWithProgress = true,
    this.startAngle = -math.pi / 2,
    this.begin = Alignment.topLeft,
    this.end = Alignment.bottomRight,
    this.shiftWithProgress = false,
    this.center = Alignment.center,
    this.radius = 0.8,
    this.pulseWithProgress = false,
  });

  /// Default rainbow-like sweep palette used when no custom colors are provided.
  static const List<Color> _kDefaultColors = <Color>[
    Color(0x00000000),
    Color(0xFF3B82F6),
    Color(0xFF22C55E),
    Color(0xFFF59E0B),
    Color(0x00000000),
  ];

  /// Gradient family to render.
  final BorderGradientType type;

  /// Gradient colors used by the active family.
  final List<Color> colors;

  /// Optional stops for [colors].
  final List<double>? stops;

  /// Sweep-only: unpainted arc fraction (`0` = full ring).
  final double gap;

  /// Sweep-only: rotates the gradient over time.
  final bool rotateWithProgress;

  /// Sweep-only: start angle before runtime rotation.
  final double startAngle;

  /// Linear-only: gradient begin alignment.
  final Alignment begin;

  /// Linear-only: gradient end alignment.
  final Alignment end;

  /// Linear-only: small animated alignment drift.
  final bool shiftWithProgress;

  /// Radial-only: gradient center alignment.
  final Alignment center;

  /// Radial-only: base radius.
  final double radius;

  /// Radial-only: enables animated radius pulsing.
  final bool pulseWithProgress;

  /// Builds the frame shader by delegating to internal gradient helpers.
  @override
  Shader createShader({
    required Rect bounds,
    required double progress,
    required Path path,
  }) {
    return _createGradientShader(
      spec: this,
      bounds: bounds,
      progress: progress,
    );
  }
}

/// Wraps [child] and paints a configurable border effect around it.
class BorderLoading extends StatefulWidget {
  /// Creates a border loader/progress wrapper.
  const BorderLoading({
    super.key,
    required this.child,
    this.strokeWidth = 2.0,
    this.padding = const EdgeInsets.all(2),
    this.borderRadius = const BorderRadius.all(Radius.circular(12)),
    this.shapeBorder,
    this.mode = BorderLoadingMode.sweepGradient,
    this.progress = 0.0,
    this.progressStream,
    this.tracer = const BorderTracerSpec(),
    this.spec = const BorderGradientSpec(),
    this.duration = const Duration(milliseconds: 1200),
    this.curve = Curves.linear,
    this.backgroundColor,
    this.opacity = 1.0,
  }) : assert(strokeWidth >= 0, 'strokeWidth must be >= 0');

  /// The wrapped content.
  final Widget child;

  /// Outline stroke thickness.
  final double strokeWidth;

  /// Spacing between the painted border and [child].
  final EdgeInsets padding;

  /// Rounded-rect shape used when [shapeBorder] is null.
  final BorderRadius borderRadius;

  /// Optional shape override (circle/stadium/custom border).
  final ShapeBorder? shapeBorder;

  /// Rendering mode controlling animation/progress behavior.
  final BorderLoadingMode mode;

  /// Determinate progress used in [BorderLoadingMode.progress].
  final double progress;

  /// Optional progress stream used in [BorderLoadingMode.progress].
  ///
  /// When provided, stream values override [progress] as they arrive.
  final Stream<double>? progressStream;

  /// Tracer segment configuration used in tracer mode.
  final BorderTracerSpec tracer;

  /// Shader spec used by all painter variants.
  final BorderLoadingSpec spec;

  /// Cycle duration for looping modes.
  final Duration duration;

  /// Curve applied to normalized animation progress.
  final Curve curve;

  /// Optional fill painted behind the padded child.
  final Color? backgroundColor;

  /// Global stroke opacity multiplier.
  final double opacity;

  /// Creates the State object used by this border loading widget.
  @override
  State<BorderLoading> createState() => _BorderLoadingState();
}

/// Internal state that drives animation and chooses painter variants.
class _BorderLoadingState extends State<BorderLoading>
    with SingleTickerProviderStateMixin {
  /// Unbounded timeline controller used for continuous looping motion.
  late final _BorderLoadingController _loadingController;

  /// Stream subscription for determinate progress updates.
  StreamSubscription<double>? _progressStreamSubscription;

  /// Last progress value received from [BorderLoading.progressStream].
  double? _streamProgress;

  /// Returns true for looped animation modes.
  bool get _shouldAnimate =>
      widget.mode == BorderLoadingMode.sweepGradient ||
      widget.mode == BorderLoadingMode.tracer;

  /// Returns effective progress value for determinate mode.
  double get _effectiveProgress {
    final progress = _streamProgress ?? widget.progress;
    return progress.clamp(0.0, 1.0).toDouble();
  }

  /// Initializes controllers and listeners required by border loading.
  @override
  void initState() {
    super.initState();
    // Create the timeline driver once and keep it across rebuilds.
    _loadingController = _BorderLoadingController(
      vsync: this,
      duration: widget.duration,
    );
    // Start or stop based on the current mode.
    _loadingController.sync(animate: _shouldAnimate);
    // Subscribe to progress stream when provided.
    _bindProgressStream();
  }

  /// Updates internal state when border loading configuration changes.
  @override
  void didUpdateWidget(covariant BorderLoading oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update speed when duration changes.
    _loadingController.updateTiming(duration: widget.duration);
    // Keep controller running state aligned with current mode.
    _loadingController.sync(animate: _shouldAnimate);
    // Rebind when stream identity changes.
    if (oldWidget.progressStream != widget.progressStream) {
      _bindProgressStream();
    }
  }

  /// Disposes resources allocated by this border loading state.
  @override
  void dispose() {
    // Cancel stream subscription.
    _progressStreamSubscription?.cancel();
    // Dispose animation resources when widget is removed.
    _loadingController.dispose();
    super.dispose();
  }

  /// Subscribes to [BorderLoading.progressStream] and stores latest values.
  void _bindProgressStream() {
    _progressStreamSubscription?.cancel();
    _progressStreamSubscription = null;

    final stream = widget.progressStream;
    if (stream == null) {
      _streamProgress = null;
      return;
    }

    _streamProgress = widget.progress.clamp(0.0, 1.0).toDouble();
    _progressStreamSubscription = stream.listen((value) {
      final next = value.clamp(0.0, 1.0).toDouble();
      if (next == _streamProgress) return;
      if (!mounted) return;

      /// Implements `setState` behavior for border loading.
      setState(() {
        _streamProgress = next;
      });
    }, onError: (_) {});
  }

  /// Builds the widget tree for border loading.
  @override
  Widget build(BuildContext context) {
    // Resolve outer shape once for optional background painting.
    final shape = _resolveShapeBorder(
      shapeBorder: widget.shapeBorder,
      borderRadius: widget.borderRadius,
    );

    // Child is always wrapped with edge padding to avoid border overlap.
    Widget content = Padding(padding: widget.padding, child: widget.child);

    // Optional background fill that follows the resolved shape.
    if (widget.backgroundColor != null) {
      content = DecoratedBox(
        decoration: ShapeDecoration(
          color: widget.backgroundColor,
          shape: shape,
        ),
        child: content,
      );
    }

    // Early return when no stroke should be painted.
    if (widget.strokeWidth == 0) {
      return content;
    }

    // Builds the overlay painter for a given progress frame.
    /// Implements `buildOverlay` behavior for border loading.
    Widget buildOverlay(double progress) {
      // Select the correct painter variant for the active mode.
      final painter = switch (widget.mode) {
        BorderLoadingMode.tracer => _BorderTracerPainter(
          progress: progress,
          strokeWidth: widget.strokeWidth,
          borderRadius: widget.borderRadius,
          shapeBorder: widget.shapeBorder,
          opacity: widget.opacity,
          spec: widget.spec,
          tracer: widget.tracer,
        ),
        BorderLoadingMode.progress => _BorderProgressPainter(
          progress: _effectiveProgress,
          strokeWidth: widget.strokeWidth,
          borderRadius: widget.borderRadius,
          shapeBorder: widget.shapeBorder,
          opacity: widget.opacity,
          spec: widget.spec,
        ),
        BorderLoadingMode.staticBorder => _BorderLoadingPainter(
          progress: 0,
          strokeWidth: widget.strokeWidth,
          borderRadius: widget.borderRadius,
          shapeBorder: widget.shapeBorder,
          opacity: widget.opacity,
          spec: widget.spec,
        ),
        BorderLoadingMode.sweepGradient => _BorderLoadingPainter(
          progress: progress,
          strokeWidth: widget.strokeWidth,
          borderRadius: widget.borderRadius,
          shapeBorder: widget.shapeBorder,
          opacity: widget.opacity,
          spec: widget.spec,
        ),
      };

      // Paint above content while keeping pointer events on the child.
      return Positioned.fill(
        child: IgnorePointer(
          child: RepaintBoundary(child: CustomPaint(painter: painter)),
        ),
      );
    }

    // Looping modes listen to the timeline; non-looping modes use widget progress.
    final overlay = _shouldAnimate
        ? AnimatedBuilder(
            animation: _loadingController.animation,
            builder: (context, child) {
              // Convert unbounded timeline into [0,1) frame progress.
              final timeline = _loadingController.animation.value;
              final normalized = timeline - timeline.floorToDouble();
              // Apply optional easing curve.
              final progress = widget.curve.transform(normalized);
              return buildOverlay(progress);
            },
          )
        : buildOverlay(widget.curve.transform(widget.progress.clamp(0, 1)));

    // Compose child and border overlay.
    return RepaintBoundary(
      child: Stack(clipBehavior: Clip.none, children: [content, overlay]),
    );
  }
}
