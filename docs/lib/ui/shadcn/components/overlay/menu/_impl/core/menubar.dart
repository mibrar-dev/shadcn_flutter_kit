// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../menu.dart';

/// Theme configuration for [Menubar] appearance and layout.
///
/// MenubarTheme defines the visual styling for menubar components including
/// borders, colors, positioning, and spacing. All properties are optional
/// and fall back to theme defaults when not specified.
///
/// The theme controls both the menubar container appearance and the behavior
/// of submenu positioning when menu items are opened.
///
/// Example:
/// ```dart
/// ComponentTheme<MenubarTheme>(
///   data: MenubarTheme(
///     border: true,
///     backgroundColor: Colors.white,
///     borderColor: Colors.grey,
///     borderRadius: BorderRadius.circular(8),
///     padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
///     subMenuOffset: Offset(0, 8),
///   ),
///   child: Menubar(...),
/// )
/// ```
/// Theme for [Menubar].

/// Menubar defines a reusable type for this registry module.
class Menubar extends StatefulWidget {
  /// List of menu items to display in the menubar.
  ///
  /// Type: `List<MenuItem>`. Each MenuItem represents a top-level menu that
  /// can contain nested menu items for dropdown functionality. Items are
  /// displayed horizontally in the order provided.
  final List<MenuItem> children;

  /// Positioning offset for submenu popovers when items are opened.
  ///
  /// Type: `Offset?`. If null, uses theme defaults or calculated values based
  /// on border presence. Controls where dropdown menus appear relative to
  /// their parent menu items.
  final Offset? popoverOffset;

  /// Whether to draw a border around the menubar container.
  ///
  /// Type: `bool`, default: `true`. When true, the menubar is wrapped with
  /// an outlined container using theme colors and border radius.
  final bool border;

  /// Creates a [Menubar] with horizontal menu layout.
  ///
  /// Configures a horizontal menubar that displays menu items and supports
  /// dropdown submenus with customizable styling and positioning.
  ///
  /// Parameters:
  /// - [key] (Key?): Widget identifier for the widget tree
  /// - [children] (`List<MenuItem>`, required): Menu items to display horizontally
  /// - [popoverOffset] (Offset?, optional): Positioning offset for dropdown menus
  /// - [border] (bool, default: true): Whether to show a border around the menubar
  ///
  /// Example:
  /// ```dart
  /// Menubar(
  ///   border: true,
  ///   popoverOffset: Offset(0, 8),
  ///   children: [
  ///     MenuItem(
  ///       title: Text('View'),
  ///       children: [
  ///         MenuItem(title: Text('Zoom In')),
  ///         MenuItem(title: Text('Zoom Out')),
  ///         MenuDivider(),
  ///         MenuItem(title: Text('Full Screen')),
  ///       ],
  ///     ),
  ///     MenuItem(
  ///       title: Text('Tools'),
  ///       children: [
  ///         MenuItem(title: Text('Preferences')),
  ///         MenuItem(title: Text('Extensions')),
  ///       ],
  ///     ),
  ///   ],
  /// )
  /// ```
  const Menubar({
    super.key,
    this.popoverOffset,
    this.border = true,
    required this.children,
  });

  @override
  /// Executes `createState` behavior for this component/composite.
  State<Menubar> createState() => MenubarState();
}

/// State class for [Menubar] widget.
///
/// Manages the rendering and theming of the menubar container.
