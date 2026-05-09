// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../../keyboard_shortcut.dart';

/// Theme for keyboard shortcut displays.
class KeyboardShortcutTheme extends ComponentThemeData {
  /// Spacing between keys.
  final double? spacing;

  /// Padding inside each key display.
  final EdgeInsetsGeometry? keyPadding;

  /// Shadow applied to key displays.
  final List<BoxShadow>? keyShadow;

  /// Creates a [KeyboardShortcutTheme].
  const KeyboardShortcutTheme({
    super.themeDensity,
    super.themeSpacing,
    super.themeShadows,
    this.spacing,
    this.keyPadding,
    this.keyShadow,
  });

  /// Creates a copy with the given values replaced.
  KeyboardShortcutTheme copyWith({
    ValueGetter<double?>? spacing,
    ValueGetter<EdgeInsetsGeometry?>? keyPadding,
    ValueGetter<List<BoxShadow>?>? keyShadow,
  }) {
    return KeyboardShortcutTheme(
      spacing: spacing == null ? this.spacing : spacing(),
      keyPadding: keyPadding == null ? this.keyPadding : keyPadding(),
      keyShadow: keyShadow == null ? this.keyShadow : keyShadow(),
    );
  }

  /// Compares two keyboard shortcut values for structural equality.
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is KeyboardShortcutTheme &&
        other.spacing == spacing &&
        other.keyPadding == keyPadding &&
        listEquals(other.keyShadow, keyShadow);
  }

  /// State flag that toggles specific keyboard shortcut behavior.
  @override
  int get hashCode => Object.hash(spacing, keyPadding, keyShadow);
}
