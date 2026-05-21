// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../../menu.dart';

/// MenuPopupTheme defines a reusable type for this registry module.
class MenuPopupTheme extends ComponentThemeData {
  /// The opacity of the surface.
  final double? surfaceOpacity;

  /// The blur applied to the surface.
  final double? surfaceBlur;

  /// The padding inside the popup.
  final EdgeInsetsGeometry? padding;

  /// The background color of the popup.
  final Color? fillColor;

  /// The border color of the popup.
  final Color? borderColor;

  /// The border radius of the popup.
  final BorderRadiusGeometry? borderRadius;

  /// Creates a [MenuPopupTheme].
  const MenuPopupTheme({
    super.themeDensity,
    super.themeSpacing,
    super.themeShadows,
    this.surfaceOpacity,
    this.surfaceBlur,
    this.padding,
    this.fillColor,
    this.borderColor,
    this.borderRadius,
  });

  /// Returns a copy of this theme with the given fields replaced.
  MenuPopupTheme copyWith({
    ValueGetter<double?>? surfaceOpacity,
    ValueGetter<double?>? surfaceBlur,
    ValueGetter<EdgeInsetsGeometry?>? padding,
    ValueGetter<Color?>? fillColor,
    ValueGetter<Color?>? borderColor,
    ValueGetter<BorderRadiusGeometry?>? borderRadius,
  }) {
    return MenuPopupTheme(
      surfaceOpacity: surfaceOpacity == null
          ? this.surfaceOpacity
          : surfaceOpacity(),
      surfaceBlur: surfaceBlur == null ? this.surfaceBlur : surfaceBlur(),
      padding: padding == null ? this.padding : padding(),
      fillColor: fillColor == null ? this.fillColor : fillColor(),
      borderColor: borderColor == null ? this.borderColor : borderColor(),
      borderRadius: borderRadius == null ? this.borderRadius : borderRadius(),
    );
  }

  @override
  /// Executes `operator ==` behavior for this component/composite.
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MenuPopupTheme &&
        other.surfaceOpacity == surfaceOpacity &&
        other.surfaceBlur == surfaceBlur &&
        other.padding == padding &&
        other.fillColor == fillColor &&
        other.borderColor == borderColor &&
        other.borderRadius == borderRadius;
  }

  @override
  int get hashCode => Object.hash(
    surfaceOpacity,
    surfaceBlur,
    padding,
    fillColor,
    borderColor,
    borderRadius,
  );
}

/// A styled container widget for displaying popup menus.
///
/// Provides a consistent visual container for menu items with customizable
/// appearance including background, borders, padding, and surface effects.
/// Automatically adapts its layout based on context (sheet overlay, dialog, etc.).
///
/// Features:
/// - **Surface Effects**: Configurable opacity and blur for backdrop
/// - **Styled Border**: Custom border color and radius
/// - **Flexible Layout**: Automatically adjusts for vertical/horizontal menus
/// - **Scrollable**: Content scrolls when it exceeds available space
/// - **Themeable**: Integrates with component theming system
///
/// Typically used as a container for menu items within dropdown menus,
/// context menus, or other popup menu components.
///
/// Example:
/// ```dart
/// MenuPopup(
///   padding: EdgeInsets.all(8),
///   fillColor: Colors.white,
///   borderRadius: BorderRadius.circular(8),
///   children: [
///     MenuItem(title: Text('Option 1')),
///     MenuItem(title: Text('Option 2')),
///     MenuItem(title: Text('Option 3')),
///   ],
/// )
/// ```
///
/// See also:
/// - [MenuPopupTheme] for theming options
/// - [MenuItem] for individual menu items
/// - [DropdownMenu] for complete dropdown menu implementation
