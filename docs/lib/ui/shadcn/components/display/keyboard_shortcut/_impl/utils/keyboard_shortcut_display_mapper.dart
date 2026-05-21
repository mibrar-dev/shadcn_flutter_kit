// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../keyboard_shortcut.dart';

/// Widget that provides keyboard shortcut display customization.
///
/// Allows customization of how keyboard shortcuts are displayed
/// throughout the widget tree using a builder function.
class KeyboardShortcutDisplayMapper extends StatefulWidget {
  /// Implements `_defaultBuilder` behavior for keyboard shortcut.
  static Widget _defaultBuilder(BuildContext context, LogicalKeyboardKey key) {
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
        return Text(key.keyLabel);
    }
  }

  /// The builder function for creating key displays.
  final KeyboardShortcutDisplayBuilder builder;

  /// The child widget that will have access to this mapper.
  final Widget child;

  /// Creates a keyboard shortcut display mapper.
  const KeyboardShortcutDisplayMapper({
    super.key,
    this.builder = _defaultBuilder,
    required this.child,
  });

  /// Creates the State object used by this keyboard shortcut widget.
  @override
  State<KeyboardShortcutDisplayMapper> createState() =>
      _KeyboardShortcutDisplayMapperState();
}
