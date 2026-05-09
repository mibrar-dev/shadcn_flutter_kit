// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:flutter/animation.dart';

/// A controlled animation that wraps an [AnimationController] and provides
/// smooth transitions between values using curves.
class ControlledAnimation extends Animation<double> {
  /// Stores `_controller` state/configuration for this implementation.
  final AnimationController _controller;

  ControlledAnimation(this._controller);

  /// Stores `_from` state/configuration for this implementation.
  double _from = 0;

  /// Stores `_to` state/configuration for this implementation.
  double _to = 1;

  /// Stores `_curve` state/configuration for this implementation.
  Curve _curve = Curves.linear;

  /// Animates from the current value to the specified target value.
  TickerFuture forward(double to, [Curve? curve]) {
    _from = value;
    _to = to;
    _curve = curve ?? Curves.linear;
    return _controller.forward(from: 0);
  }

  /// Executes `value` behavior for this component/composite.
  set value(double value) {
    _from = value;
    _to = value;
    _curve = Curves.linear;
    _controller.value = 0;
  }

  @override
  /// Executes `addListener` behavior for this component/composite.
  void addListener(VoidCallback listener) {
    _controller.addListener(listener);
  }

  @override
  /// Executes `addStatusListener` behavior for this component/composite.
  void addStatusListener(AnimationStatusListener listener) {
    _controller.addStatusListener(listener);
  }

  @override
  /// Executes `removeListener` behavior for this component/composite.
  void removeListener(VoidCallback listener) {
    _controller.removeListener(listener);
  }

  @override
  /// Executes `removeStatusListener` behavior for this component/composite.
  void removeStatusListener(AnimationStatusListener listener) {
    _controller.removeStatusListener(listener);
  }

  @override
  /// Stores `status` state/configuration for this implementation.
  AnimationStatus get status => _controller.status;

  @override
  double get value =>
      _from + (_to - _from) * _curve.transform(_controller.value);
}
