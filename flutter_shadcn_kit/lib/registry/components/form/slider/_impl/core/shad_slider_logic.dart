// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'shad_slider_models.dart';

/// Geometry and interaction logic for the registry slider.
class ShadSliderLogic {
  /// Builds a render-state snapshot from configuration and current value.
  ///
  /// [thumbEdgeOffsetPx] controls horizontal thumb placement:
  /// - `0`: fully inside-track mapping
  /// - positive: pushes thumbs toward/outside edges
  /// - negative: pulls thumbs further inward
  ///
  /// [thumbVerticalOffsetPx] controls vertical thumb center offset:
  /// - positive: down
  /// - negative: up
  ShadSliderStateView buildView({
    required double min,
    required double max,
    required ShadSnap snap,
    required bool enabled,
    required Rect trackRect,
    required double trackRadius,
    required double thumbInset,
    required bool dragging,
    required int? activeThumb,
    required bool fillStopsAtThumbCenter,
    required double fillEdgeBiasPx,
    required double joinGapPx,
    required double thumbEdgeOffsetPx,
    required double thumbVerticalOffsetPx,
    required ShadSegmentLayout segmentLayout,
    required TextDirection textDirection,
    required double? value,
    required ShadRangeValue? rangeValue,
    required Size thumbSize,
  }) {
    final isRange = rangeValue != null;
    final baseInsideInset = math.max(thumbInset, thumbSize.width / 2);
    final centerInset = (baseInsideInset - thumbEdgeOffsetPx).clamp(
      0.0,
      trackRect.width / 2,
    );
    final minCenterX = trackRect.left + centerInset;
    final maxCenterX = trackRect.right - centerInset;
    final usableW = math.max(0.0, maxCenterX - minCenterX);

    double dxForT(double t) {
      if (textDirection == TextDirection.rtl) {
        return maxCenterX - usableW * t;
      }
      return minCenterX + usableW * t;
    }

    double tForValue(double v) {
      final range = max - min;
      if (range == 0) return 0;
      return ((v - min) / range).clamp(0.0, 1.0);
    }

    List<ShadThumbStateView> thumbs = [];
    double? tSingle;
    double? t0;
    double? t1;
    double? vSingle = value?.clamp(min, max);
    ShadRangeValue? rv = rangeValue;

    if (!isRange) {
      final v = vSingle ?? min;
      final t = tForValue(v);
      tSingle = t;
      const eps = 0.005;
      final nearMin = t <= eps;
      final nearMax = t >= 1.0 - eps;

      final rawCx = dxForT(t);
      final cx = nearMin
          ? minCenterX
          : nearMax
          ? maxCenterX
          : rawCx;
      final center = Offset(cx, trackRect.center.dy + thumbVerticalOffsetPx);

      thumbs = [
        ShadThumbStateView(
          index: 0,
          value: v,
          t: t,
          center: center,
          size: thumbSize,
          active: (activeThumb ?? 0) == 0 && dragging,
          enabled: enabled,
        ),
      ];
    } else {
      rv = _normalizeRange(rv!, min, max);
      final tStart = tForValue(rv.start);
      final tEnd = tForValue(rv.end);
      t0 = tStart;
      t1 = tEnd;
      const eps = 0.005;
      final leftAtMin = tStart <= eps;
      final rightAtMax = tEnd >= 1.0 - eps;

      final rawCx0 = dxForT(tStart);
      final rawCx1 = dxForT(tEnd);
      final cx0 = leftAtMin ? minCenterX : rawCx0;
      final cx1 = rightAtMax ? maxCenterX : rawCx1;

      thumbs = [
        ShadThumbStateView(
          index: 0,
          value: rv.start,
          t: tStart,
          center: Offset(cx0, trackRect.center.dy + thumbVerticalOffsetPx),
          size: thumbSize,
          active: activeThumb == 0 && dragging,
          enabled: enabled,
        ),
        ShadThumbStateView(
          index: 1,
          value: rv.end,
          t: tEnd,
          center: Offset(cx1, trackRect.center.dy + thumbVerticalOffsetPx),
          size: thumbSize,
          active: activeThumb == 1 && dragging,
          enabled: enabled,
        ),
      ];
    }

    final segments = segmentLayout.buildSegments(
      trackRect: trackRect,
      trackRadius: trackRadius,
      textDirection: textDirection,
      isRange: isRange,
      min: min,
      max: max,
      value: vSingle,
      rangeValue: rv,
      thumbs: thumbs,
    );

    Rect? firstOf(ShadSegmentKind kind) {
      for (final segment in segments) {
        if (segment.kind == kind) return segment.rect;
      }
      return null;
    }

    Rect? nthOf(ShadSegmentKind kind, int index) {
      var found = 0;
      for (final segment in segments) {
        if (segment.kind != kind) continue;
        if (found == index) return segment.rect;
        found++;
      }
      return null;
    }

    final activeRect = firstOf(ShadSegmentKind.fill);
    final remainingRect = isRange ? null : firstOf(ShadSegmentKind.remaining);
    final rangeRect = isRange ? firstOf(ShadSegmentKind.fill) : null;
    final leftGapRect = firstOf(ShadSegmentKind.gap);
    final rightGapRect = nthOf(ShadSegmentKind.gap, 1);
    final leftRemainingRect = isRange
        ? firstOf(ShadSegmentKind.remaining)
        : null;
    final rightRemainingRect = isRange
        ? nthOf(ShadSegmentKind.remaining, 1)
        : null;

    final marks = _defaultMarks(
      min: min,
      max: max,
      snap: snap,
      trackRect: trackRect,
      thumbInset: centerInset,
      textDirection: textDirection,
    );

    return ShadSliderStateView(
      min: min,
      max: max,
      enabled: enabled,
      dragging: dragging,
      activeThumb: activeThumb,
      textDirection: textDirection,
      trackRect: trackRect,
      trackRadius: trackRadius,
      thumbInset: centerInset,
      isRange: isRange,
      value: vSingle,
      rangeValue: rv,
      t: tSingle,
      t0: t0,
      t1: t1,
      activeRect: activeRect,
      remainingRect: remainingRect,
      rangeRect: rangeRect,
      leftGapRect: leftGapRect,
      rightGapRect: rightGapRect,
      leftRemainingRect: leftRemainingRect,
      rightRemainingRect: rightRemainingRect,
      segments: segments,
      thumbs: thumbs,
      marks: marks,
    );
  }

