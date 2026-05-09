// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../timeline_animation.dart';

/// Keyframe defines a reusable type for this registry module.
abstract class Keyframe<T> {
  /// Stores `duration` state/configuration for this implementation.
  Duration get duration;
  T compute(TimelineAnimation<T> timeline, int index, double t);
}

/// Animates between explicit start and end values.
