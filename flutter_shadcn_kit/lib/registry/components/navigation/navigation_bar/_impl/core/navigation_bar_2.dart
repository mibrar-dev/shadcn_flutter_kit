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
  ///
  /// Legacy index-based selection. Kept for backward compatibility.
  /// When [selectedKey] is non-null, key-based selection takes precedence
  /// (upstream parity); [onSelected] is still invoked as a compat notify
  /// when the key resolves to an index.
  final int? index;

  /// Currently selected item key (upstream parity).
  ///
  /// When non-null, takes precedence over [index]. Matches `widget.key`
  /// of the selected child.
  final Key? selectedKey;

  /// Callback when an item is selected.
  final ValueChanged<int>? onSelected;

  /// Callback when an item is selected by key (upstream parity).
  final ValueChanged<Key?>? onSelectedKey;

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

  /// Cross-axis size when the bar is expanded (upstream parity).
  ///
  /// When set (with [collapsedSize]), the bar animates its cross-axis
  /// constraint between the two sizes based on [expanded].
  final double? expandedSize;

  /// Cross-axis size when the bar is collapsed (upstream parity).
  final double? collapsedSize;

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
    this.selectedKey,
    this.onSelected,
    this.onSelectedKey,
    this.surfaceOpacity,
    this.surfaceBlur,
    this.expanded,
    this.keepCrossAxisSize,
    this.keepMainAxisSize,
    this.expandedSize,
    this.collapsedSize,
    required this.children,
  });

  @override
  /// Executes `createState` behavior for this component/composite.
  State<NavigationBar> createState() => _NavigationBarState();
}
