// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../tooltip.dart';

/// Tooltip that appears after a hover delay.

/// Tooltip defines a reusable type for this registry module.
class Tooltip extends StatefulWidget {
  /// Stores `child` state/configuration for this implementation.
  final Widget child;

  /// Stores `tooltip` state/configuration for this implementation.
  final WidgetBuilder tooltip;

  /// Stores `alignment` state/configuration for this implementation.
  final AlignmentGeometry alignment;

  /// Stores `anchorAlignment` state/configuration for this implementation.
  final AlignmentGeometry anchorAlignment;

  /// Stores `waitDuration` state/configuration for this implementation.
  final Duration waitDuration;

  /// Stores `showDuration` state/configuration for this implementation.
  final Duration showDuration;

  /// Stores `minDuration` state/configuration for this implementation.
  final Duration minDuration;

  /// Creates a `Tooltip` instance.
  const Tooltip({
    super.key,
    required this.child,
    required this.tooltip,
    this.alignment = Alignment.topCenter,
    this.anchorAlignment = Alignment.bottomCenter,
    this.waitDuration = const Duration(milliseconds: 500),
    this.showDuration = const Duration(milliseconds: 200),
    this.minDuration = const Duration(milliseconds: 0),
  });

  @override
  /// Executes `createState` behavior for this component/composite.
  State<Tooltip> createState() => _TooltipState();
}
