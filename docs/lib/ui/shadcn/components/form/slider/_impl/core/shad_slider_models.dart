// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Builds the base track layer for the current slider state.
typedef ShadTrackBuilder =
    Widget Function(BuildContext context, ShadSliderStateView state);

/// Builds active/remaining fill layers for the current slider state.
typedef ShadFillBuilder =
    Widget Function(BuildContext context, ShadSliderStateView state);

/// Builds a single thumb widget from a thumb state snapshot.
typedef ShadThumbBuilder =
    Widget Function(BuildContext context, ShadThumbStateView thumb);

/// Builds ticks/marks layer.
typedef ShadTicksBuilder =
    Widget Function(BuildContext context, ShadSliderStateView state);

/// Builds optional overlay layer above thumbs.
typedef ShadOverlayBuilder =
    Widget Function(BuildContext context, ShadSliderStateView state);

/// Data payload for generic slider popover builders.
class ShadPopoverData {
  const ShadPopoverData({
    /// Denormalized value in active slider units.
    required this.value,

    /// Normalized progress in `[0..1]`.
    required this.normalizedValue,

    /// True while gesture drag is active.
    this.isDragging = false,

    /// Active thumb index when slider has multiple thumbs.
    this.thumbIndex,

    /// Full computed slider view when available.
    this.state,

    /// Active thumb snapshot when available.
    this.thumb,

    /// Arbitrary extension payload for custom slider variants.
    this.meta = const <String, Object?>{},
  });

  /// Denormalized value in the active slider domain.
  final double value;

  /// Normalized progress value in `[0..1]`.
  final double normalizedValue;

  /// Whether pointer drag is currently active.
  final bool isDragging;

  /// Active thumb index for range sliders.
  final int? thumbIndex;

  /// Full slider state when available (track/range sliders).
  final ShadSliderStateView? state;

  /// Active thumb state when available (track/range sliders).
  final ShadThumbStateView? thumb;

  /// Free-form extension map for future/custom slider metadata.
  final Map<String, Object?> meta;
}

/// Builds a popover for any slider variant.
typedef ShadPopoverBuilder =
    Widget Function(BuildContext context, ShadPopoverData data);

/// Controls when slider popovers are visible.
enum ShadPopoverVisibility {
  /// Never show popover.
  never,

  /// Show popover only while dragging/tapping.
  whileDragging,

  /// Keep popover visible even when idle.
  always,
}

/// Built-in popover shape options used by default helper builders.
enum ShadPopoverShape {
  /// Capsule-like rounded ends.
  pill,

  /// Medium rounded rectangle.
  rounded,

  /// Square rectangle with subtle corners.
  square,
}

/// Resolves per-segment style during segmented rendering.
typedef ShadSegmentStyleResolver =
    ShadSegmentStyle Function(
      BuildContext context,
      ShadSliderStateView view,
      ShadSegment segment,
    );

/// Declarative style for one rendered segment.
class ShadSegmentStyle {
  const ShadSegmentStyle({
    /// Flat fill color for this segment.
    this.color,

    /// Gradient fill; takes precedence over [color] when provided.
    this.gradient,

    /// Optional border stroke.
    this.border,

    /// Optional corner radius override.
    this.radius,

    /// Opacity multiplier in `[0..1]`.
    ///
    /// `1` keeps full alpha. `0` makes segment invisible.
    this.opacity,
  });

  final Color? color;
  final Gradient? gradient;
  final BoxBorder? border;
  final BorderRadius? radius;
  final double? opacity;
}

enum ShadSegmentKind { fill, remaining, gap, disabled, custom }

/// Immutable geometry + style metadata for one track segment.
class ShadSegment {
  const ShadSegment({
    /// Semantic role used by renderers to pick default styling.
    required this.kind,

    /// Segment rectangle in slider canvas coordinates.
    required this.rect,

    /// Optional radius override used by segmented renderers.
    this.radius,

    /// Paint stacking order; lower values paint first.
    this.paintOrder = 0,

    /// Arbitrary extension metadata for custom renderers.
    this.meta = const <String, Object?>{},
  });

  final ShadSegmentKind kind;
  final Rect rect;

  /// Optional radius override for this segment.
  final BorderRadius? radius;

  /// If you want to draw some things above others.
  final int paintOrder;

