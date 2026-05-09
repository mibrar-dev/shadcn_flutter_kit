// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../../menu.dart';

/// MenubarTheme defines a reusable type for this registry module.
class MenubarTheme extends ComponentThemeData {
  /// Whether to draw a border around the menubar container.
  ///
  /// Type: `bool?`. If null, uses the widget's border property. When true,
  /// the menubar is wrapped with an outlined container with customizable
  /// border color and radius.
  final bool? border;

  /// Positioning offset for submenu popovers when menu items are opened.
  ///
  /// Type: `Offset?`. If null, uses calculated defaults based on border
  /// presence. Controls where submenus appear relative to their parent items.
  final Offset? subMenuOffset;

  /// Internal padding within the menubar container.
  ///
  /// Type: `EdgeInsetsGeometry?`. If null, uses 4 logical pixels on all sides
  /// scaled by theme scaling. Applied inside the border when present.
  final EdgeInsetsGeometry? padding;

  /// Color of the border when [border] is enabled.
  ///
  /// Type: `Color?`. If null, uses the theme's border color. Only visible
  /// when [border] is true.
  final Color? borderColor;

  /// Background color of the menubar container.
  ///
  /// Type: `Color?`. If null, uses the theme's background color. Applied
  /// to the menubar's container element.
  final Color? backgroundColor;

  /// Border radius for the menubar container corners.
  ///
  /// Type: `BorderRadiusGeometry?`. If null, uses the theme's medium border
  /// radius. Only visible when [border] is true.
  final BorderRadiusGeometry? borderRadius;

  /// Creates a [MenubarTheme].
  const MenubarTheme({
    super.themeDensity,
    super.themeSpacing,
    super.themeShadows,
    this.border,
    this.subMenuOffset,
    this.padding,
    this.borderColor,
    this.backgroundColor,
    this.borderRadius,
  });

  /// Returns a copy of this theme with the given fields replaced.
  MenubarTheme copyWith({
    ValueGetter<bool?>? border,
    ValueGetter<Offset?>? subMenuOffset,
    ValueGetter<EdgeInsetsGeometry?>? padding,
    ValueGetter<Color?>? borderColor,
    ValueGetter<Color?>? backgroundColor,
    ValueGetter<BorderRadiusGeometry?>? borderRadius,
  }) {
    return MenubarTheme(
      border: border == null ? this.border : border(),
      subMenuOffset: subMenuOffset == null
          ? this.subMenuOffset
          : subMenuOffset(),
      padding: padding == null ? this.padding : padding(),
      borderColor: borderColor == null ? this.borderColor : borderColor(),
      backgroundColor: backgroundColor == null
          ? this.backgroundColor
          : backgroundColor(),
      borderRadius: borderRadius == null ? this.borderRadius : borderRadius(),
    );
  }

  @override
  /// Executes `operator ==` behavior for this component/composite.
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MenubarTheme &&
        other.border == border &&
        other.subMenuOffset == subMenuOffset &&
        other.padding == padding &&
        other.borderColor == borderColor &&
        other.backgroundColor == backgroundColor &&
        other.borderRadius == borderRadius;
  }

  @override
  int get hashCode => Object.hash(
    border,
    subMenuOffset,
    padding,
    borderColor,
    backgroundColor,
    borderRadius,
  );
}

/// A horizontal menubar widget for displaying application menus and menu items.
///
/// Menubar provides a classic application-style menu interface with horizontal
/// layout and dropdown submenu support. It organizes menu items in a row format
/// similar to traditional desktop application menubars, with each item capable
/// of revealing dropdown menus when activated.
///
/// The menubar supports hierarchical menu structures through MenuItem widgets
/// that can contain nested menu items. It handles focus management, keyboard
/// navigation, and proper popover positioning for submenu display.
///
/// Features:
/// - Horizontal layout of top-level menu items
/// - Dropdown submenu support with configurable positioning
/// - Optional border and styling customization
/// - Keyboard navigation and accessibility support
/// - Focus region management for proper menu behavior
/// - Automatic sizing and layout adaptation
/// - Theme-aware styling with comprehensive customization options
///
/// The widget integrates with the MenuGroup system to provide consistent
/// menu behavior across different contexts and supports both bordered and
/// borderless display modes.
///
/// Example:
/// ```dart
/// Menubar(
///   border: true,
///   children: [
///     MenuItem(
///       title: Text('File'),
///       children: [
///         MenuItem(
///           title: Text('New'),
///           onPressed: () => createNewFile(),
///         ),
///         MenuItem(
///           title: Text('Open'),
///           onPressed: () => openFile(),
///         ),
///         MenuDivider(),
///         MenuItem(
///           title: Text('Exit'),
///           onPressed: () => exitApp(),
///         ),
///       ],
///     ),
///     MenuItem(
///       title: Text('Edit'),
///       children: [
///         MenuItem(title: Text('Cut')),
///         MenuItem(title: Text('Copy')),
///         MenuItem(title: Text('Paste')),
///       ],
///     ),
///   ],
/// )
/// ```
