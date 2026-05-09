// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../menu.dart';

/// MenuGap defines a reusable type for this registry module.
class MenuGap extends StatelessWidget implements MenuItem {
  /// Size of the gap in logical pixels.
  final double size;

  /// Creates a menu gap.
  ///
  /// Parameters:
  /// - [size] (double, required): Gap size in logical pixels
  const MenuGap(this.size, {super.key});

  @override
  /// Executes `build` behavior for this component/composite.
  Widget build(BuildContext context) {
    return Gap(size);
  }

  @override
  /// Stores `hasLeading` state/configuration for this implementation.
  bool get hasLeading => false;

  @override
  /// Stores `popoverController` state/configuration for this implementation.
  PopoverController? get popoverController => null;
}

/// Clickable button menu item with optional submenu support.
///
/// Primary menu item type that responds to user interaction. Can display
/// leading icons, trailing widgets (shortcuts), and nested submenus.
///
/// Example:
/// ```dart
/// MenuButton(
///   leading: Icon(Icons.cut),
///   trailing: Text('Ctrl+X').textSmall().muted(),
///   onPressed: (context) => _handleCut(),
///   child: Text('Cut'),
/// )
/// ```
