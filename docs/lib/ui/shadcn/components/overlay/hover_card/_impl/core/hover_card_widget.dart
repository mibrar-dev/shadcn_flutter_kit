// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../hover_card.dart';

/// Displays a popover when the child is hovered or long-pressed.

/// HoverCard defines a reusable type for this registry module.
class HoverCard extends StatefulWidget {
  /// Stores `child` state/configuration for this implementation.
  final Widget child;

  /// Stores `debounce` state/configuration for this implementation.
  final Duration? debounce;

  /// Stores `wait` state/configuration for this implementation.
  final Duration? wait;

  /// Stores `hoverBuilder` state/configuration for this implementation.
  final WidgetBuilder hoverBuilder;

  /// Stores `popoverAlignment` state/configuration for this implementation.
  final AlignmentGeometry? popoverAlignment;

  /// Stores `anchorAlignment` state/configuration for this implementation.
  final AlignmentGeometry? anchorAlignment;

  /// Stores `popoverOffset` state/configuration for this implementation.
  final Offset? popoverOffset;

  /// Stores `behavior` state/configuration for this implementation.
  final HitTestBehavior? behavior;

  /// Stores `controller` state/configuration for this implementation.
  final PopoverController? controller;

  /// Stores `handler` state/configuration for this implementation.
  final OverlayHandler? handler;

  /// Creates a `HoverCard` instance.
  const HoverCard({
    super.key,
    required this.child,
    required this.hoverBuilder,
    this.debounce,
    this.wait,
    this.popoverAlignment,
    this.anchorAlignment,
    this.popoverOffset,
    this.behavior,
    this.controller,
    this.handler,
  });

  @override
  /// Executes `createState` behavior for this component/composite.
  State<HoverCard> createState() => _HoverCardState();
}
