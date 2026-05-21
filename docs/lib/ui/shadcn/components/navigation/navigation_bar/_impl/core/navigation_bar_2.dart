// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../navigation_bar.dart';

/// NavigationBar defines a reusable type for this registry module.
class NavigationBar extends StatefulWidget {
  /// Background color of the navigation bar.
  final Color? backgroundColor;

  /// List of navigation items to display.
  final List<NavigationBarItem> children;

  /// Alignment of navigation items.
  final NavigationBarAlignment? alignment;

  /// Layout direction (horizontal or vertical).
  final Axis? direction;

  /// Spacing between navigation items.
  final double? spacing;

  /// Type of label display.
  final NavigationLabelType? labelType;

  /// Position of labels relative to icons.
  final NavigationLabelPosition? labelPosition;

  /// Size variant for labels.
  final NavigationLabelSize? labelSize;

  /// Internal padding of the navigation bar.
  final EdgeInsetsGeometry? padding;

  /// Size constraints for the navigation bar.
  final BoxConstraints? constraints;

  /// Whether the navigation bar expands to fill available space.
  final bool? expands;

  /// Currently selected item index.
  final int? index;

  /// Callback when an item is selected.
  final ValueChanged<int>? onSelected;

  /// Surface opacity for the navigation bar background.
  final double? surfaceOpacity;

  /// Surface blur amount for the navigation bar background.
  final double? surfaceBlur;

  /// Whether the navigation bar is in expanded state (for collapsible bars).
  final bool? expanded;

  /// Whether to keep cross-axis size when expanding/collapsing.
  final bool? keepCrossAxisSize;

  /// Whether to keep main-axis size when expanding/collapsing.
  final bool? keepMainAxisSize;

  /// Creates a [NavigationBar].
  const NavigationBar({
    super.key,
    this.backgroundColor,
    this.alignment,
    this.direction,
    this.spacing,
    this.labelType,
    this.labelPosition,
    this.labelSize,
    this.padding,
    this.constraints,
    this.expands,
    this.index,
    this.onSelected,
    this.surfaceOpacity,
    this.surfaceBlur,
    this.expanded,
    this.keepCrossAxisSize,
    this.keepMainAxisSize,
    required this.children,
  });

  @override
  /// Executes `createState` behavior for this component/composite.
  State<NavigationBar> createState() => _NavigationBarState();
}
