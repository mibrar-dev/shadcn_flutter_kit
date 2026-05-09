// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../menu.dart';

/// MenuGroup defines a reusable type for this registry module.
class MenuGroup extends StatefulWidget {
  /// List of menu item widgets.
  final List<MenuItem> children;

  /// Builder function that layouts the menu items.
  final Widget Function(BuildContext context, List<Widget> children) builder;

  /// Parent menu group for nested submenus.
  final MenuGroupData? parent;

  /// Offset for positioning submenus.
  final Offset? subMenuOffset;

  /// Callback when menu is dismissed.
  final VoidCallback? onDismissed;

  /// Region group ID for tap region management.
  final Object? regionGroupId;

  /// Layout direction (horizontal or vertical).
  final Axis direction;

  /// Custom keyboard actions.
  final Map<Type, Action> actions;

  /// Padding around menu items.
  final EdgeInsets? itemPadding;

  /// Whether to autofocus on mount.
  final bool autofocus;

  /// Optional focus node for keyboard navigation.
  final FocusNode? focusNode;

  /// Creates a menu group.
  ///
  /// Parameters:
  /// - [children] (`List<MenuItem>`, required): Menu items
  /// - [builder] (Function, required): Layout builder
  /// - [direction] (Axis, required): Layout direction
  /// - [parent] (MenuGroupData?): Parent group for nesting
  /// - [subMenuOffset] (Offset?): Submenu positioning offset
  /// - [onDismissed] (VoidCallback?): Dismissal callback
  /// - [regionGroupId] (Object?): Tap region group ID
  /// - [actions] (`Map<Type, Action>`): Custom actions, defaults to empty
  /// - [itemPadding] (EdgeInsets?): Item padding
  /// - [autofocus] (bool): Auto-focus behavior, defaults to true
  /// - [focusNode] (FocusNode?): Focus node
  const MenuGroup({
    super.key,
    required this.children,
    required this.builder,
    this.parent,
    this.subMenuOffset,
    this.onDismissed,
    this.regionGroupId,
    this.actions = const {},
    required this.direction,
    this.itemPadding,
    this.autofocus = true,
    this.focusNode,
  });

  @override
  /// Executes `createState` behavior for this component/composite.
  State<MenuGroup> createState() => _MenuGroupState();
}
