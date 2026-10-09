// Scroll-position math shared by the scroll components: scrollbar, scrollable,
// scrollable_client, scrollview, table and carousel.
//
// The old tree kept this math inline — `FadedScrollableViewport` recomputed
// edge fractions from every `ScrollNotification`, the 2D viewport clamped
// pixels by hand, and the scrollbar leaned on Flutter's `RawScrollbar`
// internals. This file owns the shared parts; `ScrollableClient*` stays in the
// `scrollable_client` component.

import 'dart:math' as math;

import 'package:flutter/widgets.dart';

/// Smallest thumb length (in logical pixels) a scrollbar thumb may shrink to.
const double kMinScrollbarThumbExtent = 48;

/// An immutable copy of the scroll position values scroll components need,
/// plus the values derived from them (progress, edge fractions, thumb
/// geometry).
class ScrollMetricsSnapshot {
  /// Creates a snapshot from explicit values.
  const ScrollMetricsSnapshot({
    required this.pixels,
    this.minScrollExtent = 0,
    required this.maxScrollExtent,
    required this.viewportDimension,
    this.axis = Axis.vertical,
    this.axisDirection = AxisDirection.down,
  });

  /// Reads a snapshot from a live [ScrollMetrics] (a scroll notification's).
  factory ScrollMetricsSnapshot.fromMetrics(ScrollMetrics metrics) {
    return ScrollMetricsSnapshot(
      pixels: metrics.pixels,
      minScrollExtent: metrics.minScrollExtent,
      maxScrollExtent: metrics.maxScrollExtent,
      viewportDimension: metrics.viewportDimension,
      axis: metrics.axis,
      axisDirection: metrics.axisDirection,
    );
  }

  /// Current scroll offset.
  final double pixels;

  /// Lower bound of [pixels].
  final double minScrollExtent;

  /// Upper bound of [pixels].
  final double maxScrollExtent;

  /// Size of the visible window.
  final double viewportDimension;

  /// Scroll axis.
  final Axis axis;

  /// Direction content moves when scrolling forward.
  final AxisDirection axisDirection;

  /// Total distance the position can travel, never negative.
  double get scrollableExtent => math.max(0, maxScrollExtent - minScrollExtent);

  /// Whether the content extends beyond the viewport.
  bool get canScroll => scrollableExtent > 0;

  /// Whether [pixels] sits at or before the leading edge.
  bool get atStart => pixels <= minScrollExtent;

  /// Whether [pixels] sits at or past the trailing edge.
  bool get atEnd => pixels >= maxScrollExtent;

  /// Whether the axis starts at the right/bottom ([AxisDirection.up] or
  /// [AxisDirection.left]).
  bool get reversed =>
      axisDirection == AxisDirection.up || axisDirection == AxisDirection.left;

  /// Position between the edges: 0 at [minScrollExtent], 1 at
  /// [maxScrollExtent]; 0 when there is nothing to scroll.
  double get progress {
    if (scrollableExtent <= 0) return 0;
    return ((pixels - minScrollExtent) / scrollableExtent).clamp(0.0, 1.0);
  }

  /// Signed distance outside the edges: negative before the start, positive
  /// past the end, zero while in range.
  double get overscrollPixels {
    if (pixels < minScrollExtent) return pixels - minScrollExtent;
    if (pixels > maxScrollExtent) return pixels - maxScrollExtent;
    return 0;
  }

  /// Leading fade strength: 0 at the leading edge, 1 once the position is
  /// [extent] past it. A non-positive [extent] yields 0.
  double leadingFadeFraction(double extent) =>
      _clampedFraction((pixels - minScrollExtent) / extent);

  /// Trailing fade strength: 0 at the trailing edge, 1 when the position is
  /// [extent] before it.
  double trailingFadeFraction(double extent) =>
      _clampedFraction((maxScrollExtent - pixels) / extent);

