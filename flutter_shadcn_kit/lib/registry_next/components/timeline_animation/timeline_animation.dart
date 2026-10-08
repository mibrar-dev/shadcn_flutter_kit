// The `timeline_animation` component: a typed keyframe timeline that turns an
// [AnimationController]'s progress into a value (`Color`, `Offset`, `double`,
// …) segment by segment.
//
// Distinct from the neighbouring animation machinery, all of which do a
// different job: `primitives/animation.dart` repeats a scalar range,
// `primitives/animation_queue.dart` plays queued scalar tweens, and the old
// `repeated_animation_builder` never carried typed keyframes. No widget is
// exported here — the timeline is an [Animatable] you drive from any
// controller.

import 'package:flutter/widgets.dart';

/// Interpolates between two values of type [T].
///
/// Return null to leave a segment un-interpolated (for example a colour that
/// cannot be lerped).
typedef PropertyLerp<T> = T? Function(T? a, T? b, double t);

/// One segment of a [TimelineAnimation].
abstract class Keyframe<T> {
  /// How long this segment takes.
  Duration get duration;

  /// The value at [t] inside this segment; `t` is `0..1` within the segment.
  T compute(TimelineAnimation<T> timeline, int index, double t);
}

/// Animates between explicit [from] and [to] values.
class AbsoluteKeyframe<T> implements Keyframe<T> {
  /// Creates an absolute segment: `from` -> `to` over [duration].
  const AbsoluteKeyframe(this.duration, this.from, this.to);

  /// Segment start value.
  final T from;

  /// Segment end value.
  final T to;

  @override
  final Duration duration;

  @override
  T compute(TimelineAnimation<T> timeline, int index, double t) {
    return timeline.lerp(from, to, t) as T;
  }
}

/// Animates from the previous segment's end value to [target].
class RelativeKeyframe<T> implements Keyframe<T> {
  /// Creates a relative segment ending at [target].
  const RelativeKeyframe(this.duration, this.target);

  /// Segment end value; the start is the previous segment's end.
  final T target;

  @override
  final Duration duration;

  @override
  T compute(TimelineAnimation<T> timeline, int index, double t) {
    if (index <= 0) {
      return target;
    }
    final T previous = timeline.keyframes[index - 1].compute(
      timeline,
      index - 1,
      1.0,
    );
    return timeline.lerp(previous, target, t) as T;
  }
}

/// Holds [value] — or, when omitted, the previous segment's end value — for
/// [duration].
class StillKeyframe<T> implements Keyframe<T> {
  /// Creates a holding segment.
  const StillKeyframe(this.duration, [this.value]);

  /// Value to hold. Null means "hold whatever the previous segment ended at".
  final T? value;

  @override
  final Duration duration;

  @override
  T compute(TimelineAnimation<T> timeline, int index, double t) {
    final T? resolved = value;
    if (resolved != null) {
      return resolved;
    }
    if (index <= 0) {
      throw StateError(
        'StillKeyframe without a value needs a previous keyframe to hold, '
        'but it is the first segment of the timeline.',
      );
    }
    return timeline.keyframes[index - 1].compute(timeline, index - 1, 1.0);
  }
}

/// A keyframe timeline bound to a total duration.
///
/// ```dart
/// final timeline = TimelineAnimation<double>(keyframes: [
///   AbsoluteKeyframe(const Duration(milliseconds: 200), 0.0, 1.0),
///   StillKeyframe(const Duration(milliseconds: 100)),
///   RelativeKeyframe(const Duration(milliseconds: 300), 0.0),
/// ]);
/// ```
class TimelineAnimation<T> extends Animatable<T> {
  TimelineAnimation._({
    required this.lerp,
    required this.totalDuration,
    required this.keyframes,
  });

  /// Builds a timeline from [keyframes]; every segment must be positive.
  factory TimelineAnimation({
    PropertyLerp<T>? lerp,
    required List<Keyframe<T>> keyframes,
  }) {
    if (keyframes.isEmpty) {
      throw ArgumentError.value(keyframes, 'keyframes', 'No keyframes found');
    }
    Duration total = Duration.zero;
    for (final Keyframe<T> keyframe in keyframes) {
      if (keyframe.duration <= Duration.zero) {
        throw ArgumentError.value(
          keyframe.duration,
          'keyframes',
          'Keyframe durations must be positive',
        );
      }
      total += keyframe.duration;
    }
    return TimelineAnimation<T>._(
      lerp: lerp ?? defaultLerp,
      totalDuration: total,
      keyframes: List<Keyframe<T>>.unmodifiable(keyframes),
    );
  }

