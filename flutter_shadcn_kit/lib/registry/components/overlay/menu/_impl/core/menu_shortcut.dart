// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../menu.dart';

/// MenuShortcut defines a reusable type for this registry module.
class MenuShortcut extends StatelessWidget {
  /// The keyboard shortcut to display.
  final ShortcutActivator activator;

  /// Widget to display between multiple keys.
  final Widget? combiner;

  /// Creates a [MenuShortcut].
  ///
  /// Parameters:
  /// - [activator] (`ShortcutActivator`, required): The shortcut to display.
  /// - [combiner] (`Widget?`, optional): Separator between keys (default: " + ").
  const MenuShortcut({super.key, required this.activator, this.combiner});

  @override
  /// Executes `build` behavior for this component/composite.
  Widget build(BuildContext context) {
    /// Stores `activator` state/configuration for this implementation.
    var activator = this.activator;
    var combiner = this.combiner ?? const Text(' + ');
    final displayMapper = Data.maybeOf<KeyboardShortcutDisplayHandle>(context);
    List<LogicalKeyboardKey> keys = shortcutActivatorToKeySet(activator);

    /// Stores `children` state/configuration for this implementation.
    List<Widget> children = [];

    /// Executes `buildKeyboardDisplay` behavior for this component/composite.
    Widget buildKeyboardDisplay(LogicalKeyboardKey key) {
      if (displayMapper != null) {
        return displayMapper.buildKeyboardDisplay(context, key);
      }
      switch (key) {
        case LogicalKeyboardKey.control:
        case LogicalKeyboardKey.controlLeft:
        case LogicalKeyboardKey.controlRight:
          return const Text('Ctrl');
        case LogicalKeyboardKey.shift:
        case LogicalKeyboardKey.shiftLeft:
        case LogicalKeyboardKey.shiftRight:
          return const Text('Shift');
        case LogicalKeyboardKey.alt:
        case LogicalKeyboardKey.altLeft:
        case LogicalKeyboardKey.altRight:
          return const Text('Alt');
        case LogicalKeyboardKey.meta:
        case LogicalKeyboardKey.metaLeft:
        case LogicalKeyboardKey.metaRight:
          return const Text('⌘');
        case LogicalKeyboardKey.enter:
          return const Text('↵');
        case LogicalKeyboardKey.arrowLeft:
          return const Text('←');
        case LogicalKeyboardKey.arrowRight:
          return const Text('→');
        case LogicalKeyboardKey.arrowUp:
          return const Text('↑');
        case LogicalKeyboardKey.arrowDown:
          return const Text('↓');
        default:
          return Text(
            key.keyLabel.isNotEmpty ? key.keyLabel : (key.debugName ?? ''),
          );
      }
    }

    for (int i = 0; i < keys.length; i++) {
      if (i > 0) {
        children.add(combiner);
      }
      children.add(buildKeyboardDisplay(keys[i]));
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: children,
    ).xSmall().muted();
  }
}

/// Abstract base class for menu item widgets.
///
/// All menu items (buttons, checkboxes, radio buttons, dividers, etc.) must
/// implement this interface. Menu items can be placed within menu groups and
/// support features like leading icons and popover controllers.
///
/// See also:
/// - [MenuButton], clickable menu item
/// - [MenuCheckbox], checkbox menu item
/// - [MenuRadio], radio button menu item
/// - [MenuDivider], divider between menu items
