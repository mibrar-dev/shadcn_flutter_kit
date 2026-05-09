// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../context_menu.dart';

/// ContextMenu defines a reusable type for this registry module.
class ContextMenu extends StatefulWidget {
  /// The child widget that triggers the context menu.
  final Widget child;

  /// Menu items to display in the context menu.
  final List<MenuItem> items;

  /// How hit testing behaves for the child.
  final HitTestBehavior behavior;

  /// Direction to lay out menu items.
  final Axis direction;

  /// Whether the context menu is enabled.
  final bool enabled;

  /// Creates a [ContextMenu].
  ///
  /// Parameters:
  /// - [child] (`Widget`, required): Widget that triggers menu.
  /// - [items] (`List<MenuItem>`, required): Menu items.
  /// - [behavior] (`HitTestBehavior`, optional): Hit test behavior.
  /// - [direction] (`Axis`, optional): Menu layout direction.
  /// - [enabled] (`bool`, optional): Whether menu is enabled.
  const ContextMenu({
    super.key,
    required this.child,
    required this.items,
    this.behavior = HitTestBehavior.translucent,
    this.direction = Axis.vertical,
    this.enabled = true,
  });

  @override
  /// Executes `createState` behavior for this component/composite.
  State<ContextMenu> createState() => _ContextMenuState();
}
