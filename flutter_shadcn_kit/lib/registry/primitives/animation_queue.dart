// A queue-driven animation controller: requests are played in order and the
// progress value can be advanced with a tick delta.
//
// Ported from `shared/utils/animation_queue.dart` + `_impl/**`.

import 'package:flutter/widgets.dart';

/// A single queued animation target.
class AnimationRequest {
  /// The target value to animate to.
  final double target;

  /// Duration of the animation.
  final Duration duration;

  /// Curve applied during the animation.
  final Curve curve;

  /// Creates an animation request.
  AnimationRequest(this.target, this.duration, this.curve);
}

class _AnimationRunner {
  final double from;
  final double to;
  final Duration duration;
  final Curve curve;
  double _progress = 0.0;

  _AnimationRunner(this.from, this.to, this.duration, this.curve);
}

/// Plays [AnimationRequest]s in order and exposes the current value.
///
/// `push(request)` queues (or replaces, when `queue` is false) a request;
/// `tick(delta)` advances the current animation by [delta].
class AnimationQueueController extends ChangeNotifier {
  double _value;
  List<AnimationRequest> _requests = [];
  _AnimationRunner? _runner;

  /// Creates a controller with an optional [initialValue].
  AnimationQueueController([this._value = 0.0]);

  /// Adds [request] to the queue, or replaces the queue when [queue] is
  /// false.
  void push(AnimationRequest request, [bool queue = true]) {
    if (queue) {
      _requests.add(request);
    } else {
      _runner = null;
      _requests = [request];
    }
    _runner ??= _AnimationRunner(
      _value,
      request.target,
      request.duration,
      request.curve,
    );
    notifyListeners();
  }

  /// Sets the value immediately and clears queued animations.
  set value(double value) {
    _value = value;
    _runner = null;
    _requests.clear();
    notifyListeners();
  }

  /// The current value.
  double get value => _value;

  /// Whether there are pending animations to tick.
  bool get shouldTick => _runner != null || _requests.isNotEmpty;

  /// Advances the animation by [delta].
  void tick(Duration delta) {
    if (_requests.isNotEmpty) {
      final request = _requests.removeAt(0);
      _runner = _AnimationRunner(
        _value,
        request.target,
        request.duration,
        request.curve,
      );
    }
    final runner = _runner;
    if (runner != null) {
      runner._progress += delta.inMilliseconds / runner.duration.inMilliseconds;
      _value =
          runner.from +
          (runner.to - runner.from) *
              runner.curve.transform(runner._progress.clamp(0, 1));
      if (runner._progress >= 1.0) {
        _runner = null;
      }
      notifyListeners();
    }
  }
}
