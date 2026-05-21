// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../refresh_trigger.dart';

/// RefreshTriggerStage defines a reusable type for this registry module.
class RefreshTriggerStage {
  /// Current stage of the refresh lifecycle.
  final TriggerStage stage;

  /// Animated pull extent value.
  ///
  /// Range depends on min/max extent configuration. Use [extentValue] for
  /// current numeric value.
  final Animation<double> extent;

  /// Direction of the pull gesture.
  final Axis direction;

  /// Whether the pull direction is reversed.
  final bool reverse;

  /// Creates a refresh trigger stage snapshot.
  const RefreshTriggerStage(
    this.stage,
    this.extent,
    this.direction,
    this.reverse,
  );

  /// Current numeric value of the pull extent.
  ///
  /// Convenience getter for [extent.value].
  double get extentValue => extent.value;
}

/// Custom scroll physics for refresh trigger behavior.
///
/// Enables over-scroll to allow pulling beyond content bounds for refresh.
/// Applied automatically by [RefreshTrigger] to its child scrollable.
