// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../menu.dart';

/// MenuButton defines a reusable type for this registry module.
class MenuButton extends StatefulWidget implements MenuItem {
  /// Content widget displayed in the button.
  final Widget child;

  /// Optional submenu items shown on hover or click.
  final List<MenuItem>? subMenu;

  /// Callback when button is pressed.
  final ContextedCallback? onPressed;

  /// Optional trailing widget (e.g., keyboard shortcut indicator).
  final Widget? trailing;

  /// Optional leading widget (e.g., icon).
  final Widget? leading;

  /// Whether the button is enabled for interaction.
  final bool enabled;

  /// Focus node for keyboard navigation.
  final FocusNode? focusNode;

  /// Whether selecting this button closes the menu automatically.
  final bool autoClose;

  @override
  /// Stores `popoverController` state/configuration for this implementation.
  final PopoverController? popoverController;

  /// Creates a menu button.
  ///
  /// Parameters:
  /// - [child] (Widget, required): Main content
  /// - [subMenu] (`List<MenuItem>?`): Optional nested submenu
  /// - [onPressed] (ContextedCallback?): Click handler
  /// - [trailing] (Widget?): Trailing widget
  /// - [leading] (Widget?): Leading icon or widget
  /// - [enabled] (bool): Whether enabled, defaults to true
  /// - [focusNode] (FocusNode?): Focus node
  /// - [autoClose] (bool): Auto-close behavior, defaults to true
  /// - [popoverController] (PopoverController?): Optional popover controller
  const MenuButton({
    super.key,
    required this.child,
    this.subMenu,
    this.onPressed,
    this.trailing,
    this.leading,
    this.enabled = true,
    this.focusNode,
    this.autoClose = true,
    this.popoverController,
  });

  @override
  /// Executes `createState` behavior for this component/composite.
  State<MenuButton> createState() => _MenuButtonState();

  @override
  /// Stores `hasLeading` state/configuration for this implementation.
  bool get hasLeading => leading != null;
}

/// Non-interactive label menu item.
///
/// Displays text or content without click handlers. Useful for section
/// headers or informational text within menus.
///
/// Example:
/// ```dart
/// MenuLabel(
///   leading: Icon(Icons.settings),
///   child: Text('Settings').semiBold(),
/// )
/// ```
