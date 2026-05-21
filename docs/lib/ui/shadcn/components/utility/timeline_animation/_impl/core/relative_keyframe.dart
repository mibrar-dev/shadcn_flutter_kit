// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../timeline_animation.dart';

/// RelativeKeyframe defines a reusable type for this registry module.
class RelativeKeyframe<T> implements Keyframe<T> {
  /// Stores `target` state/configuration for this implementation.
  final T target;
  @override
  /// Stores `duration` state/configuration for this implementation.
  final Duration duration;

  const RelativeKeyframe(this.duration, this.target);

  @override
  /// Executes `compute` behavior for this component/composite.
  T compute(TimelineAnimation<T> timeline, int index, double t) {
    if (index <= 0) {
      return target;
    }
    final previous = timeline.keyframes[index - 1].compute(
      timeline,
      index - 1,
      1.0,
    );
    return timeline.lerp(previous, target, t) as T;
  }
}

/// Holds a value without animating.