  ShadHitResult hitTest({
    required ShadSliderStateView view,
    required Offset localPosition,
  }) {
    if (!view.isRange) return const ShadHitResult(activeThumb: 0);
    return ShadHitResult(
      activeThumb: pickActiveThumb(view: view, dx: localPosition.dx),
    );
  }

  int pickActiveThumb({required ShadSliderStateView view, required double dx}) {
    if (!view.isRange) return 0;
    final d0 = (dx - view.thumbs[0].center.dx).abs();
    final d1 = (dx - view.thumbs[1].center.dx).abs();
    return d0 <= d1 ? 0 : 1;
  }

  /// Computes updated value/range for a pointer x-position.
  ShadUpdateResult updateFromDx({
    required ShadSliderStateView view,
    required ShadSnap snap,
    required double dx,
    required int thumbIndex,
  }) {
    final min = view.min;
    final max = view.max;

    final t = _dxToT(dx, view);
    final vRaw = _tToValue(t, min, max);
    final v = _applySnap(vRaw, snap, min, max);

    if (!view.isRange) return ShadUpdateResult(singleValue: v);

    final rv = view.rangeValue!;
    final start = rv.start;
    final end = rv.end;

    if (thumbIndex == 0) {
      double ns = v;
      double ne = end;
      if (!rv.allowSwap) {
        ns = math.min(ns, ne - rv.minRange);
      } else if (ns > ne) {
        ns = ne;
        ne = v;
      }
      return ShadUpdateResult(
        rangeValue: _normalizeRange(
          ShadRangeValue(
            ns,
            ne,
            minRange: rv.minRange,
            allowSwap: rv.allowSwap,
          ),
          min,
          max,
        ),
      );
    } else {
      double ns = start;
      double ne = v;
      if (!rv.allowSwap) {
        ne = math.max(ne, ns + rv.minRange);
      } else if (ne < ns) {
        ne = ns;
        ns = v;
      }
      return ShadUpdateResult(
        rangeValue: _normalizeRange(
          ShadRangeValue(
            ns,
            ne,
            minRange: rv.minRange,
            allowSwap: rv.allowSwap,
          ),
          min,
          max,
        ),
      );
    }
  }

  double _dxToT(double dx, ShadSliderStateView view) {
    final w = view.trackRect.width;
    final inset = view.thumbInset;
    final usableW = math.max(0.0, w - inset * 2);
    final x = view.textDirection == TextDirection.rtl ? (w - dx) : dx;
    if (usableW == 0) return 0;
    return ((x - inset) / usableW).clamp(0.0, 1.0);
  }

  double _tToValue(double t, double min, double max) => min + (max - min) * t;

  ShadRangeValue _normalizeRange(ShadRangeValue rv, double min, double max) {
    final s = rv.start.clamp(min, max);
    final e = rv.end.clamp(min, max);
    if (!rv.allowSwap) {
      final s2 = math.min(s, e);
      final e2 = math.max(e, s2 + rv.minRange).clamp(min, max);
      return rv.copyWith(start: s2, end: e2);
    }
    return rv.copyWith(start: s, end: e);
  }

  double _applySnap(double v, ShadSnap snap, double min, double max) {
    if (snap is ShadSnapNone) return v.clamp(min, max);
    if (snap is ShadSnapSteps) {
      final steps = snap.steps;
      if ((max - min).abs() < 1e-9) return min;
      final t = ((v - min) / (max - min)).clamp(0.0, 1.0);
      final qt = (t * steps).round() / steps;
      return (min + (max - min) * qt).clamp(min, max);
    }
    if (snap is ShadSnapValues) {
      double best = snap.values.first;
      double bd = (v - best).abs();
      for (final x in snap.values.skip(1)) {
        final d = (v - x).abs();
        if (d < bd) {
          bd = d;
          best = x;
        }
      }
      return best.clamp(min, max);
    }
    return v.clamp(min, max);
  }

  List<ShadMarkLayout> _defaultMarks({
    required double min,
    required double max,
    required ShadSnap snap,
    required Rect trackRect,
    required double thumbInset,
    required TextDirection textDirection,
  }) {
    final w = trackRect.width;
    final usableW = math.max(0.0, w - thumbInset * 2);

    double xForT(double t) {
      final x = thumbInset + usableW * t;
      return textDirection == TextDirection.rtl ? (w - x) : x;
    }

    if (snap is ShadSnapSteps) {
      final n = snap.steps;
      return List.generate(n + 1, (i) {
        final t = i / n;
        final v = min + (max - min) * t;
        return ShadMarkLayout(value: v, t: t, x: xForT(t));
      });
    }
    if (snap is ShadSnapValues) {
      final out = snap.values.map((v) {
        final t = ((v - min) / (max - min)).clamp(0.0, 1.0);
        return ShadMarkLayout(value: v, t: t, x: xForT(t));
      }).toList();
      out.sort((a, b) => a.t.compareTo(b.t));
      return out;
    }
    return const <ShadMarkLayout>[];
  }
}
