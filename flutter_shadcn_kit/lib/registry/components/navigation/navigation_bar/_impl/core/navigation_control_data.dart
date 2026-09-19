// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../navigation_bar.dart';

/// NavigationControlData defines a reusable type for this registry module.
class NavigationControlData {
  /// Type of navigation container (bar, rail, etc.).
  final NavigationContainerType containerType;

  /// Label display type from parent container.
  final NavigationLabelType parentLabelType;

  /// Label position relative to icon from parent.
  final NavigationLabelPosition parentLabelPosition;

  /// Label size variant from parent.
  final NavigationLabelSize parentLabelSize;

  /// Padding applied by parent container.
  final EdgeInsets parentPadding;

  /// Layout direction (horizontal or vertical).
  final Axis direction;

  /// Currently selected item index (null if none selected).
  ///
  /// Legacy index-based selection. When [selectedKey] is non-null, key-based
  /// selection takes precedence (upstream parity); index is ignored for
  /// highlighting but [onSelected] is still invoked as a compat notify.
  final int? selectedIndex;

  /// Currently selected item key (null if none selected, upstream parity).
  ///
  /// When non-null, takes precedence over [selectedIndex]. Matches
  /// `widget.key` of the selected [NavigationBarItem].
  final Key? selectedKey;

  /// Total number of child items.
  final int childCount;

  /// Callback when an item is selected.
  final ValueChanged<int> onSelected;

  /// Callback when an item is selected by key (upstream parity, optional).
  ///
  /// Invoked alongside [onSelected] when the selection can be resolved to a
  /// key/index pair. May be null when only index-based selection is used.
  final ValueChanged<Key?>? onSelectedKey;

  /// Whether the navigation is expanded to fill available space.
  final bool expanded;

  /// Spacing between navigation items.
  final double spacing;

  /// Whether to maintain cross-axis size constraints.
  final bool keepCrossAxisSize;

  /// Whether to maintain main-axis size constraints.
  final bool keepMainAxisSize;

  /// Computed label direction based on parent label position.
  ///
  /// Returns horizontal for start/end positions, vertical for top/bottom.
  Axis get labelDirection {
    return parentLabelPosition == NavigationLabelPosition.start ||
            parentLabelPosition == NavigationLabelPosition.end
        ? Axis.horizontal
        : Axis.vertical;
  }

  /// Creates navigation control data.
  ///
  /// Parameters:
  /// - [containerType] (NavigationContainerType, required): Container type
  /// - [parentLabelType] (NavigationLabelType, required): Label display type
  /// - [parentLabelPosition] (NavigationLabelPosition, required): Label position
  /// - [parentLabelSize] (NavigationLabelSize, required): Label size variant
  /// - [parentPadding] (EdgeInsets, required): Container padding
  /// - [direction] (Axis, required): Layout direction
  /// - [selectedIndex] (int?): Selected item index
  /// - [onSelected] (`ValueChanged<int>`, required): Selection callback
  /// - [expanded] (bool, required): Whether expanded
  /// - [childCount] (int, required): Number of children
  /// - [spacing] (double, required): Item spacing
  /// - [keepCrossAxisSize] (bool, required): Maintain cross-axis size
  /// - [keepMainAxisSize] (bool, required): Maintain main-axis size
  NavigationControlData({
    required this.containerType,
    required this.parentLabelType,
    required this.parentLabelPosition,
    required this.parentLabelSize,
    required this.parentPadding,
    required this.direction,
    required this.selectedIndex,
    required this.onSelected,
    this.selectedKey,
    this.onSelectedKey,
    required this.expanded,
    required this.childCount,
    required this.spacing,
    required this.keepCrossAxisSize,
    required this.keepMainAxisSize,
  });

  @override
  /// Executes `operator ==` behavior for this component/composite.
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is NavigationControlData &&
        other.containerType == containerType &&
        other.parentLabelType == parentLabelType &&
        other.parentPadding == parentPadding &&
        other.direction == direction &&
        other.selectedIndex == selectedIndex &&
        other.selectedKey == selectedKey &&
        other.onSelected == onSelected &&
        other.parentLabelPosition == parentLabelPosition &&
        other.parentLabelSize == parentLabelSize &&
        other.expanded == expanded &&
        other.childCount == childCount &&
        other.spacing == spacing &&
        other.keepCrossAxisSize == keepCrossAxisSize &&
        other.keepMainAxisSize == keepMainAxisSize;
  }

  @override
  int get hashCode {
    return Object.hash(
      containerType,
      parentLabelType,
      parentPadding,
      direction,
      selectedIndex,
      selectedKey,
      onSelected,
      parentLabelPosition,
      parentLabelSize,
      expanded,
      childCount,
      spacing,
      keepCrossAxisSize,
      keepMainAxisSize,
    );
  }
}