  /// Any extra info renderers may need.
  final Map<String, Object?> meta;
}

enum ShadGapEndsPolicy { always, noneAtMinMax, noneAlways }

enum ShadSegmentRadiusPolicy { fullPills, flatJoin, custom }

abstract class ShadSegmentLayout {
  const ShadSegmentLayout();

  /// Computes canonical segments for current slider geometry/state.
  ///
  /// Called during build after thumb centers are resolved. Implementations
  /// should return stable ordering via [ShadSegment.paintOrder].
  List<ShadSegment> buildSegments({
    required Rect trackRect,
    required double trackRadius,
    required TextDirection textDirection,
    required bool isRange,
    required double min,
    required double max,
    required double? value,
    required ShadRangeValue? rangeValue,
    required List<ShadThumbStateView> thumbs,
  });
}

class ShadContinuousLayout extends ShadSegmentLayout {
  const ShadContinuousLayout({
    /// Radius policy used for generated segments.
    this.segmentRadius = ShadSegmentRadiusPolicy.fullPills,
  });

  final ShadSegmentRadiusPolicy segmentRadius;

  @override
  List<ShadSegment> buildSegments({
    required Rect trackRect,
    required double trackRadius,
    required TextDirection textDirection,
    required bool isRange,
    required double min,
    required double max,
    required double? value,
    required ShadRangeValue? rangeValue,
    required List<ShadThumbStateView> thumbs,
  }) {
    if (thumbs.isEmpty) return const <ShadSegment>[];
    final segments = <ShadSegment>[];
    const eps = 0.0001;

    BorderRadius? radiusFor(Rect rect) {
      switch (segmentRadius) {
        case ShadSegmentRadiusPolicy.fullPills:
          return BorderRadius.circular(trackRadius);
        case ShadSegmentRadiusPolicy.flatJoin:
          final touchesLeft = (rect.left - trackRect.left).abs() <= eps;
          final touchesRight = (rect.right - trackRect.right).abs() <= eps;
          return BorderRadius.only(
            topLeft: Radius.circular(touchesLeft ? trackRadius : 0),
            bottomLeft: Radius.circular(touchesLeft ? trackRadius : 0),
            topRight: Radius.circular(touchesRight ? trackRadius : 0),
            bottomRight: Radius.circular(touchesRight ? trackRadius : 0),
          );
        case ShadSegmentRadiusPolicy.custom:
          return null;
      }
    }

    Rect rectFromX(double left, double right) {
      final l = left.clamp(trackRect.left, trackRect.right);
      final r = right.clamp(trackRect.left, trackRect.right);
      final x0 = l < r ? l : r;
      final x1 = l < r ? r : l;
      return Rect.fromLTWH(
        x0,
        trackRect.top,
        (x1 - x0).clamp(0.0, trackRect.width),
        trackRect.height,
      );
    }

    if (!isRange) {
      final cx = thumbs.first.center.dx.clamp(trackRect.left, trackRect.right);
      late final Rect fillRect;
      late final Rect remRect;
      if (textDirection == TextDirection.rtl) {
        fillRect = rectFromX(cx, trackRect.right);
        remRect = rectFromX(trackRect.left, cx);
      } else {
        fillRect = rectFromX(trackRect.left, cx);
        remRect = rectFromX(cx, trackRect.right);
      }

      if (fillRect.width > eps) {
        segments.add(
          ShadSegment(
            kind: ShadSegmentKind.fill,
            rect: fillRect,
            radius: radiusFor(fillRect),
            paintOrder: 1,
          ),
        );
      }
      if (remRect.width > eps) {
        segments.add(
          ShadSegment(
            kind: ShadSegmentKind.remaining,
            rect: remRect,
            radius: radiusFor(remRect),
            paintOrder: 3,
          ),
        );
      }
      return segments;
    }

    final cx0 = thumbs[0].center.dx;
    final cx1 = thumbs[1].center.dx;
    final left = math.min(cx0, cx1).clamp(trackRect.left, trackRect.right);
    final right = math.max(cx0, cx1).clamp(trackRect.left, trackRect.right);

    final leftRem = rectFromX(trackRect.left, left);
    final fillRect = rectFromX(left, right);
    final rightRem = rectFromX(right, trackRect.right);

    if (leftRem.width > eps) {
      segments.add(
        ShadSegment(
          kind: ShadSegmentKind.remaining,
          rect: leftRem,
          radius: radiusFor(leftRem),
          paintOrder: 0,
        ),
      );
    }
    if (fillRect.width > eps) {
      segments.add(
        ShadSegment(
          kind: ShadSegmentKind.fill,
          rect: fillRect,
          radius: radiusFor(fillRect),
          paintOrder: 2,
        ),
      );
    }
    if (rightRem.width > eps) {
      segments.add(
        ShadSegment(
          kind: ShadSegmentKind.remaining,
          rect: rightRem,
          radius: radiusFor(rightRem),
          paintOrder: 4,
        ),
      );
    }
    return segments;
  }
}

