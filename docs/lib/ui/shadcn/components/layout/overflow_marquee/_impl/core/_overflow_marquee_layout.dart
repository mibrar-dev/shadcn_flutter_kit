// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../overflow_marquee.dart';

/// _OverflowMarqueeLayout defines a reusable type for this registry module.
class _OverflowMarqueeLayout extends SingleChildRenderObjectWidget {
  /// Stores `direction` state/configuration for this implementation.
  final Axis direction;

  /// Stores `fadePortion` state/configuration for this implementation.
  final double fadePortion;

  /// Stores `duration` state/configuration for this implementation.
  final Duration duration;

  /// Stores `delayDuration` state/configuration for this implementation.
  final Duration delayDuration;

  /// Stores `ticker` state/configuration for this implementation.
  final Ticker ticker;

  /// Stores `elapsed` state/configuration for this implementation.
  final Duration elapsed;

  /// Stores `step` state/configuration for this implementation.
  final double step;

  /// Stores `textDirection` state/configuration for this implementation.
  final TextDirection textDirection;

  /// Stores `curve` state/configuration for this implementation.
  final Curve curve;

  /// Creates a `_OverflowMarqueeLayout` instance.
  const _OverflowMarqueeLayout({
    required this.direction,
    this.fadePortion = 25,
    required this.duration,
    required this.delayDuration,
    required this.ticker,
    required this.elapsed,
    required this.step,
    required this.textDirection,
    required this.curve,
    required Widget child,
  }) : super(child: child);

  @override
  /// Executes `createRenderObject` behavior for this component/composite.
  RenderObject createRenderObject(BuildContext context) {
    return _RenderOverflowMarqueeLayout(
      direction: direction,
      fadePortion: fadePortion,
      duration: duration,
      delayDuration: delayDuration,
      ticker: ticker,
      step: step,
      elapsed: elapsed,
      textDirection: textDirection,
      curve: curve,
    );
  }

  @override
  void updateRenderObject(
    BuildContext context,
    _RenderOverflowMarqueeLayout renderObject,
  ) {
    /// Stores `hasChanged` state/configuration for this implementation.
    bool hasChanged = false;
    if (renderObject.direction != direction) {
      renderObject.direction = direction;
      hasChanged = true;
    }
    if (renderObject.fadePortion != fadePortion) {
      renderObject.fadePortion = fadePortion;
      hasChanged = true;
    }
    if (renderObject.duration != duration) {
      renderObject.duration = duration;
      hasChanged = true;
    }
    if (renderObject.delayDuration != delayDuration) {
      renderObject.delayDuration = delayDuration;
      hasChanged = true;
    }
    // most likely this will never change
    if (renderObject.ticker != ticker) {
      renderObject.ticker = ticker;
      hasChanged = true;
    }
    if (renderObject.elapsed != elapsed) {
      renderObject.elapsed = elapsed;
      hasChanged = true;
    }
    if (renderObject.step != step) {
      renderObject.step = step;
      hasChanged = true;
    }
    if (renderObject.textDirection != textDirection) {
      renderObject.textDirection = textDirection;
      hasChanged = true;
    }
    if (renderObject.curve != curve) {
      renderObject.curve = curve;
      hasChanged = true;
    }
    if (hasChanged) {
      renderObject.markNeedsLayout();
    }
  }
}
