// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../keyboard_shortcut.dart';

/// A widget that displays keyboard shortcuts in a visually appealing format.
///
/// Renders keyboard key combinations as styled keyboard key representations,
/// typically used in tooltips, help text, or UI elements that need to
/// communicate keyboard shortcuts to users.
class KeyboardDisplay extends StatelessWidget {
  /// List of keyboard keys to display when using direct key specification.
  final List<LogicalKeyboardKey>? _keys;

  /// Shortcut activator to convert to keyboard keys for display.
  final ShortcutActivator? _activator;

  /// Spacing between individual keyboard key displays.
  ///
  /// Controls the horizontal gap between adjacent key representations.
  /// When null, uses theme-appropriate default spacing.
  final double? spacing;

  /// Creates a [KeyboardDisplay] from a list of keyboard keys.
  const KeyboardDisplay({
    super.key,
    required List<LogicalKeyboardKey> keys,
    this.spacing,
  }) : _keys = keys,
       _activator = null;

  /// Creates a [KeyboardDisplay] from a shortcut activator.
  const KeyboardDisplay.fromActivator({
    super.key,
    required ShortcutActivator activator,
    this.spacing,
  }) : _keys = null,
       _activator = activator;

  /// Builds the widget tree for keyboard shortcut.
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final compTheme = ComponentTheme.maybeOf<KeyboardShortcutTheme>(context);
    final keys = _keys ?? shortcutActivatorToKeySet(_activator!);
    final spacing = styleValue(
      widgetValue: this.spacing,
      themeValue: compTheme?.spacing,
      defaultValue: 2 * theme.scaling,
    );
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: keys
          .map((key) => KeyboardKeyDisplay(keyboardKey: key))
          .toList(),
    ).gap(spacing);
  }
}

/// Converts a [ShortcutActivator] into a list of logical keyboard keys.
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