class ShadJoinGapLayout extends ShadSegmentLayout {
  const ShadJoinGapLayout({
    /// Gap size around thumb centers.
    ///
    /// `0` removes gaps. Positive values create visible joins.
    this.gapPx = 6,

    /// How gaps behave at min/max edges.
    this.endsPolicy = ShadGapEndsPolicy.noneAtMinMax,

    /// Radius policy used for generated segments.
    this.segmentRadius = ShadSegmentRadiusPolicy.fullPills,
  });

  /// Gap size around thumb centers.
  final double gapPx;

  /// Edge-gap behavior policy.
  final ShadGapEndsPolicy endsPolicy;

  /// Segment radius strategy.
  final ShadSegmentRadiusPolicy segmentRadius;

  @override
  List<ShadSegment> buildSegments({
    required Rect trackRect,
    required double trackRadius,
    required TextDirection textDirection,
    required bool isRange,
    required double min,
    required double max,
    required double? value,
    required ShadRangeValue? rangeValue,
    required List<ShadThumbStateView> thumbs,
  }) {
    if (thumbs.isEmpty) return const <ShadSegment>[];
    // Use a practical epsilon so values that visually render as 100%/0%
    // don't leave a tiny tail due to floating-point drift.
    const eps = 0.005;
    final range = (max - min).abs() < eps ? 1.0 : (max - min);
    final segments = <ShadSegment>[];

    Rect rectFromX(double left, double right) {
      final l = left.clamp(trackRect.left, trackRect.right);
      final r = right.clamp(trackRect.left, trackRect.right);
      final x0 = l < r ? l : r;
      final x1 = l < r ? r : l;
      return Rect.fromLTWH(
        x0,
        trackRect.top,
        (x1 - x0).clamp(0.0, trackRect.width),
        trackRect.height,
      );
    }

    BorderRadius? radiusFor(Rect rect) {
      switch (segmentRadius) {
        case ShadSegmentRadiusPolicy.fullPills:
          return BorderRadius.circular(trackRadius);
        case ShadSegmentRadiusPolicy.flatJoin:
          final touchesLeft = (rect.left - trackRect.left).abs() <= eps;
          final touchesRight = (rect.right - trackRect.right).abs() <= eps;
          return BorderRadius.only(
            topLeft: Radius.circular(touchesLeft ? trackRadius : 0),
            bottomLeft: Radius.circular(touchesLeft ? trackRadius : 0),
            topRight: Radius.circular(touchesRight ? trackRadius : 0),
            bottomRight: Radius.circular(touchesRight ? trackRadius : 0),
          );
        case ShadSegmentRadiusPolicy.custom:
          return null;
      }
    }

    double effectiveGap(bool atEdge) {
      switch (endsPolicy) {
        case ShadGapEndsPolicy.always:
          return gapPx;
        case ShadGapEndsPolicy.noneAlways:
          return 0.0;
        case ShadGapEndsPolicy.noneAtMinMax:
          return atEdge ? 0.0 : gapPx;
      }
    }

    if (!isRange) {
      final v = value ?? min;
      final t = ((v - min) / range).clamp(0.0, 1.0);
      final atMin = t <= eps;
      final atMax = t >= 1.0 - eps;
      final cx = thumbs.first.center.dx.clamp(trackRect.left, trackRect.right);
      final isRtl = textDirection == TextDirection.rtl;
      final gap = effectiveGap(atMin || atMax);

      // At min/max, snap segment boundaries to track edges instead of thumb
      // center so no residual tail/gap appears at ends.
      final edgeX = isRtl
          ? (atMin
                ? trackRect.right
                : atMax
                ? trackRect.left
                : cx)
          : (atMin
                ? trackRect.left
                : atMax
                ? trackRect.right
                : cx);
      final anchor = (atMin || atMax) ? edgeX : cx;
      final gapHalf = gap / 2;
      final gapL = (anchor - gapHalf).clamp(trackRect.left, trackRect.right);
      final gapR = (anchor + gapHalf).clamp(trackRect.left, trackRect.right);

      late final Rect fillRect;
      late final Rect remRect;
      if (textDirection == TextDirection.rtl) {
        fillRect = rectFromX(gapR, trackRect.right);
        remRect = rectFromX(trackRect.left, gapL);
      } else {
        fillRect = rectFromX(trackRect.left, gapL);
        remRect = rectFromX(gapR, trackRect.right);
      }
      final gapRect = rectFromX(gapL, gapR);

      if (fillRect.width > eps) {
        segments.add(
          ShadSegment(
            kind: ShadSegmentKind.fill,
            rect: fillRect,
            radius: radiusFor(fillRect),
            paintOrder: 1,
          ),
        );
      }
      if (gapRect.width > eps) {
        segments.add(
          ShadSegment(
            kind: ShadSegmentKind.gap,
            rect: gapRect,
            radius: radiusFor(gapRect),
            paintOrder: 2,
          ),
        );
      }
      if (remRect.width > eps) {
        segments.add(
          ShadSegment(
            kind: ShadSegmentKind.remaining,
            rect: remRect,
            radius: radiusFor(remRect),
            paintOrder: 3,
          ),
        );
      }
      return segments;
    }

    final rv = rangeValue ?? ShadRangeValue(min, max);
    final startT = ((rv.start - min) / range).clamp(0.0, 1.0);
    final endT = ((rv.end - min) / range).clamp(0.0, 1.0);
    final leftAtMin = startT <= eps;
    final rightAtMax = endT >= 1.0 - eps;
    final cx0 = thumbs[0].center.dx;
    final cx1 = thumbs[1].center.dx;
    final leftCx = math.min(cx0, cx1).clamp(trackRect.left, trackRect.right);
    final rightCx = math.max(cx0, cx1).clamp(trackRect.left, trackRect.right);

    final gapLeft = effectiveGap(leftAtMin);
    final gapRight = effectiveGap(rightAtMax);
    final isRtl = textDirection == TextDirection.rtl;
    final leftGapAnchor = (isRtl && rightAtMax) || (!isRtl && leftAtMin)
        ? trackRect.left
        : leftCx;
    final rightGapAnchor = (isRtl && leftAtMin) || (!isRtl && rightAtMax)
        ? trackRect.right
        : rightCx;
    final g0L = (leftGapAnchor - gapLeft / 2).clamp(
      trackRect.left,
      trackRect.right,
    );
    final g0R = (leftGapAnchor + gapLeft / 2).clamp(
      trackRect.left,
      trackRect.right,
    );
    final g1L = (rightGapAnchor - gapRight / 2).clamp(
      trackRect.left,
      trackRect.right,
    );
    final g1R = (rightGapAnchor + gapRight / 2).clamp(
      trackRect.left,
      trackRect.right,
    );

    final leftRem = rectFromX(trackRect.left, g0L);
    final leftGap = rectFromX(g0L, g0R);
    final fillRect = rectFromX(g0R, g1L);
    final rightGap = rectFromX(g1L, g1R);
    final rightRem = rectFromX(g1R, trackRect.right);

    if (leftRem.width > eps) {
      segments.add(
        ShadSegment(
          kind: ShadSegmentKind.remaining,
          rect: leftRem,
          radius: radiusFor(leftRem),
          paintOrder: 0,
        ),
      );
    }
    if (leftGap.width > eps) {
      segments.add(
        ShadSegment(
          kind: ShadSegmentKind.gap,
          rect: leftGap,
          radius: radiusFor(leftGap),
          paintOrder: 1,
        ),
      );
    }
    if (fillRect.width > eps) {
      segments.add(
        ShadSegment(
          kind: ShadSegmentKind.fill,
          rect: fillRect,
          radius: radiusFor(fillRect),
          paintOrder: 2,
        ),
      );
    }
    if (rightGap.width > eps) {
      segments.add(
        ShadSegment(
          kind: ShadSegmentKind.gap,
          rect: rightGap,
          radius: radiusFor(rightGap),
          paintOrder: 3,
        ),
      );
    }
    if (rightRem.width > eps) {
      segments.add(
        ShadSegment(
          kind: ShadSegmentKind.remaining,
          rect: rightRem,
          radius: radiusFor(rightRem),
          paintOrder: 4,
        ),
      );
    }
    return segments;
  }
}