  /// Interpolation used by absolute and relative segments.
  final PropertyLerp<T> lerp;

  /// Sum of every segment duration.
  final Duration totalDuration;

  /// The segments, in order.
  final List<Keyframe<T>> keyframes;

  /// Default interpolation: rounds for `int` endpoints, lerps any other
  /// `num`, and throws for types it cannot interpolate (the old dynamic
  /// `a + (b - a) * t` cast crashed at runtime for `T = int`).
  static T defaultLerp<T>(T a, T b, double t) {
    if (a is int && b is int) {
      return (a + (b - a) * t).round() as T;
    }
    if (a is num && b is num) {
      return (a + (b - a) * t) as T;
    }
    throw ArgumentError(
      'TimelineAnimation<$T> cannot interpolate ${a.runtimeType}; '
      'pass an explicit `lerp` (see Transformers).',
    );
  }

  /// Drives this timeline from [controller]; the controller's duration is
  /// used as the timeline window.
  TimelineAnimatable<T> drive(AnimationController controller) {
    return TimelineAnimatable<T>(controller.duration ?? totalDuration, this);
  }

  /// Binds the timeline to an explicit [duration].
  TimelineAnimatable<T> withTotalDuration(Duration duration) {
    return TimelineAnimatable<T>(duration, this);
  }

  /// The value at normalized time [t]; inputs outside `0..1` are clamped so a
  /// controller that overshoots cannot assert or index past the timeline.
  @override
  T transform(double t) {
    final double clamped = t.clamp(0.0, 1.0).toDouble();
    final int elapsedMs = (clamped * totalDuration.inMicroseconds).round();
    Duration current = Duration.zero;
    for (var i = 0; i < keyframes.length; i++) {
      final Keyframe<T> keyframe = keyframes[i];
      final Duration next = current + keyframe.duration;
      if (elapsedMs < next.inMicroseconds) {
        final double localT =
            (elapsedMs - current.inMicroseconds) /
            keyframe.duration.inMicroseconds;
        return keyframe.compute(this, i, localT);
      }
      current = next;
    }
    return keyframes.last.compute(this, keyframes.length - 1, 1.0);
  }
}

/// A [TimelineAnimation] re-based onto another total duration.
class TimelineAnimatable<T> extends Animatable<T> {
  /// Creates a re-based view of [animation] over [duration].
  TimelineAnimatable(this.duration, this.animation);

  /// The window this view maps `0..1` onto.
  final Duration duration;

  /// The underlying timeline.
  final TimelineAnimation<T> animation;

  @override
  T transform(double t) {
    if (duration <= Duration.zero) {
      return animation.transform(1.0);
    }
    final double timelineT =
        (t * animation.totalDuration.inMicroseconds) / duration.inMicroseconds;
    return animation.transform(timelineT);
  }
}

/// Interpolation helpers for the built-in types, for use as a `lerp` argument.
class Transformers {
  const Transformers._();

  /// Integer interpolation (rounds half away from zero like `lerpDouble`).
  static int? typeInt(int? a, int? b, double t) {
    if (a == null || b == null) {
      return null;
    }
    return (a + (b - a) * t).round();
  }

  /// Double interpolation.
  static double? typeDouble(double? a, double? b, double t) {
    if (a == null || b == null) {
      return null;
    }
    return a + (b - a) * t;
  }

  /// Colour interpolation.
  static Color? typeColor(Color? a, Color? b, double t) {
    return Color.lerp(a, b, t);
  }

  /// Offset interpolation.
  static Offset? typeOffset(Offset? a, Offset? b, double t) {
    return Offset.lerp(a, b, t);
  }

  /// Size interpolation.
  static Size? typeSize(Size? a, Size? b, double t) {
    return Size.lerp(a, b, t);
  }

  /// Rect interpolation.
  static Rect? typeRect(Rect? a, Rect? b, double t) {
    return Rect.lerp(a, b, t);
  }
}

/// The longest total duration among [timelines].
Duration timelineMaxDuration(Iterable<TimelineAnimation<Object?>> timelines) {
  Duration longest = Duration.zero;
  for (final TimelineAnimation<Object?> timeline in timelines) {
    if (timeline.totalDuration > longest) {
      longest = timeline.totalDuration;
    }
  }
  return longest;
}
