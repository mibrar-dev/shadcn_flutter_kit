// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../menu.dart';

/// MenuGroupData defines a reusable type for this registry module.
class MenuGroupData {
  /// Parent menu group, null for root menus.
  final MenuGroupData? parent;

  /// Child menu items' data.
  final List<MenuData> children;

  /// Whether any child items have leading widgets.
  final bool hasLeading;

  /// Offset for positioning submenus relative to parent.
  final Offset? subMenuOffset;

  /// Callback when menu is dismissed.
  final VoidCallback? onDismissed;

  /// Region group ID for tap region management.
  final Object? regionGroupId;

  /// Layout direction (horizontal or vertical).
  final Axis direction;

  /// Padding around menu items.
  final EdgeInsets itemPadding;

  /// Focus scope state for keyboard navigation.
  final SubFocusScopeState focusScope;

  /// Creates menu group data.
  ///
  /// Parameters:
  /// - [parent] (MenuGroupData?): Parent group
  /// - [children] (`List<MenuData>`): Child items
  /// - [hasLeading] (bool): Whether items have leading widgets
  /// - [subMenuOffset] (Offset?): Submenu offset
  /// - [onDismissed] (VoidCallback?): Dismissal callback
  /// - [regionGroupId] (Object?): Region group ID
  /// - [direction] (Axis): Layout direction
  /// - [itemPadding] (EdgeInsets): Item padding
  /// - [focusScope] (SubFocusScopeState): Focus scope
  MenuGroupData(
    this.parent,
    this.children,
    this.hasLeading,
    this.subMenuOffset,
    this.onDismissed,
    this.regionGroupId,
    this.direction,
    this.itemPadding,
    this.focusScope,
  );

  /// Checks if any child menu items have open popovers.
  ///
  /// Returns true if at least one child has an open submenu popover.
  bool get hasOpenPopovers {
    for (final child in children) {
      if (child.popoverController.hasOpenPopover) {
        return true;
      }
    }
    return false;
  }

  /// Closes all open popovers in child menu items.
  ///
  /// Iterates through children and closes any open submenu popovers.
  void closeOthers() {
    for (final child in children) {
      child.popoverController.close();
    }
  }

  /// Closes all menus in the hierarchy by bubbling up to root.
  ///
  /// Recursively closes popovers in parent groups and invokes the
  /// dismissal callback at the root level.
  void closeAll() {
    var menuGroupData = parent;
    if (menuGroupData == null) {
      onDismissed?.call();
      return;
    }
    menuGroupData.closeOthers();
    menuGroupData.closeAll();
  }

  @override
  /// Executes `operator ==` behavior for this component/composite.
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is MenuGroupData) {
      return listEquals(children, other.children) &&
          parent == other.parent &&
          hasLeading == other.hasLeading &&
          subMenuOffset == other.subMenuOffset &&
          onDismissed == other.onDismissed;
    }
    return false;
  }

  /// Gets the root menu group in the hierarchy.
  ///
  /// Traverses up the parent chain to find the topmost menu group.
  ///
  /// Returns the root [MenuGroupData].
  MenuGroupData get root {
    /// Stores `menuGroupData` state/configuration for this implementation.
    var menuGroupData = parent;
    if (menuGroupData == null) {
      return this;
    }
    return menuGroupData.root;
  }

  @override
  int get hashCode =>
      Object.hash(children, parent, hasLeading, subMenuOffset, onDismissed);

  @override
  /// Executes `toString` behavior for this component/composite.
  String toString() {
    return 'MenuGroupData{parent: $parent, children: $children, hasLeading: $hasLeading, subMenuOffset: $subMenuOffset, onDismissed: $onDismissed, regionGroupId: $regionGroupId, direction: $direction}';
  }
}

/// Data container for individual menu item state.
///
/// Wraps a popover controller for each menu item, managing submenu
/// display and interaction state.
