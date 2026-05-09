// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

/// Builder function type for creating custom keyboard key displays.
typedef KeyboardShortcutDisplayBuilder =
    Widget Function(BuildContext context, LogicalKeyboardKey key);

/// Handle for accessing keyboard shortcut display builders.
class KeyboardShortcutDisplayHandle {
  /// Stores `_builder` state/configuration for this implementation.
  final KeyboardShortcutDisplayBuilder _builder;

  /// Creates a handle with the specified builder.
  const KeyboardShortcutDisplayHandle(this._builder);

  /// Builds a display widget for the specified keyboard key.
  Widget buildKeyboardDisplay(BuildContext context, LogicalKeyboardKey key) {
    return _builder(context, key);
  }
}

/// Converts a [ShortcutActivator] into a list of logical keyboard keys.
List<LogicalKeyboardKey> shortcutActivatorToKeySet(
  ShortcutActivator activator,
) {
  /// Stores `keys` state/configuration for this implementation.
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