/// Defines snapping behavior for slider values.
sealed class ShadSnap {
  const ShadSnap();

  /// Continuous mode without quantization.
  const factory ShadSnap.none() = ShadSnapNone;

  /// Quantizes values into evenly spaced steps.
  const factory ShadSnap.steps(int steps) = ShadSnapSteps;

  /// Quantizes values to nearest explicit value entry.
  const factory ShadSnap.values(List<double> values) = ShadSnapValues;
}

class ShadSnapNone extends ShadSnap {
  const ShadSnapNone();
}

/// Snap to equally-spaced steps in `[min, max]`.
class ShadSnapSteps extends ShadSnap {
  /// Step count for equal-interval snapping.
  ///
  /// Must be greater than `0` (asserted).
  const ShadSnapSteps(this.steps) : assert(steps > 0);

  /// Number of equal intervals across `[min, max]`.
  final int steps;
}

class ShadSnapValues extends ShadSnap {
  /// Explicit values used for nearest-value snapping.
  const ShadSnapValues(this.values);

  /// Candidate values. Empty lists disable effective snapping.
  final List<double> values;
}

/// Value model for range sliders.
class ShadRangeValue {
  const ShadRangeValue(
    /// Start value for range selection.
    this.start,

    /// End value for range selection.
    this.end, {

    /// Minimum allowed distance between start and end.
    ///
    /// `0` allows touching thumbs.
    this.minRange = 0,

    /// Whether thumbs may cross and swap order while dragging.
    this.allowSwap = false,
  });

