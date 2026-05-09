// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../hover.dart';

/// HoverActivity defines a reusable type for this registry module.
class HoverActivity extends StatefulWidget {
  /// Stores `child` state/configuration for this implementation.
  final Widget child;

  /// Stores `onHover` state/configuration for this implementation.
  final VoidCallback? onHover;

  /// Stores `onExit` state/configuration for this implementation.
  final VoidCallback? onExit;

  /// Stores `onEnter` state/configuration for this implementation.
  final VoidCallback? onEnter;

  /// Stores `debounceDuration` state/configuration for this implementation.
  final Duration? debounceDuration;

  /// Stores `hitTestBehavior` state/configuration for this implementation.
  final HitTestBehavior? hitTestBehavior;

  /// Creates a `HoverActivity` instance.
  const HoverActivity({
    super.key,
    required this.child,
    this.onHover,
    this.onExit,
    this.onEnter,
    this.hitTestBehavior,
    this.debounceDuration,
  });

  @override
  /// Executes `createState` behavior for this component/composite.
  State<HoverActivity> createState() => _HoverActivityState();
}
