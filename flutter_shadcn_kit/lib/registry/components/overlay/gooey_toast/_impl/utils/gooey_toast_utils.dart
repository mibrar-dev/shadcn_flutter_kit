// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../gooey_toast.dart';

/// Resolves effective corner roundness based on selected [style].
double _roundnessForShape(double roundness, GooeyToastShapeStyle style) {
  return switch (style) {
    // Default aims for a smoother boarding-pass style silhouette.
    GooeyToastShapeStyle.defaultShape => roundness * 1.35,
    GooeyToastShapeStyle.soft => roundness * 1.6,
    GooeyToastShapeStyle.sharp => roundness * 0.9,
    GooeyToastShapeStyle.capsule => _kToastHeight / 2,
  };
}

/// Returns animation duration for each toast animation [style].
Duration _durationForAnimationStyle(GooeyToastAnimationStyle style) {
  return switch (style) {
    GooeyToastAnimationStyle.sileo => _kMorphDuration,
    GooeyToastAnimationStyle.smooth => const Duration(milliseconds: 760),
    GooeyToastAnimationStyle.snappy => const Duration(milliseconds: 420),
    GooeyToastAnimationStyle.bouncy => const Duration(milliseconds: 680),
    GooeyToastAnimationStyle.fluid => const Duration(milliseconds: 760),
    GooeyToastAnimationStyle.springEasing => const Duration(milliseconds: 600),
  };
}

/// Returns animation curve for each toast animation [style].
Curve _curveForAnimationStyle(GooeyToastAnimationStyle style) {
  return switch (style) {
    GooeyToastAnimationStyle.sileo => Curves.easeInOutCubic,
    GooeyToastAnimationStyle.smooth => Curves.easeInOutQuart,
    GooeyToastAnimationStyle.snappy => Curves.easeOutCubic,
    GooeyToastAnimationStyle.bouncy => Curves.elasticOut,
    GooeyToastAnimationStyle.fluid => const Cubic(0.20, 0.95, 0.20, 1.18),
    GooeyToastAnimationStyle.springEasing => const _SileoSpringEasingCurve(),
  };
}

/// Piecewise curve ported from the CSS `linear(...)` Sileo spring easing.
class _SileoSpringEasingCurve extends Curve {
  const _SileoSpringEasingCurve();

  static const List<Offset> _stops = <Offset>[
    Offset(0.0, 0.0),
    Offset(0.006, 0.002),
    Offset(0.012, 0.007),
    Offset(0.018, 0.015),
    Offset(0.024, 0.026),
    Offset(0.031, 0.041),
    Offset(0.038, 0.06),
    Offset(0.053, 0.108),
    Offset(0.066, 0.157),
    Offset(0.08, 0.214),
    Offset(0.137, 0.467),
    Offset(0.163, 0.577),
    Offset(0.177, 0.631),
    Offset(0.191, 0.682),
    Offset(0.205, 0.73),
    Offset(0.218, 0.771),
    Offset(0.231, 0.808),
    Offset(0.245, 0.844),
    Offset(0.258, 0.874),
    Offset(0.272, 0.903),
    Offset(0.286, 0.928),
    Offset(0.301, 0.952),
    Offset(0.316, 0.972),
    Offset(0.331, 0.988),
    Offset(0.357, 1.01),
    Offset(0.385, 1.025),
    Offset(0.416, 1.034),
    Offset(0.45, 1.038),
    Offset(0.501, 1.035),
    Offset(0.642, 1.012),
    Offset(0.73, 1.003),
    Offset(0.837, 0.999),
    Offset(1.0, 1.0),
  ];

  @override
  double transformInternal(double t) {
    if (t <= 0) return _stops.first.dy;
    if (t >= 1) return _stops.last.dy;
    for (var i = 1; i < _stops.length; i++) {
      final previous = _stops[i - 1];
      final current = _stops[i];
      if (t <= current.dx) {
        final span = current.dx - previous.dx;
        if (span <= 0) return current.dy;
        final localT = (t - previous.dx) / span;
        return lerpDouble(previous.dy, current.dy, localT) ?? current.dy;
      }
    }
    return _stops.last.dy;
  }
}

/// Resolves tone color for a toast [state], optionally from [theme] overrides.
Color _toneForState(GooeyToastState state, [GooeyToastTheme? theme]) {
  return switch (state) {
    GooeyToastState.success =>
      theme?.successTone ?? GooeyToastDefaults.successTone,
    GooeyToastState.loading =>
      theme?.loadingTone ?? GooeyToastDefaults.loadingTone,
    GooeyToastState.error => theme?.errorTone ?? GooeyToastDefaults.errorTone,
    GooeyToastState.warning =>
      theme?.warningTone ?? GooeyToastDefaults.warningTone,
    GooeyToastState.info => theme?.infoTone ?? GooeyToastDefaults.infoTone,
    GooeyToastState.action =>
      theme?.actionTone ?? GooeyToastDefaults.actionTone,
  };
}

/// Computes default swipe dismiss directions for [position] and [expandDirection].
Set<GooeyToastSwipeDirection> _defaultDismissDirections({
  required GooeyToastPosition position,
  required GooeyToastExpandDirection expandDirection,
}) {
  final directions = <GooeyToastSwipeDirection>{
    if (expandDirection == GooeyToastExpandDirection.bottom)
      GooeyToastSwipeDirection.up
    else
      GooeyToastSwipeDirection.down,
  };
  switch (position) {
    case GooeyToastPosition.left:
    case GooeyToastPosition.centerLeft:
      directions.add(GooeyToastSwipeDirection.left);
      break;
    case GooeyToastPosition.right:
    case GooeyToastPosition.centerRight:
      directions.add(GooeyToastSwipeDirection.right);
      break;
    case GooeyToastPosition.center:
      directions.addAll(const {
        GooeyToastSwipeDirection.left,
        GooeyToastSwipeDirection.right,
      });
      break;
  }
  return directions;
}
