// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../animation_queue.dart';

/// AnimationQueueController defines a reusable type for this registry module.
class AnimationQueueController extends ChangeNotifier {
  /// Stores `_value` state/configuration for this implementation.
  double _value;

  /// Creates an animation queue controller with an optional initial value.
  AnimationQueueController([this._value = 0.0]);

  /// Stores `_requests` state/configuration for this implementation.
  List<AnimationRequest> _requests = [];

  /// Stores `_runner` state/configuration for this implementation.
  _AnimationRunner? _runner;

  /// Adds an animation request to the queue or replaces the current queue.
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

  /// Sets the current value immediately and clears queued animations.
  set value(double value) {
    _value = value;
    _runner = null;
    _requests.clear();
    notifyListeners();
  }

  /// Returns the current value.
  double get value => _value;

  /// Whether there are pending animations to tick.
  bool get shouldTick => _runner != null || _requests.isNotEmpty;

  /// Advances the animation by the given delta.
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

    /// Stores `runner` state/configuration for this implementation.
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
