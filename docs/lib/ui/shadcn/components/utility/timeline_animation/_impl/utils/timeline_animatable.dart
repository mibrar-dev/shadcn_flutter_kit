// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../timeline_animation.dart';

/// TimelineAnimatable defines a reusable type for this registry module.
class TimelineAnimatable<T> extends Animatable<T> {
  /// Stores `duration` state/configuration for this implementation.
  final Duration duration;

  /// Stores `animation` state/configuration for this implementation.
  final TimelineAnimation<T> animation;

  TimelineAnimatable(this.duration, this.animation);

  @override
  /// Executes `transform` behavior for this component/composite.
  T transform(double t) {
    /// Stores `selfDuration` state/configuration for this implementation.
    final selfDuration = animation.totalDuration;
    final selfT = (t * selfDuration.inMilliseconds) / duration.inMilliseconds;
    return animation.transform(selfT);
  }
}

/// A timeline-based animation built from multiple keyframes.
