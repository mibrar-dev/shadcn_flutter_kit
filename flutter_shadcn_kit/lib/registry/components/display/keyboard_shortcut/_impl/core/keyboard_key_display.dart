// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../keyboard_shortcut.dart';

/// A widget that displays a single keyboard key in a styled format.
class KeyboardKeyDisplay extends StatelessWidget {
  /// The keyboard key to display.
  final LogicalKeyboardKey keyboardKey;

  /// Internal padding applied within the key display.
  final EdgeInsetsGeometry? padding;

  /// Box shadows applied to the key display for depth effect.
  final List<BoxShadow>? boxShadow;

  /// Creates a [KeyboardKeyDisplay] for the specified keyboard key.
  const KeyboardKeyDisplay({
    super.key,
    required this.keyboardKey,
    this.padding,
    this.boxShadow,
  });

  /// Builds the widget tree for keyboard shortcut.
  @override
  Widget build(BuildContext context) {
    final displayMapper = Data.of<KeyboardShortcutDisplayHandle>(context);
    final theme = Theme.of(context);
    final directionality = Directionality.of(context);
    final compTheme = ComponentTheme.maybeOf<KeyboardShortcutTheme>(context);
    final resolvedPadding = styleValue(
      widgetValue: padding,
      themeValue: compTheme?.keyPadding,
      defaultValue: EdgeInsets.symmetric(
        horizontal: theme.density.baseGap * 0.75,
        vertical: theme.density.baseGap * 0.5,
      ),
    ).resolve(directionality);
    final resolvedShadow = styleValue(
      widgetValue: boxShadow,
      themeValue: compTheme?.keyShadow,
      defaultValue: null,
    );

    return Card(
      padding: resolvedPadding * theme.scaling,
      borderRadius: theme.borderRadiusMd,
      fillColor: theme.colorScheme.background.scaleAlpha(0.7),
      filled: true,
      boxShadow: resolvedShadow,
      child: displayMapper.buildKeyboardDisplay(context, keyboardKey),
    );
  }
}
