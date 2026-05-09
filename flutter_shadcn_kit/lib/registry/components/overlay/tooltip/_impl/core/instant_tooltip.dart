// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../tooltip.dart';

/// InstantTooltip defines a reusable type for this registry module.
class InstantTooltip extends StatefulWidget {
  /// Stores `child` state/configuration for this implementation.
  final Widget child;

  /// Stores `behavior` state/configuration for this implementation.
  final HitTestBehavior behavior;

  /// Stores `tooltipBuilder` state/configuration for this implementation.
  final WidgetBuilder tooltipBuilder;

  /// Stores `tooltipAlignment` state/configuration for this implementation.
  final AlignmentGeometry tooltipAlignment;

  /// Stores `tooltipAnchorAlignment` state/configuration for this implementation.
  final AlignmentGeometry? tooltipAnchorAlignment;

  /// Creates a `InstantTooltip` instance.
  const InstantTooltip({
    super.key,
    required this.child,
    required this.tooltipBuilder,
    this.behavior = HitTestBehavior.translucent,
    this.tooltipAlignment = Alignment.bottomCenter,
    this.tooltipAnchorAlignment,
  });

  @override
  /// Executes `createState` behavior for this component/composite.
  State<InstantTooltip> createState() => _InstantTooltipState();
}
