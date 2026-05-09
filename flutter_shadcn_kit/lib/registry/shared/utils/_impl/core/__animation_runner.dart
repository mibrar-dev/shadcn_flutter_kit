// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../animation_queue.dart';

/// _AnimationRunner defines a reusable type for this registry module.
class _AnimationRunner {
  /// Stores `from` state/configuration for this implementation.
  final double from;

  /// Stores `to` state/configuration for this implementation.
  final double to;

  /// Stores `duration` state/configuration for this implementation.
  final Duration duration;

  /// Stores `curve` state/configuration for this implementation.
  final Curve curve;

  /// Stores `_progress` state/configuration for this implementation.
  double _progress = 0.0;

  _AnimationRunner(this.from, this.to, this.duration, this.curve);
}

/// Queue-based animation controller used by carousel transitions.
