// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../menu.dart';

/// MenuData defines a reusable type for this registry module.
class MenuData {
  /// Controller for this item's submenu popover.
  final PopoverController popoverController;

  /// Creates menu item data.
  ///
  /// Parameters:
  /// - [popoverController] (PopoverController?): Optional controller, creates default if null
  MenuData({PopoverController? popoverController})
    : popoverController = popoverController ?? PopoverController();
}

/// Container widget for organizing menu items into a group.
///
/// Provides layout, focus management, and keyboard navigation for a collection
/// of menu items. Supports both horizontal and vertical orientations, nested
/// submenus, and customizable actions.
///
/// Example:
/// ```dart
/// MenuGroup(
///   direction: Axis.vertical,
///   builder: (context, children) => Column(children: children),
///   children: [
///     MenuButton(child: Text('Cut')),
///     MenuButton(child: Text('Copy')),
///     MenuDivider(),
///     MenuButton(child: Text('Paste')),
///   ],
/// )
/// ```