  /// Start value for range selection.
  final double start;

  /// End value for range selection.
  final double end;

  /// Minimum start/end distance.
  final double minRange;

  /// Whether thumbs may cross/swap while dragging.
  final bool allowSwap;

  /// Returns a copy with provided overrides.
  ShadRangeValue copyWith({
    /// Replacement for [start]. Null keeps current value.
    double? start,

    /// Replacement for [end]. Null keeps current value.
    double? end,

    /// Replacement for [minRange]. Null keeps current value.
    double? minRange,

    /// Replacement for [allowSwap]. Null keeps current value.
    bool? allowSwap,
  }) {
    return ShadRangeValue(
      start ?? this.start,
      end ?? this.end,
      minRange: minRange ?? this.minRange,
      allowSwap: allowSwap ?? this.allowSwap,
    );
  }
}

class ShadSliderStateView {
  const ShadSliderStateView({
    /// Lower bound of slider domain.
    required this.min,

    /// Upper bound of slider domain.
    required this.max,

    /// Whether interactions are enabled.
    required this.enabled,

    /// Whether drag gesture is active.
    required this.dragging,

    /// Active thumb index if currently resolved.
    required this.activeThumb,

    /// Layout direction used for segment orientation.
    required this.textDirection,

    /// Effective track rect in slider canvas.
    required this.trackRect,

    /// Effective track corner radius.
    required this.trackRadius,

    /// Effective thumb inset used for mapping.
    required this.thumbInset,

    /// Whether this state represents a range slider.
    required this.isRange,

    /// Single value if in single mode.
    required this.value,

    /// Range value if in range mode.
    required this.rangeValue,

    /// Normalized single value in `[0..1]`.
    required this.t,

    /// Normalized range start in `[0..1]`.
    required this.t0,

    /// Normalized range end in `[0..1]`.
    required this.t1,

    /// Single-mode active segment rect.
    required this.activeRect,

    /// Single-mode remaining segment rect.
    required this.remainingRect,

    /// Range-mode selected segment rect.
    required this.rangeRect,

    /// Gap rect around single/left thumb.
    required this.leftGapRect,

    /// Gap rect around right thumb in range mode.
    required this.rightGapRect,

    /// Left remaining range-mode segment.
    required this.leftRemainingRect,

    /// Right remaining range-mode segment.
    required this.rightRemainingRect,

    /// Canonical segment list for renderers.
    required this.segments,

    /// Computed thumb snapshots.
    required this.thumbs,

    /// Computed mark/tick layouts.
    required this.marks,
  });

