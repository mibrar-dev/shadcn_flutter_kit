// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../toast.dart';

/// ToastEntry defines a reusable type for this registry module.
class ToastEntry extends StatefulWidget {
  /// Stores `child` state/configuration for this implementation.
  final Widget child;

  /// Stores `duration` state/configuration for this implementation.
  final Duration duration;

  /// Stores `animationDuration` state/configuration for this implementation.
  final Duration animationDuration;

  /// Stores `animationCurve` state/configuration for this implementation.
  final Curve animationCurve;

  /// Stores `onDismissed` state/configuration for this implementation.
  final VoidCallback onDismissed;

  /// Stores `pauseOnHover` state/configuration for this implementation.
  final bool pauseOnHover;

  /// Stores `dismissDirections` state/configuration for this implementation.
  final Set<ToastSwipeDirection> dismissDirections;

  /// Stores `dismissDragThreshold` state/configuration for this implementation.
  final double dismissDragThreshold;

  /// Stores `autoDismiss` state/configuration for this implementation.
  final bool autoDismiss;

  /// Stores `onInteractionStart` state/configuration for this implementation.
  final VoidCallback? onInteractionStart;

  /// Stores `onInteractionEnd` state/configuration for this implementation.
  final VoidCallback? onInteractionEnd;

  /// Stores `onTap` state/configuration for this implementation.
  final VoidCallback? onTap;

  /// Stores `dismissSignal` state/configuration for this implementation.
  final int dismissSignal;

  /// Stores `refreshSignal` state/configuration for this implementation.
  final int refreshSignal;

  /// Stores `onDismissRequest` state/configuration for this implementation.
  final bool Function()? onDismissRequest;

  /// Stores `onPointerScroll` state/configuration for this implementation.
  final ValueChanged<double>? onPointerScroll;

  /// Stores `onDragScroll` state/configuration for this implementation.
  final ValueChanged<double>? onDragScroll;

  /// Creates a `ToastEntry` instance.
  const ToastEntry({
    super.key,
    required this.child,
    required this.duration,
    required this.animationDuration,
    required this.animationCurve,
    required this.onDismissed,
    this.pauseOnHover = false,
    this.dismissDirections = const {},
    this.dismissDragThreshold = 72,
    this.autoDismiss = true,
    this.onInteractionStart,
    this.onInteractionEnd,
    this.onTap,
    this.dismissSignal = 0,
    this.refreshSignal = 0,
    this.onDismissRequest,
    this.onPointerScroll,
    this.onDragScroll,
  });

  @override
  /// Executes `createState` behavior for this component/composite.
  State<ToastEntry> createState() => _ToastEntryState();
}
