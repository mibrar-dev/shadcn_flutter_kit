// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../timeline_animation.dart';

/// StillKeyframe defines a reusable type for this registry module.
class StillKeyframe<T> implements Keyframe<T> {
  /// Stores `value` state/configuration for this implementation.
  final T? value;
  @override
  /// Stores `duration` state/configuration for this implementation.
  final Duration duration;

  const StillKeyframe(this.duration, [this.value]);

  @override
  /// Executes `compute` behavior for this component/composite.
  T compute(TimelineAnimation<T> timeline, int index, double t) {
    /// Stores `resolved` state/configuration for this implementation.
    var resolved = value;
    if (resolved == null) {
      assert(
        index > 0,
        'Relative still keyframe must have a previous keyframe',
      );
      resolved = timeline.keyframes[index - 1].compute(
        timeline,
        index - 1,
        1.0,
      );
    }
    return resolved as T;
  }
}

/// Binds a timeline to an explicit duration.
