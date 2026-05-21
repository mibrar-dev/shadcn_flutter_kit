// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../refresh_trigger.dart';

/// _RefreshTriggerTween defines a reusable type for this registry module.
class _RefreshTriggerTween extends Animatable<double> {
  /// Stores `minExtent` state/configuration for this implementation.
  final double minExtent;

  const _RefreshTriggerTween(this.minExtent);

  @override
  /// Executes `transform` behavior for this component/composite.
  double transform(double t) {
    return t / minExtent;
  }
}

/// State for the refresh trigger widget.
///
/// Manages the refresh lifecycle, gesture detection, and animation coordination
/// for pull-to-refresh functionality.
