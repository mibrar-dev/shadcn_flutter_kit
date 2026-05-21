// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../../menu.dart';

/// MenuTheme defines a reusable type for this registry module.
class MenuTheme extends ComponentThemeData {
  /// Default padding applied to each menu item.
  final EdgeInsets? itemPadding;

  /// Offset applied when showing a submenu.
  final Offset? subMenuOffset;

  /// {@macro menu_theme}
  const MenuTheme({
    super.themeDensity,
    super.themeSpacing,
    super.themeShadows,
    this.itemPadding,
    this.subMenuOffset,
  });

  /// Creates a copy of this theme but with the given fields replaced.
  MenuTheme copyWith({
    ValueGetter<EdgeInsets?>? itemPadding,
    ValueGetter<Offset?>? subMenuOffset,
  }) {
    return MenuTheme(
      itemPadding: itemPadding == null ? this.itemPadding : itemPadding(),
      subMenuOffset: subMenuOffset == null
          ? this.subMenuOffset
          : subMenuOffset(),
    );
  }

  @override
  int get hashCode => Object.hash(itemPadding, subMenuOffset);

  @override
  /// Executes `operator ==` behavior for this component/composite.
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MenuTheme &&
        other.itemPadding == itemPadding &&
        other.subMenuOffset == subMenuOffset;
  }

  @override
  /// Executes `toString` behavior for this component/composite.
  String toString() {
    return 'MenuTheme(itemPadding: $itemPadding, subMenuOffset: $subMenuOffset)';
  }
}

/// Displays a keyboard shortcut in a menu.
///
/// Renders the visual representation of a keyboard shortcut, typically
/// displayed on the right side of menu items.
///
/// Example:
/// ```dart
/// MenuShortcut(
///   activator: SingleActivator(LogicalKeyboardKey.keyS, control: true),
/// )
/// ```