  /// Leading overscroll strength: 0 while in range, 1 when dragged [extent]
  /// before the leading edge.
  double leadingOverscrollFraction(double extent) =>
      _clampedFraction((minScrollExtent - pixels) / extent);

  /// Trailing overscroll strength: 0 while in range, 1 when dragged [extent]
  /// past the trailing edge.
  double trailingOverscrollFraction(double extent) =>
      _clampedFraction((pixels - maxScrollExtent) / extent);

  /// Length of a scrollbar thumb in a track [trackExtent] long.
  ///
  /// Reflects the visible fraction of the content and never shrinks below
  /// [minExtent] (itself capped at the track length).
  double thumbExtent(
    double trackExtent, {
    double minExtent = kMinScrollbarThumbExtent,
  }) {
    if (trackExtent <= 0) return 0;
    final contentExtent = scrollableExtent + viewportDimension;
    final visible = contentExtent <= 0
        ? 1.0
        : (viewportDimension / contentExtent).clamp(0.0, 1.0);
    return (trackExtent * visible).clamp(
      math.min(minExtent, trackExtent),
      trackExtent,
    );
  }

  /// Distance of the thumb from the leading edge of its track, between 0 and
  /// `trackExtent - thumbExtent`.
  ///
  /// [reversed] defaults to this snapshot's own orientation, which puts the
  /// thumb at the far end when the axis is reversed (up/left).
  double thumbOffset(double trackExtent, double thumbExtent, {bool? reversed}) {
    final movable = trackExtent - thumbExtent;
    if (movable <= 0) return 0;
    final fraction = (reversed ?? this.reversed) ? 1 - progress : progress;
    return fraction * movable;
  }

  /// Scroll offset that places the thumb [thumbOffset] from the leading edge;
  /// the inverse of [thumbOffset].
  double pixelsForThumbOffset({
    required double thumbOffset,
    required double trackExtent,
    required double thumbExtent,
  }) {
    final movable = trackExtent - thumbExtent;
    if (movable <= 0) return minScrollExtent;
    final fraction = (thumbOffset / movable).clamp(0.0, 1.0);
    final effective = reversed ? 1 - fraction : fraction;
    return minScrollExtent + effective * scrollableExtent;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ScrollMetricsSnapshot &&
        other.pixels == pixels &&
        other.minScrollExtent == minScrollExtent &&
        other.maxScrollExtent == maxScrollExtent &&
        other.viewportDimension == viewportDimension &&
        other.axis == axis &&
        other.axisDirection == axisDirection;
  }

  @override
  int get hashCode => Object.hash(
    pixels,
    minScrollExtent,
    maxScrollExtent,
    viewportDimension,
    axis,
    axisDirection,
  );

  @override
  String toString() =>
      'ScrollMetricsSnapshot($minScrollExtent..[$pixels]..$maxScrollExtent, '
      'viewport: $viewportDimension)';
}

/// Clamps [pixels] into `[minScrollExtent, maxScrollExtent]`; pass
/// [allowOverscroll] to keep the measured value (2D viewports toggle this per
/// axis).
double clampScrollPixels(
  double pixels, {
  required double minScrollExtent,
  required double maxScrollExtent,
  bool allowOverscroll = false,
}) {
  if (allowOverscroll) return pixels;
  if (!pixels.isFinite) return minScrollExtent;
  if (maxScrollExtent < minScrollExtent) return minScrollExtent;
  return pixels.clamp(minScrollExtent, maxScrollExtent);
}

/// Largest scrollable offset for content [contentExtent] long inside a
/// viewport [viewportExtent] long (0 when the content fits).
double maxScrollExtentFor({
  required double contentExtent,
  required double viewportExtent,
}) {
  return math.max(0, contentExtent - viewportExtent);
}

/// Clamps a `0..1` fraction, mapping non-finite inputs (a zero extent) to 0.
double _clampedFraction(double value) {
  if (!value.isFinite) return 0;
  return value.clamp(0.0, 1.0);
}
