// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../border_loading.dart';

/// Owns the unbounded animation timeline for border loading effects.
class _BorderLoadingController {
  /// Creates a timeline controller that advances continuously while animating.
  _BorderLoadingController({
    required TickerProvider vsync,
    required Duration duration,
  }) : _controller = AnimationController.unbounded(vsync: vsync, value: 0),
       _duration = duration;

  /// Underlying controller used as a time source.
  final AnimationController _controller;

  /// Current cycle duration used to derive cycles-per-second.
  Duration _duration;

  /// Read-only animation view used by widgets.
  Animation<double> get animation => _controller.view;

  /// Updates speed settings and reapplies simulation when already running.
  void updateTiming({required Duration duration}) {
    // Skip work when timing is unchanged.
    if (_duration == duration) return;
    // Persist the new duration.
    _duration = duration;
    // Restart simulation so speed changes apply immediately.
    if (_controller.isAnimating) {
      _startLinearSimulation();
    }
  }

  /// Starts or stops timeline progression.
  void sync({required bool animate}) {
    // Start loop when animation is requested.
    if (animate) {
      if (!_controller.isAnimating) {
        _startLinearSimulation();
      }
      return;
    }

    // Stop loop when animation is not requested.
    if (_controller.isAnimating) {
      _controller.stop();
    }
    // Reset to frame zero for deterministic non-loop rendering.
    if (_controller.value != 0) {
      _controller.value = 0;
    }
  }

  /// Disposes the underlying animation controller.
  void dispose() {
    _controller.dispose();
  }

  /// Starts an infinite linear simulation at the current timeline value.
  void _startLinearSimulation() {
    _controller.animateWith(
      _LinearBorderLoadingSimulation(
        initialValue: _controller.value,
        cyclesPerSecond: _cyclesPerSecond(_duration),
      ),
    );
  }

  /// Converts cycle duration into cycles per second.
  double _cyclesPerSecond(Duration duration) {
    final micros = duration.inMicroseconds;
    // Guard against zero/negative durations.
    if (micros <= 0) return 1.0;
    return 1000000 / micros;
  }
}

/// Infinite linear simulation used to avoid frame hitch at cycle boundaries.
class _LinearBorderLoadingSimulation extends Simulation {
  /// Creates a simulation with constant derivative.
  _LinearBorderLoadingSimulation({
    required this.initialValue,
    required this.cyclesPerSecond,
  });

  /// Starting timeline offset.
  final double initialValue;

  /// Constant speed in cycles/second.
  final double cyclesPerSecond;

  /// Returns timeline value at [time].
  @override
  double x(double time) => initialValue + (cyclesPerSecond * time);

  /// Returns constant derivative at [time].
  @override
  double dx(double time) => cyclesPerSecond;

  /// Never completes by design (infinite animation).
  @override
  bool isDone(double time) => false;
}
