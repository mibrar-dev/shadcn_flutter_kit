// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../timeline_animation.dart';

/// TimelineAnimation defines a reusable type for this registry module.
class TimelineAnimation<T> extends Animatable<T> {
  static T defaultLerp<T>(T a, T b, double t) {
    return ((a as dynamic) + ((b as dynamic) - (a as dynamic)) * t) as T;
  }

  /// Stores `lerp` state/configuration for this implementation.
  final PropertyLerp<T> lerp;

  /// Stores `totalDuration` state/configuration for this implementation.
  final Duration totalDuration;

  /// Stores `keyframes` state/configuration for this implementation.
  final List<Keyframe<T>> keyframes;

  /// Creates a `TimelineAnimation._` instance.
  TimelineAnimation._({
    required this.lerp,
    required this.totalDuration,
    required this.keyframes,
  });

  /// Factory constructor that creates `TimelineAnimation` instances.
  factory TimelineAnimation({
    PropertyLerp<T>? lerp,
    required List<Keyframe<T>> keyframes,
  }) {
    lerp ??= defaultLerp;
    assert(keyframes.isNotEmpty, 'No keyframes found');

    /// Stores `current` state/configuration for this implementation.
    Duration current = Duration.zero;
    for (final keyframe in keyframes) {
      assert(keyframe.duration.inMilliseconds > 0, 'Invalid duration');
      current += keyframe.duration;
    }
    return TimelineAnimation._(
      lerp: lerp,
      totalDuration: current,
      keyframes: keyframes,
    );
  }

  /// Executes `_computeDuration` behavior for this component/composite.
  Duration _computeDuration(double t) {
    return Duration(milliseconds: (t * totalDuration.inMilliseconds).floor());
  }

  /// Executes `drive` behavior for this component/composite.
  TimelineAnimatable<T> drive(AnimationController controller) {
    return TimelineAnimatable(controller.duration!, this);
  }

  /// Executes `transformWithController` behavior for this component/composite.
  T transformWithController(AnimationController controller) {
    return drive(controller).transform(controller.value);
  }

  /// Executes `withTotalDuration` behavior for this component/composite.
  TimelineAnimatable<T> withTotalDuration(Duration duration) {
    return TimelineAnimatable(duration, this);
  }

  @override
  /// Executes `transform` behavior for this component/composite.
  T transform(double t) {
    assert(t >= 0 && t <= 1, 'Invalid time $t');
    assert(keyframes.isNotEmpty, 'No keyframes found');
    final duration = _computeDuration(t);

    /// Stores `current` state/configuration for this implementation.
    var current = Duration.zero;
    for (var i = 0; i < keyframes.length; i++) {
      /// Stores `keyframe` state/configuration for this implementation.
      final keyframe = keyframes[i];

      /// Stores `next` state/configuration for this implementation.
      final next = current + keyframe.duration;
      if (duration < next) {
        final localT =
            (duration - current).inMilliseconds /
            keyframe.duration.inMilliseconds;
        return keyframe.compute(this, i, localT);
      }
      current = next;
    }
    return keyframes.last.compute(this, keyframes.length - 1, 1.0);
  }
}

/// Executes `_maxDuration` behavior for this component/composite.
Duration _maxDuration(Duration a, Duration b) => a > b ? a : b;

/// Returns the longest total duration among timelines.
Duration timelineMaxDuration(Iterable<TimelineAnimation> timelines) {
  /// Stores `max` state/configuration for this implementation.
  Duration max = Duration.zero;
  for (final timeline in timelines) {
    max = _maxDuration(max, timeline.totalDuration);
  }
  return max;
}
