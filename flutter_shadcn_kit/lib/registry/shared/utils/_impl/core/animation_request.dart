// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../animation_queue.dart';

/// AnimationRequest defines a reusable type for this registry module.
class AnimationRequest {
  /// The target value to animate to.
  final double target;

  /// The duration of the animation.
  final Duration duration;

  /// The easing curve to apply during the animation.
  final Curve curve;

  /// Creates an animation request with the specified parameters.
  AnimationRequest(this.target, this.duration, this.curve);
}
