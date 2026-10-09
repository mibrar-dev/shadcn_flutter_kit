import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

/// Builds a display widget for a single logical keyboard key.
typedef KeyboardShortcutDisplayBuilder =
    Widget Function(BuildContext context, LogicalKeyboardKey key);

/// Wraps a [KeyboardShortcutDisplayBuilder] so components can read it from
/// the tree through `Data.of<KeyboardShortcutDisplayHandle>`.
class KeyboardShortcutDisplayHandle {
  final KeyboardShortcutDisplayBuilder _builder;

  const KeyboardShortcutDisplayHandle(this._builder);

  /// Builds a display widget for [key].
  Widget buildKeyboardDisplay(BuildContext context, LogicalKeyboardKey key) {
    return _builder(context, key);
  }
}

/// Converts a [ShortcutActivator] into the list of logical keys that make it
/// up, modifier keys included.
List<LogicalKeyboardKey> shortcutActivatorToKeySet(
  ShortcutActivator activator,
) {
  List<LogicalKeyboardKey> keys = [];
  if (activator is CharacterActivator) {
    if (activator.control) {
      keys.add(LogicalKeyboardKey.control);
    }
    if (activator.alt) {
      keys.add(LogicalKeyboardKey.alt);
    }
    if (activator.meta) {
      keys.add(LogicalKeyboardKey.meta);
    }
    keys.add(LogicalKeyboardKey(activator.character.codeUnitAt(0)));
  }
  if (activator is SingleActivator) {
    if (activator.control) {
      keys.add(LogicalKeyboardKey.control);
    }
    if (activator.alt) {
      keys.add(LogicalKeyboardKey.alt);
    }
    if (activator.meta) {
      keys.add(LogicalKeyboardKey.meta);
    }
    if (activator.shift) {
      keys.add(LogicalKeyboardKey.shift);
    }
    keys.add(activator.trigger);
  }
  if (activator is LogicalKeySet) {
    for (final trigger in activator.triggers) {
      keys.add(trigger);
    }
  }
  return keys;
}
