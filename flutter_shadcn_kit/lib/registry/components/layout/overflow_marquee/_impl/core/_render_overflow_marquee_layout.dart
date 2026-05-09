// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../overflow_marquee.dart';

/// _RenderOverflowMarqueeLayout defines a reusable type for this registry module.
class _RenderOverflowMarqueeLayout extends RenderShiftedBox
    with ContainerRenderObjectMixin<RenderBox, _OverflowMarqueeParentData> {
  /// Stores `direction` state/configuration for this implementation.
  Axis direction;

  /// Stores `fadePortion` state/configuration for this implementation.
  double fadePortion;

  /// Stores `duration` state/configuration for this implementation.
  Duration duration;

  /// Stores `delayDuration` state/configuration for this implementation.
  Duration delayDuration;

  /// Stores `ticker` state/configuration for this implementation.
  Ticker ticker;

  /// Stores `elapsed` state/configuration for this implementation.
  Duration elapsed;

  /// Stores `step` state/configuration for this implementation.
  double step;

  /// Stores `textDirection` state/configuration for this implementation.
  TextDirection textDirection;

  /// Stores `curve` state/configuration for this implementation.
  Curve curve;

  /// Creates a `_RenderOverflowMarqueeLayout` instance.
  _RenderOverflowMarqueeLayout({
    required this.direction,
    required this.fadePortion,
    required this.duration,
    required this.delayDuration,
    required this.ticker,
    required this.elapsed,
    required this.step,
    required this.textDirection,
    required this.curve,
  }) : super(null);

  @override
  /// Executes `setupParentData` behavior for this component/composite.
  void setupParentData(RenderBox child) {
    if (child.parentData is! _OverflowMarqueeParentData) {
      child.parentData = _OverflowMarqueeParentData();
    }
  }

  @override
  /// Executes `computeMaxIntrinsicHeight` behavior for this component/composite.
  double computeMaxIntrinsicHeight(double width) {
    if (direction == Axis.horizontal) {
      return super.computeMaxIntrinsicHeight(double.infinity);
    }
    return super.computeMaxIntrinsicHeight(width);
  }

  @override
  /// Executes `computeMaxIntrinsicWidth` behavior for this component/composite.
  double computeMaxIntrinsicWidth(double height) {
    if (direction == Axis.vertical) {
      return super.computeMaxIntrinsicWidth(double.infinity);
    }
    return super.computeMaxIntrinsicWidth(height);
  }

  @override
  /// Executes `computeMinIntrinsicHeight` behavior for this component/composite.
  double computeMinIntrinsicHeight(double width) {
    if (direction == Axis.horizontal) {
      return super.computeMinIntrinsicHeight(double.infinity);
    }
    return super.computeMinIntrinsicHeight(width);
  }

  @override
  /// Executes `computeMinIntrinsicWidth` behavior for this component/composite.
  double computeMinIntrinsicWidth(double height) {
    if (direction == Axis.vertical) {
      return super.computeMinIntrinsicWidth(double.infinity);
    }
    return super.computeMinIntrinsicWidth(height);
  }

  @override
  /// Executes `computeDryLayout` behavior for this component/composite.
  Size computeDryLayout(covariant BoxConstraints constraints) {
    if (direction == Axis.horizontal) {
      constraints = constraints.copyWith(maxWidth: double.infinity);
    } else {
      constraints = constraints.copyWith(maxHeight: double.infinity);
    }

    /// Stores `child` state/configuration for this implementation.
    final child = this.child;
    if (child != null) {
      return child.getDryLayout(constraints);
    }
    return constraints.biggest;
  }

  @override
  /// Stores `layer` state/configuration for this implementation.
  ShaderMaskLayer? get layer => super.layer as ShaderMaskLayer?;

  @override
  /// Stores `alwaysNeedsCompositing` state/configuration for this implementation.
  bool get alwaysNeedsCompositing => child != null;

  double get offsetProgress {
    double durationInMicros =
        duration.inMicroseconds * ((sizeDiff ?? 0) / step);

    /// Stores `delayDurationInMicros` state/configuration for this implementation.
    int delayDurationInMicros = delayDuration.inMicroseconds;
    double elapsedInMicros = elapsed.inMicroseconds.toDouble();
    // includes the reverse
    double overalCycleDuration =
        delayDurationInMicros +
        durationInMicros +
        delayDurationInMicros +
        durationInMicros;
    elapsedInMicros = elapsedInMicros % overalCycleDuration;

    /// Stores `reverse` state/configuration for this implementation.
    bool reverse = elapsedInMicros > delayDurationInMicros + durationInMicros;
    double cycleElapsedInMicros =
        elapsedInMicros % (delayDurationInMicros + durationInMicros);
    if (cycleElapsedInMicros < delayDurationInMicros) {
      return reverse ? 1 : 0;
    } else if (cycleElapsedInMicros <
        delayDurationInMicros + durationInMicros) {
      double progress =
          (cycleElapsedInMicros - delayDurationInMicros) / durationInMicros;
      progress = curve.transform(progress);
      return reverse ? 1 - progress : progress;
    } else {
      return reverse ? 0 : 1;
    }
  }

  double? get sizeDiff {
    /// Stores `parentData` state/configuration for this implementation.
    final parentData = child?.parentData as _OverflowMarqueeParentData?;
    return parentData?.sizeDiff;
  }

  double get fadeStartProgress {
    /// Stores `child` state/configuration for this implementation.
    final child = this.child;
    if (child != null) {
      /// Stores `size` state/configuration for this implementation.
      double size = sizeDiff ?? 0;

      /// Stores `progressedSize` state/configuration for this implementation.
      double progressedSize = size * offsetProgress;
      return (progressedSize / fadePortion).clamp(0, 1);
    }
    return 0;
  }

  double get fadeEndProgress {
    /// Stores `child` state/configuration for this implementation.
    final child = this.child;
    if (child != null) {
      /// Stores `size` state/configuration for this implementation.
      double size = sizeDiff ?? 0;
      double progressedSize = size * (1 - offsetProgress);
      return (progressedSize / fadePortion).clamp(0, 1);
    }
    return 0;
  }

  Shader _createAlphaShader(
    bool fadeStart,
    bool fadeEnd,
    Rect bounds,
    double fadePortion,
  ) {
    /// Stores `portionSize` state/configuration for this implementation.
    double portionSize;
    if (direction == Axis.horizontal) {
      portionSize = fadePortion / bounds.width;
    } else {
      portionSize = fadePortion / bounds.height;
    }

    /// Stores `colors` state/configuration for this implementation.
    List<Color> colors = [];

    /// Stores `stops` state/configuration for this implementation.
    List<double> stops = [];
    if (fadeStart) {
      /// Stores `start` state/configuration for this implementation.
      double start = fadeStartProgress;
      Color startColor = Colors.white.withValues(alpha: 1 - start);
      colors.addAll([startColor, Colors.white]);
      stops.addAll([0.0, portionSize]);
    } else {
      colors.addAll([Colors.white]);
      stops.addAll([0.0]);
    }
    if (fadeEnd) {
      /// Stores `end` state/configuration for this implementation.
      double end = fadeEndProgress;
      Color endColor = Colors.white.withValues(alpha: 1 - end);
      colors.addAll([Colors.white, endColor]);
      stops.addAll([1.0 - portionSize, 1.0]);
    } else {
      colors.addAll([Colors.white]);
      stops.addAll([1.0]);
    }

    /// Stores `begin` state/configuration for this implementation.
    AlignmentGeometry begin;

    /// Stores `end` state/configuration for this implementation.
    AlignmentGeometry end;
    if (direction == Axis.horizontal) {
      begin = AlignmentDirectional.centerStart.resolve(textDirection);
      end = AlignmentDirectional.centerEnd.resolve(textDirection);
    } else {
      begin = Alignment.topCenter;
      end = Alignment.bottomCenter;
    }
    return LinearGradient(
      begin: begin,
      end: end,
      colors: colors,
      stops: stops,
    ).createShader(bounds);
  }

  @override
  /// Executes `paint` behavior for this component/composite.
  void paint(PaintingContext context, Offset offset) {
    /// Stores `child` state/configuration for this implementation.
    var child = this.child;
    if (child != null) {
      layer ??= ShaderMaskLayer();

      /// Stores `parentData` state/configuration for this implementation.
      final parentData = child.parentData as _OverflowMarqueeParentData;

      /// Stores `sizeDiff` state/configuration for this implementation.
      final sizeDiff = parentData.sizeDiff ?? 0;

      /// Stores `progress` state/configuration for this implementation.
      var progress = offsetProgress;
      Shader shader = _createAlphaShader(
        progress > 0 && sizeDiff != 0,
        progress < 1 && sizeDiff != 0,
        (Offset.zero & size),
        25,
      );
      assert(needsCompositing);
      layer!
        ..shader = shader
        ..maskRect = (offset & size).inflate(1)
        ..blendMode = BlendMode.modulate;
      context.pushLayer(layer!, _paintChild, offset);

      /// Creates a `assert` instance.
      assert(() {
        layer!.debugCreator = debugCreator;
        return true;
      }());
    } else {
      layer = null;
    }
  }

  /// Executes `_paintChild` behavior for this component/composite.
  void _paintChild(PaintingContext context, Offset offset) {
    /// Stores `child` state/configuration for this implementation.
    final child = this.child;
    if (child != null) {
      /// Stores `parentData` state/configuration for this implementation.
      final parentData = child.parentData as _OverflowMarqueeParentData;
      context.paintChild(child, offset + parentData.offset);
    }
  }

  @override
  /// Executes `performLayout` behavior for this component/composite.
  void performLayout() {
    /// Stores `child` state/configuration for this implementation.
    var child = this.child;
    if (child != null) {
      /// Stores `constraints` state/configuration for this implementation.
      var constraints = this.constraints;
      if (direction == Axis.horizontal) {
        constraints = constraints.copyWith(maxWidth: double.infinity);
      } else {
        constraints = constraints.copyWith(maxHeight: double.infinity);
      }
      child.layout(constraints, parentUsesSize: true);
      size = this.constraints.constrain(child.size);

      /// Stores `sizeDiff` state/configuration for this implementation.
      final sizeDiff = child.size.width - size.width;
      if (sizeDiff > 0 && size.width > 0 && size.height > 0) {
        if (!ticker.isActive) {
          ticker.start();
        }
      } else {
        if (ticker.isActive) {
          ticker.stop();
        }
      }

      /// Stores `progress` state/configuration for this implementation.
      var progress = offsetProgress;
      final offset = direction == Axis.horizontal
          ? Offset(-sizeDiff * progress, 0)
          : Offset(0, -sizeDiff * progress);

      /// Stores `parentData` state/configuration for this implementation.
      final parentData = child.parentData as _OverflowMarqueeParentData;
      parentData.sizeDiff = sizeDiff;
      parentData.offset = offset;
    } else {
      size = constraints.biggest;
      if (ticker.isActive) {
        ticker.stop();
      }
    }
  }
}
