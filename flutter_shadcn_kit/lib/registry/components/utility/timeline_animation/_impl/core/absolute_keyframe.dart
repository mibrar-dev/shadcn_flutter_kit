// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../timeline_animation.dart';

/// AbsoluteKeyframe defines a reusable type for this registry module.
class AbsoluteKeyframe<T> implements Keyframe<T> {
  /// Stores `from` state/configuration for this implementation.
  final T from;

  /// Stores `to` state/configuration for this implementation.
  final T to;
  @override
  /// Stores `duration` state/configuration for this implementation.
  final Duration duration;

  const AbsoluteKeyframe(this.duration, this.from, this.to);

  @override
  /// Executes `compute` behavior for this component/composite.
  T compute(TimelineAnimation<T> timeline, int index, double t) {
    return timeline.lerp(from, to, t) as T;
  }
}

/// Animates from the previous keyframe's end to [target].