  /// Lower domain bound.
  final double min;

  /// Upper domain bound.
  final double max;

  /// Whether interactions are enabled.
  final bool enabled;

  /// Whether drag gesture is active.
  final bool dragging;

  /// Active thumb index when dragging.
  final int? activeThumb;

  /// Layout direction used for geometry.
  final TextDirection textDirection;

  /// Track layout rect in the slider canvas.
  final Rect trackRect;

  /// Track corner radius used by renderers.
  final double trackRadius;

  /// Effective horizontal inset used by value<->pixel mapping.
  final double thumbInset;

  /// Whether this state is for range mode.
  final bool isRange;

  /// Single value in single mode.
  final double? value;

  /// Range value in range mode.
  final ShadRangeValue? rangeValue;

  /// Normalized single value in `[0..1]`.
  final double? t;

  /// Normalized range start in `[0..1]`.
  final double? t0;

  /// Normalized range end in `[0..1]`.
  final double? t1;

  /// Single-value active segment.
  final Rect? activeRect;

  /// Single-value remaining segment.
  final Rect? remainingRect;

  /// Selected segment for range sliders.
  final Rect? rangeRect;

  /// Gap around left/single thumb.
  final Rect? leftGapRect;

  /// Gap around right thumb in range mode.
  final Rect? rightGapRect;

  /// Left remaining segment in range mode.
  final Rect? leftRemainingRect;

  /// Right remaining segment in range mode.
  final Rect? rightRemainingRect;

  /// Canonical segment model for rendering.
  final List<ShadSegment> segments;

  /// Computed thumb snapshots for rendering/hit testing.
  final List<ShadThumbStateView> thumbs;

  /// Computed mark/tick layout entries.
  final List<ShadMarkLayout> marks;
}

/// Immutable layout/state snapshot for one thumb.
class ShadThumbStateView {
  const ShadThumbStateView({
    /// Thumb index in rendering order.
    required this.index,

    /// Denormalized thumb value.
    required this.value,

    /// Normalized thumb value in `[0..1]`.
    required this.t,

    /// Thumb center in canvas coordinates.
    required this.center,

    /// Thumb layout size.
    required this.size,

    /// Whether this thumb is currently active.
    required this.active,

    /// Whether slider is enabled.
    required this.enabled,
  });

  /// Thumb index in rendering order.
  final int index;

  /// Denormalized thumb value.
  final double value;

  /// Normalized value in `[0..1]`.
  final double t;

  /// Thumb center point in slider canvas coordinates.
  final Offset center;

  /// Logical size used for layout and gesture hit area.
  final Size size;

  /// Whether this thumb is currently active.
  final bool active;

  /// Whether slider interactions are enabled.
  final bool enabled;
}

/// Mark/tick layout entry.
class ShadMarkLayout {
  const ShadMarkLayout({
    /// Denormalized mark value.
    required this.value,

    /// Normalized mark value in `[0..1]`.
    required this.t,

    /// Horizontal canvas position.
    required this.x,

    /// Optional text label rendered by custom ticks.
    this.label,

    /// Whether mark should be treated as major.
    this.isMajor = true,
  });

  /// Denormalized mark value.
  final double value;

  /// Normalized value in `[0..1]`.
  final double t;

  /// Horizontal position in canvas coordinates.
  final double x;

  /// Optional label.
  final String? label;

  /// Major/minor flag for custom tick styling.
  final bool isMajor;
}

/// Output model for drag/tap update calculations.
class ShadUpdateResult {
  const ShadUpdateResult({
    /// Resolved single value when single mode updates.
    this.singleValue,

    /// Resolved range value when range mode updates.
    this.rangeValue,
  });

  /// Resolved single value output.
  final double? singleValue;

  /// Resolved range value output.
  final ShadRangeValue? rangeValue;
}

/// Output model for hit-testing which thumb is active.
class ShadHitResult {
  const ShadHitResult({
    /// Thumb index selected by hit testing.
    required this.activeThumb,
  });

  /// Thumb index selected by hit testing.
  final int? activeThumb;
}
